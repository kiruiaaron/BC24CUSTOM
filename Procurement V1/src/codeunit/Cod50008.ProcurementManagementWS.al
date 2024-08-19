codeunit 50008 "Procurement Management WS"
{

    trigger OnRun()
    begin
    end;

    var
        PurchaseRequisition: Record 50046;
        PurchaseRequisitionLine: Record 50047;
        "Purchases&PayablesSetup": Record 312;
        Employee: Record 5200;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApprovalsMgmtExt: Codeunit "Approval Mgt.Procurement Ext";
        ApprovalsMgmt: Codeunit 1535;
        ProcurementApprovalManager: Codeunit 50009;
        Text0001: Label 'You Have exceeded the Budget by ';
        Text0002: Label 'Do you want to Continue?';
        Text0003: Label 'There is no Budget to Check against do you wish to continue?';
        Text0004: Label 'The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3';
        Text0005: Label 'The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3';
        Text0006: Label 'No Budget To Check Against';
        Text0007: Label 'Item Does not Exist';
        Text0008: Label 'Ensure Fixed Asset No %1 has the Maintenance G/L Account';
        Text0009: Label 'Ensure Fixed Asset No %1 has the Acquisition G/L Account';
        Text0010: Label 'No Budget To Check Against';
        Text0011: Label 'The Amount On Purchase Requisition No %1  %2 %3  Exceeds The Budget By %4';
        PurchaseRequisitions2: Record 50046;
        ApprovalEntry: Record 454;

    /*  
     procedure GetItemList(var ItemExport: XMLport 50018)
     begin
     end;

     
     procedure GetPurchaseRequisitionList(var PurchaseRequisitionExport: XMLport 50020; EmployeeNo: Code[20])
     begin
         IF EmployeeNo <> '' THEN BEGIN
             PurchaseRequisitions2.RESET;
             PurchaseRequisitions2.SETFILTER("Employee No.", EmployeeNo);
             IF PurchaseRequisitions2.FINDFIRST THEN;
             PurchaseRequisitionExport.SETTABLEVIEW(PurchaseRequisitions2);
         END
     end;

     
     procedure GetPurchaseRequisitionHeaderLines(var PurchaseRequisitionExport: XMLport 50020; HeaderNo: Code[20])
     begin
         IF HeaderNo <> '' THEN BEGIN
             PurchaseRequisitions2.RESET;
             PurchaseRequisitions2.SETFILTER("No.", HeaderNo);
             IF PurchaseRequisitions2.FINDFIRST THEN;
             PurchaseRequisitionExport.SETTABLEVIEW(PurchaseRequisitions2);
         END
     end;

     
     procedure GetPurchaseRequisitionListStatus(var PurchaseRequisitionExport: XMLport 50020; EmployeeNo: Code[20]; PRQStatus: Option Open,"Pending Approval",Approved,Rejected,Closed)
     begin

         PurchaseRequisitions2.RESET;
         PurchaseRequisitions2.SETRANGE(Status, PRQStatus);
         IF EmployeeNo <> '' THEN BEGIN
             PurchaseRequisitions2.SETFILTER("Employee No.", EmployeeNo);
             IF PurchaseRequisitions2.FINDFIRST THEN;
             PurchaseRequisitionExport.SETTABLEVIEW(PurchaseRequisitions2);
         END
     end;

     
     procedure GetFixedAssetList(var FixedAssetExport: XMLport "50022")
     begin
     end;

     
     procedure GetServicecodes(var PurchaseReqCodesExport: XMLport 50019)
     begin
     end; */


    procedure CheckPurchaseRequisitionExists("PurchaseRequisitionNo.": Code[20]; "EmployeeNo.": Code[20]) PurchaseRequisitionExist: Boolean
    begin
        PurchaseRequisitionExist := FALSE;
        PurchaseRequisition.RESET;
        PurchaseRequisition.SETRANGE(PurchaseRequisition."No.", "PurchaseRequisitionNo.");
        PurchaseRequisition.SETRANGE(PurchaseRequisition."Employee No.", "EmployeeNo.");
        IF PurchaseRequisition.FINDFIRST THEN BEGIN
            PurchaseRequisitionExist := TRUE;
        END;
    end;


    procedure CheckOpenPurchaseRequisitionExists("EmployeeNo.": Code[20]) OpenPurchaseRequisitionExist: Boolean
    begin
        OpenPurchaseRequisitionExist := FALSE;
        PurchaseRequisition.RESET;
        PurchaseRequisition.SETRANGE(PurchaseRequisition."Employee No.", "EmployeeNo.");
        PurchaseRequisition.SETFILTER(PurchaseRequisition.Status, '=%1|%2', 0, 1);
        IF PurchaseRequisition.FINDFIRST THEN BEGIN
            OpenPurchaseRequisitionExist := TRUE;
        END;
    end;


    procedure CreatePurchaseRequisition("EmployeeNo.": Code[20]; RequestedReceiptDate: Date; Description: Text[100]; Department: Code[20]) ReturnValue: Text
    var
        "DocNo.": Code[20];
        HREmployee: Record 5200;
        PurchaseRequisition2: Record 50046;
        ProcurementPortalDocuments: Record 50067;
    begin
        ReturnValue := '';

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        "Purchases&PayablesSetup".RESET;
        "Purchases&PayablesSetup".GET;

        "DocNo." := NoSeriesMgt.GetNextNo("Purchases&PayablesSetup"."Purchase Requisition Nos.", 0D, TRUE);
        IF "DocNo." <> '' THEN BEGIN
            PurchaseRequisition.INIT;
            PurchaseRequisition."No." := "DocNo.";
            PurchaseRequisition."Document Date" := TODAY;
            PurchaseRequisition."Employee No." := "EmployeeNo.";
            PurchaseRequisition.VALIDATE(PurchaseRequisition."Employee No.");
            PurchaseRequisition."User ID" := Employee."User ID";
            PurchaseRequisition.Description := Description;
            HREmployee.RESET;
            HREmployee.SETRANGE(HREmployee."No.", "EmployeeNo.");
            IF HREmployee.FINDFIRST THEN BEGIN
                PurchaseRequisition."Global Dimension 1 Code" := HREmployee."Global Dimension 1 Code";
                PurchaseRequisition."Global Dimension 2 Code" := Department;//HREmployee."Global Dimension 2 Code";
                PurchaseRequisition."Shortcut Dimension 3 Code" := HREmployee."Shortcut Dimension 3 Code";
                PurchaseRequisition."Shortcut Dimension 4 Code" := HREmployee."Shortcut Dimension 4 Code";
            END;
            IF PurchaseRequisition.INSERT THEN BEGIN
                ReturnValue := '200: Procurement Requistion No ' + "DocNo." + ' Successfully Created';
            END
            ELSE
                ReturnValue := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;

            /*
            IF PurchaseRequisition.INSERT THEN BEGIN
             //Insert procurement upload documents
              PurchaseRequisition2.RESET;
              PurchaseRequisition2.SETRANGE(PurchaseRequisition2."Employee No.","EmployeeNo.");
              PurchaseRequisition2.SETRANGE(PurchaseRequisition2.Status,PurchaseRequisition2.Status::Open);
              IF PurchaseRequisition2.FINDFIRST THEN BEGIN
                REPEAT
                  ProcurementPortalDocuments.INIT;
                  ProcurementPortalDocuments."DocumentNo.":=PurchaseRequisition."No.";
                  ProcurementPortalDocuments."Document Code":=UPPERCASE('Requisition Document');
                  ProcurementPortalDocuments."Document Description":=UPPERCASE('Detailed Document');
                  ProcurementPortalDocuments."Document Attached":=FALSE;
                  ProcurementPortalDocuments.INSERT;
                UNTIL ProcurementPortalDocuments.NEXT=0;
              "PurchaseRequisitionNo.":="DocNo.";
              END;
             END;
             */
        END;

    end;


    procedure ModifyPurchaseRequisition("PurchaseRequisitionNo.": Code[20]; "EmployeeNo.": Code[20]; RequestedReceiptDate: Date; Description: Text[100]; Department: Code[20]; DocumentName: Text) PurchaseRequisitionModified: Boolean
    var
        HREmployee: Record 5200;
    begin
        //Check requisition document is attached
        //CheckProcurementUploadedDocumentAttached("PurchaseRequisitionNo.");
        PurchaseRequisitionModified := FALSE;
        PurchaseRequisition.RESET;
        PurchaseRequisition.SETRANGE(PurchaseRequisition."No.", "PurchaseRequisitionNo.");
        IF PurchaseRequisition.FINDFIRST THEN BEGIN
            PurchaseRequisition."Requested Receipt Date" := RequestedReceiptDate;
            PurchaseRequisition.VALIDATE(PurchaseRequisition."Currency Code");
            PurchaseRequisition.Description := Description;
            PurchaseRequisition."Document Name" := DocumentName;
            HREmployee.RESET;
            HREmployee.SETRANGE(HREmployee."No.", "EmployeeNo.");
            IF HREmployee.FINDFIRST THEN BEGIN
                PurchaseRequisition."Global Dimension 1 Code" := HREmployee."Global Dimension 1 Code";
                PurchaseRequisition."Global Dimension 2 Code" := Department;//HREmployee."Global Dimension 2 Code";
                PurchaseRequisition."Shortcut Dimension 3 Code" := HREmployee."Shortcut Dimension 3 Code";
                PurchaseRequisition."Shortcut Dimension 4 Code" := HREmployee."Shortcut Dimension 4 Code";
            END;
            IF PurchaseRequisition.MODIFY THEN
                PurchaseRequisitionModified := TRUE;
        END;
    end;


    procedure GetPurchaseRequisitionAmount("PurchaseRequisitionNo.": Code[20]) PurchaseRequisitionAmount: Decimal
    begin
        PurchaseRequisitionAmount := 0;

        PurchaseRequisition.RESET;
        IF PurchaseRequisition.GET("PurchaseRequisitionNo.") THEN BEGIN
            PurchaseRequisition.CALCFIELDS(Amount);
            PurchaseRequisitionAmount := PurchaseRequisition.Amount;
        END;
    end;


    procedure GetPurchaseRequisitionStatus("PurchaseRequisitionNo.": Code[20]) PurchaseRequisitionStatus: Text
    begin
        PurchaseRequisitionStatus := '';

        PurchaseRequisition.RESET;
        IF PurchaseRequisition.GET("PurchaseRequisitionNo.") THEN BEGIN
            PurchaseRequisitionStatus := FORMAT(PurchaseRequisition.Status);
        END;
    end;


    procedure GetPurchaseRequisitionGlobalDimension1Code("PurchaseRequisitionNo.": Code[20]) GlobalDimension1Code: Text
    begin
        GlobalDimension1Code := '';

        PurchaseRequisition.RESET;
        IF PurchaseRequisition.GET("PurchaseRequisitionNo.") THEN BEGIN
            GlobalDimension1Code := PurchaseRequisition."Global Dimension 1 Code";
        END;
    end;


    procedure GetPurchaseRequisitionGlobalDimension2Code("PurchaseRequisitionNo.": Code[20]) GlobalDimension2Code: Text
    begin
        GlobalDimension2Code := '';

        PurchaseRequisition.RESET;
        IF PurchaseRequisition.GET("PurchaseRequisitionNo.") THEN BEGIN
            GlobalDimension2Code := PurchaseRequisition."Global Dimension 2 Code";
        END;
    end;


    procedure CreatePurchaseRequisitionLine("PurchaseRequisitionNo.": Code[20]; RequisitionType: Code[20]; RequisitionCode: Code[50]; Quantity: Decimal; UnitCost: Decimal; Description: Text) PurchaseRequisitionLineCreated: Boolean
    var
        StockItem: Record 27;
        HREmployee: Record 5200;
    begin
        PurchaseRequisitionLineCreated := FALSE;

        PurchaseRequisition.RESET;
        PurchaseRequisition.GET("PurchaseRequisitionNo.");

        PurchaseRequisitionLine.INIT;
        PurchaseRequisitionLine."Line No." := 0;
        PurchaseRequisitionLine."Document No." := "PurchaseRequisitionNo.";
        IF RequisitionType = UPPERCASE(FORMAT(PurchaseRequisitionLine."Requisition Type"::Service)) THEN
            PurchaseRequisitionLine."Requisition Type" := PurchaseRequisitionLine."Requisition Type"::Service;
        IF RequisitionType = UPPERCASE(FORMAT(PurchaseRequisitionLine."Requisition Type"::Item)) THEN
            PurchaseRequisitionLine."Requisition Type" := PurchaseRequisitionLine."Requisition Type"::Item;
        IF RequisitionType = UPPERCASE(FORMAT(PurchaseRequisitionLine."Requisition Type"::"Fixed Asset")) THEN
            PurchaseRequisitionLine."Requisition Type" := PurchaseRequisitionLine."Requisition Type"::"Fixed Asset";
        PurchaseRequisitionLine."Requisition Code" := RequisitionCode;
        PurchaseRequisitionLine.VALIDATE(PurchaseRequisitionLine."Requisition Code");

        StockItem.RESET;
        StockItem.SETRANGE(StockItem."No.", RequisitionCode);
        IF StockItem.FINDFIRST THEN BEGIN
            PurchaseRequisitionLine."Location Code" := StockItem."Location Code";
            PurchaseRequisitionLine.VALIDATE(PurchaseRequisitionLine."Location Code");
        END;

        PurchaseRequisitionLine.Quantity := Quantity;
        PurchaseRequisitionLine.VALIDATE(PurchaseRequisitionLine.Quantity);
        PurchaseRequisitionLine."Unit Cost" := UnitCost;
        PurchaseRequisitionLine.VALIDATE(PurchaseRequisitionLine."Unit Cost");
        PurchaseRequisitionLine.Description := Description;
        /*HREmployee.RESET;
        HREmployee.SETRANGE(HREmployee."No.","EmployeeNo.");
          IF HREmployee.FINDFIRST THEN BEGIN
            PurchaseRequisition."Global Dimension 1 Code":=HREmployee."Global Dimension 1 Code";
            PurchaseRequisition.VALIDATE(PurchaseRequisition."Global Dimension 1 Code");
            PurchaseRequisition."Global Dimension 2 Code":=HREmployee."Global Dimension 2 Code";
            PurchaseRequisition.VALIDATE(PurchaseRequisition."Global Dimension 2 Code");
        END;*/
        /*
      PurchaseRequisitionLine."Global Dimension 1 Code":=GlobalDimension1Code;
      PurchaseRequisitionLine."Global Dimension 2 Code":=GlobalDimension2Code;
      PurchaseRequisitionLine."Shortcut Dimension 3 Code":=ShortcutDimension3Code;
      PurchaseRequisitionLine."Shortcut Dimension 4 Code":=ShortcutDimension4Code;
      PurchaseRequisitionLine."Shortcut Dimension 5 Code":=ShortcutDimension5Code;
      PurchaseRequisitionLine."Shortcut Dimension 6 Code":=ShortcutDimension6Code;
      PurchaseRequisitionLine."Shortcut Dimension 7 Code":=ShortcutDimension7Code;
      PurchaseRequisitionLine."Shortcut Dimension 8 Code":=ShortcutDimension8Code;*/
        IF PurchaseRequisitionLine.INSERT THEN BEGIN
            PurchaseRequisitionLineCreated := TRUE;
        END;

    end;


    procedure ModifyPurchaseRequisitionLine("LineNo.": Integer; "PurchaseRequisitionNo.": Code[20]; RequisitionType: Code[20]; RequisitionCode: Code[50]; Quantity: Decimal; UnitCost: Decimal; Description: Text) PurchaseRequisitionLineModified: Boolean
    var
        StockItem: Record 27;
    begin
        PurchaseRequisitionLineModified := FALSE;

        PurchaseRequisitionLine.RESET;
        PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Line No.", "LineNo.");
        PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Document No.", "PurchaseRequisitionNo.");
        IF PurchaseRequisitionLine.FINDFIRST THEN BEGIN
            IF RequisitionType = UPPERCASE(FORMAT(PurchaseRequisitionLine."Requisition Type"::Service)) THEN
                PurchaseRequisitionLine."Requisition Type" := PurchaseRequisitionLine."Requisition Type"::Service;
            IF RequisitionType = UPPERCASE(FORMAT(PurchaseRequisitionLine."Requisition Type"::Item)) THEN
                PurchaseRequisitionLine."Requisition Type" := PurchaseRequisitionLine."Requisition Type"::Item;
            IF RequisitionType = UPPERCASE(FORMAT(PurchaseRequisitionLine."Requisition Type"::"Fixed Asset")) THEN
                PurchaseRequisitionLine."Requisition Type" := PurchaseRequisitionLine."Requisition Type"::"Fixed Asset";
            PurchaseRequisitionLine."Requisition Code" := RequisitionCode;
            // PurchaseRequisitionLine.VALIDATE(PurchaseRequisitionLine."Requisition Code");

            StockItem.RESET;
            StockItem.SETRANGE(StockItem."No.", RequisitionCode);
            IF StockItem.FINDFIRST THEN BEGIN
                PurchaseRequisitionLine."Location Code" := StockItem."Location Code";
                PurchaseRequisitionLine.VALIDATE(PurchaseRequisitionLine."Location Code");
            END;
            PurchaseRequisitionLine.Quantity := Quantity;
            PurchaseRequisitionLine.VALIDATE(PurchaseRequisitionLine.Quantity);
            PurchaseRequisitionLine."Unit Cost" := UnitCost;
            PurchaseRequisitionLine.VALIDATE(PurchaseRequisitionLine."Unit Cost");
            PurchaseRequisitionLine.Description := Description;
            /*PurchaseRequisitionLine."Global Dimension 1 Code":=GlobalDimension1Code;
            PurchaseRequisitionLine."Global Dimension 2 Code":=GlobalDimension2Code;
            PurchaseRequisitionLine."Shortcut Dimension 3 Code":=ShortcutDimension3Code;
            PurchaseRequisitionLine."Shortcut Dimension 4 Code":=ShortcutDimension4Code;
            PurchaseRequisitionLine."Shortcut Dimension 5 Code":=ShortcutDimension5Code;
            PurchaseRequisitionLine."Shortcut Dimension 6 Code":=ShortcutDimension6Code;
            PurchaseRequisitionLine."Shortcut Dimension 7 Code":=ShortcutDimension7Code;
            PurchaseRequisitionLine."Shortcut Dimension 8 Code":=ShortcutDimension8Code;*/
            IF PurchaseRequisitionLine.MODIFY THEN BEGIN
                PurchaseRequisitionLineModified := TRUE;
            END;
        END;

    end;


    procedure DeletePurchaseRequisitionLine("LineNo.": Integer; "PurchaseRequisitionNo.": Code[20]) PurchaseRequisitionLineDeleted: Boolean
    begin
        PurchaseRequisitionLineDeleted := FALSE;

        PurchaseRequisitionLine.RESET;
        PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Line No.", "LineNo.");
        PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Document No.", "PurchaseRequisitionNo.");
        IF PurchaseRequisitionLine.FINDFIRST THEN BEGIN
            IF PurchaseRequisitionLine.DELETE THEN BEGIN
                PurchaseRequisitionLineDeleted := TRUE;
            END;
        END;
    end;


    procedure CheckPurchaseRequisitionLinesExist("PurchaseRequisitionNo.": Code[20]) PurchaseRequisitionLinesExist: Boolean
    begin
        PurchaseRequisitionLinesExist := FALSE;

        PurchaseRequisitionLine.RESET;
        PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Document No.", "PurchaseRequisitionNo.");
        IF PurchaseRequisitionLine.FINDFIRST THEN BEGIN
            PurchaseRequisitionLinesExist := TRUE;
        END;
    end;


    procedure ValidatePurchaseRequisitionLines("PurchaseRequisitionNo.": Code[20]) PurchaseRequisitionLinesError: Text
    var
        "PurchaseRequisitionLineNo.": Integer;
    begin
        PurchaseRequisitionLinesError := '';
        "PurchaseRequisitionLineNo." := 0;

        PurchaseRequisitionLine.RESET;
        PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Document No.", "PurchaseRequisitionNo.");
        IF PurchaseRequisitionLine.FINDSET THEN BEGIN
            REPEAT
                "PurchaseRequisitionLineNo." := "PurchaseRequisitionLineNo." + 1;
                IF PurchaseRequisitionLine."Requisition Code" = '' THEN BEGIN
                    PurchaseRequisitionLinesError := 'Requisition code missing on purchase requisition line no.' + FORMAT("PurchaseRequisitionLineNo.") + ', it cannot be zero or empty';
                    BREAK;
                END;

            UNTIL PurchaseRequisitionLine.NEXT = 0;
        END;
    end;


    procedure CheckPurchaseRequisitionApprovalWorkflowEnabled("PurchaseRequisitionNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;

        PurchaseRequisition.RESET;
        IF PurchaseRequisition.GET("PurchaseRequisitionNo.") THEN
            ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckPurchaseRequisitionApprovalsWorkflowEnabled(PurchaseRequisition);
    end;


    procedure SendPurchaseRequisitionApprovalRequest("PurchaseRequisitionNo.": Code[20]) PurchaseRequisitionApprovalRequestSent: Text
    var
        ApprovalEntry: Record 454;
    begin
        PurchaseRequisitionApprovalRequestSent := '';

        PurchaseRequisition.RESET;
        IF PurchaseRequisition.GET("PurchaseRequisitionNo.") THEN BEGIN
            ApprovalsMgmtExt.OnSendPurchaseRequisitionForApproval(PurchaseRequisition);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", PurchaseRequisition."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);

            IF ApprovalEntry.FINDFIRST THEN
                PurchaseRequisitionApprovalRequestSent := '200: Purchase Requisition Approval Request sent Successfully '
            ELSE
                PurchaseRequisitionApprovalRequestSent := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;

        END;
    end;


    procedure CancelPurchaseRequisitionApprovalRequest("PurchaseRequisitionNo.": Code[20]) PurchaseRequisitionApprovalRequestCanceled: Text
    var
        ApprovalEntry: Record 454;
    begin
        PurchaseRequisitionApprovalRequestCanceled := '';

        PurchaseRequisition.RESET;
        IF PurchaseRequisition.GET("PurchaseRequisitionNo.") THEN BEGIN
            ApprovalsMgmtExt.OnCancelPurchaseRequisitionApprovalRequest(PurchaseRequisition);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", PurchaseRequisition."No.");
            IF ApprovalEntry.FINDLAST THEN BEGIN
                IF ApprovalEntry.Status = ApprovalEntry.Status::Canceled THEN
                    PurchaseRequisitionApprovalRequestCanceled := '200: Purchase Requisition Approval Request sent Successfully '
                ELSE
                    PurchaseRequisitionApprovalRequestCanceled := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
            END;
        END;
    end;

    procedure ReopenPurchaseRequisition("PurchaseRequisitionNo.": Code[20]) PurchaseRequisitionOpened: Boolean
    begin
        PurchaseRequisitionOpened := FALSE;
        PurchaseRequisition.RESET;
        PurchaseRequisition.SETRANGE(PurchaseRequisition."No.", "PurchaseRequisitionNo.");
        IF PurchaseRequisition.FINDFIRST THEN BEGIN
            //  ProcurementApprovalManager.ReOpenPurchaseRequisitionHeader(PurchaseRequisition);
            PurchaseRequisitionOpened := TRUE;
        END;
    end;

    procedure CheckBudgetPurchaseRequisition(PurchReqNo: Code[20]; DocumentDate: Date)
    var
        PurchLine: Record 50047;
        Commitments: Record 50019;
        Amount: Decimal;
        GLAccount: Record 15;
        Items: Record 27;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record 96;
        BudgetAmount: Decimal;
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssets: Record 5600;
        FAPostingGroup: Record 5606;
        EntryNo: Integer;
        BCSetup: Record 50018;
        BudgetGL: Code[20];
    begin
        /*BCSetup.GET;
        //check if the dates are within the specified range
        IF (DocumentDate< BCSetup."Current Budget Start Date") OR (DocumentDate> BCSetup."Current Budget End Date") THEN BEGIN
          ERROR(Text0004,DocumentDate,
          BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        END;
        
        CheckIfGLAccountBlocked(BCSetup."Current Budget Code");
        
        //get the lines related to the purchase requisition header
        PurchLine.RESET;
        PurchLine.SETRANGE(PurchLine."Document No.",PurchReqNo);
        IF PurchLine.FINDSET THEN BEGIN
          REPEAT
            //Items
            IF PurchLine."Requisition Type"=PurchLine."Requisition Type"::Item THEN BEGIN
              Items.RESET;
              IF NOT Items.GET(PurchLine."Requisition Code") THEN
              ERROR(Text0007);
              Items.TESTFIELD("Item G/L Budget Account");
              BudgetGL:=Items."Item G/L Budget Account";
            END;
        
            //Fixed Asset
            IF PurchLine."Requisition Type"=PurchLine."Requisition Type"::"Fixed Asset" THEN BEGIN
              FixedAssets.RESET;
              FixedAssets.SETRANGE(FixedAssets."No.",PurchLine."No.");
              IF FixedAssets.FINDFIRST THEN BEGIN
                FAPostingGroup.RESET;
                FAPostingGroup.SETRANGE(FAPostingGroup.Code,FixedAssets."FA Posting Group");
                IF FAPostingGroup.FINDFIRST THEN
                IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::Maintenance THEN BEGIN
                  BudgetGL:=FAPostingGroup."Maintenance Expense Account";
                  IF BudgetGL ='' THEN
                  ERROR(Text0008,PurchLine."No.");
                END ELSE BEGIN
                  BudgetGL:=FAPostingGroup."Acquisition Cost Account";
                  IF BudgetGL ='' THEN
                  ERROR(Text0009,PurchLine."No.");
                END;
              END;
            END;
        
           //G/L Account
            IF PurchLine."Requisition Type"=PurchLine."Requisition Type"::Service THEN BEGIN
              BudgetGL:=PurchLine."No.";
              IF GLAccount.GET(PurchLine."No.") THEN
              GLAccount.TESTFIELD(GLAccount."Budget Controlled",TRUE);
            END;
        
            //check the votebook now
            FirstDay:=DMY2DATE(1,DATE2DMY(DocumentDate,2),DATE2DMY(DocumentDate,3));
            CurrMonth:=DATE2DMY(DocumentDate,2);
            IF CurrMonth=12 THEN BEGIN
              LastDay:=DMY2DATE(1,1,DATE2DMY(DocumentDate,3) +1);
              LastDay:=CALCDATE('-1D',LastDay);
            END ELSE BEGIN
              CurrMonth:=CurrMonth +1;
              LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(DocumentDate,3));
              LastDay:=CALCDATE('-1D',LastDay);
            END;
        
            //check the summation of the budget
            BudgetAmount:=0;
            Budget.RESET;
            Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
            Budget.SETFILTER(Budget.Date,'%1..%2',BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
            Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
            {Budget.SETRANGE(Budget."Global Dimension 1 Code",PurchLine."Global Dimension 1 Code");
            Budget.SETRANGE(Budget."Global Dimension 2 Code",PurchLine."Global Dimension 2 Code");
            IF PurchLine."Shortcut Dimension 3 Code" <> '' THEN
             Budget.SETRANGE(Budget."Budget Dimension 3 Code",PurchLine."Shortcut Dimension 3 Code");
            IF PurchLine."Shortcut Dimension 4 Code" <> '' THEN
             Budget.SETRANGE(Budget."Budget Dimension 4 Code",PurchLine."Shortcut Dimension 4 Code");}
            IF Budget.FINDSET THEN BEGIN
             Budget.CALCSUMS(Amount);
             BudgetAmount:=Budget.Amount;
            END;
        
            //get the committments
            CommitmentAmount:=0;
            Commitments.RESET;
            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PurchLine."Global Dimension 1 Code");
            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PurchLine."Global Dimension 2 Code");
            IF PurchLine."Shortcut Dimension 3 Code" <> '' THEN
             Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PurchLine."Shortcut Dimension 3 Code");
            IF PurchLine."Shortcut Dimension 4 Code" <> '' THEN
             Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PurchLine."Shortcut Dimension 4 Code");
            Commitments.CALCSUMS(Commitments.Amount);
            CommitmentAmount:= Commitments.Amount;
        
            //check if there is any budget
            IF (BudgetAmount<=0) THEN
             ERROR(Text0010);
        
            //check if the actuals plus the amount is greater then the budget amount
            IF ((CommitmentAmount + PurchLine."Total Cost(LCY)") > BudgetAmount) AND (BCSetup."Allow OverExpenditure"=FALSE) THEN BEGIN
              ERROR(Text0011,
              PurchLine."Document No.",PurchLine.Type ,PurchLine."No.",
              FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Total Cost"))));
            END ELSE BEGIN
            //commit Amounts
            Commitments.INIT;
            Commitments."Line No.":=0;
            Commitments.Date:=TODAY;
            Commitments."Posting Date":=DocumentDate;
            Commitments."Document Type":=Commitments."Document Type"::Requisition;
            Commitments."Document No.":=PurchReqNo;
            Commitments.Amount:=PurchLine."Total Cost(LCY)";
            Commitments."Month Budget":=BudgetAmount;
            Commitments.Committed:=TRUE;
            Commitments."Committed By":=USERID;
            Commitments."Committed Date":=DocumentDate;
            Commitments."G/L Account No.":=BudgetGL;
            Commitments."Committed Time":=TIME;
            Commitments."Shortcut Dimension 1 Code":=PurchLine."Global Dimension 1 Code";
            Commitments."Shortcut Dimension 2 Code":=PurchLine."Global Dimension 2 Code";
            Commitments."Shortcut Dimension 3 Code":=PurchLine."Shortcut Dimension 3 Code";
            Commitments."Shortcut Dimension 4 Code":=PurchLine."Shortcut Dimension 4 Code";
            Commitments.Budget:=BCSetup."Current Budget Code";
            Commitments.Type:=Commitments.Type::Vendor;
            Commitments.Committed:=TRUE;
            IF Commitments.INSERT THEN BEGIN
              PurchLine.Committed:=TRUE;
              PurchLine.MODIFY;
             END;
            END;
          UNTIL PurchLine.NEXT=0;
        END;*/

    end;

    procedure CancelBudgetCommitmentPurchaseRequisition(PurchReqNo: Code[20])
    var
        Commitments: Record 50019;
        EntryNo: Integer;
        PurchLine: Record 50047;
        BudgetAmount: Decimal;
        Items: Record 27;
        FixedAsset: Record 5600;
        FAPostingGroup: Record 5606;
        BudgetGL: Code[20];
        BCSetup: Record 50018;
    begin
        CLEAR(BudgetAmount);
        BudgetGL := '';
        BCSetup.GET();
        PurchLine.RESET;
        PurchLine.SETRANGE("Document No.", PurchReqNo);
        PurchLine.SETRANGE(Committed, TRUE);
        IF PurchLine.FINDSET THEN BEGIN
            IF PurchLine.Type = PurchLine.Type::Item THEN
                IF Items.GET(PurchLine."No.") THEN
                    BudgetGL := Items."Item G/L Budget Account"
                ELSE
                    IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN
                        IF FixedAsset.GET(PurchLine."No.") THEN
                            FAPostingGroup.RESET;
            FAPostingGroup.SETRANGE(Code, FixedAsset."FA Posting Group");
            IF FAPostingGroup.FINDFIRST THEN
                BudgetGL := FAPostingGroup."Acquisition Cost Account"
            ELSE
                IF PurchLine.Type = PurchLine.Type::"G/L Account" THEN
                    BudgetGL := PurchLine."No.";

            REPEAT
                BudgetAmount := PurchLine.Quantity * PurchLine."Unit Cost";
                Commitments.RESET;
                Commitments.INIT;
                Commitments."Line No." := 0;
                Commitments.Date := TODAY;
                Commitments."Posting Date" := TODAY;
                Commitments."Document Type" := Commitments."Document Type"::Requisition;
                Commitments."Document No." := PurchReqNo;
                Commitments.Amount := -BudgetAmount;
                Commitments.Committed := TRUE;
                Commitments."Committed By" := USERID;
                Commitments."Committed Date" := TODAY;
                Commitments."G/L Account No." := BudgetGL;
                Commitments."Committed Time" := TIME;
                Commitments."Shortcut Dimension 1 Code" := PurchLine."Global Dimension 1 Code";
                Commitments."Shortcut Dimension 2 Code" := PurchLine."Global Dimension 2 Code";
                Commitments."Shortcut Dimension 3 Code" := PurchLine."Shortcut Dimension 3 Code";
                Commitments."Shortcut Dimension 4 Code" := PurchLine."Shortcut Dimension 4 Code";
                Commitments.Committed := TRUE;
                Commitments.Budget := BCSetup."Current Budget Code";
                IF Commitments.INSERT THEN BEGIN
                    PurchLine.Committed := FALSE;
                    PurchLine.MODIFY;
                END;
            UNTIL PurchLine.NEXT = 0;
        END;
    end;

    procedure CheckIfGLAccountBlocked(BudgetName: Code[20])
    var
        GLBudgetName: Record 95;
    begin
        GLBudgetName.GET(BudgetName);
        GLBudgetName.TESTFIELD(Blocked, FALSE);
    end;

    procedure ModifyProcurementUploadedDocumentLocalURL("DocumentNo.": Code[20]; DocumentCode: Code[50]; LocalURL: Text[250]) UploadedDocumentModified: Boolean
    var
        ProcurementPortalDocuments: Record 50067;
    begin
        UploadedDocumentModified := FALSE;
        ProcurementPortalDocuments.RESET;
        ProcurementPortalDocuments.SETRANGE(ProcurementPortalDocuments."DocumentNo.", "DocumentNo.");
        ProcurementPortalDocuments.SETRANGE(ProcurementPortalDocuments."Document Code", DocumentCode);
        IF ProcurementPortalDocuments.FINDFIRST THEN BEGIN
            ProcurementPortalDocuments."Local File URL" := LocalURL;
            ProcurementPortalDocuments."Document Attached" := TRUE;
            IF ProcurementPortalDocuments.MODIFY THEN
                UploadedDocumentModified := TRUE;
        END;
    end;

    procedure CheckProcurementUploadedDocumentAttached("DocumentNo.": Code[20]) UploadedDocumentAttached: Boolean
    var
        ProcurementPortalDocuments: Record 50067;
        Error0001: Label '%1 must be attached.';
    begin
        UploadedDocumentAttached := FALSE;
        ProcurementPortalDocuments.RESET;
        ProcurementPortalDocuments.SETRANGE(ProcurementPortalDocuments."DocumentNo.", "DocumentNo.");
        IF ProcurementPortalDocuments.FINDSET THEN BEGIN
            REPEAT
                IF ProcurementPortalDocuments."Local File URL" = '' THEN
                    ERROR(Error0001, ProcurementPortalDocuments."Document Description");
            UNTIL ProcurementPortalDocuments.NEXT = 0;
            UploadedDocumentAttached := TRUE;
        END;
    end;

    procedure DeleteProcurementUploadedDocument("DocumentNo.": Code[20]) UploadedDocumentDeleted: Boolean
    var
        ProcurementPortalDocuments: Record 50067;
    begin
        UploadedDocumentDeleted := FALSE;
        ProcurementPortalDocuments.RESET;
        ProcurementPortalDocuments.SETRANGE(ProcurementPortalDocuments."DocumentNo.", "DocumentNo.");
        IF ProcurementPortalDocuments.FINDSET THEN BEGIN
            ProcurementPortalDocuments.DELETEALL;
            UploadedDocumentDeleted := TRUE;
        END;
    end;


    procedure ApprovePurchaseReqApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]) Approved: Text
    var
        "EntryNo.": Integer;
    begin
        Approved := '';
        "EntryNo." := 0;

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", Employee."User ID");
        ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            "EntryNo." := ApprovalEntry."Entry No.";
            ApprovalEntry."Web Portal Approval" := TRUE;
            ApprovalEntry.MODIFY;
            //ApprovalsMgmtExt.ApproveApprovalRequests(ApprovalEntry);
        END;
        COMMIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Entry No.", "EntryNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN
            Approved := '200: Purchase Requisition Approved Successfully '
        ELSE
            Approved := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure RejectPurchaseReqApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]; "Reject Comments": Text) Rejected: Text
    var
        "EntryNo.": Integer;
    begin
        Rejected := '';
        "EntryNo." := 0;

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", Employee."User ID");
        ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            "EntryNo." := ApprovalEntry."Entry No.";
            ApprovalEntry."Web Portal Approval" := TRUE;
            ApprovalEntry."Rejection Comments" := "Reject Comments";
            ApprovalEntry.MODIFY;
            // ApprovalsMgmtExt.RejectApprovalRequests(ApprovalEntry);
        END;
        COMMIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Entry No.", "EntryNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Rejected);
        IF ApprovalEntry.FINDFIRST THEN
            Rejected := '200: Purchase requisition Rejected Successfully '
        ELSE
            Rejected := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;

        //**************************************** HR Leave Reimbursement ********************************************************************************************************************************************************
    end;
    /*
       
       procedure GetEmployeePurchaseReqApprovalEntries(var ApprovalEntries: XMLport 50024; EmployeeNo: Code[20])
       var
           ApprovalEntry: Record 454;
           Employee: Record 5200;
       begin
           ApprovalEntry.RESET;
           ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Requisition);
           IF EmployeeNo <> '' THEN BEGIN
               Employee.GET(EmployeeNo);
               Employee.TESTFIELD("User ID");
               ApprovalEntry.SETRANGE("Approver ID", Employee."User ID");
           END;
           IF ApprovalEntry.FINDFIRST THEN;
           ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
       end;

           
           procedure GetPurchaseReqApprovalEntries(var ApprovalEntries: XMLport 50024; LeaveNo: Code[20])
           var
               ApprovalEntry: Record 454;
               Employee: Record 5200;
           begin
               ApprovalEntry.RESET;
               ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Requisition);
               IF LeaveNo <> '' THEN BEGIN
                   ApprovalEntry.SETRANGE("Document No.", LeaveNo);
               END;
               IF ApprovalEntry.FINDFIRST THEN;
               ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
           end;

            
           procedure GetGlobalDimension1Codes(var DepartmentCodes: XMLport 50034)
           begin
           end; */
}


codeunit 50013 "Inventory Management WS"
{

    trigger OnRun()
    begin
        SendStoreRequisitionApprovalRequest('S-REQ0313')
    end;

    var
        Item: Record 27;
        ItemLedgerEntry: Record 32;
        ItemUnitOfMeasure: Record 5404;
        StoreRequisition: Record 50068;
        StoreRequisitionLine: Record 50069;
        InventorySetup: Record 313;
        InventoryUserSetup: Record 50070;
        Employee: Record 5200;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApprovalsMgmtExt: Codeunit "Approval Mgt.Procurement Ext";
        ApprovalsMgmt: Codeunit 1535;
        InventoryApprovalManager: Codeunit 50014;
        Text_0001: Label 'The inventory is insufficient';
        StoreRequisition2: Record 50068;
        ApprovalEntry: Record 454;
        DimensionValue: Record 349;

    /*  
     procedure GetStoreRequisitiontList(var StoreRequisitionExport: XMLport 50017; EmployeeNo: Code[20])
     begin
         IF EmployeeNo <> '' THEN BEGIN
             StoreRequisition2.RESET;
             StoreRequisition2.SETFILTER("Employee No.", EmployeeNo);
             IF StoreRequisition2.FINDFIRST THEN;
             StoreRequisitionExport.SETTABLEVIEW(StoreRequisition2);
         END
     end;

     
     procedure GetStoreRequisitiontListStatus(var StoreRequisitionExport: XMLport 50017; EmployeeNo: Code[20]; StatusFilter: Option Open,"Pending Approval",Approved,Rejected,Posted)
     begin
         StoreRequisition2.RESET;
         StoreRequisition2.SETRANGE(Status, StatusFilter);
         IF EmployeeNo <> '' THEN BEGIN

             StoreRequisition2.SETFILTER("Employee No.", EmployeeNo);
             IF StoreRequisition2.FINDFIRST THEN;
             StoreRequisitionExport.SETTABLEVIEW(StoreRequisition2);
         END
     end;

     
     procedure GetStoreRequisitionHeaderLines(var StoreRequisitionExport: XMLport 50017; HeaderNo: Code[20])
     begin

         IF HeaderNo <> '' THEN BEGIN
             StoreRequisition2.RESET;
             StoreRequisition2.SETFILTER("No.", HeaderNo);
             IF StoreRequisition2.FINDFIRST THEN;
             StoreRequisitionExport.SETTABLEVIEW(StoreRequisition2);
         END
     end;

     
     procedure GetItemList(var ItemExport: XMLport 50018)
     begin
     end;
  */

    procedure CheckStoreRequisitionExists("StoreRequisitionNo.": Code[20]; "EmployeeNo.": Code[20]) StoreRequisitionExist: Boolean
    begin
        StoreRequisitionExist := FALSE;
        StoreRequisition.RESET;
        StoreRequisition.SETRANGE(StoreRequisition."No.", "StoreRequisitionNo.");
        StoreRequisition.SETRANGE(StoreRequisition."Employee No.", "EmployeeNo.");
        IF StoreRequisition.FINDFIRST THEN BEGIN
            StoreRequisitionExist := TRUE;
        END;
    end;


    procedure CheckOpenStoreRequisitionExists("EmployeeNo.": Code[20]) OpenStoreRequisitionExist: Boolean
    begin
        OpenStoreRequisitionExist := FALSE;
        StoreRequisition.RESET;
        StoreRequisition.SETRANGE(StoreRequisition."Employee No.", "EmployeeNo.");
        StoreRequisition.SETRANGE(StoreRequisition.Status, StoreRequisition.Status::Open);
        IF StoreRequisition.FINDFIRST THEN BEGIN
            OpenStoreRequisitionExist := TRUE;
        END;
    end;


    procedure CreateStoreRequisition("EmployeeNo.": Code[20]; RequiredDate: Date; Description: Text[100]; Department: Code[20]) ReturnValue: Text
    var
        "DocNo.": Code[20];
        HREmployee: Record 5200;
    begin
        ReturnValue := '';

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        InventorySetup.RESET;
        InventorySetup.GET;

        "DocNo." := '';//NoSeriesMgt.GetNextNo(InventorySetup."Stores Requisition Nos.", 0D, TRUE);
        IF "DocNo." <> '' THEN BEGIN
            StoreRequisition.INIT;
            StoreRequisition."No." := "DocNo.";
            StoreRequisition."Document Date" := TODAY;
            StoreRequisition."Employee No." := "EmployeeNo.";
            StoreRequisition.VALIDATE(StoreRequisition."Employee No.");
            StoreRequisition."User ID" := Employee."User ID";
            StoreRequisition."Requester ID" := Employee."User ID";
            StoreRequisition."Required Date" := RequiredDate;
            StoreRequisition.Description := Description;

            HREmployee.RESET;
            HREmployee.SETRANGE("No.", "EmployeeNo.");
            IF HREmployee.FINDFIRST THEN BEGIN
                StoreRequisition."Global Dimension 1 Code" := HREmployee."Global Dimension 1 Code";
                //StoreRequisition.VALIDATE(StoreRequisition."Global Dimension 1 Code");
                StoreRequisition."Global Dimension 2 Code" := Department;//HREmployee."Global Dimension 2 Code";
                StoreRequisition."Shortcut Dimension 3 Code" := HREmployee."Shortcut Dimension 3 Code";
            END;
            IF StoreRequisition.INSERT THEN BEGIN
                ReturnValue := '200: Store Requisition No ' + "DocNo." + ' Successfully Created';
            END
            ELSE
                ReturnValue := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
        END;
    end;


    procedure ModifyStoreRequisition("StoreRequisitionNo.": Code[20]; "EmployeeNo.": Code[20]; RequiredDate: Date; Description: Text[100]; Department: Code[20]) StoreRequisitionModified: Boolean
    var
        HREmployee: Record 5200;
    begin
        StoreRequisitionModified := FALSE;
        StoreRequisition.RESET;
        StoreRequisition.SETRANGE(StoreRequisition."No.", "StoreRequisitionNo.");
        IF StoreRequisition.FINDFIRST THEN BEGIN
            StoreRequisition.TESTFIELD(Status, StoreRequisition.Status::Open);
            StoreRequisition."Document Date" := TODAY;
            StoreRequisition."Required Date" := RequiredDate;
            StoreRequisition.Description := Description;
            HREmployee.RESET;
            HREmployee.SETRANGE("No.", "EmployeeNo.");
            IF HREmployee.FINDFIRST THEN BEGIN
                StoreRequisition."Global Dimension 1 Code" := HREmployee."Global Dimension 1 Code";
                StoreRequisition."Global Dimension 2 Code" := Department;//HREmployee."Global Dimension 2 Code";
                StoreRequisition."Shortcut Dimension 3 Code" := HREmployee."Shortcut Dimension 3 Code";
            END;
            StoreRequisitionLine.RESET;
            StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Document No.", "StoreRequisitionNo.");
            IF StoreRequisitionLine.FINDFIRST THEN BEGIN
                StoreRequisition."Location Code" := StoreRequisitionLine."Location Code";
            END;
            StoreRequisition."Requester ID" := HREmployee."User ID";
            IF StoreRequisition.MODIFY THEN
                StoreRequisitionModified := TRUE;
        END;
    end;


    procedure GetStoreRequisitionAmount("StoreRequisitionNo.": Code[20]) StoreRequisitionAmount: Decimal
    begin
        StoreRequisitionAmount := 0;

        StoreRequisition.RESET;
        IF StoreRequisition.GET("StoreRequisitionNo.") THEN BEGIN
            StoreRequisition.CALCFIELDS(Amount);
            StoreRequisitionAmount := StoreRequisition.Amount;
        END;
    end;


    procedure GetStoreRequisitionStatus("StoreRequisitionNo.": Code[20]) StoreRequisitionStatus: Text
    begin
        StoreRequisitionStatus := '';

        StoreRequisition.RESET;
        IF StoreRequisition.GET("StoreRequisitionNo.") THEN BEGIN
            StoreRequisitionStatus := FORMAT(StoreRequisition.Status);
        END;
    end;


    procedure GetStoreRequisitionGlobalDimension1Code("StoreRequisitionNo.": Code[20]) GlobalDimension1Code: Text
    begin
        GlobalDimension1Code := '';

        StoreRequisition.RESET;
        IF StoreRequisition.GET("StoreRequisitionNo.") THEN BEGIN
            GlobalDimension1Code := StoreRequisition."Global Dimension 1 Code";
        END;
    end;


    procedure GetStoreRequisitionGlobalDimension2Code("StoreRequisitionNo.": Code[20]) GlobalDimension2Code: Text
    begin
        GlobalDimension2Code := '';

        StoreRequisition.RESET;
        IF StoreRequisition.GET("StoreRequisitionNo.") THEN BEGIN
            GlobalDimension2Code := StoreRequisition."Global Dimension 2 Code";
        END;
    end;


    procedure CreateStoreRequisitionLine("StoreRequisitionNo.": Code[20]; "ItemNo.": Code[20]; LocationCode: Code[10]; Quantity: Decimal; UOM: Code[10]; Description: Text) StoreRequisitionLineCreated: Text
    begin
        StoreRequisitionLineCreated := '';
        Item.GET("ItemNo.");
        Item.CALCFIELDS(Inventory);

        IF Quantity > Item.Inventory THEN
            ERROR(Text_0001);
        IF Quantity < 1 THEN ERROR('Quantity Must be Greater than 0');
        StoreRequisition.RESET;
        StoreRequisition.GET("StoreRequisitionNo.");

        StoreRequisitionLine.INIT;
        StoreRequisitionLine."Line No." := 0;
        StoreRequisitionLine."Document No." := "StoreRequisitionNo.";
        StoreRequisitionLine.Type := StoreRequisitionLine.Type::Item;
        StoreRequisitionLine."Item No." := "ItemNo.";
        StoreRequisitionLine.VALIDATE(StoreRequisitionLine."Item No.");
        StoreRequisitionLine."Location Code" := LocationCode;
        StoreRequisitionLine.VALIDATE(StoreRequisitionLine."Location Code");
        StoreRequisitionLine.VALIDATE(Quantity, Quantity);
        StoreRequisitionLine."Line Amount" := StoreRequisitionLine.Quantity * StoreRequisitionLine."Unit Cost";
        //StoreRequisitionLine."Unit of Measure Code":=UOM;
        //StoreRequisitionLine.VALIDATE(StoreRequisitionLine."Unit of Measure Code");
        //StoreRequisitionLine.Description:=Description;
        IF StoreRequisitionLine.INSERT THEN BEGIN
            StoreRequisitionLineCreated := '200: Store Requisition Line Successfully Created';
        END ELSE
            StoreRequisitionLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;

    end;


    procedure ModifyStoreRequisitionLine("LineNo.": Integer; "StoreRequisitionNo.": Code[20]; "ItemNo.": Code[20]; Quantity: Decimal; UOM: Code[10]; Description: Text; LocationCode: Code[20]) StoreRequisitionLineModified: Boolean
    begin
        StoreRequisitionLineModified := FALSE;
        StoreRequisition.SETRANGE(StoreRequisition."No.", "StoreRequisitionNo.");
        IF StoreRequisition.FINDFIRST THEN
            StoreRequisition.TESTFIELD(Status, StoreRequisition.Status::Open);
        StoreRequisitionLine.RESET;
        StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Line No.", "LineNo.");
        StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Document No.", "StoreRequisitionNo.");
        IF StoreRequisitionLine.FINDFIRST THEN BEGIN
            StoreRequisitionLine.Type := StoreRequisitionLine.Type::Item;
            StoreRequisitionLine."Item No." := "ItemNo.";
            StoreRequisitionLine.VALIDATE(StoreRequisitionLine."Item No.");
            StoreRequisitionLine."Location Code" := LocationCode;
            StoreRequisitionLine.VALIDATE(StoreRequisitionLine."Location Code");
            StoreRequisitionLine.Quantity := Quantity;
            StoreRequisitionLine.VALIDATE(StoreRequisitionLine.Quantity);
            StoreRequisitionLine."Unit of Measure Code" := UOM;
            StoreRequisitionLine.VALIDATE(StoreRequisitionLine."Unit of Measure Code");
            StoreRequisitionLine.Description := Description;
            IF StoreRequisitionLine.MODIFY THEN BEGIN
                StoreRequisitionLineModified := TRUE;
            END;
        END;
    end;


    procedure DeleteStoreRequisitionLine("LineNo.": Integer; "StoreRequisitionNo.": Code[20]) StoreRequisitionLineDeleted: Boolean
    begin
        StoreRequisitionLineDeleted := FALSE;
        StoreRequisition.SETRANGE(StoreRequisition."No.", "StoreRequisitionNo.");
        IF StoreRequisition.FINDFIRST THEN
            StoreRequisition.TESTFIELD(Status, StoreRequisition.Status::Open);

        StoreRequisitionLine.RESET;
        StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Line No.", "LineNo.");
        StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Document No.", "StoreRequisitionNo.");
        IF StoreRequisitionLine.FINDFIRST THEN BEGIN
            IF StoreRequisitionLine.DELETE THEN BEGIN
                StoreRequisitionLineDeleted := TRUE;
            END;
        END;
    end;

    procedure GetAvailableInventory("ItemNo.": Code[20]; UnitOfMeasure: Code[10]; LocationCode: Code[10]) AvailableInventory: Decimal
    var
        AvailableInventoryInBaseUOM: Decimal;
    begin
        AvailableInventory := 0;
        AvailableInventoryInBaseUOM := 0;

        Item.RESET;
        Item.GET("ItemNo.");

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item No.", "ItemNo.");
        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Location Code", LocationCode);
        IF ItemLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                AvailableInventoryInBaseUOM := AvailableInventoryInBaseUOM + ItemLedgerEntry.Quantity;
            UNTIL ItemLedgerEntry.NEXT = 0;
        END;

        IF UnitOfMeasure <> Item."Base Unit of Measure" THEN BEGIN
            ItemUnitOfMeasure.RESET;
            ItemUnitOfMeasure.SETRANGE(ItemUnitOfMeasure."Item No.", Item."No.");
            ItemUnitOfMeasure.SETRANGE(ItemUnitOfMeasure.Code, UnitOfMeasure);
            IF ItemUnitOfMeasure.FINDFIRST THEN BEGIN
                AvailableInventory := AvailableInventoryInBaseUOM / ItemUnitOfMeasure."Qty. per Unit of Measure";
            END;
        END ELSE BEGIN
            AvailableInventory := AvailableInventoryInBaseUOM;
        END;
    end;

    procedure CheckStoreRequisitionLinesExist("StoreRequisitionNo.": Code[20]) StoreRequisitionLinesExist: Boolean
    begin
        StoreRequisitionLinesExist := FALSE;

        StoreRequisitionLine.RESET;
        StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Document No.", "StoreRequisitionNo.");
        IF StoreRequisitionLine.FINDFIRST THEN BEGIN
            StoreRequisitionLinesExist := TRUE;
        END;
    end;

    procedure ValidateStoreRequisitionLines("StoreRequisitionNo.": Code[20]) StoreRequisitionLinesError: Text
    var
        "StoreRequisitionLineNo.": Integer;
    begin
        StoreRequisitionLinesError := '';
        "StoreRequisitionLineNo." := 0;

        StoreRequisitionLine.RESET;
        StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Document No.", "StoreRequisitionNo.");
        IF StoreRequisitionLine.FINDSET THEN BEGIN
            REPEAT
                "StoreRequisitionLineNo." := "StoreRequisitionLineNo." + 1;
                IF StoreRequisitionLine."Item No." = '' THEN BEGIN
                    StoreRequisitionLinesError := 'Item no. missing on Store requisition line no.' + FORMAT("StoreRequisitionLineNo.") + ', it cannot be zero or empty';
                    BREAK;
                END;

            UNTIL StoreRequisitionLine.NEXT = 0;
        END;
    end;

    procedure CheckStoreRequisitionApprovalWorkflowEnabled("StoreRequisitionNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;

        StoreRequisition.RESET;
        IF StoreRequisition.GET("StoreRequisitionNo.") THEN
            ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckStoreRequisitionApprovalsWorkflowEnabled(StoreRequisition);
    end;


    procedure SendStoreRequisitionApprovalRequest("StoreRequisitionNo.": Code[20]) StoreRequisitionApprovalRequestSent: Text
    var
        ApprovalEntry: Record 454;
    begin
        StoreRequisitionApprovalRequestSent := '';

        StoreRequisition.RESET;
        IF StoreRequisition.GET("StoreRequisitionNo.") THEN BEGIN
            ApprovalsMgmtExt.OnSendStoreRequisitionForApproval(StoreRequisition);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", StoreRequisition."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            IF ApprovalEntry.FINDFIRST THEN
                StoreRequisitionApprovalRequestSent := '200: Approval Request sent Successfully'
            ELSE
                StoreRequisitionApprovalRequestSent := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
        END
    end;


    procedure CancelStoreRequisitionApprovalRequest("StoreRequisitionNo.": Code[20]) StoreRequisitionApprovalRequestCanceled: Text
    var
        ApprovalEntry: Record 454;
    begin
        StoreRequisitionApprovalRequestCanceled := '';

        StoreRequisition.RESET;
        IF StoreRequisition.GET("StoreRequisitionNo.") THEN BEGIN
            ApprovalsMgmtExt.OnCancelStoreRequisitionApprovalRequest(StoreRequisition);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", StoreRequisition."No.");
            IF ApprovalEntry.FINDLAST THEN BEGIN
                IF ApprovalEntry.Status = ApprovalEntry.Status::Canceled THEN
                    StoreRequisitionApprovalRequestCanceled := '200: Approval Request Cancelled Successfully'
                ELSE
                    StoreRequisitionApprovalRequestCanceled := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
            END;
        END;
    end;

    procedure ReopenStoreRequisition("StoreRequisitionNo.": Code[20]) StoreRequisitionOpened: Boolean
    begin
        StoreRequisitionOpened := FALSE;
        StoreRequisition.RESET;
        StoreRequisition.SETRANGE(StoreRequisition."No.", "StoreRequisitionNo.");
        IF StoreRequisition.FINDFIRST THEN BEGIN
            InventoryApprovalManager.ReOpenStoreRequisitionHeader(StoreRequisition);
            StoreRequisitionOpened := TRUE;
        END;
    end;

    procedure CancelStoreRequisitionBudgetCommitment("StoreRequisitionNo.": Code[20]) StoreRequisitionBudgetCommitmentCanceled: Boolean
    var
        ApprovalEntry: Record 454;
    begin
        StoreRequisitionBudgetCommitmentCanceled := FALSE;

        StoreRequisition.RESET;
        IF StoreRequisition.GET("StoreRequisitionNo.") THEN BEGIN
            StoreRequisitionBudgetCommitmentCanceled := TRUE;
        END;
    end;


    procedure ApproveStoreReqApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]) Approved: Text
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
            // ApprovalsMgmtExt.ApproveApprovalRequests(ApprovalEntry);
        END;
        COMMIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Entry No.", "EntryNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN
            Approved := '200: Store Requisition Approved Successfully '
        ELSE
            Approved := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure RejectStoreReqApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]; RejectionComments: Text) Rejected: Text
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
            ApprovalEntry."Rejection Comments" := RejectionComments;
            ApprovalEntry.MODIFY;
            // ApprovalsMgmtExt.RejectApprovalRequests(ApprovalEntry);
        END;
        COMMIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Entry No.", "EntryNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Rejected);
        IF ApprovalEntry.FINDFIRST THEN
            Rejected := '200: Store requisition Rejected Successfully '
        ELSE
            Rejected := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;

        //**************************************** HR Leave Reimbursement ********************************************************************************************************************************************************
    end;
    /* 
        
        procedure GetEmployeeStoreReqApprovalEntries(var ApprovalEntries: XMLport 50024; EmployeeNo: Code[20])
        var
            ApprovalEntry: Record 454;
            Employee: Record 5200;
        begin
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::"Store Requisition");
            IF EmployeeNo <> '' THEN BEGIN
                Employee.GET(EmployeeNo);
                Employee.TESTFIELD("User ID");
                ApprovalEntry.SETRANGE("Approver ID", Employee."User ID");

            END;
            //ApprovalEntry.SETRANGE("Approver ID",'77tyty');
            IF ApprovalEntry.FINDFIRST THEN;
            ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
        end;

        
        procedure GetStoreReqApprovalEntries(var ApprovalEntries: XMLport 50024; StoreReqNo: Code[20])
        var
            ApprovalEntry: Record 454;
            Employee: Record 5200;
        begin
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::"Store Requisition");
            IF StoreReqNo <> '' THEN BEGIN
                ApprovalEntry.SETRANGE("Document No.", StoreReqNo);
            END;
            IF ApprovalEntry.FINDFIRST THEN;
            ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
        end;

        
        procedure GetGlobalDimension1Codes(var DepartmentCodes: XMLport 50034)
        begin
            DimensionValue.RESET;
            DimensionValue.SETRANGE("Global Dimension No.", 1);
            IF DimensionValue.FINDFIRST THEN;
            DepartmentCodes.SETTABLEVIEW(DimensionValue);
        end;
    
    
    procedure GetGlobalDimension2Codes(var DepartmentCodes: XMLport 50034)
    begin
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Global Dimension No.", 2);
        IF DimensionValue.FINDFIRST THEN;
        DepartmentCodes.SETTABLEVIEW(DimensionValue);
    end;

    
    procedure GetShortcutDimension3Codes(var DepartmentCodes: XMLport 50034)
    begin
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Global Dimension No.", 3);
        IF DimensionValue.FINDFIRST THEN;
        DepartmentCodes.SETTABLEVIEW(DimensionValue);
    end;
     */
}


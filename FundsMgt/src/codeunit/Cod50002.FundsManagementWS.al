codeunit 50002 "Funds Management WS"
{

    trigger OnRun()
    begin
        MESSAGE(CreateImprestSurrenderHeader('0874', 'IN01341', '', 1, '0874'));
        //MESSAGE(CreateImprestHeader('0008',010620D,030620D,'test',6,''));
    end;

    var
        ImprestHeader: Record 50008;
        ImprestLine: Record 50009;
        ImprestSurrenderHeader: Record 50010;
        ImprestSurrenderLine: Record 50011;
        FundsGeneralSetup: Record 50031;
        Employee: Record 5200;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
        ApprovalsMgmt: Codeunit 1535;
        FundsApprovalManager: Codeunit 50003;
        ImprestHeader2: Record 50008;
        ApprovalEntry: Record 454;
        DimensionValue: Record 49;
        FundsTransactionCode: Record 50027;

    /* 
    /* procedure GetImprestList(var ImprestsExportandImport: XMLport 50016; EmployeeNo: Code[20])
    begin
        IF EmployeeNo <> '' THEN BEGIN
            ImprestHeader2.RESET;
            ImprestHeader2.SETFILTER("Employee No.", EmployeeNo);
            IF ImprestHeader2.FINDFIRST THEN;
            ImprestsExportandImport.SETTABLEVIEW(ImprestHeader2);
        END
    end; */
    /*
       
       procedure GetImprestHeaderLines(var ImprestsExportandImport: XMLport 50016; HeaderNo: Code[20])
       begin
           IF HeaderNo <> '' THEN BEGIN
               ImprestHeader2.RESET;
               ImprestHeader2.SETFILTER("No.", HeaderNo);
               IF ImprestHeader2.FINDFIRST THEN;
               ImprestsExportandImport.SETTABLEVIEW(ImprestHeader2);
           END
       end;

       
       procedure GetImprestListStatus(var ImprestsExportandImport: XMLport 50016; EmployeeNo: Code[20]; ImpStatus: Option Open,"Pending Approval",Approved,Rejected,Posted,Reversed)
       begin
           ImprestHeader2.RESET;
           ImprestHeader2.SETRANGE(Status, ImpStatus);
           IF EmployeeNo <> '' THEN BEGIN

               ImprestHeader2.SETFILTER("Employee No.", EmployeeNo);
               IF ImprestHeader2.FINDFIRST THEN;
               ImprestsExportandImport.SETTABLEVIEW(ImprestHeader2);
           END
       end;

       
       procedure GetOvertimeList(var OvertimeExportandImport: XMLport 50033; EmployeeNo: Code[20])
       begin
           IF EmployeeNo <> '' THEN BEGIN
               ImprestHeader2.RESET;
               ImprestHeader2.SETFILTER("Employee No.", EmployeeNo);
               IF ImprestHeader2.FINDFIRST THEN;
               OvertimeExportandImport.SETTABLEVIEW(ImprestHeader2);
           END
       end;

       
       procedure GetOvertimeHeaderLines(var OvertimeExportandImport: XMLport 50033; HeaderNo: Code[20])
       begin
           IF HeaderNo <> '' THEN BEGIN
               ImprestHeader2.RESET;
               ImprestHeader2.SETFILTER("No.", HeaderNo);
               IF ImprestHeader2.FINDFIRST THEN;
               OvertimeExportandImport.SETTABLEVIEW(ImprestHeader2);
           END
       end;

       
       procedure GetOvertimeListStatus(var OvertimeExportandImport: XMLport 50033; EmployeeNo: Code[20]; ImpStatus: Option Open,"Pending Approval",Approved,Rejected,Posted,Reversed)
       begin
           ImprestHeader2.RESET;
           ImprestHeader2.SETRANGE(Status, ImpStatus);
           IF EmployeeNo <> '' THEN BEGIN

               ImprestHeader2.SETFILTER("Employee No.", EmployeeNo);
               IF ImprestHeader2.FINDFIRST THEN;
               OvertimeExportandImport.SETTABLEVIEW(ImprestHeader2);
           END
       end;

       
       procedure GetImprestcodes(var ImprestCodes: XMLport "50021")
       begin
       end;

       
       procedure GetImprestcodesHR(var ImprestCodes: XMLport "50021"; Type: Integer)
       begin
           FundsTransactionCode.RESET;
           FundsTransactionCode.SETRANGE("Imprest Type", Type);
           IF FundsTransactionCode.FINDFIRST THEN;
           ImprestCodes.SETTABLEVIEW(FundsTransactionCode);
       end; 

       
       procedure CreateImprestHeaderAndLines(var ImprestsExportandImport: XMLport 50016; EmployeeNo: Code[20])
       begin
       end; */


    procedure GetLocalCurrencyCode() LocalCurrencyCode: Code[10]
    var
        GeneralLedgerSetup: Record 98;
    begin
        LocalCurrencyCode := '';
        GeneralLedgerSetup.RESET;
        IF GeneralLedgerSetup.GET THEN
            LocalCurrencyCode := GeneralLedgerSetup."LCY Code";
    end;


    procedure CheckImprestRequestExists("ImprestNo.": Code[20]; "EmployeeNo.": Code[20]) ImprestRequestExist: Boolean
    begin
        ImprestRequestExist := FALSE;
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", "ImprestNo.");
        ImprestHeader.SETRANGE(ImprestHeader."Employee No.", "EmployeeNo.");
        IF ImprestHeader.FINDFIRST THEN BEGIN
            ImprestRequestExist := TRUE;
        END;
    end;


    procedure CheckOpenImprestRequestExists("EmployeeNo.": Code[20]) OpenImprestRequestExist: Boolean
    begin
        OpenImprestRequestExist := FALSE;
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."Employee No.", "EmployeeNo.");
        IF ImprestHeader.FINDFIRST THEN BEGIN
            IF (ImprestHeader.Status = ImprestHeader.Status::Open) OR (ImprestHeader.Status = ImprestHeader.Status::"Pending Approval") THEN
                OpenImprestRequestExist := TRUE;
        END;
    end;


    procedure CheckImprestNotSurrendered("EmployeeNo.": Code[20]) ImprestNotSurrendered: Boolean
    var
        Text001: Label 'You are not able make this request. You are required to surrender your previous imprest before making a new request.';
    begin
        ImprestNotSurrendered := FALSE;
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."Employee No.", "EmployeeNo.");
        IF ImprestHeader.FINDFIRST THEN BEGIN
            IF ImprestHeader."Surrender status" = ImprestHeader."Surrender status"::"Not Surrendered" THEN
                ERROR(Text001);
            ImprestNotSurrendered := TRUE;
        END;
    end;


    procedure CheckImprestPartiallySurrendered("EmployeeNo.": Code[20]) ImprestPartiallySurrendered: Boolean
    var
        Text001: Label 'You are not able make this request. You have surrendered your imprest partially. Ensure you submit your imprest fully before requesting for a new one.';
    begin
        ImprestPartiallySurrendered := FALSE;
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."Employee No.", "EmployeeNo.");
        IF ImprestHeader.FINDFIRST THEN BEGIN
            IF ImprestHeader."Surrender status" = ImprestHeader."Surrender status"::"Partially Surrendered" THEN
                ERROR(Text001);
            ImprestPartiallySurrendered := TRUE;
        END;
    end;


    procedure CreateImprestHeader("Employee No.": Code[20]; DateFrom: Date; DateTo: Date; Description: Text[250]; Type: Option " ",Imprest,"Petty Cash","Board Allowances",Subsistence,Overtime,Allowances; Department: Code[20]; CreatedBy: Code[20]) ReturnValue: Text
    var
        "DocNo.": Code[20];
        HREmployee: Record 5200;
        ImprestType: Option " ",Imprest,"Petty Cash";
    begin

        //Check imprest not surrendered
        //CheckImprestNotSurrendered("Employee No.");

        //Check imprest partially surrendered
        //CheckImprestPartiallySurrendered("Employee No.");
        ReturnValue := '';

        Employee.RESET;
        Employee.GET("Employee No.");

        FundsGeneralSetup.RESET;
        FundsGeneralSetup.GET;

        //ADDED ON 06/02/2020
        IF Type = Type::Imprest THEN BEGIN
            "DocNo." := NoSeriesMgt.GetNextNo(FundsGeneralSetup."Imprest Nos.", 0D, TRUE);
        END ELSE
            IF Type = Type::"Petty Cash" THEN BEGIN
                "DocNo." := NoSeriesMgt.GetNextNo(FundsGeneralSetup."Imprest Nos.", 0D, TRUE);
            END
            ELSE
                IF Type = Type::Subsistence THEN BEGIN
                    "DocNo." := NoSeriesMgt.GetNextNo(FundsGeneralSetup."Subsistence Nos", 0D, TRUE);
                END
                ELSE
                    IF Type = Type::Overtime THEN BEGIN
                        "DocNo." := NoSeriesMgt.GetNextNo(FundsGeneralSetup."Overtime Nos", 0D, TRUE);
                    END
                    ELSE
                        IF Type = Type::Allowances THEN BEGIN
                            "DocNo." := NoSeriesMgt.GetNextNo(FundsGeneralSetup."Allowance Nos", 0D, TRUE);
                        END;
        //
        IF "DocNo." <> '' THEN BEGIN
            ImprestHeader.INIT;
            ImprestHeader."No." := "DocNo.";
            ImprestHeader."Employee No." := "Employee No.";
            ImprestHeader.VALIDATE(ImprestHeader."Employee No.");
            ImprestHeader."User ID" := Employee."User ID";
            ImprestHeader."Document Date" := TODAY;
            ImprestHeader."Posting Date" := TODAY;
            ImprestHeader.Type := Type;
            ImprestHeader."Document Type" := ImprestHeader."Document Type"::Imprest;
            ImprestHeader."Date From" := DateFrom;
            ImprestHeader."Date To" := DateTo;
            ImprestHeader.VALIDATE("Date To");
            ImprestHeader.Description := Description;
            ImprestHeader."Created By" := CreatedBy;

            HREmployee.RESET;
            HREmployee.SETRANGE("No.", "Employee No.");
            IF HREmployee.FINDFIRST THEN BEGIN
                ImprestHeader."Global Dimension 1 Code" := Department;
                ImprestHeader.VALIDATE(ImprestHeader."Global Dimension 1 Code");

                ImprestHeader."Global Dimension 2 Code" := HREmployee."Global Dimension 2 Code";
                ImprestHeader."Shortcut Dimension 3 Code" := HREmployee."Shortcut Dimension 3 Code";
            END;

            IF ImprestHeader.INSERT THEN BEGIN
                ReturnValue := '200: Imprest No ' + "DocNo." + ' Successfully Created';
            END
            ELSE
                ReturnValue := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
        END ELSE
            ReturnValue := '400: Error, please setup no series';
    end;


    procedure ModifyImprestHeader("ImprestNo.": Code[20]; "Employee No.": Code[20]; DateFrom: Date; DateTo: Date; Description: Text[250]; DocumentName: Text; Department: Code[20]) ImprestHeaderModified: Boolean
    var
        HREmployee: Record 5200;
        ImprestType: Option " ",Imprest,"Petty Cash";
    begin
        ImprestHeaderModified := FALSE;
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", "ImprestNo.");
        IF ImprestHeader.FINDFIRST THEN BEGIN
            ImprestHeader."Posting Date" := TODAY;
            ImprestHeader."Document Type" := ImprestHeader."Document Type"::Imprest;
            ImprestHeader."Date From" := DateFrom;
            ImprestHeader."Date To" := DateTo;
            ImprestHeader.Description := Description;
            //ImprestHeader."Paid In Bank":=DocumentName;
            HREmployee.RESET;
            HREmployee.SETRANGE("No.", "Employee No.");
            IF HREmployee.FINDFIRST THEN BEGIN
                ImprestHeader."Global Dimension 2 Code" := HREmployee."Global Dimension 2 Code";
                ImprestHeader.VALIDATE(ImprestHeader."Global Dimension 2 Code");
                ImprestHeader.VALIDATE("Global Dimension 1 Code", Department);
            END;

            IF ImprestHeader.MODIFY THEN
                ImprestHeaderModified := TRUE;
        END;
    end;


    procedure GetImprestAmount("ImprestNo.": Code[20]) ImprestAmount: Decimal
    begin
        ImprestAmount := 0;

        ImprestHeader.RESET;
        IF ImprestHeader.GET("ImprestNo.") THEN BEGIN
            ImprestHeader.CALCFIELDS(Amount);
            ImprestAmount := ImprestHeader.Amount;
        END;
    end;


    procedure GetImprestLineAmount(EmployeeNo: Code[20]; Imprestcode: Code[20]) ImprestAmount: Decimal
    var
        AllowanceMatrix: Record 50032;
        Employee: Record 5200;
    begin
        ImprestAmount := 0;
        Employee.GET(EmployeeNo);
        Employee.TESTFIELD("Salary Scale");
        AllowanceMatrix.RESET;
        AllowanceMatrix.SETRANGE(AllowanceMatrix."Allowance Code", Imprestcode);
        AllowanceMatrix.SETRANGE("Job Group", Employee."Salary Scale");
        IF AllowanceMatrix.FINDFIRST THEN BEGIN
            ImprestAmount := AllowanceMatrix.Amount;

        END;
    end;


    procedure GetImprestStatus("ImprestNo.": Code[20]) ImprestStatus: Text
    begin
        ImprestStatus := '';

        ImprestHeader.RESET;
        IF ImprestHeader.GET("ImprestNo.") THEN BEGIN
            ImprestStatus := FORMAT(ImprestHeader.Status);
        END;

        //GetImprestGlobalDimension1Code
        /*GlobalDimension1Code:='';
        
        ImprestHeader.RESET;
        IF ImprestHeader.GET("ImprestNo.") THEN BEGIN
          GlobalDimension1Code:=ImprestHeader."Global Dimension 1 Code";
        END;*/

    end;


    procedure CreateImprestLine("ImprestNo.": Code[20]; ImprestCode: Code[50]; Description: Text; Amount: Decimal; Quantity: Decimal; BankName: Text; BankBranch: Text; BankAccNo: Code[20]) ImprestLineCreated: Text
    var
        HREmployee: Record 5200;
    begin
        ImprestLineCreated := '';

        ImprestHeader.RESET;
        ImprestHeader.GET("ImprestNo.");

        ImprestLine.INIT;
        ImprestLine."Line No." := 0;
        ImprestLine."Document No." := "ImprestNo.";
        ImprestLine."Imprest Code" := ImprestCode;
        ImprestLine.VALIDATE(ImprestLine."Imprest Code");
        ImprestLine.Quantity := Quantity;
        ImprestLine."Unit Amount" := Amount;
        ImprestLine.Description := Description;
        ImprestLine."Gross Amount" := Amount * ImprestLine.Quantity;
        ImprestLine.VALIDATE(ImprestLine."Gross Amount");
        //ImprestLine."Bank Name":=BankName;
        //ImprestLine."Bank Branch":=BankBranch;
        //ImprestLine."Bank A/C No.":=BankAccNo;
        /*ImprestLine."Global Dimension 1 Code":=GlobalDimension1Code;
        ImprestLine."Global Dimension 2 Code":=GlobalDimension2Code;
        ImprestLine."Shortcut Dimension 3 Code":=ShortcutDimension3Code;
        ImprestLine."Shortcut Dimension 4 Code":=ShortcutDimension4Code;
        ImprestLine."Shortcut Dimension 5 Code":=ShortcutDimension5Code;
        ImprestLine."Shortcut Dimension 6 Code":=ShortcutDimension6Code;
        ImprestLine."Shortcut Dimension 7 Code":=ShortcutDimension7Code;
        ImprestLine."Shortcut Dimension 8 Code":=ShortcutDimension8Code;*/

        IF ImprestLine.INSERT THEN BEGIN
            ImprestLineCreated := '200: Imprest Line Successfully Created';
        END ELSE
            ImprestLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;

    end;


    procedure ModifyImprestLine("LineNo.": Integer; "ImprestNo.": Code[20]; ImprestCode: Code[50]; Description: Text; Amount: Decimal; Quantity: Decimal; BankName: Text; BankBranch: Text; BankAccNo: Code[20]) ImprestLineModified: Boolean
    begin
        ImprestLineModified := FALSE;

        ImprestLine.RESET;
        ImprestLine.SETRANGE(ImprestLine."Line No.", "LineNo.");
        ImprestLine.SETRANGE(ImprestLine."Document No.", "ImprestNo.");
        IF ImprestLine.FINDFIRST THEN BEGIN
            ImprestLine."Imprest Code" := ImprestCode;
            ImprestLine.VALIDATE(ImprestLine."Imprest Code");
            ImprestLine.Description := Description;
            ImprestLine.Quantity := Quantity;
            ImprestLine."Unit Amount" := Amount;
            /*//Bank Details
            ImprestLine."Bank Name":=BankName;
            ImprestLine."Bank Branch":=BankBranch;
            ImprestLine."Bank A/C No.":=BankAccNo;
            */
            ImprestLine."Gross Amount" := Amount * Quantity;
            ImprestLine.VALIDATE(ImprestLine."Gross Amount");

            ImprestHeader.RESET;
            ImprestHeader.SETRANGE(ImprestHeader."No.", "ImprestNo.");
            IF ImprestHeader.FINDFIRST THEN BEGIN
                ImprestLine."Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
                ImprestLine."Global Dimension 2 Code" := ImprestHeader."Global Dimension 2 Code";
                ImprestLine."Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
            END;
            IF ImprestLine.MODIFY THEN BEGIN
                ImprestLineModified := TRUE;
            END;
        END;

    end;


    procedure DeleteImprestLine("LineNo.": Integer; "ImprestNo.": Code[20]) ImprestLineDeleted: Boolean
    begin
        ImprestLineDeleted := FALSE;

        ImprestLine.RESET;
        ImprestLine.SETRANGE(ImprestLine."Line No.", "LineNo.");
        ImprestLine.SETRANGE(ImprestLine."Document No.", "ImprestNo.");
        IF ImprestLine.FINDFIRST THEN BEGIN
            IF ImprestLine.DELETE THEN BEGIN
                ImprestLineDeleted := TRUE;
            END;
        END;
    end;

    procedure CheckImprestLinesExist("ImprestNo.": Code[20]) ImprestLinesExist: Boolean
    begin
        ImprestLinesExist := FALSE;

        ImprestLine.RESET;
        ImprestLine.SETRANGE(ImprestLine."Document No.", "ImprestNo.");
        IF ImprestLine.FINDFIRST THEN BEGIN
            ImprestLinesExist := TRUE;
        END;
    end;

    procedure ValidateImprestLines("ImprestNo.": Code[20]) ImprestLinesError: Text
    var
        "ImprestLineNo.": Integer;
    begin
        ImprestLinesError := '';
        "ImprestLineNo." := 0;

        ImprestLine.RESET;
        ImprestLine.SETRANGE(ImprestLine."Document No.", "ImprestNo.");
        IF ImprestLine.FINDSET THEN BEGIN
            REPEAT
                "ImprestLineNo." := "ImprestLineNo." + 1;
                IF ImprestLine."Imprest Code" = '' THEN BEGIN
                    ImprestLinesError := 'Imprest code missing on imprest line no.' + FORMAT("ImprestLineNo.") + ', it cannot be zero or empty';
                    BREAK;
                END;
            /*IF ImprestLine."Global Dimension 1 Code"='' THEN BEGIN
              ImprestLinesError:='Project code missing on imprest line no.'+FORMAT("ImprestLineNo.")+', it cannot be zero or empty';
              BREAK;
            END;*/

            UNTIL ImprestLine.NEXT = 0;
        END;

    end;

    procedure CheckImprestApprovalWorkflowEnabled("ImprestNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;

        ImprestHeader.RESET;
        IF ImprestHeader.GET("ImprestNo.") THEN
            ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckImprestApprovalsWorkflowEnabled(ImprestHeader);
    end;


    procedure SendImprestApprovalRequest("ImprestNo.": Code[20]) ImprestApprovalRequestSent: Text
    var
        ApprovalEntry: Record 454;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
    begin
        ImprestApprovalRequestSent := '';

        ImprestHeader.RESET;
        IF ImprestHeader.GET("ImprestNo.") THEN BEGIN
            ApprovalsMgmtExt.OnSendImprestHeaderForApproval(ImprestHeader);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", ImprestHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            IF ApprovalEntry.FINDFIRST THEN
                ImprestApprovalRequestSent := '200: Imprest Approval Request sent Successfully '
            ELSE
                ImprestApprovalRequestSent := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;

        END;
    end;


    procedure CancelImprestApprovalRequest("ImprestNo.": Code[20]) ImprestApprovalRequestCanceled: Text
    var
        ApprovalEntry: Record 454;
    begin
        ImprestApprovalRequestCanceled := '';

        ImprestHeader.RESET;
        IF ImprestHeader.GET("ImprestNo.") THEN BEGIN
            ApprovalsMgmtExt.OnCancelImprestHeaderApprovalRequest(ImprestHeader);
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", ImprestHeader."No.");
            IF ApprovalEntry.FINDLAST THEN BEGIN
                IF ApprovalEntry.Status = ApprovalEntry.Status::Canceled THEN
                    ImprestApprovalRequestCanceled := '200: Imprest Cancelled Request sent Successfully '
                ELSE
                    ImprestApprovalRequestCanceled := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
            END;
        END;
    end;

    procedure ReopenImprestRequest("ImprestNo.": Code[20]) ImprestRequestOpened: Boolean
    begin
        ImprestRequestOpened := FALSE;
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", "ImprestNo.");
        IF ImprestHeader.FINDFIRST THEN BEGIN
            FundsApprovalManager.ReOpenImprestHeader(ImprestHeader);
            ImprestRequestOpened := TRUE;
        END;
    end;

    procedure CancelImprestBudgetCommitment("ImprestNo.": Code[20]) ImprestBudgetCommitmentCanceled: Boolean
    var
        ApprovalEntry: Record 454;
    begin
        ImprestBudgetCommitmentCanceled := FALSE;

        ImprestHeader.RESET;
        IF ImprestHeader.GET("ImprestNo.") THEN BEGIN
            ImprestBudgetCommitmentCanceled := TRUE;
        END;
    end;


    procedure GetEmployeeImprestBalance("EmployeeNo.": Code[20]) EmployeeImprestBalance: Decimal
    begin
        EmployeeImprestBalance := 0;

        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            Employee.CALCFIELDS(Employee.Balance);
            EmployeeImprestBalance := Employee.Balance;
        END;
    end;


    procedure CheckImprestSurrenderExists("ImprestSurrenderNo.": Code[20]; "EmployeeNo.": Code[20]) ImprestSurrenderExist: Boolean
    begin
        ImprestSurrenderExist := FALSE;
        ImprestSurrenderHeader.RESET;
        ImprestSurrenderHeader.SETRANGE(ImprestSurrenderHeader."No.", "ImprestSurrenderNo.");
        ImprestSurrenderHeader.SETRANGE(ImprestSurrenderHeader."Employee No.", "EmployeeNo.");
        IF ImprestSurrenderHeader.FINDFIRST THEN BEGIN
            ImprestSurrenderExist := TRUE;
        END;
    end;


    procedure CheckOpenImprestSurrenderExists("EmployeeNo.": Code[20]) OpenImprestSurrenderExist: Boolean
    begin
        OpenImprestSurrenderExist := FALSE;
        ImprestSurrenderHeader.RESET;
        ImprestSurrenderHeader.SETRANGE(ImprestSurrenderHeader."Employee No.", "EmployeeNo.");
        ImprestSurrenderHeader.SETRANGE(ImprestSurrenderHeader.Status, ImprestSurrenderHeader.Status::Open);
        IF ImprestSurrenderHeader.FINDFIRST THEN BEGIN
            OpenImprestSurrenderExist := TRUE;
        END;
    end;
    /*
        
         procedure GetImprestSurrenderList(var ImprestsSurrExportImport: XMLport 50025; EmployeeNo: Code[20])
        var
            ImprestSurrHeader: Record 50010;
        begin
            IF EmployeeNo <> '' THEN BEGIN
                ImprestSurrHeader.RESET;
                ImprestSurrHeader.SETFILTER("Employee No.", EmployeeNo);
                IF ImprestSurrHeader.FINDFIRST THEN;
                ImprestsSurrExportImport.SETTABLEVIEW(ImprestSurrHeader);
            END
        end;

        
        procedure GetImprestSurrenderHeaderLines(var ImprestsSurrExportImport: XMLport 50025; HeaderNo: Code[20])
        var
            ImprestSurrHeader: Record 50010;
        begin
            IF HeaderNo <> '' THEN BEGIN
                ImprestSurrHeader.RESET;
                ImprestSurrHeader.SETFILTER("No.", HeaderNo);
                IF ImprestSurrHeader.FINDFIRST THEN;
                ImprestsSurrExportImport.SETTABLEVIEW(ImprestSurrHeader);
            END
        end; */


    procedure CreateImprestSurrenderHeader("EmployeeNo.": Code[20]; "ImprestNo.": Code[20]; Description: Text[100]; DocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Receipt,"Funds Transfer",Imprest,"Imprest Surrender","Petty Cash Surrender"; CreatedBy: Code[20]) ReturnValue: Text
    var
        "DocNo.": Code[20];
        ImprestSurrenderHeader2: Record 50010;
    // ImprestSurrenderDocuments: Record 50014;
    begin
        ReturnValue := '';
        Employee.RESET;
        Employee.GET("EmployeeNo.");
        DocumentType := DocumentType::"Imprest Surrender";
        FundsGeneralSetup.RESET;
        FundsGeneralSetup.GET;

        //added on 10/02/2020
        IF DocumentType = DocumentType::"Imprest Surrender" THEN BEGIN
            "DocNo." := NoSeriesMgt.GetNextNo(FundsGeneralSetup."Imprest Surrender Nos.", 0D, TRUE);
        END ELSE
            IF DocumentType = DocumentType::"Petty Cash Surrender" THEN BEGIN
                "DocNo." := NoSeriesMgt.GetNextNo(FundsGeneralSetup."Imprest Surrender Nos.", 0D, TRUE);
            END;
        //

        IF "DocNo." <> '' THEN BEGIN
            ImprestSurrenderHeader.RESET;
            ImprestSurrenderHeader."No." := "DocNo.";
            ImprestSurrenderHeader."Document Date" := TODAY;
            ImprestSurrenderHeader."Posting Date" := TODAY;
            ImprestSurrenderHeader."Document Type" := DocumentType;
            ImprestSurrenderHeader."Employee No." := "EmployeeNo.";
            ImprestSurrenderHeader.VALIDATE(ImprestSurrenderHeader."Employee No.");
            ImprestSurrenderHeader."Imprest No." := "ImprestNo.";
            ImprestSurrenderHeader.VALIDATE(ImprestSurrenderHeader."Imprest No.");
            ImprestSurrenderHeader.Description := Description;
            ImprestSurrenderHeader."User ID" := Employee."User ID";
            ImprestSurrenderHeader."Created by" := CreatedBy;
            IF ImprestSurrenderHeader.INSERT THEN BEGIN
                ReturnValue := '200: Imprest Surrender No ' + "DocNo." + ' Successfully Created';
            END
            ELSE
                ReturnValue := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;

            /*
          //Insert Imprest Surrender Receipts
            ImprestSurrenderHeader2.RESET;
            ImprestSurrenderHeader2.SETRANGE(ImprestSurrenderHeader2."Employee No.","EmployeeNo.");
            ImprestSurrenderHeader2.SETRANGE(ImprestSurrenderHeader2.Status,ImprestSurrenderHeader2.Status::Open);
              IF ImprestSurrenderHeader2.FINDFIRST THEN BEGIN
        
        
                REPEAT
                  ImprestSurrenderDocuments.INIT;
                  ImprestSurrenderDocuments."DocumentNo.":=ImprestSurrenderHeader."No.";
                  ImprestSurrenderDocuments."Document Code":=UPPERCASE('Imprest Receipt');
                  ImprestSurrenderDocuments."Document Description":=UPPERCASE('Imprest Receipt');
                  ImprestSurrenderDocuments."Document Attached":=FALSE;
                  ImprestSurrenderDocuments.INSERT;
                UNTIL ImprestSurrenderDocuments.NEXT=0;
                KLK
                "ImprestSurrenderDocumentNo.":="DocNo.";
            END;
          END;*/
        END;

    end;


    procedure ModifyImprestSurrenderHeader("ImprestSurrenderNo.": Code[20]; "EmployeeNo.": Code[20]; "ImprestNo.": Code[20]; Description: Text[100]; DocumentName: Text) ReturnValue: Text
    var
        HREmployee: Record 5200;
    begin
        ReturnValue := '';
        ImprestSurrenderHeader.RESET;
        ImprestSurrenderHeader.SETRANGE(ImprestSurrenderHeader."No.", "ImprestSurrenderNo.");
        IF ImprestSurrenderHeader.FINDFIRST THEN BEGIN
            ImprestSurrenderHeader."Imprest No." := "ImprestNo.";
            ImprestSurrenderHeader.VALIDATE(ImprestSurrenderHeader."Imprest No.");
            ImprestSurrenderHeader.Description := Description;
            ImprestSurrenderHeader."Document Name" := DocumentName;
            HREmployee.RESET;
            HREmployee.SETRANGE("No.", "EmployeeNo.");
            IF HREmployee.FINDFIRST THEN BEGIN
                ImprestSurrenderHeader."Employee Name" := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";
                ImprestSurrenderHeader."Global Dimension 1 Code" := HREmployee."Global Dimension 1 Code";
                ImprestSurrenderHeader.VALIDATE(ImprestSurrenderHeader."Global Dimension 1 Code");
            END;
            IF ImprestSurrenderHeader.MODIFY THEN BEGIN
                ReturnValue := '200: Imprest Surrender No ' + "ImprestSurrenderNo." + ' Successfully Modified';
            END
            ELSE
                ReturnValue := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
        END;
    end;


    procedure GetImprestSurrenderAmount("ImprestSurrenderNo.": Code[20]) ImprestSurrenderAmount: Decimal
    begin
        ImprestSurrenderAmount := 0;

        ImprestSurrenderHeader.RESET;
        IF ImprestSurrenderHeader.GET("ImprestSurrenderNo.") THEN BEGIN
            ImprestSurrenderHeader.CALCFIELDS(Amount);
            ImprestSurrenderAmount := ImprestHeader.Amount;
        END;
    end;


    procedure GetImprestRemainingAmount("ImprestNo.": Code[20]; ActualSpent: Decimal) Difference: Decimal
    begin
        Difference := 0;
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", "ImprestNo.");
        ImprestHeader.SETRANGE(ImprestHeader.Status, ImprestHeader.Status::Posted);
        IF ImprestHeader.FINDFIRST THEN BEGIN
            ImprestHeader.CALCFIELDS(Amount);
            Difference := (ImprestHeader.Amount) - ActualSpent;
        END;
    end;


    procedure GetImprestSurrenderStatus("ImprestSurrenderNo.": Code[20]) ImprestSurrenderStatus: Text
    begin
        ImprestSurrenderStatus := '';

        ImprestSurrenderHeader.RESET;
        IF ImprestSurrenderHeader.GET("ImprestSurrenderNo.") THEN BEGIN
            ImprestSurrenderStatus := FORMAT(ImprestSurrenderHeader.Status);
        END;

        //Add GetImprestSurrenderGlobalDimension1Code
        /*GlobalDimension1Code:='';
        
        ImprestSurrenderHeader.RESET;
        IF ImprestSurrenderHeader.GET("ImprestSurrenderNo.") THEN BEGIN
          GlobalDimension1Code:=ImprestSurrenderHeader."Global Dimension 1 Code";
        END;*/

    end;


    procedure CreateImprestSurrenderLine("ImprestSurrenderNo.": Code[20]; ImprestCode: Code[50]; Description: Text; ActualAmountSpent: Decimal; GlobalDimension1Code: Code[20]; GlobalDimension2Code: Code[20]; ShortcutDimension3Code: Code[20]; ShortcutDimension4Code: Code[20]; ShortcutDimension5Code: Code[20]; ShortcutDimension6Code: Code[20]; ShortcutDimension7Code: Code[20]; ShortcutDimension8Code: Code[20]) ImprestSurrenderLineCreated: Boolean
    begin
        ImprestSurrenderLineCreated := FALSE;

        ImprestSurrenderHeader.RESET;
        ImprestSurrenderHeader.GET("ImprestSurrenderNo.");

        ImprestSurrenderLine.INIT;
        ImprestSurrenderLine."Line No." := 0;
        ImprestSurrenderLine."Document No." := "ImprestSurrenderNo.";
        ImprestSurrenderLine."Imprest Code" := ImprestCode;
        ImprestSurrenderLine.VALIDATE(ImprestSurrenderLine."Imprest Code");
        ImprestSurrenderLine.Description := Description;
        ImprestSurrenderLine."Actual Spent" := ActualAmountSpent;
        ImprestSurrenderLine.VALIDATE(ImprestSurrenderLine."Actual Spent");
        ImprestSurrenderLine."Global Dimension 1 Code" := GlobalDimension1Code;
        ImprestSurrenderLine."Global Dimension 2 Code" := GlobalDimension2Code;
        ImprestSurrenderLine."Shortcut Dimension 3 Code" := ShortcutDimension3Code;
        ImprestSurrenderLine."Shortcut Dimension 4 Code" := ShortcutDimension4Code;
        ImprestSurrenderLine."Shortcut Dimension 5 Code" := ShortcutDimension5Code;
        ImprestSurrenderLine."Shortcut Dimension 6 Code" := ShortcutDimension6Code;
        ImprestSurrenderLine."Shortcut Dimension 7 Code" := ShortcutDimension7Code;
        ImprestSurrenderLine."Shortcut Dimension 8 Code" := ShortcutDimension8Code;
        IF ImprestSurrenderLine.INSERT THEN BEGIN
            ImprestSurrenderLineCreated := TRUE;
        END;
    end;


    procedure ModifyImprestSurrenderLine("LineNo.": Integer; "ImprestSurrenderNo.": Code[20]; ImprestCode: Code[50]; Description: Text; ActualAmountSpent: Decimal; GlobalDimension1Code: Code[20]; GlobalDimension2Code: Code[20]; ShortcutDimension3Code: Code[20]; ShortcutDimension4Code: Code[20]; ShortcutDimension5Code: Code[20]; ShortcutDimension6Code: Code[20]; ShortcutDimension7Code: Code[20]; ShortcutDimension8Code: Code[20]) ImprestSurrenderLineModified: Boolean
    begin
        ImprestSurrenderLineModified := FALSE;

        ImprestSurrenderLine.RESET;
        ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Line No.", "LineNo.");
        ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Document No.", "ImprestSurrenderNo.");
        IF ImprestSurrenderLine.FINDFIRST THEN BEGIN
            ImprestSurrenderLine."Imprest Code" := ImprestCode;
            ImprestSurrenderLine.VALIDATE(ImprestSurrenderLine."Imprest Code");
            ImprestSurrenderLine.Description := Description;
            ImprestSurrenderLine."Actual Spent" := ActualAmountSpent;
            ImprestSurrenderLine.VALIDATE(ImprestSurrenderLine."Actual Spent");
            ImprestSurrenderLine."Global Dimension 2 Code" := GlobalDimension2Code;
            ImprestSurrenderLine."Shortcut Dimension 3 Code" := ShortcutDimension3Code;
            ImprestSurrenderLine."Shortcut Dimension 4 Code" := ShortcutDimension4Code;
            ImprestSurrenderLine."Shortcut Dimension 5 Code" := ShortcutDimension5Code;
            ImprestSurrenderLine."Shortcut Dimension 6 Code" := ShortcutDimension6Code;
            ImprestSurrenderLine."Shortcut Dimension 7 Code" := ShortcutDimension7Code;
            ImprestSurrenderLine."Shortcut Dimension 8 Code" := ShortcutDimension8Code;
            IF ImprestSurrenderLine.MODIFY THEN BEGIN
                ImprestSurrenderLineModified := TRUE;
            END;
        END;
    end;


    procedure DeleteImprestSurrenderLine("LineNo.": Integer; "ImprestSurrenderNo.": Code[20]) ImprestSurrenderLineDeleted: Boolean
    begin
        ImprestSurrenderLineDeleted := FALSE;

        ImprestSurrenderLine.RESET;
        ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Line No.", "LineNo.");
        ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Document No.", "ImprestSurrenderNo.");
        IF ImprestSurrenderLine.FINDFIRST THEN BEGIN
            IF ImprestSurrenderLine.DELETE THEN BEGIN
                ImprestSurrenderLineDeleted := TRUE;
            END;
        END;
    end;


    procedure CheckImprestSurrenderLinesExist("ImprestSurrenderNo.": Code[20]) ImprestSurrenderLinesExist: Boolean
    begin
        ImprestSurrenderLinesExist := FALSE;

        ImprestSurrenderLine.RESET;
        ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Document No.", "ImprestSurrenderNo.");
        IF ImprestSurrenderLine.FINDFIRST THEN BEGIN
            ImprestSurrenderLinesExist := TRUE;
        END;
    end;

    procedure ValidateImprestSurrenderLines("ImprestSurrenderNo.": Code[20]) ImprestSurrenderLinesError: Text
    var
        "ImprestSurrenderLineNo.": Integer;
    begin
        ImprestSurrenderLinesError := '';
        "ImprestSurrenderLineNo." := 0;

        ImprestSurrenderLine.RESET;
        ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Document No.", "ImprestSurrenderNo.");
        IF ImprestSurrenderLine.FINDSET THEN BEGIN
            REPEAT
                "ImprestSurrenderLineNo." := "ImprestSurrenderLineNo." + 1;
                IF ImprestSurrenderLine."Imprest Code" = '' THEN BEGIN
                    ImprestSurrenderLinesError := 'Imprest code missing on imprest surrender line no.' + FORMAT("ImprestSurrenderLineNo.") + ', it cannot be zero or empty';
                    BREAK;
                END;
            /*IF ImprestLine."Global Dimension 1 Code"='' THEN BEGIN
              ImprestLinesError:='Project code missing on imprest line no.'+FORMAT("ImprestLineNo.")+', it cannot be zero or empty';
              BREAK;
            END;*/

            UNTIL ImprestSurrenderLine.NEXT = 0;
        END;

    end;

    procedure CheckImprestSurrenderApprovalWorkflowEnabled("ImprestSurrenderNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;

        ImprestSurrenderHeader.RESET;
        IF ImprestSurrenderHeader.GET("ImprestSurrenderNo.") THEN
            ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckImprestSurrenderApprovalsWorkflowEnabled(ImprestSurrenderHeader);
    end;


    procedure SendImprestSurrenderApprovalRequest("ImprestSurrenderNo.": Code[20]) ImprestSurrenderApprovalRequestSent: Boolean
    var
        ApprovalEntry: Record 454;
    begin
        ImprestSurrenderApprovalRequestSent := FALSE;

        ImprestSurrenderHeader.RESET;
        IF ImprestSurrenderHeader.GET("ImprestSurrenderNo.") THEN BEGIN
            ApprovalsMgmtExt.OnSendImprestSurrenderHeaderForApproval(ImprestSurrenderHeader);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", ImprestSurrenderHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            IF ApprovalEntry.FINDFIRST THEN
                ImprestSurrenderApprovalRequestSent := TRUE;
        END;
    end;


    procedure CancelImprestSurrenderApprovalRequest("ImprestSurrenderNo.": Code[20]) ImprestSurrenderApprovalRequestCanceled: Boolean
    var
        ApprovalEntry: Record 454;
    begin
        ImprestSurrenderApprovalRequestCanceled := FALSE;

        ImprestSurrenderHeader.RESET;
        IF ImprestSurrenderHeader.GET("ImprestSurrenderNo.") THEN BEGIN
            ApprovalsMgmtExt.OnCancelImprestSurrenderHeaderApprovalRequest(ImprestSurrenderHeader);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", ImprestSurrenderHeader."No.");
            IF ApprovalEntry.FINDLAST THEN BEGIN
                IF ApprovalEntry.Status = ApprovalEntry.Status::Canceled THEN
                    ImprestSurrenderApprovalRequestCanceled := TRUE;
            END;
        END;
    end;

    procedure ReopenImprestSurrender("ImprestSurrenderNo.": Code[20]) ImprestSurrenderOpened: Boolean
    begin
        ImprestSurrenderOpened := FALSE;
        ImprestSurrenderHeader.RESET;
        ImprestSurrenderHeader.SETRANGE(ImprestSurrenderHeader."No.", "ImprestSurrenderNo.");
        IF ImprestSurrenderHeader.FINDFIRST THEN BEGIN
            //FundsApprovalManager.ReOpenImprestSurrenderHeader(ImprestSurrenderHeader);
            ImprestSurrenderOpened := TRUE;
        END;
    end;

    procedure CancelImprestSurrenderBudgetCommitment("ImprestSurrenderNo.": Code[20]) ImprestSurrenderBudgetCommitmentCanceled: Boolean
    var
        ApprovalEntry: Record 454;
    begin
        ImprestSurrenderBudgetCommitmentCanceled := FALSE;

        ImprestSurrenderHeader.RESET;
        IF ImprestSurrenderHeader.GET("ImprestSurrenderNo.") THEN BEGIN
            ImprestSurrenderBudgetCommitmentCanceled := TRUE;
        END;
    end;

    /* procedure ModifyImprestSurrenderUploadedDocumentLocalURL("DocumentNo.": Code[20]; DocumentCode: Code[50]; LocalURL: Text[250]) RequiredDocumentModified: Boolean
    var
        ImprestSurrenderDocuments: Record 50014;
    begin
        RequiredDocumentModified := FALSE;
        ImprestSurrenderDocuments.RESET;
        ImprestSurrenderDocuments.SETRANGE(ImprestSurrenderDocuments."DocumentNo.", "DocumentNo.");
        ImprestSurrenderDocuments.SETRANGE(ImprestSurrenderDocuments."Document Code", DocumentCode);
        IF ImprestSurrenderDocuments.FINDFIRST THEN BEGIN
            ImprestSurrenderDocuments."Local File URL" := LocalURL;
            ImprestSurrenderDocuments."Document Attached" := TRUE;
            IF ImprestSurrenderDocuments.MODIFY THEN
                RequiredDocumentModified := TRUE;
        END;
    end; */

    /* procedure CheckImprestSurrenderUploadedDocumentAttached("DocumentNo.": Code[20]) UploadedDocumentAttached: Boolean
    var
        ImprestSurrenderDocuments: Record 50014;
        Error0001: Label '%1 must be attached.';
    begin
        UploadedDocumentAttached := FALSE;
        ImprestSurrenderDocuments.RESET;
        ImprestSurrenderDocuments.SETRANGE(ImprestSurrenderDocuments."DocumentNo.", "DocumentNo.");
        IF ImprestSurrenderDocuments.FINDSET THEN BEGIN
            REPEAT
                IF ImprestSurrenderDocuments."Local File URL" = '' THEN
                    ERROR(Error0001, ImprestSurrenderDocuments."Document Description");
            UNTIL ImprestSurrenderDocuments.NEXT = 0;
            UploadedDocumentAttached := TRUE;
        END;
    end;

    procedure DeleteImprestSurrenderUploadedDocument("DocumentNo.": Code[20]) RequiredDocumentsDeleted: Boolean
    var
        ImprestSurrenderDocuments: Record 50014;
    begin
        RequiredDocumentsDeleted := FALSE;
        ImprestSurrenderDocuments.RESET;
        ImprestSurrenderDocuments.SETRANGE(ImprestSurrenderDocuments."DocumentNo.", "DocumentNo.");
        IF ImprestSurrenderDocuments.FINDSET THEN BEGIN
            ImprestSurrenderDocuments.DELETEALL;
            RequiredDocumentsDeleted := TRUE;
        END;
    end; */


    procedure ApproveImprestApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]) Approved: Text
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
            Approved := '200: Imprest Approved Successfully '
        ELSE
            Approved := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure RejectImprestApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]; RejectionComments: Text) Rejected: Text
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
            //   ApprovalsMgmtExt.RejectApprovalRequests(ApprovalEntry);
        END;
        COMMIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Entry No.", "EntryNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Rejected);
        IF ApprovalEntry.FINDFIRST THEN
            Rejected := '200: Imprest Rejected Successfully '
        ELSE
            Rejected := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;


        //**************************************** HR Leave Reimbursement ********************************************************************************************************************************************************
    end;
    /*
        
        procedure GetEmployeeImprestApprovalEntries(var ApprovalEntries: XMLport 50024; EmployeeNo: Code[20])
        var
            ApprovalEntry: Record 454;
            Employee: Record 5200;
        begin
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Imprest);
            IF EmployeeNo <> '' THEN BEGIN
                Employee.GET(EmployeeNo);
                Employee.TESTFIELD("User ID");
                ApprovalEntry.SETRANGE("Approver ID", Employee."User ID");
            END;
            IF ApprovalEntry.FINDFIRST THEN;
            ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
        end;

            
             procedure GetImprestApprovalEntries(var ApprovalEntries: XMLport 50024; LeaveNo: Code[20])
            var
                ApprovalEntry: Record 454;
                Employee: Record 5200;
            begin
                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Imprest);
                IF LeaveNo <> '' THEN BEGIN
                    ApprovalEntry.SETRANGE("Document No.", LeaveNo);
                END;
                IF ApprovalEntry.FINDFIRST THEN;
                ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
            end; */


    procedure ApproveImprestSurrApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]) Approved: Text
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
            //  ApprovalsMgmtExt.ApproveApprovalRequests(ApprovalEntry);
        END;
        COMMIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Entry No.", "EntryNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN
            Approved := '200: Imprest Surrender Approved Successfully '
        ELSE
            Approved := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure RejectImprestSurrApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]; RejectionComments: Text) Rejected: Text
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
            ApprovalEntry."Rejection Comments" := RejectionComments;
            ApprovalEntry."Web Portal Approval" := TRUE;
            ApprovalEntry.MODIFY;

            //     ApprovalsMgmtExt.RejectApprovalRequests(ApprovalEntry);
        END;
        COMMIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Entry No.", "EntryNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Rejected);
        IF ApprovalEntry.FINDFIRST THEN
            Rejected := '200: Imprest Surrender Rejected Successfully '
        ELSE
            Rejected := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;


        //**************************************** HR Leave Reimbursement ********************************************************************************************************************************************************
    end;

    /*  
     procedure GetEmployeeImprestSurrApprovalEntries(var ApprovalEntries: XMLport 50024; EmployeeNo: Code[20])
     var
         ApprovalEntry: Record 454;
         Employee: Record 5200;
     begin
         ApprovalEntry.RESET;
         ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::"Imprest Surrender");
         IF EmployeeNo <> '' THEN BEGIN
             Employee.GET(EmployeeNo);
             Employee.TESTFIELD("User ID");
             ApprovalEntry.SETRANGE("Approver ID", Employee."User ID");
         END;
         IF ApprovalEntry.FINDFIRST THEN;
         ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
     end;

     
     procedure GetImprestSurrApprovalEntries(var ApprovalEntries: XMLport 50024; LeaveNo: Code[20])
     var
         ApprovalEntry: Record 454;
         Employee: Record 5200;
     begin
         ApprovalEntry.RESET;
         ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::"Imprest Surrender");
         IF LeaveNo <> '' THEN BEGIN
             ApprovalEntry.SETRANGE("Document No.", LeaveNo);
         END;
         IF ApprovalEntry.FINDFIRST THEN;
         ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
     end; */


    procedure PrintImprest(ImprestNo: Code[20]) ServerPath: Text
    var
        ImprestVoucher: Report 50005;
        Filename: Text;
        PortalSetup: Record "Portal Setup";
        Filepath: Text;
        ImprestHeader: Record 50008;
    begin
        PortalSetup.RESET;
        PortalSetup.GET;
        // PortalSetup.TESTFIELD("Serial No");
        //PortalSetup.TESTFIELD("Item No");
        Filename := ImprestNo + '_' + 'ImprestApplication.pdf';
        // Filepath := PortalSetup."Item No" + Filename;
        /*  IF FILE.EXISTS(Filepath) THEN
             FILE.ERASE(Filepath);

         ImprestHeader.RESET;
         ImprestHeader.SETRANGE("No.", ImprestNo);
         ImprestVoucher.SETTABLEVIEW(ImprestHeader);
         ImprestVoucher.SAVEASPDF(Filepath);
         IF FILE.EXISTS(Filepath) THEN
             ServerPath := PortalSetup."Serial No" + Filename
         ELSE
             ERROR('There was an Error. Please Try again'); */
    end;


    procedure PrintPettyCash(ImprestNo: Code[20]) ServerPath: Text
    var
        ImprestVoucher: Report 50205;
        Filename: Text;
        PortalSetup: Record "Portal Setup";
        Filepath: Text;
        ImprestHeader: Record 50008;
    begin
        PortalSetup.RESET;
        PortalSetup.GET;
        //   PortalSetup.TESTFIELD("Serial No");
        //  PortalSetup.TESTFIELD("Item No");
        Filename := ImprestNo + '_' + 'PettyCashApplication.pdf';
        //   Filepath := PortalSetup."Item No" + Filename;
        /*   IF FILE.e.EXISTS(Filepath) THEN
              FILE.ERASE(Filepath);

          ImprestHeader.RESET;
          ImprestHeader.SETRANGE("No.", ImprestNo);
          ImprestVoucher.SETTABLEVIEW(ImprestHeader);
          ImprestVoucher.SAVEASPDF(Filepath);
          IF FILE.EXISTS(Filepath) THEN
              ServerPath := PortalSetup."Serial No" + Filename
          ELSE
              ERROR('There was an Error. Please Try again'); */
    end;
    /*
        
         procedure GetGlobalDimension1Codes(var DepartmentCodes: XMLport 50034)
        begin
            DimensionValue.RESET;
            DimensionValue.SETRANGE("Global Dimension No.", 1);
            IF DimensionValue.FINDFIRST THEN;
            DepartmentCodes.SETTABLEVIEW(DimensionValue);
        end; */


    procedure DelegateApprovalRequestFromPortal(DocNo: Code[20]) RecordDelegated: Boolean
    var
        ApprovalEntry: Record 454;
        EmployeeRec: Record 5200;
    begin
        ApprovalEntry.RESET;
        //ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID",USERID);
        ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", DocNo);
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            //  ApprovalsMgmtExt.DelegateApprovalRequests(ApprovalEntry);
        END;
    end;


    procedure CreateOvertimeLine("ImprestNo.": Code[20]; Overtimedate: Date; Description: Text; noofhours: Decimal; BankName: Text; BankBranch: Text; BankAccNo: Code[20]) ImprestLineCreated: Text
    var
        HREmployee: Record 5200;
    begin
        ImprestLineCreated := '';

        ImprestHeader.RESET;
        ImprestHeader.GET("ImprestNo.");

        ImprestLine.INIT;
        ImprestLine."Line No." := 0;
        ImprestLine."Document No." := "ImprestNo.";
        ImprestLine.Description := Description;
        ImprestLine."Overtime Date" := Overtimedate;
        ImprestLine.VALIDATE(ImprestLine."Overtime Date");
        ImprestLine.VALIDATE(Quantity, noofhours);





        IF ImprestLine.INSERT THEN BEGIN
            ImprestLineCreated := '200: Overtime Line Successfully Created';
        END ELSE
            ImprestLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyOvertimeLine("LineNo.": Integer; "ImprestNo.": Code[20]; Overtimedate: Date; Description: Text; noofhours: Decimal; BankName: Text; BankBranch: Text; BankAccNo: Code[20]) ImprestLineModified: Boolean
    begin
        ImprestLineModified := FALSE;

        ImprestLine.RESET;
        ImprestLine.SETRANGE(ImprestLine."Line No.", "LineNo.");
        ImprestLine.SETRANGE(ImprestLine."Document No.", "ImprestNo.");
        IF ImprestLine.FINDFIRST THEN BEGIN
            ImprestLine."Overtime Date" := Overtimedate;
            ImprestLine.VALIDATE(ImprestLine."Overtime Date");
            ImprestLine.VALIDATE(Quantity, noofhours);

            ImprestLine.Description := Description;

            ImprestHeader.RESET;
            ImprestHeader.SETRANGE(ImprestHeader."No.", "ImprestNo.");
            IF ImprestHeader.FINDFIRST THEN BEGIN
                ImprestLine."Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
                ImprestLine."Global Dimension 2 Code" := ImprestHeader."Global Dimension 2 Code";
                ImprestLine."Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
            END;
            IF ImprestLine.MODIFY THEN BEGIN
                ImprestLineModified := TRUE;
            END;
        END;
    end;


    procedure DeleteOvertimeLine("LineNo.": Integer; "ImprestNo.": Code[20]) ImprestLineDeleted: Boolean
    begin
        ImprestLineDeleted := FALSE;

        ImprestLine.RESET;
        ImprestLine.SETRANGE(ImprestLine."Line No.", "LineNo.");
        ImprestLine.SETRANGE(ImprestLine."Document No.", "ImprestNo.");
        IF ImprestLine.FINDFIRST THEN BEGIN
            IF ImprestLine.DELETE THEN BEGIN
                ImprestLineDeleted := TRUE;
            END;
        END;
    end;
    /* 
        
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
        end; */


    procedure CheckEmployeeCanCreateForOthers(Employeeno: Code[10]) CanCreate: Boolean
    begin
        CanCreate := TRUE
    end;
    /*
       
       procedure GetImprestCreeatedByList(var ImprestsExportandImport: XMLport 50016; EmployeeNo: Code[20]; CreatedBy: Code[20])
       begin
           IF EmployeeNo <> '' THEN BEGIN
               ImprestHeader2.RESET;
               ImprestHeader2.SETFILTER("Employee No.", '<>%1', EmployeeNo);
               ImprestHeader2.SETFILTER("Created By", CreatedBy);
               IF ImprestHeader2.FINDFIRST THEN;
               ImprestsExportandImport.SETTABLEVIEW(ImprestHeader2);
           END
       end; */
}


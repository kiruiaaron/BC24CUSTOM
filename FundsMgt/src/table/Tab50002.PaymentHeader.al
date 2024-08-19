table 50002 "Payment Header"
{
    Caption = 'Payment Header';
    DrillDownPageID = 51336;
    LookupPageID = 51336;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt,Funds Transfer,Imprest,Imprest Surrender';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Receipt,"Funds Transfer",Imprest,"Imprest Surrender";
        }
        field(3; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            Editable = true;
            OptionCaption = ' ,Cheque,EFT,RTGS,MPESA,Cash';
            OptionMembers = " ",Cheque,EFT,RTGS,MPESA,Cash;

            trigger OnValidate()
            begin
                "Bank Account No." := '';
                "Bank Account Name" := '';
                "Cheque No." := '';
            end;
        }
        field(6; "Payment Type"; Option)
        {
            Caption = '"Payment Type"';
            Editable = true;
            OptionCaption = '"Cheque Payment",Cash Payment,EFT,RTGS,MPESA,Project Payment';
            OptionMembers = "Cheque Payment","Cash Payment",EFT,RTGS,MPESA,"Project Payment";
        }
        field(7; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account"."No.";

            /*  IF ("Payment Type"=CONST("Cash Payment")) "Bank Account"."No."
                             ELSE IF ("Payment Type"=CONST("Cheque Payment")) "Bank Account"."No." WHERE ("Bank Account Type"=FILTER(Normal|"Credit Card"|"Mobile Banking"))
                             ELSE IF ("Payment Type"=CONST("Project Payment")) "Bank Account"."No." WHERE (Bank Account Type=FILTER(Normal|Credit Card|Mobile Banking));
  */
            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
                TESTFIELD("Payment Mode");
                TESTFIELD("Posting Date");

                "Bank Account Name" := '';

                "Cheque No." := '';

                /*ChequeRegisterLines.RESET;
                ChequeRegisterLines.SETRANGE(ChequeRegisterLines."Bank  Account No.","Bank Account No.");
                ChequeRegisterLines.SETRANGE(ChequeRegisterLines.Status,ChequeRegisterLines.Status::Approved);
                ChequeRegisterLines.SETRANGE(ChequeRegisterLines."PV Posted with Cheque",FALSE);
                IF ChequeRegisterLines.FINDSET THEN BEGIN
                  REPEAT
                  ChequeRegisterLines."Assigned to PV":=FALSE;
                  ChequeRegisterLines.MODIFY;
                  UNTIL ChequeRegisterLines.NEXT=0;
                END;
                */

                BankAccount.RESET;
                BankAccount.SETRANGE(BankAccount."No.", "Bank Account No.");
                IF BankAccount.FINDFIRST THEN BEGIN
                    "Bank Account Name" := BankAccount.Name;
                    "Currency Code" := BankAccount."Currency Code";
                    VALIDATE("Currency Code");
                END;

                //Insert Cheque Number if paymode is cheque\

                IF "Payment Mode" = "Payment Mode"::Cheque THEN
                    ChequeRegisterLines.RESET;
                ChequeRegisterLines.SETRANGE(ChequeRegisterLines."Bank  Account No.", "Bank Account No.");
                ChequeRegisterLines.SETRANGE(ChequeRegisterLines.Status, ChequeRegisterLines.Status::Approved);
                ChequeRegisterLines.SETRANGE(ChequeRegisterLines."Assigned to PV", FALSE);
                IF ChequeRegisterLines.FINDFIRST THEN BEGIN
                    "Cheque No." := ChequeRegisterLines."Cheque No.";
                    ChequeRegisterLines."Assigned to PV" := TRUE;
                    ChequeRegisterLines.MODIFY;
                END;

            end;
        }
        field(8; "Bank Account Name"; Text[100])
        {
            Caption = 'Bank Account Name';
            Editable = false;
        }
        field(9; "Bank Account Balance"; Decimal)
        {
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE("Bank Account No." = FIELD("Bank Account No.")));
            Caption = 'Bank Account Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Cheque Type"; Option)
        {
            Caption = 'Cheque Type';
            OptionCaption = ' ,Computer Cheque,Manual Cheque';
            OptionMembers = " ","Computer Cheque","Manual Cheque";
        }
        field(11; "Reference No."; Code[20])
        {
            Caption = 'Reference No.';

            trigger OnValidate()
            begin
                /*PaymentHeader.RESET;
                PaymentHeader.SETRANGE(PaymentHeader."Reference No.","Reference No.");
                PaymentHeader.SETRANGE(PaymentHeader."Bank Account No.","Bank Account No.");
                IF PaymentHeader.FINDFIRST THEN BEGIN
                   ERROR(ErrorUsedReferenceNumber,PaymentHeader."No.");
                END;
                BankAccountLedgerEntry.RESET;
                BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."External Document No.","Reference No.");
                IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                  ERROR(ErrorUsedReferenceNumber,BankAccountLedgerEntry."Document No.");
                END;
                */

            end;
        }
        field(12; "Payee Type"; Option)
        {
            Caption = 'Payee Type';
            OptionCaption = ' ,Vendor,Employee,Claim,Imprest,Imprest Surrender';
            OptionMembers = " ",Vendor,Employee,Claim,Imprest,"Imprest Surrender";
        }
        field(13; "Payee No."; Code[20])
        {
            Caption = 'Payee No.';
            TableRelation = IF ("Payee Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Payee Type" = CONST(Employee)) Employee
            ELSE
            IF ("Payee Type" = CONST(Claim)) "Funds Claim Header" WHERE(Posted = CONST(false),
                                                                                          Status = CONST(Released))
            ELSE
            IF ("Payee Type" = CONST(Imprest)) "Imprest Header" WHERE(Posted = CONST(false),
                                                                                                                                                      Status = CONST(Approved))
            ELSE
            IF ("Payee Type" = CONST("Imprest Surrender")) "Imprest Surrender Header" WHERE(Difference = FILTER(< 0),
                                                                                                                                                                                                                                      Status = CONST(Released));

            trigger OnValidate()
            begin
                StaffEmps.GET("Payee No.");
                "Payee Name" := StaffEmps."First Name" + ' ' + StaffEmps."Middle Name" + ' ' + StaffEmps."Last Name";
            end;
        }
        field(14; "Payee Name"; Text[100])
        {
            Caption = 'Payee Name';

            trigger OnValidate()
            begin
                "Payee Name" := UPPERCASE("Payee Name");
            end;
        }
        field(15; "On Behalf Of"; Text[100])
        {
            Caption = 'On Behalf Of';
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TESTFIELD("Bank Account No.");
                TESTFIELD("Posting Date");
                IF "Currency Code" <> '' THEN BEGIN

                    IF BankAccount.GET("Bank Account No.") THEN BEGIN
                        BankAccount.TESTFIELD(BankAccount."Currency Code", "Currency Code");
                        "Currency Factor" := CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                    END;
                END ELSE BEGIN
                    IF BankAccount.GET("Bank Account No.") THEN BEGIN
                        BankAccount.TESTFIELD(BankAccount."Currency Code", '');
                    END;
                END;
            end;
        }
        field(17; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(18; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Total Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount Incl. VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Total Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Total Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount Incl. VAT(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "VAT Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."VAT Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'VAT Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "VAT Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."VAT Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'VAT Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "WithHolding Tax Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Withholding Tax Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'WithHolding Tax Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "WithHolding Tax Amount(LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Line"."Withholding Tax Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'WithHolding Tax Amount(LCY)';
            Editable = false;

        }
        field(24; "Withholding VAT Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Withholding VAT Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Withholding VAT Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Withholding VAT Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Withholding VAT Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Withholding VAT Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Net Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Line"."Net Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Net Amount';
            Editable = false;

        }
        field(39; "Net Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Net Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Net Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(49; Description; Text[150])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                Description := UPPERCASE(Description);
            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                //Delete the previous dimensions
                /*"Global Dimension 2 Code":='';
                "Shortcut Dimension 3 Code":='';
                "Shortcut Dimension 4 Code":='';
                "Shortcut Dimension 5 Code":='';
                "Shortcut Dimension 6 Code":='';
                "Shortcut Dimension 7 Code":='';
                "Shortcut Dimension 8 Code":='';
                
                PaymentLine.RESET;
                PaymentLine.SETRANGE(PaymentLine."Document No.","No.");
                IF PaymentLine.FINDSET THEN BEGIN
                  REPEAT
                    PaymentLine."Global Dimension 2 Code":='';
                    PaymentLine."Shortcut Dimension 3 Code":='';
                    PaymentLine."Shortcut Dimension 4 Code":='';
                    PaymentLine."Shortcut Dimension 5 Code":='';
                    PaymentLine."Shortcut Dimension 6 Code":='';
                    PaymentLine."Shortcut Dimension 7 Code":='';
                    PaymentLine."Shortcut Dimension 8 Code":='';
                    PaymentLine.MODIFY;
                  UNTIL PaymentLine.NEXT=0;
                END;
                //End delete the previous dimensions
                
                PaymentLine.RESET;
                PaymentLine.SETRANGE(PaymentLine."Document No.","No.");
                IF PaymentLine.FINDSET THEN BEGIN
                  REPEAT
                    PaymentLine."Global Dimension 1 Code":="Global Dimension 1 Code";
                    PaymentLine.MODIFY;
                  UNTIL PaymentLine.NEXT=0;
                END;*/

            end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Posted,Reversed;

            trigger OnValidate()
            begin
                /*IF Status=Status::Released THEN BEGIN
                 //Send email to supplier
                  PaymentLine.RESET;
                  PaymentLine.SETRANGE(PaymentLine."Document No.","No.");
                  PaymentLine.SETRANGE(PaymentLine."Account Type",PaymentLine."Account Type"::Vendor);
                  IF PaymentLine.FINDFIRST THEN BEGIN
                   FundsManagement.SendVendorEmail(PaymentLine."Document No.",PaymentLine."Account No.",PaymentLine."Net Amount");
                  END;
                END;
                */


                PaymentLine.RESET;
                PaymentLine.SETRANGE(PaymentLine."Document No.", "No.");
                IF PaymentLine.FINDSET THEN BEGIN
                    REPEAT
                        PaymentLine.Status := Rec.Status;
                        IF Rec.Status = Rec.Status::Posted THEN BEGIN
                            PaymentLine.Posted := TRUE;
                            PaymentLine."Posted By" := USERID;
                            PaymentLine."Date Posted" := TODAY;
                            PaymentLine."Time Posted" := TIME;
                        END;
                        PaymentLine.MODIFY;
                    UNTIL PaymentLine.NEXT = 0;
                END;

            end;
        }
        field(71; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(72; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(73; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            Editable = false;
        }
        field(74; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            Editable = false;
        }
        field(75; Reversed; Boolean)
        {
            Caption = 'Reversed';
            Editable = false;
        }
        field(76; "Reversed By"; Code[50])
        {
            Caption = 'Reversed By';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(77; "Reversal Date"; Date)
        {
            Caption = 'Reversal Date';
            Editable = false;
        }
        field(78; "Reversal Time"; Time)
        {
            Caption = 'Reversal Time';
            Editable = false;
        }
        field(80; "Reversal Posting Date"; Date)
        {
        }
        field(81; "Cheque No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            begin
                "Reference No." := "Cheque No.";
            end;
        }
        field(99; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(100; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(101; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
        }
        field(102; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
        }
        field(103; "Payee Bank Account Name"; Text[100])
        {
            Editable = false;
        }
        field(104; "Payee Bank Account No."; Code[20])
        {
            Editable = false;
        }
        field(105; "MPESA/Paybill Account No."; Code[20])
        {
            Editable = false;
        }
        field(106; "Payee Bank Code"; Code[20])
        {
        }
        field(107; "Payee Bank Name"; Text[80])
        {
            Editable = false;
        }
        field(108; "Loan Disbursement Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Investment Loan,Staff Loan,Equity';
            OptionMembers = " ","Investment Loan","Staff Loan",Equity;
        }
        field(50000; "Retention Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Retention Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Retention Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52137123; "Payroll Payment"; Boolean)
        {
        }
        field(52137124; "Loan Disbursement No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137125; "Loan No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137126; "Loan Disbursement"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //TESTFIELD(Status,Status::Open);

        PaymentLine.RESET;
        PaymentLine.SETRANGE(PaymentLine."Document No.", "No.");
        IF PaymentLine.FINDSET THEN
            PaymentLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            IF "Payment Type" = "Payment Type"::"Cheque Payment" THEN BEGIN//"Cheque Payment"s
                FundsSetup.GET;
                FundsSetup.TESTFIELD(FundsSetup."Payment Voucher Nos.");
                NoSeriesMgt.InitSeries(FundsSetup."Payment Voucher Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            END;
            IF "Payment Type" = "Payment Type"::"Cash Payment" THEN BEGIN//Cash Payments
                FundsSetup.GET;
                FundsSetup.TESTFIELD(FundsSetup."Cash Voucher Nos.");
                NoSeriesMgt.InitSeries(FundsSetup."Cash Voucher Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            END;
            IF "Payment Type" = "Payment Type"::"Project Payment" THEN BEGIN//Project Payments
                FundsSetup.GET;
                FundsSetup.TESTFIELD(FundsSetup."Projects Nos");
                NoSeriesMgt.InitSeries(FundsSetup."Projects Nos", xRec."No. Series", 0D, "No.", "No. Series");
            END;
        END;
        "Document Type" := "Document Type"::Payment;
        "Document Date" := TODAY;
        "User ID" := USERID;
        "Posting Date" := TODAY;
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Status,Status::Open);
    end;

    var
        FundsSetup: Record 50031;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        "G/LAccount": Record 15;
        BankAccount: Record 270;
        Customer: Record 18;
        Vendor: Record 23;
        FixedAsset: Record 5600;
        ICPartner: Record 413;
        BankAccountLedgerEntry: Record 271;
        Employee: Record 5200;
        PaymentHeader: Record 50002;
        PaymentLine: Record "Payment Line";
        CurrExchRate: Record 330;
        ErrorUsedReferenceNumber: Label 'The Reference Number has been used for Payment No:%1';
        FundsManagement: Codeunit 50045;
        ChequeRegisterLines: Record 50025;
        //EmployeeLoanDisbursement: Record 50076;
        //HRLoanProduct: Record 50088;
        ClaimHeader: Record 50012;
        StaffEmps: Record 5200;
        ImprestSurrender: Record 50010;
        ImportedBankPayments: Record 50024;
        FundsTransCodes: Record 50027;
        ImprestHeader: Record 50008;
        LineNo: Integer;
        Txt060: Label 'Payment Lines Created Successfully';
        Text100: Label 'Imprest Allowance for employee: :';
        Text105: Label 'Imprest Surrender Claim by :';
        Txt055: Label 'Reference No already receipted by Receipt No:';
        Txt056: Label 'Reference Number not found in Bank Statement for Paymode:';
        Text4100: Label 'Reference No.';
        ClaimLines: Record 50013;

    local procedure TestStatusOpen(AllowApproverEdit: Boolean)
    var
        PaymentHeader: Record 50002;
        ApprovalEntry: Record 454;
    begin
        PaymentHeader.GET("No.");
        IF AllowApproverEdit THEN BEGIN
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", PaymentHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", USERID);
            IF NOT ApprovalEntry.FINDFIRST THEN BEGIN
                PaymentHeader.TESTFIELD(Status, PaymentHeader.Status::Open);
            END;
        END ELSE BEGIN
            PaymentHeader.TESTFIELD(Status, PaymentHeader.Status::Open);
        END;
    end;


    procedure AssistEdit(): Boolean
    begin
        FundsSetup.GET;
        FundsSetup.TESTFIELD("Payment Voucher Reference Nos.");
        IF NoSeriesMgt.SelectSeries(FundsSetup."Payment Voucher Reference Nos.", xRec."No. Series", "No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            EXIT(TRUE);
        END;
    end;

    local procedure InsertImprestLines(PayeeNo: Code[20]; DocumentNo: Code[20])
    begin
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", DocumentNo);
        IF PaymentLine.FINDSET THEN
            PaymentLine.DELETEALL;

        ImprestHeader.RESET;
        ImprestHeader.SETRANGE("No.", PayeeNo);
        IF ImprestHeader.FINDFIRST THEN BEGIN
            ImprestHeader.CALCFIELDS(ImprestHeader.Amount);
            PaymentHeader.RESET;
            PaymentHeader.SETRANGE("No.", DocumentNo);
            IF PaymentHeader.FINDFIRST THEN BEGIN
                PaymentHeader."Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
                PaymentHeader."Global Dimension 2 Code" := ImprestHeader."Global Dimension 2 Code";
                PaymentHeader."Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
                PaymentHeader."Shortcut Dimension 4 Code" := ImprestHeader."Shortcut Dimension 4 Code";
                PaymentHeader."Shortcut Dimension 5 Code" := ImprestHeader."Shortcut Dimension 5 Code";
                PaymentHeader."Shortcut Dimension 6 Code" := ImprestHeader."Shortcut Dimension 6 Code";
                PaymentHeader."Shortcut Dimension 8 Code" := ImprestHeader."Shortcut Dimension 7 Code";
            END;
            LineNo := 10000;
            PaymentLine.INIT;
            PaymentLine."Line No." := LineNo;
            //PaymentLine."Payment Code":=
            PaymentLine."Account Type" := PaymentLine."Account Type"::Employee;
            PaymentLine."Document No." := DocumentNo;
            PaymentLine."Account No." := ImprestHeader."Employee No.";
            PaymentLine."Account Name" := ImprestHeader."Employee Name";
            PaymentLine.Description := Text100 + ImprestHeader."Employee Name";   //ImprestHeader.Description;
            PaymentLine."Total Amount" := ImprestHeader.Amount;
            PaymentLine.VALIDATE(PaymentLine."Total Amount");
            PaymentLine."Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
            PaymentLine."Global Dimension 2 Code" := ImprestHeader."Global Dimension 2 Code";
            PaymentLine."Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
            PaymentLine."Shortcut Dimension 4 Code" := ImprestHeader."Shortcut Dimension 4 Code";
            PaymentLine."Shortcut Dimension 5 Code" := ImprestHeader."Shortcut Dimension 5 Code";
            PaymentLine."Shortcut Dimension 6 Code" := ImprestHeader."Shortcut Dimension 6 Code";
            PaymentLine."Shortcut Dimension 8 Code" := ImprestHeader."Shortcut Dimension 7 Code";
            PaymentLine.INSERT;
        END;
        //MESSAGE(Txt060);
    end;

    local procedure InsertClaimLines(PayeeNo: Code[20]; DocumentNo: Code[20])
    var
        AccountNo: Code[20];
    begin
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", DocumentNo);
        IF PaymentLine.FINDSET THEN
            PaymentLine.DELETEALL;

        ClaimLines.RESET;
        ClaimLines.SETRANGE("Document No.", PayeeNo);
        IF ClaimLines.FINDSET THEN BEGIN
            ClaimHeader.RESET;
            ClaimHeader.SETRANGE("No.", PayeeNo);
            IF ClaimHeader.FINDFIRST THEN BEGIN
                ClaimHeader."Global Dimension 1 Code" := ClaimLines."Global Dimension 1 Code";
                ClaimHeader."Global Dimension 2 Code" := ClaimLines."Global Dimension 2 Code";
                ClaimHeader."Shortcut Dimension 3 Code" := ClaimLines."Shortcut Dimension 3 Code";
                ClaimHeader."Shortcut Dimension 4 Code" := ClaimLines."Shortcut Dimension 4 Code";
                ClaimHeader."Shortcut Dimension 5 Code" := ClaimLines."Shortcut Dimension 5 Code";
                ClaimHeader."Shortcut Dimension 6 Code" := ClaimLines."Shortcut Dimension 6 Code";
                ClaimHeader."Shortcut Dimension 8 Code" := ClaimLines."Shortcut Dimension 7 Code";
                AccountNo := ClaimHeader."Payee No.";
            END;
            LineNo := 10000;
            REPEAT
                LineNo += 1;
                PaymentLine.INIT;
                PaymentLine."Line No." := LineNo;
                PaymentLine."Payment Code" := ClaimLines."Funds Claim Code";
                PaymentLine."Document No." := DocumentNo;
                PaymentLine."Account Type" := PaymentLine."Account Type"::"G/L Account";
                PaymentLine."Account No." := ClaimLines."Account No.";
                PaymentLine."Account Name" := ClaimLines."Account Name";
                PaymentLine.Description := ClaimLines.Description;
                PaymentLine."Total Amount" := ClaimLines.Amount;
                PaymentLine.VALIDATE(PaymentLine."Total Amount");
                PaymentLine."Global Dimension 1 Code" := ClaimLines."Global Dimension 1 Code";
                PaymentLine."Global Dimension 2 Code" := ClaimLines."Global Dimension 2 Code";
                PaymentLine."Shortcut Dimension 3 Code" := ClaimLines."Shortcut Dimension 3 Code";
                PaymentLine."Shortcut Dimension 4 Code" := ClaimLines."Shortcut Dimension 4 Code";
                PaymentLine."Shortcut Dimension 5 Code" := ClaimLines."Shortcut Dimension 5 Code";
                PaymentLine."Shortcut Dimension 6 Code" := ClaimLines."Shortcut Dimension 6 Code";
                PaymentLine."Shortcut Dimension 8 Code" := ClaimLines."Shortcut Dimension 7 Code";
                PaymentLine.INSERT;
            UNTIL ClaimLines.NEXT = 0;
        END;
        //MESSAGE(Txt060);
    end;

    local procedure InsertImprestSurrenderLines(PayeeNo: Code[20]; DocumentNo: Code[20])
    begin
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", DocumentNo);
        IF PaymentLine.FINDSET THEN
            PaymentLine.DELETEALL;

        ImprestSurrender.RESET;
        ImprestSurrender.SETRANGE("No.", PayeeNo);
        IF ImprestSurrender.FINDFIRST THEN BEGIN
            ImprestSurrender.CALCFIELDS(ImprestSurrender.Difference);
            PaymentHeader.RESET;
            PaymentHeader.SETRANGE("No.", DocumentNo);
            IF PaymentHeader.FINDFIRST THEN BEGIN
                PaymentHeader."Global Dimension 1 Code" := ImprestSurrender."Global Dimension 1 Code";
                PaymentHeader."Global Dimension 2 Code" := ImprestSurrender."Global Dimension 2 Code";
                PaymentHeader."Shortcut Dimension 3 Code" := ImprestSurrender."Shortcut Dimension 3 Code";
                PaymentHeader."Shortcut Dimension 4 Code" := ImprestSurrender."Shortcut Dimension 4 Code";
                PaymentHeader."Shortcut Dimension 5 Code" := ImprestSurrender."Shortcut Dimension 5 Code";
                PaymentHeader."Shortcut Dimension 6 Code" := ImprestSurrender."Shortcut Dimension 6 Code";
                PaymentHeader."Shortcut Dimension 8 Code" := ImprestSurrender."Shortcut Dimension 7 Code";
            END;
            LineNo := 10000;
            PaymentLine.INIT;
            PaymentLine."Line No." := LineNo;
            //PaymentLine."Payment Code":=
            PaymentLine."Account Type" := PaymentLine."Account Type"::Employee;
            PaymentLine."Document No." := DocumentNo;
            PaymentLine."Account No." := ImprestSurrender."Employee No.";
            PaymentLine."Account Name" := ImprestSurrender."Employee Name";
            PaymentLine.Description := Text105 + ImprestSurrender."Employee Name";   //ImprestHeader.Description;
            PaymentLine."Total Amount" := ImprestSurrender.Difference * -1;
            PaymentLine.VALIDATE(PaymentLine."Total Amount");
            PaymentLine."Global Dimension 1 Code" := ImprestSurrender."Global Dimension 1 Code";
            PaymentLine."Global Dimension 2 Code" := ImprestSurrender."Global Dimension 2 Code";
            PaymentLine."Shortcut Dimension 3 Code" := ImprestSurrender."Shortcut Dimension 3 Code";
            PaymentLine."Shortcut Dimension 4 Code" := ImprestSurrender."Shortcut Dimension 4 Code";
            PaymentLine."Shortcut Dimension 5 Code" := ImprestSurrender."Shortcut Dimension 5 Code";
            PaymentLine."Shortcut Dimension 6 Code" := ImprestSurrender."Shortcut Dimension 6 Code";
            PaymentLine."Shortcut Dimension 8 Code" := ImprestSurrender."Shortcut Dimension 7 Code";
            PaymentLine.INSERT;
        END;
        //MESSAGE(Txt060);
    end;
}


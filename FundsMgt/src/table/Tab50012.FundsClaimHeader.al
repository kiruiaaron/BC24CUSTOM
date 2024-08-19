table 50012 "Funds Claim Header"
{
    Caption = 'Funds Claim Header';
    DrillDownPageID = 50032;
    LookupPageID = 50032;

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
        }
        field(6; "Payment Type"; Option)
        {
            Caption = '"Payment Type"';
            Editable = false;
            OptionCaption = '"Cheque Payment",Cash Payment,EFT,RTGS,MPESA';
            OptionMembers = "Cheque Payment","Cash Payment",EFT,RTGS,MPESA;
        }
        field(7; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                TESTFIELD("Posting Date");

                "Bank Account Name" := '';
                "Currency Code" := '';
                VALIDATE("Currency Code");

                BankAccount.RESET;
                BankAccount.SETRANGE(BankAccount."No.", "Bank Account No.");
                IF BankAccount.FINDFIRST THEN BEGIN
                    "Bank Account Name" := BankAccount.Name;
                    "Currency Code" := BankAccount."Currency Code";
                    VALIDATE("Currency Code");
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
                BankAccountLedgerEntry.RESET;
                BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."External Document No.", "Reference No.");
                IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                    ERROR(ErrorUsedReferenceNumber, BankAccountLedgerEntry."Document No.");
                END;
            end;
        }
        field(12; "Payee Type"; Option)
        {
            Caption = 'Payee Type';
            OptionCaption = ' ,Employee';
            OptionMembers = " ",Employee;
        }
        field(13; "Payee No."; Code[20])
        {
            Caption = 'Payee No.';
            TableRelation = IF ("Payee Type" = CONST(Employee)) Employee;

            trigger OnValidate()
            begin
                "Payee Name" := '';
                IF "Payee Type" = "Payee Type"::Employee THEN BEGIN
                    Employee.RESET;
                    Employee.SETRANGE(Employee."No.", "Payee No.");
                    IF Employee.FINDFIRST THEN BEGIN
                        "Payee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                        FundsClaimLine.RESET;
                        FundsClaimLine.SETRANGE(FundsClaimLine."Document No.", "No.");
                        FundsClaimLine.SETRANGE(FundsClaimLine."Account Type", FundsClaimLine."Account Type"::Employee);
                        IF FundsClaimLine.FINDSET THEN BEGIN
                            REPEAT
                                FundsClaimLine."Account No." := Employee."No.";
                                FundsClaimLine.VALIDATE(FundsClaimLine."Account No.");
                            UNTIL FundsClaimLine.NEXT = 0;
                        END;

                    END;
                END;
                VALIDATE("Payee Name");
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
        field(18; Amount; Decimal)
        {
            CalcFormula = Sum("Funds Claim Line".Amount WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Funds Claim Line"."Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Net Amount"; Decimal)
        {
            CalcFormula = Sum("Funds Claim Line"."Net Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Net Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Net Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Funds Claim Line"."Net Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Net Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(49; Description; Text[100])
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
                "Global Dimension 2 Code" := '';
                "Shortcut Dimension 3 Code" := '';
                "Shortcut Dimension 4 Code" := '';
                "Shortcut Dimension 5 Code" := '';
                "Shortcut Dimension 6 Code" := '';
                "Shortcut Dimension 7 Code" := '';
                "Shortcut Dimension 8 Code" := '';
                FundsClaimLine.RESET;
                FundsClaimLine.SETRANGE(FundsClaimLine."Document No.", "No.");
                IF FundsClaimLine.FINDSET THEN BEGIN
                    REPEAT
                        FundsClaimLine."Global Dimension 2 Code" := '';
                        FundsClaimLine."Shortcut Dimension 3 Code" := '';
                        FundsClaimLine."Shortcut Dimension 4 Code" := '';
                        FundsClaimLine."Shortcut Dimension 5 Code" := '';
                        FundsClaimLine."Shortcut Dimension 6 Code" := '';
                        FundsClaimLine."Shortcut Dimension 7 Code" := '';
                        FundsClaimLine."Shortcut Dimension 8 Code" := '';
                        FundsClaimLine.MODIFY;
                    UNTIL FundsClaimLine.NEXT = 0;
                END;
                //End delete the previous dimensions

                FundsClaimLine.RESET;
                FundsClaimLine.SETRANGE(FundsClaimLine."Document No.", "No.");
                IF FundsClaimLine.FINDSET THEN BEGIN
                    REPEAT
                        FundsClaimLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        FundsClaimLine.MODIFY;
                    UNTIL FundsClaimLine.NEXT = 0;
                END;
            end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                         "Dimension Value Type" = CONST(Standard),
                                                Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                    Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                              Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                    Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                     Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                   Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted,Reversed;

            trigger OnValidate()
            begin
                FundsClaimLine.RESET;
                FundsClaimLine.SETRANGE(FundsClaimLine."Document No.", "No.");
                IF FundsClaimLine.FINDSET THEN BEGIN
                    REPEAT
                        FundsClaimLine.Status := Rec.Status;
                        FundsClaimLine.MODIFY;
                    UNTIL FundsClaimLine.NEXT = 0;
                END;
            end;
        }
        field(71; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
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
        FundsClaimLine.RESET;
        FundsClaimLine.SETRANGE(FundsClaimLine."Document No.", "No.");
        IF FundsClaimLine.FINDSET THEN
            FundsClaimLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            FundsSetup.GET;
            FundsSetup.TESTFIELD("Funds Claim Nos.");
            NoSeriesMgt.InitSeries(FundsSetup."Funds Claim Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "Document Type" := "Document Type"::Refund;
        "Document Date" := TODAY;
        "User ID" := USERID;
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Status,Status::Open);
    end;

    trigger OnRename()
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
        Employee: Record 5200;
        FundsClaimHeader: Record 50012;
        FundsClaimLine: Record 50013;
        CurrExchRate: Record 330;
        BankAccountLedgerEntry: Record 271;
        ErrorUsedReferenceNumber: Label 'The Reference Number has been used in Document No:%1';
}


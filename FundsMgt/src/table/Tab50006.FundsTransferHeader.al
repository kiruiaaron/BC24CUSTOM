table 50006 "Funds Transfer Header"
{
    Caption = 'Funds Transfer Header';
    DrillDownPageID = 50017;
    LookupPageID = 50017;

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
            OptionCaption = 'Normal,Petty Cash,Express,Cash Purchase,Mobile';
            OptionMembers = Normal,"Petty Cash",Express,"Cash Purchase",Mobile;
        }
        field(7; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
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
                FundsTransferHeader.RESET;
                FundsTransferHeader.SETRANGE(FundsTransferHeader."Reference No.", "Reference No.");
                IF FundsTransferHeader.FINDSET THEN BEGIN
                    REPEAT
                        IF FundsTransferHeader."No." <> "No." THEN
                            ERROR('The Reference Number has been used in Funds Transfer Document No:' + FORMAT(FundsTransferHeader."No."));
                    UNTIL FundsTransferHeader.NEXT = 0;
                END;
            end;
        }
        field(12; "Tranfer Type"; Option)
        {
            Caption = 'Tranfer Type';
            OptionCaption = ' ,Bank,InterCompany';
            OptionMembers = " ",Bank,InterCompany;
        }
        field(14; "Transfer To"; Text[100])
        {
            Caption = 'Transfer To';
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
                        //BankAccount.TESTFIELD(BankAccount."Currency Code","Currency Code");
                        "Currency Factor" := CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                    END;
                END ELSE BEGIN
                    IF BankAccount.GET("Bank Account No.") THEN BEGIN
                        //BankAccount.TESTFIELD(BankAccount."Currency Code",'');
                    END;
                END
            end;
        }
        field(17; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(18; "Amount To Transfer"; Decimal)
        {
            Caption = 'Amount To Transfer';

            trigger OnValidate()
            begin
                IF "Currency Code" <> '' THEN BEGIN
                    "Amount To Transfer(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Amount To Transfer", "Currency Factor"));
                END ELSE BEGIN
                    "Amount To Transfer(LCY)" := "Amount To Transfer";
                END;
            end;
        }
        field(19; "Amount To Transfer(LCY)"; Decimal)
        {
            Caption = 'Amount To Transfer(LCY)';
            Editable = false;
        }
        field(38; "Line Amount"; Decimal)
        {
            CalcFormula = Sum("Funds Transfer Line".Amount WHERE("Document No." = FIELD("No.")));
            Caption = 'Line Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Line Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Funds Transfer Line"."Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Line Amount(LCY)';
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

                FundsTransferLine.RESET;
                FundsTransferLine.SETRANGE(FundsTransferLine."Document No.", "No.");
                IF FundsTransferLine.FINDSET THEN BEGIN
                    REPEAT
                        FundsTransferLine."Global Dimension 2 Code" := '';
                        FundsTransferLine."Shortcut Dimension 3 Code" := '';
                        FundsTransferLine."Shortcut Dimension 4 Code" := '';
                        FundsTransferLine."Shortcut Dimension 5 Code" := '';
                        FundsTransferLine."Shortcut Dimension 6 Code" := '';
                        FundsTransferLine."Shortcut Dimension 7 Code" := '';
                        FundsTransferLine."Shortcut Dimension 8 Code" := '';
                        FundsTransferLine.MODIFY;
                    UNTIL FundsTransferLine.NEXT = 0;
                END;
                //End delete the previous dimensions

                FundsTransferLine.RESET;
                FundsTransferLine.SETRANGE(FundsTransferLine."Document No.", "No.");
                IF FundsTransferLine.FINDSET THEN BEGIN
                    REPEAT
                        FundsTransferLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        FundsTransferLine.MODIFY;
                    UNTIL FundsTransferLine.NEXT = 0;
                END;
            end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));
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
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted,Reversed;
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
        }
        field(103; Payee; Text[100])
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
        Rec.TESTFIELD(Status, Rec.Status::Open);
        FundsTransferLine.RESET;
        FundsTransferLine.SETRANGE(FundsTransferLine."Document No.", "No.");
        IF FundsTransferLine.FINDSET THEN
            FundsTransferLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            FundsSetup.GET;
            FundsSetup.TESTFIELD("Funds Transfer Nos.");
            NoSeriesMgt.InitSeries(FundsSetup."Funds Transfer Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "Document Type" := "Document Type"::"Funds Transfer";
        "Document Date" := TODAY;
        "User ID" := USERID;
        "Posting Date" := TODAY;
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
        FundsTransferHeader: Record 50006;
        FundsTransferLine: Record 50007;
        CurrExchRate: Record 330;
        OnlyDeleteOpenDocument: Label 'You can only delete an Open Payment Document. The current status is %1';
}


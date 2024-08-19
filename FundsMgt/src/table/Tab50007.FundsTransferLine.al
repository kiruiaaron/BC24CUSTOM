table 50007 "Funds Transfer Line"
{
    Caption = 'Funds Transfer Line';

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(2; "Document No.";
        Code[20])
        {
            Caption = '"Document No."';
            Editable = false;
            TableRelation = "Funds Transfer Header"."No.";
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt,Funds Transfer,Imprest,Imprest Surrender';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Receipt,"Funds Transfer",Imprest,"Imprest Surrender";
        }
        field(4; "Money Transfer Code"; Code[50])
        {
            Caption = 'Money Transfer Code';
        }
        field(5; "Money Transfer Description"; Text[100])
        {
            Caption = 'Money Transfer Description';
            Editable = true;
        }
        field(6; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = ' ,Bank Account';
            OptionMembers = " ","Bank Account";
        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            Editable = true;
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                "Account Name" := '';

                FundsTransferHeader.RESET;
                FundsTransferHeader.SETRANGE(FundsTransferHeader."No.", "Document No.");
                FundsTransferHeader.SETRANGE(FundsTransferHeader."Bank Account No.", "Account No.");
                IF FundsTransferHeader.FINDFIRST THEN BEGIN
                    ERROR(SimilarBank);
                END;

                BankAccount.RESET;
                BankAccount.SETRANGE(BankAccount."No.", "Account No.");
                IF BankAccount.FINDFIRST THEN BEGIN
                    "Account Name" := BankAccount.Name;
                END;
            end;
        }
        field(8; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
            Editable = false;
        }
        field(9; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            Editable = false;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(22; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(23; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                FundsTransferHeader.RESET;
                IF FundsTransferHeader.GET("Document No.") THEN BEGIN
                    IF FundsTransferHeader."Currency Code" <> '' THEN BEGIN
                        "Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(FundsTransferHeader."Posting Date", FundsTransferHeader."Currency Code", Amount, FundsTransferHeader."Currency Factor"));
                    END ELSE BEGIN
                        "Amount(LCY)" := Amount;
                    END;
                END;
            end;
        }
        field(24; "Amount(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
            Editable = false;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
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
    }

    keys
    {
        key(Key1; "Line No.", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Rec.TESTFIELD(Status, Rec.Status::Open);
    end;

    trigger OnInsert()
    begin
        FundsTransferHeader.RESET;
        FundsTransferHeader.SETRANGE("No.", "Document No.");
        IF FundsTransferHeader.FINDFIRST THEN BEGIN
            "Document Type" := "Document Type"::"Funds Transfer";
            "Posting Date" := FundsTransferHeader."Posting Date";
            "Currency Code" := FundsTransferHeader."Currency Code";
            "Money Transfer Description" := FundsTransferHeader.Description;
            "Currency Factor" := FundsTransferHeader."Currency Factor";
            "Global Dimension 1 Code" := FundsTransferHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := FundsTransferHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code" := FundsTransferHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := FundsTransferHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code" := FundsTransferHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code" := FundsTransferHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code" := FundsTransferHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code" := FundsTransferHeader."Shortcut Dimension 8 Code";
        END;
    end;

    var
        FundsTransactionCodes: Record 50027;
        FundsTaxCodes: Record 50028;
        "G/LAccount": Record 15;
        BankAccount: Record 270;
        Customer: Record 18;
        Vendor: Record 23;
        FixedAsset: Record 5600;
        ICPartner: Record 413;
        FundsTransferHeader: Record 50006;
        FundsTransferLine: Record 50007;
        CurrExchRate: Record 330;
        SimilarBank: Label 'This account is similar to account where money is being received from';
}


table 50029 "Funds User Setup"
{
    Caption = 'Funds User Setup';

    fields
    {
        field(1; UserID; Code[50])
        {
            Caption = 'UserID';
            NotBlank = true;

            trigger OnLookup()
            begin
                //UserManager.l.LookupUserID(UserID);
            end;

            trigger OnValidate()
            begin
                // UserManager.ValidateUserID(UserID);
            end;
        }
        field(2; "Receipt Journal Template"; Code[10])
        {
            Caption = 'Receipt Journal Template';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(3; "Receipt Journal Batch"; Code[10])
        {
            Caption = 'Receipt Journal Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Receipt Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                TempFundsUserSetup.RESET;
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Receipt Journal Template", "Receipt Journal Template");
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Receipt Journal Batch", "Receipt Journal Batch");
                IF TempFundsUserSetup.FINDFIRST THEN BEGIN
                    REPEAT
                        IF (TempFundsUserSetup.UserID <> UserID) AND ("Receipt Journal Batch" <> '') THEN BEGIN
                            ERROR(SameBatch, "Receipt Journal Batch");
                        END;
                    UNTIL TempFundsUserSetup.NEXT = 0;
                END;

            end;
        }
        field(4; "Payment Journal Template"; Code[10])
        {
            Caption = 'Payment Journal Template';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(5; "Payment Journal Batch"; Code[10])
        {
            Caption = 'Payment Journal Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payment Journal Template"));

            trigger OnValidate()
            begin
                //Check if the batch has been allocated to another user
                TempFundsUserSetup.RESET;
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Payment Journal Template", "Payment Journal Template");
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Payment Journal Batch", "Payment Journal Batch");
                IF TempFundsUserSetup.FINDFIRST THEN BEGIN
                    REPEAT
                        IF (TempFundsUserSetup.UserID <> Rec.UserID) AND ("Payment Journal Batch" <> '') THEN BEGIN
                            ERROR(SameBatch, "Payment Journal Batch");
                        END;
                    UNTIL TempFundsUserSetup.NEXT = 0;
                END;
            end;
        }
        field(6; "Fund Transfer Template Name"; Code[10])
        {
            Caption = 'Fund Transfer Template Name';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(7; "Fund Transfer Batch Name"; Code[10])
        {
            Caption = 'Fund Transfer Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Fund Transfer Template Name"));

            trigger OnValidate()
            begin
                //Check if the batch has been allocated to another user
                TempFundsUserSetup.RESET;
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Fund Transfer Template Name", "Fund Transfer Template Name");
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Fund Transfer Batch Name", "Fund Transfer Batch Name");
                IF TempFundsUserSetup.FINDFIRST THEN BEGIN
                    REPEAT
                        IF (TempFundsUserSetup.UserID <> Rec.UserID) AND ("Fund Transfer Batch Name" <> '') THEN BEGIN
                            ERROR(SameBatch, "Fund Transfer Batch Name");
                        END;
                    UNTIL TempFundsUserSetup.NEXT = 0;
                END;
            end;
        }
        field(8; "Funds Claim Template"; Code[10])
        {
            Caption = 'Funds Refund Template';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(9; "Funds Claim  Batch"; Code[10])
        {
            Caption = 'Funds Claim  Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Funds Claim Template"));
        }
        field(10; "Imprest Template"; Code[10])
        {
            Caption = 'Imprest Template';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(11; "Imprest Batch"; Code[10])
        {
            Caption = 'Imprest Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Imprest Template"));
        }
        field(50; "Default Receipts Bank"; Code[20])
        {
            Caption = 'Default Receipts Bank';
            TableRelation = "Bank Account"."No.";
        }
        field(51; "Default Payment Bank"; Code[20])
        {
            Caption = 'Default Payment Bank';
            TableRelation = "Bank Account"."No.";
        }
        field(52; "Default Petty Cash Bank"; Code[20])
        {
            Caption = 'Default Petty Cash Bank';
            TableRelation = "Bank Account"."No.";
        }
        field(53; "JV Template"; Code[10])
        {
            Caption = 'JV Template';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(54; "JV Batch"; Code[10])
        {
            Caption = 'JV Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("JV Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                TempFundsUserSetup.RESET;
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."JV Template", "JV Template");
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."JV Batch", "JV Batch");
                IF TempFundsUserSetup.FINDFIRST THEN BEGIN
                    REPEAT
                        IF (TempFundsUserSetup.UserID <> UserID) AND ("JV Batch" <> '') THEN BEGIN
                            ERROR(SameBatch, "JV Batch");
                        END;
                    UNTIL TempFundsUserSetup.NEXT = 0;
                END;

            end;
        }
        field(55; "Reversal Template"; Code[10])
        {
            Caption = 'Reversal Template';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(56; "Reversal Batch"; Code[10])
        {
            Caption = 'Reversal Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Reversal Template"));
        }
        field(100; "Reopen Funds Documents"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; UserID)
        {
        }
    }

    fieldgroups
    {
    }

    var
        TempFundsUserSetup: Record 50029;
        UserManager: Codeunit 418;
        SameBatch: Label 'Another User has been assign to the batch:%1';
}


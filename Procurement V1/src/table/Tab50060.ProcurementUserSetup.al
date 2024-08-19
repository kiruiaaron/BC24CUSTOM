table 50060 "Procurement User Setup"
{

    fields
    {
        field(10; UserID; Code[50])
        {
            Caption = 'UserID';
            NotBlank = true;

            trigger OnLookup()
            begin
                //  UserManager.loo(UserID);
            end;

            trigger OnValidate()
            begin
                //    UserManager.ValidateUserID(UserID);
            end;
        }
        field(11; "Procurement Journal Template"; Code[10])
        {
            Caption = 'Receipt Journal Template';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(12; "Procurement Journal Batch"; Code[10])
        {
            Caption = 'Receipt Journal Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Procurement Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                TempFundsUserSetup.RESET;
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Procurement Journal Template", "Procurement Journal Template");
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Procurement Journal Batch", "Procurement Journal Batch");
                IF TempFundsUserSetup.FINDFIRST THEN BEGIN
                    REPEAT
                        IF (TempFundsUserSetup.UserID <> UserID) AND ("Procurement Journal Batch" <> '') THEN BEGIN
                            ERROR(SameBatch, "Procurement Journal Batch");
                        END;
                    UNTIL TempFundsUserSetup.NEXT = 0;
                END;

            end;
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
        TempFundsUserSetup: Record 50060;
        UserManager: Codeunit 418;
        SameBatch: Label 'Another User has been assign to the batch:%1';
}


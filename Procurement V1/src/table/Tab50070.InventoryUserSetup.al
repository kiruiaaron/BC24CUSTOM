table 50070 "Inventory User Setup"
{
    Caption = 'Inventory User Setup';

    fields
    {
        field(1; UserID; Code[50])
        {
            Caption = 'UserID';
            NotBlank = true;

            trigger OnLookup()
            begin
                //  UserManager.LookupUserID(UserID);
            end;

            trigger OnValidate()
            begin
                //   UserManager.ValidateUserID(UserID);
            end;
        }
        field(2; "Item Journal Template"; Code[10])
        {
            Caption = 'Item Journal Template';
            TableRelation = "Item Journal Template".Name;
        }
        field(3; "Item Journal Batch"; Code[10])
        {
            Caption = 'Item Journal Batch';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Item Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                TempFundsUserSetup.RESET;
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Procurement Journal Template", "Item Journal Template");
                TempFundsUserSetup.SETRANGE(TempFundsUserSetup."Procurement Journal Batch", "Item Journal Batch");
                IF TempFundsUserSetup.FINDFIRST THEN BEGIN
                    REPEAT
                        IF (TempFundsUserSetup.UserID <> UserID) AND ("Item Journal Batch" <> '') THEN BEGIN
                            ERROR(SameBatch, "Item Journal Batch");
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


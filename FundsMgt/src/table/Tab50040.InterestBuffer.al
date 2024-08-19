table 50040 "Interest Buffer"
{

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = false;
            DataClassification = ToBeClassified;
        }
        field(2; "Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";

        }
        field(3; "Account Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Interest Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Interest Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Account Matured"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(10; "Late Interest"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Transferred; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Mark For Deletion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Description; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Transaction Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Document No.";
        Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No, "Account No")
        {
        }
    }

    fieldgroups
    {
    }
}


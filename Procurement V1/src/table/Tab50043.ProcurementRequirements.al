table 50043 "Procurement Requirements"
{

    fields
    {
        field(10; "Document No.";
        Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(12; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


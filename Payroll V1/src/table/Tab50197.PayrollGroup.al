table 50197 "Payroll Group"
{

    fields
    {
        field(1;"Code";Code[50])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}


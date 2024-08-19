table 50334 "First/Final Review KPI Details"
{

    fields
    {
        field(1; "Review No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Review KPI No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(4; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Improvement,Concern';
            OptionMembers = Improvement,Concern;
        }
        field(5; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Review No.", "Review KPI No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


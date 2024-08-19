table 50333 "Probation First/Final KPI"
{

    fields
    {
        field(1; "Review No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; "Area Of Performance"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Remarks; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Improvement Required,Satisfactory,Good,Excellent';
            OptionMembers = "Improvement Required",Satisfactory,Good,Excellent;
        }
        field(5; "First/Final"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'First,Final';
            OptionMembers = First,Final;
        }
    }

    keys
    {
        key(Key1; "Review No.", "Line No.", "First/Final")
        {
        }
    }

    fieldgroups
    {
    }
}


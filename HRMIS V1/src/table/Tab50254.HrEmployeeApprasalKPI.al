table 50254 "Hr Employee Apprasal KPI"
{

    fields
    {
        field(1; "Appraisal No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Performance Indicator"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Results Achieved"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Performance Score %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Appraisal No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


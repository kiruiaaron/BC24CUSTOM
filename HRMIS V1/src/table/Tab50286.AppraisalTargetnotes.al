table 50286 "Appraisal Target notes"
{

    fields
    {
        field(1; "Header No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Appraisal Header";
        }
        field(2; "Criteria code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Appraisal KPI"."Criteria code";
        }
        field(3; Notes; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Line no"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Target Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Header No", "Criteria code", "Target Code", "Line no")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AppraisalTargets: Record 50285;
}


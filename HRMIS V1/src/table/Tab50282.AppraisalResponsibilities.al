table 50282 "Appraisal Responsibilities"
{

    fields
    {
        field(1;"Header No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Appraisal Header";
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3;"Employee Responsibilities";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Manager Responsibilities";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Header No","Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


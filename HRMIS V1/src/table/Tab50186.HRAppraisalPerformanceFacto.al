table 50186 "HR Appraisal Performance Facto"
{

    fields
    {
        field(1;"Appraisal No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Line No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Performance Factor";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Appraisal No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


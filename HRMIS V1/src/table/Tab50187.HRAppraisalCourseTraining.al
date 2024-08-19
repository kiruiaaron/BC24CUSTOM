table 50187 "HR Appraisal Course/Training"
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
        field(3;"Course/Training";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Appraisal No.")
        {
        }
    }

    fieldgroups
    {
    }
}


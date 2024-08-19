table 50238 "HR Employee Appraisal Peforman"
{

    fields
    {
        field(1;"Appraisal No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Appraisal Period";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Improvement Factor";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Line No.";Integer)
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


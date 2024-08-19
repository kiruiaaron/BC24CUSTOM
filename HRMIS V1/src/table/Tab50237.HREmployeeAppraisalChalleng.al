table 50237 "HR Employee Appraisal Challeng"
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
        field(3;"Challenge/Problem";Text[250])
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


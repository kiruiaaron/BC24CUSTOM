table 50193 "HR Appraisal Global Competency"
{

    fields
    {
        field(1;"Assesment Factor";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Appraisal Period";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Calendar Period";
        }
    }

    keys
    {
        key(Key1;"Assesment Factor")
        {
        }
    }

    fieldgroups
    {
    }
}


table 50182 "Hr Appraisal Academic/Prof Qua"
{

    fields
    {
        field(1;"Appraisal Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Line No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Name of Institution";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Qualification Awarded";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Period Of Study";DateFormula)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Appraisal Code","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


table 50303 "Plan Support"
{

    fields
    {
        field(1;"Plan No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Development Plan";
        }
        field(2;"Line no";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;Support;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"AD Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Plan No","AD Code","Line no")
        {
        }
    }

    fieldgroups
    {
    }
}


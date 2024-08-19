table 50302 "Areas of Development"
{

    fields
    {
        field(1;"Plan No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Development Plan";
        }
        field(2;"AD Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Areas of Development";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Plan No","AD Code")
        {
        }
    }

    fieldgroups
    {
    }
}


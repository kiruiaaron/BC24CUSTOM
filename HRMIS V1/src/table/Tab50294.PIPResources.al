table 50294 "PIP Resources"
{

    fields
    {
        field(1;"Header No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee PIP";
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3;"Areas of Concern";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Resource Name";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Description Of Resource";Text[250])
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


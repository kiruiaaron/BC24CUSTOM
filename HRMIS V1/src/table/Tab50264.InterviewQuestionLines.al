table 50264 "Interview Question Lines"
{

    fields
    {
        field(1;"Setup Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Interview Score Sheet Setup";
        }
        field(2;Lineno;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;Question;Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Setup Code",Lineno)
        {
        }
    }

    fieldgroups
    {
    }
}


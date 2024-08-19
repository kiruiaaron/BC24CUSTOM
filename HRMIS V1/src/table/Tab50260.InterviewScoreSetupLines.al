table 50260 "Interview Score Setup Lines"
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
        field(3;"Job Factor";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Maximum Score";Decimal)
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


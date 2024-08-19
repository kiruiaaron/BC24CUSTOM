table 50033 "Cluster Codes"
{

    fields
    {
        field(10;"Cluster Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Cluster Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Cluster Code")
        {
        }
    }

    fieldgroups
    {
    }
}


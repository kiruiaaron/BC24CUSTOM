table 51607 "Mandatory Interactions"
{

    fields
    {
        field(1; "Interaction Template"; Code[100])
        {
            TableRelation = "Interaction Template";
        }
    }

    keys
    {
        key(Key1; "Interaction Template")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


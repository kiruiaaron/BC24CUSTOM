table 51601 "BA SetUp"
{

    fields
    {
        field(1; "No. Series"; Code[20])
        {
            Caption = 'BA No Series';
            TableRelation = "No. Series".Code;
        }
        field(2; "code"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Assignment Number Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(4; "Deployment Number Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(5; "Payment Schedule Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(Key1; "code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


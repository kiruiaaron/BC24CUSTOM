table 51604 Venues
{
    DrillDownPageID = Venues;
    LookupPageID = Venues;

    fields
    {
        field(1; "code"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Venue; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; "code", Venue)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


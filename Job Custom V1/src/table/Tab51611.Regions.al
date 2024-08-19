table 51611 Regions
{
    DrillDownPageID = Regions;
    LookupPageID = Regions;

    fields
    {
        field(1; "Region Code"; Code[20])
        {
        }
        field(2; "Region Name"; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; "Region Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


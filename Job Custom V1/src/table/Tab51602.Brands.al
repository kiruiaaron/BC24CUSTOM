table 51602 Brands
{
    DrillDownPageID = Brands;
    LookupPageID = Brands;

    fields
    {
        field(1; "Brand Code"; Code[20])
        {
        }
        field(2; "Brand Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Brand Code", "Brand Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


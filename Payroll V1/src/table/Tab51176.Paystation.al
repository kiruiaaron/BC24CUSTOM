table 51176 Paystation
{
    // LookupPageID = 39012017;

    fields
    {
        field(1; Paystation; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; Paystation)
        {
        }
    }

    fieldgroups
    {
    }
}


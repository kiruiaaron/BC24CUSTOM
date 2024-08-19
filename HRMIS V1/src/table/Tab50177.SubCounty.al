/// <summary>
/// Table Sub-County (ID 50177).
/// </summary>
table 50177 "Sub-County"
{

    fields
    {
        field(1; "County Code"; Code[50])
        {
            TableRelation = County;
        }
        field(2; "Sub-County Code"; Code[50])
        {
        }
        field(3; "Sub-County Name"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "County Code", "Sub-County Code")
        {
        }
    }

    fieldgroups
    {
    }
}


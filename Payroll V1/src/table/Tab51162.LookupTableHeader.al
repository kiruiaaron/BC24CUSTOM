table 51162 "Lookup Table Header"
{
    DrillDownPageID = 51164;
    LookupPageID = 51164;

    fields
    {
        field(1; "Table ID"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Type; Option)
        {
            OptionMembers = Percentage,"Extract Amount",Month,"Max Min";
        }
        field(3; Description; Text[30])
        {
        }
        field(4; "Min Extract Amount (LCY)"; Decimal)
        {
        }
        field(5; "Max Extract Amount (LCY)"; Decimal)
        {
        }
        field(50000; "Calendar Year"; Integer)
        {
            Description = 'Used e.g. in Lump Sum taxation';
        }
    }

    keys
    {
        key(Key1; "Table ID")
        {
        }
    }

    fieldgroups
    {
    }
}


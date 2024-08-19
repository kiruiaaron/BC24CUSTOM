table 50311 "Casual Job Titles"
{
    DrillDownPageID = 51338;
    LookupPageID = 51338;

    fields
    {
        field(1;"Code";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Job Title";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Casual Cost";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Administrative Cost";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code","Job Title")
        {
        }
    }
}


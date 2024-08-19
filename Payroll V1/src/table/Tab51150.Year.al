/// <summary>
/// Table Year (ID 51150).
/// </summary>
table 51150 Year
{
    LookupPageID = 51154;

    fields
    {
        field(1; Year; Integer)
        {
            MaxValue = 2050;
            MinValue = 1999;

            trigger OnValidate()
            begin
                "Start Date" := DMY2DATE(1, 1, Year);
                "End date" := DMY2DATE(31, 12, Year);
                Description := 'Year ' + FORMAT(Year);
            end;
        }
        field(2; "Start Date"; Date)
        {
        }
        field(3; "End date"; Date)
        {
        }
        field(4; Description; Text[50])
        {
        }
        field(5; "Annual TAX Table"; Code[30])
        {
            Description = 'V.6.1.65_08SEP10 For Annual TAX';
            TableRelation = "Lookup Table Header";
        }
        field(6; "Annual TAX Relief Table"; Code[30])
        {
            Description = 'V.6.1.65_08SEP10 For Annual TAX';
            TableRelation = "Lookup Table Header";
        }
    }

    keys
    {
        key(Key1; Year)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PeriodRec.SETRANGE("Period Year", Year);
        IF PeriodRec.FINDFIRST THEN
            ERROR('Payroll Periods exist for this payroll year. Year data is common to ALL payrolls in a company.'
);
        PeriodRec.DELETEALL;
    end;

    var
        PeriodRec: Record Periods;
}


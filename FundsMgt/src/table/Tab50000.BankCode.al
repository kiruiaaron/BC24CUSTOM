table 50000 "Bank Code"
{
    Caption = 'Bank Code';
    DataPerCompany = false;
    DrillDownPageID = 50000;
    LookupPageID = 50000;

    fields
    {
        field(1;"Bank Code";Code[20])
        {
            Caption = 'Bank Code';
            Description = 'Specifies the bank unique identifier';
        }
        field(2;"Bank Name";Text[100])
        {
            Caption = 'Bank Name';
            Description = 'Specifies the bank name';
        }
    }

    keys
    {
        key(Key1;"Bank Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Bank Code","Bank Name")
        {
        }
    }
}


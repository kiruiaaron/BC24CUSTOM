table 51613 "BA Deploymet Import"
{

    fields
    {
        field(1; "Deployment Code"; Code[20])
        {
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "ID No"; Code[8])
        {
        }
        field(4; "Days worked"; Decimal)
        {
        }
        field(5; "Subcontract Type"; Code[20])
        {
        }
        field(6; "Venue/Outlet"; Text[250])
        {
        }
        field(7; "Created By"; Code[100])
        {
        }
        field(8; "Date Created"; Date)
        {
        }
        field(9; "Time Created"; Time)
        {
        }
        field(10; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Deployment Code", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Time Created" := Time;
        "Date Created" := Today;
    end;
}


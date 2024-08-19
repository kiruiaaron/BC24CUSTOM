/// <summary>
/// Table HR Job Responsibilities (ID 50096).
/// </summary>
table 50096 "HR Job Responsibilities"
{
    Caption = 'HR Job Responsibility';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            TableRelation = "HR Jobs"."No.";
        }
        field(2; "Responsibility Code"; Code[50])
        {
            Caption = 'Responsibility Code';
            TableRelation = "HR Job Lookup Value".Code WHERE(Option = CONST(Responsibility));
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }

        field(4; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Job No.", "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


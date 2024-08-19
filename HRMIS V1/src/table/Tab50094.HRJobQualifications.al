/// <summary>
/// Table HR Job Qualifications (ID 50094).
/// </summary>
table 50094 "HR Job Qualifications"
{
    Caption = 'HR Job Qualification';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            TableRelation = "HR Jobs"."No.";
        }
        field(2; "Qualification Code"; Code[50])
        {
            Caption = 'Qualification Code';
            TableRelation = "HR Job Lookup Value".Code WHERE(Option = FILTER("Other Certifications" | Qualification));
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; Mandatory; Boolean)
        {
            Caption = 'Mandatory';
        }
        field(5; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Job No.", "Qualification Code", "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


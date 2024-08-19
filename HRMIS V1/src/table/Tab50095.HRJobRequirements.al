/// <summary>
/// Table HR Job Requirements (ID 50095).
/// </summary>
table 50095 "HR Job Requirements"
{
    Caption = 'HR Job Requirement';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = "HR Jobs"."No.";
        }
        field(2; "Requirement Code"; Code[50])
        {
            Caption = 'Requirement Code';
            TableRelation = "HR Job Lookup Value".Code WHERE(Option = CONST(Requirement),
                                                              Blocked = CONST(false));
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; Mandatory; Boolean)
        {
            Caption = 'Mandatory';
            DataClassification = ToBeClassified;
        }
        field(5; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(6; "No. of Years"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job No.", Mandatory, "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


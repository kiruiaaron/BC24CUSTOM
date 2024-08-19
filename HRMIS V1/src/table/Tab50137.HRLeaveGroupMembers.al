/// <summary>
/// Table HR Leave Group Members (ID 50137).
/// </summary>
table 50137 "HR Leave Group Members"
{

    fields
    {
        field(1; "Leave Group Code"; Code[50])
        {
            TableRelation = "HR Leave Groups".Code;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(3; "Employee Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Leave Group Code")
        {
        }
    }

    fieldgroups
    {
    }
}


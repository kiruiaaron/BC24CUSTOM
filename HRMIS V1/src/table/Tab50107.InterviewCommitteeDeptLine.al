/// <summary>
/// Table Interview Committee Dept Line (ID 50107).
/// </summary>
table 50107 "Interview Committee Dept Line"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Code"; Code[20])
        {
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."No.", "Employee No.");
                IF Employee.FINDFIRST THEN
                  "Employee Name" := Employee.FullName();// Employee."Last Name"+' '+Employee."Middle Name"+' '+Employee."First Name";
                "Employee Email" := Employee."Company E-Mail";
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "Employee Email"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record Employee;
}


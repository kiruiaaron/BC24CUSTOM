table 51191 "Employee Grades2"
{
    //LookupPageID = 52021099;

    fields
    {
        field(1; "Grade Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "OT Qualifying"; Boolean)
        {
            Description = 'Added for OT Calculations GJ';
        }
        field(4; "Leave Travel Allowance"; Decimal)
        {
        }
        field(5; "Grade 0"; Boolean)
        {
            Description = 'Added for HR2-2 - GJ';

            trigger OnValidate()
            begin
                IF "Grade 0" THEN BEGIN
                    "Grade 1 - 5" := FALSE;
                    Management := FALSE;
                END;
            end;
        }
        field(6; "Grade 1 - 5"; Boolean)
        {
            Description = 'Added for HR2-2 - GJ';

            trigger OnValidate()
            begin
                IF "Grade 1 - 5" THEN BEGIN
                    "Grade 0" := FALSE;
                    Management := FALSE;
                END;
            end;
        }
        field(7; Management; Boolean)
        {
            Description = 'Added for HR2-2 - GJ';

            trigger OnValidate()
            begin
                IF Management THEN BEGIN
                    "Grade 0" := FALSE;
                    "Grade 1 - 5" := FALSE;
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Grade Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        gvEmp.SETRANGE("Employee Grade", "Grade Code");
        IF gvEmp.FINDFIRST THEN ERROR('Employee No. %1 is assigned this grade', gvEmp."No.");
    end;

    var
        gvEmp: Record 5200;
}


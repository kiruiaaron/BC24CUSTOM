table 51175 "Membership Numbers"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "ED Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "ED Definitions";
        }
        field(3; "Number Name"; Text[30])
        {
            CalcFormula = Lookup("ED Definitions"."Membership No. Name" WHERE("ED Code" = FIELD("ED Code")));
            FieldClass = FlowField;
        }
        field(4; "Membership Number"; Code[20])
        {
        }
        field(50000; "Member Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."Last Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(50009; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                ERROR('Manual Edits not allowed.');
            end;
        }
    }

    keys
    {
        key(Key1; "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure gsAssignPayrollCode()
    var
        lvUserSetup: Record 91;
    begin
        lvUserSetup.GET(USERID);
        lvUserSetup.TESTFIELD("Give Access to Payroll");
        Rec."Payroll Code" := lvUserSetup."Give Access to Payroll"
    end;
}


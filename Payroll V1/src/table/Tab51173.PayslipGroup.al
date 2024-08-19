table 51173 "Payslip Group"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Heading Text"; Text[50])
        {
        }
        field(3; "Include Total For Group"; Boolean)
        {
            InitValue = true;
        }
        field(4; "Line Type"; Option)
        {
            OptionMembers = "E/D code",P9;
        }
        field(5; "Heading Text 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                //ERROR('Manual Edits not allowed.');
            end;
        }
    }

    keys
    {
        key(Key1; "Code", "Payroll Code")
        {
        }
    }

    fieldgroups
    {
    }

    local procedure gsAssignPayrollCode()
    var
        lvUserSetup: Record 91;
    begin

        lvUserSetup.GET(USERID);
        //  lvUserSetup.TESTFIELD("Give Access to Payroll");
        //Rec. "Payroll Code" := lvUserSetup."Give Access to Payroll"
    end;
}


table 51181 "Coinage Analysis Setup"
{

    fields
    {
        field(1; Line; BigInteger)
        {
        }
        field(2; "ED Code"; Code[20])
        {
            TableRelation = "ED Definitions"."ED Code";
        }
        field(3; Description; Text[50])
        {
            CalcFormula = Lookup("ED Definitions"."Payroll Text" WHERE("ED Code" = FIELD("ED Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Denomination; BigInteger)
        {
            MinValue = 1;
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
        key(Key1; Line)
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
        //"Payroll Code" := lvUserSetup."Give Access to Payroll"
    end;
}


/// <summary>
/// Table Special Payments (ID 51166).
/// </summary>
table 51166 "Special Payments"
{

    fields
    {
        field(1; "Line No"; BigInteger)
        {
        }
        field(2; "Payment ED Code"; Code[20])
        {
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Payments),
                                                              "System Created" = CONST(true),
                                                              "Special Payment" = CONST(true));
        }
        field(3; "Payment ED Description"; Text[50])
        {
            CalcFormula = Lookup("ED Definitions"."Payroll Text" WHERE("ED Code" = FIELD("Payment ED Code")));
            FieldClass = FlowField;
        }
        field(4; "Min Basic Salary"; Decimal)
        {
            MinValue = 0;
        }
        field(5; "Max Basic Salary"; Decimal)
        {
            MinValue = 0;
        }
        field(6; "Granted Rate (%)"; Decimal)
        {
            MinValue = 0;
        }
        field(50009; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                ERROR('Manual Edits not allowed.');
            end;
        }
        field(50010; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1; "Line No")
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


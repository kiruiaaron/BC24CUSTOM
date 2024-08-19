table 51167 "Special Allowances"
{

    fields
    {
        field(1; "Allowance ED Code"; Code[20])
        {
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Payments),
                                                              "System Created" = CONST(true),
                                                              "Special Allowance" = CONST(true));
        }
        field(2; "Employee No"; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin

                EmployeeRec.GET("Employee No");
                "Employee Name" := EmployeeRec."First Name" + ' ' + EmployeeRec."Middle Name" + ' ' + EmployeeRec."Last Name";
            end;
        }
        field(3; "Amount (LCY)"; Decimal)
        {
            MinValue = 0;
        }
        field(4; "Allowance ED Description"; Text[50])
        {
            CalcFormula = Lookup("ED Definitions"."Payroll Text" WHERE("ED Code" = FIELD("Allowance ED Code")));
            FieldClass = FlowField;
        }
        field(5; "Employee Name"; Text[30])
        {
        }
        field(6; "Deduction ED Code"; Code[20])
        {
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Deduction),
                                                              "System Created" = CONST(true),
                                                              "Special Allowance" = CONST(true));
        }
        field(7; "Deduction ED Description"; Text[50])
        {
            CalcFormula = Lookup("ED Definitions"."Payroll Text" WHERE("ED Code" = FIELD("Deduction ED Code")));
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
        key(Key1; "Allowance ED Code", "Employee No", "Deduction ED Code")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Payroll Code" = '' THEN "Payroll Code" := gvPayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation
    end;

    var
        EmployeeRec: Record 5200;
        gvPayrollUtilities: Codeunit 51152;

    procedure gsAssignPayrollCode()
    var
        lvUserSetup: Record 91;
    begin
        lvUserSetup.GET(USERID);
        lvUserSetup.TESTFIELD("Give Access to Payroll");
        Rec."Payroll Code" := lvUserSetup."Give Access to Payroll"
    end;
}


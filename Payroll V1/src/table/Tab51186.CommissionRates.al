table 51186 "Commission Rates"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Employee No"; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; Base; Option)
        {
            InitValue = "Sales Turnover";
            OptionMembers = "Basic Salary","Sales Turnover","Receipts Collected";

            trigger OnValidate()
            var
                lvEmployee: Record 5200;
            begin
                IF Base = Base::"Basic Salary" THEN BEGIN
                    Rec.TESTFIELD("Employee No");
                    lvEmployee.GET("Employee No");
                    IF lvEmployee."Basic Pay" = lvEmployee."Basic Pay"::" " THEN ERROR('Invalid for an employee without a Basic Salary.');
                END
            end;
        }
        field(5; "Valid To Date"; Date)
        {
        }
        field(6; "ED Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Payments),
                                                              "System Created" = CONST(true));
        }
        field(7; "Threshold Amount LCY"; Decimal)
        {
        }
        field(8; "Commission %"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Commission %" <> 0 THEN "Commission Amount LCY" := 0;
            end;
        }
        field(9; "Commission Amount LCY"; Decimal)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Commission Amount LCY" <> 0 THEN "Commission %" := 0;
            end;
        }
        field(10; "Payroll Code"; Code[10])
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
        key(Key1; "Entry No")
        {
        }
        key(Key2; "Employee No", "Valid To Date", Base)
        {
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
        gvPayrollUtilities: Codeunit 51152;
}


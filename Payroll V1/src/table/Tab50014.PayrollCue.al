table 50014 "Payroll Cue"
{
    Caption = 'Payroll Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Basic Pay"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period Filter"), "ED Code" = filter('BASIC')));

        }
        field(3; "Commission"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period Filter"), "ED Code" = filter('COMMISSION')));

        }
        field(4; "Net Pay"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period Filter"), "Calculation Group" = filter(Payments | Deduction)));

        }
        field(5; PAYE; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period Filter"), "ED Code" = filter('PAYE')));

        }
        field(6; NSSF; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period Filter"), "ED Code" = filter('NSSF T1|NSSF T2')));
        }
        field(7; NHIF; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period Filter"), "ED Code" = filter('NHIF')));

        }
        field(8; "Period Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(9; HELB; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period Filter"), "ED Code" = filter('HELB')));

        }
        field(10; HLevy; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period Filter"), "ED Code" = filter('HLEVY')));

        }
        field(11; "Active Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where(Status = filter(Active)));

        }
        field(12; "Inactive Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where(Status = filter(Inactive)));

        }
        field(13; "Male Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where(Gender = filter(Male)));

        }
        field(14; "Female Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where(Gender = filter(Female)));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    var
}

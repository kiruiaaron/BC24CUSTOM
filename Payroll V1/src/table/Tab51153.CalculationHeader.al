/// <summary>
/// Table Calculation Header (ID 51153).
/// </summary>
table 51153 "Calculation Header"
{
    LookupPageID = 51151;

    fields
    {
        field(1; "Scheme ID"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Payroll Code"; Code[10])
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
        key(Key1; "Scheme ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Employee.SETRANGE("Calculation Scheme", "Scheme ID");
        IF Employee.FIND('-') THEN
            ERROR('This Calculation Scheme is Used')
        ELSE BEGIN
            SchemeLines.SETRANGE("Scheme ID", "Scheme ID");
            SchemeLines.DELETEALL;
        END;
    end;

    trigger OnInsert()
    begin
        IF "Payroll Code" = '' THEN "Payroll Code" := gvPayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation
    end;

    var
        Employee: Record Employee;
        SchemeLines: Record "Calculation Scheme";
        gvPayrollUtilities: Codeunit "Payroll Posting";
}


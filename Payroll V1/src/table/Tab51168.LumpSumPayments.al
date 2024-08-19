table 51168 "Lump Sum Payments"
{
    //DrillDownPageID = 52021083;
    // LookupPageID = 52021083;

    fields
    {
        field(1; "Line No"; BigInteger)
        {
            Editable = false;
        }
        field(2; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            var
                LoanRec: Record 51177;
            begin
                EmployeeRec.GET("Employee No");
                "Employee Name" := EmployeeRec."First Name" + ' ' + EmployeeRec."Middle Name" + ' ' + EmployeeRec."Last Name";
            end;
        }
        field(3; "Employee Name"; Text[30])
        {
            Editable = false;
        }
        field(4; "ED Code"; Code[20])
        {
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Payments),
                                                              "System Created" = CONST(true));
        }
        field(5; "ED Description"; Text[50])
        {
            CalcFormula = Lookup("ED Definitions"."Payroll Text" WHERE("ED Code" = FIELD("ED Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Amount (LCY)"; Decimal)
        {
        }
        field(8; "Assessment Year"; Integer)
        {
            Description = 'Determines the PAYE tax table and Relief table to use.';
        }
        field(9; "Annual Tax Table"; Code[20])
        {
            Description = 'Annual PAYE Table to Lookup to';
            TableRelation = "Lookup Table Header"."Table ID" WHERE("Calendar Year" = FIELD("Assessment Year"));
        }
        field(11; "Linked Payroll Entry No"; Integer)
        {
            Description = 'The Payroll Entry the lump sum payment has been processed to';
            Editable = false;
        }
        field(12; "Linked Payroll Line No"; Integer)
        {
            Description = 'The Payroll Line the lump sum payment has been processed to';
            Editable = false;
        }
        field(13; "Payroll Code"; Code[10])
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
        key(Key1; "Line No")
        {
        }
        key(Key2; "Employee No", "Assessment Year", "ED Code")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lvPayrollEntry: Record 51161;
        lvPayrollLine: Record 51160;
        lvPayrollHdr: Record 51159;
    begin
        IF ("Linked Payroll Entry No" <> 0) AND (lvPayrollEntry.GET("Linked Payroll Entry No")) THEN BEGIN
            lvPayrollHdr.GET(lvPayrollEntry."Payroll ID", lvPayrollEntry."Employee No.");
            lvPayrollHdr.Calculated := FALSE;
            lvPayrollHdr.MODIFY;
            lvPayrollEntry.DELETE;
        END;

        IF ("Linked Payroll Line No" <> 0) AND (lvPayrollLine.GET("Linked Payroll Line No")) THEN lvPayrollLine.DELETE;
    end;

    trigger OnInsert()
    begin
        IF "Payroll Code" = '' THEN "Payroll Code" := gvPayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation
    end;

    var
        EmployeeRec: Record 5200;
        gvPayrollUtilities: Codeunit 51152;
}


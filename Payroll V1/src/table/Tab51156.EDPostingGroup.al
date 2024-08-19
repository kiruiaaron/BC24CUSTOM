/// <summary>
/// Table ED Posting Group (ID 51156).
/// </summary>
table 51156 "ED Posting Group"
{
    LookupPageID = 51173;

    fields
    {
        field(1; "ED Posting Group"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[40])
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
        key(Key1; "ED Posting Group", "Payroll Code")
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
        gvPayrollUtilities: Codeunit "Payroll Posting";
}


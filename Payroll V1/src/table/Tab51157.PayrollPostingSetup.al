table 51157 "Payroll Posting Setup"
{

    fields
    {
        field(1; "Posting Group"; Code[20])
        {
            TableRelation = "Employee Posting Groups";
        }
        field(2; "ED Posting Group"; Code[20])
        {
            TableRelation = "ED Posting Group";
        }
        field(3; "Debit Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Credit Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Employee Posting Group"; Text[40])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Employee Posting Groups".Description WHERE("Posting Group" = FIELD("Posting Group")));

        }
        field(6; "E/D Posting Group"; Text[40])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("ED Posting Group".Description WHERE("ED Posting Group" = FIELD("ED Posting Group")));

        }
        field(7; "Debit Account Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("Debit Account")));

        }
        field(8; "Credit Account Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("Credit Account")));

        }
        field(9; "Include Dedit Dimension Codes"; Boolean)
        {
        }
        field(10; "Include Credit Dimension Codes"; Boolean)
        {
        }
        field(11; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;
        }
    }

    keys
    {
        key(Key1; "Posting Group", "ED Posting Group")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //"Payroll Code":='IGS';
    end;
}


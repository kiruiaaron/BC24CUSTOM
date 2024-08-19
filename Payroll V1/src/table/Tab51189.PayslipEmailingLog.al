table 51189 "Payslip E-mailing Log"
{

    fields
    {
        field(1; "Employee No"; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(2; "Payroll ID"; Code[10])
        {
            Editable = false;
            TableRelation = Periods;
        }
        field(3; Name; Text[30])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(4; "File Name"; Text[250])
        {
            Editable = false;
        }
        field(5; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
        }
        field(6; Sent; Boolean)
        {
        }
        field(7; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;
        }
    }

    keys
    {
        key(Key1; "Employee No")
        {
        }
        key(Key2; "Payroll ID")
        {
        }
    }

    fieldgroups
    {
    }
}


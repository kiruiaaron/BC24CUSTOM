/// <summary>
/// Table Allowed Payrolls (ID 51182).
/// </summary>
table 51182 "Allowed Payrolls"
{

    fields
    {
        field(1; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;
        }
        field(2; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";


        }
        field(3; "Valid to Date"; Date)
        {
        }
        field(4; "Last Active Payroll"; Boolean)
        {
            Description = 'Indicates the payroll the user had access to last';
            Editable = true;

            trigger OnValidate()
            begin
                //ERROR('Manual edit not allowed.')
            end;
        }
    }

    keys
    {
        key(Key1; "Payroll Code", "User ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //PayrollEdit;
    end;

    trigger OnInsert()
    begin
        //PayrollEdit;
    end;

    trigger OnModify()
    begin
        //PayrollEdit;
    end;

    trigger OnRename()
    begin
        //PayrollEdit;
    end;

    local procedure PayrollEdit()
    var
        UserSetup: Record 91;
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Payroll Admin" THEN
            ERROR('You are not allowed to edit this payroll!');
    end;
}


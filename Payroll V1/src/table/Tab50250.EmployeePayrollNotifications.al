table 50250 "Employee Payroll Notifications"
{

    fields
    {
        field(1;"Payroll Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Payroll;
        }
        field(2;"Employee no";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
    }

    keys
    {
        key(Key1;"Payroll Code","Employee no")
        {
        }
    }

    fieldgroups
    {
    }
}


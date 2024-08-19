table 51185 "Employee Customer Loan Link"
{
    //LookupPageID = 50205;

    fields
    {
        field(1; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "Customer No"; Code[20])
        {
            NotBlank = true;
            TableRelation = Customer;
        }
        field(3; "Loan Type"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Loan Types";
        }
    }

    keys
    {
        key(Key1; "Employee No", "Customer No", "Loan Type")
        {
        }
    }

    fieldgroups
    {
    }
}


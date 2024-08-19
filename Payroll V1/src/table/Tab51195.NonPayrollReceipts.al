table 51195 "Non Payroll Receipts"
{

    fields
    {
        field(1;"Employee No";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(2;"Employee Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"ED Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ED Definitions";
        }
        field(4;"Posting Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Employee No","ED Code","Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}


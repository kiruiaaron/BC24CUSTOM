table 50249 "Payroll entry Update"
{

    fields
    {
        field(1; "No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Ed Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ED Definitions" WHERE("Calculation Group" = CONST(Payments));
        }
        field(4; "New Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Period Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Periods;
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.", "Ed Code", "Period Id")
        {
        }
    }

    fieldgroups
    {
    }
}


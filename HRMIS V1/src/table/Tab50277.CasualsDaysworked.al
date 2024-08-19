table 50277 "Casuals Days worked"
{

    fields
    {
        field(1;"Casual no";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Date Worked";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;Paid;Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Casual no","Date Worked")
        {
        }
    }

    fieldgroups
    {
    }
}


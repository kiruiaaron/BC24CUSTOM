table 50330 "Probation Meeting Objective"
{

    fields
    {
        field(1;"Review No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Line No.";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3;Objective;Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Review No","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


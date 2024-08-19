table 50295 "PIP Progress Monitoring"
{

    fields
    {
        field(1;"Header No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee PIP";
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3;"Date Scheduled";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4;Activity;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Conducted By";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Date Completed";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Header No","Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


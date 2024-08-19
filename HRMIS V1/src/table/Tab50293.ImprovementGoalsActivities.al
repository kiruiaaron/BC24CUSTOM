table 50293 "Improvement Goals Activities"
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
        field(3;Goal;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Activity Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Activity;Text[250])
        {
            Caption = 'Issue Addressed by Meeting Goal';
            DataClassification = ToBeClassified;
        }
        field(6;"Start Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Projected date of Completion";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Header No",Goal,"Activity Code")
        {
        }
    }

    fieldgroups
    {
    }
}


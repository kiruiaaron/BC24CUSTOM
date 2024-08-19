table 50292 "Improvement Goals"
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
        field(3;Goal;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Description;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Issue Addressed by Goal";Text[30])
        {
            Caption = 'Issue Addressed by Meeting Goal';
            DataClassification = ToBeClassified;
        }
        field(6;"Goal Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Header No","Goal Code")
        {
        }
    }

    fieldgroups
    {
    }
}


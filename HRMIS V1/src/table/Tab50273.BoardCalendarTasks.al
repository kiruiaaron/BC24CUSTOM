table 50273 "Board Calendar Tasks"
{

    fields
    {
        field(1; "Calendar code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Start time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "End Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Activity/Task"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Venue; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Achieved,"Not Achieved";
        }
        field(9; "Expected Outcome"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Main Issue/Agenda"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Quarter; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'QTR 1,QTR 2,QTR 3,QTR 4';
            OptionMembers = "QTR 1","QTR 2","QTR 3","QTR 4";
        }
        field(13; "Board Committee"; Code[50])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Interview Committee Dep Header" WHERE (field 81=CONST(3));
        }
    }

    keys
    {
        key(Key1; "Calendar code", "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


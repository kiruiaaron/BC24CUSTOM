table 50272 "Board Calendar"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Type;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'CEO,Board,CMT';
            OptionMembers = CEO,Board,CMT;
        }
        field(3;Description;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Objective;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6;Notes;Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}


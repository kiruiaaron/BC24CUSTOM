table 50257 "Recruitment Plan Lines"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Job Details";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Recruitment & Selection";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Recruitment,Selection,Induction Training,Placement';
            OptionMembers = " ",Recruitment,Selection,"Induction Training",Placement;
        }
        field(4;"Plan Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Recruitment Plan";
        }
        field(5;Activity;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Responsible Parties";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Completion Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8;Strategy;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Not Accomplished,Accomplished';
            OptionMembers = "Not Accomplished",Accomplished;
        }
        field(10;Remarks;Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Plan Code","Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}


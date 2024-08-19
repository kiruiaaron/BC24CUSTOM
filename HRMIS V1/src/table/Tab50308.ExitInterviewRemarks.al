table 50308 "Exit Interview Remarks"
{

    fields
    {
        field(1;"Exit Interview No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;Category;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Job,Renumeration,Company,Line Manager,Management';
            OptionMembers = Job,Renumeration,Company,"Line Manager",Management;
        }
        field(4;Statement;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Response;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Strongly Disagree,Disagree,Agree,Strongly Agree';
            OptionMembers = " ","Strongly Disagree",Disagree,Agree,"Strongly Agree";
        }
        field(6;Remarks;Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Exit Interview No","Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


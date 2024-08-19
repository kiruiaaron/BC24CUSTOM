table 50289 "Appraisal Ratings"
{

    fields
    {
        field(1;Rating;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Exceptional,Very Good,Good,Average,Below Average';
            OptionMembers = " ",Exceptional,"Very Good",Good,"Average","Below Average";
        }
        field(2;"Overall Score";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Score Description";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Entry no";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(5;Indicator;Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entry no")
        {
        }
    }

    fieldgroups
    {
    }
}


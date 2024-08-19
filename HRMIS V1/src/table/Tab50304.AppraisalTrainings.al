table 50304 "Appraisal Trainings"
{

    fields
    {
        field(1;"Appraisal No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Line no";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;Training;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Impact;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Rating;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Poor,Average,Good,Very Good,Excellent';
            OptionMembers = " ",Poor,"Average",Good,"Very Good",Excellent;
        }
        field(6;"Knowledge & Skills Obtained";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Appraisal No","Line no")
        {
        }
    }

    fieldgroups
    {
    }
}


table 50305 "Evaluation Criterias"
{

    fields
    {
        field(1;"Evaluation Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Line No";Integer)
        {
            AutoIncrement = false;
            DataClassification = ToBeClassified;
        }
        field(3;Category;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'COURSE OBJECTIVES,TRAINING CONTENT,THE TRAINERS,LEARNING ACTIVITIES/MATERIALS';
            OptionMembers = "COURSE OBJECTIVES","TRAINING CONTENT","THE TRAINERS","LEARNING ACTIVITIES/MATERIALS";
        }
        field(4;"Evaluation Criteria";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Rating;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Poor,Fair,Average,Good,Excellent';
            OptionMembers = " ",Poor,Fair,"Average",Good,Excellent;

            trigger OnValidate()
            begin
                "Rating Weight":=Rating;
            end;
        }
        field(6;"Rating Weight";Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Evaluation Code","Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


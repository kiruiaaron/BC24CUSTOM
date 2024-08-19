page 50648 "Evaluation Criteria"
{
    PageType = Card;
    SourceTable = 50306;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
            part("Course Objectives"; 50643)
            {
                SubPageLink = "Evaluation Code" = FIELD(Code);
                ApplicationArea = All;
            }
            part("Training Content"; 50644)
            {
                SubPageLink = "Evaluation Code" = FIELD(Code);
                ApplicationArea = All;
            }
            part("The Trainers"; 50645)
            {
                SubPageLink = "Evaluation Code" = FIELD(Code);
                ApplicationArea = All;
            }
            part("Learning Activities"; 50646)
            {
                SubPageLink = "Evaluation Code" = FIELD(Code);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}


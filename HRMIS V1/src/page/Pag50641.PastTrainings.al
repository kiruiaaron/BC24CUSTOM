page 50641 "Past Trainings"
{
    AutoSplitKey = true;
    Caption = 'Effectiveness of Trainings Undertaken';
    PageType = ListPart;
    SourceTable = 50304;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line no"; Rec."Line no")
                {
                    ApplicationArea = All;
                }
                field(Training; Rec.Training)
                {
                    ApplicationArea = All;
                }
                field("Knowledge & Skills Obtained"; Rec."Knowledge & Skills Obtained")
                {
                    ApplicationArea = All;
                }
                field(Impact; Rec.Impact)
                {
                    Caption = 'Impact on Performance';
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


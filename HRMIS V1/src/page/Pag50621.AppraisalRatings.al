page 50621 "Appraisal Ratings"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50289;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Indicator; Rec.Indicator)
                {
                    ApplicationArea = All;
                }
                field(Rating; rec.Rating)
                {
                    ApplicationArea = All;
                }
                field("Overall Score"; Rec."Overall Score")
                {
                    ApplicationArea = All;
                }
                field("Score Description"; Rec."Score Description")
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


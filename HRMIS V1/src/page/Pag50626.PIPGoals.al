page 50626 "PIP Goals"
{
    PageType = ListPart;
    SourceTable = 50292;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Goal Code"; Rec."Goal Code")
                {
                    ApplicationArea = All;
                }
                field(Goal; Rec.Goal)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Issue Addressed by Goal"; Rec."Issue Addressed by Goal")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Activities)
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 50625;
                RunPageLink = "Header No" = FIELD("Header No"),
                              Goal = FIELD("Goal Code");
                ApplicationArea = All;
            }
        }
    }
}


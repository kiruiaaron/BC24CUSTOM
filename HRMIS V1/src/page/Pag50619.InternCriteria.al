page 50619 "Intern Criteria"
{
    PageType = ListPart;
    SourceTable = 50285;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Criteria code"; Rec."Criteria code")
                {
                    ApplicationArea = All;
                }
                field("Performance Criteria"; Rec."Performance Criteria")
                {
                    ApplicationArea = All;
                }
                field("Targeted Score"; Rec."Targeted Score")
                {
                    ApplicationArea = All;
                }
                field("Achieved Score"; Rec."Achieved Score")
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
            action(KPIs)
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50620;
                RunPageLink = "Header No" = FIELD("Header No"),
                              "Criteria code" = FIELD("Criteria code");
                ApplicationArea = All;
            }
        }
    }
}


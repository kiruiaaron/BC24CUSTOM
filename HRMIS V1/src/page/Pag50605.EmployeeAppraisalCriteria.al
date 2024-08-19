page 50605 "Employee Appraisal Criteria"
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
            action(Targets)
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50605;
                RunPageLink = "Header No" = FIELD("Header No"),
                              "Criteria code" = FIELD("Criteria code");
                ApplicationArea = All;
            }
        }
    }
}


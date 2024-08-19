page 50675 "Appraisal Target Card"
{
    Caption = 'Performance Activities';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50288;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Criteria code"; Rec."Criteria code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Target Code"; Rec."Target Code")
                {
                    ApplicationArea = All;
                }
                field("Performance Targets"; Rec."Performance Targets")
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
            action("Target Notes")
            {
                Image = OpportunitiesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50549;
                RunPageLink = "Header No" = FIELD("Header No");
                ApplicationArea = All;
                //  "Target Code" = FIELD("Target Code");
            }
        }
    }
}


page 50714 "Emp Appraisal Target Scoring"
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
                field(Weights; Rec.Weights)
                {
                    ApplicationArea = All;
                }
                field("Targeted Score"; Rec."Targeted Score")
                {
                    ApplicationArea = All;
                }
                field("Achieved Score Employee"; Rec."Achieved Score Employee")
                {
                    ApplicationArea = All;
                }
            }
            part("Appraisal Performance Standards"; 50712)
            {
                Caption = 'Appraisal Performance Standards';
                SubPageLink = "Header No" = FIELD("Header No"),
                              "Criteria code" = FIELD("Criteria code"),
                              "Target Code" = FIELD("Target Code");
                ApplicationArea = All;
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
                /*  "Criteria code" = FIELD("Criteria code"),
                 "Target Code" = FIELD("Target Code"); */
            }
        }
    }
}


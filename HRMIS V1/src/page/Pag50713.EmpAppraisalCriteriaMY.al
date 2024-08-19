page 50713 "Emp. Appraisal Criteria MY"
{
    AutoSplitKey = true;
    Caption = 'Kery Performance Activities';
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
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Performance Criteria"; Rec."Performance Criteria")
                {
                    ApplicationArea = All;
                }
                field("Objective Weightage"; Rec."Objective Weightage")
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
                field("weighted Results Employee"; Rec."weighted Results Employee")
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
                Caption = 'Performance Activities';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50714;
                RunPageLink = "Header No" = FIELD("Header No"),
                              "Criteria code" = FIELD("Criteria code");
                ApplicationArea = All;
            }
        }
    }
}


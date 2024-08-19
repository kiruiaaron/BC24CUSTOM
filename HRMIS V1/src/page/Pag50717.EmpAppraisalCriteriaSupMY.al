page 50717 "Emp. Appraisal Criteria Sup MY"
{
    AutoSplitKey = true;
    Caption = 'Key Performance Activities';
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
                field("Achieved Score Supervisor"; Rec."Achieved Score Supervisor")
                {
                    ApplicationArea = All;
                }
                field("Weighted Results Supervisor"; Rec."Weighted Results Supervisor")
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
                RunObject = Page 50718;
                RunPageLink = "Header No" = FIELD("Header No"),
                              "Criteria code" = FIELD("Criteria code");
                ApplicationArea = All;
            }
        }
    }
}


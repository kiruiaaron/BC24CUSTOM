page 50551 "Appraisal Targets List"
{
    Caption = 'Appraisal Performance Activities';
    PageType = ListPart;
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
                field("Targeted Score"; Rec."Targeted Score")
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
                RunPageLink = "Header No" = FIELD("Header No");/* ,
                              "Criteria code" = FIELD("Criteria code"),
                              "Target Code" = FIELD("Target Code"); */
                ApplicationArea = All;
            }
        }
    }
}


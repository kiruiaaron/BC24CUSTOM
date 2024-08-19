page 50620 "Intern Key Perform Indicators"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    PageType = ListPart;
    SourceTable = 50283;

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
                field("Indicator Code"; Rec."Indicator Code")
                {
                    ApplicationArea = All;
                }
                field("Specific Indicator"; Rec."Specific Indicator")
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
                field(Remarks; Rec.Remarks)
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


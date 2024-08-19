page 50610 "Emp Appraisal Indicators Sub"
{
    DeleteAllowed = false;
    InsertAllowed = false;
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
                field("Target Code"; Rec."Target Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Indicator Code"; Rec."Indicator Code")
                {
                    ApplicationArea = All;
                }
                field("Specific Indicator"; Rec."Specific Indicator")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Unit of Measurement"; Rec."Unit of Measurement")
                {
                    ApplicationArea = All;
                }
                field(Weights; Rec.Weights)
                {
                    ApplicationArea = All;
                }
                field("Target Date"; Rec."Target Date")
                {
                    ApplicationArea = All;
                }
                field("Targeted Score"; Rec."Targeted Score")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Achieved Score Employee"; Rec."Achieved Score Employee")
                {
                    ApplicationArea = All;
                }
                field(Remarks;Rec.Remarks)
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


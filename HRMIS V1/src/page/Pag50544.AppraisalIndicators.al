page 50544 "Appraisal Indicators"
{
    Caption = 'Appraisal Performance Standards';
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
                field("Performance Targets"; Rec."Performance Targets")
                {
                    ApplicationArea = All;
                }
                field("Indicator Code"; Rec."Indicator Code")
                {
                    Caption = 'Standard Code';
                    ApplicationArea = All;
                }
                field("Specific Indicator"; Rec."Specific Indicator")
                {
                    Caption = 'Specific Standard';
                    ApplicationArea = All;
                }
                field("Unit of Measurement"; Rec."Unit of Measurement")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Weights; Rec.Weights)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Target Date"; Rec."Target Date")
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
    }
}


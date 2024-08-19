page 50548 "Appraisal Indicators Targets L"
{
    Caption = 'Appraisal Indicators Subform Targets';
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
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Specific Indicator"; Rec."Specific Indicator")
                {
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
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


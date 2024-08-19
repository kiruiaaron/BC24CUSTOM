page 50729 "Emp-Sup Appraisal Ind- MY"
{
    Caption = 'Employee Supevisor Appraisal Indicators Subform MY';
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
                field(Weights; Rec.Weights)
                {
                    ApplicationArea = All;
                }
                field("Target Date"; Rec."Target Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Targeted Score"; Rec."Targeted Score")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Achieved Score Employee"; Rec."Achieved Score Employee")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Achieved Score Supervisor"; Rec."Achieved Score Supervisor")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Achieved Score"; Rec."Achieved Score")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


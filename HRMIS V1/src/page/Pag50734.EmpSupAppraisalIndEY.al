page 50734 "Emp-Sup Appraisal Ind- EY"
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
                field("Achieved Score EY Employee"; Rec."Achieved Score EY Employee")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Achieved Score EY Supervisor"; Rec."Achieved Score EY Supervisor")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Achieved Score EY"; Rec."Achieved Score EY")
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


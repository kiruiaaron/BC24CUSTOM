page 50238 "Individual Appraisal Lines"
{
    PageType = ListPart;
    SourceTable = 50142;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal Objective"; Rec."Appraisal Objective")
                {
                    ApplicationArea = All;
                }
                field("Organization Activity Code"; Rec."Organization Activity Code")
                {
                    ApplicationArea = All;
                }
                field("Organization Activity Descrp"; Rec."Organization Activity Descrp")
                {
                    ApplicationArea = All;
                }
                field("Departmental Activity Code"; Rec."Departmental Activity Code")
                {
                    ApplicationArea = All;
                }
                field("Departmental Activity Descrp"; Rec."Departmental Activity Descrp")
                {
                    ApplicationArea = All;
                }
                field("Divisional Activity Code"; Rec."Divisional Activity Code")
                {
                    ApplicationArea = All;
                }
                field("Divisional Activity Descrp"; Rec."Divisional Activity Descrp")
                {
                    ApplicationArea = All;
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        //AssistEdit;
                    end;
                }
                field("Activity Description"; Rec."Activity Description")
                {
                    ApplicationArea = All;
                }
                field("Objective Weight"; Rec."Objective Weight")
                {
                    ApplicationArea = All;
                }
                field("Activity Weight"; Rec."Activity Weight")
                {
                    ApplicationArea = All;
                }
                field("Target Value"; Rec."Target Value")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Score Type"; Rec."Appraisal Score Type")
                {
                    ApplicationArea = All;
                }
                field("Parameter Type"; Rec."Parameter Type")
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Actual Output Description"; Rec."Actual Output Description")
                {
                    ApplicationArea = All;
                }
                field("Actual Value"; Rec."Actual Value")
                {
                    ApplicationArea = All;
                }
                field("Self Assessment Rating"; Rec."Self Assessment Rating")
                {
                    ApplicationArea = All;
                }
                field("Self Assessment Weighted Rat."; Rec."Self Assessment Weighted Rat.")
                {
                    ApplicationArea = All;
                }
                field("Actual agreed Value"; Rec."Actual agreed Value")
                {
                    ApplicationArea = All;
                }
                field("Agreed Rating with Supervisor"; Rec."Agreed Rating with Supervisor")
                {
                    ApplicationArea = All;
                }
                field("Weighted Rat. With Supervisor"; Rec."Weighted Rat. With Supervisor")
                {
                    ApplicationArea = All;
                }
                field("Moderated Value"; Rec."Moderated Value")
                {
                    ApplicationArea = All;
                }
                field("Moderated Assessment Rating"; Rec."Moderated Assessment Rating")
                {
                    ApplicationArea = All;
                }
                field("Weighted Rat. Moderated Value"; Rec."Weighted Rat. Moderated Value")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        ObjectiveWeightEditable: Boolean;
        ActivityWeightEditable: Boolean;
        TargetValueEditable: Boolean;
        AppraisalScoreType: Boolean;
}


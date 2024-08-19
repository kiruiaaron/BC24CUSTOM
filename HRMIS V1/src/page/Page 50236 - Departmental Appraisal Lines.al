page 50236 "Departmental Appraisal Lines"
{
    PageType = ListPart;
    SourceTable = 50140;

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
                field("Activity option"; Rec."Activity option")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF Rec."Activity option" = Rec."Activity option"::"Final-Level" THEN BEGIN
                            ObjectiveWeightEditable := TRUE;
                            ActivityWeightEditable := TRUE;
                            TargetValueEditable := TRUE;
                        END;


                        IF Rec."Activity option" = Rec."Activity option"::"Cascade-Down" THEN BEGIN
                            ObjectiveWeightEditable := FALSE;
                            ActivityWeightEditable := FALSE;
                            TargetValueEditable := FALSE;
                        END;
                    end;
                }
                field("Objective Weight"; Rec."Objective Weight")
                {
                    Editable = ObjectiveWeightEditable;
                    ApplicationArea = All;
                }
                field("Activity Weight"; Rec."Activity Weight")
                {
                    Editable = ActivityWeightEditable;
                    ApplicationArea = All;
                }
                field("Target Value"; Rec."Target Value")
                {
                    Editable = TargetValueEditable;
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


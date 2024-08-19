page 50683 "Probation First Review Card"
{
    PageType = Card;
    SourceTable = 50332;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Review No."; Rec."Review No.")
                {
                    ApplicationArea = All;
                }
                field("First Review Date"; Rec."First Review Date")
                {
                    ApplicationArea = All;
                }
                field("Performance Summary"; Rec."Performance Summary")
                {
                    ApplicationArea = All;
                }
                field("Objectives Met?"; Rec."Objectives Met?")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF NOT Rec."Objectives Met?" THEN
                            ObjMetVisible := TRUE ELSE
                            ObjMetVisible := FALSE;
                    end;
                }
                group(Group)
                {
                    Visible = ObjMetVisible;
                    field("Objectives Met Action"; Rec."Objectives Met Action")
                    {
                        ApplicationArea = All;
                    }
                    field("Objective Met Review Date"; Rec."Objective Met Review Date")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Training Need Addressed?"; Rec."Training Need Addressed?")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF NOT Rec."Training Need Addressed?" THEN
                            TrainingNeedVisble := FALSE
                        ELSE
                            TrainingNeedVisble := TRUE;
                    end;
                }
                group(g1)
                {
                    Visible = TrainingNeedVisble;
                    field("Training Need Action"; Rec."Training Need Action")
                    {
                        ApplicationArea = All;
                    }
                    field("Training Need Review Date"; Rec."Training Need Review Date")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            part(sbpg; 50684)
            {
                SubPageLink = "Review No." = FIELD("Review No.");
                ApplicationArea = All;
                //   "First/Final" = FILTER(First);
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        IF NOT Rec."Objectives Met?" THEN
            ObjMetVisible := TRUE
        ELSE
            ObjMetVisible := FALSE;

        IF NOT Rec."Training Need Addressed?" THEN
            TrainingNeedVisble := FALSE
        ELSE
            TrainingNeedVisble := TRUE;
    end;

    var
        ObjMetVisible: Boolean;
        TrainingNeedVisble: Boolean;
}


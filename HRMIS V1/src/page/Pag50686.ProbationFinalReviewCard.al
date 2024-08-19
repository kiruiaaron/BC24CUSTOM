page 50686 "Probation Final Review Card"
{
    PageType = Card;
    SourceTable = 50335;

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
                field("Final Review Date"; Rec."Final Review Date")
                {
                    ApplicationArea = All;
                }
                part(sbpg; 50684)
                {
                    SubPageLink = "Review No." = FIELD("Review No.");
                    ApplicationArea = All;
                    //  "First/Final" = FILTER(Final);
                }
            }
            group(gr)
            {
                field("Objectives Met?"; Rec."Objectives Met?")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF Rec."Objectives Met?" = FALSE THEN
                            ObjectiveReasonVisible := TRUE
                        ELSE
                            ObjectiveReasonVisible := FALSE;
                    end;
                }
                group(g1)
                {
                    Caption = 'Reason';
                    Visible = ObjectiveReasonVisible;
                    field("Reason Objective Not Met"; Rec."Reason Objective Not Met")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Training Need Addressed?"; Rec."Training Need Addressed?")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF Rec."Training Need Addressed?" = FALSE THEN
                            TrainingReasonVisible := TRUE
                        ELSE
                            TrainingReasonVisible := FALSE;
                    end;
                }
                group(Reason)
                {
                    Caption = 'Reason';
                    Visible = TrainingReasonVisible;
                    field("Reason Training Not Met"; Rec."Reason Training Not Met")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Performance Summary"; Rec."Performance Summary")
                {
                    ApplicationArea = All;
                }
                field("Appointment to be Confirmed"; Rec."Appointment to be Confirmed")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF Rec."Appointment to be Confirmed" = FALSE THEN
                            ReasonNotConfirmedVisible := TRUE
                        ELSE
                            ReasonNotConfirmedVisible := FALSE;
                    end;
                }
                group(Group)
                {
                    Visible = ReasonNotConfirmedVisible;
                    field("Reasons For Not Confirming"; Rec."Reasons For Not Confirming")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Employee Comments"; Rec."Employee Comments")
                {
                    ApplicationArea = All;
                }
                field("Extend Probation Period"; Rec."Extend Probation Period")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF Rec."Extend Probation Period" = TRUE THEN
                            ExtendDetailsVisible := TRUE
                        ELSE
                            ExtendDetailsVisible := FALSE;
                    end;
                }
                group("Extension Details")
                {
                    Caption = 'Extension Details';
                    Visible = ExtendDetailsVisible;
                    field("Reason For Extension"; Rec."Reason For Extension")
                    {
                        ApplicationArea = All;
                    }
                    field("Length Of Extension"; Rec."Length Of Extension")
                    {
                        ApplicationArea = All;
                    }
                    field("New Probation End Date"; Rec."New Probation End Date")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Confirmation Letter Sent"; Rec."Confirmation Letter Sent")
                {
                    ApplicationArea = All;
                }
                field("Signatory Employee"; Rec."Signatory Employee")
                {
                    ApplicationArea = All;
                }
                field("Signatory Employee Name"; Rec."Signatory Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Signatory Employee Title"; Rec."Signatory Employee Title")
                {
                    ApplicationArea = All;
                }

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
        area(reporting)
        {
            action("Review Report")
            {
                Caption = 'Review Report';
                Image = "Report";
                Promoted = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CLEAR(ProbationReviewRepor);
                    Rec.SETRANGE("Review No.", Rec."Review No.");
                    ProbationReviewRepor.SETTABLEVIEW(Rec);
                    ProbationReviewRepor.RUN;
                end;
            }
            action("Confirmation Letter")
            {
                Caption = 'Confirmation Letter';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CLEAR(ConfirmationLetter1RPt);
                    Rec.TESTFIELD("Appointment to be Confirmed");
                    Rec.SETRANGE("Review No.", Rec."Review No.");
                    ConfirmationLetter1RPt.SETTABLEVIEW(Rec);
                    ConfirmationLetter1RPt.RUN;
                end;
            }
            action("Extend Probation Letter")
            {
                Caption = 'Probation Extension Letter';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CLEAR(ExtensionofProbationRpt);
                    Rec.TESTFIELD("Extend Probation Period");
                    Rec.SETRANGE("Review No.", Rec."Review No.");
                    ExtensionofProbationRpt.SETTABLEVIEW(Rec);
                    ExtensionofProbationRpt.RUN;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IF Rec."Extend Probation Period" = FALSE THEN
            ExtendDetailsVisible := FALSE
        ELSE
            ExtendDetailsVisible := TRUE;

        IF Rec."Objectives Met?" = FALSE THEN
            ObjectiveReasonVisible := TRUE
        ELSE
            ObjectiveReasonVisible := FALSE;

        IF Rec."Training Need Addressed?" = FALSE THEN
            TrainingReasonVisible := TRUE
        ELSE
            TrainingReasonVisible := FALSE;
        IF Rec."Appointment to be Confirmed" = FALSE THEN
            ReasonNotConfirmedVisible := TRUE
        ELSE
            ReasonNotConfirmedVisible := FALSE;
    end;

    var
        ExtendDetailsVisible: Boolean;
        ObjectiveReasonVisible: Boolean;
        TrainingReasonVisible: Boolean;
        ReasonNotConfirmedVisible: Boolean;
        ProbationReviewRepor: Report 52205;
        ConfirmationLetter1RPt: Report 52206;
        ExtensionofProbationRpt: Report 52207;
}


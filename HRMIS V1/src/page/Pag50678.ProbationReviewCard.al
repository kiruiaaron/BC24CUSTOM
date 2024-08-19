page 50678 "Probation Review Card"
{
    PageType = Card;
    SourceTable = 50328;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field(Grade; Rec.Grade)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Department/Section"; Rec."Department/Section")
                {
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                }
                field("Post Start Date"; Rec."Post Start Date")
                {
                    ApplicationArea = All;
                }
                field("Line Manager"; Rec."Line Manager")
                {
                    ApplicationArea = All;
                }
                field("Line Manager Name"; Rec."Line Manager Name")
                {
                    ApplicationArea = All;
                }
                field("Review Stage"; Rec."Review Stage")
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
        area(navigation)
        {
            action("Probation Review Meeting Card")
            {
                Caption = 'Probation Review Meeting Card';
                Image = Group;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ProbationReviewMeetingRec.RESET;
                    ProbationReviewMeetingRec.SETRANGE("Review No.", Rec."No.");
                    IF NOT ProbationReviewMeetingRec.FINDFIRST THEN BEGIN
                        ProbationReviewMeetingRec.INIT;
                        ProbationReviewMeetingRec."Review No." := Rec."No.";
                        ProbationReviewMeetingRec.INSERT;
                        ProbationReviewMeetingCardPg.SETTABLEVIEW(ProbationReviewMeetingRec);
                        ProbationReviewMeetingCardPg.RUN;
                    END ELSE BEGIN
                        ProbationReviewMeetingCardPg.SETTABLEVIEW(ProbationReviewMeetingRec);
                        ProbationReviewMeetingCardPg.RUN;
                    END;
                end;
            }
            action("Probation First Review Card")
            {
                Caption = 'Probation First Review Card';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ProbationFirstReviewRec.RESET;
                    ProbationFirstReviewRec.SETRANGE("Review No.", Rec."No.");
                    IF NOT ProbationFirstReviewRec.FINDFIRST THEN BEGIN
                        ProbationFirstReviewRec.INIT;
                        ProbationFirstReviewRec."Review No." := Rec."No.";
                        ProbationFirstReviewRec.INSERT;
                        ProbationFirstReviewCardPg.SETTABLEVIEW(ProbationFirstReviewRec);
                        ProbationFirstReviewCardPg.RUN;
                    END ELSE BEGIN
                        ProbationFirstReviewCardPg.SETTABLEVIEW(ProbationFirstReviewRec);
                        ProbationFirstReviewCardPg.RUN;
                    END;
                end;
            }
            action("Probation Final Review Card")
            {
                Caption = 'Probation Final Review Card';
                Image = StepOut;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ProbationFinalReviewRec.RESET;
                    ProbationFinalReviewRec.SETRANGE("Review No.", Rec."No.");
                    IF NOT ProbationFinalReviewRec.FINDFIRST THEN BEGIN
                        ProbationFinalReviewRec.INIT;
                        ProbationFinalReviewRec."Review No." := Rec."No.";
                        ProbationFinalReviewRec.INSERT;
                        ProbationFinalReviewCardPg.SETTABLEVIEW(ProbationFinalReviewRec);
                        ProbationFinalReviewCardPg.RUN;
                    END ELSE BEGIN
                        ProbationFinalReviewCardPg.SETTABLEVIEW(ProbationFinalReviewRec);
                        ProbationFinalReviewCardPg.RUN;
                    END;
                end;
            }
        }
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
                    Rec.SETRANGE("No.", Rec."No.");
                    ProbationReviewRepor.SETTABLEVIEW(Rec);
                    ProbationReviewRepor.RUN;
                end;
            }
        }
        area(processing)
        {
            action("Initial Meeting")
            {
                Caption = 'Initial Meeting';
                Image = MoveUp;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM('Are you sure you want to move this to Initial Meeting?') THEN BEGIN
                        Rec."Review Stage" := Rec."Review Stage"::"Initial Meeting";
                        Rec.MODIFY;
                        MESSAGE('Successfully moved');
                    END;
                end;
            }
        }
    }

    var
        ProbationReviewMeetingCardPg: Page 50680;
        ProbationReviewMeetingRec: Record 50329;
        ProbationFirstReviewRec: Record 50332;
        ProbationFirstReviewCardPg: Page 50683;
        ProbationFinalReviewCardPg: Page 50686;
        ProbationFinalReviewRec: Record 50335;
        ProbationReviewRepor: Report 52205;
}


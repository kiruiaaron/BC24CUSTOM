page 50693 "Probation Review Card-Final"
{
    PageType = Card;
    SourceTable = 50328;
    SourceTableView = WHERE("Review Stage" = CONST("6-Month Review"));

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
        }
        area(creation)
        {
            action("Probation Final Review Card")
            {
                Caption = 'Probation Final Review Card';
                Image = StepOut;
                Promoted = true;
                PromotedCategory = Process;
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
        area(processing)
        {
            action(Close)
            {
                Caption = 'Close';
                Image = Close;
                ApplicationArea = All;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF CONFIRM('Are you sure you want to move this to Initial Meeting?') THEN BEGIN
                        Rec."Review Stage" := Rec."Review Stage"::Closed;
                        Rec.MODIFY;
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
                PromotedCategory = Category4;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CLEAR(ProbationReviewRepor);
                    Rec.SETRANGE("No.", Rec."No.");
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
                    Rec.SETRANGE("No.", Rec."No.");
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
                    Rec.SETRANGE("No.", Rec."No.");
                    ExtensionofProbationRpt.SETTABLEVIEW(Rec);
                    ExtensionofProbationRpt.RUN;
                end;
            }
            action("Termination Letter")
            {
                Caption = 'Termination Letter';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CLEAR(TerminationLetterRpt);
                    Rec.SETRANGE("No.", Rec."No.");
                    TerminationLetterRpt.SETTABLEVIEW(Rec);
                    TerminationLetterRpt.RUN;
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
        ConfirmationLetter1RPt: Report 52206;
        ExtensionofProbationRpt: Report 52207;
        TerminationLetterRpt: Report 52216;
}


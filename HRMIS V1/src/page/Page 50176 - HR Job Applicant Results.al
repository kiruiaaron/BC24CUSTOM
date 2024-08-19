page 50176 "HR Job Applicant Results"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50110;
    SourceTableView = SORTING(Total)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Applicant No"; Rec."Job Applicant No")
                {
                    ApplicationArea = All;
                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = All;
                }
                field(Firstname; Rec.Firstname)
                {
                    ApplicationArea = All;
                }
                field(Middlename; Rec.Middlename)
                {
                    ApplicationArea = All;
                }
                field("EV 1"; Rec."EV 1")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field("EV 2"; Rec."EV 2")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field("EV 3"; Rec."EV 3")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field("EV 4"; Rec."EV 4")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field("EV 5"; Rec."EV 5")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field("EV 6"; Rec."EV 6")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field("EV 7"; Rec."EV 7")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field("EV 8"; Rec."EV 8")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field("EV 9"; Rec."EV 9")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field("EV 10"; Rec."EV 10")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Closed, FALSE);
                    end;
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = All;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Rank Interviewees")
            {
                Caption = 'Rank Interviewees';
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    EmployeeRecruitment.RankInterviewees(Rec."Job Requistion No", Rec."Job No");
                end;
            }
            action("Print Final Score Sheet")
            {
                Caption = 'Print Final Score Sheet';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    JobApplicantResults.RESET;
                    JobApplicantResults.SETRANGE("Job Requistion No", Rec."Job Requistion No");
                    IF JobApplicantResults.FINDFIRST THEN;
                    //REPORT.RUN(REPORT::"HR Interview Results Report", TRUE, TRUE, JobApplicantResults);
                end;
            }
            action("Calculate Totals")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    EmployeeRecruitment.CalculateResultsTotals(Rec."Job Requistion No", Rec."Job No");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IF Rec.Closed = TRUE THEN
            CurrPage.EDITABLE(FALSE);
    end;

    trigger OnOpenPage()
    begin
        IF Rec.Closed = TRUE THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        EmployeeRecruitment: Codeunit 50033;
        JobApplicantResults: Record 50110;
}


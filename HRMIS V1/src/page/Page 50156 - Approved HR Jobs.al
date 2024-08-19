page 50156 "Approved HR Jobs"
{
    CardPageID = "Approved HR Job Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50093;
    SourceTableView = WHERE(Status = CONST(Released));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the Job Title.';
                    ApplicationArea = All;
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ToolTip = 'Specifies the Job Grade.';
                    ApplicationArea = All;
                }
                field("Maximum Positions"; Rec."Maximum Positions")
                {
                    ToolTip = 'Specifies the Maximum positions for a specific Job.';
                    ApplicationArea = All;
                }
                field("Occupied Positions"; Rec."Occupied Positions")
                {
                    ToolTip = 'Specifies the occupied positions for a specific Job.';
                    ApplicationArea = All;
                }
                field("Vacant Positions"; Rec."Vacant Positions")
                {
                    ApplicationArea = All;
                }
                field("Supervisor Job No."; Rec."Supervisor Job No.")
                {
                    ToolTip = 'Specifies the Supervisor''s Job Number.';
                    ApplicationArea = All;
                }
                field("Supervisor Job Title"; Rec."Supervisor Job Title")
                {
                    ToolTip = 'Specifies the Supervisor''s Job Title.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    OptionCaption = '<Open,Pending Approval,Approved,Rejected>';
                    ToolTip = 'Specifies the status.';
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
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
            action("Job Qualifications")
            {
                Caption = 'Job Qualifications';
                Image = BulletList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "HR Job Qualifications";
                RunPageLink = "Job No." = FIELD("No.");
                ToolTip = 'Specifies the Job Qualification Requirements';
                ApplicationArea = All;
            }
            action("Job Requirements")
            {
                Image = BusinessRelation;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "HR Job Requirements";
                //  RunPageLink = "Job No." = FIELD("No.");
                ToolTip = 'Specifies the Job General Requirements';
                ApplicationArea = All;
            }
            action("Job Responsibilities")
            {
                Caption = 'Job Responsibilities';
                Image = ResourceSkills;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50160;
                RunPageLink = "Job No." = FIELD("No.");
                ToolTip = 'Specifies the Job Responsibilities';
                ApplicationArea = All;
            }
            action("Salary Notch")
            {
                Image = JobLedger;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50161;
                RunPageLink = Option = CONST("Job Grade Level");
                ApplicationArea = All;
            }
            action(Reopen)
            {
                Caption = 'Reopen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt_001, FALSE, Rec."No.") THEN BEGIN
                        HRJobManagement.ReOpenReleasedJobs(Rec);
                    END;
                end;
            }
            action("Deactivate Job")
            {
                Caption = 'Deactivate Job';
                Image = DisableAllBreakpoints;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Deactivate Job from being Active. Active has to be false.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt_002, FALSE, Rec."No.") THEN BEGIN
                        HRJobManagement.DeactivateReleasedJobs(Rec);
                    END;
                end;
            }
            action("Reactivate Job")
            {
                Caption = 'Reactivate Job';
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Reactivate Job after it has been deactivated. Active has to be true.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt_003, FALSE, Rec."No.") THEN BEGIN
                        HRJobManagement.ReactivateReleasedJobs(Rec);
                    END;
                end;
            }
            action("Job Details Report")
            {
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRJobs.RESET;
                    HRJobs.SETRANGE(HRJobs."No.", Rec."No.");
                    IF HRJobs.FINDFIRST THEN BEGIN
                        //   REPORT.RUNMODAL(REPORT::"HR Job Details", TRUE, FALSE, HRJobs);
                    END;
                end;
            }
            action("HR Establishement Report")
            {
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;
                //   RunObject = Report 50071;

                trigger OnAction()
                begin
                    HRJobs.RESET;
                    //  REPORT.RUNMODAL(REPORT::"HR Jobs", TRUE, FALSE, HRJobs);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CALCFIELDS("Occupied Positions");
        Rec."Vacant Positions" := Rec."Maximum Positions" - Rec."Occupied Positions";
        Rec.MODIFY;
    end;

    var
        Txt_001: Label 'Reopen Approved Job.:%1';
        HRJobManagement: Codeunit 50032;
        HRJobs: Record 50093;
        Txt_002: Label 'Are you sure you want to Deactivate Approved Job.:%1';
        Txt_003: Label 'Are you sure you want to Reactivate Approved Job.:%1';
}


page 50155 "HR Job Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 50093;
    SourceTableView = WHERE(Status = FILTER(<> Released));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the Job number.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Job Title.';
                    ApplicationArea = All;
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ApplicationArea = All;
                }
                field("Maximum Positions"; Rec."Maximum Positions")
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the maximum positions for a specific Job.';
                    ApplicationArea = All;
                }
                field("Occupied Positions"; Rec."Occupied Positions")
                {
                    ToolTip = 'Specifies the occupied positions for a specific Job.';
                    ApplicationArea = All;
                }
                field("Vacant Positions"; Rec."Vacant Positions")
                {
                    ToolTip = 'Specifies vacant Positions for a specific Job.';
                    ApplicationArea = All;
                }
                field("Supervisor Job No."; Rec."Supervisor Job No.")
                {
                    ToolTip = 'Specifies the supervisor''s Job Number.';
                    ApplicationArea = All;
                }
                field("Supervisor Job Title"; Rec."Supervisor Job Title")
                {
                    ToolTip = 'Specifies supervisor''s Job Title.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the Job Status.';
                    ApplicationArea = All;
                }
                field("Appraisal Level"; Rec."Appraisal Level")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user ID that created the Job.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
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
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HR Job Qualifications";
                // RunPageLink = "Job No." = FIELD("No.");
                ToolTip = 'Specifies the Job Qualification Requirements';
                ApplicationArea = All;
            }
            action("Job Requirements")
            {
                Image = BusinessRelation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HR Job Requirements";
                RunPageLink = "Job No." = FIELD("No.");
                ToolTip = 'Specifies the Job General Requirements';
                ApplicationArea = All;
            }
            action("Job Responsibilities")
            {
                Caption = 'Job Responsibilities';
                Image = ResourceSkills;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50160;
                RunPageLink = "Job No." = FIELD("No.");
                ToolTip = 'Specifies the Job Responsibilities';
                ApplicationArea = All;
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
            action("Salary Notch")
            {
                Image = JobLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50161;
                RunPageLink = Option = CONST("Job Grade Level");
                ApplicationArea = All;
            }
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Send Job for Approval';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Open);
                    HRJobManagement.CheckHRJobMandatoryFields(Rec);
                    IF ApprovalsMgmtExt.IsHRJobApprovalsWorkflowEnabled(Rec) THEN
                        ApprovalsMgmtExt.OnSendHRJobForApproval(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Approve HR Job")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Approve HR Job for Employee Requisitions';
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(ApproveHRJobForJobApplication, FALSE, Rec."No.") THEN BEGIN
                        Rec.Status := Rec.Status::Released;
                        IF Rec.MODIFY THEN
                            MESSAGE(ApproveHRJobSuccessful);
                    END;
                end;
            }
            action(Approvals)
            {
                AccessByPermission = TableData 454 = R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                PromotedOnly = true;
                /* RunObject = Page "Approval Entries";
                 RunPageLink = "Document No." = FIELD("No.");*/
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    WorkflowsEntriesBuffer: Record 832;
                    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund",Requisition,"Funds Transfer","HR Document";
                begin
                    //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(RECORDID,DATABASE::"HR Jobs","No.");
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                    ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                // WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                begin
                    ApprovalsMgmtExt.CheckHRJobApprovalsWorkflowEnabled(Rec);
                    //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    end;

                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF HRJobManagement.CheckOpenJobExists(USERID) THEN
            ERROR(OpenJobCardExist);
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        HRJobManagement: Codeunit 50032;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        ApproveHRJobForJobApplication: Label 'Approve HR Job No. %1 for Employee Requisition?';
        ApproveHRJobSuccessful: Label 'HR Job Approved Successfully, Proceed to Employee Requisitions.';
        OpenJobCardExist: Label 'Open Job Card Exists for User ID:%1. Please use it before opening another one';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        HRJobs: Record 50093;
}


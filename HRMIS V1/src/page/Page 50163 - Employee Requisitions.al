page 50163 "Employee Requisitions"
{
    CardPageID = "Employee Requisition Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50098;
    SourceTableView = WHERE(Status = FILTER(<> Closed));

    layout
    {
        area(content)
        {
            repeater(General1)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number.';
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the Job Number.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the Job Title.';
                    ApplicationArea = All;
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ToolTip = 'Specifies the Job grade.';
                    ApplicationArea = All;
                }
                field("Maximum Positions"; Rec."Maximum Positions")
                {
                    ToolTip = 'Specifies the maximum number of position.';
                    ApplicationArea = All;
                }
                field("Vacant Positions"; Rec."Vacant Positions")
                {
                    ToolTip = 'Specifies the Vacant positions.';
                    ApplicationArea = All;
                }
                field("Requested Employees"; Rec."Requested Employees")
                {
                    ToolTip = 'Specifies the requseted Employee.';
                    ApplicationArea = All;
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ToolTip = 'Specifies the closing date.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies Global Dimension 1 code.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies Global Dimension 2 Code.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status.';
                    ApplicationArea = All;
                }
                field("Interview Date"; Rec."Interview Date")
                {
                    ApplicationArea = All;
                }
                field("Interview Time"; Rec."Interview Time")
                {
                    ApplicationArea = All;
                }
                field("Interview Location"; Rec."Interview Location")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(General)
            {
                action(Advertise)
                {
                    Caption = 'Advertise';
                    Image = Web;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Advertise Job Online';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //Advertise to Web Site
                    end;
                }
                action("Job Qualifications")
                {
                    Caption = 'Job Qualifications';
                    Image = BulletList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HR Job Qualifications";
                    //   RunPageLink = "Job No." = FIELD("Job No.");
                    ToolTip = 'Job Qualifications';
                    ApplicationArea = All;
                }
                action("Job Requirements")
                {
                    Caption = 'Job Requirements';
                    Image = BusinessRelation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HR Job Requirements";
                    RunPageLink = "Job No." = FIELD("Job No.");
                    ToolTip = 'Job Requirements';
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
                    //  RunPageLink = "Job No." = FIELD("Job No.");
                    ToolTip = 'Job Responsibilities';
                    ApplicationArea = All;
                }
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Send Approval Request';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);

                        IF ApprovalsMgmtExt.CheckHREmployeeRequisitionApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendHREmployeeRequisitionForApproval(Rec);
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
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund",Requisition,"Funds Transfer","HR Document";
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(RECORDID,DATABASE::"HR Employee Requisitions","No.");
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
                        ApprovalsMgmtExt."OnCancelHREmployee RequisitionApprovalRequest"(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                    end;
                }
            }
            group(Group)
            {
                action("Email Invitation to Candidates")
                {
                    Caption = 'Send Email Invitation to Successful Applicants';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        EmployeeRecruitment.SendInterviewShortlistedApplicantEmail(Rec."Job No.", Rec."No.", Rec."Interview Date", Rec."Interview Time", Rec."Interview Location", '', Rec."Interview Date");
                    end;
                }
                action("Regret Mail to Candiates")
                {
                    Caption = 'Send Regret Email to Unsuccessful Applicants';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        EmployeeRecruitment.SendInterviewRejectedApplicantEmail(Rec."Job No.", Rec."No.");
                    end;
                }
                action("Close Requisition")
                {
                    Caption = 'Close Requisition';
                    Image = ClosePeriod;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        EmployeeRecruitment.CloseEmployeeRequisition(Rec."No.");
                    end;
                }
            }
        }
    }

    var
        ApproveRequisitionForJobApplication: Label 'Approve Employee Requisition Form %1 for Job Application?';
        ApproveRequisitionSuccessful: Label 'Employee Requisition Approved Successfully.';
        HRJobManagement: Codeunit 50032;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        EmployeeRecruitment: Codeunit 50033;
}


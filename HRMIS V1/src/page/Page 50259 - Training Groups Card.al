page 50259 "Training Groups Card"
{
    PageType = Card;
    SourceTable = 50162;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Training Group App. No."; Rec."Training Group App. No.")
                {
                    ApplicationArea = All;
                }
                field("Training Group Name"; Rec."Training Group Name")
                {
                    ApplicationArea = All;
                }
                field("Calendar Year"; Rec."Calendar Year")
                {
                    ApplicationArea = All;
                }
                field("Development Need"; Rec."Development Need")
                {
                    ApplicationArea = All;
                }
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = All;
                }
                field("Training Needs Description"; Rec."Training Needs Description")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Proposed Training Provider"; Rec."Proposed Training Provider")
                {
                    ApplicationArea = All;
                }
                field("Training Location"; Rec."Training Location")
                {
                    ApplicationArea = All;
                }
                field("Proposed Period"; Rec."Proposed Period")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field("Total Estimated Cost"; Rec."Total Estimated Cost")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
            }
            part("Training Group Line"; 50260)
            {
                SubPageLink = "Training Group No." = field("Training Group App. No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF ApprovalsMgmtExt.CheckHrTrainingGroupApprovalsWorkflowEnabled(Rec) THEN
                        ApprovalsMgmtExt.OnSendHRTrainingGroupForApproval(Rec);
                end;
            }
            action(ReOpen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //IF CONFIRM(ReOpenLeaveApplication,FALSE,"No.") THEN BEGIN
                    // Status:=Status::Open;
                    // MODIFY;
                    //END;
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
                RunObject = Page "Approval Entries";
                RunPageLink = "Document No." = FIELD("Training Group App. No.");
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    WorkflowsEntriesBuffer: Record 832;
                    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund",Requisition,"Funds Transfer","HR Document";
                begin
                    //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(RECORDID,DATABASE::"Training Needs App. Card","No.");
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
                    ApprovalsMgmtExt.OnCancelHRTrainingGroupApprovalRequest(Rec);
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

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
}


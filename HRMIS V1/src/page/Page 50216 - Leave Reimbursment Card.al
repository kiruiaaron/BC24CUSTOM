page 50216 "Leave Reimbursment Card"
{
    DeleteAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = 50128;
    SourceTableView = WHERE(Status = FILTER(<> Posted));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the document date.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the Posting Date.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the Employee Number.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the Employee Name.';
                    ApplicationArea = All;
                }
                field("Leave Application No."; Rec."Leave Application No.")
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Leave application Number.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the Leave Type.';
                    ApplicationArea = All;
                }
                field("Leave Period"; Rec."Leave Period")
                {
                    ToolTip = 'Specifies the Leave Period.';
                    ApplicationArea = All;
                }
                field("Leave Start Date"; Rec."Leave Start Date")
                {
                    ToolTip = 'Specifies the Leave start Date.';
                    ApplicationArea = All;
                }
                field("Leave Days Applied"; Rec."Leave Days Applied")
                {
                    ToolTip = 'Specifies the Leave Days Applied.';
                    ApplicationArea = All;
                }
                field("Leave Days Approved"; Rec."Leave Days Approved")
                {
                    ToolTip = 'Specifies the Leave Period.';
                    ApplicationArea = All;
                }
                field("Leave End Date"; Rec."Leave End Date")
                {
                    ToolTip = 'Specifies the Leave End Date.';
                    ApplicationArea = All;
                }
                field("Leave Return Date"; Rec."Leave Return Date")
                {
                    ToolTip = 'Specifies the Leave Return Date.';
                    ApplicationArea = All;
                }
                field("Substitute No."; Rec."Substitute No.")
                {
                    ToolTip = 'Specifies the substitute Employee No.';
                    ApplicationArea = All;
                }
                field("Substitute Name"; Rec."Substitute Name")
                {
                    ToolTip = 'Specifies the substitute Employee Name.';
                    ApplicationArea = All;
                }
                field("Reason for Leave"; Rec."Reason for Leave")
                {
                    ToolTip = 'Specifies the reason for Leave.';
                    ApplicationArea = All;
                }
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ToolTip = 'Specifies the Leave Balance.';
                    ApplicationArea = All;
                }
                field("Actual Return Date"; Rec."Actual Return Date")
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the actual return date.';
                    ApplicationArea = All;
                }
                field("Days to Reimburse"; Rec."Days to Reimburse")
                {
                    ToolTip = 'Specifies the days to reimburse.';
                    ApplicationArea = All;
                }
                field("Reason for Reimbursement"; Rec."Reason for Reimbursement")
                {
                    ToolTip = 'Specifies the reason for Reimbursement.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user ID that created the document.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Post Leave Reimbursment")
            {
                Image = PriceAdjustment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /* IF UserSetup.GET(USERID) THEN BEGIN
                      IF NOT UserSetup."Post Leave Application" THEN
                        ERROR(PemissionDenied);
                     END;
                     */

                    IF CONFIRM(ConfirmPostLeaveReimbursment, FALSE, Rec."No.", Rec."Leave Type", Rec."Leave Period") THEN BEGIN
                        HRLeaveManagement.CheckReimbursmentMandatoryFields(Rec, TRUE);
                        IF HRLeaveManagement.PostLeaveReimbursment(Rec."No.") THEN BEGIN
                            MESSAGE(ReimbursmentPostedSuccessfully, Rec."No.");
                        END;
                    END;

                end;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                begin
                    HRLeaveManagement.CheckReimbursmentMandatoryFields(Rec, FALSE);
                    Rec.TESTFIELD(Status, Rec.Status::Open);
                    IF ApprovalsMgmtExt.IsHRLeaveReimbusmentApprovalsWorkflowEnabled(Rec) THEN
                        ApprovalsMgmtExt.OnSendHRLeaveReimbusmentForApproval(Rec);
                end;
            }
            action(ReOpen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(ReOpenLeaveReimbursment, FALSE, Rec."No.") THEN BEGIN
                        Rec.Status := Rec.Status::Open;
                        REC.MODIFY;
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
                    //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(RECORDID,DATABASE::"HR Leave Application","No.");
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
                    ApprovalsMgmtExt.CheckHRLeaveReimbusmentApprovalsWorkflowEnabled(Rec);
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
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
            }
        }
    }

    var
        ReOpenLeaveReimbursment: Label 'Reopen Leave Reimbursment No.%1, the Status will be changed to Open. Continue?';
        UserSetup: Record 91;
        PemissionDenied: Label 'Contact System admin to continue with this transaction.';
        ConfirmPostLeaveReimbursment: Label 'Post this leave Reimbursment No.%1';
        ReimbursmentPostedSuccessfully: Label 'Reimbursment Posted Successfully';
        HRLeaveManagement: Codeunit 50036;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
}


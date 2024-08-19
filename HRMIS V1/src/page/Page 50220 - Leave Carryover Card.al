page 50220 "Leave Carryover Card"
{
    DeleteAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = 50129;
    SourceTableView = WHERE(Status = FILTER(<> Posted));

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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Leave Period"; Rec."Leave Period")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Maximum Carryover Days"; Rec."Maximum Carryover Days")
                {
                    ApplicationArea = All;
                }
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ApplicationArea = All;
                }
                field("Reason for Carryover"; Rec."Reason for Carryover")
                {
                    ApplicationArea = All;
                }
                field("Reasons For Difference in Days"; Rec."Reasons For Difference in Days")
                {
                    Caption = 'Reason For having Days to carryover different from reccomended';
                    ApplicationArea = All;
                }
                field("Days to CarryOver"; Rec."Days to CarryOver")
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
        }
    }

    actions
    {
        area(creation)
        {
            action("Post Leave Carry Over")
            {
                Image = PriceAdjustment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF UserSetup.GET(USERID) THEN BEGIN
                        IF NOT UserSetup."Post Leave Application" THEN
                            ERROR(PemissionDenied);
                    END;


                    IF CONFIRM(ConfirmPostLeaveReimbursment, FALSE, Rec."No.", Rec."Leave Type", Rec."Leave Period") THEN BEGIN
                        HRLeaveManagement.CheckCarryOverMandatoryFields(Rec, TRUE);
                        IF HRLeaveManagement.PostLeaveCarryover(Rec."No.") THEN BEGIN
                            MESSAGE(PostedSuccessfully, Rec."No.");
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
                    Rec.TESTFIELD(Status, Rec.Status::Open);

                    IF ApprovalsMgmtExt.CheckHRLeaveCarryoverApprovalsWorkflowEnabled(Rec) THEN
                        ApprovalsMgmtExt.OnSendHRLeaveCarryoverForApproval(Rec);
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
                    IF CONFIRM(ReOpenLeaveCarryOver, FALSE, Rec."No.") THEN BEGIN
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
                    ApprovalsMgmtExt.CheckHRLeaveCarryoverApprovalsWorkflowEnabled(Rec);
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
        UserSetup: Record 91;
        PemissionDenied: Label 'Contact System Admin to continue with this transaction';
        ConfirmPostLeaveReimbursment: Label 'Post This Leave carryover';
        HRLeaveManagement: Codeunit 50036;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        PostedSuccessfully: Label 'Transaction Posted Successfully';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        ReOpenLeaveCarryOver: Label 'Are you sure you want to Re-open the Leave Carryover';
}


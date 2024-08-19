page 50215 "Leave Reimbursements"
{
    CardPageID = "Leave Reimbursment Card";
    DeleteAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50128;
    SourceTableView = WHERE(Posted = CONST(False));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the Posting Date.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the Employee No.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the Employee Name.';
                    ApplicationArea = All;
                }
                field("Leave Application No."; Rec."Leave Application No.")
                {
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
                field("Leave Return Date"; Rec."Leave Return Date")
                {
                    ToolTip = 'Specifies the Leave Retun Date.';
                    ApplicationArea = All;
                }
                field("Actual Return Date"; Rec."Actual Return Date")
                {
                    ToolTip = 'Specifies the actual return date.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 1 Code.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 2 Code.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the Leave status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies User ID that created the document';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
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
                    /*IF UserSetup.GET(USERID) THEN BEGIN
                     IF NOT UserSetup."Post Leave Application" THEN
                       ERROR(PemissionDenied);
                    END;*/


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

                    IF ApprovalsMgmtExt.CheckHRLeaveReimbusmentApprovalsWorkflowEnabled(Rec) THEN
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
                //   // WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                begin
                    ApprovalsMgmtExt.CheckHRLeaveReimbusmentApprovalsWorkflowEnabled(Rec);
                    // //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF HRLeaveManagement.CheckOpenLeaveReimbursementExists(USERID) THEN
            ERROR(OpenLeaveReimbursementExist, USERID);
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        UserSetup: Record 91;
        HRLeaveManagement: Codeunit 50036;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        OpenLeaveReimbursementExist: Label 'Open Leave Reimbursment Exists for User ID:%1';
        ReOpenLeaveReimbursment: Label 'Reopen Leave Reimbursment No.%1, the Status will be changed to Open. Continue?';
        PemissionDenied: Label 'Contact System admin to continue with this transaction.';
        ConfirmPostLeaveReimbursment: Label 'Post this leave Reimbursment No.%1';
        ReimbursmentPostedSuccessfully: Label 'Reimbursment Posted Successfully';
}


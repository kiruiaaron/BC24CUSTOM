page 50211 "Leave Application Card"
{
    DeleteAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = 50127;
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
                    ToolTip = 'Specifies the Document Date.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting Date.';
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
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    Editable = false;
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
                field("Leave Balance"; Rec."Leave Balance")
                {
                    Caption = 'Leave Balance ';
                    ToolTip = 'Specifies the Leave Balance.';
                    ApplicationArea = All;
                }
                field("Substitute No."; Rec."Substitute No.")
                {
                    ToolTip = 'Specifies the Substitute Employee Number.';
                    ApplicationArea = All;
                }
                field("Substitute Name"; Rec."Substitute Name")
                {
                    ToolTip = 'Specifies the Employee Name.';
                    ApplicationArea = All;
                }
                field("Leave Start Date"; Rec."Leave Start Date")
                {
                    ToolTip = 'Specifies the Leave start Date.';
                    ApplicationArea = All;
                }
                field("Days Applied"; Rec."Days Applied")
                {
                    ToolTip = 'Specifies the Days Applied.';
                    ApplicationArea = All;
                }
                field("Days Approved"; Rec."Days Approved")
                {
                    ToolTip = 'Specifies the Days approved.';
                    ApplicationArea = All;
                }
                field("Leave End Date"; Rec."Leave End Date")
                {
                    ToolTip = 'Specifies the Leave End Date.';
                    ApplicationArea = All;
                }
                field("Leave Return Date"; Rec."Leave Return Date")
                {
                    ToolTip = 'Specifies the Leave return date.';
                    ApplicationArea = All;
                }
                field("Reason for Leave"; Rec."Reason for Leave")
                {
                    ToolTip = 'Specifies the reason for Leave.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = true;
                    ToolTip = 'Specifies the status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the User ID that created the document.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
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
                    //check substitute
                    Rec.TESTFIELD("Substitute No.");
                    Rec.TESTFIELD(Status, Rec.Status::Open);

                    HRLeaveManagement.CheckLeaveApplicationMandatoryFields(Rec, FALSE);

                    IF ApprovalsMgmtExt.CheckHRLeaveApplicationApprovalsWorkflowEnabled(Rec) THEN
                        ApprovalsMgmtExt.OnSendHRLeaveApplicationForApproval(Rec);
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
                    IF CONFIRM(ReOpenLeaveApplication, FALSE, Rec."No.") THEN BEGIN
                        Rec.Status := Rec.Status::Open;
                        REC.MODIFY;
                    END;
                end;
            }
            action("Post Leave Application")
            {
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*IF UserSetup.GET(USERID) THEN BEGIN
                     IF NOT UserSetup."Post Leave Application" THEN
                       ERROR(PemissionDenied);
                    END;*/
                    LeaveType.RESET;
                    IF LeaveType.GET(Rec."Leave Type") THEN BEGIN
                        Rec.CALCFIELDS(Rec."Leave Balance");
                        IF Rec."Leave Balance" < Rec."Days Approved" THEN BEGIN
                            IF LeaveType."Allow Negative Days" = FALSE THEN
                                ERROR(ErrorNegativeDaysNotAllowed + Rec."Leave Type");
                        END;
                    END;


                    IF CONFIRM(ConfirmPostLeaveApplication, FALSE, Rec."No.", Rec."Leave Type", Rec."Leave Period") THEN BEGIN
                        HRLeaveManagement.CheckLeaveApplicationMandatoryFields(Rec, TRUE);
                        IF HRLeaveManagement.PostLeaveApplication(Rec."No.") THEN BEGIN
                            MESSAGE(LeavePostedSuccessfully, Rec."No.");
                        END;
                    END;

                end;
            }
            action("Print Leave Application")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRLeaveApplication.RESET;
                    HRLeaveApplication.SETRANGE(HRLeaveApplication."No.", Rec."No.");
                    IF HRLeaveApplication.FINDFIRST THEN BEGIN
                        //  REPORT.RUNMODAL(REPORT::"HR Leave Application Report", TRUE, FALSE, HRLeaveApplication);
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
                //  // WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    ApprovalsMgmtExt.CheckHRLeaveApplicationApprovalsWorkflowEnabled(Rec);
                    // //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
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
        HRLeaveManagement: Codeunit 50036;
        OpenLeaveApplicationExist: Label 'Open Leave Application Exists for User ID:%1';
        ReOpenLeaveApplication: Label 'Reopen Leave Application No.%1, the Status will be changed to Open. Continue?';
        ConfirmPostLeaveApplication: Label 'Post Leave Application. Identification Fields and Values, "Document No.":%1,  Leave Type:%2, Leave Period:%3. Continue?';
        LeavePostedSuccessfully: Label 'Leave Application No. %1, Posted Successfully.';
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        UserSetup: Record 91;
        PemissionDenied: Label 'You are not setup to Post Leave Applications. Contact System Administrator';
        HRLeaveApplication: Record 50127;
        LeaveType: Record 50134;
        ErrorNegativeDaysNotAllowed: Label 'Negative leave days are not allowed for Leave Type:';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
}


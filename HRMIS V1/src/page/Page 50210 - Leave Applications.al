page 50210 "Leave Applications"
{
    CardPageID = "Leave Application Card";
    DeleteAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50127;
    SourceTableView = WHERE(Status = FILTER(<> Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the No.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the  Employee No.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the  Employee Name.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the Leave Type.';
                    ApplicationArea = All;
                }
                field("Leave Period"; Rec."Leave Period")
                {
                    ToolTip = 'Specifies the Leave period.';
                    ApplicationArea = All;
                }
                field("Leave Start Date"; Rec."Leave Start Date")
                {
                    ToolTip = 'Specifies the Leave start date.';
                    ApplicationArea = All;
                }
                field("Days Applied"; Rec."Days Applied")
                {
                    ToolTip = 'Specifies the Days applied.';
                    ApplicationArea = All;
                }
                field("Days Approved"; Rec."Days Approved")
                {
                    ToolTip = 'Specifies the Days approved.';
                    ApplicationArea = All;
                }
                field("Leave End Date"; Rec."Leave End Date")
                {
                    ToolTip = 'Specifies the Leave End date.';
                    ApplicationArea = All;
                }
                field("Leave Return Date"; Rec."Leave Return Date")
                {
                    ToolTip = 'Specifies the Leave return date.';
                    ApplicationArea = All;
                }
                field("Substitute No."; Rec."Substitute No.")
                {
                    ToolTip = 'Specifies the Employee substitute No.';
                    ApplicationArea = All;
                }
                field("Substitute Name"; Rec."Substitute Name")
                {
                    ToolTip = 'Specifies the  Employee substitute Name.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status.';
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
                ToolTip = 'Specifies the approval request process.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                begin
                    //
                    Rec.TESTFIELD("Substitute No.");

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
                ToolTip = 'Specifies the process of re-opening a document.';
                ApplicationArea = All;
            }
            action("Post Leave Application")
            {
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Specifies the process of posting a leave application.';
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
                        Rec.CALCFIELDS("Leave Balance");
                        IF Rec."Leave Balance" < Rec."Days Approved" THEN BEGIN
                            IF LeaveType."Allow Negative Days" = FALSE THEN
                                ERROR('Negative leave days are not allowed for Leave Type:' + Rec."Leave Type");
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
                /*  RunObject = Page "Approval Entries";
                 RunPageLink = "Document No." = FIELD("No.");
                 RunPageView = WHERE("Table ID"=CONST(52137055)); */
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
                    ApprovalsMgmtExt.CheckHRLeaveApplicationApprovalsWorkflowEnabled(Rec);
                    //  //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF HRLeaveManagement.CheckOpenLeaveApplicationExists(USERID) THEN
            ERROR(OpenLeaveApplicationExist, USERID);
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        HRLeaveApplication: Record 50127;
        HRLeaveManagement: Codeunit 50036;
        OpenLeaveApplicationExist: Label 'Open Leave Application Exists for User ID:%1';
        ReOpenLeaveApplication: Label 'Reopen Leave Application No.%1, the Status will be changed to Open. Continue?';
        ConfirmPostLeaveApplication: Label 'Post Leave Application. Identification Fields and Values, "Document No.":%1,  Leave Type:%2, Leave Period:%3. Continue?';
        LeavePostedSuccessfully: Label 'Leave Application No. %1, Posted Successfully.';
        UserSetup: Record 91;
        PemissionDenied: Label 'You are not setup to post Leave applications. Contact System Administrator';
        LeaveType: Record 50134;
}


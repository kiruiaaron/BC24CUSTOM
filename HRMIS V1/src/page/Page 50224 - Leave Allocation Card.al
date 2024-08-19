page 50224 "Leave Allocation Card"
{
    DeleteAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = 50130;
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
                    ToolTip = 'Specifies the document Date.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting Date.';
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
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the User ID that created the document.';
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50225)
            {
                SubPageLink = "Leave Allocation No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Auto Generate Allocation Lines")
            {
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Auto Generate Leave Allocation Lines based on Employee Default Annual Leave Type';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CheckRequiredFields;
                    IF CONFIRM(ConfirmAutoGenerateAllocationLines, FALSE, Rec."Leave Type", Rec."Leave Period") THEN BEGIN
                        IF HRLeaveManagement.AutoFillLeaveAllocationLines(Rec."No.") THEN BEGIN
                            HRLeaveAllocationLine.RESET;
                            HRLeaveAllocationLine.SETRANGE(HRLeaveAllocationLine."Leave Allocation No.", Rec."No.");
                            IF HRLeaveAllocationLine.FINDSET THEN
                                MESSAGE(AutoGenerateAllocationLineSuccessful)
                            ELSE
                                ERROR(AutoGenerateAllocationLineFail, Rec."Leave Type", Rec."Leave Period");
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
                ToolTip = 'Send Approval Request for the document';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CheckRequiredFields;
                    IF ApprovalsMgmtExt.CheckHRLeaveAllocationHeaderApprovalsWorkflowEnabled(Rec) THEN
                        ApprovalsMgmtExt.OnSendHRLeaveAllocationHeaderForApproval(Rec);
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
                    ApprovalsMgmtExt.OnCancelHRLeaveAllocationHeaderApprovalRequest(Rec);
                    //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
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
            action(ReOpen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(ReOpenLeaveAllocation, FALSE, Rec."No.") THEN BEGIN
                        Rec.Status := Rec.Status::Open;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Post Leave Allocation")
            {
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Helps to Post Leave Allocation.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CheckRequiredFields;
                    IF CONFIRM(ConfirmPostLeaveAllocation, FALSE, Rec."No.", Rec."Leave Type", Rec."Leave Period") THEN BEGIN
                        HRLeaveAllocationLine.RESET;
                        HRLeaveAllocationLine.SETRANGE(HRLeaveAllocationLine."Leave Allocation No.", Rec."No.");
                        HRLeaveAllocationLine.SETFILTER(HRLeaveAllocationLine."Days Approved", '>%1', 0);
                        IF HRLeaveAllocationLine.FINDSET THEN BEGIN
                            IF HRLeaveManagement.PostLeaveAllocation(Rec."No.") THEN BEGIN
                                MESSAGE(LeaveAllocationPostedSuccessfully, Rec."No.");
                            END;
                        END ELSE BEGIN
                            ERROR(EmptyAllocationLines, rec."No.");
                        END;
                    END;
                end;
            }
            action("Import Leave Allocation ")
            {
                //The property 'Caption' cannot be empty.
                //Caption = '';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //   RunObject = XMLport 52137125;
                ToolTip = 'Import Leave Allocation for Employees';
                ApplicationArea = All;
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
        /*IF HRLeaveManagement.CheckOpenLeaveAllocationExists(USERID) THEN
          ERROR(OpenLeaveAllocationExist,USERID);*/

    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        HRLeaveManagement: Codeunit 50036;
        AutoGenerateAllocationLineSuccessful: Label 'Leave Allocation Lines Generated Successully';
        AutoGenerateAllocationLineFail: Label 'Leave Allocation Lines Not Generated, The Leave Allocation for Leave type:%1 and Leave Period:%2, is already Posted for all Employees.';
        LeaveAllocationPostedSuccessfully: Label 'Leave Allocation No. %1, Posted Successfully ';
        OpenLeaveAllocationExist: Label 'Open Leave Allocation Exists for User ID:%1';
        HRLeaveAllocationLine: Record 50131;
        EmptyAllocationLines: Label 'Error Posting Leave Allocation Document:%1. Fault Code: Empty Leave Allocation Lines.';
        ConfirmAutoGenerateAllocationLines: Label 'Auto Generate Leave Allocation Lines. Identification Fields and Values, Leave Type:%1, Leave Period:%2. Continue?';
        ConfirmPostLeaveAllocation: Label 'Post Leave Allocation. Identification Fields and Values, "Document No.":%1,  Leave Type:%2, Leave Period:%3. Continue?';
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        ReOpenLeaveAllocation: Label 'Reopen Leave Allocation No.%1, the Status will be changed to Open. Continue?';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;

    local procedure CheckRequiredFields()
    begin
        Rec.TESTFIELD("Posting Date");
        Rec.TESTFIELD("Leave Type");
        Rec.TESTFIELD("Leave Period");
        Rec.TESTFIELD(Description);
    end;
}


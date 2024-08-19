page 50267 "Training Evaluation List"
{
    CardPageID = "Training Evaluation Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50161;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Training Evaluation No."; Rec."Training Evaluation No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Official Mail"; Rec."Official Mail")
                {
                    ApplicationArea = All;
                }
                field("Training Application no."; Rec."Training Application no.")
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
                    IF ApprovalsMgmtExt.CheckTrainingEvaluationApprovalsWorkflowEnabled(Rec) THEN
                        ApprovalsMgmtExt.OnSendTrainingEvaluationForApproval(Rec);
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
                    /*IF CONFIRM(ReOpenLeaveApplication,FALSE,"No.") THEN BEGIN
                      Status:=Status::Open;
                      MODIFY;
                    END;*/

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
                 RunPageLink = "Document No." = FIELD("No. Series"),
                               "Document Type" = FILTER("HR Document"); */
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
                    ApprovalsMgmtExt.OnCancelTrainingEvaluationApprovalRequest(Rec);
                    //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID","User ID");
    end;

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
}


page 50261 "Training Applications"
{
    CardPageID = "Training Application Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50164;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                }
                field("Training Need No."; Rec."Training Need No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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
                field("Number of Days"; Rec."Number of Days")
                {
                    ApplicationArea = All;
                }
                field("Estimated Cost Of Training"; Rec."Estimated Cost Of Training")
                {
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Provider Code"; Rec."Provider Code")
                {
                    ApplicationArea = All;
                }
                field("Provider Name"; Rec."Provider Name")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Actual Training Cost"; Rec."Actual Training Cost")
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
                    IF ApprovalsMgmtExt.CheckHRTrainingApplicationsHeaderApprovalsWorkflowEnabled(Rec) THEN
                        ApprovalsMgmtExt.OnSendHRTrainingApplicationsHeaderForApproval(Rec);
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
                /* RunObject = Page "Approval Entries";
                RunPageLink = "Document No." = FIELD(Application No.),
                              "Document Type"=FILTER(HR Document); */
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
                    ApprovalsMgmtExt.OnCancelHRTrainingApplicationsHeaderApprovalRequest(Rec);
                    //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        TrainingApplications.RESET;
        TrainingApplications.SETRANGE(TrainingApplications."Employee No.", Rec."Employee No.");
        TrainingApplications.SETRANGE(TrainingApplications."Evaluation Submitted", FALSE);
        IF TrainingApplications.FINDFIRST THEN
            ERROR(TrainingApplicationError);

        TrainingEvaluation.RESET;
        TrainingEvaluation.SETRANGE("Employee No.", Rec."No.");
        IF TrainingEvaluation.FINDFIRST THEN BEGIN
            REPEAT
                TrainingEvaluation.Submitted := FALSE;
                ERROR(TrainingApplicationError);
            UNTIL TrainingEvaluation.NEXT = 0;
        END;
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID","User ID");
    end;

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        TrainingEvaluation: Record 50161;
        TrainingApplicationError: Label 'You can not apply for another Training if you have not submited your previous Training attendance Evaluation. Please submit your Training Evaluation to proceed';
        TrainingApplications: Record 50164;
}


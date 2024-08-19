page 50249 "Training Evaluation Card"
{
    PageType = Card;
    SourceTable = 50161;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Training Evaluation No."; Rec."Training Evaluation No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
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
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Training Application no."; Rec."Training Application no.")
                {
                    ApplicationArea = All;
                }
                field("Calendar Year"; Rec."Calendar Year")
                {
                    ApplicationArea = All;
                }
                field("Developement Need"; Rec."Developement Need")
                {
                    ApplicationArea = All;
                }
                field(Objectives; Rec.Objectives)
                {
                    ApplicationArea = All;
                }
                field("Training Provider"; Rec."Training Provider")
                {
                    ApplicationArea = All;
                }
                field("Venue/Location"; Rec."Venue/Location")
                {
                    ApplicationArea = All;
                }
                field("Training Start Date"; Rec."Training Start Date")
                {
                    ApplicationArea = All;
                }
                field("Training End Date"; Rec."Training End Date")
                {
                    ApplicationArea = All;
                }
                field("General Comments from Training"; Rec."General Comments from Training")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Objective Achieved"; Rec."Objective Achieved")
                {
                    ApplicationArea = All;
                }
                field(Submitted; Rec.Submitted)
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
        area(factboxes)
        {
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Submit Training Evaluation")
            {
                Image = SelectField;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Approved);
                    IF CONFIRM(Txt080) = FALSE THEN EXIT;
                    TrainingApplications.RESET;
                    TrainingApplications.SETRANGE(TrainingApplications."Employee No.", Rec."Employee No.");
                    TrainingApplications.SETRANGE(TrainingApplications."Application No.", Rec."Training Application no.");
                    IF TrainingApplications.FINDFIRST THEN BEGIN
                        TrainingApplications."Evaluation Submitted" := TRUE;
                        TrainingApplications.MODIFY;
                        Rec.Submitted := TRUE;
                        Rec.MODIFY;
                        MESSAGE(Txt081, Rec."Training Evaluation No.");
                    END;
                end;
            }
            action("HR Mandatory Document Checklist")
            {
                Caption = 'HR Training Evaluation Mandatory Document Checklist';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page 50175;
                RunPageLink = "Document No." = FIELD("Training Evaluation No.");
                ToolTip = 'HR Training Evaluation Mandatory Document Checklist';
                ApplicationArea = All;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Check if HR Mandatory checklist documents have been attached.
                    HRJobLookupValue.RESET;
                    HRJobLookupValue.SETRANGE(HRJobLookupValue."Required Stage", HRJobLookupValue."Required Stage"::"Training Evaluation");
                    IF HRJobLookupValue.FINDSET THEN BEGIN
                        REPEAT
                            HRMandatoryDocChecklist.RESET;
                            HRMandatoryDocChecklist.SETRANGE(HRMandatoryDocChecklist."Document No.", Rec."Training Evaluation No.");
                            HRMandatoryDocChecklist.SETRANGE(HRMandatoryDocChecklist."Mandatory Doc. Code", HRJobLookupValue.Code);
                            IF HRMandatoryDocChecklist.FINDFIRST THEN BEGIN
                                IF NOT HRMandatoryDocChecklist.HASLINKS THEN BEGIN
                                    ERROR(HRJobLookupValue.Code + ' ' + Txt082);
                                    BREAK;
                                    EXIT;
                                END;
                            END ELSE BEGIN
                                ERROR(HRJobLookupValue.Code + ' ' + Txt082);
                                BREAK;
                                EXIT;
                            END;
                        UNTIL HRJobLookupValue.NEXT = 0;
                    END;

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
                /*RunObject = Page "Approval Entries";
                RunPageLink = "Document No." = FIELD("No. Series"),
                              "Document Type" = FILTER("HR Document");*/
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
                //WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                begin
                    ApprovalsMgmtExt.OnCancelTrainingEvaluationApprovalRequest(Rec);
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
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
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

    trigger OnOpenPage()
    begin
        Rec."User ID" := USERID;
        Rec.Date := TODAY
    end;

    var
        Txt080: Label 'Are you sure you want to Submit your Training Evaluation';
        Txt081: Label 'Your Training Evaluation %1 has successfully been submitted';
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        HRJobLookupValue: Record 50097;
        HRMandatoryDocChecklist: Record 50112;
        Txt082: Label 'has not been attached. This is a required document.';
        TrainingApplications: Record 50164;
}


page 50262 "Training Application Card"
{
    PageType = Card;
    SourceTable = 50164;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                }
                field("Type of Training"; Rec."Type of Training")
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
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Calendar Year"; Rec."Calendar Year")
                {
                    ApplicationArea = All;
                }
                field("Training Need No."; Rec."Training Need No.")
                {
                    Visible = TrainingNeedNoVisible;
                    ApplicationArea = All;
                }
                field("Development Need"; Rec."Development Need")
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
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Estimated Cost Of Training"; Rec."Estimated Cost Of Training")
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
                field("Purpose of Training"; Rec."Purpose of Training")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Evaluation Card Created"; Rec."Evaluation Card Created")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Submitted"; Rec."Evaluation Submitted")
                {
                    ApplicationArea = All;
                }
                field("Total Training Cost"; Rec."Total Training Cost")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50263)
            {
                SubPageLink = "Application No." = FIELD("Application No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Requisition for Training")
            {
                Caption = 'Requisition for Employee Training';
                Image = ReservationLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // RunObject = Page 50083;
                // RunPageLink = "Reference Document No." = FIELD("Application No.");
                ToolTip = 'Create Purchase Requisition for Employee Training';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Create a Purchase Requisition for Training Application
                    /*  PurchaseRequisitions.RESET;
                     PurchaseRequisitions.SETRANGE(PurchaseRequisitions."Reference Document No.", "Application No.");
                     IF PurchaseRequisitions.FINDFIRST THEN
                         ERROR(ERRORPURCHASEREQUISITIONEXISTS);
                     "Purchases&PayablesSetup".GET;
                     PurchaseRequisitions.INIT;
                     PurchaseRequisitions."No." := ''; //NoSeriesMgt.GetNextNo("Purchases&PayablesSetup"."Purchase Requisition Nos.", 0D, TRUE);
                     PurchaseRequisitions."Document Date" := TODAY;
                     PurchaseRequisitions."Requested Receipt Date" := TODAY;
                     PurchaseRequisitions."Reference Document No." := "Application No.";
                     PurchaseRequisitions.Description := Description;
                     PurchaseRequisitions.INSERT; */
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
                /*  RunObject = Page "Approval Entries";
                                 RunPageLink = "Document No."=FIELD(Application No.); */
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
            action("Create Evaluation card for Training")
            {
                Caption = 'Create Evaluation card for Training';
                Image = ReturnOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50249;
                RunPageLink = "Training Application No." = FIELD("Application No.");
                ToolTip = 'Create Training Evaluation for Employee Training';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Create and Submit a Training Evaluation
                    TrainingEvaluation.RESET;
                    TrainingEvaluation.SETRANGE(TrainingEvaluation."Training Application no.", Rec."Application No.");
                    IF TrainingEvaluation.FINDFIRST THEN
                        ERROR(ERRORTRAININGEVALUATIONEXISTS);
                    IF CONFIRM(Txt001) = FALSE THEN EXIT;
                    HumanResourcesSetup.GET;
                    TrainingEvaluation.INIT;
                    TrainingEvaluation."Training Evaluation No." := '';// NoSeriesMgt.GetNextNo(HumanResourcesSetup."Employee Evaluation Nos.", 0D, TRUE);
                    TrainingEvaluation."Employee No." := Rec."Employee No.";
                    TrainingEvaluation.VALIDATE(TrainingEvaluation."Employee No.");
                    TrainingEvaluation."Employee Name" := Rec."Employee Name";
                    TrainingEvaluation.Date := TODAY;
                    TrainingEvaluation."Training Application no." := Rec."Application No.";
                    TrainingEvaluation."Calendar Year" := Rec."Calendar Year";
                    TrainingEvaluation."Developement Need" := Rec."Development Need";
                    TrainingEvaluation.Objectives := Rec."Purpose of Training";
                    TrainingEvaluation."Training Provider" := Rec."Provider Name";
                    TrainingEvaluation."Training Start Date" := Rec."From Date";
                    TrainingEvaluation."Training End Date" := Rec."To Date";
                    TrainingEvaluation.Submitted := TRUE;
                    TrainingEvaluation.INSERT;
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

    trigger OnOpenPage()
    begin
        TrainingNeedNoVisible := FALSE;

        IF Rec."Type of Training" = Rec."Type of Training"::"Individual Training" THEN
            TrainingNeedNoVisible := TRUE;
    end;

    var
        //PurchaseRequisitions: Record 50046;
        "Purchases&PayablesSetup": Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TrainingNeedNoVisible: Boolean;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        TrainingEvaluation: Record 50161;
        HumanResourcesSetup: Record 5218;
        Txt001: Label 'Do you want to proceed to create an Evaluation card for this Training?';
        ERRORTRAININGEVALUATIONEXISTS: Label 'Training Evaluation Card for this Training application Exist! Please use it to submitt your Training Evaluation to proceed';
        ERRORPURCHASEREQUISITIONEXISTS: Label 'A purcahse requisition card for this Training application Exist! Please use it to submitt your requisition for Training to proceed';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
}


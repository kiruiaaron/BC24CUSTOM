page 50103 "Procurement Planning Card"
{
    DeleteAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = 50063;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Budget; Rec.Budget)
                {
                    ApplicationArea = All;
                }
                field("Budget Description"; Rec."Budget Description")
                {
                    ApplicationArea = All;
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                }
                field("Procurement Plan No."; Rec."Procurement Plan No.")
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
                field(Name; Rec.Name)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part("Purchase Planning Sub Form"; 50104)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ReOpen)
            {
                Caption = 'ReOpen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                ApplicationArea = All;
            }
            action("Planning Lines Attributes")
            {
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50104;
                RunPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
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
                    /*     RunObject = Page "Approval Entries";
                         RunPageLink = "Document No." = FIELD("No.");*/
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesPage(Rec.RECORDID,DATABASE::"Receipt Header","Document Type","No.");
                    end;
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmtExt: Codeunit "Approval Mgt.Procurement Ext";
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);

                        /*CALCFIELDS("Budget Amount");
                        
                        ProcurementPlanningLine.RESET;
                        ProcurementPlanningLine.SETRANGE(ProcurementPlanningLine."Document No.","No.");
                        ProcurementPlanningLine.CALCSUMS("Estimated cost");
                        AmountAssigned:=ProcurementPlanningLine."Estimated cost";
                        
                        IF "Budget Amount" >  AmountAssigned THEN
                          ERROR(Text047);
                        
                        IF "Budget Amount" < AmountAssigned THEN
                          ERROR(Text048);
                          */

                        //Send Approval Request
                        IF ApprovalsMgmtExt.IsProcurementPlanApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendProcurementPlanForApproval(Rec);

                        CurrPage.CLOSE

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
                        ApprovalsMgmtExt: Codeunit "Approval Mgt.Procurement Ext";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                    begin
                        Rec.TESTFIELD(Status, Rec.Status::"Pending Approval");

                        ApprovalsMgmtExt.OnCancelProcurementPlanApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                action("Procurement Planning")
                {
                    Caption = 'Procurement Planning';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ProcurementPlanningHeader.RESET;
                        ProcurementPlanningHeader.SETRANGE(ProcurementPlanningHeader."No.", Rec."No.");
                        IF ProcurementPlanningHeader.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Procurement Planning", TRUE, FALSE, ProcurementPlanningHeader);
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Rec.Status <> Rec.Status::Open THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        Txt_001: Label 'User %1 is not setup for Inventory Posting. Contact System Administrator';
        Text046: Label 'The %1 does not match the quantity defined in item tracking.';
        ApprovalsMgmtExt: Codeunit "Approval Mgt.Procurement Ext";
        JTemplate: Code[10];
        JBatch: Code[10];
        "DocNo.": Code[20];
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        ProcurementPlanningHeader: Record 50063;
        ProcurementPlanningLine: Record 50064;
        AmountAssigned: Decimal;
        Text047: Label 'Amount broken down in the Procurement planning lines is LESS than the budget line amount. The figures should be equal';
        Text048: Label 'Amount broken down in the Procurement planning lines is MORE than the budget line amount. The figures should be equal';

    procedure UpdateControls()
    begin
    end;

    procedure CurrPageUpdate()
    begin
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgt.Procurement Ext";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin
    end;
}


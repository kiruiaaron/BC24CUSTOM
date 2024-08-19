page 50142 "App Purchase Requisition Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 50046;
    SourceTableView = WHERE(Status = CONST(Approved));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the unique document number for the purchase requisition';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the date when the purchase requisition was created';
                    ApplicationArea = All;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ToolTip = 'Specifies the date when the user expects to receive the items on the purchase requisition';
                    ApplicationArea = All;
                }
                field(Budget; Rec.Budget)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency used for the amounts on the purchase requisition';
                    ApplicationArea = All;
                }
                field("Reference Document No."; Rec."Reference Document No.")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
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
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description for the purchase requisition';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the approval status for the purchase requisition';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user who created the purchase requisition';
                    ApplicationArea = All;
                }
                field("Cancelation Comments"; Rec."Cancelation Comments")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
            part("Purchase Requisition Line"; 50318)
            {
                Caption = 'Purchase Requisition Line';
                SubPageLink = "Document No." = FIELD("No.");
                ToolTip = 'Purchase Requisition Line';
                ApplicationArea = All;
            }
            part(sbpg; 50101)
            {
                Editable = false;
                SubPageLink = "RFQ No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            part(ApprovalFactBox; 9092)
            {
                ApplicationArea = Advanced;
                //ToolTip = 'Approvals FactBox';
            }
            part(IncomingDocAttachFactBox; 193)
            {
                ApplicationArea = Advanced;
                ShowFilter = false;
                ToolTip = 'Incoming Document Attach FactBox';
            }
            part(WorkflowStatus; 1528)
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                //ToolTip = 'Workflow Status';
                Visible = ShowWorkflowStatus;
            }
            systempart(Links; Links)
            {
                //ToolTip = 'Record Links';
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
                //ToolTip = 'Notes';
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
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*TESTFIELD("User ID",USERID);
                    IF CONFIRM(Txt_003,FALSE,"No.") THEN BEGIN
                      ProcurementApprovalWorkflow.ReOpenPurchaseRequisitionHeader(Rec);
                      ApprovalsMgmtExt.OnCancelPurchaseRequisitionApprovalRequest(Rec);
                      //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                    END;*/

                end;
            }
            action("Create PO")
            {
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    IF CONFIRM('Are you sure you want to create a purchase order from this requisition?') THEN
                        ProcurementManagement.CreatePurchaseOrder(Rec);
                end;
            }
            action("Create Petty Cash")
            {
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM('Are you sure you want to create a petty cash from this requisition?') THEN
                        ProcurementManagement.CreatePettyCash(Rec);
                end;
            }
            action("View Petty Cash")
            {
                Image = ValueLedger;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CLEAR(ImprestHeader);
                    ImprestHeader.RESET;
                    ImprestHeader.SETRANGE("Purchase Requisition No", Rec."No.");
                    PettyCashlist.SETTABLEVIEW(ImprestHeader);
                    PettyCashlist.RUN
                end;
            }
            action("Requisition Lines Specifications")
            {
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50084;
                RunPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Return To User")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Return To User';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var

                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                begin



                    Rec.TESTFIELD("Cancelation Comments");
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Imprest);
                    ApprovalEntry.SETFILTER(Status, '=%1|%2|%3', ApprovalEntry.Status::Approved, ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
                    ;
                    IF ApprovalEntry.FINDFIRST THEN
                        REPEAT
                            ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                            ApprovalEntry."Rejection Comments" := Rec."Cancelation Comments";
                            ApprovalEntry.MODIFY;

                        UNTIL ApprovalEntry.NEXT = 0;
                    Rec.Status := Rec.Status::Open;
                    Rec.MODIFY;
                    MESSAGE('Record changed successfully');
                end;
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action("Attach File")
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page 1173;
                        RecRef: RecordRef;
                    begin
                        RecRef.GETTABLE(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RUNMODAL;
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
                    /*     RunObject = Page "Approval Entries";
                         RunPageLink = "Document No." = FIELD("No.");*/
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(RECORDID,DATABASE::"Purchase Requisition Header","No.");
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Requisition Header","No.");
                    end;
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        //ProcurementManagement.CheckPurchaseRequisitionMandatoryFields(Rec);
                        IF ApprovalsMgmtExt.CheckPurchaseRequisitionApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendPurchaseRequisitionForApproval(Rec);
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
                    begin
                        ApprovalsMgmtExt.OnCancelPurchaseRequisitionApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);

                        //CanCancelApprovalForRecord OR CanCancelApprovalForFlow
                    end;
                }
                action("Budget Committment Lines")
                {
                    Image = BinJournal;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page 50049;
                    RunPageLink = "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Check Budget Availability")
                {
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        BudgetarySetup.GET;
                        IF NOT BudgetarySetup.Mandatory THEN
                            EXIT;

                        IF Rec.Status = Rec.Status::Approved THEN
                            ERROR(Text001);

                        IF CheckIfSomeLinesCommitted(Rec."No.") THEN BEGIN
                            IF NOT CONFIRM(Text002, TRUE) THEN
                                ERROR(Text003);
                            BudgetCommitment.RESET;
                            BudgetCommitment.SETRANGE(BudgetCommitment."Document No.", Rec."No.");
                            IF BudgetCommitment.FINDSET THEN
                                BudgetCommitment.DELETEALL;
                        END;

                        Commitment.CheckBudgetPurchaseRequisition(Rec);
                        MESSAGE(Text004);
                    end;
                }
                action("Cancel Budget Commitment")
                {
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM(Text005, TRUE) THEN
                            ERROR(Text006);

                        /*BudgetCommitment.RESET;
                        BudgetCommitment.SETRANGE(BudgetCommitment."Document No.","No.");
                        BudgetCommitment.DELETEALL;*/

                        Commitment.CancelBudgetCommitmentPurchaseRequisition(Rec);

                        PurchLine.RESET;
                        PurchLine.SETRANGE(PurchLine."Document No.", Rec."No.");
                        IF PurchLine.FIND('-') THEN BEGIN
                            REPEAT
                                PurchLine.Committed := FALSE;
                                PurchLine.MODIFY;
                            UNTIL PurchLine.NEXT = 0;
                        END;

                        MESSAGE(Text007, Rec."No.");

                    end;
                }
            }
            group("Report")
            {
                Caption = 'Report';
                action("Print Purchase Requisition")
                {
                    Caption = 'Print Purchase Requisition';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PurchaseRequisitionHeader.RESET;
                        PurchaseRequisitionHeader.SETRANGE(PurchaseRequisitionHeader."No.", Rec."No.");
                        IF PurchaseRequisitionHeader.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Purchase Requisition", TRUE, FALSE, PurchaseRequisitionHeader);
                        END;
                    end;
                }
            }
            group(IncomingDocument)
            {
                Caption = 'Incoming Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    ApplicationArea = Suite;
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    ToolTip = 'View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes';

                    trigger OnAction()
                    var
                        IncomingDocument: Record 130;
                    begin
                        //IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData 130 = R;
                    ApplicationArea = Suite;
                    Caption = 'Select Incoming Document';
                    Image = SelectLineToApply;
                    ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record 130;
                    begin
                        //VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Incoming Document from File';
                    Ellipsis = true;
                    Enabled = CreateIncomingDocumentEnabled;
                    Image = Attach;
                    ToolTip = 'Create an incoming document from a file that you select from the disk. The file will be attached to the incoming document record.';

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record 133;
                    begin
                        //IncomingDocumentAttachment.NewAttachmentFromPurchaseRequisitionDocument(Rec);
                    end;
                }
                action(RemoveIncomingDoc)
                {
                    ApplicationArea = Suite;
                    Caption = 'Remove Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = RemoveLine;
                    ToolTip = 'Remove any incoming document records and file attachments.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record 130;
                    begin
                        IF IncomingDocument.GET(Rec."Incoming Document Entry No.") THEN
                            IncomingDocument.RemoveLinkToRelatedRecord;
                        Rec."Incoming Document Entry No." := 0;
                        Rec.MODIFY(TRUE);
                    end;
                }
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

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        //CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        /*CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RECORDID);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID)*/
        ;

        IF Rec.Status = Rec.Status::Approved THEN
            CurrPage.EDITABLE := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*PurchaseRequisitionHeader.RESET;
        PurchaseRequisitionHeader.SETRANGE("User ID",USERID);
        PurchaseRequisitionHeader.SETRANGE(Status,PurchaseRequisitionHeader.Status::Open);
        IF PurchaseRequisitionHeader.FINDFIRST THEN BEGIN
          ERROR(Txt_002);
        END;
        */

    end;

    var
        Txt_002: Label 'There is an open purchase requisition under your name, use it before you create a new one';
        Txt_003: Label 'Reopen Purchase Requisition No.:%1. All approval requests for this document will be cancelled. Continue?';
        Text001: Label 'This document has already been released. This functionality is available for open documents only';
        Text002: Label 'Some or All the Lines Are already Committed do you want to continue';
        Text003: Label 'Budget Availability Check and Commitment Aborted';
        Text004: Label 'Budget Availability Checking Complete';
        Text005: Label 'Are you sure you want to Cancel All Commitments Done for this document';
        Text006: Label 'Budget Availability Check and Commitment Aborted';
        Text007: Label 'Commitments Cancelled Successfully for Doc. No %1';
        Text008: Label 'Check Budget Availability Before Sending for Approval.';
        Error0001: Label 'Document is under Approval Process, Cancel Approval instead!';
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgt.Procurement Ext";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

        ProcurementManagement: Codeunit 50007;
        ProcurementApprovalWorkflow: Codeunit 50009;
        PurchaseRequisitionHeader: Record 50046;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund","Purchase Requisition";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        IsEditable: Boolean;
        BudgetarySetup: Record 50018;
        BudgetCommitment: Record 50019;
        Commitment: Codeunit 50007;
        SomeLinesCommitted: Boolean;
        PurchLine: Record 50047;
        ApprovalEntry: Record 454;
        ImprestHeader: Record 50008;
        PettyCashlist: Page 50129;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND (Rec."No." <> '');

        /*OpenApprovalEntriesExistForCurrUser := ApprovalsMgmtExt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmtExt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmtExt.CanCancelApprovalForRecord(Rec.RECORDID);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);*/
    end;

    procedure CheckIfSomeLinesCommitted(PurchReqNo: Code[20]) SomeLinesCommitted: Boolean
    begin
        SomeLinesCommitted := FALSE;
        PurchLine.RESET;
        PurchLine.SETRANGE("Document No.", PurchReqNo);
        IF PurchLine.FINDSET THEN BEGIN
            REPEAT
                IF PurchLine.Committed = TRUE THEN
                    SomeLinesCommitted := TRUE;
            UNTIL PurchLine.NEXT = 0;
        END;
    end;
}


page 50105 "Tender List"
{
    CardPageID = "Tender Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50055;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Tender Description"; Rec."Tender Description")
                {
                    ApplicationArea = All;
                }
                field("Tender Type"; Rec."Tender Type")
                {
                    ApplicationArea = All;
                }
                field("Tender Submission (From)"; Rec."Tender Submission (From)")
                {
                    ApplicationArea = All;
                }
                field("Tender Submission (To)"; Rec."Tender Submission (To)")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Tender Closing Date"; Rec."Tender Closing Date")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Date"; Rec."Evaluation Date")
                {
                    ApplicationArea = All;
                }
                field("Award Date"; Rec."Award Date")
                {
                    ApplicationArea = All;
                }
                field("Supplier Awarded"; Rec."Supplier Awarded")
                {
                    ApplicationArea = All;
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ApplicationArea = All;
                }
                field("Tender Status"; Rec."Tender Status")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
            chartpart("Q9151-01"; "Q9151-01")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Purchase Requisition Lines")
            {
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50084;
                RunPageLink = "Document No." = FIELD("Purchase Requisition");
                ApplicationArea = All;
            }
            action("Close Tender")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    Rec.TESTFIELD("Purchase Requisition");
                    Rec.TESTFIELD("Tender Description");
                    Rec.TESTFIELD("Tender Submission (From)");
                    Rec.TESTFIELD("Tender Submission (To)");

                    Rec.TESTFIELD("Tender Status", Rec."Tender Status"::"Tender Evaluation");

                    IF CONFIRM(Txt061) = FALSE THEN EXIT;

                    Rec."Tender Status" := Rec."Tender Status"::Closed;

                    MESSAGE(TenderClosed);
                end;
            }
            action("Print Tender List")
            {
                Caption = 'Print Tender List';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TenderHeader.RESET;
                    TenderHeader.SETRANGE(TenderHeader."No.", Rec."No.");
                    IF TenderHeader.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(REPORT::"Tender Listing", TRUE, FALSE, TenderHeader);
                    END;
                end;
            }
            action("Send To Tender Committee")
            {
                Image = Migration;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Purchase Requisition");
                    Rec.TESTFIELD("Tender Submission (From)");
                    Rec.TESTFIELD("Tender Submission (To)");


                    Rec."Tender Status" := Rec."Tender Status"::"Tender Evaluation";


                    MESSAGE(TenderEvaluate);
                end;
            }
            action("Get Awardee")
            {
                Image = Approval;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*TenderLines.RESET;
                    TenderLines.SETRANGE(TenderLines."Document No.","No.");
                    TenderLines.SETCURRENTKEY(TenderLines."Document No.",TenderLines."Total Assessment MRKS");
                    TenderLines.SETASCENDING("Total Assessment MRKS",FALSE);
                    IF TenderLines.FINDFIRST THEN
                    BEGIN
                      "Supplier Awarded":=TenderLines."Supplier No.";
                      "Supplier Name":=TenderLines."Supplier Name";
                      MODIFY;
                    END
                    */

                end;
            }
            action("Make Contract Request")
            {
                Image = CalculateDiscount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*
                    TESTFIELD("Tender Status","Tender Status"::"4");
                    IF CONFIRM (Txt060)=FALSE THEN EXIT;
                    ContractSetup.GET;
                    
                    Contract.RESET;
                    Contract.SETRANGE(Contract.Type,Contract.Type::"1");
                    Contract.SETRANGE(Contract."Contract Link","No.");
                    IF Contract.FINDFIRST THEN BEGIN
                      ERROR(Contractexist);
                    END;
                    
                    TempContract.INIT;
                    TempContract."Request No.":=NoSeriesMgt.GetNextNo(ContractSetup."Contract Request Nos",0D,TRUE);
                    TempContract."Document Date":=TODAY;
                    TempContract."Contract Link":="No.";
                    TempContract.Type:=TempContract.Type::"1";
                    TempContract.Description:="Tender Description";
                    TempContract."User ID":=USERID;
                    TempContract.INSERT;
                    MESSAGE(ContractCreated);
                    */

                end;
            }
            action("Contract Request Details")
            {
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50316;
                ApplicationArea = All;
                // RunPageLink = Contract = FIELD("No.");
            }
            group(RequestApproval)
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
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(Rec.RECORDID,DATABASE::"Purchase Requisition Header","No.");
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
                        //TESTFIELD(Status,Status::Open);
                        //ProcurementManagement.CheckPurchaseRequisitionMandatoryFields(Rec);

                        //IF ApprovalsMgmtExt.CheckPurchaseRequisitionApprovalsWorkflowEnabled(Rec) THEN
                        //  ApprovalsMgmtExt.OnSendPurchaseRequisitionForApproval(Rec);
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
                        //ApprovalsMgmtExt.OnCancelPurchaseRequisitionApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);

                        //CanCancelApprovalForRecord OR CanCancelApprovalForFlow
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
                        /*IF IncomingDocument.GET("Incoming Document Entry No.") THEN
                          IncomingDocument.RemoveLinkToRelatedRecord;
                        "Incoming Document Entry No." := 0;
                        MODIFY(TRUE);
                        */

                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SETRANGE("Held By",USERID);
    end;

    var
        ApprovalsMgmt: Codeunit 1535;
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
        TenderHeader: Record 50055;
        TenderLines: Record 50056;
        TenderClosed: Label 'Tender Successfully Closed';
        TenderEvaluate: Label 'Tender successfully now is under evaluation';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Txt060: Label 'Are you sure you want to make contract request for this tender document?';
        Txt061: Label 'Are you sure you want to close this tender?';
        Contractexist: Label 'There exists a contract in relation to this tender';
        ContractCreated: Label 'Contract request successfully created. Proceed to the contract application and send to Legal Department';
}


page 50093 "Request for Quotation List"
{
    CardPageID = "Request for Quotation Card";
    DeleteAllowed = false;
    PageType = List;
    ShowFilter = false;
    UsageCategory = Lists;
    SourceTable = 50049;
    SourceTableView = WHERE(Status = FILTER(<> Closed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the unique document number';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the date when the request for quotation was created';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ToolTip = 'Specifies the expected closing date for the request for quotation was created, after this date the request for quotation is considered complete and moved to the closed request for quotations';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the approval status for the request for quotation';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user who created the request for quotation';
                    ApplicationArea = All;
                }
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
        area(creation)
        {
            action(Reopen)
            {
                Caption = 'Reopen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*TESTFIELD("User ID",USERID);
                    IF CONFIRM(Txt_003,FALSE,"No.") THEN BEGIN
                      ProcurementApprovalWorkflow.ReOpenRequestforQuotation(Rec);
                    END;
                    */

                end;
            }
            action(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*TESTFIELD("User ID",USERID);
                    ProcurementManagement.CheckRequestforQuotationMandatoryFields(Rec);
                    IF CONFIRM(Txt_004,FALSE,"No.") THEN BEGIN
                      ProcurementApprovalWorkflow.ReleaseRequestforQuotation(Rec);
                    END;
                    */

                end;
            }
            action("Get Requisition Lines")
            {
                Caption = 'Get Requisition Lines';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Get the purchase requisition lines to add to this request for quotation';
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Description);

                    CurrPage.UPDATE(TRUE);
                    InsertRFQLinesFromPurchaseRequisition();
                end;
            }
            group("Report")
            {
                Caption = 'Report';
                action("Print Request for Quotation")
                {
                    Caption = 'Print Request for Quotation';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        RequestforQuotationHeader.RESET;
                        RequestforQuotationHeader.SETRANGE(RequestforQuotationHeader."No.", Rec."No.");
                        IF RequestforQuotationHeader.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Request for Quatation Report", TRUE, FALSE, RequestforQuotationHeader);
                        END;
                    end;
                }
                action("Print Bid Analysis")
                {
                    Caption = 'Print Bid Analysis';
                    Image = Bins;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        RequestforQuotationHeader.RESET;
                        RequestforQuotationHeader.SETRANGE(RequestforQuotationHeader."No.", Rec."No.");
                        IF RequestforQuotationHeader.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Bids Analysis", TRUE, FALSE, RequestforQuotationHeader);
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
                        IncomingDocument.ShowCardFromEntryNo(Rec."Incoming Document Entry No.");
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
                        Rec.VALIDATE("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RECORDID));
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
                        //IncomingDocumentAttachment.NewAttachmentFromRequestForQuotationDocument(Rec);
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
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        //CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        /*CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RECORDID);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID)*/
        ;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*RequestforQuotationHeader.RESET;
        RequestforQuotationHeader.SETRANGE("User ID",USERID);
        RequestforQuotationHeader.SETRANGE(Status,RequestforQuotationHeader.Status::Open);
        IF RequestforQuotationHeader.FINDFIRST THEN BEGIN
          ERROR(Txt_002);
        END;
        */

    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        PurchaseRequisitionLines: Record 50047;
        ProcurementManagement: Codeunit 50007;
        ProcurementApprovalWorkflow: Codeunit 50009;
        RequestforQuotationHeader: Record 50049;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund","Purchase Requisition";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        Txt_002: Label 'There is an open request for quotation under your name, use it before you create a new one';
        Txt_003: Label 'Reopen "Request for Quotation No.":%1';
        Txt_004: Label 'Release "Request for Quotation No.":%1';

    procedure InsertRFQLinesFromPurchaseRequisition()
    var
        RequisitionLines: Page 50092;
        SelectedPurchaseRequisitionLine: Record 50047;
        Counter: Integer;
        RFQLine: Record 50050;
        "LineNo.": Integer;
        RFQLine2: Record 50050;
    begin
        //Get Last Line No.
        RFQLine2.RESET;
        RFQLine2.SETRANGE(RFQLine2."Document No.", Rec."No.");
        RFQLine2.SETCURRENTKEY("Document No.", "Line No.");
        IF RFQLine2.FINDLAST THEN BEGIN
            "LineNo." := RFQLine2."Line No.";
        END ELSE BEGIN
            "LineNo." := 1000;
        END;
        //End Get Last Line No.
        RequisitionLines.LOOKUPMODE(TRUE);
        IF RequisitionLines.RUNMODAL = ACTION::LookupOK THEN BEGIN
            RequisitionLines.SetSelection(SelectedPurchaseRequisitionLine);
            Counter := SelectedPurchaseRequisitionLine.COUNT;
            IF Counter > 0 THEN BEGIN
                IF SelectedPurchaseRequisitionLine.FINDSET THEN
                    REPEAT
                        "LineNo." := "LineNo." + 1;
                        RFQLine.INIT;
                        RFQLine."Line No." := "LineNo.";
                        RFQLine."Document No." := Rec."No.";
                        RFQLine."Document Date" := Rec."Document Date";
                        RFQLine."Requisition Type" := SelectedPurchaseRequisitionLine."Requisition Type";
                        RFQLine."Requisition Code" := SelectedPurchaseRequisitionLine."Requisition Code";
                        IF RFQLine."Requisition Type" = RFQLine."Requisition Type"::Service THEN BEGIN
                            RFQLine.Type := RFQLine.Type::"G/L Account";
                        END;
                        IF RFQLine."Requisition Type" = RFQLine."Requisition Type"::Item THEN BEGIN
                            RFQLine.Type := RFQLine.Type::Item;
                        END;
                        IF RFQLine."Requisition Type" = RFQLine."Requisition Type"::"Fixed Asset" THEN BEGIN
                            RFQLine.Type := RFQLine.Type::"Fixed Asset";
                        END;
                        RFQLine."No." := SelectedPurchaseRequisitionLine."No.";
                        RFQLine.Name := SelectedPurchaseRequisitionLine.Name;
                        RFQLine."Location Code" := SelectedPurchaseRequisitionLine."Location Code";
                        RFQLine."Unit of Measure Code" := SelectedPurchaseRequisitionLine."Unit of Measure";
                        RFQLine.Quantity := SelectedPurchaseRequisitionLine.Quantity;
                        RFQLine."Currency Code" := SelectedPurchaseRequisitionLine."Currency Code";
                        RFQLine."Currency Factor" := SelectedPurchaseRequisitionLine."Currency Factor";
                        RFQLine."Unit Cost" := SelectedPurchaseRequisitionLine."Unit Cost";
                        RFQLine."Unit Cost(LCY)" := SelectedPurchaseRequisitionLine."Unit Cost(LCY)";
                        RFQLine."Total Cost" := SelectedPurchaseRequisitionLine."Total Cost";
                        RFQLine."Total Cost(LCY)" := SelectedPurchaseRequisitionLine."Total Cost(LCY)";
                        RFQLine.Description := SelectedPurchaseRequisitionLine.Description;
                        RFQLine."Global Dimension 1 Code" := SelectedPurchaseRequisitionLine."Global Dimension 1 Code";
                        RFQLine."Global Dimension 2 Code" := SelectedPurchaseRequisitionLine."Global Dimension 2 Code";
                        RFQLine."Shortcut Dimension 3 Code" := SelectedPurchaseRequisitionLine."Shortcut Dimension 3 Code";
                        RFQLine."Shortcut Dimension 4 Code" := SelectedPurchaseRequisitionLine."Shortcut Dimension 4 Code";
                        RFQLine."Shortcut Dimension 5 Code" := SelectedPurchaseRequisitionLine."Shortcut Dimension 5 Code";
                        RFQLine."Shortcut Dimension 6 Code" := SelectedPurchaseRequisitionLine."Shortcut Dimension 6 Code";
                        RFQLine."Shortcut Dimension 7 Code" := SelectedPurchaseRequisitionLine."Shortcut Dimension 7 Code";
                        RFQLine."Shortcut Dimension 8 Code" := SelectedPurchaseRequisitionLine."Shortcut Dimension 8 Code";
                        RFQLine."Responsibility Center" := SelectedPurchaseRequisitionLine."Responsibility Center";
                        RFQLine."Purchase Requisition Line" := SelectedPurchaseRequisitionLine."Line No.";
                        RFQLine."Purchase Requisition No." := SelectedPurchaseRequisitionLine."Document No.";
                        IF RFQLine.INSERT THEN BEGIN
                            PurchaseRequisitionLines.RESET;
                            PurchaseRequisitionLines.SETRANGE(PurchaseRequisitionLines."Line No.", SelectedPurchaseRequisitionLine."Line No.");
                            PurchaseRequisitionLines.SETRANGE(PurchaseRequisitionLines."Document No.", SelectedPurchaseRequisitionLine."Document No.");
                            PurchaseRequisitionLines.SETRANGE(PurchaseRequisitionLines."Requisition Code", SelectedPurchaseRequisitionLine."Requisition Code");
                            IF PurchaseRequisitionLines.FINDFIRST THEN BEGIN
                                PurchaseRequisitionLines.Closed := TRUE;
                                PurchaseRequisitionLines."Request for Quotation No." := rEC."No.";
                                PurchaseRequisitionLines."Request for Quotation Line" := "LineNo.";
                                PurchaseRequisitionLines.MODIFY;
                            END;
                        END;
                    UNTIL SelectedPurchaseRequisitionLine.NEXT = 0;
            END;
        END;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgt.Procurement Ext";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND (Rec."No." <> '');

        /*OpenApprovalEntriesExistForCurrUser := ApprovalsMgmtExt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmtExt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmtExt.CanCancelApprovalForRecord(Rec.RECORDID);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);*/
    end;
}


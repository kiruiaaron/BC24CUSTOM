page 51336 "Lookup Payment List"
{
    Caption = 'Payment List';
    CardPageID = "Lookup Payment Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Lists;
    ApplicationArea = all;
    PageType = List;
    SourceTable = 50002;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the document number';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the date when the journals will be posted.';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the paying bank';
                    ApplicationArea = All;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ToolTip = 'Specifies the paying bank name';
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the transaction external reference number, e.g. cheque number';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ToolTip = 'Specifies the vendor or employee being paid';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the transaction currency';
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the total amount to be paid to the vendor';
                    ApplicationArea = All;
                }
                field("WithHolding Tax Amount"; Rec."WithHolding Tax Amount")
                {
                    ToolTip = 'Specifies the amount of withholding tax being withheld in this payment';
                    ApplicationArea = All;
                }
                field("Withholding VAT Amount"; Rec."Withholding VAT Amount")
                {
                    ToolTip = 'Specifies the amount of withholding vat being withheld in this payment';
                    ApplicationArea = All;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ToolTip = 'Specifies the net amount of payment after withholding tax and withholding vat.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the payment approval status,open/pending approval/released/rejected';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user who did the payment ';
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
                //ToolTip = 'Incoming Document Attachment FactBox';
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
                ApplicationArea = All;

                trigger OnAction()
                begin
                    UserSetup.RESET;
                    UserSetup.SETRANGE(UserSetup."User ID", USERID);
                    IF UserSetup."Approval Administrator" THEN BEGIN

                    END ELSE BEGIN

                    END;
                end;
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
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund","Purchase Requisition";
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Payment Header",DocType::Payment,"No.");
                        ApprovalsMgmtExt.ShowPaymentHeaderApprovalEntries(Rec);
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
                    var
                        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        FundsManagement.CheckPaymentMandatoryFields(Rec, FALSE);

                        IF ApprovalsMgmtExt.CheckPaymentApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendPaymentHeaderForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                    begin
                        ApprovalsMgmtExt.OnCancelPaymentHeaderApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                action("Preview Posting")
                {
                    Caption = 'Preview Posting';
                    Image = PreviewChecks;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckPaymentMandatoryFields(Rec, FALSE);
                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD("Payment Journal Template");
                            FundsUserSetup.TESTFIELD("Payment Journal Batch");
                            JTemplate := FundsUserSetup."Payment Journal Template";
                            JBatch := FundsUserSetup."Payment Journal Batch";
                            FundsManagement.PostPayment(Rec, JTemplate, JBatch, TRUE);
                        END ELSE BEGIN
                            ERROR(Txt_001, USERID);
                        END;
                    end;
                }
                action("Post Payment")
                {
                    Caption = 'Post Payment';
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckPaymentMandatoryFields(Rec, TRUE);
                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD(FundsUserSetup."Payment Journal Template");
                            FundsUserSetup.TESTFIELD(FundsUserSetup."Payment Journal Batch");
                            JTemplate := FundsUserSetup."Payment Journal Template";
                            JBatch := FundsUserSetup."Payment Journal Batch";
                            IF Rec."Loan Disbursement Type" = Rec."Loan Disbursement Type"::" " THEN
                                FundsManagement.PostPayment(Rec, JTemplate, JBatch, FALSE);
                            /*IF "Loan Disbursement Type" = "Loan Disbursement Type"::"Investment Loan" THEN
                             FundsManagement.PostInvestmentLoanPayment(Rec,JTemplate,JBatch,FALSE);
                            IF "Loan Disbursement Type" = "Loan Disbursement Type"::Equity THEN
                             FundsManagement.PostEquityPayment(Rec,JTemplate,JBatch,FALSE);
                           IF "Loan Disbursement Type" = "Loan Disbursement Type"::"Staff Loan" THEN
                            FundsManagement.PostHRLoanPayment(Rec,JTemplate,JBatch,FALSE);*/
                        END ELSE BEGIN
                            ERROR(Txt_001, USERID);
                        END;

                    end;
                }
                action("Post and Print Payment")
                {
                    Caption = 'Post and Print Payment';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckPaymentMandatoryFields(Rec, TRUE);
                        "DocNo." := Rec."No.";
                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD(FundsUserSetup."Payment Journal Template");
                            FundsUserSetup.TESTFIELD(FundsUserSetup."Payment Journal Batch");
                            JTemplate := FundsUserSetup."Payment Journal Template";
                            JBatch := FundsUserSetup."Payment Journal Batch";
                            IF Rec."Loan No." = '' THEN
                                FundsManagement.PostPayment(Rec, JTemplate, JBatch, FALSE)
                            ELSE
                                /*FundsManagement.PostInvestmentLoanPayment(Rec,JTemplate,JBatch,FALSE);*/
                          COMMIT;
                            PaymentHeader.RESET;
                            PaymentHeader.SETRANGE(PaymentHeader."No.", "DocNo.");
                            IF PaymentHeader.FINDFIRST THEN BEGIN
                                REPORT.RUNMODAL(REPORT::"Payment Voucher", TRUE, FALSE, PaymentHeader);
                            END;
                        END ELSE BEGIN
                            ERROR(Txt_001, USERID);
                        END;

                    end;
                }
            }
            group("Report")
            {
                Caption = 'Report';
                action("Print Pety Cash Payment")
                {
                    Caption = 'Print Pety Cash Payment';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PaymentHeader.RESET;
                        PaymentHeader.SETRANGE(PaymentHeader."No.", Rec."No.");
                        IF PaymentHeader.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Payment Voucher II", TRUE, FALSE, PaymentHeader);
                        END;
                    end;
                }
                action("Print Payment Payment Voucher")
                {
                    Caption = 'Print Payment Payment Voucher';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PaymentHeader.RESET;
                        PaymentHeader.SETRANGE(PaymentHeader."No.", Rec."No.");
                        IF PaymentHeader.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Payments Voucher", TRUE, FALSE, PaymentHeader);
                        END;
                    end;
                }
                action("Print Cheque")
                {
                    Caption = 'Print Cheque';
                    Image = Check;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Print Bank Cheque for this Payment';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //TESTFIELD(Status,Status::Approved);
                        //TESTFIELD("Cheque Type","Cheque Type"::"Computer Cheque");

                        PaymentHeader.RESET;
                        PaymentHeader.SETRANGE(PaymentHeader."No.", Rec."No.");
                        IF PaymentHeader.FINDFIRST THEN
                            REPORT.RUN(REPORT::"Cheque Print", TRUE, TRUE, PaymentHeader);
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
                        IncomingDocumentAttachment.NewAttachmentFromPaymentDocument(Rec);
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
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID)*/
        ;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*PaymentHeader.RESET;
        PaymentHeader.SETRANGE("User ID",USERID);
        PaymentHeader.SETRANGE(Status,PaymentHeader.Status::Open);
        PaymentHeader.SETRANGE("Payment Type",PaymentHeader."Payment Type"::"Cheque Payment");
        IF PaymentHeader.FINDFIRST THEN BEGIN
          ERROR(Txt_002);
        END;
        */
        //"Payment Type":="Payment Type"::"Cheque Payment";

    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
        UserSetup: Record 91;
        FundsManagement: Codeunit 50045;
        FundsUserSetup: Record 50029;
        PaymentHeader: Record 50002;
        JTemplate: Code[10];
        JBatch: Code[10];
        "DocNo.": Code[20];
        Txt_001: Label 'User Account %1 is not Setup for Payments Posting, Contact the System Administrator';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        Txt_002: Label 'There is an open payment document under your name, use it before you create a new one';

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND (Rec."No." <> '');

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;
}


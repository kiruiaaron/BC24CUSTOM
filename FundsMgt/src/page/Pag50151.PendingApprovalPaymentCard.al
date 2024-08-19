page 50151 "Pending Approval Payment Card"
{
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = 50002;
    SourceTableView = WHERE("Payment Type" = CONST("Cheque Payment"),
                            Posted = CONST(False),
                            Status = CONST("Pending Approval"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = PageEditable;
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the document number';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        Rec.AssistEdit;
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the date when the document was created';
                    ApplicationArea = All;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ToolTip = 'Specifies the mode of payment e.g. Cheque,EFT,RTGS,MPESA,Cash';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the paying bank';
                    ApplicationArea = All;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ToolTip = 'Specifies the paying bank name';
                    ApplicationArea = All;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Payee Bank Account Name"; Rec."Payee Bank Account Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payee Bank Account No."; Rec."Payee Bank Account No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payee Bank Code"; Rec."Payee Bank Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payee Bank Name"; Rec."Payee Bank Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("MPESA/Paybill Account No."; Rec."MPESA/Paybill Account No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the field name';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Total Amount(LCY)"; Rec."Total Amount(LCY)")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("WithHolding Tax Amount"; Rec."WithHolding Tax Amount")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("WithHolding Tax Amount(LCY)"; Rec."WithHolding Tax Amount(LCY)")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Withholding VAT Amount"; Rec."Withholding VAT Amount")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Withholding VAT Amount(LCY)"; Rec."Withholding VAT Amount(LCY)")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Net Amount(LCY)"; Rec."Net Amount(LCY)")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
            }
            group("Payment Details")
            {
                field("Cheque Type"; Rec."Cheque Type")
                {
                    ToolTip = 'Specifies the cheque fill type, manual fill or automated fill';
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the transaction external reference number, e.g. cheque number';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        Rec.AssistEdit;
                    end;
                }
                field("Cheque Date"; Rec."Posting Date")
                {
                    Caption = 'Cheque Date';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the date when the journals will be posted.';
                    ApplicationArea = All;
                }
            }
            part(PaymentLine; 50004)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            part(ApprovalFactBox; 9092)
            {
                ApplicationArea = Advanced;
            }
            part(IncomingDocAttachFactBox; 193)
            {
                ApplicationArea = Advanced;
                ShowFilter = false;
                Visible = false;
            }
            part(WorkflowStatus; 1528)
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Links; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
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
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund","Purchase Requisition";
                    begin
                        //  WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID, DATABASE::"Payment Header", DocType::Payment, "No.");
                        ApprovalMgt.OpenApprovalEntriesPage(Rec.RECORDID);
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

                        CurrPage.CLOSE;
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
                        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                    begin
                        ApprovalsMgmtExt.OnCancelPaymentHeaderApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                    end;
                }
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
                        Rec.TESTFIELD(Status, Rec.Status::Approved);
                        UserSetup.RESET;
                        UserSetup.SETRANGE(UserSetup."User ID", USERID);
                        IF UserSetup.FINDFIRST THEN BEGIN
                            IF UserSetup."Reopen Documents" THEN
                                FundsApprovalManager.ReOpenPaymentHeader(Rec);
                            MESSAGE(Txt_003);
                        END;
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

                        //Check if  Reference Number has been used
                        /*PaymentHeader.RESET;
                        PaymentHeader.SETRANGE(PaymentHeader."Reference No.","Reference No.");
                        PaymentHeader.SETRANGE(PaymentHeader."Bank Account No.","Bank Account No.");
                        PaymentHeader.SETFILTER(PaymentHeader."Reference No.",'<>%1','');
                        IF PaymentHeader.FINDFIRST THEN BEGIN
                          IF PaymentHeader."Reference No."="Reference No." THEN
                           ERROR(ErrorUsedReferenceNumber,PaymentHeader."No.");
                        END;
                        
                        BankAccountLedgerEntry.RESET;
                        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."External Document No.","Reference No.");
                        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry.Reversed,FALSE);
                        IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                          ERROR(ErrorUsedReferenceNumber,BankAccountLedgerEntry."Document No.");
                        END;*/

                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD(FundsUserSetup."Payment Journal Template");
                            FundsUserSetup.TESTFIELD(FundsUserSetup."Payment Journal Batch");
                            JTemplate := FundsUserSetup."Payment Journal Template";
                            JBatch := FundsUserSetup."Payment Journal Batch";
                            IF Rec."Loan Disbursement Type" = Rec."Loan Disbursement Type"::" " THEN
                                FundsManagement.PostPayment(Rec, JTemplate, JBatch, FALSE);
                            /*IF "Loan Disbursement Type" = "Loan Disbursement Type"::"Investment Loan" THEN
                          //   FundsManagement.PostInvestmentLoanPayment(Rec,JTemplate,JBatch,FALSE);
                           IF "Loan Disbursement Type" = "Loan Disbursement Type"::Equity THEN
                             FundsManagement.PostEquityPayment(Rec,JTemplate,JBatch,FALSE);
                            IF "Loan Disbursement Type" = "Loan Disbursement Type"::"Staff Loan" THEN
                             FundsManagement.PostHRLoanPayment(Rec,JTemplate,JBatch,FALSE);
                          END ELSE BEGIN*/
                            //ERROR(Txt_001,USERID);
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
                                FundsManagement.PostPayment(Rec, JTemplate, JBatch, FALSE);
                            /*ELSE
                             FundsManagement.PostInvestmentLoanPayment(Rec,JTemplate,JBatch,FALSE);*/
                            COMMIT;
                            PaymentHeader.RESET;
                            PaymentHeader.SETRANGE(PaymentHeader."No.", "DocNo.");
                            IF PaymentHeader.FINDFIRST THEN BEGIN
                                REPORT.RUNMODAL(REPORT::"Payment Voucher II", TRUE, FALSE, PaymentHeader);
                            END;
                        END ELSE BEGIN
                            ERROR(Txt_001, USERID);
                        END;

                    end;
                }
                action("Post Payment Line By Line")
                {
                    Caption = 'Post Payment Line By Line';
                    Image = PaymentJournal;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
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
                            FundsManagement.PostPaymentLineByLine(Rec, JTemplate, JBatch, FALSE);
                        END ELSE BEGIN
                            ERROR(Txt_001, USERID);
                        END;
                    end;
                }
                action("Import Payment Lines")
                {
                    Caption = 'Import Payment Lines';
                    Image = Import;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ToolTip = 'Import Payment Lines';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD(FundsUserSetup."Payment Journal Template");
                            FundsUserSetup.TESTFIELD(FundsUserSetup."Payment Journal Batch");

                            PaymentLineImportBuffer.RESET;
                            PaymentLineImportBuffer.SETRANGE(PaymentLineImportBuffer."User ID", USERID);
                            IF PaymentLineImportBuffer.FINDSET THEN BEGIN
                                PaymentLineImportBuffer.DELETEALL;
                            END;
                            COMMIT;

                            // XMLPORT.RUN(XMLPORT::XMLport52136960);
                            COMMIT;

                            PaymentLineImportBuffer.RESET;
                            PaymentLineImportBuffer.SETRANGE(PaymentLineImportBuffer."User ID", USERID);
                            IF PaymentLineImportBuffer.FINDSET THEN BEGIN
                                REPEAT
                                    PaymentLine.INIT;
                                    PaymentLine."Line No." := 0;
                                    PaymentLine."Document No." := Rec."No.";
                                    PaymentLine."Payment Code" := PaymentLineImportBuffer."Payment Code";
                                    PaymentLine.VALIDATE("Payment Code");
                                    /*FundsTransactionCodes.RESET;
                                    FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code",PaymentLineImportBuffer."Payment Code");
                                    IF FundsTransactionCodes.FINDFIRST THEN BEGIN
                                      PaymentLine."Account Type":=FundsTransactionCodes."Account Type";
                                      PaymentLine."Posting Group":=FundsTransactionCodes."Posting Group";
                                      PaymentLine."Payment Code Description":=FundsTransactionCodes.Description;
                                      //Employee Transaction Type
                                      PaymentLine."Employee Transaction Type":=FundsTransactionCodes."Employee Transaction Type";
                                    END;
                                    */
                                    PaymentLine."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                    PaymentLine."Account No." := PaymentLineImportBuffer."Account No.";
                                    PaymentLine.VALIDATE("Account No.");
                                    PaymentLine.Description := PaymentLineImportBuffer.Description;
                                    PaymentLine."Reference No." := PaymentLineImportBuffer."Reference No.";
                                    PaymentLine."Total Amount" := PaymentLineImportBuffer."Total Amount";
                                    PaymentLine.VALIDATE("Total Amount");
                                    PaymentLine.INSERT;
                                UNTIL PaymentLineImportBuffer.NEXT = 0;
                            END;
                        END ELSE BEGIN
                            ERROR(Txt_001, USERID);
                        END;
                        PaymentLineImportBuffer.RESET;
                        PaymentLineImportBuffer.SETRANGE(PaymentLineImportBuffer."User ID", USERID);
                        IF PaymentLineImportBuffer.FINDSET THEN BEGIN
                            PaymentLineImportBuffer.DELETEALL;
                        END;

                    end;
                }
            }
            group(Reversal)
            {
                Caption = 'Reversal';
                Image = "Action";
                action("Reverse Payment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reverse Payment';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Scope = Repeater;
                    ToolTip = 'Reverse a posted payment.';

                    trigger OnAction()
                    var
                        ReversalEntry: Record 179;
                        "TransactionNo.": Integer;
                        "G/LEntry": Record 17;
                        CustLedgerEntry: Record 21;
                        VendorLedgerEntry: Record 25;
                    begin
                        CLEAR(ReversalEntry);
                        IF Rec.Reversed THEN
                            ReversalEntry.AlreadyReversedDocument(PaymentTxt, Rec."No.");

                        //Get transaction no.
                        BankAccountLedgerEntry.RESET;
                        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Document No.", Rec."No.");
                        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry.Reversed, FALSE);
                        IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                            ReversalEntry.ReverseTransaction(BankAccountLedgerEntry."Transaction No.");
                        END;

                        COMMIT;

                        //Update the document
                        BankAccountLedgerEntry.RESET;
                        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Document No.", Rec."No.");
                        BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry.Reversed, TRUE);
                        IF BankAccountLedgerEntry.FINDLAST THEN BEGIN
                            Rec.Status := Rec.Status::Reversed;
                            Rec.Reversed := TRUE;
                            Rec."Reversal Date" := TODAY;
                            Rec."Reversal Time" := TIME;
                            Rec."Reversed By" := USERID;
                            Rec.MODIFY;
                        END;
                    end;
                }
            }
            group("Report")
            {
                Caption = 'Report';
                action("Print Petty Cash Payment")
                {
                    Caption = 'Print Petty Cash Payment';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
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
                action("Print Payment Voucher")
                {
                    Caption = 'Print Payment Voucher';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
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
                        Rec.TESTFIELD("Cheque Type", Rec."Cheque Type"::"Computer Cheque");

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
        Rec."Payment Type" := Rec."Payment Type"::"Cheque Payment";


    end;

    var
        Txt_001: Label 'User Account %1 is not Setup for Payments Posting, Contact the System Administrator';
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
        FundsManagement: Codeunit 50045;
        FundsApprovalManager: Codeunit 50003;
        FundsUserSetup: Record 50029;
        PaymentHeader: Record 50002;
        UserSetup: Record 91;
        BankAccountLedgerEntry: Record 271;
        PaymentLine: Record 50003;
        FundsTransactionCodes: Record 50027;
        PaymentLineImportBuffer: Record 50015;
        JTemplate: Code[10];
        JBatch: Code[10];
        "DocNo.": Code[20];
        PageEditable: Boolean;
        ActionsVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        Txt_002: Label 'There is an open payment document under your name, use it before you create a new one.';
        Txt_003: Label 'Document reopened successfully.';
        ErrorUsedReferenceNumber: Label 'The Reference Number has been used for Payment No:%1';
        PaymentTxt: Label 'Payment';

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

        IF (Rec.Status = Rec.Status::Open) OR (Rec.Status = Rec.Status::"Pending Approval") THEN BEGIN
            PageEditable := TRUE;
        END ELSE BEGIN
            PageEditable := FALSE;
        END;
    end;
}


page 50013 "Receipt Card"
{
    PageType = Card;
    SourceTable = 50004;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                }
                field("Receipt Types"; Rec."Receipt Types")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    Caption = 'Bank/G/L Account No.';
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Receipt Type"; Rec."Receipt Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF (Rec."Receipt Type" = Rec."Receipt Type"::"Investment Loan") OR (Rec."Receipt Type" = Rec."Receipt Type"::Equity) THEN
                            InvestmentDetailsVisible := TRUE;
                    end;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Amount Received"; Rec."Amount Received")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Received From"; Rec."Received From")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50014)
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
                Visible = false;
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
            action("Suggest Lines")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //  InvstReceiptApplication.InsertRecoveryPriorities();

                    /*   IF "Investment Account No." <> '' THEN BEGIN
                          InvstReceiptApplication.SuggestInvestmentLoanRepaymentsDefined("No.", "Amount Received", "Investment Account No.");
                      END ELSE BEGIN
                          InvstReceiptApplication.SuggestInvestmentLoanRepaymentsUnDefined("No.", "Amount Received");
                      END; */
                end;
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Visible = false;
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
                        ApprovalsMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //  WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID, DATABASE::"Receipt Header", "Document Type", "No.");
                        ApprovalsMgt.OpenApprovalEntriesPage(Rec.RECORDID);
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

                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        FundsManagement.CheckReceiptMandatoryFields(Rec, FALSE);

                        IF ApprovalsMgmtExt.IsReceiptApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendReceiptHeaderForApproval(Rec);
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

                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                    begin
                        ApprovalsMgmtExt.OnCancelReceiptHeaderApprovalRequest(Rec);
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
                        FundsManagement.CheckReceiptMandatoryFields(Rec, TRUE);
                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD("Receipt Journal Template");
                            FundsUserSetup.TESTFIELD("Receipt Journal Batch");
                            JTemplate := FundsUserSetup."Receipt Journal Template";
                            JBatch := FundsUserSetup."Receipt Journal Batch";
                            FundsManagement.PostReceipt(Rec, JTemplate, JBatch, TRUE);
                        END ELSE BEGIN
                            ERROR(UserAccountNotSetup, USERID);
                        END;
                    end;
                }
                action("Post and Print Receipt")
                {
                    Caption = 'Post and Print Receipt';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckReceiptMandatoryFields(Rec, TRUE);

                        //Allocate loan Repayments
                        IF Rec."Receipt Type" = Rec."Receipt Type"::"Investment Loan" THEN BEGIN
                            Rec.TESTFIELD("Client No.");
                        END;

                        "DocNo." := Rec."No.";
                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD("Receipt Journal Template");
                            FundsUserSetup.TESTFIELD("Receipt Journal Batch");
                            JTemplate := FundsUserSetup."Receipt Journal Template";
                            JBatch := FundsUserSetup."Receipt Journal Batch";
                            FundsManagement.PostReceipt(Rec, JTemplate, JBatch, FALSE);
                            COMMIT;
                            ReceiptHeader.RESET;
                            ReceiptHeader.SETRANGE(ReceiptHeader."No.", "DocNo.");
                            IF ReceiptHeader.FINDFIRST THEN BEGIN
                                REPORT.RUNMODAL(REPORT::"Receipt Header", TRUE, FALSE, ReceiptHeader);
                            END;
                        END ELSE BEGIN
                            ERROR(UserAccountNotSetup, USERID);
                        END;

                        CurrPage.CLOSE;
                    end;
                }
                action("Print Receipt")
                {
                    Caption = 'Print Receipt';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ReceiptHeader.RESET;
                        ReceiptHeader.SETRANGE(ReceiptHeader."No.", Rec."No.");
                        IF ReceiptHeader.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Receipt Header", TRUE, FALSE, ReceiptHeader);
                        END;
                    end;
                }
                action("Post Receipt")
                {
                    Caption = 'Post Receipt';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckReceiptMandatoryFields(Rec, TRUE);

                        "DocNo." := Rec."No.";

                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            IF Rec."Payment Mode" = Rec."Payment Mode"::Cheque THEN BEGIN
                                //insert to cheque buffer
                                Rec."Posted to Cheque Buffer" := TRUE;
                                Rec.MODIFY;
                                CurrPage.CLOSE;
                            END ELSE BEGIN
                                FundsUserSetup.TESTFIELD("Receipt Journal Template");
                                FundsUserSetup.TESTFIELD("Receipt Journal Batch");
                                JTemplate := FundsUserSetup."Receipt Journal Template";
                                JBatch := FundsUserSetup."Receipt Journal Batch";
                                FundsManagement.PostReceipt(Rec, JTemplate, JBatch, FALSE);
                                COMMIT;
                            END;
                        END ELSE BEGIN
                            ERROR(UserAccountNotSetup, USERID);
                        END;

                        CurrPage.CLOSE;
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

    trigger OnAfterGetRecord()
    begin
        IF (Rec."Receipt Type" <> Rec."Receipt Type"::"Investment Loan") OR (Rec."Receipt Type" <> Rec."Receipt Type"::Equity) THEN
            InvestmentDetailsVisible := FALSE ELSE
            InvestmentDetailsVisible := TRUE;
    end;

    trigger OnOpenPage()
    begin
        IF (Rec."Posted to Cheque Buffer" = TRUE) AND (Rec."Payment Mode" = Rec."Payment Mode"::Cheque) THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        UserAccountNotSetup: Label 'User Account %1 is not Setup for Receipt Posting, Contact the System Administrator';
        FundsManagement: Codeunit 50045;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
        //  InvstReceiptApplication: Codeunit 50064;
        FundsUserSetup: Record 50029;
        JTemplate: Code[10];
        JBatch: Code[10];
        "DocNo.": Code[20];
        ReceiptHeader: Record 50004;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        InvestmentDetailsVisible: Boolean;

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


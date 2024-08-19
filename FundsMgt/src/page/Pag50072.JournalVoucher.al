page 50072 "Journal Voucher"
{

    PageType = Card;
    SourceTable = 50016;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("JV No."; Rec."JV No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Document date"; Rec."Document date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("JV Lines Cont"; Rec."JV Lines Cont")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50073)
            {
                SubPageLink = "JV No." = FIELD("JV No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Print JV Report")
            {
                Image = PrepaymentSimulation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    JournalVoucher.RESET;
                    JournalVoucher.SETRANGE(JournalVoucher."JV No.", Rec."JV No.");
                    IF JournalVoucher.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(REPORT::"Journal Voucher Report", TRUE, FALSE, JournalVoucher);
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
                    /*                     RunObject = Page "Approval Entries";
                                        RunPageLink = "Document No." = FIELD("JV No."); */
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

                        FundsManagement.CheckJournalVoucherMandatoryFields(Rec, FALSE);

                        IF ApprovalsMgmtExt.CheckJournalVoucherApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendJournalVoucherForApproval(Rec);
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
                        ApprovalsMgmtExt.OnCancelJournalVoucherApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);

                        //CanCancelApprovalForRecord OR CanCancelApprovalForFlow
                    end;
                }
            }
            group(Postings)
            {
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
                        FundsManagement.CheckJournalVoucherMandatoryFields(Rec, FALSE);

                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD("JV Template");
                            FundsUserSetup.TESTFIELD("JV Batch");
                            JTemplate := FundsUserSetup."JV Template";
                            JBatch := FundsUserSetup."JV Batch";
                            FundsManagement.PostJournalVoucher(Rec, JTemplate, JBatch, TRUE);
                        END ELSE BEGIN
                            ERROR(Txt_001, USERID);
                        END;
                    end;
                }
                action("Post Journal")
                {
                    Caption = 'Post Journal';
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckJournalVoucherMandatoryFields(Rec, TRUE);


                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD(FundsUserSetup."JV Template");
                            FundsUserSetup.TESTFIELD(FundsUserSetup."JV Batch");
                            JTemplate := FundsUserSetup."JV Template";
                            JBatch := FundsUserSetup."JV Batch";
                            FundsManagement.PostJournalVoucher(Rec, JTemplate, JBatch, FALSE);
                        END ELSE BEGIN
                            ERROR(Txt_001, USERID);
                        END;
                    end;
                }
                action("Post and Print Journal")
                {
                    Caption = 'Post and Print Journal';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckJournalVoucherMandatoryFields(Rec, TRUE);

                        "DocNo." := Rec."JV No.";

                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD(FundsUserSetup."JV Template");
                            FundsUserSetup.TESTFIELD(FundsUserSetup."JV Batch");
                            JTemplate := FundsUserSetup."JV Template";
                            JBatch := FundsUserSetup."JV Batch";
                            FundsManagement.PostJournalVoucher(Rec, JTemplate, JBatch, FALSE);

                            COMMIT;

                            JournalVoucher.RESET;
                            JournalVoucher.SETRANGE(JournalVoucher."JV No.", "DocNo.");
                            IF JournalVoucher.FINDFIRST THEN BEGIN
                                REPORT.RUNMODAL(REPORT::"Journal Voucher Report", TRUE, FALSE, JournalVoucher);
                            END;
                        END ELSE BEGIN
                            ERROR(Txt_001, USERID);
                        END;
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
    end;

    trigger OnOpenPage()
    begin
        IF Rec.Status <> Rec.Status::Open THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        FundsManagement: Codeunit 50045;
        FundsUserSetup: Record 50029;
        JTemplate: Code[30];
        JBatch: Code[30];
        Txt_001: Label 'User Account %1 is not Setup for Journal Posting, Contact the System Administrator';
        "DocNo.": Code[30];
        JournalVoucher: Record 50016;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin
        //HasIncomingDocument := "Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND (Rec."JV No." <> '');

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;
}


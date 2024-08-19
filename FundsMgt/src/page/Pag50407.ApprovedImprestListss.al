page 50407 "Approved Imprest List-ss"
{
    CardPageID = "Imprest Card";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50008;
    SourceTableView = WHERE(Posted = CONST(False),
                            Type = CONST(Imprest),
                            Status = CONST(Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("HR Job Grade"; Rec."HR Job Grade")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Date From"; Rec."Date From")
                {
                    ApplicationArea = All;
                }
                field("Date To"; Rec."Date To")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the field name';
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
        area(creation)
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
                    Rec.TESTFIELD(Status, Rec.Status::Approved);
                    UserSetup.RESET;
                    UserSetup.SETRANGE(UserSetup."User ID", USERID);
                    IF UserSetup.FINDFIRST THEN BEGIN
                        IF UserSetup."Reopen Documents" THEN
                            FundsApprovalManager.ReOpenImprestHeader(Rec);
                    END;
                    MESSAGE(TEXT_003);
                end;
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
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                    begin
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
                        FundsManagement.CheckImprestMandatoryFields(Rec, FALSE);

                        IF ApprovalsMgmtExt.CheckImprestApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendImprestHeaderForApproval(Rec);
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
                        ApprovalsMgmtExt.OnCancelImprestHeaderApprovalRequest(Rec);
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
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckImprestMandatoryFields(Rec, TRUE);
                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD("Imprest Template");
                            FundsUserSetup.TESTFIELD("Imprest Batch");
                            JTemplate := FundsUserSetup."Imprest Template";
                            JBatch := FundsUserSetup."Imprest Batch";
                            FundsManagement.PostImprest(Rec, JTemplate, JBatch, TRUE);
                        END ELSE BEGIN
                            ERROR(UserAccountNotSetup, USERID);
                        END;
                    end;
                }
                action("Post Imprest")
                {
                    Caption = 'Post Imprest';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckImprestMandatoryFields(Rec, TRUE);
                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD("Imprest Template");
                            FundsUserSetup.TESTFIELD("Imprest Batch");
                            JTemplate := FundsUserSetup."Imprest Template";
                            JBatch := FundsUserSetup."Imprest Batch";
                            FundsManagement.PostImprest(Rec, JTemplate, JBatch, FALSE);
                        END ELSE BEGIN
                            ERROR(UserAccountNotSetup, USERID);
                        END;
                    end;
                }
                action("Post and Print Imprest")
                {
                    Caption = 'Post and Print Imprest';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FundsManagement.CheckImprestMandatoryFields(Rec, TRUE);
                        "DocNo." := Rec."No.";
                        IF FundsUserSetup.GET(USERID) THEN BEGIN
                            FundsUserSetup.TESTFIELD("Imprest Template");
                            FundsUserSetup.TESTFIELD("Imprest Batch");
                            JTemplate := FundsUserSetup."Imprest Template";
                            JBatch := FundsUserSetup."Imprest Batch";
                            FundsManagement.PostImprest(Rec, JTemplate, JBatch, FALSE);
                            COMMIT;
                            ImprestHeader.RESET;
                            ImprestHeader.SETRANGE("No.", "DocNo.");
                            IF ImprestHeader.FINDFIRST THEN BEGIN
                                REPORT.RUNMODAL(REPORT::"Imprest Voucher", TRUE, FALSE, ImprestHeader);
                            END;
                        END ELSE BEGIN
                            ERROR(UserAccountNotSetup, USERID);
                        END;
                    end;
                }
                action("Print Imprest")
                {
                    Caption = 'Print Imprest';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ImprestHeader.RESET;
                        ImprestHeader.SETRANGE(ImprestHeader."No.", Rec."No.");
                        IF ImprestHeader.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Imprest Voucher", TRUE, FALSE, ImprestHeader);
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
                        IncomingDocumentAttachment.NewAttachmentFromImprestDocument(Rec);
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
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE("User ID", USERID);
        ImprestHeader.SETRANGE(ImprestHeader.Status, ImprestHeader.Status::Open);
        IF ImprestHeader.FINDFIRST THEN BEGIN
            ERROR(Txt_002);
        END;
    end;

    trigger OnOpenPage()
    begin
        Rec.FILTERGROUP(1);
        Rec.SETRANGE("User ID", USERID);
        Rec.FILTERGROUP(2);
    end;

    var
        UserAccountNotSetup: Label 'User Account %1 is not Setup for Imprest Posting, Contact the System Administrator';
        FundsManagement: Codeunit 50045;
        UserSetup: Record 91;
        FundsUserSetup: Record 50029;
        FundsApprovalManager: Codeunit 50003;
        JTemplate: Code[10];
        JBatch: Code[10];
        "DocNo.": Code[20];
        ImprestHeader: Record 50008;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        Txt_002: Label 'There is an open imprest document under your name, use it before you create a new one';
        TEXT_003: Label 'Document Successfully Re-opened';

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


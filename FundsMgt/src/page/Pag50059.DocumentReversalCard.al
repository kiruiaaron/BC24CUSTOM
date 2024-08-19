page 50059 "Document Reversal Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 50034;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Doc. Posting date"; Rec."Doc. Posting date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Reversal Posted"; Rec."Reversal Posted")
                {
                    ApplicationArea = All;
                }
                field("Reversal Posted By"; Rec."Reversal Posted By")
                {
                    ApplicationArea = All;
                }
                field("Reversal Posting Date"; Rec."Reversal Posting Date")
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50060)
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
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
                    IF FundsUserSetup.GET(USERID) THEN BEGIN
                        FundsUserSetup.TESTFIELD("Reversal Template");
                        FundsUserSetup.TESTFIELD("Reversal Batch");
                        JTemplate := FundsUserSetup."Reversal Template";
                        JBatch := FundsUserSetup."Reversal Batch";
                        FundsManagement.PostDocumentReversal(Rec, JTemplate, JBatch, TRUE);
                    END ELSE BEGIN
                        ERROR(UserAccountNotSetup, USERID);
                    END;
                end;
            }
            action("Post Reversal")
            {
                Caption = 'Post Reversal';
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //TESTFIELD(Status,Status::Approved);

                    IF FundsUserSetup.GET(USERID) THEN BEGIN
                        FundsUserSetup.TESTFIELD("Reversal Template");
                        FundsUserSetup.TESTFIELD("Reversal Batch");
                        JTemplate := FundsUserSetup."Reversal Template";
                        JBatch := FundsUserSetup."Reversal Batch";
                        FundsManagement.PostDocumentReversal(Rec, JTemplate, JBatch, FALSE);
                    END ELSE BEGIN
                        ERROR(UserAccountNotSetup, USERID);
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
                                        RunPageLink = "Document No." = FIELD("No."),
                                                      "Document Type" = FILTER(Payment); */
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
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        Rec.TESTFIELD("Document No.");
                        Rec.TESTFIELD("Document Type");

                        IF ApprovalsMgmtExt.CheckDocumentReversalApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendDocumentReversalHeaderForApproval(Rec);

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
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                    begin
                        Rec.TESTFIELD(Status, Rec.Status::"Pending Approval");
                        ApprovalsMgmtExt.OnCancelDocumentReversalHeaderApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);

                        //CanCancelApprovalForRecord OR CanCancelApprovalForFlow
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
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
        FundsManagement: Codeunit 50045;
        UserSetup: Record 91;
        FundsUserSetup: Record 50029;
        JTemplate: Code[30];
        JBatch: Code[30];
        UserAccountNotSetup: Label 'User Account %1 is not Setup for Receipt Posting, Contact the System Administrator';
}


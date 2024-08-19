page 50031 "Posted Imprest Surrender Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = 50010;
    SourceTableView = WHERE(Posted = CONST(True));

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
                field("Imprest No."; Rec."Imprest No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Imprest Date"; Rec."Imprest Date")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Caption = 'Account No';
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Actual Spent"; Rec."Actual Spent")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Difference; Rec.Difference)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
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
            part(sbpg; 50029)
            {
                Editable = false;
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
            action("Print Imprest Surrender")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ImprestSurrenderHeader.RESET;
                    ImprestSurrenderHeader.SETRANGE("No.", Rec."No.");
                    IF ImprestSurrenderHeader.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(REPORT::"Imprest Surrender Voucher", TRUE, FALSE, ImprestSurrenderHeader);
                    END;
                end;
            }
            action("Reverse Surrender")
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
                    EmployeeLedgerEntry: Record 5222;
                begin
                    CLEAR(ReversalEntry);
                    IF Rec.Reversed THEN
                        ReversalEntry.AlreadyReversedDocument(PaymentTxt, Rec."No.");

                    //Get transaction no.
                    EmployeeLedgerEntry.RESET;
                    EmployeeLedgerEntry.SETRANGE(EmployeeLedgerEntry."Document No.", Rec."No.");
                    EmployeeLedgerEntry.SETRANGE(EmployeeLedgerEntry.Reversed, FALSE);
                    IF EmployeeLedgerEntry.FINDFIRST THEN BEGIN
                        ReversalEntry.ReverseTransaction(EmployeeLedgerEntry."Transaction No.");
                    END;

                    COMMIT;

                    //Update the document
                    EmployeeLedgerEntry.RESET;
                    EmployeeLedgerEntry.SETRANGE(EmployeeLedgerEntry."Document No.", Rec."No.");
                    EmployeeLedgerEntry.SETRANGE(EmployeeLedgerEntry.Reversed, TRUE);
                    IF EmployeeLedgerEntry.FINDLAST THEN BEGIN
                        ImprestHeader.RESET;
                        ImprestHeader.SETRANGE("No.", Rec."Imprest No.");
                        IF ImprestHeader.FINDFIRST THEN BEGIN
                            ImprestHeader."Surrender status" := ImprestHeader."Surrender status"::"Not Surrendered";
                            ImprestHeader.Surrendered := FALSE;
                            ImprestHeader.MODIFY;
                        END;



                        Rec.Status := Rec.Status::Reversed;
                        Rec.Reversed := TRUE;
                        Rec."Reversal Date" := TODAY;
                        Rec."Reversal Time" := TIME;
                        Rec."Reversed By" := USERID;
                        Rec.MODIFY;
                    END;
                    MESSAGE('Surrender reversed successfully');
                end;
            }
            action("Employee Ledger entrires")
            {
                Image = Addresses;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Employee Ledger Entries";
                RunPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            group(IncomingDocument)
            {
                Caption = 'Incoming Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    ApplicationArea = Suite;
                    Caption = 'View Incoming Document';
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
                        IncomingDocumentAttachment.NewAttachmentFromImprestSurrenderDocument(Rec);
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
            }
        }
    }

    var
        UserAccountNotSetup: Label 'User Account %1 is not Setup for Imprest Surrender Posting, Contact the System Administrator';
        ImprestSurrenderHeader: Record 50010;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        PaymentTxt: Label 'Surrender';
        ImprestSurrenderLine: Record 50011;
        ImprestHeader: Record 50008;
}


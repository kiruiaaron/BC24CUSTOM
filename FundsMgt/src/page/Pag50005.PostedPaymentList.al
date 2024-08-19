page 50005 "Posted Payment List"
{
    CardPageID = "Posted Payment Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Lists;
    ApplicationArea = all;
    PageType = List;

    SourceTable = 50002;
    SourceTableView = SORTING("No.")
                      ORDER(Descending)
                      WHERE("Payment Type" = CONST("Cheque Payment"),
                            Posted = CONST(true));

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
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the transaction external reference number, e.g. cheque number';
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ToolTip = 'Specifies the vendor or employee being paid';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
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
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
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
                //TToolTip = 'Incoming Documents Attach FactBox';
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
            action(Approvals)
            {
                ApplicationArea = All;
            }
            action("Print Payment")
            {
                Caption = 'Print Payment';
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
                    Rec.TESTFIELD(Status, Rec.Status::Posted);
                    Rec.TESTFIELD("Cheque Type", Rec."Cheque Type"::"Computer Cheque");

                    PaymentHeader.RESET;
                    PaymentHeader.SETRANGE(PaymentHeader."No.", Rec."No.");
                    IF PaymentHeader.FINDFIRST THEN
                        REPORT.RUN(REPORT::"Cheque Print", TRUE, TRUE, PaymentHeader);
                end;
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
                        BankAccountLedgerEntry: Record 271;
                        ReversalEntry: Record 179;
                        "TransactionNo.": Integer;
                        "G/LEntry": Record 17;
                        CustLedgerEntry: Record 21;
                        VendorLedgerEntry: Record 25;
                        PaymentTxt: Label 'Payment';
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
        Rec."Payment Type" := Rec."Payment Type"::"Cheque Payment";

    end;

    var
        PaymentHeader: Record 50002;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND (Rec."No." <> '');
    end;
}


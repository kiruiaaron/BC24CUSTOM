page 50006 "Posted Payment Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = 50002;
    SourceTableView = WHERE("Payment Type" = CONST("Cheque Payment"),
                            Posted = CONST(True));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Cheque Type"; Rec."Cheque Type")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Payee Type"; Rec."Payee Type")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Payee No."; Rec."Payee No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Payee Bank Account Name"; Rec."Payee Bank Account Name")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
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
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
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
            part(PaymentLine; 50004)
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
        area(processing)
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
                            PaymentLine.RESET;
                            PaymentLine.SETRANGE("Document No.", Rec."No.");
                            IF PaymentLine.FINDFIRST THEN
                                REPEAT
                                    IF (PaymentLine."Payee Type" = PaymentLine."Payee Type"::Imprest) OR (PaymentLine."Payee Type" = PaymentLine."Payee Type"::"Petty Cash Request") THEN BEGIN
                                        ImprestHeader.RESET;
                                        ImprestHeader.SETRANGE("No.", PaymentLine."Payee No.");
                                        IF ImprestHeader.FINDFIRST THEN BEGIN
                                            ImprestHeader.Status := ImprestHeader.Status::Approved;
                                            ImprestHeader.Posted := FALSE;
                                            ImprestHeader.Reversed := TRUE;
                                            ImprestHeader."Reversal Date" := TODAY;
                                            ImprestHeader."Reversal Time" := TIME;
                                            ImprestHeader."Reversed By" := USERID;
                                            ImprestHeader.MODIFY;
                                        END;

                                    END;

                                UNTIL PaymentLine.NEXT = 0;
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
        BankAccountLedgerEntry: Record 271;
        PaymentHeader: Record 50002;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        PaymentTxt: Label 'Payment';
        PaymentLine: Record 50003;
        ImprestHeader: Record 50008;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND (Rec."No." <> '');
    end;
}


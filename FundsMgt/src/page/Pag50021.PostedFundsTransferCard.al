page 50021 "Posted Funds Transfer Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = 50006;
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
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Tranfer Type"; Rec."Tranfer Type")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Transfer To"; Rec."Transfer To")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Amount To Transfer"; Rec."Amount To Transfer")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
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
            part(sbpg; 50019)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Print Funds Transfer")
            {
                Caption = 'Print Funds Transfer';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    MoneyTransferHeader.RESET;
                    MoneyTransferHeader.SETRANGE(MoneyTransferHeader."No.", Rec."No.");
                    IF MoneyTransferHeader.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(REPORT::"Funds Transfer Voucher", TRUE, FALSE, MoneyTransferHeader);
                    END;
                end;
            }
        }
    }

    var
        MoneyTransferHeader: Record 50006;
}


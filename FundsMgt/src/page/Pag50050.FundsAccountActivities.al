page 50050 "Funds Account Activities"
{
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = 50030;

    layout
    {
        area(content)
        {
            cuegroup("Accounts Payable")
            {
                Caption = 'Accounts Payable';
                field("Purchase Invoices"; Rec."Purchase Invoices")
                {
                    DrillDownPageID = "Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Posted Purchase Invoices"; Rec."Posted Purchase Invoices")
                {
                    DrillDownPageID = "Posted Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Purchase Cr. Memos"; Rec."Purchase Cr. Memos")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Posted Purchase Cr. Memos"; Rec."Posted Purchase Cr. Memos")
                {
                    DrillDownPageID = "Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
            }
            cuegroup(Payments)
            {
                Caption = 'Payments';
                field("Open Payments"; Rec."Open Payments")
                {
                    DrillDownPageID = "Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Posted Payments"; Rec."Posted Payments")
                {
                    DrillDownPageID = "Posted Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Reversed Payments"; Rec."Reversed Payments")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Open Cash Payments"; Rec."Open Cash Payments")
                {
                    DrillDownPageID = "Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Posted Cash Payments"; Rec."Posted Cash Payments")
                {
                    ApplicationArea = All;
                }
                field("Reversed Cash Payments"; Rec."Reversed Cash Payments")
                {
                    ApplicationArea = All;
                }
            }
            cuegroup("Accounts Receivable")
            {
                Caption = 'Accounts Receivable';
                field("Sales Invoices"; Rec."Sales Invoices")
                {
                    DrillDownPageID = "Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Posted Sales Invoices"; Rec."Posted Sales Invoices")
                {
                    DrillDownPageID = "Posted Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Sales Cr. Memos"; Rec."Sales Cr. Memos")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Posted Sales Cr. Memos"; Rec."Posted Sales Cr. Memos")
                {
                    DrillDownPageID = "Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
            }
            cuegroup(Receipt)
            {
                Caption = 'Receipts';
                field(Receipts; Rec.Receipts)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Cash;
                    ToolTip = 'Specifies the field name';
                }
                field("Posted Receipts"; Rec."Posted Receipts")
                {
                    ApplicationArea = All;
                }
            }
            cuegroup("Imprest and Surrenders")
            {
                Caption = 'Imprest and Surrenders';
                field(Imprests; Rec.Imprests)
                {
                    DrillDownPageID = "Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Posted Imprests"; Rec."Posted Imprests")
                {
                    DrillDownPageID = "Posted Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Reversed Imprests"; Rec."Reversed Imprests")
                {
                    ApplicationArea = All;
                }
                field("Imprest Surrenders"; Rec."Imprest Surrenders")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Posted Imprest Surrenders"; Rec."Posted Imprest Surrenders")
                {
                    DrillDownPageID = "Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Reversed Imprest Surrenders"; Rec."Reversed Imprest Surrenders")
                {
                    ApplicationArea = All;
                }
            }
            cuegroup("Funds Transfers")
            {
                Caption = 'Funds Transfers';
                field("Funds Transfer"; Rec."Funds Transfer")
                {
                    DrillDownPageID = "Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
                field("Posted Funds Transfer"; Rec."Posted Funds Transfer")
                {
                    DrillDownPageID = "Posted Payment List";
                    ToolTip = 'Specifies the payments';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    end;
}


page 50097 "Request for Quotation Vendors"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50051;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Not listed Vendor"; Rec."Not listed Vendor")
                {
                    ApplicationArea = All;
                }
                field("Vendor Email Address"; Rec."Vendor Email Address")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("View Quotes")
            {
                Image = Quote;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CLEAR(PurchaseQuote);
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("Request for Quotation Code", Rec."RFQ Document No.");
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                    PurchaseHeader.SETRANGE("Buy-from Vendor No.", Rec."Vendor No.");
                    PurchaseQuote.SETTABLEVIEW(PurchaseHeader);
                    PurchaseQuote.RUN;
                end;
            }
        }
    }

    var
        Mail: Record 50051;
        PurchaseHeader: Record 38;
        PurchaseQuote: Page 49;
}


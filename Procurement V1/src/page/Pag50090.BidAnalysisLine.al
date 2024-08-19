page 50090 "Bid Analysis Line"
{
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = 50054;

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
                field("Purchase Quote No."; Rec."Purchase Quote No.")
                {
                    ApplicationArea = All;
                }
                field("Purchase Quote Date"; Rec."Purchase Quote Date")
                {
                    ApplicationArea = All;
                }
                field("Quote Amount Incl VAT"; Rec."Quote Amount Incl VAT")
                {
                    ApplicationArea = All;
                }
                field("Meets Specifications"; Rec."Meets Specifications")
                {
                    ApplicationArea = All;
                }
                field("Delivery/Lead Time"; Rec."Delivery/Lead Time")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    ApplicationArea = All;
                }
                field(Award; Rec.Award)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


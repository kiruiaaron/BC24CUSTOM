page 50084 "Purchase Requisition Line"
{
    PageType = ListPart;
    SourceTable = 50047;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ToolTip = 'Specifies the requisition type(Service,Item or Fixed Asset) selection for the purchase requisition line';
                    ApplicationArea = All;
                }
                field("Requisition Code"; Rec."Requisition Code")
                {
                    ToolTip = 'Specifies the requisition code lookup for the purchase requisition line, based on the requisition type selection';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description of the item/service/fixed asset being requisitioned';
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the location for the item on the purchase requisition line';
                    ApplicationArea = All;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the quantity of item/service/fixed asset to be purchased';
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Market Price"; Rec."Market Price")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost(LCY)"; Rec."Unit Cost(LCY)")
                {
                    ApplicationArea = All;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                }
                field("Total Cost(LCY)"; Rec."Total Cost(LCY)")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 3, which is one of six shortcut dimension codes that you set up in the General Ledger Setup window.';
                    ApplicationArea = All;
                }
                field(Budget; Rec.Budget)
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
            action("Specification Attributes")
            {

                RunObject = Page 50101;
                RunPageLink = "RFQ No." = FIELD("Document No."),
                              Type = FIELD("Type (Attributes)"),
                              Item = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }
}


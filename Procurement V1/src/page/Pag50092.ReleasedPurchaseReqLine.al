page 50092 "Released Purchase Req. Line"
{
    Caption = 'Released Purchase Requisition Line';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50047;
    SourceTableView = SORTING("Document No.")
                      ORDER(Ascending)
                      WHERE(Status = CONST(Released),
                            Closed = CONST(False),
                            "Request for Quotation No." = CONST(''),
                            "Purchase Order No." = CONST(''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the purchase requisition unique number';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
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
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the purchase type, G/L Account/Item/Fixed Asset/Charge(Item)';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
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
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the purchase unit of measure for the item selected on the purchase requisition line';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ShowMandatory = true;
                    ToolTip = 'Specifies the quantity of item/service/fixed asset to be purchased';
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                    ToolTip = 'Specifies the cost of one unit of the item/service/fixed asset';
                    ApplicationArea = All;
                }
                field("Unit Cost(LCY)"; Rec."Unit Cost(LCY)")
                {
                    Caption = 'Unit Cost(LCY)';
                    ToolTip = 'Specifies the cost of one unit of the item/service/fixed asset in the company''s local currency';
                    ApplicationArea = All;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ToolTip = 'Specifies the total cost of all the quantity of the item/service/fixed asset, i.e. unit cost * quantity';
                    ApplicationArea = All;
                }
                field("Total Cost(LCY)"; Rec."Total Cost(LCY)")
                {
                    ToolTip = 'Specifies the total cost of all the quantity of the item/service/fixed asset in the company''s local currency, i.e. unit cost(LCY)* quantity';
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
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 4, which is one of six shortcut dimension codes that you set up in the General Ledger Setup window.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 5, which is one of six shortcut dimension codes that you set up in the General Ledger Setup window.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 6, which is one of six shortcut dimension codes that you set up in the General Ledger Setup window.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the purchase requisition line approval status, i.e. Open/Pending Approval/Released/Rejected/Closed';
                    ApplicationArea = All;
                }
                field("Request for Quotation No."; Rec."Request for Quotation No.")
                {
                    ApplicationArea = All;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                }
                field("Imprest Code"; Rec."Imprest Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    procedure SetSelection(var PurchaseRequisitionLine: Record 50047)
    begin
        CurrPage.SETSELECTIONFILTER(PurchaseRequisitionLine);
    end;
}


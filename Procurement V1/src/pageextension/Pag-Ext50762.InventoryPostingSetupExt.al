namespace ProcurementV.ProcurementV;

using Microsoft.Inventory.Setup;

pageextension 50762 "Inventory Posting Setup Ext" extends "Inventory Setup"
{
    layout
    {
        addlast(Numbering)
        {
            field("Stores Requisition Nos."; Rec."Stores Requisition Nos.")
            {
                ApplicationArea = All;
            }


        }
        addlast(General)
        {
            field("Item Journal Template"; Rec."Item Journal Template")
            {
                ApplicationArea = All;
            }
            field("Item Journal Batch"; Rec."Item Journal Batch")
            {
                ApplicationArea = All;
            }


        }
    }
}

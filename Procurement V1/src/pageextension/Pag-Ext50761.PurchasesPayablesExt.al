namespace ProcurementV.ProcurementV;

using Microsoft.Purchases.Setup;

pageextension 50761 "Purchases & Payables Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Use Procurement Plan"; Rec."Use Procurement Plan")
            {
                ApplicationArea = All;
            }
            field("User to replenish Stock"; Rec."User to replenish Stock")
            {
                ApplicationArea = All;
            }

        }
        addlast("Number Series")
        {
            field("Purchase Requisition Nos."; Rec."Purchase Requisition Nos.")
            {
                ApplicationArea = All;
            }
            field("Procurement Plan Nos"; Rec."Procurement Plan Nos")
            {
                ApplicationArea = All;
            }
            field("Projects Nos"; Rec."Projects Nos")
            {
                ApplicationArea = All;
            }
            field("Request for Quotation Nos."; Rec."Request for Quotation Nos.")
            {
                ApplicationArea = All;
            }

            field("Tender Doc No."; Rec."Tender Doc No.")
            {
                ApplicationArea = All;
            }
            field("Tender Evaluation No."; Rec."Tender Evaluation No.")
            {
                ApplicationArea = All;
            }










        }
    }
}

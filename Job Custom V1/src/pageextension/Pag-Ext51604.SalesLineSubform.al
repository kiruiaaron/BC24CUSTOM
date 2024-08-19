pageextension 51604 "Sales Line Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Purpose; Rec.Purpose)
            {
                ApplicationArea = All;
            }

        }
        addafter("Location Code")
        {
            field("No. of Days"; Rec."No. of Days")
            {
                ApplicationArea = All;
            }

        }
    }
}

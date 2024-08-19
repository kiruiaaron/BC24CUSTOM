pageextension 51602 "Sales Quote Subform Ext" extends "Sales Quote Subform"
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
    }
}

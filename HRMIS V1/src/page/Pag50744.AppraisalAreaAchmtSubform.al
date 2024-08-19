page 50744 "Appraisal Area Achmt Subform"
{
    Caption = 'Appraisal Area Achievement Subform';
    PageType = ListPart;
    SourceTable = 50320;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Area of Achievement"; Rec."Area of Achievement")
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


page 50745 "Area of Devt Subform"
{
    PageType = ListPart;
    SourceTable = 50321;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Area of Development"; Rec."Area of Development")
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


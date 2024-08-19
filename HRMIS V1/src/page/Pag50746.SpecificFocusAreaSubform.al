page 50746 "Specific Focus Area Subform"
{
    PageType = ListPart;
    SourceTable = 50322;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Specific Focus Area"; Rec."Specific Focus Area")
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


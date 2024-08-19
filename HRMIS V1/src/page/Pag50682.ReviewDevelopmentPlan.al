page 50682 "Review Development Plan"
{
    PageType = ListPart;
    SourceTable = 50331;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Development Plan"; Rec."Development Plan")
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


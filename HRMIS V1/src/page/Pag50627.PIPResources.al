page 50627 "PIP Resources"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50294;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Resource Name"; Rec."Resource Name")
                {
                    ApplicationArea = All;
                }
                field("Description Of Resource"; Rec."Description Of Resource")
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


page 51625 Regions
{
    PageType = List;
    SourceTable = Regions;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Region Code"; Rec."Region Code")
                {
                }
                field("Region Name"; Rec."Region Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}


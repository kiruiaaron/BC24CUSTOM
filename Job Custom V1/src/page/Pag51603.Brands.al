page 51603 Brands
{
    PageType = List;
    SourceTable = Brands;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Brand Code"; Rec."Brand Code")
                {
                }
                field("Brand Name"; Rec."Brand Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}


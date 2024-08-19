page 51614 Venues
{
    PageType = List;
    SourceTable = Venues;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Venue; Rec.Venue)
                {
                }
            }
        }
    }

    actions
    {
    }
}


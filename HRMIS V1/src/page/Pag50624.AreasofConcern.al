page 50624 "Areas of Concern"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50291;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Areas of Concern"; Rec."Areas of Concern")
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


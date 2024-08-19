page 50635 "My Plan"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50300;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line no"; Rec."Line no")
                {
                    ApplicationArea = All;
                }
                field(Goals; Rec.Goals)
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


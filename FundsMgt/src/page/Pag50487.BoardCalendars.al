page 50487 "Board Calendars"
{
    CardPageID = "Board Calendar";
    Editable = false;
    PageType = List;

    SourceTable = 50272;
    SourceTableView = WHERE(Type = CONST(Board));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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


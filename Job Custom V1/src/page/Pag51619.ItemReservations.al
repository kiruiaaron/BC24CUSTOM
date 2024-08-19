page 51619 "Item Reservations"
{
    CardPageID = "Item Reservation Card";
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Item Reservations";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    Editable = false;
                }
                field(Resource; Rec.Resource)
                {
                    Editable = false;
                }
                field("Resource Name"; Rec."Resource Name")
                {
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                }
                field("Start Time"; Rec."Start Time")
                {
                }
                field("End Time"; Rec."End Time")
                {
                }
                field(Project; Rec.Project)
                {
                    Editable = false;
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = false;
                }
                field("Task Line"; Rec."Task Line")
                {
                    Editable = false;
                }
                field("Task name"; Rec."Task name")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Bulk Reservation")
            {
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;
                //  RunObject = Report Report57020;
            }
        }
    }
}


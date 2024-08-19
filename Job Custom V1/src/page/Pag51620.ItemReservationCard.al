page 51620 "Item Reservation Card"
{
    PageType = Card;
    SourceTable = "Item Reservations";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Resource; Rec.Resource)
                {
                }
                field("Resource Name"; Rec."Resource Name")
                {
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
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Task Line"; Rec."Task Line")
                {
                }
                field("Task name"; Rec."Task name")
                {
                }
            }
        }
    }

    actions
    {
    }
}


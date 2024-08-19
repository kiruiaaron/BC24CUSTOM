page 50483 "Calendar Tasks"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50273;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Calendar code"; Rec."Calendar code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Line No"; Rec."Line No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Activity/Task"; Rec."Activity/Task")
                {
                    ApplicationArea = All;
                }
                field("Main Issue/Agenda"; Rec."Main Issue/Agenda")
                {
                    ApplicationArea = All;
                }
                field("Expected Outcome"; Rec."Expected Outcome")
                {
                    ApplicationArea = All;
                }
                field(Venue; Rec.Venue)
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
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


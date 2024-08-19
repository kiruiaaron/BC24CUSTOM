page 50499 "Board Calendar Tasks"
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
                field(Quarter; Rec.Quarter)
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Expected Outcome"; Rec."Expected Outcome")
                {
                    Caption = 'Proposed Month';
                    ApplicationArea = All;
                }
                field("Main Issue/Agenda"; Rec."Main Issue/Agenda")
                {
                    Caption = 'Type of Meeting';
                    ApplicationArea = All;
                }
                field("Board Committee"; Rec."Board Committee")
                {
                    Caption = 'Members';
                    ApplicationArea = All;
                }
                field("Activity/Task"; Rec."Activity/Task")
                {
                    Caption = 'Agenda for Inclusion & Output';
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(Venue; Rec.Venue)
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


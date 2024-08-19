page 50207 "Leave Planner Line"
{
    PageType = ListPart;
    SourceTable = 50126;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies start Date.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies No. of days.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the End Date.';
                    ApplicationArea = All;
                }
                field("Substitute No."; Rec."Substitute No.")
                {
                    ToolTip = 'Specifies subsititute Employee No.';
                    ApplicationArea = All;
                }
                field("Substitute Name"; Rec."Substitute Name")
                {
                    ToolTip = 'Specifies the Substitute Employee Name.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


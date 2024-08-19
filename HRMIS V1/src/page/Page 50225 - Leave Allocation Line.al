page 50225 "Leave Allocation Line"
{
    PageType = ListPart;
    SourceTable = 50131;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the Employee Name.';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the entry Type.';
                    ApplicationArea = All;
                }
                field("Days Allocated"; Rec."Days Allocated")
                {
                    ToolTip = 'Specifies the Days allocated.';
                    ApplicationArea = All;
                }
                field("Days Approved"; Rec."Days Approved")
                {
                    ToolTip = 'Specifies the Days approved.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


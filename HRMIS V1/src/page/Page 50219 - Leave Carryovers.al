page 50219 "Leave Carryovers"
{
    CardPageID = "Leave Carryover Card";
    DeleteAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50129;
    SourceTableView = WHERE(Status = FILTER(<> Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting Date.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the Employee Number.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the Employee Name.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Species the Leave Type.';
                    ApplicationArea = All;
                }
                field("Days to CarryOver"; Rec."Days to CarryOver")
                {
                    ApplicationArea = All;
                }
                field("Reasons For Difference in Days"; Rec."Reasons For Difference in Days")
                {
                    ApplicationArea = All;
                }
                field("Leave Period"; Rec."Leave Period")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the  User ID that craeted the document.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}


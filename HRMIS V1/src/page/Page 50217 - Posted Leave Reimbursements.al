page 50217 "Posted Leave Reimbursements"
{
    CardPageID = "Leave Reimbursment Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50128;
    SourceTableView = WHERE(Status = CONST(Posted));

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
                    ToolTip = 'Specifies the Posting Date.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the Employee No.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the Employee Name.';
                    ApplicationArea = All;
                }
                field("Leave Application No."; Rec."Leave Application No.")
                {
                    ToolTip = 'Specifies the Leave application Number.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the Leave Type.';
                    ApplicationArea = All;
                }
                field("Leave Period"; Rec."Leave Period")
                {
                    ToolTip = 'Specifies the Leave Period.';
                    ApplicationArea = All;
                }
                field("Leave Start Date"; Rec."Leave Start Date")
                {
                    ToolTip = 'Specifies the Leave start Date.';
                    ApplicationArea = All;
                }
                field("Leave Return Date"; Rec."Leave Return Date")
                {
                    ToolTip = 'Specifies the Leave Retun Date.';
                    ApplicationArea = All;
                }
                field("Actual Return Date"; Rec."Actual Return Date")
                {
                    ToolTip = 'Specifies the actual return date.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 1 Code.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 2 Code.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the Leave status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies User ID that created the document';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


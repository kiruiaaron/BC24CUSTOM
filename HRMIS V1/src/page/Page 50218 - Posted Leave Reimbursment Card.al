page 50218 "Posted Leave Reimbursment Card"
{
    DeleteAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = 50128;
    SourceTableView = WHERE(Status = CONST(Posted));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the document date.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the Posting Date.';
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
                field("Leave Days Applied"; Rec."Leave Days Applied")
                {
                    ToolTip = 'Specifies the Leave Days Applied.';
                    ApplicationArea = All;
                }
                field("Leave Days Approved"; Rec."Leave Days Approved")
                {
                    ToolTip = 'Specifies the Leave Period.';
                    ApplicationArea = All;
                }
                field("Leave End Date"; Rec."Leave End Date")
                {
                    ToolTip = 'Specifies the Leave End Date.';
                    ApplicationArea = All;
                }
                field("Leave Return Date"; Rec."Leave Return Date")
                {
                    ToolTip = 'Specifies the Leave Return Date.';
                    ApplicationArea = All;
                }
                field("Substitute No."; Rec."Substitute No.")
                {
                    ToolTip = 'Specifies the substitute Employee No.';
                    ApplicationArea = All;
                }
                field("Substitute Name"; Rec."Substitute Name")
                {
                    ToolTip = 'Specifies the substitute Employee Name.';
                    ApplicationArea = All;
                }
                field("Reason for Leave"; Rec."Reason for Leave")
                {
                    ToolTip = 'Specifies the reason for Leave.';
                    ApplicationArea = All;
                }
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ToolTip = 'Specifies the Leave Balance.';
                    ApplicationArea = All;
                }
                field("Actual Return Date"; Rec."Actual Return Date")
                {
                    ToolTip = 'Specifies the actual return date.';
                    ApplicationArea = All;
                }
                field("Days to Reimburse"; Rec."Days to Reimburse")
                {
                    ToolTip = 'Specifies the days to reimburse.';
                    ApplicationArea = All;
                }
                field("Reason for Reimbursement"; Rec."Reason for Reimbursement")
                {
                    ToolTip = 'Specifies the reason for Reimbursement.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 1 Code.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 2 code.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user ID that created the document.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


page 50222 "Posted Leave Carryover Card"
{
    DeleteAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = 50129;
    SourceTableView = WHERE(Status = CONST(Posted));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = All;
                }
                field("Maximum Carryover Days"; Rec."Maximum Carryover Days")
                {
                    ApplicationArea = All;
                }
                field("From Leave Period"; Rec."From Leave Period")
                {
                    ApplicationArea = All;
                }
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ApplicationArea = All;
                }
                field("To Leave Period"; Rec."To Leave Period")
                {
                    ApplicationArea = All;
                }
                field("Days Applied"; Rec."Days Applied")
                {
                    ApplicationArea = All;
                }
                field("Days Approved"; Rec."Days Approved")
                {
                    ApplicationArea = All;
                }
                field("Reason for Carryover"; Rec."Reason for Carryover")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
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


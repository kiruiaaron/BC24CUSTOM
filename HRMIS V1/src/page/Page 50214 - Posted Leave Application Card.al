page 50214 "Posted Leave Application Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = 50127;
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
                    ToolTip = 'Specifies the Document Date.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting Date.';
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
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ToolTip = 'Specifies the Leave Balance.';
                    ApplicationArea = All;
                }
                field("Leave Start Date"; Rec."Leave Start Date")
                {
                    ToolTip = 'Specifies the Leave start Date.';
                    ApplicationArea = All;
                }
                field("Days Applied"; Rec."Days Applied")
                {
                    ToolTip = 'Specifies the Days Applied.';
                    ApplicationArea = All;
                }
                field("Days Approved"; Rec."Days Approved")
                {
                    ToolTip = 'Specifies the Days approved.';
                    ApplicationArea = All;
                }
                field("Leave End Date"; Rec."Leave End Date")
                {
                    ToolTip = 'Specifies the Leave End Date.';
                    ApplicationArea = All;
                }
                field("Leave Return Date"; Rec."Leave Return Date")
                {
                    ToolTip = 'Specifies the Leave return date.';
                    ApplicationArea = All;
                }
                field("Substitute No."; Rec."Substitute No.")
                {
                    ToolTip = 'Specifies the Substitute Employee Number.';
                    ApplicationArea = All;
                }
                field("Substitute Name"; Rec."Substitute Name")
                {
                    ToolTip = 'Specifies the Employee Name.';
                    ApplicationArea = All;
                }
                field("Reason for Leave"; Rec."Reason for Leave")
                {
                    ToolTip = 'Specifies the reason for Leave.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 1 Code.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the User ID that created the document.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Print Leave Application")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*HRLeaveApplication.RESET;
                    HRLeaveApplication.SETRANGE(HRLeaveApplication."No.","No.");
                    IF HRLeaveApplication.FINDFIRST THEN BEGIN
                      REPORT.RUNMODAL(REPORT::"HR Leave Application Report",TRUE,FALSE,HRLeaveApplication);
                    END;*/

                end;
            }
        }
    }

    var
        OpenLeaveApplicationExist: Label 'Open Leave Application Exists for User ID:%1';
        ReOpenLeaveApplication: Label 'Reopen Leave Application No.%1, the Status will be changed to Open. Continue?';
        ConfirmPostLeaveApplication: Label 'Post Leave Application. Identification Fields and Values, "Document No.":%1,  Leave Type:%2, Leave Period:%3. Continue?';
        LeavePostedSuccessfully: Label 'Leave Application No. %1, Posted Successfully.';
        HRLeaveApplication: Record 50127;
}


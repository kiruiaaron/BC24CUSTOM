page 50213 "Posted Leave Applications"
{
    CardPageID = "Posted Leave Application Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50127;
    SourceTableView = WHERE(Status = CONST(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the No.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the  Employee No.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the  Employee Name.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the Leave Type.';
                    ApplicationArea = All;
                }
                field("Leave Period"; Rec."Leave Period")
                {
                    ToolTip = 'Specifies the Leave period.';
                    ApplicationArea = All;
                }
                field("Leave Start Date"; Rec."Leave Start Date")
                {
                    ToolTip = 'Specifies the Leave start date.';
                    ApplicationArea = All;
                }
                field("Days Applied"; Rec."Days Applied")
                {
                    ToolTip = 'Specifies the Days applied.';
                    ApplicationArea = All;
                }
                field("Days Approved"; Rec."Days Approved")
                {
                    ToolTip = 'Specifies the Days approved.';
                    ApplicationArea = All;
                }
                field("Leave End Date"; Rec."Leave End Date")
                {
                    ToolTip = 'Specifies the Leave End date.';
                    ApplicationArea = All;
                }
                field("Leave Return Date"; Rec."Leave Return Date")
                {
                    ToolTip = 'Specifies the Leave return date.';
                    ApplicationArea = All;
                }
                field("Substitute No."; Rec."Substitute No.")
                {
                    ToolTip = 'Specifies the Employee substitute No.';
                    ApplicationArea = All;
                }
                field("Substitute Name"; Rec."Substitute Name")
                {
                    ToolTip = 'Specifies the  Employee substitute Name.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status.';
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
                ToolTip = 'Specifies the process printng a leave application.';
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
        HRLeaveManagement: Codeunit 50036;
        LeavePostedSuccessfully: Label 'Leave Application No. %1, Posted Successfully ';
        LeaveApplication: Record 50127;
        OpenLeaveApplicationExist: Label 'Open Leave Application Exists for User ID:%1';
        HRLeaveApplication: Record 50127;
}


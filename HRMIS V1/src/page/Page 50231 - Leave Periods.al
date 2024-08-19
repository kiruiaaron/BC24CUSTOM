page 50231 "Leave Periods"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50135;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the Name.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the start Date.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the End date.';
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Closed';
                    ApplicationArea = All;
                }
                field("Enable Leave Planning"; Rec."Enable Leave Planning")
                {
                    ToolTip = 'Specifies Enabling of Leave planning';
                    ApplicationArea = All;
                }
                field("Leave Planning End Date"; Rec."Leave Planning End Date")
                {
                    ToolTip = 'Specifies the Leave Planning End Date.';
                    ApplicationArea = All;
                }
                field("Enable Leave Application"; Rec."Enable Leave Application")
                {
                    ToolTip = 'Specifies the enabling of Leave application.';
                    ApplicationArea = All;
                }
                field("Enable Leave Carryover"; Rec."Enable Leave Carryover")
                {
                    ToolTip = 'Specifies the Enabling of Leave carryover.';
                    ApplicationArea = All;
                }
                field("Leave Carryover End Date"; Rec."Leave Carryover End Date")
                {
                    ToolTip = 'Specifies the Enabling of Leave carryover End Date.';
                    ApplicationArea = All;
                }
                field("Enable Leave Reimbursement"; Rec."Enable Leave Reimbursement")
                {
                    ToolTip = 'Specifies the Enabling of Leave Reimbursement.';
                    ApplicationArea = All;
                }
                field("Leave Reimbursement End Date"; Rec."Leave Reimbursement End Date")
                {
                    ToolTip = 'Specifies the Enabling of Leave Reimbursment End Date.';
                    ApplicationArea = All;
                }
                field("Leave Year"; Rec."Leave Year")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Close Leave Period")
            {
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    LeavePeriods.RESET;
                    //LeavePeriods.SETRANGE(LeavePeriods.Closed,FALSE);
                    IF LeavePeriods.FINDLAST THEN BEGIN
                        Rec.Closed := TRUE;
                        IF Rec.MODIFY THEN BEGIN
                            HRLeaveManagement.CarryOverLeaveDays(Rec.Code);
                        END;
                    END;
                end;
            }
        }
    }

    var
        LeavePeriods: Record 50135;
        HRLeaveManagement: Codeunit 50036;
        Text001: Label 'Are you sure you want to Close the Leave Period? Please note the Leave balances from the current period  will be transfered to the next Financial Period.';
}


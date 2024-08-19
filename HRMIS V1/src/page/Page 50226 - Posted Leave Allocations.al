page 50226 "Posted Leave Allocations"
{
    CardPageID = "Posted Leave Allocation Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50130;
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
                    ToolTip = 'Specifies the posting Date.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the Leave Type.';
                    ApplicationArea = All;
                }
                field("Leave Period"; Rec."Leave Period")
                {
                    ToolTip = 'Species the Leave period.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Species the Global Dimension 1 Code.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Species the status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Species the User ID that created the document.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Auto Generate Allocation Lines")
            {
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Auto Generate Leave Allocation Lines based on Employee Default Annual Leave Type';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Leave Type");
                    Rec.TESTFIELD("Leave Period");
                    Rec.TESTFIELD(Description);
                    IF HRLeaveManagement.AutoFillLeaveAllocationLines(Rec."No.") THEN BEGIN
                        MESSAGE(AutoGenerateAllocationLineSuccessful);
                    END;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF HRLeaveManagement.CheckOpenLeaveAllocationExists(USERID) THEN
            ERROR(OpenLeaveAllocationExist, USERID);
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        HRLeaveManagement: Codeunit 50036;
        AutoGenerateAllocationLineSuccessful: Label 'Leave Allocation Lines Generated Successully';
        OpenLeaveAllocationExist: Label 'Open Leave Allocation Exists for User ID:%1';
}


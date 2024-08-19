page 51156 "Payroll Posting Setup"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 51157;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("Posting Group"; Rec."Posting Group")
                {
                    Caption = 'Employee Posting Group';
                    ApplicationArea = All;
                }
                field("ED Posting Group"; Rec."ED Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Debit Account"; Rec."Debit Account")
                {
                    ApplicationArea = All;
                }
                field("Credit Account"; Rec."Credit Account")
                {
                    ApplicationArea = All;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Group)
            {
                field("Debit Account Name"; Rec."Debit Account Name")
                {
                    Editable = false;
                    Enabled = true;
                    ApplicationArea = All;
                }
                field("Credit Account Name"; Rec."Credit Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        /*"Payroll Code":='GENERAL';
        "Posting Group":='EMPLOYEE';*/

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*"Payroll Code":='GENERAL';
        "Posting Group":='EMPLOYEE';*/

    end;

    trigger OnOpenPage()
    begin
        gsSegmentPayrollData; //Mesh
    end;

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin
        /*lvSession.SETRANGE("My Session", TRUE);
        lvSession.FINDFIRST; //fire error in absence of a login
        IF lvSession."Login Type" = lvSession."Login Type"::Database THEN
          lvAllowedPayrolls.SETRANGE("User ID", USERID)
        ELSE*/

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF lvAllowedPayrolls.FINDFIRST THEN
            Rec.SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
            ERROR('You are not allowed access to this payroll dataset.');
        Rec.FILTERGROUP(100);

    end;
}


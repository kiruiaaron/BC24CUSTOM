page 51187 "Membership Numbers"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 51175;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("ED Code"; Rec."ED Code")
                {
                    ApplicationArea = All;
                }
                field("Number Name"; Rec."Number Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Membership Number"; Rec."Membership Number")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        gsSegmentPayrollData; //skm150506
        IF NOT Rec.FIND('-') THEN BEGIN
            gvEDDEF.SETFILTER(gvEDDEF."Membership No. Name", '<>%1', '');
            gvEDDEF.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
            IF gvEDDEF.FIND('-') THEN BEGIN
                REPEAT
                    Rec."ED Code" := gvEDDEF."ED Code";
                    Rec.INSERT(TRUE);
                UNTIL gvEDDEF.NEXT = 0;
            END;
        END;
    end;

    var
        gvEDDEF: Record 51158;
        gvAllowedPayrolls: Record 51182;
        gvThisCode: Code[20];

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


page 51184 "Payslip Group"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 51173;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Heading Text"; Rec."Heading Text")
                {
                    ApplicationArea = All;
                }
                field("Include Total For Group"; Rec."Include Total For Group")
                {
                    ApplicationArea = All;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ApplicationArea = All;
                }
                field("Heading Text 2"; Rec."Heading Text 2")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Group Lines")
            {
                Caption = 'Group Lines';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 51185;
                RunPageLink = "Payslip Group" = FIELD(Code),
                              "Payroll Code" = FIELD("Payroll Code"),
                              "Line Type" = FIELD("Line Type");
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        gsSegmentPayrollData; //skm150506
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


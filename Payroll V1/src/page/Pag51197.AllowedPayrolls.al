page 51197 "Allowed Payrolls"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 51182;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("Payroll Code"; Rec."Payroll Code")
                {
                    Editable = AllowEdit;
                    Enabled = AllowEdit;
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = AllowEdit;
                    Enabled = AllowEdit;
                    ApplicationArea = All;
                }
                field("Valid to Date"; Rec."Valid to Date")
                {
                    Editable = AllowEdit;
                    Enabled = AllowEdit;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        AllowEdit := FALSE;
    end;

    trigger OnOpenPage()
    begin
        gsSegmentPayrollData;
    end;

    var
        AllowEdit: Boolean;

    local procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
        UserSetup: Record 91;
    begin
        /*lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID",SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID",SESSIONID);
        lvActiveSession.FINDFIRST;
        
        
        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        //lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);//mesh
        IF lvAllowedPayrolls.FINDFIRST THEN
         Rec. SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
          ERROR('You are not allowed access to this payroll dataset.');
        FILTERGROUP(100);*/

        UserSetup.GET(USERID);
        IF UserSetup."Payroll Admin" THEN
            AllowEdit := TRUE ELSE
            AllowEdit := FALSE;

    end;
}


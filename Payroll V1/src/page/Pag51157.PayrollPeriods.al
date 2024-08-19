page 51157 "Payroll Periods"
{
    PageType = List;
    Permissions = TableData 51151 = rimd;
    SourceTable = 51151;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("Period ID"; Rec."Period ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Period Month"; Rec."Period Month")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Period Year"; Rec."Period Year")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("NHIF Period Start"; Rec."NHIF Period Start")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Hours; Rec.Hours)
                {
                    ApplicationArea = All;
                }
                field(Days; Rec.Days)
                {
                    ApplicationArea = All;
                }
                field("Tax Penalties"; Rec."Tax Penalties")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Annualize TAX"; Rec."Annualize TAX")
                {
                    ApplicationArea = All;
                }
                field("Low Interest Benefit %"; Rec."Low Interest Benefit %")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        //SKM 06/04/00 show history setting but
        IF Rec.Status <> Rec.Status::Open THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            CurrPage.EDITABLE := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //IF Rec.Status <> Rec.Status::Open THEN ERROR('You can only edit open periods');
    end;

    trigger OnOpenPage()
    var
        MyPeriod: Record 51151;
    begin
        //gsSegmentPayrollData; //skm150506
        MyPeriod.SETRANGE(MyPeriod.Status, MyPeriod.Status::Open);
        IF MyPeriod.FIND('-') THEN Rec := MyPeriod;
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


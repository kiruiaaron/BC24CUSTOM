page 51174 "Loan types"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 51178;

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Calculate Interest Benefit"; Rec."Calculate Interest Benefit")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Loan Accounts Type"; Rec."Loan Accounts Type")
                {
                    ApplicationArea = All;
                }
                field("Loan Account"; Rec."Loan Account")
                {
                    ApplicationArea = All;
                }
                field("Loan Losses Account"; Rec."Loan Losses Account")
                {
                    ApplicationArea = All;
                }
                field("Loan Interest Account Type"; Rec."Loan Interest Account Type")
                {
                    ApplicationArea = All;
                }
                field("Loan Interest Account"; Rec."Loan Interest Account")
                {
                    ApplicationArea = All;
                }
                field("Loan E/D Code"; Rec."Loan E/D Code")
                {
                    ApplicationArea = All;
                }
                field("Finance Source"; Rec."Finance Source")
                {
                    ApplicationArea = All;
                }
                field(Rounding; Rec.Rounding)
                {
                    ApplicationArea = All;
                }
                field("Rounding Precision"; Rec."Rounding Precision")
                {
                    ApplicationArea = All;
                }
            }
            field("Loan Account Name"; Rec."Loan Account Name")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Losses Account Name"; Rec."Losses Account Name")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Loan E/D Name"; Rec."Loan E/D Name")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //gsSegmentPayrollData; //skm150506
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


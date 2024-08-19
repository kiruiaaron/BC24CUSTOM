page 51185 "Payslip Lines"
{
    PageType = List;
    PopulateAllFields = true;
    SourceTable = 51174;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Payslip Group"; Rec."Payslip Group")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Line Type"; Rec."Line Type")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("E/D Code"; Rec."E/D Code")
                {
                    Visible = "E/D CodeVisible";
                    ApplicationArea = All;
                }
                field(P9; Rec.P9)
                {
                    Visible = P9Visible;
                    ApplicationArea = All;
                }
                field(Negative; Rec.Negative)
                {
                    ApplicationArea = All;
                }
                field("P9 Text"; Rec."P9 Text")
                {
                    Visible = "P9 TextVisible";
                    ApplicationArea = All;
                }
                field("E/D Description"; Rec."E/D Description")
                {
                    Editable = false;
                    Visible = "E/D DescriptionVisible";
                    ApplicationArea = All;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
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
        "E/D DescriptionVisible" := TRUE;
        "P9 TextVisible" := TRUE;
        P9Visible := TRUE;
        "E/D CodeVisible" := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec, BelowxRec);
    end;

    trigger OnOpenPage()
    begin
        PayslipGroupRec.GET(Rec."Payslip Group", Rec."Payroll Code");

        IF PayslipGroupRec."Line Type" = 0 THEN BEGIN
            "E/D CodeVisible" := TRUE;
            P9Visible := FALSE;
            "P9 TextVisible" := FALSE;
            "E/D DescriptionVisible" := TRUE;
        END ELSE BEGIN
            "E/D CodeVisible" := FALSE;
            P9Visible := TRUE;
            "P9 TextVisible" := TRUE;
            "E/D DescriptionVisible" := FALSE;
        END;
    end;

    var
        PayslipGroupRec: Record 51173;
        [InDataSet]
        "E/D CodeVisible": Boolean;
        [InDataSet]
        P9Visible: Boolean;
        [InDataSet]
        "P9 TextVisible": Boolean;
        [InDataSet]
        "E/D DescriptionVisible": Boolean;

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


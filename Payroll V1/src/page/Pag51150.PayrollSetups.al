page 51150 "Payroll Setups"
{
    // V.6.1.65_07SEP10  :Added One Field <Leave Travel Allowance ED>

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = 51165;

    layout
    {
        area(content)
        {
            group(Payroll)
            {
                Caption = 'Payroll';
                field("PAYE ED Code"; Rec."PAYE ED Code")
                {
                    ApplicationArea = All;
                }
                field("NSSF ED Code"; Rec."NSSF ED Code")
                {
                    ApplicationArea = All;
                }
                field("NSSF Company Contribution"; Rec."NSSF Company Contribution")
                {
                    ApplicationArea = All;
                }
                field("NHIF ED Code"; Rec."NHIF ED Code")
                {
                    ApplicationArea = All;
                }
                field("Pension ED Code"; Rec."Pension ED Code")
                {
                    Caption = 'Provident Employee';
                    ApplicationArea = All;
                }
                field("Pension Company Contribution"; Rec."Pension Company Contribution")
                {
                    Caption = 'Provident Employer';
                    ApplicationArea = All;
                }
                field("Interest Benefit"; Rec."Interest Benefit")
                {
                    ApplicationArea = All;
                }
                field("Tax on Lump Sum ED"; Rec."Tax on Lump Sum ED")
                {
                    ApplicationArea = All;
                }
                field("Pension Lumpsom Contribution"; Rec."Pension Lumpsom Contribution")
                {
                    ApplicationArea = All;
                }
                field("Mid Month ED Code"; Rec."Mid Month ED Code")
                {
                    ApplicationArea = All;
                }
                field("Tax Calculation"; Rec."Tax Calculation")
                {
                    ApplicationArea = All;
                }
                field("Leave Travel Allowance ED"; Rec."Leave Travel Allowance ED")
                {
                    ApplicationArea = All;
                }
                field("Leave Advance Payment ED"; Rec."Leave Advance Payment ED")
                {
                    ApplicationArea = All;
                }
                field("Personal Account Recoveries ED"; Rec."Personal Account Recoveries ED")
                {
                    ApplicationArea = All;
                }
                field("Make Personal A/C Recoveries"; Rec."Make Personal A/C Recoveries")
                {
                    ApplicationArea = All;
                }
                field("Income Brackets Rate"; Rec."Income Brackets Rate")
                {
                    ApplicationArea = All;
                }
                field("Net Pay Rounding Precision"; Rec."Net Pay Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field("Insert Special Payments"; Rec."Insert Special Payments")
                {
                    ApplicationArea = All;
                }
                field("Overdrawn ED"; Rec."Overdrawn ED")
                {
                    ApplicationArea = All;
                }
                field("Insurance Relief ED"; Rec."Insurance Relief ED")
                {
                    ApplicationArea = All;
                }
                field("Rent Recovery ED"; Rec."Rent Recovery ED")
                {
                    ApplicationArea = All;
                }
                field("Net Pay Rounding B/F"; Rec."Net Pay Rounding B/F")
                {
                    ApplicationArea = All;
                }
                field("Net Pay Rounding C/F"; Rec."Net Pay Rounding C/F")
                {
                    ApplicationArea = All;
                }
                field("Net Pay Rounding B/F (-Ve)"; Rec."Net Pay Rounding B/F (-Ve)")
                {
                    ApplicationArea = All;
                }
                field("Net Pay Rounding C/F (-ve)"; Rec."Net Pay Rounding C/F (-ve)")
                {
                    ApplicationArea = All;
                }
                field("Net Pay Rounding Mid Amount"; Rec."Net Pay Rounding Mid Amount")
                {
                    ApplicationArea = All;
                }
                field("House Allowances ED"; Rec."House Allowances ED")
                {
                    ApplicationArea = All;
                }
                field("Commuter Allowance ED"; Rec."Commuter Allowance ED")
                {
                    ApplicationArea = All;
                }
                field("Lost Hours Registration Type"; Rec."Lost Hours Registration Type")
                {
                    ApplicationArea = All;
                }
                field("Leave Advance Loan"; Rec."Leave Advance Loan")
                {
                    ApplicationArea = All;
                }
                field("% of Basic Pay to Advance"; Rec."% of Basic Pay to Advance")
                {
                    ApplicationArea = All;
                }
                field("Default Cause of Absence"; Rec."Default Cause of Absence")
                {
                    ToolTip = 'Filled for a non-working day in the Time Registration ''Suggest employee attendance''';
                    ApplicationArea = All;
                }
                field("Retirements Age"; Rec."Retirements Age")
                {
                    ApplicationArea = All;
                }
                field("LAPTRUST Employee ED Code"; Rec."LAPTRUST Employee ED Code")
                {
                    ApplicationArea = All;
                }
                field("LAPTRUST Employer ED Code"; Rec."LAPTRUST Employer ED Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Payroll Template"; Rec."Payroll Template")
                {
                    ApplicationArea = All;
                }
                field("Payroll Batch"; Rec."Payroll Batch")
                {
                    ApplicationArea = All;
                }
                field("Loan Template"; Rec."Loan Template")
                {
                    ApplicationArea = All;
                }
                field("Loan Payments Batch"; Rec."Loan Payments Batch")
                {
                    ApplicationArea = All;
                }
                field("Loan Losses Batch"; Rec."Loan Losses Batch")
                {
                    ApplicationArea = All;
                }
                field("Priority to Dims Assigned To"; Rec."Priority to Dims Assigned To")
                {
                    ApplicationArea = All;
                }
                field("Auto-Post Payroll Journals"; Rec."Auto-Post Payroll Journals")
                {
                    ApplicationArea = All;
                }
                field("Bonuses Exist"; Rec."Bonuses Exist")
                {
                    ApplicationArea = All;
                }
                field("Payroll Expense Based On"; Rec."Payroll Expense Based On")
                {
                    ApplicationArea = All;
                }
                field("Emp ID in Payroll Posting Jnl"; Rec."Emp ID in Payroll Posting Jnl")
                {
                    ApplicationArea = All;
                }
                field("Payroll Base Currency"; Rec."Payroll Base Currency")
                {
                    ApplicationArea = All;
                }
            }
            group("Basic Pay")
            {
                Caption = 'Basic Pay';
                field("Basic Pay E/D Code"; Rec."Basic Pay E/D Code")
                {
                    ApplicationArea = All;
                }
                field("Daily Rate Rounding"; Rec."Daily Rate Rounding")
                {
                    ApplicationArea = All;
                }
                field("Daily Rounding Precision"; Rec."Daily Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field("Hourly Rate Rounding"; Rec."Hourly Rate Rounding")
                {
                    ApplicationArea = All;
                }
                field("Hourly Rounding Precision"; Rec."Hourly Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field("Standard Hours"; Rec."Standard Hours")
                {
                    ApplicationArea = All;
                }
                field("Standard Days"; Rec."Standard Days")
                {
                    ApplicationArea = All;
                }
                field("Normal OT Rate"; Rec."Normal OT Rate")
                {
                    ApplicationArea = All;
                }
                field("Holiday OT Rate"; Rec."Holiday OT Rate")
                {
                    ApplicationArea = All;
                }
                field("Weekend OT Rate"; Rec."Weekend OT Rate")
                {
                    ApplicationArea = All;
                }
            }
            group(Information)
            {
                Caption = 'Information';
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = All;
                }
                field("Employer PIN No."; Rec."Employer PIN No.")
                {
                    ApplicationArea = All;
                }
                field("Employer NSSF No."; Rec."Employer NSSF No.")
                {
                    ApplicationArea = All;
                }
                field("Employer NHIF No."; Rec."Employer NHIF No.")
                {
                    ApplicationArea = All;
                }
                field("Employer LASC No."; Rec."Employer LASC No.")
                {
                    ApplicationArea = All;
                }
                field("Employers Address"; Rec."Employers Address")
                {
                    ApplicationArea = All;
                }
                field("Employer HELB No."; Rec."Employer HELB No.")
                {
                    ApplicationArea = All;
                }
                field("Attendance Time Register Code"; Rec."Attendance Time Register Code")
                {
                    ApplicationArea = All;
                }
                field("Overtime Time Register Code"; Rec."Overtime Time Register Code")
                {
                    ApplicationArea = All;
                }
                field("Absence Time Register Code"; Rec."Absence Time Register Code")
                {
                    ApplicationArea = All;
                }
                field("Normal OT ED"; Rec."Normal OT ED")
                {
                    ApplicationArea = All;
                }
                field("Weekend OT ED"; Rec."Weekend OT ED")
                {
                    ApplicationArea = All;
                }
                field("Holiday OT ED"; Rec."Holiday OT ED")
                {
                    ApplicationArea = All;
                }
                field("Payslip Message Footer"; Rec."Payslip Message Footer")
                {
                    ApplicationArea = All;
                }
            }
            group("Payroll Transfer")
            {
                Caption = 'Payroll Transfer';
                field("Payroll Transfer Path"; Rec."Payroll Transfer Path")
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ApplicationArea = All;
                }
                field("KRA Tax Logo"; Rec."KRA Tax Logo")
                {
                    ApplicationArea = All;
                }
            }
            group("Payslip E-mailing")
            {
                Caption = 'Payslip E-mailing';
                field("Payslips Folder"; Rec."Payslips Folder")
                {
                    ApplicationArea = All;
                }
                field("Payslips Folder No Email"; Rec."Payslips Folder No Email")
                {
                    ApplicationArea = All;
                }
                field("Email Subject"; Rec."Email Subject")
                {
                    ApplicationArea = All;
                }
                field("Email Body"; Rec."Email Body")
                {
                    ApplicationArea = All;
                }
                field("Email Footer Line 1"; Rec."Email Footer Line 1")
                {
                    ApplicationArea = All;
                }
                field("Email Footer Line 2"; Rec."Email Footer Line 2")
                {
                    ApplicationArea = All;
                }
                field("Email Footer Line 3"; Rec."Email Footer Line 3")
                {
                    ApplicationArea = All;
                }
                field("Email Footer Line 4"; Rec."Email Footer Line 4")
                {
                    ApplicationArea = All;
                }
                field("Email Footer Line 5"; Rec."Email Footer Line 5")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("KRA Logo")
            {
                Caption = 'KRA Logo';
                action("Import KRA Logo")
                {
                    Caption = 'Import KRA Logo';
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.Import;
                    end;
                }
                action("Export KRA Logo")
                {
                    Caption = 'Export KRA Logo';
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.ExportAttachment('');
                    end;
                }
                action("Delete KRA Logo")
                {
                    Caption = 'Delete KRA Logo';
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.RemoveAttachment(TRUE);
                        // END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        lvAllowedPayrolls: Record 51182;
    begin
        Rec.RESET;
        gsSegmentPayrollData; //skm150506
        lvAllowedPayrolls.SETRANGE("User ID", USERID);
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        lvAllowedPayrolls.FINDFIRST;
        IF NOT Rec.GET(lvAllowedPayrolls."Payroll Code") THEN BEGIN
            Rec."Payroll Code" := lvAllowedPayrolls."Payroll Code";
            Rec.INSERT;
        END
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
        Rec.FILTERGROUP(7);

    end;
}


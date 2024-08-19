report 51166 P10
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/P10.rdlc';

    dataset
    {
        dataitem(DataItem5766; 51150)
        {
            RequestFilterFields = Year;
            column(PayrollSetupEmployerPINNo; PayrollSetup."Employer PIN No.")
            {
            }
            column(YEARFORMATYear; 'YEAR ' + FORMAT(Year))
            {
            }
            column(Year_Year; Year)
            {
            }
            dataitem(Periods; 51151)
            {
                DataItemLink = "Period Year" = FIELD(Year);
                DataItemTableView = SORTING("Start Date");
                column(KENYAREVENUEAUTHORITY; 'KENYA REVENUE AUTHORITY')
                {
                }
                column(NAMEOFEMPLOYERPayrollSetupEmployerName; 'NAME OF EMPLOYER   ' + PayrollSetup."Employer Name")
                {
                }
                column(ADDRESSPayrollSetupEmployersAddress; 'ADDRESS    ' + PayrollSetup."Employers Address")
                {
                }
                column(SIGNATURE; 'SIGNATURE ............................................................')
                {
                }
                column(DATE; 'DATE           ............................................................')
                {
                }
                column(PAYE; PAYE)
                {
                }
                column(WeIforwardherewithTaxDeductionCardsP9AP9BshowingthetotaltaxdeductedaslistedonP10AamountingtoKshsFORMATTotalPAYE; 'We/I forward herewith ..... Tax Deduction Cards (P9A/P9B) showing the total tax deducted (as listed on P.10A) amounting to Kshs ' + FORMAT(TotalPAYE))
                {
                }
                column(Periods_Period_ID; "Period ID")
                {
                }
                column(PeriodStarDate; Periods."Start Date")
                {
                }
                column(Periods_Period_Month; "Period Month")
                {
                }
                column(Periods_Period_Year; "Period Year")
                {
                }
                column(Periods_Payroll_Code; "Payroll Code")
                {
                }
                column(EmployerName; PayrollSetup."Employer Name")
                {
                }
                column(EmployerAddress; PayrollSetup."Employers Address")
                {
                }
                dataitem("Payroll Header"; 51159)
                {
                    DataItemLink = "Payroll ID" = FIELD("Period ID");
                    column(PAYE1; PAYE)
                    {
                    }
                    column(PeriodsDescription; Periods.Description)
                    {
                    }
                    column(Payroll_Header_Payroll_ID; "Payroll ID")
                    {
                    }
                    column(Payroll_Header_Employee_no_; "Employee no.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF "L (LCY)" > 0 THEN PAYE := PAYE + "L (LCY)"; //SKM130208 OC-ES037 added if to exclude negative PAYE
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    PAYE := 0;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    CurrReport.CREATETOTALS(PAYE);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        gsSegmentPayrollData;
        PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
    end;

    var
        PAYE: Decimal;
        PayrollSetup: Record 51165;
        TotalPAYE: Decimal;
        gvAllowedPayrolls: Record 51182;

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        gvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        gvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF NOT gvAllowedPayrolls.FINDFIRST THEN
            ERROR('You are not allowed access to this payroll dataset.');
    end;
}


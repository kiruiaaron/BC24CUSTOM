report 51196 "Employee Retirements"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Employee Retirements.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
            DataItemTableView = WHERE(Status = CONST(Active));
            column(No_Employee; Employee."No.")
            {
            }
            column(BirthDate_Employee; Employee."Birth Date")
            {
            }
            column(Agetext; AgeText)
            {
            }
            column(EmployeeFullName; Employee.FullName)
            {
            }
            column(CName; CompanyInfo.Name)
            {
            }
            column(CAddress; CompanyInfo.Address)
            {
            }
            column(CCity; CompanyInfo.City)
            {
            }
            column(CPic; CompanyInfo.Picture)
            {
            }
            column(CEmail; CompanyInfo."E-Mail")
            {
            }
            column(CPhone; CompanyInfo."Phone No.")
            {
            }
            column(ServiceAgeText; ServiceAgeText)
            {
            }
            column(PeriodFormula; PeriodFormula)
            {
            }
            column(retirementdate; retirementdate)
            {
            }

            trigger OnAfterGetRecord()
            var
                retirementdateCeil: Date;
            begin

                IF Employee."Birth Date" = 0D THEN
                    CurrReport.SKIP;
                IF Employee."Calculation Scheme" = 'PWD' THEN BEGIN
                    //   EVALUATE(retireagef, FORMAT(CompanyInfo."PWD Age") + 'Y');
                    retirementdate := CALCDATE(retireagef, Employee."Birth Date");
                    retirementdateCeil := CALCDATE(PeriodFormula, TODAY);
                    IF retirementdate > retirementdateCeil THEN
                        CurrReport.SKIP;
                    AgeText := Dates.pwdDetermineAgeService2(Employee."Birth Date", Employee."Employment Date");

                END
                ELSE BEGIN


                    //     EVALUATE(retireagef, FORMAT(CompanyInfo."Permanet Age") + 'Y');
                    retirementdate := CALCDATE(retireagef, Employee."Birth Date");
                    retirementdateCeil := CALCDATE(PeriodFormula, TODAY);
                    IF retirementdate > retirementdateCeil THEN
                        CurrReport.SKIP;
                    AgeText := Dates.DetermineAgeService2(Employee."Birth Date", Employee."Employment Date");
                END
            end;

            trigger OnPreDataItem()
            begin
                Employee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                IF PeriodFormula = PeriodFormula2 THEN
                    ERROR('Please Input the Period Formula');
                Employee.SETRANGE("Emplymt. Contract Code", 'PERMANENT');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Period Formula"; PeriodFormula)
                {
                    ApplicationArea = All;
                }
            }
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
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        gsSegmentPayrollData;
    end;

    var
        PeriodFormula: DateFormula;
        AgeText: Text;
        CompanyInfo: Record 79;
        ServiceAgeText: Text;
        Dates: Codeunit 50043;
        gvAllowedPayrolls: Record 51182;
        retireagef: DateFormula;
        PeriodFormula2: DateFormula;
        retirementdate: Date;

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


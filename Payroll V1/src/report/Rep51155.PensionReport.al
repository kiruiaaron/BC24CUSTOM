report 51155 "Pension Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Pension Report.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            column(EmployerName; EmployerName)
            {
            }
            column(TitleText; TitleText)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(TotalAmountArray_2_; TotalAmountArray[2])
            {
            }
            column(TotalAmountArray_1_; TotalAmountArray[1])
            {
            }
            column(TotalAmountArray_6_; TotalAmountArray[6])
            {
            }
            column(TotalAmountArray_5_; TotalAmountArray[5])
            {
            }
            column(TotalAmountArray_4_; TotalAmountArray[4])
            {
            }
            column(TotalAmountArray_5____TotalAmountArray_6_; TotalAmountArray[5] + TotalAmountArray[6])
            {
            }
            column(Employee_ContributionCaption; Employee_ContributionCaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employer_ContributionCaption; Employer_ContributionCaptionLbl)
            {
            }
            column(Monthly_TotalCaption; Monthly_TotalCaptionLbl)
            {
            }
            column(Employee_Total_to_DateCaption; Employee_Total_to_DateCaptionLbl)
            {
            }
            column(Employer_Total_to_dateCaption; Employer_Total_to_dateCaptionLbl)
            {
            }
            column(Total_To_DateCaption; Total_To_DateCaptionLbl)
            {
            }
            column(TotalsCaption; TotalsCaptionLbl)
            {
            }
            column(Periods_Period_ID; "Period ID")
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
            dataitem(Employee; 5200)
            {
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending);
                RequestFilterFields = "No.", "Statistics Group Code", Status, "Global Dimension 1 Code", "Global Dimension 2 Code";
                column(Employee_Name; Name)
                {
                }
                column(Employee__No__; "No.")
                {
                }
                column(PeriodAmountArray_1_; PeriodAmountArray[1])
                {
                }
                column(PeriodAmountArray_5_; PeriodAmountArray[5])
                {
                }
                column(PeriodAmountArray_4_; PeriodAmountArray[4])
                {
                }
                column(PeriodAmountArray_2_; PeriodAmountArray[2])
                {
                }
                column(PeriodAmountArray_6_; PeriodAmountArray[6])
                {
                }
                column(PeriodAmountArray_5____PeriodAmountArray_6_; PeriodAmountArray[5] + PeriodAmountArray[6])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(PeriodAmountArray);

                    Name := Employee.FullName;
                    EmployeeRec.GET(Employee."No.");
                    EmployeeRec.SETFILTER("Period Filter", Periods."Period ID");

                    IF PayrollSetup."Pension ED Code" <> '' THEN BEGIN
                        EmployeeRec.SETFILTER("ED Code Filter", PayrollSetup."Pension ED Code");
                        EmployeeRec.CALCFIELDS("Amount (LCY)");
                        PeriodAmountArray[1] := EmployeeRec."Amount (LCY)";
                        TotalAmountArray[1] := TotalAmountArray[1] + EmployeeRec."Amount (LCY)";
                        PeriodAmountArray[4] += EmployeeRec."Amount (LCY)";
                        TotalAmountArray[4] := TotalAmountArray[4] + PeriodAmountArray[1];
                    END;

                    IF PayrollSetup."Pension Company Contribution" <> '' THEN BEGIN
                        EmployeeRec.SETFILTER("ED Code Filter", PayrollSetup."Pension Company Contribution");
                        EmployeeRec.CALCFIELDS("Amount (LCY)");
                        PeriodAmountArray[2] := EmployeeRec."Amount (LCY)";
                        TotalAmountArray[2] := TotalAmountArray[2] + EmployeeRec."Amount (LCY)";
                        PeriodAmountArray[4] += EmployeeRec."Amount (LCY)";
                        TotalAmountArray[4] := TotalAmountArray[4] + PeriodAmountArray[2];
                    END;

                    IF PayrollSetup."Pension Lumpsom Contribution" <> '' THEN BEGIN
                        EmployeeRec.SETFILTER("ED Code Filter", PayrollSetup."Pension Lumpsom Contribution");
                        EmployeeRec.CALCFIELDS("Amount (LCY)");
                        PeriodAmountArray[3] := EmployeeRec."Amount (LCY)";
                        TotalAmountArray[3] := TotalAmountArray[3] + EmployeeRec."Amount (LCY)";
                        PeriodAmountArray[4] += EmployeeRec."Amount (LCY)";
                        TotalAmountArray[4] := TotalAmountArray[4] + PeriodAmountArray[3];
                    END;

                    EmployeeRec.SETFILTER("Date Filter", '%1..%2', Periods."Start Date", Periods."End Date");

                    IF PayrollSetup."Pension ED Code" <> '' THEN BEGIN
                        EmployeeRec.SETFILTER("ED Code Filter", PayrollSetup."Pension ED Code");
                        EmployeeRec.CALCFIELDS("Amount To Date (LCY)");
                        PeriodAmountArray[5] := EmployeeRec."Amount To Date (LCY)";
                        TotalAmountArray[5] := TotalAmountArray[5] + EmployeeRec."Amount To Date (LCY)";
                    END;

                    IF PayrollSetup."Pension Company Contribution" <> '' THEN BEGIN
                        EmployeeRec.SETFILTER("ED Code Filter", PayrollSetup."Pension Company Contribution");
                        EmployeeRec.CALCFIELDS("Amount To Date (LCY)");
                        PeriodAmountArray[6] := EmployeeRec."Amount To Date (LCY)";
                        TotalAmountArray[6] := TotalAmountArray[6] + EmployeeRec."Amount To Date (LCY)";
                    END;

                    IF PayrollSetup."Pension Lumpsom Contribution" <> '' THEN BEGIN
                        EmployeeRec.SETFILTER("ED Code Filter", PayrollSetup."Pension Lumpsom Contribution");
                        EmployeeRec.CALCFIELDS("Amount To Date (LCY)");
                        PeriodAmountArray[6] := PeriodAmountArray[6] + EmployeeRec."Amount To Date (LCY)";
                        TotalAmountArray[6] := TotalAmountArray[6] + EmployeeRec."Amount To Date (LCY)";
                    END
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }
            dataitem(Integer; 2000000026)
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'Pension Contributions for ' + Periods.Description;

                CLEAR(TotalAmountArray);
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                IF Periods.GETFILTER(Periods."Period ID") = '' THEN ERROR('Specify the Period ID');
            end;
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
        EmployerName := PayrollSetup."Employer Name";

        PeriodRec.SETCURRENTKEY("Start Date");
        PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        PeriodRec.FIND('-');
    end;

    var
        PayrollSetup: Record 51165;
        PeriodRec: Record 51151;
        EmployeeRec: Record 5200;
        Name: Text[100];
        TitleText: Text[60];
        EmployerName: Text[50];
        PeriodAmountArray: array[6] of Decimal;
        TotalAmountArray: array[6] of Decimal;
        gvAllowedPayrolls: Record 51182;
        Employee_ContributionCaptionLbl: Label 'Employee Contribution';
        NameCaptionLbl: Label 'Name';
        No_CaptionLbl: Label 'No.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Employer_ContributionCaptionLbl: Label 'Employer Contribution';
        Monthly_TotalCaptionLbl: Label 'Monthly Total';
        Employee_Total_to_DateCaptionLbl: Label 'Employee Total to Date';
        Employer_Total_to_dateCaptionLbl: Label 'Employer Total to date';
        Total_To_DateCaptionLbl: Label 'Total To Date';
        TotalsCaptionLbl: Label 'Totals';

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


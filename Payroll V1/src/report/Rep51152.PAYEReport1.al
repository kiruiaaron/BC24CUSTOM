report 51152 "PAYE Report1"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/PAYE Report1.rdlc';

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
            column(Amount_This_PeriodCaption; Amount_This_PeriodCaptionLbl)
            {
            }
            column(Employee_NameCaption; Employee_NameCaptionLbl)
            {
            }
            column(gvPinNoCaption; gvPinNoCaptionLbl)
            {
            }
            column(Employee__No__Caption; Employee__No__CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(AmountThisYearCaption; AmountThisYearCaptionLbl)
            {
            }
            column(AmountToDateCaption; AmountToDateCaptionLbl)
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
            dataitem("Payroll Lines"; 51160)
            {
                DataItemLink = "Payroll ID" = FIELD("Period ID");
                DataItemTableView = SORTING("Payroll ID", "Employee No.", "ED Code");
                column(Payroll_Lines_Entry_No_; "Entry No.")
                {
                }
                column(Payroll_Lines_Payroll_ID; "Payroll ID")
                {
                }
                column(Payroll_Lines_Employee_No_; "Employee No.")
                {
                }
                column(Payroll_Lines_ED_Code; "ED Code")
                {
                }
                dataitem(Employee; 5200)
                {
                    DataItemLink = "No." = FIELD("Employee No.");
                    DataItemTableView = SORTING("No.")
                                        ORDER(Ascending);
                    RequestFilterFields = "No.", "Statistics Group Code", "Global Dimension 1 Code", "Global Dimension 2 Code", Status;
                    column(Employee_Name; Name)
                    {
                    }
                    column(Employee__No__; "No.")
                    {
                    }
                    column(gvPinNo; gvPinNo)
                    {
                    }
                    column(AmountPeriod; AmountPeriod)
                    {
                    }
                    column(AmountThisYear; AmountThisYear)
                    {
                    }
                    column(AmountToDate; AmountToDate)
                    {
                    }
                    column(Employee_ED_Code_Filter; "ED Code Filter")
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        lvPeriodYear: Text[5];
                    begin

                        IF PrevEmpID = Employee."No." THEN CurrReport.SKIP;//SNG 270511 To stop employee details from being fetched more than once

                        Name := Employee.FullName;

                        Employee.SETRANGE("Period Filter", Periods."Period ID");
                        Employee.CALCFIELDS(Amount);
                        AmountPeriod := Employee.Amount;
                        TotalAmount := TotalAmount + Employee.Amount;

                        AmountThisYear := 0;

                        //calculate the PAYE amount for the employee in the year
                        PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
                        gvPeriods.RESET;
                        gvPeriods.SETRANGE("Period ID", Periods."Period ID");
                        IF gvPeriods.FIND('-') THEN
                            lvPeriodYear := STRSUBSTNO('*%1', FORMAT(gvPeriods."Period Year"));
                        gvPayrollLines.RESET;
                        gvPayrollLines.SETCURRENTKEY("ED Code", "Employee No.", "Payroll Code", "Payroll ID");
                        gvPayrollLines.SETRANGE("ED Code", PayrollSetup."PAYE ED Code");
                        gvPayrollLines.SETRANGE("Employee No.", Employee."No.");
                        gvPayrollLines.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                        gvPayrollLines.SETFILTER("Payroll ID", '%1', lvPeriodYear);
                        IF gvPayrollLines.FINDSET THEN BEGIN
                            REPEAT
                                AmountThisYear += gvPayrollLines.Amount;
                            UNTIL gvPayrollLines.NEXT = 0;
                        END;


                        Employee.SETRANGE("Period Filter", PeriodRec."Period ID", Periods."Period ID");
                        Employee.CALCFIELDS(Amount, "Amount To Date");
                        //AmountThisYear := Employee.Amount;
                        //TotalAmountThisYear := TotalAmountThisYear + Employee.Amount;
                        TotalAmountThisYear := TotalAmountThisYear + AmountThisYear;

                        AmountToDate := Employee."Amount To Date";
                        TotalAmountToDate := TotalAmountToDate + Employee."Amount To Date";


                        //AKK START
                        SETFILTER("ED Code Filter", PayrollSetup."PAYE ED Code");
                        CALCFIELDS("Membership No.");
                        gvPinNo := Employee.PIN;
                        //AKK STOP
                    end;

                    trigger OnPostDataItem()
                    begin
                        PrevEmpID := Employee."No.";
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    SETRANGE("ED Code", PayrollSetup."PAYE ED Code");
                end;
            }
            dataitem(Integer; 2000000026)
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(TotalAmount; TotalAmount)
                {
                }
                column(TotalAmountThisYear; TotalAmountThisYear)
                {
                }
                column(TotalAmountToDate; TotalAmountToDate)
                {
                }
                column(TotalsCaption; TotalsCaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'PAYE Deduction Schedule for ' + Periods.Description;

                PeriodRec.SETRANGE("Period Year", Periods."Period Year");
                PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                PeriodRec.FIND('-');

                TotalAmountThisYear := 0;
                TotalAmountToDate := 0;
                TotalAmount := 0;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
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
    end;

    var
        PayrollSetup: Record 51165;
        PeriodRec: Record 51151;
        Name: Text[100];
        TitleText: Text[60];
        EmployerName: Text[50];
        AmountPeriod: Decimal;
        AmountThisYear: Decimal;
        AmountToDate: Decimal;
        TotalAmountThisYear: Decimal;
        TotalAmountToDate: Decimal;
        TotalAmount: Decimal;
        gvAllowedPayrolls: Record 51182;
        MembershipNumbers: Record 51175;
        gvPinNo: Code[20];
        PrevEmpID: Code[20];
        gvPayrollLines: Record 51160;
        gvPeriods: Record 51151;
        Amount_This_PeriodCaptionLbl: Label 'Amount This Period';
        Employee_NameCaptionLbl: Label 'Name';
        gvPinNoCaptionLbl: Label 'PIN No.';
        Employee__No__CaptionLbl: Label 'No.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        AmountThisYearCaptionLbl: Label 'This Year';
        AmountToDateCaptionLbl: Label 'To Date';
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


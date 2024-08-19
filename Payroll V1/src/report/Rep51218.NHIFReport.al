report 51218 "NHIF Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/NHIF Report.rdlc';

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
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(NHIF_No_Caption; NHIF_No_CaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(This_YearCaption; This_YearCaptionLbl)
            {
            }
            column(To_DateCaption; To_DateCaptionLbl)
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
                    DataItemLink = "No." = FIELD("Employee No."),
                                   "Period Filter" = FIELD("Payroll ID");
                    RequestFilterFields = "No.", "Statistics Group Code", "Global Dimension 1 Code", "Global Dimension 2 Code", Status;
                    column(Employee_Name; Name)
                    {
                    }
                    column(LName; Employee."Last Name")
                    {
                    }
                    column(Fname; Employee."First Name")
                    {
                    }
                    column(Employee__No__; "No.")
                    {
                    }
                    column(Employee__Membership_No__; "NHIF No.")
                    {
                    }
                    column(IDNo; Employee."National ID")
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
                    column(EmployerCode; NHIFEmployer)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        lvPeriodYear: Text[5];
                    begin
                        IF PrevEmpID = Employee."No." THEN CurrReport.SKIP;//SNG 300511 To stop employee details from being fetched more than once

                        Name := Employee.FullName;

                        Employee.SETRANGE("Period Filter", Periods."Period ID");
                        Employee.CALCFIELDS(Amount);
                        AmountPeriod := Employee.Amount;
                        TotalAmount := TotalAmount + Employee.Amount;
                        AmountPeriod := 0;
                        AmountThisYear := 0;
                        //calculate the NHIF amount for the employee in the year
                        PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
                        EmployerName := PayrollSetup."Employer Name";
                        NHIFEmployer := PayrollSetup."Employer NHIF No.";
                        gvPeriods.RESET;
                        gvPeriods.SETRANGE("Period ID", Periods."Period ID");
                        IF gvPeriods.FIND('-') THEN
                            lvPeriodYear := STRSUBSTNO('*%1', FORMAT(gvPeriods."Period Year"));
                        gvPayrollLines.RESET;
                        gvPayrollLines.SETCURRENTKEY("ED Code", "Employee No.", "Payroll Code", "Payroll ID");
                        gvPayrollLines.SETRANGE("ED Code", PayrollSetup."NHIF ED Code");
                        gvPayrollLines.SETRANGE("Employee No.", Employee."No.");
                        gvPayrollLines.SETRANGE("Payroll ID", Periods."Period ID");
                        //gvPayrollLines.SETRANGE("Payroll Code",gvAllowedPayrolls."Payroll Code");

                        IF gvPayrollLines.FINDSET THEN BEGIN
                            REPEAT
                                AmountPeriod += gvPayrollLines.Amount;
                            UNTIL gvPayrollLines.NEXT = 0;
                        END;



                        Employee.SETRANGE("Period Filter", PeriodRec."Period ID", Periods."Period ID");
                        Employee.CALCFIELDS(Amount, "Amount To Date");
                        //AmountThisYear := Employee.Amount;
                        //TotalAmountThisYear := TotalAmountThisYear + Employee.Amount;
                        TotalAmountThisYear := TotalAmountThisYear + AmountThisYear;

                        AmountToDate := Employee."Amount To Date";
                        TotalAmountToDate := TotalAmountToDate + Employee."Amount To Date";
                    end;

                    trigger OnPostDataItem()
                    begin
                        PrevEmpID := Employee."No.";
                    end;

                    trigger OnPreDataItem()
                    begin
                        //Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SETRANGE("ED Code", PayrollSetup."NHIF ED Code");
                    //Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    //setrange("Payroll Lines"."Payroll ID",
                end;
            }
            dataitem(DataItem5444; 2000000026)
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
                TitleText := 'NHIF Deduction Schedule for ' + Periods.Description;
                PeriodRec.SETRANGE("Period Year", Periods."Period Year");
                //PeriodRec.Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
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
        PrevEmpID: Code[20];
        gvPayrollLines: Record 51160;
        gvPeriods: Record 51151;
        AmountCaptionLbl: Label 'Amount';
        NameCaptionLbl: Label 'Name';
        NHIF_No_CaptionLbl: Label 'NHIF No.';
        No_CaptionLbl: Label 'No.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        This_YearCaptionLbl: Label 'Amount';
        To_DateCaptionLbl: Label 'To Date';
        TotalsCaptionLbl: Label 'Totals';
        CompInfo: Record 79;
        NHIFEmployer: Code[20];

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


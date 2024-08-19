report 51195 "LAPTRUST Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/LAPTRUST Report.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date");
            RequestFilterFields = "Period ID";
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
            dataitem("ED Definitions"; 51158)
            {
                RequestFilterFields = "ED Code";
                column(USERID; USERID)
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(ED_Definitions__ED_Code_; "ED Code")
                {
                }
                column(ED_Definitions_Description; Description)
                {
                }
                column(EmployerName; EmployerName)
                {
                }
                column(TitleText; TitleText)
                {
                }
                column(EDFilters; EDFilters)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Employee_NameCaption; Employee_NameCaptionLbl)
                {
                }
                column(Employee__No__Caption; Employee__No__CaptionLbl)
                {
                }
                column(Employee__Membership_No__Caption; Employee__Membership_No__CaptionLbl)
                {
                }
                column(AmountPeriodCaption; AmountPeriodCaptionLbl)
                {
                }
                column(AmountThisYearCaption; AmountThisYearCaptionLbl)
                {
                }
                column(AmountToDateCaption; AmountToDateCaptionLbl)
                {
                }
                column(Employee__Bank_Account_No__Caption; Employee.FIELDCAPTION("Bank Account No"))
                {
                }
                column(BankCaption; BankCaptionLbl)
                {
                }
                column(BranchCaption; BranchCaptionLbl)
                {
                }
                dataitem("Payroll Lines"; 51160)
                {
                    DataItemLink = "ED Code" = FIELD("ED Code");
                    DataItemTableView = SORTING("Payroll ID", "Employee No.", "ED Code");
                    column(Payroll_Lines_Entry_No_; "Entry No.")
                    {
                    }
                    column(Payroll_Lines_ED_Code; "ED Code")
                    {
                    }
                    column(Payroll_Lines_Employee_No_; "Employee No.")
                    {
                    }
                    column(RemainingDebt_PayrollLines; CumilativeDec)
                    {
                    }
                    dataitem(Employee; 5200)
                    {
                        DataItemLink = "No." = FIELD("Employee No.");
                        DataItemTableView = SORTING("Global Dimension 1 Code");
                        RequestFilterFields = "No.", "Statistics Group Code", "Global Dimension 1 Code", "Global Dimension 2 Code", Status;
                        column(Employee_Name; Name)
                        {
                        }
                        column(Employee__No__; "No.")
                        {
                        }
                        column(LaptrustNo_Employee; Employee."Laptrust No")
                        {
                        }
                        column(Employee__Membership_No__; "Membership No.")
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
                        column(Employee__Bank_Account_No__; "Bank Account No")
                        {
                        }
                        column(NationalID_Employee; Employee."National ID")
                        {
                        }
                        column(BankName; BankName)
                        {
                        }
                        column(BranchName; BranchName)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            lvBank: Record 51152;
                        begin
                            Name := FullName;
                            Employee.SETFILTER("Employee Type", '%1', "Payroll Lines"."Loan ID");
                            SETFILTER("ED Code Filter", "ED Definitions"."ED Code");
                            CALCFIELDS("Membership No.");

                            SETFILTER("Date Filter", '%1..%2', Periods."Start Date", Periods."End Date");
                            CALCFIELDS("Amount (LCY)");
                            AmountPeriod := "Amount (LCY)";
                            TotalAmount := TotalAmount + "Amount (LCY)";

                            SETFILTER("Date Filter", '%1', Periods."End Date");
                            CALCFIELDS("Amount To Date (LCY)");

                            PeriodRec.SETRANGE("Period Year", Periods."Period Year");
                            PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                            PeriodRec.FIND('-');
                            SETFILTER("Date Filter", '%1..%2', PeriodRec."Start Date", Periods."End Date");
                            CALCFIELDS("Amount (LCY)");
                            AmountThisYear := "Amount (LCY)";
                            TotalAmountThisYear := TotalAmountThisYear + "Amount (LCY)";

                            AmountToDate := "Amount To Date (LCY)";
                            TotalAmountToDate := TotalAmountToDate + "Amount To Date";
                            Empcount := Empcount + 1;

                            IF lvBank.GET(Employee."Bank Code") THEN BEGIN
                                BankName := lvBank.Name;
                                BranchName := lvBank.Branch;
                            END
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                            CurrReport.CREATETOTALS(AmountToDate, TotalAmountToDate);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        EDDefRec: Record 51158;
                        EmployeeRec: Record 5200;
                        Enddate: Date;
                        PayrollLines: Record 51160;
                    begin
                        //CumilativeDec:=ROUND((15/12)*"Payroll Lines".Amount,1);
                        PayrollLines.RESET;
                        PayrollLines.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                        PayrollLines.SETRANGE("Payroll ID", Periods."Period ID");
                        PayrollLines.SETRANGE("ED Code", PayrollSetup."LAPTRUST Employer ED Code");
                        PayrollLines.SETRANGE("Employee No.", "Payroll Lines"."Employee No.");
                        IF PayrollLines.FINDFIRST THEN
                            CumilativeDec := PayrollLines.Amount
                        ELSE
                            CumilativeDec := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                        SETRANGE("Payroll ID", Periods."Period ID");
                        SETRANGE("Payroll Lines"."ED Code", PayrollSetup."LAPTRUST Employee ED Code");
                    end;
                }
                dataitem(DataItem5444; 2000000026)
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(Number_of_Employees_____FORMAT_Empcount_; 'Number of Employees ' + FORMAT(Empcount))
                    {
                    }
                    column(TotalAmount; TotalAmount)
                    {
                    }
                    column(TotalAmountThisYear; TotalAmountThisYear)
                    {
                    }
                    column(TotalAmountToDate; TotalAmountToDate)
                    {
                    }
                    column(TotalAmount_Control1000000011; TotalAmount)
                    {
                    }
                    column(Periods_Description; Periods.Description)
                    {
                    }
                    column(TotalsCaption; TotalsCaptionLbl)
                    {
                    }
                    column(Please_Recieve_Cheque_Number__________________________________Caption; Please_Recieve_Cheque_Number__________________________________CaptionLbl)
                    {
                    }
                    column(For_Ksh_Caption; For_Ksh_CaptionLbl)
                    {
                    }
                    column(Covering_payment_of_advance_to_the_above_listed_StaffCaption; Covering_payment_of_advance_to_the_above_listed_StaffCaptionLbl)
                    {
                    }
                    column(Please_credit_their_accounts_accordinglyCaption; Please_credit_their_accounts_accordinglyCaptionLbl)
                    {
                    }
                    column(Approved_by_Chief_Executive_OfficerCaption; Approved_by_Chief_Executive_OfficerCaptionLbl)
                    {
                    }
                    column(Approved_by_AccountantCaption; Approved_by_AccountantCaptionLbl)
                    {
                    }
                    column(Approved_by_HR_Admin_ManagerCaption; Approved_by_HR_Admin_ManagerCaptionLbl)
                    {
                    }
                    column(Integer_Number; Number)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    TotalAmountThisYear := 0;
                    TotalAmountToDate := 0;
                    TotalAmount := 0;
                end;

                trigger OnPreDataItem()
                begin
                    "ED Definitions".SETRANGE("ED Definitions"."ED Code", PayrollSetup."LAPTRUST Employee ED Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'Earning/Deduction Schedule for ' + Periods.Description;
                PeriodRec.SETRANGE("Period Year", Periods."Period Year");
                PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                PeriodRec.FIND('-');

                TotalAmountThisYear := 0;
                TotalAmountToDate := 0;
                TotalAmount := 0;
                Empcount := 0;
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
        EDFilters := "ED Definitions".GETFILTERS + ' ' + Employee.GETFILTERS;
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
        EDFilters: Text[150];
        Empcount: Integer;
        gvAllowedPayrolls: Record 51182;
        BankName: Text[200];
        BranchName: Text[50];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Employee_NameCaptionLbl: Label 'Name';
        Employee__No__CaptionLbl: Label 'No.';
        Employee__Membership_No__CaptionLbl: Label 'Membership No.';
        AmountPeriodCaptionLbl: Label 'Amount';
        AmountThisYearCaptionLbl: Label 'This Year';
        AmountToDateCaptionLbl: Label 'To Date';
        BankCaptionLbl: Label 'Bank';
        BranchCaptionLbl: Label 'Branch';
        TotalsCaptionLbl: Label 'Totals';
        Please_Recieve_Cheque_Number__________________________________CaptionLbl: Label 'Please Recieve Cheque Number__________________________________';
        For_Ksh_CaptionLbl: Label 'For Ksh.';
        Covering_payment_of_advance_to_the_above_listed_StaffCaptionLbl: Label 'Covering payment of advance to the above listed Staff';
        Please_credit_their_accounts_accordinglyCaptionLbl: Label 'Please credit their accounts accordingly';
        Approved_by_Chief_Executive_OfficerCaptionLbl: Label 'Approved by Finance Director';
        Approved_by_AccountantCaptionLbl: Label 'Approved by FinanceAccountant';
        Approved_by_HR_Admin_ManagerCaptionLbl: Label 'Approved by HR/Admin Manager';
        CumilativeDec: Decimal;

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


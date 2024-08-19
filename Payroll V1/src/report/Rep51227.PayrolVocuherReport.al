report 51227 "PayrolVocuher Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/PayrolVocuher Report.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date");
            RequestFilterFields = "Period ID";
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
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
                                    ORDER(Ascending)
                                    WHERE(Status = CONST(Active));
                RequestFilterFields = "No.", "Global Dimension 1 Code", Status, "Calculation Scheme";
                column(Employee_Name; Name)
                {
                }
                column(Employee__No__; "No.")
                {
                }
                column(BankAccountNo_Employee; Employee."Bank Account No")
                {
                }
                column(KRAPIN; Employee.PIN)
                {
                }
                dataitem("Calculation Scheme Master Roll"; 51192)
                {
                    DataItemTableView = SORTING("Payroll Code", Number);
                    column(Number_CalculationScheme1; "Calculation Scheme Master Roll".Number)
                    {
                    }
                    column(EDCode_CalculationScheme1; "Calculation Scheme Master Roll"."ED Code")
                    {
                    }
                    column(Description_CalculationScheme1; "Calculation Scheme Master Roll".Description)
                    {
                    }
                    column(ValueSource_CalculationScheme1; "Calculation Scheme Master Roll"."Value Source")
                    {
                    }
                    column(Amount; Amount)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Amount := 0;
                        IF "Calculation Scheme Master Roll"."Value Source" = "Calculation Scheme Master Roll"."Value Source"::"ED Definition" THEN BEGIN
                            PayrollLines.RESET;
                            PayrollLines.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                            PayrollLines.SETRANGE("Employee No.", Employee."No.");
                            PayrollLines.SETRANGE("Payroll ID", Periods."Period ID");
                            PayrollLines.SETRANGE("ED Code", "Calculation Scheme Master Roll"."ED Code");
                            IF PayrollLines.FINDFIRST THEN BEGIN
                                REPEAT
                                    Amount := Amount + PayrollLines.Amount;
                                UNTIL PayrollLines.NEXT = 0;
                                /*IF PayrollLines."Calculation Group"=PayrollLines."Calculation Group"::Payments THEN
                                  TotalIncome:=TotalIncome+Amount*/
                                /*ELSE*/
                                IF PayrollLines."Calculation Group" = PayrollLines."Calculation Group"::Deduction THEN
                                    TotalDeduction := TotalDeduction + Amount;

                            END

                        END
                        ELSE
                            IF "Calculation Scheme Master Roll"."Value Source" = "Calculation Scheme Master Roll"."Value Source"::"Total Deduction" THEN BEGIN
                                Amount := TotalDeduction;
                            END
                            ELSE
                                IF "Calculation Scheme Master Roll"."Value Source" = "Calculation Scheme Master Roll"."Value Source"::"Total Gross" THEN BEGIN
                                    Amount := TotalIncome;
                                END
                                ELSE
                                    IF "Calculation Scheme Master Roll"."Value Source" = "Calculation Scheme Master Roll"."Value Source"::"Net Pay" THEN BEGIN
                                        Amount := TotalIncome - TotalDeduction;
                                    END;
                        //MESSAGE(FORMAT(Amount));
                        IF Amount = 0 THEN
                            CurrReport.SKIP

                    end;

                    trigger OnPreDataItem()
                    begin
                        //"Calculation Scheme Master Roll".SETRANGE("Calculation Scheme Master Roll"."Payroll Code",gvAllowedPayrolls."Payroll Code");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    lvBank: Record 51152;
                begin
                    Name := FullName;
                    TotalDeduction := 0;
                    TotalIncome := 0;
                    Netpay := 0;
                end;

                trigger OnPreDataItem()
                begin
                    //Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'Earning/Deduction Schedule for ' + Periods.Description;
                PeriodRec.SETRANGE("Period Year", Periods."Period Year");
                PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                PeriodRec.FIND('-');
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
        //EDFilters := "ED Definitions".GETFILTERS + ' ' + Employee.GETFILTERS;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
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
        TotalIncome: Decimal;
        TotalDeduction: Decimal;
        Netpay: Decimal;
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
        PayrollLines: Record "Payroll Lines";
        Amount: Decimal;
        CompanyInfo: Record "Company Information";

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record "Allowed Payrolls";
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


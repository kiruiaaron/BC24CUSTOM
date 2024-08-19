report 51194 "Master Roll Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/MasterRollReport.rdlc';

    dataset
    {
        dataitem(Periods; Periods)
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
            dataitem(Employee; Employee)
            {
                DataItemTableView = SORTING("Global Dimension 1 Code");
                RequestFilterFields = "No.", "Statistics Group Code", "Global Dimension 1 Code", "Global Dimension 2 Code", Status;
                column(Employee_Name; Name)
                {
                }
                column(Employee__No__; "No.")
                {
                }
                dataitem("Calculation Scheme Master Roll"; "Calculation Scheme Master Roll")
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
                        if "Calculation Scheme Master Roll"."Value Source" = "Calculation Scheme Master Roll"."Value Source"::"ED Definition" then begin
                            PayrollLines.Reset;
                            PayrollLines.SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
                            PayrollLines.SetRange("Employee No.", Employee."No.");
                            PayrollLines.SetRange("Payroll ID", Periods."Period ID");
                            PayrollLines.SetRange("ED Code", "Calculation Scheme Master Roll"."ED Code");
                            if PayrollLines.FindFirst then begin
                                repeat
                                    Amount := Amount + PayrollLines.Amount;
                                until PayrollLines.Next = 0;
                                if PayrollLines."Calculation Group" = PayrollLines."Calculation Group"::Payments then
                                    TotalIncome := TotalIncome + Amount
                                else
                                    if PayrollLines."Calculation Group" = PayrollLines."Calculation Group"::Deduction then
                                        TotalDeduction := TotalDeduction + Amount;

                            end

                        end
                        else
                            if "Calculation Scheme Master Roll"."Value Source" = "Calculation Scheme Master Roll"."Value Source"::"Total Deduction" then begin
                                Amount := TotalDeduction;
                            end
                            else
                                if "Calculation Scheme Master Roll"."Value Source" = "Calculation Scheme Master Roll"."Value Source"::"Total Gross" then begin
                                    Amount := TotalIncome;
                                end
                                else
                                    if "Calculation Scheme Master Roll"."Value Source" = "Calculation Scheme Master Roll"."Value Source"::"Net Pay" then begin
                                        Amount := TotalIncome - TotalDeduction;
                                    end;
                        //MESSAGE(FORMAT(Amount));
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Calculation Scheme Master Roll".SetRange("Calculation Scheme Master Roll"."Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    lvBank: Record "Employee Bank Account";
                begin
                    Name := FullName;
                    TotalDeduction := 0;
                    TotalIncome := 0;
                    Netpay := 0;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'Earning/Deduction Schedule for ' + Periods.Description;
                PeriodRec.SetRange("Period Year", Periods."Period Year");
                PeriodRec.SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");
                PeriodRec.Find('-');
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Payroll Code", gvAllowedPayrolls."Payroll Code");

                if Periods.GetFilter(Periods."Period ID") = '' then Error('Specify the Period ID');
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
        PayrollSetup.Get(gvAllowedPayrolls."Payroll Code");

        EmployerName := PayrollSetup."Employer Name";
        PeriodRec.SetCurrentKey("Start Date");
        //EDFilters := "ED Definitions".GETFILTERS + ' ' + Employee.GETFILTERS;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        PayrollSetup: Record "Payroll Setups";
        PeriodRec: Record Periods;
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
        gvAllowedPayrolls: Record "Allowed Payrolls";
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
        lvPayrollUtilities: Codeunit "Payroll Posting";
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record "Active Session";
    begin

        lvActiveSession.Reset;
        lvActiveSession.SetRange("Server Instance ID", ServiceInstanceId);
        lvActiveSession.SetRange("Session ID", SessionId);
        lvActiveSession.FindFirst;


        gvAllowedPayrolls.SetRange("User ID", lvActiveSession."User ID");
        gvAllowedPayrolls.SetRange("Last Active Payroll", true);
        if not gvAllowedPayrolls.FindFirst then
            Error('You are not allowed access to this payroll dataset.');
    end;
}


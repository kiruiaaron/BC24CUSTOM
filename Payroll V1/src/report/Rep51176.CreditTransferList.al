report 51176 "Credit Transfer List"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Credit Transfer List.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Period ID", "Period Month", "Period Year")
                                ORDER(Ascending);
            RequestFilterFields = "Period ID";
            column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReportPAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Description_Periods; Description)
            {
            }
            column(gvPeriodTotalAmount; gvPeriodTotalAmount)
            {
            }
            column(PeriodID_Periods; "Period ID")
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
            dataitem("Employee Bank Account"; 51152)
            {
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending);
                PrintOnlyIfDetail = true;
                RequestFilterFields = "No.";
                column(Name_EmployeeBankAccount; Name)
                {
                }
                column(Branch_EmployeeBankAccount; Branch)
                {
                }
                column(Address_EmployeeBankAccount; Address)
                {
                }
                column(City_EmployeeBankAccount; City)
                {
                }
                column(gvBankTotalAmount; gvBankTotalAmount)
                {
                }
                column(Name_EmployeeBankAccount1; Name)
                {
                }
                column(Branch_EmployeeBankAccount1; Branch)
                {
                }
                column(Employee_Bank_Account_No_; "No.")
                {
                }
                dataitem(Employee; 5200)
                {
                    // DataItemLink = Field52021889 = FIELD("No.");
                    PrintOnlyIfDetail = false;
                    RequestFilterFields = "No.";
                    column(No_Employee; "No.")
                    {
                    }
                    column(FullName; FullName)
                    {
                    }
                    column(BankAccountNo_Employee; "Bank Account No")
                    {
                    }
                    column(gvAmount; gvAmount)
                    {
                    }
                    column(Employee_Bank_Code; "Bank Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        gvAmount := 0;
                        IF Header.GET(Periods."Period ID", "No.") THEN BEGIN
                            Header.CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)", "Total Rounding Pmts (LCY)", "Total Rounding Ded (LCY)");
                            gvAmount := Header."Total Payable (LCY)" + Header."Total Rounding Pmts (LCY)" - (Header."Total Deduction (LCY)" +
                              Header."Total Rounding Ded (LCY)");
                            IF gvAmount < 0 THEN
                                CurrReport.SKIP
                            ELSE
                                gvBankTotalAmount := gvBankTotalAmount + gvAmount;
                            gvPeriodTotalAmount := gvPeriodTotalAmount + gvAmount;
                        END ELSE
                            CurrReport.SKIP;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    gvBankTotalAmount := 0;
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FIELDNO("No.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                gvPeriodTotalAmount := 0;
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
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Header: Record 51159;
        gvBankTotalAmount: Decimal;
        gvAmount: Decimal;
        gvPeriodTotalAmount: Decimal;
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


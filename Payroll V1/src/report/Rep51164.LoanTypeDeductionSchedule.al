report 51164 "Loan Type Deduction Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Loan Type Deduction Schedule.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                WHERE(Status = FILTER(Open | Posted));
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
            dataitem("Loan Types"; 51178)
            {
                column(Loan_Types_Description; Description)
                {
                }
                column(Loan_Types_Code; Code)
                {
                }
                column(USERID; USERID)
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(EmployerName; EmployerName)
                {
                }
                column(TitleText; TitleText)
                {
                }
                column(No_Caption; No_CaptionLbl)
                {
                }
                column(NameCaption; NameCaptionLbl)
                {
                }
                column(Principle_RepaidCaption; Principle_RepaidCaptionLbl)
                {
                }
                column(InterestCaption; InterestCaptionLbl)
                {
                }
                column(Remaining_DebtCaption; Remaining_DebtCaptionLbl)
                {
                }
                column(MonthlyCaption; MonthlyCaptionLbl)
                {
                }
                column(Loan_Types_CodeCaption; Loan_Types_CodeCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                dataitem("Loans/Advances"; 51171)
                {
                    DataItemLink = "Loan Types" = FIELD(Code);
                    RequestFilterFields = "Loan Types";
                    column(Loans_Advances_ID; "Loan ID")
                    {
                    }
                    column(Loans_Advances_Loan_Types; "Loan Types")
                    {
                    }
                    column(Loans_Advances_Employee; Employee)
                    {
                    }
                    dataitem("Loan Entry"; 51172)
                    {
                        DataItemLink = "Loan ID" = FIELD("Loan ID"),
                                       Employee = FIELD(Employee);
                        DataItemTableView = SORTING("Loan ID", Employee, Period, "Transfered To Payroll", Posted)
                                            ORDER(Ascending);
                        column(Name; Name)
                        {
                        }
                        column(Loan_Entry_Employee; Employee)
                        {
                        }
                        column(Loan_Entry_Repayment; Repayment)
                        {
                        }
                        column(Loan_Entry_Interest; Interest)
                        {
                        }
                        column(Loan_Entry__Remaining_Debt_; "Remaining Debt")
                        {
                        }
                        column(PeriodAmount; PeriodAmount)
                        {
                        }
                        column(Loan_Entry_No_; "No.")
                        {
                        }
                        column(Loan_Entry_Loan_ID; "Loan ID")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            EmployeeRec.GET(Employee);
                            Name := EmployeeRec.FullName;

                            PeriodAmount := Interest + Repayment;
                            TotalAmountArray[1] := TotalAmountArray[1] + Repayment;
                            TotalAmountArray[2] := TotalAmountArray[2] + Interest;
                            TotalAmountArray[3] := TotalAmountArray[3] + PeriodAmount;
                            TotalAmountArray[4] := TotalAmountArray[4] + "Remaining Debt";
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                            SETRANGE(Period, PERIODFILTER);

                            IF NOT gvShowWrittenOff THEN  //SNG 080611 allow user to view Written off and Cleared loans
                                SETRANGE("Loan Entry".Posted, FALSE);
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                        IF NOT gvShowWrittenOff THEN   //SNG 080611 allow user to view Written off and Cleared loans
                            SETRANGE("Loans/Advances".Cleared, FALSE);
                    end;
                }
                dataitem(DataItem5444; 2000000026)
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(TotalAmountArray_2_; TotalAmountArray[2])
                    {
                    }
                    column(TotalAmountArray_1_; TotalAmountArray[1])
                    {
                    }
                    column(TotalAmountArray_3_; TotalAmountArray[3])
                    {
                    }
                    column(TotalAmountArray_4_; TotalAmountArray[4])
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
                    CLEAR(TotalAmountArray);
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'Loan Deduction Schedule for ' + Periods.Description;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                // IF Periods.GETFILTER(Periods."Period ID")=''THEN ERROR('Specify the Period ID');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Group)
                {
                    field(gvShowWrittenOff; gvShowWrittenOff)
                    {
                        Caption = 'Show Written Off Loans / Cleared Loans';
                        ApplicationArea = All;
                    }
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
        gsSegmentPayrollData;
        PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
        EmployerName := PayrollSetup."Employer Name";
        PERIODFILTER := Periods.GETFILTER("Period ID");
    end;

    var
        PayrollSetup: Record 51165;
        EmployeeRec: Record 5200;
        Name: Text[100];
        TitleText: Text[60];
        EmployerName: Text[50];
        PeriodAmount: Decimal;
        TotalAmountArray: array[4] of Decimal;
        PERIODFILTER: Text[30];
        gvAllowedPayrolls: Record 51182;
        gvShowWrittenOff: Boolean;
        No_CaptionLbl: Label 'No.';
        NameCaptionLbl: Label 'Name';
        Principle_RepaidCaptionLbl: Label 'Principle Repaid';
        InterestCaptionLbl: Label 'Interest';
        Remaining_DebtCaptionLbl: Label 'Remaining Debt';
        MonthlyCaptionLbl: Label 'Monthly';
        Loan_Types_CodeCaptionLbl: Label 'Loan Type';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
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


report 51158 "Net Payments"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Net Payments.rdlc';
    UseRequestPage = true;

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(TitleText; TitleText)
            {
            }
            column(Description_______; Description + ' :')
            {
            }
            column(Periods_Status; Status)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Amount__LCY_Caption; Amount__LCY_CaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Total_Deduction__LCY_Caption; Total_Deduction__LCY_CaptionLbl)
            {
            }
            column(Total_Payable__LCY_Caption; Total_Payable__LCY_CaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
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
                RequestFilterFields = "No.", "Mode of Payment";
                column(Employee_No_; "No.")
                {
                }
                dataitem("Payroll Header"; 51159)
                {
                    DataItemLink = "Employee No." = FIELD("No.");
                    DataItemTableView = SORTING("Payroll ID", "Employee No.");
                    column(Amount; Amount)
                    {
                    }
                    column(Payroll_Header__Employee_no__; "Employee no.")
                    {
                    }
                    column(Payroll_Header__Total_Payable__LCY__; "Total Payable (LCY)")
                    {
                    }
                    column(Payroll_Header__Total_Deduction__LCY__; "Total Deduction (LCY)")
                    {
                    }
                    column(Name; Name)
                    {
                    }
                    column(Payroll_Header_Payroll_ID; "Payroll ID")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "Payroll Header".CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)");
                        Amount := "Payroll Header"."Total Payable (LCY)" - "Payroll Header"."Total Deduction (LCY)";

                        "Payroll Header".CALCFIELDS("Total Payable (LCY)", "Total Deduction (LCY)", "Total Rounding Pmts (LCY)",
                          "Total Rounding Ded (LCY)");
                        Amount := "Payroll Header"."Total Payable (LCY)" + "Payroll Header"."Total Rounding Pmts (LCY)" -
                                  ("Payroll Header"."Total Deduction (LCY)" + "Payroll Header"."Total Rounding Ded (LCY)");

                        IF Amount <= 0 THEN
                            IF NOT OverdrawnOnly THEN
                                CurrReport.SKIP
                            ELSE
                                TotalAmount := TotalAmount + Amount
                        ELSE
                            IF OverdrawnOnly THEN
                                CurrReport.SKIP
                            ELSE
                                TotalAmount := TotalAmount + Amount;

                        EmpCount := EmpCount + 1;

                        TotalPayable := TotalPayable + "Payroll Header"."Total Payable (LCY)";
                        TotalDeduction := TotalDeduction + "Payroll Header"."Total Deduction (LCY)";
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Payroll ID", Periods."Period ID");
                        SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Name := Employee.FullName;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }
            dataitem(DataItem5444; 2000000026)
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(TotalAmount; TotalAmount)
                {
                }
                column(Total_Employees____FORMAT_EmpCount_; 'Total Employees ' + FORMAT(EmpCount))
                {
                }
                column(TotalPayable; TotalPayable)
                {
                }
                column(TotalDeduction; TotalDeduction)
                {
                }
                column(Integer_Number; Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                TitleText := 'Net Payments For ' + Periods.Description;
                TotalAmount := 0;
                TotalPayable := 0;
                TotalDeduction := 0;
                EmpCount := 0;
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
            area(content)
            {
                group(Group)
                {
                    field("Print only Over drawn"; OverdrawnOnly)
                    {
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
    end;

    var
        Name: Text[60];
        Amount: Decimal;
        TotalAmount: Decimal;
        PayableAmount: Decimal;
        DeductionAmount: Decimal;
        TitleText: Text[60];
        OverdrawnOnly: Boolean;
        EmpCount: Integer;
        TotalPayable: Decimal;
        TotalDeduction: Decimal;
        gvAllowedPayrolls: Record 51182;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Amount__LCY_CaptionLbl: Label 'Amount (LCY)';
        NameCaptionLbl: Label 'Name';
        Total_Deduction__LCY_CaptionLbl: Label 'Total Deduction (LCY)';
        Total_Payable__LCY_CaptionLbl: Label 'Total Payable (LCY)';
        No_CaptionLbl: Label 'No.';

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


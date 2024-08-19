report 51174 "Company Payslip Dept"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Company Payslip Dept.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                ORDER(Ascending)
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(TotalPayrollbyDepartment; 'Total Payroll by Department')
            {
            }
            column(PeriodID_Periods; "Period ID")
            {
            }
            column(PeriodMonth_Periods; "Period Month")
            {
            }
            column(Periods_Period_Year; "Period Year")
            {
            }
            column(Periods_Payroll_Code; "Payroll Code")
            {
            }
            dataitem("Dimension Value"; 349)
            {
                DataItemTableView = SORTING("Dimension Code", Code)
                                    ORDER(Ascending)
                                    WHERE("Global Dimension No." = CONST(1));
                RequestFilterFields = "Dimension Code", "Code";
                column(NamePayslip; Name + ' Payslip')
                {
                }
                column(Code_DimensionValue; Code)
                {
                }
                column(Dimension_Value_Dimension_Code; "Dimension Code")
                {
                }
                dataitem("Payslip Group"; 51173)
                {
                    DataItemTableView = SORTING(Code);
                    column(HeadingText_PayslipGroup; "Heading Text")
                    {
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(ABSTotalAmountDec; ABS(TotalAmountDec))
                    {
                    }
                    column(NetPay; NetPay)
                    {
                    }
                    column(Payslip_Group_Code; Code)
                    {
                    }
                    dataitem("Payslip Lines"; 51174)
                    {
                        DataItemLink = "Payslip Group" = FIELD(Code);
                        DataItemTableView = SORTING("Line No.", "Payslip Group");
                        column(Payslip_Lines_Line_No_; "Line No.")
                        {
                        }
                        column(Payslip_Lines_Payslip_Group; "Payslip Group")
                        {
                        }
                        column(Payslip_Lines_Payroll_Code; "Payroll Code")
                        {
                        }
                        column(Payslip_Lines_E_D_Code; "E/D Code")
                        {
                        }
                        dataitem("Payroll Lines"; 51160)
                        {
                            DataItemLink = "ED Code" = FIELD("E/D Code");
                            DataItemTableView = SORTING("Entry No.");
                            RequestFilterFields = "Employee No.";
                            column(ABSAmount; ABS(Amount))
                            {
                            }
                            column(DisplayText; DisplayText)
                            {
                            }
                            column(Payroll_Lines_Entry_No_; "Entry No.")
                            {
                            }
                            column(Payroll_Lines_ED_Code; "ED Code")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                EDDefRec.GET("ED Code");

                                IF EDDefRec.Cumulative THEN BEGIN
                                    EmployeeRec.SETRANGE("ED Code Filter", EDDefRec."ED Code");
                                    EmployeeRec.SETRANGE("Date Filter", PeriodRec."Start Date", Periods."End Date");
                                    EmployeeRec.CALCFIELDS("Amount To Date");
                                    CumilativeDec := EmployeeRec."Amount To Date";
                                END ELSE
                                    CumilativeDec := 0;

                                CASE EDDefRec."Calculation Group" OF
                                    EDDefRec."Calculation Group"::None:
                                        Amount := 0;
                                    EDDefRec."Calculation Group"::Deduction:
                                        Amount := -Amount;
                                END;

                                TotalAmountDec := TotalAmountDec + Amount;
                                NetPay := NetPay + Amount;
                                DisplayText := EDDefRec.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                                SETRANGE("Global Dimension 1 Code", "Dimension Value".Code);
                                SETRANGE("Payroll ID", Periods."Period ID");

                                CurrReport.CREATETOTALS(Amount);
                                RPtHeader := "Dimension Value".Name + ' Payslip';
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF "Line Type" = 1 THEN BEGIN
                                CASE P9 OF
                                    P9::A:
                                        Amount := HeaderRec."A (LCY)";
                                    P9::B:
                                        Amount := HeaderRec."B (LCY)";
                                    P9::C:
                                        Amount := HeaderRec."C (LCY)";
                                    P9::D:
                                        Amount := HeaderRec."D (LCY)";
                                    P9::E1:
                                        Amount := HeaderRec."E1 (LCY)";
                                    P9::E2:
                                        Amount := HeaderRec."E2 (LCY)";
                                    P9::E3:
                                        Amount := HeaderRec."E3 (LCY)";
                                    P9::F:
                                        Amount := HeaderRec."F (LCY)";
                                    P9::G:
                                        Amount := HeaderRec."G (LCY)";
                                    P9::H:
                                        Amount := HeaderRec."H (LCY)";
                                    P9::J:
                                        Amount := HeaderRec."J (LCY)";
                                    P9::K:
                                        Amount := HeaderRec."K (LCY)";
                                    P9::L:
                                        Amount := HeaderRec."L (LCY)";
                                    P9::M:
                                        Amount := HeaderRec."M (LCY)";
                                END;
                            END;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                            CurrReport.CREATETOTALS(Amount);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TotalText := 'Total ' + "Payslip Group"."Heading Text";
                        TotalAmountDec := 0;
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
                }

                trigger OnAfterGetRecord()
                begin
                    TotalAmountDec := 0;
                    NetPay := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                MonthText := Periods.Description;
                IF DeptCode <> '' THEN BEGIN
                    DeptRec.SETFILTER("Global Dimension No.", '1');
                    DeptRec.GET(DeptCode);
                    RPtHeader := DeptRec.Name + ' Payslip';
                END ELSE
                    RPtHeader := COMPANYNAME + ' Payslip';
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
        PayrollSetupRec.GET(gvAllowedPayrolls."Payroll Code");
        CompanyNameText := PayrollSetupRec."Employer Name";

        PeriodRec.SETCURRENTKEY("Start Date");
        PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        PeriodRec.FIND('-');
    end;

    var
        PeriodRec: Record 51151;
        EmployeeRec: Record 5200;
        PayrollSetupRec: Record 51165;
        HeaderRec: Record 51159;
        EDDefRec: Record 51158;
        TotalText: Text[60];
        NetPayText: Text[60];
        MonthText: Text[60];
        EmploNameText: Text[100];
        CompanyNameText: Text[100];
        TotalAmountDec: Decimal;
        NetPaydec: Decimal;
        CumilativeDec: Decimal;
        EmplankAccount: Record 51152;
        EmpBank: Text[100];
        DisplayText: Text[100];
        DeptCode: Code[10];
        RPtHeader: Text[100];
        DeptRec: Record 349;
        NetPay: Decimal;
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


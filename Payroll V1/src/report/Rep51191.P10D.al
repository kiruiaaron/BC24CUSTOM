report 51191 P10D
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/P10D.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
            column(EmployeeNo; Employee."No.")
            {
            }
            column(EmployeePIN; Employee.PIN)
            {
            }
            column(EmployeeName; Employee.FullName)
            {
            }
            column(EmployerPIN; PayrollSetup."Employer PIN No.")
            {
            }
            column(EmployerName; PayrollSetup."Employer Name")
            {
            }
            column(TotalWCPS; TotalWCPS)
            {
            }
            column(FringeTax; FringeTax)
            {
            }
            column(TotalOthers; TotalOthers)
            {
            }
            column(TaxLogo; PayrollSetup."KRA Tax Logo")
            {
            }
            column(QtrEndingDate; QtrEndingDate)
            {
            }
            column(Year; Year)
            {
            }
            dataitem("Payroll Header"; 51159)
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = SORTING("Payroll ID", "Employee No.");
                column(TotalGrossPay; "Payroll Header"."D (LCY)")
                {
                }
                column(TotalPAYE; "Payroll Header"."L (LCY)")
                {
                }
                column(PayrollHeaderEmpNo; "Payroll Header"."Employee no.")
                {
                }

                trigger OnPreDataItem()
                begin
                    "Payroll Header".SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    "Payroll Header".SETFILTER("Payroll ID", PeriodFilter);
                    "Payroll Header".SETRANGE("Employee no.", Employee."No.");
                end;
            }

            trigger OnPreDataItem()
            begin
                gsSegmentPayrollData;
                Employee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
                PayrollSetup.CALCFIELDS("KRA Tax Logo");


                Period.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                Period.SETRANGE("Period Year", Year);
                IF Quarter2 = Quarter2::"1" THEN BEGIN
                    QtrEndingDate := '31/03';
                    Period.SETFILTER("Period Month", '%1|%2|%3', 1, 2, 3)
                END ELSE
                    IF Quarter2 = Quarter2::"2" THEN BEGIN
                        QtrEndingDate := '30/06';
                        Period.SETFILTER("Period Month", '%1|%2|%3', 4, 5, 6)
                    END ELSE
                        IF Quarter2 = Quarter2::"3" THEN BEGIN
                            QtrEndingDate := '30/09';
                            Period.SETFILTER("Period Month", '%1|%2|%3', 7, 8, 9)
                        END ELSE BEGIN
                            QtrEndingDate := '31/12';
                            Period.SETFILTER("Period Month", '%1|%2|%3', 10, 11, 12);
                        END;

                Period.FINDFIRST;
                REPEAT
                    IF PeriodFilter <> '' THEN
                        PeriodFilter := PeriodFilter + '|' + Period."Period ID"
                    ELSE
                        PeriodFilter := Period."Period ID";
                UNTIL Period.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(TotalWCPS; TotalWCPS)
                    {
                        BlankZero = true;
                        Caption = 'Total WCPS';
                        ApplicationArea = All;
                    }
                    field(FringeTax; FringeTax)
                    {
                        BlankZero = true;
                        Caption = 'Fringe Benefit Tax';
                        ApplicationArea = All;
                    }
                    field(TotalOthers; TotalOthers)
                    {
                        BlankZero = true;
                        Caption = 'Tax Lumpsum/Audit/Penalty/Int';
                        ApplicationArea = All;
                    }
                    field(Quarter2; Quarter2)
                    {
                        Caption = 'Quarter';
                        ApplicationArea = All;
                    }
                    field(Year; Year)
                    {
                        BlankZero = true;
                        Caption = 'Year';
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
        IF Quarter2 = 0 THEN ERROR('Quarter must be specified');
        IF Year = 0 THEN ERROR('Year must be specified');
    end;

    var
        EmployeeGrossPay: Decimal;
        EmployeeTax: Decimal;
        gvAllowedPayrolls: Record 51182;
        DateFilter: Date;
        TotalWCPS: Decimal;
        FringeTax: Decimal;
        TotalOthers: Decimal;
        PayrollSetup: Record 51165;
        Quarter2: Option "0","1","2","3","4";
        Year: Integer;
        Period: Record 51151;
        PeriodFilter: Text[30];
        QtrEndingDate: Text[5];

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


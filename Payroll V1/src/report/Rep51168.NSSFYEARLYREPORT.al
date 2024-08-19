report 51168 "NSSF YEARLY REPORT"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/NSSF YEARLY REPORT.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            column(HEADER_1_; HEADER[1])
            {
            }
            column(HEADER_2_; HEADER[2])
            {
            }
            column(HEADER_3_; HEADER[3])
            {
            }
            column(HEADER_4_; HEADER[4])
            {
            }
            column(HEADER_5_; HEADER[5])
            {
            }
            column(HEADER_6_; HEADER[6])
            {
            }
            column(TOTAL_; 'TOTAL')
            {
            }
            column(HEADER_12_; HEADER[12])
            {
            }
            column(HEADER_11_; HEADER[11])
            {
            }
            column(HEADER_10_; HEADER[10])
            {
            }
            column(HEADER_9_; HEADER[9])
            {
            }
            column(HEADER_8_; HEADER[8])
            {
            }
            column(HEADER_7_; HEADER[7])
            {
            }
            column(FOR_YEAR______FORMAT_Year_; 'FOR YEAR: ' + FORMAT(Year))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(NSSFMonthAmt_1_; NSSFMonthAmt[1])
            {
            }
            column(NSSFMonthAmt_2_; NSSFMonthAmt[2])
            {
            }
            column(NSSFMonthAmt_3_; NSSFMonthAmt[3])
            {
            }
            column(NSSFMonthAmt_4_; NSSFMonthAmt[4])
            {
            }
            column(NSSFMonthAmt_5_; NSSFMonthAmt[5])
            {
            }
            column(NSSFMonthAmt_12_; NSSFMonthAmt[12])
            {
            }
            column(NSSFMonthAmt_11_; NSSFMonthAmt[11])
            {
            }
            column(NSSFMonthAmt_10_; NSSFMonthAmt[10])
            {
            }
            column(NSSFMonthAmt_9_; NSSFMonthAmt[9])
            {
            }
            column(NSSFMonthAmt_8_; NSSFMonthAmt[8])
            {
            }
            column(NSSFMonthAmt_7_; NSSFMonthAmt[7])
            {
            }
            column(DataItem1101951051; NSSFMonthAmt[1] + NSSFMonthAmt[2] + NSSFMonthAmt[3] + NSSFMonthAmt[4] + NSSFMonthAmt[5] + NSSFMonthAmt[6] + NSSFMonthAmt[7] + NSSFMonthAmt[8] + NSSFMonthAmt[9] + NSSFMonthAmt[10] + NSSFMonthAmt[11] + NSSFMonthAmt[12])
            {
            }
            column(First_Name___________Middle_Name___________Last_Name_; "First Name" + ' ' + "Middle Name" + ' ' + "Last Name")
            {
            }
            column(NSSFMonthAmt_6_; NSSFMonthAmt[6])
            {
            }
            column(Employee__Social_Security_No__; "Social Security No.")
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(NSSFMonthAmt_1__Control1101951100; NSSFMonthAmt[1])
            {
            }
            column(NSSFMonthAmt_2__Control1101951101; NSSFMonthAmt[2])
            {
            }
            column(NSSFMonthAmt_3__Control1101951102; NSSFMonthAmt[3])
            {
            }
            column(NSSFMonthAmt_4__Control1101951103; NSSFMonthAmt[4])
            {
            }
            column(NSSFMonthAmt_5__Control1101951104; NSSFMonthAmt[5])
            {
            }
            column(NSSFMonthAmt_12__Control1101951112; NSSFMonthAmt[12])
            {
            }
            column(NSSFMonthAmt_11__Control1101951113; NSSFMonthAmt[11])
            {
            }
            column(NSSFMonthAmt_10__Control1101951115; NSSFMonthAmt[10])
            {
            }
            column(NSSFMonthAmt_9__Control1101951118; NSSFMonthAmt[9])
            {
            }
            column(NSSFMonthAmt_8__Control1101951120; NSSFMonthAmt[8])
            {
            }
            column(NSSFMonthAmt_7__Control1101951121; NSSFMonthAmt[7])
            {
            }
            column(DataItem1101951124; NSSFMonthAmt[1] + NSSFMonthAmt[2] + NSSFMonthAmt[3] + NSSFMonthAmt[4] + NSSFMonthAmt[5] + NSSFMonthAmt[6] + NSSFMonthAmt[7] + NSSFMonthAmt[8] + NSSFMonthAmt[9] + NSSFMonthAmt[10] + NSSFMonthAmt[11] + NSSFMonthAmt[12])
            {
            }
            column(NSSFMonthAmt_6__Control1101951126; NSSFMonthAmt[6])
            {
            }
            column(NSSF_YEARLY_REPORTCaption; NSSF_YEARLY_REPORTCaptionLbl)
            {
            }
            column(NAMECaption; NAMECaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Emp_No_Caption; Emp_No_CaptionLbl)
            {
            }
            column(NSSF_NO_Caption; NSSF_NO_CaptionLbl)
            {
            }
            column(TOTALSCaption; TOTALSCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF ("Termination Date" <> 0D) THEN
                    IF (DATE2DMY("Termination Date", 3) < Year) THEN CurrReport.SKIP;

                i := 0;
                IF PeriodRec.FIND('-') THEN
                    REPEAT
                        i := i + 1;
                        HEADER[i] := PeriodRec.Description;
                        PayrollHeader.RESET;
                        PayrollHeader.SETCURRENTKEY("Employee no.", "Payroll Year", "Payroll Month");
                        PayrollHeader.ASCENDING(FALSE);
                        PayrollHeader.SETRANGE("Employee no.", "No.");
                        PayrollHeader.SETRANGE("Payroll Year", Year);
                        PayrollHeader.SETRANGE("Payroll Month", PeriodRec."Period Month");
                        IF PayrollHeader.FIND('-') THEN
                            REPEAT
                                SETFILTER("Date Filter", '%1..%2', PeriodRec."Start Date", PeriodRec."End Date");

                                //Employee NSSF Contribution
                                SETFILTER("ED Code Filter", PayrollSetup."NSSF ED Code");
                                CALCFIELDS(Amount);
                                NSSFMonthAmt[i] := Amount;

                                //Employer NSSF Contribution
                                SETFILTER("ED Code Filter", PayrollSetup."NSSF Company Contribution");
                                CALCFIELDS(Amount);
                                NSSFMonthAmt[i] += Amount;
                            UNTIL PayrollHeader.NEXT = 0;
                    UNTIL PeriodRec.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                PeriodRec.SETCURRENTKEY("Start Date");
                PeriodRec.ASCENDING(TRUE);
                PeriodRec.SETRANGE("Period Year", Year);
                PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                CurrReport.CREATETOTALS(NSSFMonthAmt);
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
                    field(Year; Year)
                    {
                        Caption = 'Year';
                        TableRelation = Year.Year;
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
        IF Year = 0 THEN ERROR('You must specify the Year on the options tab');
        PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
    end;

    var
        Year: Integer;
        YearRec: Record 51150;
        PayrollHeader: Record 51159;
        ColumnD: Decimal;
        ColumnL: Decimal;
        PayrollSetup: Record 51165;
        NSSFMonthAmt: array[12] of Decimal;
        i: Integer;
        HEADER: array[12] of Text[30];
        PeriodRec: Record 51151;
        gvAllowedPayrolls: Record 51182;
        NSSF_YEARLY_REPORTCaptionLbl: Label 'NSSF YEARLY REPORT';
        NAMECaptionLbl: Label 'NAME';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Emp_No_CaptionLbl: Label 'Emp No.';
        NSSF_NO_CaptionLbl: Label 'NSSF NO.';
        TOTALSCaptionLbl: Label 'TOTALS';

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


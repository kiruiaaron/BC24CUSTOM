report 51167 CBS
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/CBS.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
            column(MaleTotals6; MaleTotals[6])
            {
            }
            column(MaleTotals5; MaleTotals[5])
            {
            }
            column(MaleTotals4; MaleTotals[4])
            {
            }
            column(MaleTotals3; MaleTotals[3])
            {
            }
            column(MaleTotals2; MaleTotals[2])
            {
            }
            column(MaleTotals1; MaleTotals[1])
            {
            }
            column(FemaleTotals6; FemaleTotals[6])
            {
            }
            column(FemaleTotals5; FemaleTotals[5])
            {
            }
            column(FemaleTotals4; FemaleTotals[4])
            {
            }
            column(FemaleTotals3; FemaleTotals[3])
            {
            }
            column(FemaleTotals2; FemaleTotals[2])
            {
            }
            column(FemaleTotals1; FemaleTotals[1])
            {
            }
            column(MaleTotals1MaleTotals2MaleTotals3MaleTotals4MaleTotals5MaleTotals6; MaleTotals[1] + MaleTotals[2] + MaleTotals[3] + MaleTotals[4] + MaleTotals[5] + MaleTotals[6])
            {
            }
            column(FemaleTotals1FemaleTotals2FemaleTotals3FemaleTotals4FemaleTotals5FemaleTotals6; FemaleTotals[1] + FemaleTotals[2] + FemaleTotals[3] + FemaleTotals[4] + FemaleTotals[5] + FemaleTotals[6])
            {
            }
            column(FemaleTotals1MaleTotals1; FemaleTotals[1] + MaleTotals[1])
            {
            }
            column(FemaleTotals2MaleTotals2; FemaleTotals[2] + MaleTotals[2])
            {
            }
            column(FemaleTotals3MaleTotals3; FemaleTotals[3] + MaleTotals[3])
            {
            }
            column(FemaleTotals4MaleTotals4; FemaleTotals[4] + MaleTotals[4])
            {
            }
            column(FemaleTotals5MaleTotals5; FemaleTotals[5] + MaleTotals[5])
            {
            }
            column(FemaleTotals6MaleTotals6; FemaleTotals[6] + MaleTotals[6])
            {
            }
            column(DataItem1101951050; FemaleTotals[1] + FemaleTotals[2] + FemaleTotals[3] + FemaleTotals[4] + FemaleTotals[5] + FemaleTotals[6] + MaleTotals[1] + MaleTotals[2] + MaleTotals[3] + MaleTotals[4] + MaleTotals[5] + MaleTotals[6])
            {
            }
            column(Employee_No_; "No.")
            {
            }
            dataitem("Payroll Header"; 51159)
            {
                DataItemLink = "Employee No." = FIELD("No.");
                column(HEADER1; HEADER[1])
                {
                }
                column(HEADER2; HEADER[2])
                {
                }
                column(HEADER3; HEADER[3])
                {
                }
                column(HEADER4; HEADER[4])
                {
                }
                column(HEADER5; HEADER[5])
                {
                }
                column(HEADER6; HEADER[6])
                {
                }
                column(TOTAL; 'TOTAL')
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ColumnD := ColumnD + "D (LCY)";
                    ColumnL := ColumnL + "L (LCY)";
                end;

                trigger OnPostDataItem()
                begin
                    i := 0;
                    LookUpLines.RESET;
                    LookUpLines.SETRANGE("Table ID", PayrollSetup."Income Brackets Rate");
                    IF LookUpLines.FIND('-') THEN
                        REPEAT
                            i := i + 1;
                            HEADER[i] := FORMAT(LookUpLines."Lower Amount (LCY)") + ' TO ' + FORMAT(LookUpLines."Upper Amount (LCY)");
                            IF ((ColumnD / 20 >= LookUpLines."Lower Amount (LCY)") AND (ColumnD / 20 <= LookUpLines."Upper Amount (LCY)")) THEN BEGIN
                                IF Employee.Gender = Employee.Gender::Male THEN
                                    MaleTotals[i] := MaleTotals[i] + 1
                                ELSE
                                    FemaleTotals[i] := FemaleTotals[i] + 1;
                            END;
                        UNTIL LookUpLines.NEXT = 0;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    PayrollHeader.SETRANGE("Payroll Year", Year);
                    PayrollHeader.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ColumnD := 0;
                ColumnL := 0;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                CurrReport.CREATETOTALS(ColumnD, ColumnL);
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
        IF Year = 0 THEN ERROR(' You must specify the Year under the options tab');
        PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
    end;

    var
        Year: Integer;
        YearRec: Record 51150;
        PayrollHeader: Record 51159;
        ColumnD: Decimal;
        ColumnL: Decimal;
        PayrollSetup: Record 51165;
        "INT/PENALTY": Decimal;
        MaleTotals: array[6] of Integer;
        LookUpLines: Record 51163;
        FemaleTotals: array[6] of Integer;
        i: Integer;
        HEADER: array[6] of Text[30];
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


/// <summary>
/// Codeunit Open Period (ID 51150).
/// </summary>
codeunit 51150 "Open Period"
{
    // Permissions = TableData 52021050 = ri;

    trigger OnRun()
    begin
        gvPayrollUtilities.sGetActivePayroll(gvAllowedPayrolls);
        PeriodTable.SETCURRENTKEY("Start Date");
        PeriodTable.SETRANGE(Status, 0);
        PeriodTable.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

        PeriodTable.FIND('-');
        PeriodeText := PeriodTable.Description;
        IF CONFIRM('Do you want to open period\%1', FALSE, PeriodeText) THEN BEGIN
            Period := PeriodTable."Period ID";
            Month := PeriodTable."Period Month";
            Year := PeriodTable."Period Year";

            PeriodTable.RESET;
            PeriodTable.SETCURRENTKEY("Start Date");
            PeriodTable.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
            PeriodTable.GET(Period, Month, Year, gvAllowedPayrolls."Payroll Code");
            IF PeriodTable.FIND('<') THEN BEGIN
                PreviousPeriod := PeriodTable."Period ID";

                Window.OPEN('Making Payroll Header    #1######\' +
                            'Making Payroll Entries   #2######');

                MakePayrollHeader;
                MakePayrollLines;
                SetPeriodToOpen;
            END ELSE BEGIN
                Window.OPEN('Making Payroll Header... #1######\');

                MakePayrollHeader;
                SetPeriodToOpen;
            END;
            Window.CLOSE;
        END;
    end;

    var
        Employee: Record Employee;
        PeriodTable: Record Periods;
        PeriodeText: Text[50];
        Period: Code[10];
        PreviousPeriod: Code[10];
        Window: Dialog;
        WindowCount: Integer;
        Month: Integer;
        Year: Integer;
        LineNo: Integer;
        gvAllowedPayrolls: Record "Allowed Payrolls";
        gvPayrollUtilities: Codeunit 51152;

    /// <summary>
    /// MakePayrollHeader.
    /// </summary>
    procedure MakePayrollHeader()
    var
        Header: Record "Payroll Header";
        lvPeriodTable: Record Periods;
    begin
        Header.LOCKTABLE(TRUE);
        Employee.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        Employee.FIND('-');
        WindowCount := 0;
        lvPeriodTable.GET(Period, Month, Year, gvAllowedPayrolls."Payroll Code");
        Employee.TESTFIELD("Employment Date");
        REPEAT
            IF (Employee.Status = Employee.Status::Active) AND (Employee."Employment Date" <= lvPeriodTable."End Date") THEN BEGIN
                WindowCount := WindowCount + 1;
                Window.UPDATE(1, WindowCount);
                Header."Payroll ID" := Period;
                Header."Employee no." := Employee."No.";
                Header."Payroll Month" := Month;
                Header."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                Header."Payroll Year" := Year;
                Header."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                Header."Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
                Header.INSERT(TRUE);
            END;
        UNTIL Employee.NEXT = 0;
    end;

    procedure MakePayrollLines()
    var
        OldLines: Record "Payroll Entry";
        NewLines: Record "Payroll Entry";
        EDdef: Record "ED Definitions";
        lvPeriod: Record Periods;
    begin
        OldLines.LOCKTABLE(TRUE);
        IF OldLines.FIND('+') THEN
            LineNo := OldLines."Entry No."
        ELSE
            LineNo := 0;

        lvPeriod.GET(Period, Month, Year, gvAllowedPayrolls."Payroll Code");

        //Copy Payroll Lines without expiry date
        OldLines.SETRANGE(OldLines."Copy to next", TRUE);
        OldLines.SETRANGE("Payroll ID", PreviousPeriod);
        OldLines.SETRANGE("ED Expiry Date", 0D);
        OldLines.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

        IF OldLines.FIND('-') THEN BEGIN
            WindowCount := 0;
            REPEAT
                EDdef.GET(OldLines."ED Code");
                IF Employee.GET(OldLines."Employee No.") THEN
                    IF (Employee.Status = Employee.Status::Active) AND (Employee."Employment Date" <= lvPeriod."End Date") THEN BEGIN
                        WindowCount := WindowCount + 1;
                        Window.UPDATE(2, WindowCount);
                        LineNo := LineNo + 1;
                        NewLines.COPY(OldLines);
                        NewLines."Payroll ID" := Period;
                        NewLines."Entry No." := LineNo;
                        //ICS March 2017
                        NewLines."Staff Vendor Entry" := OldLines."Staff Vendor Entry";
                        //ICS March 2017
                        IF EDdef."Reset Amount" = TRUE THEN BEGIN
                            NewLines.Amount := 0;
                            NewLines.Quantity := 0;
                        END;
                        NewLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                        NewLines.INSERT(TRUE);
                    END;
            UNTIL OldLines.NEXT = 0;
        END;

        //Copy none expired payroll entries
        OldLines.SETFILTER("ED Expiry Date", '>=%1', lvPeriod."Start Date");

        IF OldLines.FIND('-') THEN BEGIN
            WindowCount := 0;
            REPEAT
                EDdef.GET(OldLines."ED Code");
                IF Employee.GET(OldLines."Employee No.") THEN
                    IF (Employee.Status = Employee.Status::Active) AND (Employee."Employment Date" <= lvPeriod."End Date") THEN BEGIN
                        WindowCount := WindowCount + 1;
                        Window.UPDATE(2, WindowCount);
                        LineNo := LineNo + 1;
                        NewLines.COPY(OldLines);
                        NewLines."Payroll ID" := Period;
                        NewLines."Entry No." := LineNo;
                        //ICS March 2017
                        NewLines."Staff Vendor Entry" := OldLines."Staff Vendor Entry";
                        //ICS March 2017
                        IF EDdef."Reset Amount" = TRUE THEN BEGIN
                            NewLines.Amount := 0;
                            NewLines.Quantity := 0;
                        END;
                        NewLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                        NewLines.INSERT(TRUE);
                    END;
            UNTIL OldLines.NEXT = 0;
        END;
    end;

    procedure SetPeriodToOpen()
    var
        PeriodTable: Record 51151;
    begin
        PeriodTable.GET(Period, Month, Year, gvAllowedPayrolls."Payroll Code");
        PeriodTable.Status := PeriodTable.Status::Open;
        PeriodTable.MODIFY;
    end;
}


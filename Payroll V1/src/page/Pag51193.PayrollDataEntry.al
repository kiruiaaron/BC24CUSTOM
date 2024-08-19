page 51193 "Payroll Data Entry"
{
    PageType = Document;
    Permissions = TableData 51191 = rimd;

    layout
    {
        area(content)
        {
            field(gvPeriodFilter; gvPeriodFilter)
            {
                Caption = 'Period Filter';
                TableRelation = Periods."Period ID" WHERE(Status = CONST(Open));
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    gvPeriodFilterOnAfterValidate;
                end;
            }
            part(SubFrm; 51194)
            {
                SubPageView = SORTING("Payroll ID", "Employee No.", "ED Code")
                              ORDER(Ascending);
                ApplicationArea = All;
            }
            field(gvEDFilter; gvEDFilter)
            {
                Caption = 'ED Filter';
                TableRelation = "ED Definitions"."ED Code" WHERE("System Created" = CONST(False));
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    gvEDFilterOnAfterValidate;
                end;
            }
            field(gvEmployeeFilter; gvEmployeeFilter)
            {
                Caption = 'Employee Filter';
                TableRelation = Employee."No.";
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    gvEmployeeFilterOnAfterValidat;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Insert Batch...")
                {
                    Caption = 'Insert Batch...';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        lvRptInsertBatch: Report 51153;
                    begin
                        lvRptInsertBatch.RUNMODAL;
                    end;
                }
                separator(sep1)
                {
                }
                action("Compute Over Time")
                {
                    Caption = 'Compute Over Time';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PeriodStartDate: Date;
                        PeriodEndDate: Date;
                        lvEmp: Record 5200;
                        lvEmpCalendar: Code[10];
                    begin
                        CLEAR(OTHours);
                        CLEAR(OTNonWork);
                        CLEAR(OTHoliday);
                        CLEAR(OTNormal);
                        CLEAR(NonWrkAmt);
                        CLEAR(HoliAmt);
                        CLEAR(NormalAmt);
                        CLEAR(TotalOTAmount);
                        gvAllowedPayrolls.RESET;
                        gvAllowedPayrolls.SETRANGE(gvAllowedPayrolls."User ID", USERID);
                        gvAllowedPayrolls.SETRANGE(gvAllowedPayrolls."Last Active Payroll", TRUE);
                        IF gvAllowedPayrolls.FINDFIRST THEN
                            ActPayrollID := gvAllowedPayrolls."Payroll Code";

                        EmpRec.RESET;
                        EmpRec.SETRANGE(EmpRec."Payroll Code", ActPayrollID);
                        EmpRec.SETRANGE(EmpRec.Status, EmpRec.Status::Active);
                        IF EmpRec.FINDFIRST THEN
                            REPEAT
                                EmpGrade.RESET;
                                EmpGrade.SETRANGE(EmpGrade."Grade Code", EmpRec."Employee Grade");
                                EmpGrade.SETRANGE(EmpGrade."OT Qualifying", TRUE);
                                IF EmpGrade.FINDFIRST THEN
                                    REPEAT
                                        //ThisWeek := DATE2DWY(TODAY,2);
                                        //PrevWeekFrom := DWY2DATE(1,ThisWeek-1,DATE2DWY(TODAY,3));
                                        //PrevWeekTo := DWY2DATE(7,ThisWeek-1,DATE2DWY(TODAY,3));
                                        Period.RESET;
                                        Period.SETRANGE(Period."Period Month", DATE2DMY(TODAY, 2));
                                        Period.SETRANGE(Period."Period Year", DATE2DMY(TODAY, 3));
                                        IF Period.FINDFIRST THEN BEGIN
                                            PayRID := Period."Period ID";
                                            PeriodStartDate := Period."Start Date";
                                            PeriodEndDate := Period."End Date";
                                        END;
                                        CLEAR(OTHours);
                                        CLEAR(OTNonWork);
                                        CLEAR(OTHoliday);
                                        CLEAR(OTNormal);
                                        TimeRegR.RESET;
                                        TimeRegR.SETRANGE(TimeRegR."Employee No.", EmpRec."No.");
                                        TimeRegR.SETFILTER(TimeRegR.Quantity, '<>%1', 0);
                                        TimeRegR.SETRANGE(TimeRegR."From Date", PeriodStartDate, PeriodEndDate);
                                        IF TimeRegR.FINDFIRST THEN
                                            REPEAT
                                                CauseofAbs.RESET;
                                                CauseofAbs.SETRANGE(CauseofAbs.Code, TimeRegR."Cause of Absence Code");
                                                IF CauseofAbs.FINDFIRST THEN BEGIN
                                                    EDDef.RESET;
                                                    // EDDef.SETRANGE(EDDef."ED Code", CauseofAbs."E/D Code");
                                                    IF EDDef.FINDFIRST THEN BEGIN
                                                        IF EDDef."Calculation Group" = EDDef."Calculation Group"::Payments THEN
                                                            ActualWeeklyHours += TimeRegR.Quantity;
                                                        //RGK Get employee's base calendar
                                                        //lvEmpCalendar:=EmpRec."Base Calendar Code";
                                                        //end RGK Get employee's base calendar
                                                        /* HRBaseCalender.RESET;
                                                         HRBaseCalender.SETRANGE(HRBaseCalender."Base Calendar Code",lvEmpCalendar);
                                                         HRBaseCalender.SETRANGE(HRBaseCalender.Date,TimeRegR."From Date");
                                                         IF HRBaseCalender.FINDFIRST THEN BEGIN
                                                           IF HRBaseCalender.Nonworking THEN
                                                             OTNonWork += TimeRegR.Quantity
                                                           ELSE IF HRBaseCalender.Holiday THEN
                                                             OTHoliday +=TimeRegR.Quantity
                                                           ELSE BEGIN
                                                             OTNormal += TimeRegR.Quantity - HRBaseCalender."Max Daily Working Hrs";
                                                           END;
                                                         END; */
                                                    END;
                                                END;
                                            /*
                                            Week.RESET;
                                            Week.SETRANGE(Week."As of Date",TimeRegR."From Date");
                                            Week.SETRANGE(Week."Week No.",ThisWeek-1);
                                            IF Week.FINDLAST THEN BEGIN
                                              MaxWeekHrs := Week."Max. Working Hrs";
                                            END;
                                            */
                                            UNTIL TimeRegR.NEXT = 0;
                                        //IF ActualWeeklyHours > MaxWeekHrs THEN BEGIN
                                        //  OTHours := ActualWeeklyHours - MaxWeekHrs;
                                        PayrollSetup.RESET;
                                        PayrollSetup.SETRANGE(PayrollSetup."Payroll Code", ActPayrollID);
                                        IF PayrollSetup.FINDFIRST THEN BEGIN
                                            //OT Non Working days
                                            IF OTNonWork <> 0 THEN BEGIN
                                                IF PayrollSetup."Weekend OT ED" <> '' THEN BEGIN
                                                    EdDefR2.RESET;
                                                    EdDefR2.SETRANGE(EdDefR2."ED Code", PayrollSetup."Weekend OT ED");
                                                    IF EdDefR2.FINDFIRST THEN BEGIN
                                                        NonWrkAmt := OTNonWork * EdDefR2."Overtime ED Weight" * EmpRec."Hourly Rate";
                                                        PayrollEntry.RESET;
                                                        PayrollEntry.SETRANGE(PayrollEntry."ED Code", PayrollSetup."Weekend OT ED");
                                                        PayrollEntry.SETRANGE(PayrollEntry."Employee No.", EmpRec."No.");
                                                        PayrollEntry.SETRANGE(PayrollEntry."Payroll ID", PayRID);
                                                        PayrollEntry.SETRANGE(PayrollEntry.Amount, NonWrkAmt);
                                                        IF NOT PayrollEntry.FINDFIRST THEN BEGIN
                                                            ParollEntry.RESET;
                                                            IF ParollEntry.FINDLAST THEN
                                                                PayrollEntryNo := ParollEntry."Entry No.";
                                                            PayrollEntry."Entry No." := PayrollEntryNo + 1;
                                                            PayrollEntry.VALIDATE("ED Code", EdDefR2."ED Code");
                                                            PayrollEntry.VALIDATE("Payroll ID", PayRID);
                                                            PayrollEntry.VALIDATE("Employee No.", EmpRec."No.");
                                                            PayrollEntry.Quantity := 1;
                                                            PayrollEntry.VALIDATE(PayrollEntry.Rate, NonWrkAmt);
                                                            PayrollEntry.Date := TODAY;
                                                            PayrollEntry.INSERT;
                                                        END;
                                                    END;
                                                END;
                                            END;
                                            //OT Holiday
                                            IF OTHoliday <> 0 THEN BEGIN
                                                IF PayrollSetup."Holiday OT ED" <> '' THEN BEGIN
                                                    EdDefR2.RESET;
                                                    EdDefR2.SETRANGE(EdDefR2."ED Code", PayrollSetup."Holiday OT ED");
                                                    IF EdDefR2.FINDFIRST THEN BEGIN
                                                        HoliAmt := OTHoliday * EdDefR2."Overtime ED Weight" * EmpRec."Hourly Rate";
                                                        PayrollEntry.RESET;
                                                        PayrollEntry.SETRANGE(PayrollEntry."ED Code", PayrollSetup."Holiday OT ED");
                                                        PayrollEntry.SETRANGE(PayrollEntry."Employee No.", EmpRec."No.");
                                                        PayrollEntry.SETRANGE(PayrollEntry."Payroll ID", PayRID);
                                                        PayrollEntry.SETRANGE(PayrollEntry.Amount, HoliAmt);
                                                        IF NOT PayrollEntry.FINDFIRST THEN BEGIN
                                                            ParollEntry.RESET;
                                                            IF ParollEntry.FINDLAST THEN
                                                                PayrollEntryNo := ParollEntry."Entry No.";
                                                            PayrollEntry."Entry No." := PayrollEntryNo + 1;
                                                            PayrollEntry.VALIDATE("ED Code", EdDefR2."ED Code");
                                                            PayrollEntry.VALIDATE("Payroll ID", PayRID);
                                                            PayrollEntry.VALIDATE("Employee No.", EmpRec."No.");
                                                            PayrollEntry.Quantity := 1;
                                                            PayrollEntry.VALIDATE(PayrollEntry.Rate, HoliAmt);
                                                            PayrollEntry.Date := TODAY;
                                                            PayrollEntry.INSERT;
                                                        END;
                                                    END;
                                                END;
                                            END;
                                            CLEAR(NormalAmt);
                                            //OT Normal Working day
                                            IF OTNormal <> 0 THEN BEGIN
                                                IF PayrollSetup."Normal OT ED" <> '' THEN BEGIN
                                                    EdDefR2.RESET;
                                                    EdDefR2.SETRANGE(EdDefR2."ED Code", PayrollSetup."Normal OT ED");
                                                    IF EdDefR2.FINDFIRST THEN BEGIN
                                                        NormalAmt := OTNormal * EdDefR2."Overtime ED Weight" * EmpRec."Hourly Rate";
                                                        PayrollEntry.RESET;
                                                        PayrollEntry.SETRANGE(PayrollEntry."ED Code", PayrollSetup."Normal OT ED");
                                                        PayrollEntry.SETRANGE(PayrollEntry."Employee No.", EmpRec."No.");
                                                        PayrollEntry.SETRANGE(PayrollEntry."Payroll ID", PayRID);
                                                        PayrollEntry.SETRANGE(PayrollEntry.Amount, NormalAmt);
                                                        IF NOT PayrollEntry.FINDFIRST THEN BEGIN
                                                            ParollEntry.RESET;
                                                            IF ParollEntry.FINDLAST THEN
                                                                PayrollEntryNo := ParollEntry."Entry No.";
                                                            PayrollEntry."Entry No." := PayrollEntryNo + 1;
                                                            PayrollEntry.VALIDATE("ED Code", EdDefR2."ED Code");
                                                            PayrollEntry.VALIDATE("Payroll ID", PayRID);
                                                            PayrollEntry.VALIDATE("Employee No.", EmpRec."No.");
                                                            PayrollEntry.Quantity := 1;
                                                            PayrollEntry.VALIDATE(PayrollEntry.Rate, NormalAmt);
                                                            PayrollEntry.Date := TODAY;
                                                            PayrollEntry.INSERT;
                                                        END;
                                                    END;
                                                END;
                                            END;
                                        END;
                                        //END;
                                        TotalOTAmount := NonWrkAmt + HoliAmt + NormalAmt;
                                        IF TotalOTAmount <> 0 THEN
                                            Posted := TRUE;
                                    UNTIL EmpGrade.NEXT = 0;
                            UNTIL EmpRec.NEXT = 0;
                        IF Posted THEN
                            MESSAGE('Computation Updated Successfully')
                        ELSE
                            MESSAGE('Nothing to update');

                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        lvPeriods: Record 51151;
    begin
        gsSegmentPayrollData;

        lvPeriods.SETCURRENTKEY("Start Date");
        lvPeriods.SETRANGE(Status, lvPeriods.Status::Open);
        lvPeriods.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        IF lvPeriods.FIND('-') THEN gvPeriodFilter := lvPeriods."Period ID";
        ApplySubFormFilter
    end;

    var
        gvPeriodFilter: Code[10];
        gvEmployeeFilter: Code[20];
        gvEDFilter: Code[20];
        gvAllowedPayrolls: Record 51182;
        "//OT Calculation": Integer;
        EmpRec: Record 5200;
        EmpGrade: Record 51191;
        TimeRegR: Record 5207;
        CauseofAbs: Record 5206;
        EDDef: Record 51158;
        EdDefR2: Record 51158;
        PayrollSetup: Record 51165;
        PayrollEntry: Record 51161;
        ParollEntry: Record 51161;
        Period: Record 51151;
        ThisWeek: Integer;
        PrevWeekFrom: Date;
        PrevWeekTo: Date;
        ActualWeeklyHours: Decimal;
        MaxWeekHrs: Decimal;
        OTHours: Decimal;
        OTNonWork: Decimal;
        OTHoliday: Decimal;
        OTNormal: Decimal;
        NonWrkAmt: Decimal;
        HoliAmt: Decimal;
        NormalAmt: Decimal;
        TotalOTAmount: Decimal;
        PayRID: Code[20];
        PayrollEntryNo: Integer;
        Posted: Boolean;
        ActPayrollID: Code[20];

    procedure ApplySubFormFilter()
    var
        lvPayrollEntry: Record 51161;
    begin
        lvPayrollEntry.RESET;
        lvPayrollEntry.SETCURRENTKEY("Payroll ID", "Employee No.", "ED Code");

        IF gvPeriodFilter <> '' THEN lvPayrollEntry.SETRANGE("Payroll ID", gvPeriodFilter);
        IF gvEmployeeFilter <> '' THEN lvPayrollEntry.SETRANGE("Employee No.", gvEmployeeFilter);
        IF gvEDFilter <> '' THEN lvPayrollEntry.SETRANGE("ED Code", gvEDFilter);
        lvPayrollEntry.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        lvPayrollEntry.FILTERGROUP(10);

        CurrPage.SubFrm.PAGE.SETTABLEVIEW(lvPayrollEntry);
    end;

    local procedure gvPeriodFilterOnAfterValidate()
    begin
        ApplySubFormFilter;
    end;

    local procedure gvEDFilterOnAfterValidate()
    begin
        ApplySubFormFilter
    end;

    local procedure gvEmployeeFilterOnAfterValidat()
    begin
        ApplySubFormFilter
    end;

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin
        /*lvSession.SETRANGE("My Session", TRUE);
        lvSession.FINDFIRST; //fire error in absence of a login
        IF lvSession."Login Type" = lvSession."Login Type"::Database THEN
          lvAllowedPayrolls.SETRANGE("User ID", USERID)
        ELSE*/

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;

        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF NOT lvAllowedPayrolls.FINDFIRST THEN
            ERROR('You are not allowed access to this payroll dataset.');

    end;
}


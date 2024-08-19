report 51186 "Payroll Reconciliation"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Payroll Reconciliation.rdlc';

    dataset
    {
        dataitem(DataItem8892; 2000000026)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(OpenBal; OpenBal)
            {
            }
            column(AddJoiBP; AddJoiBP)
            {
            }
            column(EmptyString; '')
            {
            }
            column(LeftBP; LeftBP)
            {
            }
            column(CloseBal; CloseBal)
            {
            }
            column(EmpCount1; EmpCount1)
            {
            }
            column(AddJoin; AddJoin)
            {
            }
            column(DedLeav; DedLeav)
            {
            }
            column(TotalCloseBalE; TotalCloseBalE)
            {
            }
            column(Basic_PayCaption; Basic_PayCaptionLbl)
            {
            }
            column(Number_of_EmployeesCaption; Number_of_EmployeesCaptionLbl)
            {
            }
            column(Opening_BalanceCaption; Opening_BalanceCaptionLbl)
            {
            }
            column(Add__JoinersCaption; Add__JoinersCaptionLbl)
            {
            }
            column(Add__Salary_ReviewsCaption; Add__Salary_ReviewsCaptionLbl)
            {
            }
            column(Less__LeaversCaption; Less__LeaversCaptionLbl)
            {
            }
            column(Closing_BalanceCaption; Closing_BalanceCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                lvPeriod: Record 51151;
                lvLastDateLastMonth: Date;
                lvLastDateThisMonth: Date;
            begin
                //Moved from Presection Body for rtc
                MonthV := DATE2DMY(StartDate, 2);
                Yearv := DATE2DMY(StartDate, 3);
                CASE MonthV OF
                    1:
                        NoofDays := 31;
                    2:
                        BEGIN
                            IF DATE2DMY(StartDate, 3) MOD 4 = 0 THEN
                                NoofDays := 29
                            ELSE
                                NoofDays := 28;
                        END;
                    3:
                        NoofDays := 31;
                    4:
                        NoofDays := 30;
                    5:
                        NoofDays := 31;
                    6:
                        NoofDays := 30;
                    7:
                        NoofDays := 31;
                    8:
                        NoofDays := 31;
                    9:
                        NoofDays := 30;
                    10:
                        NoofDays := 31;
                    11:
                        NoofDays := 30;
                    12:
                        NoofDays := 31;
                END;
                CLEAR(EmpCount1);

                lvLastDateLastMonth := CALCDATE('-CM', StartDate);
                lvLastDateLastMonth -= 1;
                lvLastDateThisMonth := CALCDATE('CM', StartDate);

                gvAllowedPayrolls.RESET;
                gvAllowedPayrolls.SETRANGE(gvAllowedPayrolls."User ID", USERID);
                gvAllowedPayrolls.SETRANGE(gvAllowedPayrolls."Last Active Payroll", TRUE);
                IF gvAllowedPayrolls.FINDFIRST THEN
                    ActPayrollID := gvAllowedPayrolls."Payroll Code";

                //get the payroll period prior to this month
                lvPeriod.RESET;
                lvPeriod.SETCURRENTKEY("Period Year", lvPeriod."Period Month");
                lvPeriod.SETRANGE("Payroll Code", ActPayrollID);
                IF DATE2DMY(StartDate, 2) <> 1 THEN BEGIN
                    //PayrollHeader1.SETRANGE("Payroll Month",1,DATE2DMY(StartDate,2)-1);
                    lvPeriod.SETRANGE("Period Year", DATE2DMY(StartDate, 3));
                    lvPeriod.SETRANGE("Period Month", DATE2DMY(StartDate, 2) - 1);
                END ELSE BEGIN
                    lvPeriod.SETRANGE("Period Year", DATE2DMY(StartDate, 3) - 1);
                    lvPeriod.SETRANGE("Period Month", 1, 12);
                END;
                lvPeriod.FINDFIRST;

                //Opening Bal as at the payroll of last month
                PayrollHeader1.RESET;
                PayrollHeader1.SETRANGE("Payroll Code", ActPayrollID);
                PayrollHeader1.SETRANGE("Payroll ID", lvPeriod."Period ID");
                IF PayrollHeader1.FINDFIRST THEN
                    REPEAT
                        OpenBal += PayrollHeader1."Basic Pay";
                    UNTIL PayrollHeader1.NEXT = 0;

                //get the employee as at end of active last month
                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."Payroll Code", ActPayrollID);
                EmpRec.SETFILTER(EmpRec."Employment Date", '<>%1|<=%2', 0D, lvLastDateLastMonth);
                EmpRec.SETFILTER(EmpRec."Termination Date", '%1|>%2', 0D, lvLastDateLastMonth);
                EmpCount1 := EmpRec.COUNT;

                // newly employed
                //get the payroll period for this month
                lvPeriod.RESET;
                lvPeriod.SETCURRENTKEY("Period Year", lvPeriod."Period Month");
                lvPeriod.SETRANGE("Payroll Code", ActPayrollID);
                lvPeriod.SETRANGE("Period Year", DATE2DMY(StartDate, 3));
                lvPeriod.SETRANGE("Period Month", DATE2DMY(StartDate, 2));
                lvPeriod.FINDFIRST;

                //add joiners
                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."Payroll Code", ActPayrollID);
                EmpRec.SETFILTER(EmpRec."Employment Date", '>%1&<=%2', lvLastDateLastMonth, lvLastDateThisMonth);
                IF EmpRec.FINDFIRST THEN
                    REPEAT
                        PayrollHeader.RESET;
                        PayrollHeader.SETRANGE(PayrollHeader."Payroll ID", lvPeriod."Period ID");
                        PayrollHeader.SETRANGE("Payroll Code", lvPeriod."Payroll Code");
                        PayrollHeader.SETRANGE("Employee no.", EmpRec."No.");
                        IF PayrollHeader.FINDFIRST THEN
                            REPEAT
                                AddJoiBP += PayrollHeader."Basic Pay";
                            UNTIL PayrollHeader.NEXT = 0;
                        AddJoin += 1;
                    UNTIL EmpRec.NEXT = 0;

                // terminated employees
                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."Payroll Code", ActPayrollID);
                EmpRec.SETFILTER(EmpRec."Termination Date", '>%1&<=%2', lvLastDateLastMonth, lvLastDateThisMonth, 0D);
                IF EmpRec.FINDFIRST THEN
                    REPEAT
                        PayrollHeader.RESET;
                        PayrollHeader.SETRANGE(PayrollHeader."Payroll ID", lvPeriod."Period ID");
                        PayrollHeader.SETRANGE("Payroll Code", lvPeriod."Payroll Code");
                        PayrollHeader.SETRANGE("Employee no.", EmpRec."No.");
                        IF PayrollHeader.FINDFIRST THEN
                            REPEAT
                                LeftBP += PayrollHeader."Basic Pay";
                            UNTIL PayrollHeader.NEXT = 0;
                        DedLeav += 1;
                    UNTIL EmpRec.NEXT = 0;


                //get the employee who are active as at end of this month
                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."Payroll Code", ActPayrollID);
                EmpRec.SETFILTER(EmpRec."Employment Date", '<>%1|<=%2', 0D, lvLastDateThisMonth);
                EmpRec.SETFILTER(EmpRec."Termination Date", '%1|>%2', 0D, lvLastDateThisMonth);
                TotalCloseBalE := EmpRec.COUNT;

                //get the closing balance
                PayrollHeader.RESET;
                PayrollHeader.SETRANGE(PayrollHeader."Payroll ID", lvPeriod."Period ID");
                PayrollHeader.SETRANGE("Payroll Code", lvPeriod."Payroll Code");
                IF PayrollHeader.FINDFIRST THEN
                    REPEAT
                        CloseBal += PayrollHeader."Basic Pay";
                    UNTIL PayrollHeader.NEXT = 0;
                /*
                IF DATE2DMY(StartDate,2) <> 1 THEN BEGIN
                  PayrollHeader.RESET;
                  PayrollHeader.SETRANGE(PayrollHeader."Payroll ID",ActPayrollID);
                  PayrollHeader.SETRANGE("Payroll Month",DATE2DMY(StartDate,2),12);
                  PayrollHeader.SETRANGE("Payroll Year",DATE2DMY(StartDate,3));
                  IF PayrollHeader.FINDFIRST THEN REPEAT
                    NegateOpenBal += PayrollHeader."Basic Pay";
                  UNTIL PayrollHeader.NEXT = 0;
                END;
                OpenBal := OpenBal - NegateOpenBal;
                
                //Closing Balace
                PayrollHeader.RESET;
                PayrollHeader.SETRANGE(PayrollHeader."Payroll ID",lvPeriod."Period ID");
                PayrollHeader.SETRANGE("Payroll Code",lvPeriod."Payroll Code");
                IF PayrollHeader.FINDFIRST THEN REPEAT
                  CloseBalMonth+=PayrollHeader."Basic Pay";
                UNTIL PayrollHeader.NEXT = 0;
                  CloseBal := CloseBalMonth + OpenBal;
                
                */
                /*
                //Newly Employed
                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."Payroll Code",ActPayrollID);
                EmpRec.SETFILTER(EmpRec."Employment Date",'<>%1',0D);
                EmpRec.SETRANGE(EmpRec."Employment Date",DMY2DATE(1,DATE2DMY(StartDate,2),DATE2DMY(StartDate,3)),
                DMY2DATE(NoofDays,DATE2DMY(StartDate,2),DATE2DMY(StartDate,3)));
                IF EmpRec.FINDFIRST THEN REPEAT
                  PayrollHeader.RESET;
                  PayrollHeader.SETRANGE(PayrollHeader."Payroll ID",ActPayrollID);
                  PayrollHeader.SETRANGE(PayrollHeader."Employee no.",EmpRec."No.");
                  PayrollHeader.SETRANGE(PayrollHeader."Payroll Month",DATE2DMY(StartDate,2));
                  PayrollHeader.SETRANGE(PayrollHeader."Payroll Year",DATE2DMY(StartDate,3));
                  IF PayrollHeader.FINDFIRST THEN REPEAT
                    AddJoiBP += PayrollHeader."Basic Pay";
                  UNTIL PayrollHeader.NEXT = 0;
                  AddJoin +=1;
                UNTIL EmpRec.NEXT = 0;
                */


                /*
                //Terminated Employees
                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."Payroll Code",ActPayrollID);
                EmpRec.SETFILTER(EmpRec."Termination Date",'<>%1',0D);
                EmpRec.SETRANGE(EmpRec."Termination Date",DMY2DATE(1,DATE2DMY(StartDate,2),DATE2DMY(StartDate,3)),
                DMY2DATE(NoofDays,DATE2DMY(StartDate,2),DATE2DMY(StartDate,3)));
                IF EmpRec.FINDFIRST THEN REPEAT
                  PayrollHeader.RESET;
                  PayrollHeader.SETRANGE(PayrollHeader."Payroll ID",ActPayrollID);
                  PayrollHeader.SETRANGE(PayrollHeader."Employee no.",EmpRec."No.");
                  PayrollHeader.SETRANGE(PayrollHeader."Payroll Month",DATE2DMY(StartDate,2));
                  PayrollHeader.SETRANGE(PayrollHeader."Payroll Year",DATE2DMY(StartDate,3));
                  IF PayrollHeader.FINDFIRST THEN REPEAT
                    LeftBP += PayrollHeader."Basic Pay";
                  UNTIL PayrollHeader.NEXT = 0;
                  DedLeav +=1;
                UNTIL EmpRec.NEXT = 0;
                */

            end;

            trigger OnPreDataItem()
            begin
                CLEAR(OpenBal);
                CLEAR(NegateOpenBal);
                CLEAR(AddJoiBP);
                CLEAR(LeftBP);
                CLEAR(CloseBalMonth);
                CLEAR(CloseBal);
                CLEAR(EmpCount1);
                CLEAR(AddJoin);
                CLEAR(DedLeav);
                CLEAR(CloseBalEmp);
                CLEAR(TotalCloseBalE);
                CLEAR(ActPayrollID);
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
                    field(StartDate; StartDate)
                    {
                        Caption = 'Date';
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

        IF StartDate = 0D THEN
            ERROR('Please Specify the Start Date');
    end;

    var
        PayrollHeader: Record 51159;
        PayrollHeader1: Record 51159;
        EmpRec: Record 5200;
        StartDate: Date;
        DateVal: Date;
        OpenBal: Decimal;
        NegateOpenBal: Decimal;
        AddJoiBP: Decimal;
        LeftBP: Decimal;
        CloseBalMonth: Decimal;
        CloseBal: Decimal;
        MonthV: Integer;
        NoofDays: Integer;
        EmpCount1: Integer;
        Yearv: Integer;
        EmpCountNeg: Integer;
        AddJoin: Integer;
        DedLeav: Integer;
        CloseBalEmp: Integer;
        TotalCloseBalE: Integer;
        gvAllowedPayrolls: Record 51182;
        MembershipNumbers: Record 51175;
        gvPinNo: Code[20];
        ActPayrollID: Code[20];
        Basic_PayCaptionLbl: Label 'Basic Pay';
        Number_of_EmployeesCaptionLbl: Label 'Number of Employees';
        Opening_BalanceCaptionLbl: Label 'Opening Balance';
        Add__JoinersCaptionLbl: Label 'Add: Joiners';
        Add__Salary_ReviewsCaptionLbl: Label 'Add: Salary Reviews';
        Less__LeaversCaptionLbl: Label 'Less: Leavers';
        Closing_BalanceCaptionLbl: Label 'Closing Balance';

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


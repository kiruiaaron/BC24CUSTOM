report 51190 "Staff Movement Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Staff Movement Report.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
            DataItemTableView = SORTING("Global Dimension 1 Code", "Global Dimension 2 Code");
            column(No__of_Employees_as_per____FORMAT_PreviousFromMonth_0___Month_Text___Year_______Payroll_; 'No. of Employees as per ' + FORMAT(PreviousFromMonth, 0, '<Month Text> <Year>.') + ' Payroll')
            {
            }
            column(Leavers___FORMAT_PreviousFromMonth_0___Month_Text___Year____; 'Leavers ' + FORMAT(PreviousFromMonth, 0, '<Month Text> <Year>.'))
            {
            }
            column(Joiners___FORMAT_DateCm_0___Month_Text___Year____; 'Joiners ' + FORMAT(DateCm, 0, '<Month Text> <Year>.'))
            {
            }
            column(No__Of_Employees_as_Per____FORMAT_DateCm_0___Month_Text___Year_______Payroll_; 'No. Of Employees as Per ' + FORMAT(DateCm, 0, '<Month Text> <Year>.') + ' Payroll')
            {
            }
            column(Leavers___FORMAT_DateCm_0___Month_Text___Year____; 'Leavers ' + FORMAT(DateCm, 0, '<Month Text> <Year>.'))
            {
            }
            column(Employee__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(ToDisplay; ToDisplay)
            {
            }
            column(TransferTo; TransferTo)
            {
            }
            column(TransferFrom; TransferFrom)
            {
            }
            column(Leavers; Leavers)
            {
            }
            column(Joiners; Joiners)
            {
            }
            column(Reinstate; Reinstate)
            {
            }
            column(CurrLeavers; CurrLeavers)
            {
            }
            column(NoofEmpAsPerC; NoofEmpAsPerC)
            {
            }
            column(ExpNoofEmpClos; ExpNoofEmpClos)
            {
            }
            column(DEPTCaption; DEPTCaptionLbl)
            {
            }
            column(Transfer_ToCaption; Transfer_ToCaptionLbl)
            {
            }
            column(Transfer_FromCaption; Transfer_FromCaptionLbl)
            {
            }
            column(Reinstated_for_Final_DuesCaption; Reinstated_for_Final_DuesCaptionLbl)
            {
            }
            column(Expected_No__of_Emp_as_at_closing_of_payrollCaption; Expected_No__of_Emp_as_at_closing_of_payrollCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //Moved from Employee Body-presection
                PayrollHdr.RESET;
                PayrollHdr.SETRANGE("Employee no.", "No.");
                PayrollHdr.SETRANGE("Payroll Month", DATE2DMY(PreviousFromMonth, 2));
                PayrollHdr.SETRANGE("Payroll Year", DATE2DMY(PreviousFromMonth, 3));
                IF PayrollHdr.FINDFIRST THEN
                    REPEAT
                        NoofEmpOldP += PayrollHdr.COUNT;
                    UNTIL PayrollHdr.NEXT = 0;

                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."No.", "No.");
                EmpRec.SETRANGE(EmpRec."Termination Date", PreviousFromMonth, PreviousToDate);
                IF EmpRec.FINDFIRST THEN
                    REPEAT
                        Leavers += 1;
                    UNTIL EmpRec.NEXT = 0;

                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."No.", "No.");
                EmpRec.SETRANGE(EmpRec."Employment Date", DMY2DATE(1, MonthV, YearV), DMY2DATE(NoofDays, MonthV, YearV));
                IF EmpRec.FINDFIRST THEN
                    REPEAT
                        Joiners += 1;
                    UNTIL EmpRec.NEXT = 0;

                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."No.", "No.");
                EmpRec.SETRANGE(EmpRec."Termination Date", DMY2DATE(1, MonthV, YearV), DMY2DATE(NoofDays, MonthV, YearV));
                IF EmpRec.FINDFIRST THEN
                    REPEAT
                        CurrLeavers += 1;
                    UNTIL EmpRec.NEXT = 0;

                /*
                HRMELE.RESET;
                HRMELE.SETRANGE("Employee No.","No.");
                HRMELE.SETRANGE("Posting Date",PreviousFromMonth,PreviousToDate);
                HRMELE.SETRANGE("Affiliation Type",HRMELE."Affiliation Type"::"1");
                IF HRMELE.FINDLAST THEN BEGIN
                  HRMOldEN := HRMELE."Entry No." - 1;
                  TransferTo += 1;
                END;
                
                HRMELEFrom.RESET;
                HRMELEFrom.SETRANGE("Employee No.","No.");
                HRMELEFrom.SETRANGE("Posting Date",PreviousFromMonth,PreviousToDate);
                HRMELEFrom.SETRANGE(HRMELEFrom."Entry No.",HRMOldEN);
                HRMELEFrom.SETRANGE("Affiliation Type",HRMELEFrom."Affiliation Type"::"1");
                IF HRMELEFrom.FINDLAST THEN BEGIN
                  TransferFrom += 1;
                END;
                
                HRMELEFrom.RESET;
                HRMELEFrom.SETRANGE("Employee No.","No.");
                HRMELEFrom.SETRANGE("Posting Date",PreviousFromMonth,PreviousToDate);
                HRMELEFrom.SETRANGE(HRMELEFrom."Entry No.",HRMOldEN);
                HRMELEFrom.SETRANGE("Affiliation Type",HRMELEFrom."Affiliation Type"::"3");
                IF HRMELEFrom.FINDFIRST THEN REPEAT
                  Reinstate += 1;
                UNTIL HRMELE.NEXT = 0;   */

            end;

            trigger OnPostDataItem()
            begin
                //Moved from Employee group footer
                // CurrReport.ShowOutput := CurrReport.TOTALSCAUSEDBY = FIELDNO("Global Dimension 1 Code");
                //CurrReport.SHOWOUTPUT := CurrReport.TOTALSCAUSEDBY = FIELDNO("Global Dimension 2 Code");
                ToDisplay := NoofEmpOldP - ToDisplay;
                NoofEmpOldP := ToDisplay;

                ToDispL := Leavers - ToDispL;
                Leavers := ToDispL;

                ToDispJ := Joiners - ToDispJ;
                Joiners := ToDispJ;

                ToDispRein := Reinstate - ToDispRein;
                Reinstate := ToDispRein;

                DispCurrLeavers := CurrLeavers - DispCurrLeavers;
                CurrLeavers := DispCurrLeavers;

                DispTranFr := TransferFrom - DispTranFr;
                TransferFrom := DispTranFr;

                DispTranTo := TransferTo - DispTranTo;
                TransferTo := DispTranTo;

                NoofEmpAsPerC := NoofEmpOldP - TransferTo + TransferFrom - Leavers;
                ExpNoofEmpClos := NoofEmpAsPerC + Reinstate + Joiners - CurrLeavers;
            end;

            trigger OnPreDataItem()
            begin
                I := 1;
                gvAllowedPayrolls.RESET;
                gvAllowedPayrolls.SETRANGE(gvAllowedPayrolls."User ID", USERID);
                gvAllowedPayrolls.SETRANGE(gvAllowedPayrolls."Last Active Payroll", TRUE);
                IF gvAllowedPayrolls.FINDFIRST THEN
                    ActPayrollID := gvAllowedPayrolls."Payroll Code";
                //Moved code from Employee Presection
                MonthV := DATE2DMY(DateCm, 2);
                YearV := DATE2DMY(DateCm, 3);
                CASE MonthV OF
                    1:
                        NoofDays := 31;
                    2:
                        BEGIN
                            IF DATE2DMY(DateCm, 3) MOD 4 = 0 THEN
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

                PrevMonthV := DATE2DMY(DateCm, 2) - 1;
                CASE PrevMonthV OF
                    1:
                        PrevNoofDays := 31;
                    2:
                        BEGIN
                            IF DATE2DMY(DateCm, 3) MOD 4 = 0 THEN
                                PrevNoofDays := 29
                            ELSE
                                PrevNoofDays := 28;
                        END;
                    3:
                        PrevNoofDays := 31;
                    4:
                        PrevNoofDays := 30;
                    5:
                        PrevNoofDays := 31;
                    6:
                        PrevNoofDays := 30;
                    7:
                        PrevNoofDays := 31;
                    8:
                        PrevNoofDays := 31;
                    9:
                        PrevNoofDays := 30;
                    10:
                        PrevNoofDays := 31;
                    11:
                        PrevNoofDays := 30;
                    12:
                        PrevNoofDays := 31;
                END;
                IF MonthV <> 1 THEN BEGIN
                    PreviousFromMonth := DMY2DATE(1, MonthV - 1, YearV);
                    PreviousToDate := DMY2DATE(PrevNoofDays, MonthV - 1, YearV);
                END ELSE BEGIN
                    PreviousFromMonth := DMY2DATE(1, 12, YearV - 1);
                    PreviousToDate := DMY2DATE(PrevNoofDays, 12, YearV - 1);
                END;
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
                    field(DateCm; DateCm)
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
    end;

    var
        HRMOldEN: Integer;
        EmpRec: Record 5200;
        PayrollHdr: Record 51159;
        DateCm: Date;
        CurrentMonth: Date;
        PreviousFromMonth: Date;
        PreviousToDate: Date;
        MonthV: Integer;
        PrevMonthV: Integer;
        YearV: Integer;
        NoofDays: Integer;
        PrevNoofDays: Integer;
        NoofEmpOldP: Integer;
        TransferTo: Integer;
        TransferFrom: Integer;
        DispTranFr: Integer;
        DispTranTo: Integer;
        ToDisplay: Integer;
        I: Integer;
        Leavers: Integer;
        ToDispL: Integer;
        Joiners: Integer;
        ToDispJ: Integer;
        Reinstate: Integer;
        ToDispRein: Integer;
        CurrLeavers: Integer;
        DispCurrLeavers: Integer;
        NoofEmpAsPerC: Integer;
        ExpNoofEmpClos: Integer;
        gvAllowedPayrolls: Record 51182;
        MembershipNumbers: Record 51175;
        gvPinNo: Code[20];
        ActPayrollID: Code[20];
        DEPTCaptionLbl: Label 'DEPT';
        Transfer_ToCaptionLbl: Label 'Transfer To';
        Transfer_FromCaptionLbl: Label 'Transfer From';
        Reinstated_for_Final_DuesCaptionLbl: Label 'Reinstated for Final Dues';
        Expected_No__of_Emp_as_at_closing_of_payrollCaptionLbl: Label 'Expected No. of Emp as at closing of payroll';

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


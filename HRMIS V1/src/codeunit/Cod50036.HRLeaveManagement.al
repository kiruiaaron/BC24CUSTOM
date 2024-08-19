codeunit 50036 "HR Leave Management"
{

    trigger OnRun()
    begin
    end;

    var
        HRGeneralSetup: Record 5218;
        Employee: Record 5200;
        LeaveLedgerEntry: Record 50132;
        LeavePeriods: Record 50135;
        LeaveTypes: Record 50134;
        HRCalender: Record 50171;
        CalendarMgmt: Codeunit 50044;
        Description: Text[30];
        HRLeavePlannerHeader: Record 50125;
        HRLeaveApplication: Record 50127;
        HRLeaveAllocationHeader: Record 50130;
        HRLeaveAllocationLine: Record 50131;
        HRReimbursment: Record 50128;
        HRCarryOver: Record 50129;
        Text0001: Label ' Leave Reimbursment is already Posted!';
        LeaveYear: Integer;
        LeaveEndDate: Date;
        //  SMTPMail: Codeunit 400;
        //        SMTP: Record 409;
        EmailMessageCu: Codeunit "Email Message";
        EmailCu: Codeunit Email;

    procedure CheckOpenLeavePlannerExists(EmployeeUserID: Code[50]) OpenLeavePlannerExist: Boolean
    begin
        OpenLeavePlannerExist := FALSE;
        HRLeavePlannerHeader.RESET;
        HRLeavePlannerHeader.SETRANGE(HRLeavePlannerHeader."User ID", EmployeeUserID);
        HRLeavePlannerHeader.SETRANGE(HRLeavePlannerHeader.Status, HRLeavePlannerHeader.Status::Open);
        IF HRLeavePlannerHeader.FINDFIRST THEN BEGIN
            OpenLeavePlannerExist := TRUE;
        END;
    end;

    procedure CheckOpenLeaveApplicationExists(EmployeeUserID: Code[50]) OpenLeaveApplicationExist: Boolean
    begin
        OpenLeaveApplicationExist := FALSE;
        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."User ID", EmployeeUserID);
        HRLeaveApplication.SETRANGE(HRLeaveApplication.Status, HRLeaveApplication.Status::Open);
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            OpenLeaveApplicationExist := TRUE;
        END;
    end;

    procedure CheckOpenLeaveReimbursementExists(EmployeeUserID: Code[50]) OpenLeaveReimbursementExist: Boolean
    begin
        OpenLeaveReimbursementExist := FALSE;
        HRReimbursment.RESET;
        HRReimbursment.SETRANGE(HRReimbursment."User ID", EmployeeUserID);
        HRReimbursment.SETRANGE(HRReimbursment.Status, HRReimbursment.Status::Open);
        IF HRReimbursment.FINDFIRST THEN BEGIN
            OpenLeaveReimbursementExist := TRUE;
        END;
    end;

    procedure CalculateLeaveEndDate(LeaveType: Code[50]; LeavePeriod: Code[20]; LeaveStartDate: Date; DaysApplied: Integer; BaseCalendarCode: Code[10]) LeaveEndDate: Date
    var
        NonWorkingDay: Boolean;
        LeaveDays: Integer;
        LeaveEndDateFormula: DateFormula;
    begin
        LeaveTypes.RESET;
        LeaveTypes.GET(LeaveType);
        IF LeaveTypes."Inclusive of Non Working Days" THEN BEGIN
            LeaveDays := DaysApplied - 1;
            EVALUATE(LeaveEndDateFormula, FORMAT(LeaveDays) + 'D');
            LeaveEndDate := CALCDATE(LeaveEndDateFormula, LeaveStartDate);
        END ELSE BEGIN
            LeaveDays := DaysApplied;
            LeaveEndDate := CALCDATE('-1D', LeaveStartDate);
            WHILE LeaveDays > 0 DO BEGIN
                LeaveEndDate := CALCDATE('1D', LeaveEndDate);
                IF BaseCalendarCode = '' THEN
                    NonWorkingDay := CalendarMgmt.CheckDateStatus(LeaveTypes."Base Calendar", LeaveEndDate, Description)
                ELSE
                    NonWorkingDay := CalendarMgmt.CheckDateStatus(BaseCalendarCode, LeaveEndDate, Description);
                IF NOT NonWorkingDay THEN BEGIN
                    LeaveDays := LeaveDays - 1;
                END;
            END;
        END;
    end;

    procedure CalculateLeaveReturnDate(LeaveType: Code[50]; LeavePeriod: Code[20]; LeaveEndDate: Date; BaseCalendarCode: Code[10]) LeaveReturnDate: Date
    var
        NonWorkingDay: Boolean;
    begin
        LeaveTypes.RESET;
        LeaveTypes.GET(LeaveType);
        LeaveReturnDate := LeaveEndDate;
        REPEAT
            LeaveReturnDate := CALCDATE('1D', LeaveReturnDate);
            IF BaseCalendarCode = '' THEN
                NonWorkingDay := CalendarMgmt.CheckDateStatus(LeaveTypes."Base Calendar", LeaveReturnDate, Description)
            ELSE
                NonWorkingDay := CalendarMgmt.CheckDateStatus(BaseCalendarCode, LeaveReturnDate, Description);
        UNTIL NonWorkingDay = FALSE;
    end;

    procedure CheckLeaveApplicationMandatoryFields("HR Leave Application": Record 50127; Posting: Boolean)
    var
        HRLeaveApplication: Record 50127;
        HRLeaveApplication2: Record 50127;
    begin
        HRLeaveApplication.TRANSFERFIELDS("HR Leave Application", TRUE);
        HRLeaveApplication.TESTFIELD(HRLeaveApplication."Posting Date");
        HRLeaveApplication.TESTFIELD(HRLeaveApplication."Employee No.");
        HRLeaveApplication.TESTFIELD(HRLeaveApplication."Leave Type");
        HRLeaveApplication.TESTFIELD(HRLeaveApplication."Leave Period");
        HRLeaveApplication.TESTFIELD(HRLeaveApplication."Days Approved");
        /*IF Posting THEN
          HRLeaveApplication.TESTFIELD(HRLeaveApplication.Status,HRLeaveApplication.Status::Released);*/

    end;

    procedure PostLeaveApplication(LeaveApplication: Code[20]) LeavePosted: Boolean
    var
        HRLeaveApplication: Record 50127;
        HRLeaveApplication2: Record 50127;
        LeaveDescription: Label 'Leave Application for Leave Type: %1, Leave Period:%2';
    begin
        LeavePosted := FALSE;
        HRLeaveApplication.RESET;
        HRLeaveApplication.GET(LeaveApplication);
        IF Employee.GET(HRLeaveApplication."Employee No.") THEN BEGIN
            LeaveLedgerEntry.INIT;
            LeaveLedgerEntry."Line No." := 0;
            LeaveLedgerEntry."Document No." := HRLeaveApplication."No.";
            LeaveLedgerEntry."Posting Date" := HRLeaveApplication."Posting Date";
            LeaveLedgerEntry."Leave Year" := DATE2DMY(HRLeaveApplication."Posting Date", 3);
            LeaveLedgerEntry."Entry Type" := LeaveLedgerEntry."Entry Type"::"Negative Adjustment";
            LeaveLedgerEntry."Employee No." := HRLeaveApplication."Employee No.";
            LeaveLedgerEntry."Leave Type" := HRLeaveApplication."Leave Type";
            LeaveLedgerEntry."Leave Period" := HRLeaveApplication."Leave Period";
            LeaveLedgerEntry.Days := -(HRLeaveApplication."Days Approved");
            LeaveLedgerEntry."HR Location" := Employee.Location;
            LeaveLedgerEntry."HR Department" := Employee.Department;
            LeaveLedgerEntry.Description := STRSUBSTNO(LeaveDescription, HRLeaveApplication."Leave Type", HRLeaveApplication."Leave Period");
            LeaveLedgerEntry."Global Dimension 1 Code" := HRLeaveApplication."Global Dimension 1 Code";
            LeaveLedgerEntry."Global Dimension 2 Code" := HRLeaveApplication."Global Dimension 2 Code";
            LeaveLedgerEntry."Shortcut Dimension 3 Code" := HRLeaveApplication."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 4 Code" := HRLeaveApplication."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 5 Code" := HRLeaveApplication."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 6 Code" := HRLeaveApplication."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 7 Code" := HRLeaveApplication."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 8 Code" := HRLeaveApplication."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Responsibility Center" := HRLeaveApplication."Responsibility Center";
            LeaveLedgerEntry."User ID" := USERID;
            IF LeaveLedgerEntry.INSERT THEN BEGIN
                HRLeaveApplication2.RESET;
                HRLeaveApplication2.SETRANGE(HRLeaveApplication2."No.", HRLeaveApplication."No.");
                IF HRLeaveApplication2.FINDFIRST THEN BEGIN
                    IF HRLeaveApplication2."Leave Start Date" = TODAY THEN BEGIN
                        Employee.GET(HRLeaveApplication2."Employee No.");
                        Employee."Leave Status" := Employee."Leave Status"::"On Leave";
                        Employee.MODIFY;
                    END;
                    HRLeaveApplication2.Status := HRLeaveApplication2.Status::Posted;
                    HRLeaveApplication2.Posted := TRUE;
                    HRLeaveApplication2."Posted By" := USERID;
                    HRLeaveApplication2."Date Posted" := TODAY;
                    HRLeaveApplication2."Time Posted" := TIME;
                    IF HRLeaveApplication2.MODIFY THEN
                        LeavePosted := TRUE;
                END;
            END;
        END;
        COMMIT;

        //............Send Email notification to Employee, Substitute, Supervisor and Human Resource on Posting Leave Application.........
        //SendEmailNotificationOnPostLeave(LeaveApplication);
    end;

    procedure CheckOpenLeaveAllocationExists(EmployeeUserID: Code[50]) OpenLeaveAllocationExist: Boolean
    begin
        OpenLeaveAllocationExist := FALSE;
        HRLeaveAllocationHeader.RESET;
        HRLeaveAllocationHeader.SETRANGE(HRLeaveAllocationHeader."User ID", EmployeeUserID);
        HRLeaveAllocationHeader.SETRANGE(HRLeaveAllocationHeader.Status, HRLeaveAllocationHeader.Status::Open);
        IF HRLeaveAllocationHeader.FINDFIRST THEN BEGIN
            OpenLeaveAllocationExist := TRUE;
        END;
    end;

    procedure AutoFillLeaveAllocationLines(LeaveAllocation: Code[20]) AutoFilledLines: Boolean
    var
        EmployeeLeaveType: Record 50133;
        HRLeaveTypes: Record 50134;
    begin
        AutoFilledLines := FALSE;
        HRLeaveAllocationHeader.GET(LeaveAllocation);

        HRLeaveAllocationLine.RESET;
        HRLeaveAllocationLine.SETRANGE(HRLeaveAllocationLine."Leave Allocation No.", HRLeaveAllocationHeader."No.");
        IF HRLeaveAllocationLine.FINDSET THEN BEGIN
            HRLeaveAllocationLine.DELETEALL;
        END;

        Employee.RESET;
        Employee.SETRANGE(Employee.Status, Employee.Status::Active);
        //Employee.SETRANGE(Employee."Emplymt. Contract Code","Emplymt. Contract Code");
        IF Employee.FINDSET THEN BEGIN
            REPEAT
                LeaveLedgerEntry.RESET;
                LeaveLedgerEntry.SETRANGE(LeaveLedgerEntry."Employee No.", Employee."No.");
                LeaveLedgerEntry.SETRANGE(LeaveLedgerEntry."Leave Type", HRLeaveAllocationHeader."Leave Type");
                LeaveLedgerEntry.SETRANGE(LeaveLedgerEntry."Leave Period", HRLeaveAllocationHeader."Leave Period");
                IF NOT LeaveLedgerEntry.FINDFIRST THEN BEGIN
                    EmployeeLeaveType.RESET;
                    EmployeeLeaveType.SETRANGE(EmployeeLeaveType."Employee No.", Employee."No.");
                    EmployeeLeaveType.SETRANGE(EmployeeLeaveType."Leave Type", HRLeaveAllocationHeader."Leave Type");
                    IF EmployeeLeaveType.FINDSET THEN BEGIN
                        REPEAT
                            // EmployeeLeaveType.GET(Employee."No.",HRLeaveAllocationHeader."Leave Type");
                            HRLeaveAllocationLine.RESET;
                            HRLeaveAllocationLine."Leave Allocation No." := HRLeaveAllocationHeader."No.";
                            HRLeaveAllocationLine."Employee No." := Employee."No.";
                            HRLeaveAllocationLine.VALIDATE(HRLeaveAllocationLine."Employee No.");
                            HRLeaveAllocationLine."Entry Type" := HRLeaveAllocationLine."Entry Type"::"Positive Adjustment";
                            HRLeaveTypes.RESET;
                            HRLeaveTypes.SETRANGE(HRLeaveTypes.Code, HRLeaveAllocationHeader."Leave Type");
                            IF HRLeaveTypes.FINDFIRST THEN BEGIN
                                HRLeaveAllocationLine."Days Allocated" := HRLeaveTypes.Days;
                                HRLeaveAllocationLine.VALIDATE(HRLeaveAllocationLine."Days Allocated");
                            END;
                            HRLeaveAllocationLine.Description := HRLeaveAllocationHeader.Description;
                            HRLeaveAllocationLine."Global Dimension 1 Code" := HRLeaveAllocationHeader."Global Dimension 1 Code";
                            HRLeaveAllocationLine."Global Dimension 2 Code" := HRLeaveAllocationHeader."Global Dimension 2 Code";
                            HRLeaveAllocationLine."Shortcut Dimension 3 Code" := HRLeaveAllocationHeader."Shortcut Dimension 3 Code";
                            HRLeaveAllocationLine."Shortcut Dimension 4 Code" := HRLeaveAllocationHeader."Shortcut Dimension 4 Code";
                            HRLeaveAllocationLine."Shortcut Dimension 5 Code" := HRLeaveAllocationHeader."Shortcut Dimension 5 Code";
                            HRLeaveAllocationLine."Shortcut Dimension 6 Code" := HRLeaveAllocationHeader."Shortcut Dimension 6 Code";
                            HRLeaveAllocationLine."Shortcut Dimension 7 Code" := HRLeaveAllocationHeader."Shortcut Dimension 7 Code";
                            HRLeaveAllocationLine."Shortcut Dimension 8 Code" := HRLeaveAllocationHeader."Shortcut Dimension 8 Code";
                            HRLeaveAllocationLine.INSERT;
                        UNTIL EmployeeLeaveType.NEXT = 0;
                    END;
                END;
            UNTIL Employee.NEXT = 0;
        END;
        AutoFilledLines := TRUE;
    end;

    procedure PostLeaveAllocation(LeaveAllocation: Code[20]) LeaveAllocationPosted: Boolean
    var
        HRLeaveApplication: Record 50127;
        HRLeaveApplication2: Record 50127;
        LeaveDescription: Label 'Leave Allocation for Leave Type: %1, Leave Period:%2';
    begin
        LeaveAllocationPosted := FALSE;
        HRLeaveAllocationHeader.GET(LeaveAllocation);
        HRLeaveAllocationLine.RESET;
        HRLeaveAllocationLine.SETRANGE(HRLeaveAllocationLine."Leave Allocation No.", HRLeaveAllocationHeader."No.");
        HRLeaveAllocationLine.SETFILTER("Days Approved", '>%1', 0);
        IF HRLeaveAllocationLine.FINDSET THEN BEGIN
            REPEAT
                Employee.GET(HRLeaveAllocationLine."Employee No.");
                LeaveLedgerEntry.INIT;
                LeaveLedgerEntry."Line No." := 0;
                LeaveLedgerEntry."Document No." := HRLeaveAllocationLine."Leave Allocation No.";
                LeaveLedgerEntry."Posting Date" := HRLeaveAllocationHeader."Posting Date";
                LeaveLedgerEntry."Leave Year" := DATE2DMY(HRLeaveAllocationHeader."Posting Date", 3);
                LeaveLedgerEntry."Entry Type" := HRLeaveAllocationLine."Entry Type";
                LeaveLedgerEntry."Employee No." := HRLeaveAllocationLine."Employee No.";
                LeaveLedgerEntry."Leave Type" := HRLeaveAllocationHeader."Leave Type";
                LeaveLedgerEntry."Leave Period" := HRLeaveAllocationHeader."Leave Period";
                IF HRLeaveAllocationLine."Entry Type" = HRLeaveAllocationLine."Entry Type"::"Positive Adjustment" THEN
                    LeaveLedgerEntry.Days := HRLeaveAllocationLine."Days Approved"
                ELSE
                    LeaveLedgerEntry.Days := -(HRLeaveAllocationLine."Days Approved");
                LeaveLedgerEntry."HR Location" := Employee.Location;
                LeaveLedgerEntry."HR Department" := Employee.Department;
                LeaveLedgerEntry.Description := STRSUBSTNO(LeaveDescription, HRLeaveAllocationHeader."Leave Type", HRLeaveAllocationHeader."Leave Period");
                LeaveLedgerEntry."Global Dimension 1 Code" := HRLeaveAllocationLine."Global Dimension 1 Code";
                LeaveLedgerEntry."Global Dimension 2 Code" := HRLeaveAllocationLine."Global Dimension 2 Code";
                LeaveLedgerEntry."Shortcut Dimension 3 Code" := HRLeaveAllocationLine."Shortcut Dimension 3 Code";
                LeaveLedgerEntry."Shortcut Dimension 4 Code" := HRLeaveAllocationLine."Shortcut Dimension 3 Code";
                LeaveLedgerEntry."Shortcut Dimension 5 Code" := HRLeaveAllocationLine."Shortcut Dimension 3 Code";
                LeaveLedgerEntry."Shortcut Dimension 6 Code" := HRLeaveAllocationLine."Shortcut Dimension 3 Code";
                LeaveLedgerEntry."Shortcut Dimension 7 Code" := HRLeaveAllocationLine."Shortcut Dimension 3 Code";
                LeaveLedgerEntry."Shortcut Dimension 8 Code" := HRLeaveAllocationLine."Shortcut Dimension 3 Code";
                LeaveLedgerEntry."Responsibility Center" := HRLeaveAllocationLine."Responsibility Center";
                LeaveLedgerEntry."User ID" := USERID;
                LeaveLedgerEntry."Leave Allocation" := TRUE;
                LeaveLedgerEntry.INSERT;
            UNTIL HRLeaveAllocationLine.NEXT = 0;
        END;
        COMMIT;
        HRLeaveAllocationHeader.GET(LeaveAllocation);
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE(LeaveLedgerEntry."Document No.", HRLeaveAllocationHeader."No.");
        IF LeaveLedgerEntry.FINDFIRST THEN BEGIN
            HRLeaveAllocationHeader.Status := HRLeaveAllocationHeader.Status::Posted;
            HRLeaveAllocationHeader.Posted := TRUE;
            HRLeaveAllocationHeader."Posted By" := USERID;
            HRLeaveAllocationHeader."Date Posted" := TODAY;
            HRLeaveAllocationHeader."Time Posted" := TIME;
            HRLeaveAllocationHeader.VALIDATE(HRLeaveAllocationHeader.Status);
            IF HRLeaveAllocationHeader.MODIFY THEN BEGIN
                LeaveAllocationPosted := TRUE;
            END;
        END;
    end;

    procedure CheckReimbursmentMandatoryFields("HR Leave Reimbursment": Record 50128; Posting: Boolean)
    var
        HRLeaveReimbursment: Record 50127;
        HRLeaveReimbursment2: Record 50127;
    begin
        HRReimbursment.TRANSFERFIELDS("HR Leave Reimbursment", TRUE);
        HRReimbursment.TESTFIELD(HRReimbursment."Posting Date");
        HRReimbursment.TESTFIELD(HRReimbursment."Employee No.");
        HRReimbursment.TESTFIELD(HRReimbursment."Leave Type");
        HRReimbursment.TESTFIELD(HRReimbursment."Leave Period");
        HRReimbursment.TESTFIELD(HRReimbursment."Days to Reimburse");
    end;

    procedure PostLeaveReimbursment(LeaveReimbursment: Code[20]) ReimbursmentPosted: Boolean
    var
        HRLeaveReimbursment: Record 50128;
        HRLeaveReimbursment2: Record 50128;
        LeaveDescription: Label 'Leave Application for Leave Type: %1, Leave Period:%2';
    begin
        ReimbursmentPosted := FALSE;
        HRReimbursment.RESET;
        HRReimbursment.GET(LeaveReimbursment);

        //Check whether document is posted
        LeaveLedgerEntry.RESET;
        LeaveLedgerEntry.SETRANGE(LeaveLedgerEntry."Document No.", HRReimbursment."No.");
        IF LeaveLedgerEntry.FINDFIRST THEN BEGIN
            ERROR(Text0001);
        END;

        IF Employee.GET(HRReimbursment."Employee No.") THEN BEGIN
            LeaveLedgerEntry.RESET;
            LeaveLedgerEntry."Line No." := 0;
            LeaveLedgerEntry."Document No." := HRReimbursment."No.";
            LeaveLedgerEntry."Posting Date" := HRReimbursment."Posting Date";
            LeaveLedgerEntry."Leave Year" := DATE2DMY(HRReimbursment."Posting Date", 3);
            LeaveLedgerEntry."Entry Type" := LeaveLedgerEntry."Entry Type"::Reimbursement;
            LeaveLedgerEntry."Employee No." := HRReimbursment."Employee No.";
            LeaveLedgerEntry."Leave Type" := HRReimbursment."Leave Type";
            LeaveLedgerEntry."Leave Period" := HRReimbursment."Leave Period";
            LeaveLedgerEntry.Days := (HRReimbursment."Days to Reimburse");
            LeaveLedgerEntry."HR Location" := Employee.Location;
            LeaveLedgerEntry."HR Department" := Employee.Department;
            LeaveLedgerEntry."Leave Year" := LeaveYear;
            LeaveLedgerEntry.Description := STRSUBSTNO(LeaveDescription, HRReimbursment."Leave Type", HRReimbursment."Leave Period");
            LeaveLedgerEntry."Global Dimension 1 Code" := HRReimbursment."Global Dimension 1 Code";
            LeaveLedgerEntry."Global Dimension 2 Code" := HRReimbursment."Global Dimension 2 Code";
            LeaveLedgerEntry."Shortcut Dimension 3 Code" := HRReimbursment."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 4 Code" := HRReimbursment."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 5 Code" := HRReimbursment."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 6 Code" := HRReimbursment."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 7 Code" := HRReimbursment."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 8 Code" := HRReimbursment."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Responsibility Center" := HRReimbursment."Responsibility Center";
            LeaveLedgerEntry."User ID" := USERID;
            IF LeaveLedgerEntry.INSERT THEN BEGIN
                HRLeaveReimbursment2.RESET;
                HRLeaveReimbursment2.SETRANGE(HRLeaveReimbursment2."No.", LeaveReimbursment);
                IF HRLeaveReimbursment2.FINDFIRST THEN BEGIN
                    //modify leave status on employee card
                    Employee.GET(HRLeaveReimbursment2."Employee No.");
                    Employee."Leave Status" := Employee."Leave Status"::" ";
                    Employee.MODIFY;

                    //modify reimbursement card
                    HRLeaveReimbursment2.Status := HRLeaveReimbursment2.Status::Posted;
                    HRLeaveReimbursment2.Posted := TRUE;
                    HRLeaveReimbursment2."Posted By" := USERID;
                    HRLeaveReimbursment2."Date Posted" := TODAY;
                    HRLeaveReimbursment2."Time Posted" := TIME;
                    IF HRLeaveReimbursment2.MODIFY THEN
                        ReimbursmentPosted := TRUE;
                END;
            END;
        END;
        COMMIT;
    end;

    procedure CheckCarryOverMandatoryFields("HR Leave Carryover": Record 50129; Posting: Boolean)
    var
        HRLeaveCarryOver: Record 50129;
        HRLeaveCarryOver2: Record 50129;
    begin
        HRCarryOver.TRANSFERFIELDS("HR Leave Carryover", TRUE);
        HRCarryOver.TESTFIELD(HRCarryOver."Posting Date");
        HRCarryOver.TESTFIELD(HRCarryOver."Employee No.");
        HRCarryOver.TESTFIELD(HRCarryOver."Leave Type");
        HRCarryOver.TESTFIELD(HRCarryOver."Leave Period");
        HRCarryOver.TESTFIELD(HRCarryOver."Days to CarryOver");
        HRCarryOver.TESTFIELD(Posted, FALSE);
    end;

    procedure PostLeaveCarryover(LeaveCarryOver: Code[20]) Carryover: Boolean
    var
        HRLeaveCarryOver: Record 50129;
        HRLeaveCarryOver2: Record 50129;
        LeaveDescription: Label 'Leave Application for Leave Type: %1, Leave Period:%2';
    begin
        Carryover := FALSE;
        HRCarryOver.RESET;
        HRCarryOver.GET(LeaveCarryOver);
        HRCarryOver.TESTFIELD(Posted, FALSE);
        IF Employee.GET(HRCarryOver."Employee No.") THEN BEGIN
            LeaveLedgerEntry.RESET;
            LeaveLedgerEntry."Line No." := 0;
            LeaveLedgerEntry."Document No." := HRCarryOver."No.";
            LeaveLedgerEntry."Posting Date" := HRCarryOver."Posting Date";
            LeaveLedgerEntry."Entry Type" := LeaveLedgerEntry."Entry Type"::"Carry forward";
            LeaveLedgerEntry."Employee No." := HRCarryOver."Employee No.";
            LeaveLedgerEntry."Leave Type" := HRCarryOver."Leave Type";
            LeaveLedgerEntry."Leave Period" := HRCarryOver."Leave Period";
            LeaveLedgerEntry.Days := (HRCarryOver."Days to CarryOver");
            LeaveLedgerEntry."HR Location" := Employee.Location;
            LeaveLedgerEntry."HR Department" := Employee.Department;
            LeaveLedgerEntry.Description := STRSUBSTNO(LeaveDescription, HRCarryOver."Leave Type", HRCarryOver."Leave Period");
            LeaveLedgerEntry."Global Dimension 1 Code" := HRCarryOver."Global Dimension 1 Code";
            LeaveLedgerEntry."Global Dimension 2 Code" := HRCarryOver."Global Dimension 2 Code";
            LeaveLedgerEntry."Shortcut Dimension 3 Code" := HRCarryOver."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 4 Code" := HRCarryOver."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 5 Code" := HRCarryOver."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 6 Code" := HRCarryOver."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 7 Code" := HRCarryOver."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Shortcut Dimension 8 Code" := HRCarryOver."Shortcut Dimension 3 Code";
            LeaveLedgerEntry."Responsibility Center" := HRCarryOver."Responsibility Center";
            LeaveLedgerEntry."User ID" := USERID;

            IF LeaveLedgerEntry.INSERT THEN BEGIN
                HRLeaveCarryOver2.RESET;
                HRLeaveCarryOver2.SETRANGE(HRLeaveCarryOver2."No.", HRCarryOver."No.");
                IF HRLeaveCarryOver2.FINDFIRST THEN BEGIN

                    Employee.GET(HRLeaveCarryOver2."Employee No.");
                    Employee."Leave Status" := Employee."Leave Status"::" ";
                    Employee.MODIFY;


                    HRLeaveCarryOver2.Status := HRLeaveCarryOver2.Status::Posted;
                    HRLeaveCarryOver2.Posted := TRUE;
                    HRLeaveCarryOver2."Posted By" := USERID;
                    HRLeaveCarryOver2."Date Posted" := TODAY;
                    HRLeaveCarryOver2."Time Posted" := TIME;
                    IF HRLeaveCarryOver2.MODIFY THEN
                        Carryover := TRUE;
                END;
            END;
        END;
        COMMIT;
    end;

    procedure CloseLeavePeriod(LeavePeriodCode: Code[50]) LeavePeriodClosed: Boolean
    begin
        LeavePeriodClosed := FALSE;

        LeavePeriods.RESET;
        IF LeavePeriods.GET(LeavePeriodCode) THEN BEGIN

        END;
    end;

    procedure CalculateLeaveReimbursment(LeaveType: Code[50]; LeavePeriod: Code[20]; LeaveStartDate: Date; DaysApplied: Integer; BaseCalendarCode: Code[10]; ActualReturnDate: Date; LeaveEndDate: Date) TotalLeaveDays: Integer
    var
        NonWorkingDay: Boolean;
        LeaveDays: Integer;
        LeaveEndDateFormula: DateFormula;
    begin
        TotalLeaveDays := 0;
        LeaveTypes.RESET;
        LeaveTypes.GET(LeaveType);
        IF LeaveTypes."Inclusive of Non Working Days" THEN BEGIN
            LeaveDays := DaysApplied - 1;
            EVALUATE(LeaveEndDateFormula, FORMAT(LeaveDays) + 'D');
            LeaveEndDate := CALCDATE(LeaveEndDateFormula, LeaveStartDate);
        END ELSE BEGIN
            LeaveDays := DaysApplied;
            LeaveEndDate := CALCDATE('-1D', LeaveStartDate);
            WHILE LeaveDays > 0 DO BEGIN
                TotalLeaveDays := TotalLeaveDays + 1;
                LeaveEndDate := CALCDATE('1D', LeaveEndDate);
                IF BaseCalendarCode = '' THEN
                    NonWorkingDay := CalendarMgmt.CheckDateStatus(LeaveTypes."Base Calendar", LeaveEndDate, Description)
                ELSE
                    NonWorkingDay := CalendarMgmt.CheckDateStatus(BaseCalendarCode, LeaveEndDate, Description);
                IF NOT NonWorkingDay THEN BEGIN
                    LeaveDays := LeaveDays - 1;
                END;
            END;
        END;
    end;

    procedure SendEmailNotificationOnPostLeave(ApplicationNo: Code[50])
    var
        HRLeaveApplication: Record 50127;
        HREmployee: Record 5200;
        Receipients: List of [Text];
    begin
        //  SMTP.GET;

        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."No.", ApplicationNo);
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            Employee.RESET;
            Employee.SETRANGE(Employee."No.", HRLeaveApplication."Employee No.");
            Employee.SETFILTER(Employee."Company E-Mail", '<>%1', '');
            IF Employee.FINDFIRST THEN BEGIN
                Receipients.Add(Employee."Company E-Mail");

                EmailMessageCu.Create(Format(Receipients), 'Leave Application ' + HRLeaveApplication."No.", '', TRUE);
                EmailMessageCu.AppendToBody('Dear' + ' ' + HRLeaveApplication."Employee Name" + ',');
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('Your Leave Application has been approved and Posted. The leave application no. is  ' + HRLeaveApplication."No.");
                EmailMessageCu.AppendToBody('Leave starts on  ' + FORMAT(HRLeaveApplication."Leave Start Date", 0, 4) + ' and ends on  ' + FORMAT(HRLeaveApplication."Leave End Date", 0, 4));
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('Thank you.');
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody(CompanyName);
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('This is a system generated mail. Please do not reply to this Email');
                EmailCu.Send(EmailMessageCu);

                IF Employee."Supervisor Job No." <> '' THEN BEGIN
                    HREmployee.RESET;
                    HREmployee.SETRANGE(HREmployee."No.", Employee."Supervisor Job No.");
                    HREmployee.SETFILTER(HREmployee."Company E-Mail", '<>%1', '');
                    IF HREmployee.FINDFIRST THEN BEGIN
                        Receipients.Add(HREmployee."Company E-Mail");
                        EmailMessageCu.Create(Format(Receipients), 'Leave Application ' + HRLeaveApplication."No.", '', TRUE);
                        EmailMessageCu.AppendToBody('Dear' + ' ' + HREmployee."First Name" + ',');
                        EmailMessageCu.AppendToBody('<br><br>');
                        EmailMessageCu.AppendToBody('Kindly note:  ' + HRLeaveApplication."Employee Name" + ' will be away on leave');
                        EmailMessageCu.AppendToBody('<br><br>');
                        EmailMessageCu.AppendToBody('From,' + FORMAT(HRLeaveApplication."Leave Start Date", 0, 4) + ' to ' + FORMAT(HRLeaveApplication."Leave End Date", 0, 4));
                        EmailMessageCu.AppendToBody('<br><br>');
                        EmailMessageCu.AppendToBody('Thank you.');
                        EmailMessageCu.AppendToBody('<br><br>');
                        EmailMessageCu.AppendToBody(CompanyName);
                        EmailMessageCu.AppendToBody('<br><br>');
                        EmailMessageCu.AppendToBody('<br><br>');
                        EmailMessageCu.AppendToBody('This is a system generated mail. Please do not reply to this Email');
                        EmailCu.Send(EmailMessageCu)

                    END;
                END;
            END;

            Employee.RESET;
            Employee.SETRANGE(Employee."No.", HRLeaveApplication."Substitute No.");
            Employee.SETFILTER(Employee."Company E-Mail", '<>%1', '');
            IF Employee.FINDFIRST THEN BEGIN
                // SMTPMail.CreateMessage(CompanyName, '','', Employee."Company E-Mail", 'Leave Application ' + HRLeaveApplication."No.", '', TRUE);
                EmailMessageCu.AppendToBody('Dear' + ' ' + HRLeaveApplication."Substitute Name" + ',');
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('Kindly note:  ' + HRLeaveApplication."Employee Name" + ' will be away on leave');
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('From,' + FORMAT(HRLeaveApplication."Leave Start Date", 0, 4) + ' to ' + FORMAT(HRLeaveApplication."Leave End Date", 0, 4));
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('During this Period you have been appointed as his/her reliever');
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('Thank you.');
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody(CompanyName);
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('<br><br>');
                EmailMessageCu.AppendToBody('This is a system generated mail. Please do not reply to this Email');
                EmailCu.Send(EmailMessageCu);
            END;
        END;
    end;

    procedure CarryOverLeaveDays(LeavePeriod: Code[20])
    var
        LeaveTypes: Record 50134;
        HRLeaveLedgerEntries: Record 50132;
        Employee: Record 5200;
        TotalLeaveDays: Integer;
        HRLeavePeriods: Record 50135;
        PostingDate: Date;
        lineNo: Integer;
        NewLeavePeriod: Code[30];
        Text0001: Label 'Leave carry over from the period';
        HRLeaveLedgerEntries2: Record 50132;
    begin
        HRLeavePeriods.RESET;
        HRLeavePeriods.SETRANGE(HRLeavePeriods.Closed, FALSE);
        IF HRLeavePeriods.FINDFIRST THEN BEGIN
            PostingDate := HRLeavePeriods."Start Date";
            NewLeavePeriod := HRLeavePeriods.Code;
        END;



        LeaveTypes.RESET;
        LeaveTypes.SETRANGE(LeaveTypes.Balance, LeaveTypes.Balance::"Carry Forward");
        IF LeaveTypes.FINDSET THEN BEGIN
            REPEAT
                Employee.RESET;
                Employee.SETRANGE(Employee.Status, Employee.Status::Active);
                IF Employee.FINDSET THEN BEGIN
                    REPEAT
                        TotalLeaveDays := 0;
                        LeaveLedgerEntry.RESET;
                        LeaveLedgerEntry.SETRANGE(LeaveLedgerEntry."Leave Period", LeavePeriod);
                        LeaveLedgerEntry.SETRANGE(LeaveLedgerEntry."Employee No.", Employee."No.");
                        LeaveLedgerEntry.SETRANGE(LeaveLedgerEntry."Leave Type", LeaveTypes.Code);
                        IF LeaveLedgerEntry.FINDSET THEN BEGIN
                            lineNo := 0;
                            REPEAT
                                TotalLeaveDays := TotalLeaveDays + LeaveLedgerEntry.Days;
                            UNTIL LeaveLedgerEntry.NEXT = 0;
                        END;

                        HRLeaveLedgerEntries.RESET;
                        IF HRLeaveLedgerEntries.FINDLAST THEN
                            HRLeaveLedgerEntries."Line No." := HRLeaveLedgerEntries."Line No." + 1;
                        HRLeaveLedgerEntries."Document No." := LeavePeriod;
                        HRLeaveLedgerEntries."Posting Date" := PostingDate;
                        HRLeaveLedgerEntries."Entry Type" := HRLeaveLedgerEntries."Entry Type"::"Carry forward";
                        HRLeaveLedgerEntries."Leave Type" := LeaveTypes.Code;
                        HRLeaveLedgerEntries."Leave Period" := NewLeavePeriod;
                        HRLeaveLedgerEntries."Employee No." := Employee."No.";
                        IF LeaveTypes."Max Carry Forward Days" <= TotalLeaveDays THEN BEGIN
                            HRLeaveLedgerEntries.Days := LeaveTypes."Max Carry Forward Days"
                        END ELSE BEGIN
                            HRLeaveLedgerEntries.Days := TotalLeaveDays;
                        END;
                        HRLeaveLedgerEntries.Description := Text0001 + ' ' + FORMAT(LeavePeriod);
                        HRLeaveLedgerEntries."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                        HRLeaveLedgerEntries."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                        HRLeaveLedgerEntries."Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
                        HRLeaveLedgerEntries."Shortcut Dimension 4 Code" := Employee."Shortcut Dimension 4 Code";
                        HRLeaveLedgerEntries."Shortcut Dimension 5 Code" := Employee."Shortcut Dimension 5 Code";
                        HRLeaveLedgerEntries."Shortcut Dimension 6 Code" := Employee."Shortcut Dimension 6 Code";
                        HRLeaveLedgerEntries."Shortcut Dimension 7 Code" := Employee."Shortcut Dimension 7 Code";
                        HRLeaveLedgerEntries."Shortcut Dimension 8 Code" := Employee."Shortcut Dimension 8 Code";
                        HRLeaveLedgerEntries.INSERT;
                    UNTIL Employee.NEXT = 0;
                END;
            UNTIL LeaveTypes.NEXT = 0;
        END;
    end;
}


codeunit 50024 "HR Management WS"
{

    trigger OnRun()
    begin

        //**************************************** Leave Management Services ************************************************************************************************************************
        // MESSAGE(FORMAT(GetLeaveEndDate('E0010', 'ANNUAL', 111119D, 5)));
        // MESSAGE(FORMAT(GetLeaveReturnDate('E0010', 'ANNUAL', 111119D, 5)))
    end;

    var
        CompanyInformation: Record 79;
        Employee: Record 5200;
        HRLeavePlannerHeader: Record 50125;
        HRLeaveApplication: Record 50127;
        HRLeaveReimbursement: Record 50128;
        HumanResourcesSetup: Record 5218;
        ApprovalEntry: Record 454;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        HRApprovalManager: Codeunit 50038;
        HRLeaveMgmt: Codeunit 50036;
        SERVERDIRECTORYPATH: Label 'C:\inetpub\wwwroot\ICDC\TenantData';
        TxtCharsToKeep: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.@';
        Dates: Codeunit 50043;
        HRTrainingApplication: Record 50164;
        HRTrainingNeedsHeader: Record 50157;
        HRTrainingNeedsLine: Record 50158;
        HRTrainingEvaluation: Record 50161;
        //FundsGeneralSetup: Record 50031;
        CompanyDataDirectory: Text[50];
        EmployeeDataDirectory: Text[50];
        HRRequiredDocumentChecklist: Record 50178;
        HRJobLookupValue: Record 50097;
        Text_0001: Label 'You cannot apply for another leave before another one ends';
        TrainingApplicationError: Label 'You can not apply for another Training if you have not submited your previous Training attendance Evaluation. Please submit your Training Evaluation to proceed';
        Success: Label 'Success';
        HRLeavePlannerHeaderRec: Record 50125;
        HRLeavePlannerLineRec: Record 50126;
        HREmployeeAppraisalHeaderRec: Record 50138;
        HrAppraisalAcademicProfQuaRec: Record 50182;
        HrEmployeeApprasalKPI: Record 50254;
        HRAppraisalAssesmentFactor: Record 50191;
        HRAppraisalProblemsChalleng: Record 50185;
        HRAppraisalCourseTraining: Record 50187;
        HRAppraisalPerformanceFacto: Record 50186;
        HrAppraisalPerformaceSugge: Record 50189;
        HRAppraisalTrainingNeedOb: Record 50194;
        HRAppraisalIdentifiedPotent: Record 50195;
        HRAppraisalRecommendation: Record 50231;


    procedure "`"("EmployeeNo.": Code[20]) OpenLeavePlannerExist: Boolean
    begin

        HRLeavePlannerHeader.RESET;
        HRLeavePlannerHeader.SETRANGE(HRLeavePlannerHeader."User ID", "EmployeeNo.");
        HRLeavePlannerHeader.SETRANGE(HRLeavePlannerHeader.Status, HRLeavePlannerHeader.Status::Open);
        IF HRLeavePlannerHeader.FINDFIRST THEN BEGIN
            OpenLeavePlannerExist := TRUE;
        END;
    end;


    procedure CheckOpenLeaveApplicationExists("EmployeeNo.": Code[20]) OpenLeaveApplicationExist: Boolean
    begin
        OpenLeaveApplicationExist := FALSE;
        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."Employee No.", "EmployeeNo.");
        HRLeaveApplication.SETFILTER(HRLeaveApplication.Status, '=%1|%2', 1, 2);
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            OpenLeaveApplicationExist := TRUE;
        END;
    end;

    procedure CheckLeaveApplicationExists("LeaveApplicationNo.": Code[20]; "EmployeeNo.": Code[20]) LeaveApplicationExist: Boolean
    begin
        LeaveApplicationExist := FALSE;
        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."Employee No.", "EmployeeNo.");
        HRLeaveApplication.SETRANGE(HRLeaveApplication."No.", "LeaveApplicationNo.");
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            LeaveApplicationExist := TRUE;
        END;
    end;


    procedure CreateLeaveApplication("EmployeeNo.": Code[20]; LeaveType: Code[50]; LeaveStartDate: Date; DaysApplied: Integer; ReasonForLeave: Text; "SubstituteEmployeeNo.": Code[20]) LeaveApplicationCreated: Text
    var
        HRLeaveType: Record 50134;
        Text101: Label 'Applied number of days must be equal to %1';
    begin
        LeaveApplicationCreated := '';

        HumanResourcesSetup.GET;

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        //check running leaves
        CheckRunningLeaves("EmployeeNo.", LeaveStartDate);


        HRLeaveApplication.INIT;
        HRLeaveApplication."No." := NoSeriesMgt.GetNextNo(HumanResourcesSetup."Leave Application Nos.", 0D, TRUE);
        HRLeaveApplication."Document Date" := TODAY;
        HRLeaveApplication."Posting Date" := LeaveStartDate;
        HRLeaveApplication."Employee No." := "EmployeeNo.";
        HRLeaveApplication.VALIDATE(HRLeaveApplication."Employee No.");

        //check mandatory number of days
        HRLeaveType.RESET;
        HRLeaveType.SETRANGE(Code, LeaveType);
        HRLeaveType.SETRANGE("Take as Block", TRUE);
        IF HRLeaveType.FINDFIRST THEN BEGIN
            IF HRLeaveType.Days <> DaysApplied THEN
                ERROR(Text101, FORMAT(HRLeaveType.Days));
        END;
        // End check mandatory number of days

        HRLeaveApplication."Leave Type" := LeaveType;
        HRLeaveApplication.VALIDATE(HRLeaveApplication."Leave Type");
        HRLeaveApplication."Leave Start Date" := LeaveStartDate;
        HRLeaveApplication."Days Applied" := DaysApplied;
        HRLeaveApplication.VALIDATE(HRLeaveApplication."Days Applied");
        HRLeaveApplication."Substitute No." := "SubstituteEmployeeNo.";
        HRLeaveApplication.VALIDATE(HRLeaveApplication."Substitute No.");
        HRLeaveApplication."Reason for Leave" := ReasonForLeave;
        HRLeaveApplication."User ID" := Employee."User ID";
        IF HRLeaveApplication.INSERT THEN BEGIN
            LeaveApplicationCreated := '200: Leave Application No ' + HRLeaveApplication."No." + ' Created Successfully';
        END ELSE
            LeaveApplicationCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyLeaveApplication("LeaveApplicationNo.": Code[20]; "EmployeeNo.": Code[20]; LeaveType: Code[50]; LeaveStartDate: Date; DaysApplied: Integer; ReasonForLeave: Text; "SubstituteEmployeeNo.": Code[20]) LeaveApplicationModified: Text
    var
        Text101: Label 'Applied number of days must be equal to %1';
        HRLeaveType: Record 50134;
    begin
        ERROR(Text_0001);
        LeaveApplicationModified := '';
        HumanResourcesSetup.GET;

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."No.", "LeaveApplicationNo.");
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            HRLeaveApplication."Posting Date" := LeaveStartDate;
            HRLeaveApplication."Employee No." := "EmployeeNo.";
            HRLeaveApplication.VALIDATE(HRLeaveApplication."Employee No.");

            //check mandatory number of days
            HRLeaveType.RESET;
            HRLeaveType.SETRANGE(Code, LeaveType);
            HRLeaveType.SETRANGE("Take as Block", TRUE);
            IF HRLeaveType.FINDFIRST THEN BEGIN
                IF HRLeaveType.Days <> DaysApplied THEN
                    ERROR(Text101, FORMAT(HRLeaveType.Days));
            END;
            // End check mandatory number of days

            HRLeaveApplication."Days Applied" := DaysApplied;
            HRLeaveApplication.VALIDATE(HRLeaveApplication."Days Applied");
            HRLeaveApplication."Leave Type" := LeaveType;
            HRLeaveApplication.VALIDATE(HRLeaveApplication."Leave Type");
            HRLeaveApplication."Leave Start Date" := LeaveStartDate;
            HRLeaveApplication."Substitute No." := "SubstituteEmployeeNo.";
            HRLeaveApplication.VALIDATE(HRLeaveApplication."Substitute No.");
            HRLeaveApplication."Reason for Leave" := ReasonForLeave;
            HRLeaveApplication."User ID" := Employee."User ID";
            LeaveApplicationModified := '200: Leave Application No ' + HRLeaveApplication."No." + ' Modified Successfully';
        END ELSE
            LeaveApplicationModified := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;

    procedure CheckRunningLeaves("EmployeeNo.": Code[20]; StartDate: Date)
    begin
        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE("Employee No.", "EmployeeNo.");
        HRLeaveApplication.SETRANGE(Posted, TRUE);
        IF HRLeaveApplication.FINDSET THEN BEGIN
            REPEAT
                IF (StartDate <= HRLeaveApplication."Leave End Date") THEN
                    ERROR(Text_0001);
            UNTIL HRLeaveApplication.NEXT = 0;
        END;
    end;


    procedure GetLeaveEndDate("EmployeeNo.": Code[20]; LeaveType: Code[50]; LeaveStartDate: Date; DaysApplied: Integer) LeaveEndDate: Date
    var
        LeaveStartDateD: Date;
    begin
        LeaveEndDate := 0D;
        //EVALUATE(LeaveStartDateD,LeaveStartDate);
        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            LeaveEndDate := HRLeaveMgmt.CalculateLeaveEndDate(LeaveType, '', LeaveStartDate, DaysApplied, Employee."Leave Calendar");
            //MESSAGE(FORMAT(LeaveEndDate));
        END;
    end;


    procedure GetLeaveReturnDate("EmployeeNo.": Code[20]; LeaveType: Code[50]; LeaveStartDate: Date; DaysApplied: Integer) LeaveReturnDate: Date
    begin
        LeaveReturnDate := 0D;

        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            LeaveReturnDate := HRLeaveMgmt.CalculateLeaveReturnDate(LeaveType, '',
                                                                  HRLeaveMgmt.CalculateLeaveEndDate(LeaveType, '', LeaveStartDate, DaysApplied,
                                                                  Employee."Leave Calendar"), Employee."Leave Calendar");
        END;
    end;

    procedure GetOpenLeaveApplication("EmployeeNo.": Code[20]) "OpenLeaveApplicationNo.": Code[20]
    begin
        "OpenLeaveApplicationNo." := '';
        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."Employee No.", "EmployeeNo.");
        HRLeaveApplication.SETRANGE(HRLeaveApplication.Status, HRLeaveApplication.Status::Open);
        IF HRLeaveApplication.FINDLAST THEN BEGIN
            "OpenLeaveApplicationNo." := HRLeaveApplication."No.";
        END;
    end;


    procedure GetLeaveApplicationStatus("LeaveApplicationNo.": Code[20]) LeaveApplicationStatus: Text
    begin
        LeaveApplicationStatus := '';
        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."No.", "LeaveApplicationNo.");
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            LeaveApplicationStatus := FORMAT(HRLeaveApplication.Status);
        END;
    end;


    procedure CheckLeaveApplicationApprovalWorkflowEnabled("HRLeaveApplicationNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;

        HRLeaveApplication.RESET;
        //IF HRLeaveApplication.GET("HRLeaveApplicationNo.") THEN
        //    ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckHRLeaveApplicationApprovalsWorkflowEnabled(HRLeaveApplication);
    end;


    procedure SendLeaveApplicationApprovalRequest("HRLeaveApplicationNo.": Code[20]) LeaveApplicationApprovalRequestSent: Text
    begin
        LeaveApplicationApprovalRequestSent := '';

        HRLeaveApplication.RESET;
        IF HRLeaveApplication.GET("HRLeaveApplicationNo.") THEN BEGIN
            // ApprovalsMgmtExt.OnSendHRLeaveApplicationForApproval(HRLeaveApplication);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", HRLeaveApplication."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            IF ApprovalEntry.FINDFIRST THEN
                LeaveApplicationApprovalRequestSent := '200: Leave Approval Request sent Successfully '
            ELSE
                LeaveApplicationApprovalRequestSent := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;

        END;
    end;


    procedure CancelLeaveApplicationApprovalRequest("LeaveApplicationNo.": Code[20]) LeaveApplicationApprovalRequestCanceled: Text
    begin
        LeaveApplicationApprovalRequestCanceled := '';

        HRLeaveApplication.RESET;
        IF HRLeaveApplication.GET("LeaveApplicationNo.") THEN BEGIN
            // ApprovalsMgmtExt.OnCancelHRLeaveApplicationApprovalRequest(HRLeaveApplication);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", HRLeaveApplication."No.");
            IF ApprovalEntry.FINDLAST THEN BEGIN
                IF ApprovalEntry.FINDFIRST THEN
                    LeaveApplicationApprovalRequestCanceled := '200: Leave Approval Request Cancelled Successfully '
                ELSE
                    LeaveApplicationApprovalRequestCanceled := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
            END;
        END;
    end;


    procedure ReopenLeaveApplication("LeaveApplicationNo.": Code[20]) LeaveApplicationOpened: Boolean
    begin
        LeaveApplicationOpened := FALSE;

        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."No.", "LeaveApplicationNo.");
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            HRApprovalManager.ReOpenHRLeaveApplication(HRLeaveApplication);
            LeaveApplicationOpened := TRUE;
        END;
    end;


    procedure ApproveLeaveApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]) Approved: Text
    var
        "EntryNo.": Integer;
    begin
        Approved := '';
        "EntryNo." := 0;

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", Employee."User ID");
        ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            "EntryNo." := ApprovalEntry."Entry No.";
            //ApprovalsMgmtExt.ApproveApprovalRequests(ApprovalEntry);
        END;
        COMMIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Entry No.", "EntryNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Approved);

        IF ApprovalEntry.FINDFIRST THEN
            Approved := '200: Leave Approved Successfully '
        ELSE
            Approved := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure RejectLeaveApplication("EmployeeNo.": Code[20]; "DocumentNo.": Code[20]) Rejected: Text
    var
        "EntryNo.": Integer;
    begin
        Rejected := '';
        "EntryNo." := 0;

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", Employee."User ID");
        ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            "EntryNo." := ApprovalEntry."Entry No.";
            // ApprovalsMgmtExt.RejectApprovalRequests(ApprovalEntry);
        END;
        COMMIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry."Entry No.", "EntryNo.");
        ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Rejected);
        IF ApprovalEntry.FINDFIRST THEN
            Rejected := '200: Leave Rejected Successfully '
        ELSE
            Rejected := '400:' + GETLASTERRORCODE + '-' + GETLASTERRORTEXT;


        //**************************************** HR Leave Reimbursement ********************************************************************************************************************************************************
    end;


    procedure GetEmployeeLeaveBalance(EmployeeNo: Code[20]; LeaveType: Code[50]) LeaveBalance: Decimal
    var
        LeaveLedgerEntries: Record 50132;
        LeavePeriods: Record 50135;
        LeaveYear: Integer;
    begin
        //Calculate Leave Balance
        LeavePeriods.RESET;
        LeavePeriods.SETRANGE(Closed, FALSE);
        IF LeavePeriods.FINDFIRST THEN
            LeaveYear := LeavePeriods."Leave Year";

        LeaveLedgerEntries.RESET;
        LeaveLedgerEntries.SETRANGE(LeaveLedgerEntries."Employee No.", EmployeeNo);
        LeaveLedgerEntries.SETRANGE(LeaveLedgerEntries."Leave Type", LeaveType);
        LeaveLedgerEntries.SETRANGE("Leave Year", LeaveYear);
        LeaveLedgerEntries.CALCSUMS(LeaveLedgerEntries.Days);
        LeaveBalance := LeaveLedgerEntries.Days;
    end;

    procedure CheckLeaveReimbursementExists(LeaveReimbursementNo: Code[20]; "EmployeeNo.": Code[20]) LeaveReimbursementExist: Boolean
    begin
        LeaveReimbursementExist := FALSE;
        HRLeaveReimbursement.RESET;
        HRLeaveReimbursement.SETRANGE(HRLeaveReimbursement."Employee No.", "EmployeeNo.");
        HRLeaveReimbursement.SETRANGE(HRLeaveReimbursement."No.", LeaveReimbursementNo);
        IF HRLeaveReimbursement.FINDFIRST THEN BEGIN
            LeaveReimbursementExist := TRUE;
        END;
    end;

    procedure CreateLeaveReimbursement("EmployeeNo.": Code[20]) LeaveReimbursementCreated: Boolean
    var
        "DocNo.": Code[30];
    begin
        LeaveReimbursementCreated := FALSE;

        HumanResourcesSetup.GET;

        "DocNo." := NoSeriesMgt.GetNextNo(HumanResourcesSetup."Leave Reimbursement Nos.", 0D, TRUE);
        IF "DocNo." <> '' THEN BEGIN
            HRLeaveReimbursement.RESET;
            HRLeaveReimbursement."No." := "DocNo.";
            HRLeaveReimbursement."Document Date" := TODAY;
            HRLeaveReimbursement."Employee No." := "EmployeeNo.";
            HRLeaveReimbursement.VALIDATE(HRLeaveReimbursement."Employee No.");
            IF HRLeaveReimbursement.INSERT THEN BEGIN
                LeaveReimbursementCreated := TRUE;
            END;
        END;
    end;

    /// <summary>
    /// GetLeaveReimbursementNo.
    /// </summary>
    /// <param name="EmployeeNo.">Code[20].</param>
    /// <returns>Return variable OpenLeaveReimbursementNo. of type Code[20].</returns>
    procedure GetLeaveReimbursementNo("EmployeeNo.": Code[20]) "OpenLeaveReimbursementNo.": Code[20]
    begin
        "OpenLeaveReimbursementNo." := '';
        HRLeaveReimbursement.RESET;
        HRLeaveReimbursement.SETRANGE(HRLeaveReimbursement."Employee No.", "EmployeeNo.");
        HRLeaveReimbursement.SETRANGE(HRLeaveReimbursement.Status, HRLeaveReimbursement.Status::Open);
        IF HRLeaveReimbursement.FINDLAST THEN BEGIN
            "OpenLeaveReimbursementNo." := HRLeaveReimbursement."No.";
        END;
    end;

    procedure ModifyLeaveReimbursement("LeaveReimbursementNo.": Code[20]; "EmployeeNo.": Code[20]; "LeaveApplicationNo.": Code[20]; ActualReturnDate: Date; ReasonForReimbursement: Text[250]) LeaveReimbursementModified: Boolean
    begin
        LeaveReimbursementModified := FALSE;
        HRLeaveReimbursement.RESET;
        HRLeaveReimbursement.SETRANGE(HRLeaveReimbursement."No.", "LeaveReimbursementNo.");
        IF HRLeaveReimbursement.FINDFIRST THEN BEGIN
            HRLeaveReimbursement."Document Date" := TODAY;
            HRLeaveReimbursement."Posting Date" := TODAY;
            HRLeaveReimbursement."Leave Application No." := "LeaveApplicationNo.";
            HRLeaveReimbursement.VALIDATE(HRLeaveReimbursement."Leave Application No.");
            HRLeaveReimbursement."Actual Return Date" := ActualReturnDate;
            HRLeaveReimbursement.VALIDATE(HRLeaveReimbursement."Actual Return Date");
            HRLeaveReimbursement."Reason for Reimbursement" := ReasonForReimbursement;
            IF HRLeaveReimbursement.MODIFY THEN
                LeaveReimbursementModified := TRUE;
        END;
    end;

    procedure GetLeaveReimbursementStatus("LeaveReimbursementNo.": Code[20]) LeaveReimbursementStatus: Text
    begin
        LeaveReimbursementStatus := '';
        HRLeaveReimbursement.RESET;
        HRLeaveReimbursement.SETRANGE(HRLeaveReimbursement."No.", "LeaveReimbursementNo.");
        IF HRLeaveReimbursement.FINDFIRST THEN BEGIN
            LeaveReimbursementStatus := FORMAT(HRLeaveReimbursement.Status);
        END;
    end;

    procedure CheckLeaveReimbursementApprovalWorkflowEnabled("HRLeaveReimbursementNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;
        HRLeaveReimbursement.RESET;
        // IF HRLeaveReimbursement.GET("HRLeaveReimbursementNo.") THEN
        //     ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckHRLeaveReimbusmentApprovalsWorkflowEnabled(HRLeaveReimbursement);
    end;

    procedure SendLeaveReimbursementApprovalRequest("HRLeaveReimbursementNo.": Code[20]) LeaveReimbursementApprovalRequestSent: Boolean
    begin
        LeaveReimbursementApprovalRequestSent := FALSE;

        HRLeaveReimbursement.RESET;
        IF HRLeaveReimbursement.GET("HRLeaveReimbursementNo.") THEN BEGIN
            //   ApprovalsMgmtExt.OnSendHRLeaveReimbusmentForApproval(HRLeaveReimbursement);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", HRLeaveReimbursement."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            IF ApprovalEntry.FINDFIRST THEN
                LeaveReimbursementApprovalRequestSent := TRUE;
        END;
    end;

    procedure CancelLeaveReimbursementApprovalRequest("LeaveReimbursementNo.": Code[20]) LeaveReimbursementApprovalRequestCanceled: Boolean
    begin
        LeaveReimbursementApprovalRequestCanceled := FALSE;

        HRLeaveReimbursement.RESET;
        IF HRLeaveReimbursement.GET("LeaveReimbursementNo.") THEN BEGIN
            // ApprovalsMgmtExt.OnCancelHRLeaveReimbusmentApprovalRequest(HRLeaveReimbursement);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", HRLeaveReimbursement."No.");
            IF ApprovalEntry.FINDLAST THEN BEGIN
                IF ApprovalEntry.Status = ApprovalEntry.Status::Canceled THEN
                    LeaveReimbursementApprovalRequestCanceled := TRUE;
            END;
        END;

        //**************************************************** HR Employee Target Setting && Appraisal *****************************************************************************************************************************************************
    end;

    procedure CheckOpenTrainingNeedApplicationExists("EmployeeNo.": Code[20]) OpenTrainingNeedApplicationExist: Boolean
    begin
        OpenTrainingNeedApplicationExist := FALSE;
        HRTrainingNeedsHeader.RESET;
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader."Employee No.", "EmployeeNo.");
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader.Status, HRTrainingNeedsHeader.Status::Open);
        IF HRTrainingNeedsHeader.FINDFIRST THEN BEGIN
            OpenTrainingNeedApplicationExist := TRUE;
        END;
    end;

    procedure CheckTrainingNeedApplicationExists("TrainingNeedApplicationNo.": Code[20]; "EmployeeNo.": Code[20]) TrainingNeedApplicationExist: Boolean
    begin
        TrainingNeedApplicationExist := FALSE;
        HRTrainingNeedsHeader.RESET;
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader."Employee No.", "EmployeeNo.");
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader."No.", "TrainingNeedApplicationNo.");
        IF HRTrainingNeedsHeader.FINDFIRST THEN BEGIN
            TrainingNeedApplicationExist := TRUE;
        END;
    end;

    procedure CreateTrainingNeedApplication("EmployeeNo.": Code[20]) TrainingNeedApplicationCreated: Boolean
    begin
        TrainingNeedApplicationCreated := FALSE;

        HumanResourcesSetup.GET;

        HRTrainingNeedsHeader.INIT;
        HRTrainingNeedsHeader."No." := NoSeriesMgt.GetNextNo(HumanResourcesSetup."Training Needs Nos", 0D, TRUE);
        HRTrainingNeedsHeader."Date of Request" := TODAY;
        HRTrainingNeedsHeader."Employee No." := "EmployeeNo.";
        HRTrainingNeedsHeader.VALIDATE(HRTrainingNeedsHeader."Employee No.");
        IF HRTrainingNeedsHeader.INSERT THEN BEGIN
            TrainingNeedApplicationCreated := TRUE;
        END;
    end;

    /// <summary>
    /// GetTrainingNeedApplicationNo.
    /// </summary>
    /// <param name="EmployeeNo.">Code[20].</param>
    /// <returns>Return variable OpenTrainingNeedApplicationNo. of type Code[20].</returns>
    procedure GetTrainingNeedApplicationNo("EmployeeNo.": Code[20]) "OpenTrainingNeedApplicationNo.": Code[20]
    begin
        "OpenTrainingNeedApplicationNo." := '';
        HRTrainingNeedsHeader.RESET;
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader."Employee No.", "EmployeeNo.");
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader.Status, HRTrainingNeedsHeader.Status::Open);
        IF HRTrainingNeedsHeader.FINDFIRST THEN BEGIN
            "OpenTrainingNeedApplicationNo." := HRTrainingNeedsHeader."No.";
        END;
    end;

    procedure CreateTrainingNeedsApplicationLine(EmployeeNo: Code[20]; DevelopmentNeeds: Text[100]; InterventionRequired: Text[100]; Objectives: Text[100]; ProposedTrainingProvider: Code[20]; "Location&Venue": Text[100]; ProposedPeriod: Option " ",Q1,Q2,Q3,Q4; Description: Text[250]; TrainingScheduleFrom: Date; TrainingScheduleTo: Date; EstimatedCost: Decimal) HRTrainingNeedsApplicationLineCreated: Boolean
    begin
        HRTrainingNeedsApplicationLineCreated := FALSE;

        HRTrainingNeedsHeader.RESET;
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader."Employee No.", EmployeeNo);
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader.Status, HRTrainingNeedsHeader.Status::Open);

        IF HRTrainingNeedsHeader.FINDFIRST THEN BEGIN
            HRTrainingNeedsLine.INIT;
            HRTrainingNeedsLine."No." := HRTrainingNeedsHeader."No.";
            HRTrainingNeedsLine."Employee No." := HRTrainingNeedsHeader."Employee No.";
            HRTrainingNeedsLine.VALIDATE(HRTrainingNeedsLine."Employee No.");
            HRTrainingNeedsLine."Development Needs" := DevelopmentNeeds;
            HRTrainingNeedsLine.Objectives := Objectives;
            HRTrainingNeedsLine."Proposed Training Provider" := ProposedTrainingProvider;
            HRTrainingNeedsLine."Training Location & Venue" := "Location&Venue";
            HRTrainingNeedsLine."Proposed Period" := ProposedPeriod;
            HRTrainingNeedsLine.Description := Description;
            HRTrainingNeedsLine."Training Scheduled Date" := TrainingScheduleFrom;
            HRTrainingNeedsLine."Training Scheduled Date To" := TrainingScheduleTo;
            HRTrainingNeedsLine."Estimated Cost" := EstimatedCost;

            CASE InterventionRequired OF
                'Training':
                    HRTrainingNeedsLine."Intervention Required" := HRTrainingNeedsLine."Intervention Required"::Training;
                'Coaching':
                    HRTrainingNeedsLine."Intervention Required" := HRTrainingNeedsLine."Intervention Required"::Coaching;
                'Mentoring':
                    HRTrainingNeedsLine."Intervention Required" := HRTrainingNeedsLine."Intervention Required"::Mentoring;
                'Other':
                    HRTrainingNeedsLine."Intervention Required" := HRTrainingNeedsLine."Intervention Required"::Other;
            END;

            IF HRTrainingNeedsLine.INSERT THEN BEGIN
                HRTrainingNeedsApplicationLineCreated := TRUE;
            END;
        END;
    end;

    procedure ModifyTrainingNeedApplication("TrainingNeedApplicationNo.": Code[20]; "Employee No.": Code[20]; CalendarYear: Code[50]; AppraisalPeriod: Code[50]) TrainingNeedApplicationModified: Boolean
    begin
        TrainingNeedApplicationModified := FALSE;

        HRTrainingNeedsHeader.RESET;
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader."Employee No.", "Employee No.");
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader."No.", "TrainingNeedApplicationNo.");

        IF HRTrainingNeedsHeader.FINDFIRST THEN BEGIN

            HRTrainingNeedsHeader."Date of Request" := TODAY;
            HRTrainingNeedsHeader."Calendar Year" := CalendarYear;
            HRTrainingNeedsHeader."Appraisal Period" := UPPERCASE('Recommended Training for Appraisal Period ') + AppraisalPeriod;
            HRTrainingNeedsHeader.MODIFY;

            TrainingNeedApplicationModified := TRUE;

        END;
    end;

    procedure ModifyTrainingNeedsApplicationLine(LineNo: Integer; "TrainingNeedApplicationNo.": Code[20]; EmployeeNo: Code[20]; DevelopmentNeeds: Text[100]; InterventionRequired: Text[100]; Objectives: Text[100]; ProposedTrainingProvider: Code[20]; "Location&Venue": Text[100]; ProposedPeriod: Option " ",Q1,Q2,Q3,Q4; Description: Text[250]; TrainingScheduleFrom: Date; TrainingScheduleTo: Date; EstimatedCost: Decimal) HRTrainingNeedsApplicationModified: Boolean
    begin
        HRTrainingNeedsApplicationModified := FALSE;

        HRTrainingNeedsLine.RESET;

        HRTrainingNeedsLine.SETRANGE(HRTrainingNeedsLine."Line No.", LineNo);
        HRTrainingNeedsLine.SETRANGE("No.", "TrainingNeedApplicationNo.");

        IF HRTrainingNeedsLine.FINDFIRST THEN BEGIN
            HRTrainingNeedsLine."Development Needs" := DevelopmentNeeds;
            HRTrainingNeedsLine.Objectives := Objectives;
            HRTrainingNeedsLine."Proposed Training Provider" := ProposedTrainingProvider;
            HRTrainingNeedsLine."Training Location & Venue" := "Location&Venue";
            HRTrainingNeedsLine."Proposed Period" := ProposedPeriod;
            HRTrainingNeedsLine.Description := Description;
            HRTrainingNeedsLine."Training Scheduled Date" := TrainingScheduleFrom;
            HRTrainingNeedsLine."Training Scheduled Date To" := TrainingScheduleTo;
            HRTrainingNeedsLine."Estimated Cost" := EstimatedCost;

            CASE InterventionRequired OF
                'Training':
                    HRTrainingNeedsLine."Intervention Required" := HRTrainingNeedsLine."Intervention Required"::Coaching;
                'Coaching':
                    HRTrainingNeedsLine."Intervention Required" := HRTrainingNeedsLine."Intervention Required"::Coaching;
                'Mentoring':
                    HRTrainingNeedsLine."Intervention Required" := HRTrainingNeedsLine."Intervention Required"::Mentoring;
                'Other':
                    HRTrainingNeedsLine."Intervention Required" := HRTrainingNeedsLine."Intervention Required"::Other;
            END;

            IF HRTrainingNeedsLine.MODIFY THEN BEGIN
                HRTrainingNeedsApplicationModified := TRUE;
            END;
        END;
    end;

    procedure GetTrainingNeedApplicationStatus("TrainingNeedApplicationNo.": Code[20]) TrainingNeedApplicationStatus: Text
    begin
        TrainingNeedApplicationStatus := '';
        HRTrainingNeedsHeader.RESET;
        HRTrainingNeedsHeader.SETRANGE(HRTrainingNeedsHeader."No.", "TrainingNeedApplicationNo.");
        IF HRTrainingNeedsHeader.FINDFIRST THEN BEGIN
            TrainingNeedApplicationStatus := FORMAT(HRTrainingNeedsHeader.Status);
        END;
    end;

    procedure CheckTrainingNeedsApplicationLinesExist("TrainingNeedApplicationNo.": Code[20]) TrainingNeedApplicationLinesExist: Boolean
    begin
        TrainingNeedApplicationLinesExist := FALSE;
        HRTrainingNeedsLine.RESET;
        HRTrainingNeedsLine.SETRANGE(HRTrainingNeedsLine."No.", "TrainingNeedApplicationNo.");
        IF HRTrainingNeedsLine.FINDFIRST THEN BEGIN
            TrainingNeedApplicationLinesExist := TRUE;
        END;
    end;

    procedure DeleteTrainingNeedsApplicationLine("LineNo.": Integer; "TrainingNeedApplicationNo.": Code[20]) HRTrainingNeedsApplicationLineDeleted: Boolean
    begin
        HRTrainingNeedsApplicationLineDeleted := FALSE;

        HRTrainingNeedsLine.RESET;

        HRTrainingNeedsLine.SETRANGE(HRTrainingNeedsLine."Line No.", "LineNo.");
        HRTrainingNeedsLine.SETRANGE(HRTrainingNeedsLine."No.", "TrainingNeedApplicationNo.");

        IF HRTrainingNeedsLine.FINDFIRST THEN BEGIN
            IF HRTrainingNeedsLine.DELETE THEN BEGIN
                HRTrainingNeedsApplicationLineDeleted := TRUE;
            END;
        END;

        //************************************************** HR Training Need Application Workflows *********************************************************************************************************
    end;

    procedure CheckTrainingNeedApplicationApprovalWorkflowEnabled("TrainingNeedApplicationNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;

        HRTrainingNeedsHeader.RESET;
        // IF HRTrainingNeedsHeader.GET("TrainingNeedApplicationNo.") THEN
        //     ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckHrTrainingNeedsHeaderApprovalsWorkflowEnabled(HRTrainingNeedsHeader);
    end;

    procedure SendTrainingNeedApplicationApprovalRequest("TrainingNeedApplicationNo.": Code[20]) TrainingNeedApplicationApprovalRequestSent: Boolean
    begin
        TrainingNeedApplicationApprovalRequestSent := FALSE;

        HRTrainingNeedsHeader.RESET;
        IF HRTrainingNeedsHeader.GET("TrainingNeedApplicationNo.") THEN BEGIN
            //   ApprovalsMgmtExt.OnSendHRTrainingNeedsHeaderForApproval(HRTrainingNeedsHeader);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", HRTrainingNeedsHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            IF ApprovalEntry.FINDFIRST THEN
                TrainingNeedApplicationApprovalRequestSent := TRUE;
        END;
    end;

    procedure CancelTrainingNeedApplicationnApprovalRequest("TrainingNeedApplicationNo.": Code[20]) TrainingNeedApplicationApprovalRequestCanceled: Boolean
    begin
        TrainingNeedApplicationApprovalRequestCanceled := FALSE;

        HRTrainingNeedsHeader.RESET;
        IF HRTrainingNeedsHeader.GET("TrainingNeedApplicationNo.") THEN BEGIN
            // ApprovalsMgmtExt.OnCancelHRTrainingNeedsHeaderApprovalRequest(HRTrainingNeedsHeader);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", HRTrainingNeedsHeader."No.");
            IF ApprovalEntry.FINDLAST THEN BEGIN
                IF ApprovalEntry.Status = ApprovalEntry.Status::Canceled THEN
                    TrainingNeedApplicationApprovalRequestCanceled := TRUE;
            END;
        END;

        //******************************************* HR Training Application ********************************************************************************************************************************************
    end;

    procedure CheckOpenTrainingApplicationExists("EmployeeNo.": Code[20]) OpenTrainingApplicationExist: Boolean
    begin
        OpenTrainingApplicationExist := FALSE;
        HRTrainingApplication.RESET;
        HRTrainingApplication.SETRANGE(HRTrainingApplication."Employee No.", "EmployeeNo.");
        IF HRTrainingApplication.FINDFIRST THEN BEGIN
            IF (HRTrainingApplication.Status = HRTrainingApplication.Status::Open) OR (HRTrainingApplication.Status = HRTrainingApplication.Status::"Pending Approval") OR (HRTrainingApplication.Status = HRTrainingApplication.Status::Approved) THEN
                OpenTrainingApplicationExist := TRUE;
        END;
    end;

    procedure CheckTrainingApplicationExists("TrainingApplicationNo.": Code[20]; "EmployeeNo.": Code[20]) TrainingApplicationExist: Boolean
    begin
        TrainingApplicationExist := FALSE;
        HRTrainingApplication.RESET;
        HRTrainingApplication.SETRANGE(HRTrainingApplication."Employee No.", "EmployeeNo.");
        HRTrainingApplication.SETRANGE(HRTrainingApplication."Application No.", "TrainingApplicationNo.");
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            TrainingApplicationExist := TRUE;
        END;
    end;

    procedure CreateTrainingApplication("EmployeeNo.": Code[20]; TrainingType: Text[100]; Description: Text[250]; TrainingCalendarYear: Code[30]; TrainingNeedNo: Text[250]; StartDate: Date; EndDate: Date; Provider: Text[100]; "Objective/Purpose": Text[250]) TrainingApplicationCreated: Boolean
    begin
        TrainingApplicationCreated := FALSE;

        HumanResourcesSetup.GET;

        //check if submitted
        HRTrainingApplication.RESET;
        HRTrainingApplication.SETRANGE(HRTrainingApplication."Employee No.", "EmployeeNo.");
        HRTrainingApplication.SETRANGE(HRTrainingApplication."Evaluation Submitted", FALSE);
        IF HRTrainingApplication.FINDFIRST THEN
            ERROR(TrainingApplicationError);

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        HRTrainingApplication.INIT;
        HRTrainingApplication."Application No." := NoSeriesMgt.GetNextNo(HumanResourcesSetup."Training Application Nos", 0D, TRUE);
        HRTrainingApplication."Document Date" := TODAY;
        HRTrainingApplication."Employee No." := "EmployeeNo.";
        HRTrainingApplication.VALIDATE(HRTrainingApplication."Employee No.");
        HRTrainingApplication."No." := HRTrainingApplication."Employee No.";
        HRTrainingApplication.Name := HRTrainingApplication."Employee Name";
        CASE TrainingType OF
            'Group Training':
                HRTrainingApplication."Type of Training" := HRTrainingApplication."Type of Training"::"Group Training";
            'Individual Training':
                HRTrainingApplication."Type of Training" := HRTrainingApplication."Type of Training"::"Individual Training";
        END;
        HRTrainingApplication.Description := Description;
        HRTrainingApplication."Calendar Year" := TrainingCalendarYear;
        HRTrainingApplication."Training Need No." := TrainingNeedNo;
        HRTrainingApplication.VALIDATE(HRTrainingApplication."Training Need No.");
        HRTrainingApplication."From Date" := StartDate;
        HRTrainingApplication."To Date" := EndDate;
        HRTrainingApplication.VALIDATE("To Date");
        HRTrainingApplication."Provider Name" := Provider;
        HRTrainingApplication."Purpose of Training" := "Objective/Purpose";
        HRTrainingApplication."User ID" := Employee."User ID";
        IF HRTrainingApplication.INSERT THEN BEGIN
            TrainingApplicationCreated := TRUE;
            CheckTrainingApplicationApprovalWorkflowEnabled(HRTrainingApplication."Application No.");
            SendTrainingApplicationApprovalRequest(HRTrainingApplication."Application No.");
            // ApprovalsMgmtExt.OnSendHRTrainingApplicationsHeaderForApproval(
        END;
    end;

    procedure GetOpenTrainingApplication("EmployeeNo.": Code[20]) "OpenTrainingApplicationNo.": Code[20]
    begin
        "OpenTrainingApplicationNo." := '';
        HRTrainingApplication.RESET;
        HRTrainingApplication.SETRANGE(HRTrainingApplication."Employee No.", "EmployeeNo.");
        HRTrainingApplication.SETRANGE(HRTrainingApplication.Status, HRTrainingApplication.Status::Open);
        IF HRTrainingApplication.FINDLAST THEN BEGIN
            "OpenTrainingApplicationNo." := HRTrainingApplication."Application No.";
        END;
    end;

    procedure GetTrainingApplicationStatus("TrainingApplicationNo.": Code[20]) TrainingApplicationStatus: Text
    begin
        TrainingApplicationStatus := '';
        HRTrainingApplication.RESET;
        HRTrainingApplication.SETRANGE(HRTrainingApplication."Application No.", "TrainingApplicationNo.");
        IF HRTrainingApplication.FINDFIRST THEN BEGIN
            TrainingApplicationStatus := FORMAT(HRTrainingApplication.Status);
        END;
    end;

    procedure ModifyTrainingApplication("EmployeeNo.": Code[30]; "TrainingNo.": Code[20]; TrainingType: Text; Description: Text[250]; TrainingCalendarYear: Code[30]; DevelopmentNeed: Text[250]; StartDate: Date; EndDate: Date; Provider: Text[100]; "Objective/Purpose": Text[250]) TrainingApplicationModified: Boolean
    begin
        TrainingApplicationModified := FALSE;

        HumanResourcesSetup.GET;

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        HRTrainingApplication.RESET;
        HRTrainingApplication."No." := NoSeriesMgt.GetNextNo(HumanResourcesSetup."Training Application Nos", 0D, TRUE);
        HRTrainingApplication."Document Date" := TODAY;
        HRTrainingApplication."Employee No." := "EmployeeNo.";
        HRTrainingApplication.VALIDATE(HRTrainingApplication."Employee No.");
        CASE TrainingType OF
            'Individual Training':
                HRTrainingApplication."Type of Training" := HRTrainingApplication."Type of Training"::"Individual Training";
            'Group Training':
                HRTrainingApplication."Type of Training" := HRTrainingApplication."Type of Training"::"Group Training";
        END;
        HRTrainingApplication.Description := Description;
        HRTrainingApplication."Calendar Year" := TrainingCalendarYear;
        HRTrainingApplication."Development Need" := DevelopmentNeed;
        HRTrainingApplication."From Date" := StartDate;
        HRTrainingApplication."To Date" := EndDate;
        HRTrainingApplication.VALIDATE("To Date");
        HRTrainingApplication."Provider Code" := Provider;
        HRTrainingApplication."Purpose of Training" := "Objective/Purpose";
        HRTrainingApplication."User ID" := Employee."User ID";
        IF HRTrainingApplication.MODIFY THEN BEGIN
            TrainingApplicationModified := TRUE;
        END;
    end;

    procedure CheckTrainingApplicationApprovalWorkflowEnabled("TrainingApplicationNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;
        HRTrainingApplication.RESET;
        //  IF HRTrainingApplication.GET("TrainingApplicationNo.") THEN
        //   ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckHRTrainingApplicationsHeaderApprovalsWorkflowEnabled(HRTrainingApplication);
    end;

    procedure SendTrainingApplicationApprovalRequest(TrainingApplicationNo: Code[20]) ApprovalRequestSent: Boolean
    begin
        ApprovalRequestSent := FALSE;
        HRTrainingApplication.RESET;
        IF HRTrainingApplication.GET(TrainingApplicationNo) THEN BEGIN
            HRTrainingApplication.Status := HRTrainingApplication.Status::"Pending Approval";
            HRTrainingApplication.MODIFY;
            ApprovalRequestSent := TRUE;
        END;
    end;

    procedure CancelTrainingApplicationApprovalRequest(TrainingApplicationNo: Code[20]) ApprovalRequestCanceled: Boolean
    begin
        ApprovalRequestCanceled := FALSE;
        HRTrainingApplication.RESET;
        IF HRLeaveReimbursement.GET(TrainingApplicationNo) THEN BEGIN
            //      ApprovalsMgmtExt.OnCancelHRTrainingApplicationsHeaderApprovalRequest(HRTrainingApplication);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", HRTrainingApplication."Application No.");
            IF ApprovalEntry.FINDLAST THEN BEGIN
                IF ApprovalEntry.Status = ApprovalEntry.Status::Canceled THEN
                    ApprovalRequestCanceled := TRUE;
            END;
        END;

        //************************************************ Employee Training Evaluation ************************************************************************************************************************
    end;

    procedure CheckOpenTrainingEvaluationExists("EmployeeNo.": Code[20]) OpenTrainingEvaluationExists: Boolean
    begin
        OpenTrainingEvaluationExists := FALSE;
        HRTrainingEvaluation.RESET;
        HRTrainingEvaluation.SETRANGE(HRTrainingEvaluation."Employee No.", "EmployeeNo.");
        IF (HRTrainingEvaluation.Status = HRTrainingEvaluation.Status::Open) OR (HRTrainingEvaluation.Status = HRTrainingEvaluation.Status::"Pending Approval") THEN BEGIN
            IF HRTrainingEvaluation.FINDFIRST THEN BEGIN
                OpenTrainingEvaluationExists := TRUE;
            END;
        END;
    end;

    procedure CreateTrainingEvaluation("EmployeeNo.": Code[20]) TrainingEvaluationCreated: Boolean
    var
        HRTrainingEvaluation2: Record 50161;
    begin
        TrainingEvaluationCreated := FALSE;
        HumanResourcesSetup.GET;
        Employee.RESET;
        Employee.GET("EmployeeNo.");
        HRTrainingEvaluation.INIT;
        HRTrainingEvaluation."Training Evaluation No." := NoSeriesMgt.GetNextNo(HumanResourcesSetup."Employee Evaluation Nos.", 0D, TRUE);
        HRTrainingEvaluation.Date := TODAY;
        HRTrainingEvaluation."Employee No." := "EmployeeNo.";
        HRTrainingEvaluation.VALIDATE(HRTrainingEvaluation."Employee No.");
        HRTrainingEvaluation."User ID" := Employee."User ID";
        IF HRTrainingEvaluation.INSERT THEN BEGIN
            //Insert HR Required Documents
            HRTrainingEvaluation2.RESET;
            HRTrainingEvaluation2.SETRANGE(HRTrainingEvaluation2."Employee No.", "EmployeeNo.");
            HRTrainingEvaluation2.SETRANGE(HRTrainingEvaluation2.Status, HRTrainingEvaluation2.Status::Open);
            IF HRTrainingEvaluation2.FINDFIRST THEN BEGIN
                HRRequiredDocumentChecklist.RESET;
                HRJobLookupValue.RESET;
                HRJobLookupValue.SETRANGE(HRJobLookupValue.Option, HRJobLookupValue.Option::"Checklist Item");
                HRJobLookupValue.SETRANGE(HRJobLookupValue."Required Stage", HRJobLookupValue."Required Stage"::"Training Evaluation");
                IF HRJobLookupValue.FINDSET THEN BEGIN
                    REPEAT
                        HRRequiredDocumentChecklist.INIT;
                        HRRequiredDocumentChecklist."DocumentNo." := HRTrainingEvaluation2."Training Evaluation No.";
                        HRRequiredDocumentChecklist."Document Code" := HRJobLookupValue.Code;
                        HRRequiredDocumentChecklist."Document Description" := HRJobLookupValue.Description;
                        HRRequiredDocumentChecklist."Document Attached" := FALSE;
                        HRRequiredDocumentChecklist.INSERT;
                    UNTIL HRJobLookupValue.NEXT = 0;
                    TrainingEvaluationCreated := TRUE;
                END;
                // MESSAGE(Success);
            END;
        END;
    end;

    /// <summary>
    /// GetOpenTrainingEvaluationNo.
    /// </summary>
    /// <param name="EmployeeNo.">Code[20].</param>
    /// <returns>Return variable EvaluationNo. of type Code[20].</returns>
    procedure GetOpenTrainingEvaluationNo("EmployeeNo.": Code[20]) "EvaluationNo.": Code[20]
    begin
        "EvaluationNo." := '';
        HRTrainingEvaluation.RESET;
        HRTrainingEvaluation.SETRANGE(HRTrainingEvaluation."Employee No.", "EmployeeNo.");
        HRTrainingEvaluation.SETRANGE(HRTrainingEvaluation.Status, HRTrainingEvaluation.Status::Open);
        IF HRTrainingEvaluation.FINDFIRST THEN BEGIN
            "EvaluationNo." := HRTrainingEvaluation."Training Evaluation No.";
            CheckTrainingEvaluationnApprovalWorkflowEnabled("EvaluationNo.");
            SendTrainingEvaluationApprovalRequest("EvaluationNo.");
        END;
    end;

    procedure ModifyTrainingEvaluation("EmployeeNo.": Code[20]; "EvaluationNo.": Code[20]; "ApplicationNo.": Code[20]; Comments: Text[250]) TrainingEvaluationModified: Boolean
    begin
        TrainingEvaluationModified := FALSE;
        Employee.RESET;
        Employee.GET("EmployeeNo.");
        HRTrainingEvaluation.INIT;
        HRTrainingEvaluation."Training Evaluation No." := "EvaluationNo.";
        HRTrainingEvaluation.Date := TODAY;
        HRTrainingEvaluation."Employee No." := "EmployeeNo.";
        HRTrainingEvaluation.VALIDATE(HRTrainingEvaluation."Employee No.");
        HRTrainingEvaluation."Training Application no." := "ApplicationNo.";
        HRTrainingEvaluation.VALIDATE(HRTrainingEvaluation."Training Application no.");
        HRTrainingEvaluation."General Comments from Training" := Comments;
        HRTrainingEvaluation."User ID" := Employee."User ID";
        IF HRTrainingEvaluation.MODIFY THEN BEGIN
            TrainingEvaluationModified := TRUE;
            CheckTrainingEvaluationnApprovalWorkflowEnabled("EvaluationNo.");
            SendTrainingEvaluationApprovalRequest("EvaluationNo.");
        END;
    end;

    procedure CheckTrainingEvaluationnApprovalWorkflowEnabled("TrainingEvaluationNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;
        HRTrainingEvaluation.RESET;
        //   IF HRTrainingEvaluation.GET("TrainingEvaluationNo.") THEN
        //      ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckTrainingEvaluationApprovalsWorkflowEnabled(HRTrainingEvaluation);
    end;

    procedure SendTrainingEvaluationApprovalRequest("TrainingEvaluationNo.": Code[20]) ApprovalRequestSent: Boolean
    begin
        ApprovalRequestSent := FALSE;
        HRTrainingEvaluation.RESET;
        IF HRTrainingEvaluation.GET("TrainingEvaluationNo.") THEN BEGIN
            HRTrainingEvaluation.Status := HRTrainingEvaluation.Status::Approved;
            HRTrainingEvaluation.MODIFY;
            ApprovalRequestSent := TRUE;
        END;
    end;

    procedure ModifyHRRequiredDocumentLocalURL("DocumentNo.": Code[20]; DocumentCode: Code[50]; LocalURL: Text[250]) RequiredDocumentModified: Boolean
    var
        HRRequiredDocumentChecklist: Record 50178;
    begin
        RequiredDocumentModified := FALSE;
        HRRequiredDocumentChecklist.RESET;
        HRRequiredDocumentChecklist.SETRANGE(HRRequiredDocumentChecklist."DocumentNo.", "DocumentNo.");
        HRRequiredDocumentChecklist.SETRANGE(HRRequiredDocumentChecklist."Document Code", DocumentCode);
        IF HRRequiredDocumentChecklist.FINDFIRST THEN BEGIN
            HRRequiredDocumentChecklist."Local File URL" := LocalURL;
            HRRequiredDocumentChecklist."Document Attached" := TRUE;
            IF HRRequiredDocumentChecklist.MODIFY THEN
                RequiredDocumentModified := TRUE;
        END;
    end;

    procedure ModifyHRRequiredDocumentSharePointURL("DocumentNo.": Code[20]; DocumentCode: Code[50]; SharePointURL: Text[250]) HRRequiredDocumentModified: Boolean
    var
        HRRequiredDocumentChecklist: Record 50178;
    begin
        HRRequiredDocumentModified := FALSE;
        HRRequiredDocumentChecklist.RESET;
        HRRequiredDocumentChecklist.SETRANGE(HRRequiredDocumentChecklist."DocumentNo.", "DocumentNo.");
        HRRequiredDocumentChecklist.SETRANGE(HRRequiredDocumentChecklist."Document Code", DocumentCode);
        IF HRRequiredDocumentChecklist.FINDFIRST THEN BEGIN
            HRRequiredDocumentChecklist."SharePoint URL" := SharePointURL;
            HRRequiredDocumentChecklist."Document Attached" := TRUE;
            IF HRRequiredDocumentChecklist.MODIFY THEN
                HRRequiredDocumentModified := TRUE;
        END;
    end;

    procedure CheckHRRequiredDocumentsAttached("DocumentNo.": Code[20]) HRRequiredDocumentsAttached: Boolean
    var
        HRRequiredDocumentChecklist: Record 50178;
        Error0001: Label '%1 must be attached.';
    begin
        HRRequiredDocumentsAttached := FALSE;
        HRRequiredDocumentChecklist.RESET;
        HRRequiredDocumentChecklist.SETRANGE(HRRequiredDocumentChecklist."DocumentNo.", "DocumentNo.");
        IF HRRequiredDocumentChecklist.FINDSET THEN BEGIN
            REPEAT
                IF HRRequiredDocumentChecklist."Local File URL" = '' THEN
                    ERROR(Error0001, HRRequiredDocumentChecklist."Document Description");
            UNTIL HRRequiredDocumentChecklist.NEXT = 0;
            HRRequiredDocumentsAttached := TRUE;
        END;
    end;

    procedure DeleteHRRequiredDocuments("DocumentNo.": Code[20]) RequiredDocumentsDeleted: Boolean
    var
        HRRequiredDocumentChecklist: Record 50178;
    begin
        RequiredDocumentsDeleted := FALSE;

        HRRequiredDocumentChecklist.RESET;
        HRRequiredDocumentChecklist.SETRANGE(HRRequiredDocumentChecklist."DocumentNo.", "DocumentNo.");
        IF HRRequiredDocumentChecklist.FINDSET THEN BEGIN
            HRRequiredDocumentChecklist.DELETEALL;
            RequiredDocumentsDeleted := TRUE;
        END;
    end;

    /*  
     procedure GetEmployeeLeaveApprovalEntries(var ApprovalEntries: XMLport 50024; EmployeeNo: Code[20])
     var
         ApprovalEntry: Record 454;
         Employee: Record 5200;
     begin
         ApprovalEntry.RESET;
         //     ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Leave);
         IF EmployeeNo <> '' THEN BEGIN
             Employee.GET(EmployeeNo);
             Employee.TESTFIELD("User ID");
             ApprovalEntry.SETRANGE("Approver ID", Employee."User ID");
         END;
         IF ApprovalEntry.FINDFIRST THEN;
         ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
     end;

     
     procedure GetLeaveApprovalEntries(var ApprovalEntries: XMLport 50024; LeaveNo: Code[20])
     var
         ApprovalEntry: Record 454;
         Employee: Record 5200;
     begin
         ApprovalEntry.RESET;
         //   ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Leave);
         IF LeaveNo <> '' THEN BEGIN
             ApprovalEntry.SETRANGE("Document No.", LeaveNo);
         END;
         IF ApprovalEntry.FINDFIRST THEN;
         ApprovalEntries.SETTABLEVIEW(ApprovalEntry);
     end; */


    procedure CreateLeavePlan("EmployeeNo.": Code[20]; LeaveType: Code[50]; Description: Text) LeavePlanCreated: Text
    var
        HRLeaveType: Record 50134;
        Text101: Label 'Applied number of days must be equal to %1';
    begin
        LeavePlanCreated := '';

        HumanResourcesSetup.GET;

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        HRLeavePlannerHeader.INIT;
        HRLeavePlannerHeader."No." := NoSeriesMgt.GetNextNo(HumanResourcesSetup."Leave Planner Nos.", 0D, TRUE);
        HRLeavePlannerHeader."Employee No." := "EmployeeNo.";
        HRLeavePlannerHeader.VALIDATE(HRLeavePlannerHeader."Employee No.");

        HRLeavePlannerHeader."Leave Type" := LeaveType;
        HRLeavePlannerHeader.VALIDATE(HRLeavePlannerHeader."Leave Type");

        HRLeavePlannerHeader.Description := Description;
        HRLeavePlannerHeader."User ID" := Employee."User ID";
        IF HRLeavePlannerHeader.INSERT THEN BEGIN
            LeavePlanCreated := '200: Leave Plan No ' + HRLeavePlannerHeader."No." + ' Created Successfully';
        END ELSE
            LeavePlanCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyLeavePlan("LeavePlanNo.": Code[20]; "EmployeeNo.": Code[20]; LeaveType: Code[50]; Description: Text) LeaveApplicationModified: Text
    var
        Text101: Label 'Applied number of days must be equal to %1';
        HRLeaveType: Record 50134;
    begin
        ERROR(Text_0001);
        LeaveApplicationModified := '';
        HumanResourcesSetup.GET;

        Employee.RESET;
        Employee.GET("EmployeeNo.");

        HRLeavePlannerHeader.RESET;
        HRLeavePlannerHeader.SETRANGE(HRLeavePlannerHeader."No.", "LeavePlanNo.");
        IF HRLeavePlannerHeader.FINDFIRST THEN BEGIN
            HRLeavePlannerHeader."Employee No." := "EmployeeNo.";
            HRLeavePlannerHeader.VALIDATE(HRLeavePlannerHeader."Employee No.");

            HRLeavePlannerHeader."Leave Type" := LeaveType;
            HRLeavePlannerHeader.VALIDATE(HRLeavePlannerHeader."Leave Type");


            HRLeavePlannerHeader.Description := Description;
            HRLeavePlannerHeader."User ID" := Employee."User ID";
            LeaveApplicationModified := '200: Leave Plan No ' + HRLeavePlannerHeader."No." + ' Modified Successfully';
        END ELSE
            LeaveApplicationModified := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;

    /*   
      procedure GetLeavePlanList(var ImportExportLeavePlan: XMLport 50040; EmployeeNo: Code[20])
      begin
          IF EmployeeNo <> '' THEN BEGIN

              HRLeavePlannerHeader.RESET;
              HRLeavePlannerHeader.SETFILTER("Employee No.", EmployeeNo);
              IF HRLeavePlannerHeader.FINDFIRST THEN;
              ImportExportLeavePlan.SETTABLEVIEW(HRLeavePlannerHeader);
          END
      end;

      
      procedure GetLeavePlanHeaderLines(var ImportExportLeavePlanLines: XMLport 50042; HeaderNo: Code[20])
      var
          HRLeavePlannerLine: Record 50126;
      begin
          IF HeaderNo <> '' THEN BEGIN

              HRLeavePlannerLine.RESET;
              HRLeavePlannerLine.SETFILTER("Leave Planner No.", HeaderNo);
              IF HRLeavePlannerLine.FINDFIRST THEN;
              ImportExportLeavePlanLines.SETTABLEVIEW(HRLeavePlannerLine);
          END
      end;
   */

    procedure CreateLeavePlanLine("LeavePlanNo.": Code[20]; StartDate: Date; NoOfDays: Integer) LeavePlanLineCreated: Text
    var
        HREmployee: Record 5200;
    begin
        LeavePlanLineCreated := '';

        HRLeavePlannerHeaderRec.RESET;
        HRLeavePlannerHeaderRec.GET("LeavePlanNo.");

        HRLeavePlannerLineRec.INIT;
        HRLeavePlannerLineRec."Leave Planner No." := "LeavePlanNo.";
        HRLeavePlannerLineRec."Start Date" := StartDate;
        HRLeavePlannerLineRec."No. of Days" := NoOfDays;
        HRLeavePlannerLineRec.VALIDATE("No. of Days");

        IF HRLeavePlannerLineRec.INSERT THEN BEGIN
            LeavePlanLineCreated := '200: Leave Plan Line Successfully Created';
        END ELSE
            LeavePlanLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyLeavePlanLine("LeavePlanNo.": Code[20]; StartDate: Date; NoOfDays: Integer) LeavePlanLineModified: Boolean
    begin
        LeavePlanLineModified := FALSE;

        HRLeavePlannerLineRec.RESET;
        HRLeavePlannerLineRec.SETRANGE("Leave Planner No.", "LeavePlanNo.");
        IF HRLeavePlannerLineRec.FINDFIRST THEN BEGIN
            HRLeavePlannerLineRec."Start Date" := StartDate;
            HRLeavePlannerLineRec."No. of Days" := NoOfDays;

            HRLeavePlannerLineRec.VALIDATE(HRLeavePlannerLineRec."No. of Days");


            IF HRLeavePlannerLineRec.MODIFY THEN BEGIN
                LeavePlanLineModified := TRUE;
            END;
        END;
    end;


    procedure DeleteLeavePlanLine(LeavePLanNo: Code[20]) LeaveLineDeleted: Boolean
    begin
        LeaveLineDeleted := FALSE;

        HRLeavePlannerLineRec.RESET;
        HRLeavePlannerLineRec.SETRANGE(HRLeavePlannerLineRec."Leave Planner No.", LeavePLanNo);
        IF HRLeavePlannerLineRec.FINDFIRST THEN BEGIN
            IF HRLeavePlannerLineRec.DELETE THEN BEGIN
                LeaveLineDeleted := TRUE;
            END;
        END;
    end;


    procedure CreateHREmployeeAppraisal("EmployeeNo.": Code[20]; DateofLastAppraisal: Date; AppraisalPeriod: Code[20]; CommentsByAppraisee: Text; CommentsByAppraiseeDate: Date; CommentsByAppraiser: Text; CommentsByAppraiserDate: Date; CommentsByHOD: Text; ApprovalByMD: Text; ApprovalByMDDate: Date) AppraisalCreated: Text
    begin
        AppraisalCreated := '';
        HREmployeeAppraisalHeaderRec.INIT;
        HREmployeeAppraisalHeaderRec."Employee No." := "EmployeeNo.";
        HREmployeeAppraisalHeaderRec.VALIDATE("Employee No.");
        HREmployeeAppraisalHeaderRec."Date of Last Appraisal" := DateofLastAppraisal;
        HREmployeeAppraisalHeaderRec."Appraisal Period" := AppraisalPeriod;
        HREmployeeAppraisalHeaderRec."Comments By HOD" := CommentsByHOD;
        HREmployeeAppraisalHeaderRec."Comments By Appraisee Date" := CommentsByAppraiseeDate;
        HREmployeeAppraisalHeaderRec."Comments by Appraiser Date" := CommentsByAppraiserDate;
        HREmployeeAppraisalHeaderRec."Final Comments by Appraiser" := CommentsByAppraiser;
        IF HREmployeeAppraisalHeaderRec.INSERT THEN BEGIN
            AppraisalCreated := '200: Employee Appraisal Successfully Created';
        END ELSE
            AppraisalCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyHREmployeeAppraisal(AppraisalNo: Code[20]; DateofLastAppraisal: Date; AppraisalPeriod: Code[20]; CommentsByAppraisee: Text; CommentsByAppraiseeDate: Date; CommentsByAppraiser: Text; CommentsByAppraiserDate: Date; CommentsByHOD: Text; ApprovalByMD: Text; ApprovalByMDDate: Date) AppraisalModifed: Boolean
    begin
        AppraisalModifed := FALSE;
        HREmployeeAppraisalHeaderRec.RESET;
        HREmployeeAppraisalHeaderRec.SETRANGE("No.", AppraisalNo);
        IF HREmployeeAppraisalHeaderRec.FINDFIRST THEN BEGIN
            HREmployeeAppraisalHeaderRec."Date of Last Appraisal" := DateofLastAppraisal;
            HREmployeeAppraisalHeaderRec."Appraisal Period" := AppraisalPeriod;
            HREmployeeAppraisalHeaderRec."Comments By HOD" := CommentsByHOD;
            HREmployeeAppraisalHeaderRec."Comments By Appraisee Date" := CommentsByAppraiseeDate;
            HREmployeeAppraisalHeaderRec."Comments by Appraiser Date" := CommentsByAppraiserDate;
            HREmployeeAppraisalHeaderRec."Final Comments by Appraiser" := CommentsByAppraiser;
            IF HREmployeeAppraisalHeaderRec.MODIFY THEN
                AppraisalModifed := TRUE//'200: Employee Appraisal Successfully modified';
            ELSE
                AppraisalModifed := FALSE//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
        END;
    end;


    procedure DeleteAppraisal(AppraisalNo: Code[20]) AppraisalDeleted: Boolean
    begin
        AppraisalDeleted := FALSE;
        HREmployeeAppraisalHeaderRec.RESET;
        HREmployeeAppraisalHeaderRec.SETRANGE("No.", AppraisalNo);
        IF HREmployeeAppraisalHeaderRec.DELETE THEN
            AppraisalDeleted := TRUE
        ELSE
            AppraisalDeleted := FALSE;
    end;


    procedure CreateAppraisalAcademicsProfLine(AppraisalNo: Code[20]; InsitutionName: Text; PeriodofStudy: DateFormula; QualificationAwarded: Text) HrAppraisalAcademicLineCreated: Text
    begin
        HrAppraisalAcademicLineCreated := '';
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        HrAppraisalAcademicProfQuaRec.INIT;
        HrAppraisalAcademicProfQuaRec."Appraisal Code" := AppraisalNo;
        HrAppraisalAcademicProfQuaRec."Name of Institution" := InsitutionName;
        HrAppraisalAcademicProfQuaRec."Period Of Study" := PeriodofStudy;
        HrAppraisalAcademicProfQuaRec."Qualification Awarded" := QualificationAwarded;

        IF HrAppraisalAcademicProfQuaRec.INSERT THEN
            HrAppraisalAcademicLineCreated := '200: Employee Appraisal Academics line Successfully Created'
        ELSE
            HrAppraisalAcademicLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifiedAppraisalAcademicsProfLine(AppraisalNo: Code[20]; LineNo: Integer; InsitutionName: Text; PeriodofStudy: DateFormula; QualificationAwarded: Text) HrAppraisalAcademicLineModified: Boolean
    begin
        HrAppraisalAcademicLineModified := FALSE;
        HREmployeeAppraisalHeaderRec.RESET;
        HrAppraisalAcademicProfQuaRec.SETRANGE("Appraisal Code", AppraisalNo);
        HrAppraisalAcademicProfQuaRec.SETRANGE("Line No.", LineNo);
        IF HrAppraisalAcademicProfQuaRec.FINDFIRST THEN BEGIN
            HrAppraisalAcademicProfQuaRec.INIT;
            HrAppraisalAcademicProfQuaRec."Appraisal Code" := AppraisalNo;
            HrAppraisalAcademicProfQuaRec."Name of Institution" := InsitutionName;
            HrAppraisalAcademicProfQuaRec."Period Of Study" := PeriodofStudy;
            HrAppraisalAcademicProfQuaRec."Qualification Awarded" := QualificationAwarded;

            IF HrAppraisalAcademicProfQuaRec.MODIFY THEN
                HrAppraisalAcademicLineModified := TRUE//'200: Employee Appraisal Academics line Successfully Created'
            ELSE
                HrAppraisalAcademicLineModified := FALSE;//+'-'+GETLASTERRORTEXT;
        END;
    end;


    procedure DeleteAppraisalAcademicsProfLine(LineNo: Integer; AppraisalNo: Code[20]) HRAppraisalAcademicLineDeleted: Boolean
    begin
        HRAppraisalAcademicLineDeleted := FALSE;
        HREmployeeAppraisalHeaderRec.RESET;
        HrAppraisalAcademicProfQuaRec.SETRANGE("Appraisal Code", AppraisalNo);
        HrAppraisalAcademicProfQuaRec.SETRANGE("Line No.", LineNo);
        IF HrAppraisalAcademicProfQuaRec.DELETE THEN
            HRAppraisalAcademicLineDeleted := TRUE
        ELSE
            HRAppraisalAcademicLineDeleted := FALSE;
    end;

    /*  
     procedure GetAppraisalAcademicsProfLines(AppraisalNo: Code[20])
     var
         ImportExportAppraisalAcadem: XMLport 50053;
     begin
         HrAppraisalAcademicProfQuaRec.RESET;
         HrAppraisalAcademicProfQuaRec.SETRANGE("Appraisal Code", AppraisalNo);
         ImportExportAppraisalAcadem.SETTABLEVIEW(HrAppraisalAcademicProfQuaRec);
     end; */
    /* 
        
        procedure CreateAppraisalKPILine(AppraisalNo: Code[20]; PerformanceIndicator: Text; ResultsAchieved: Decimal; PerformanceScore: Decimal) AppraisalKPICreated: Text
        begin
            AppraisalKPICreated := '';
            HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
            HrEmployeeApprasalKPI.INIT;
            HrEmployeeApprasalKPI."Appraisal No." := AppraisalNo;
            HrEmployeeApprasalKPI."Performance Indicator" := PerformanceIndicator;
            HrEmployeeApprasalKPI."Results Achieved" := ResultsAchieved;
            HrEmployeeApprasalKPI."Performance Score %" := PerformanceScore;
            IF HrEmployeeApprasalKPI.INSERT THEN
                AppraisalKPICreated := '200: Employee Appraisal Performance KPI line Successfully Created'
            ELSE
                AppraisalKPICreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
        end;

        
        procedure ModifyAppraisalKPILine(AppraisalNo: Code[20]; LineNo: Integer; PerformanceIndicator: Text; ResultsAchieved: Decimal; PerformanceScore: Decimal) AppraisalKPIModified: Boolean
        begin
            AppraisalKPIModified := FALSE;
            HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
            HrEmployeeApprasalKPI.RESET;
            HrEmployeeApprasalKPI.SETRANGE("Appraisal No.", AppraisalNo);
            HrEmployeeApprasalKPI.SETRANGE("Line No.", LineNo);
            IF HrEmployeeApprasalKPI.FINDFIRST THEN BEGIN
                HrEmployeeApprasalKPI."Performance Indicator" := PerformanceIndicator;
                HrEmployeeApprasalKPI."Results Achieved" := ResultsAchieved;
                HrEmployeeApprasalKPI."Performance Score %" := PerformanceScore;
                IF HrEmployeeApprasalKPI.MODIFY THEN
                    AppraisalKPIModified := TRUE
                ELSE
                    AppraisalKPIModified := FALSE;
            END;
        end;

        
        procedure DeleteAppraisalKPILine(AppraisalNo: Code[20]; LineNo: Integer) AppraisalKPIDeleted: Boolean
        begin
            AppraisalKPIDeleted := FALSE;
            HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
            HrEmployeeApprasalKPI.RESET;
            HrEmployeeApprasalKPI.SETRANGE("Appraisal No.", AppraisalNo);
            HrEmployeeApprasalKPI.SETRANGE("Line No.", LineNo);
            IF HrEmployeeApprasalKPI.DELETE THEN
                AppraisalKPIDeleted := TRUE
            ELSE
                AppraisalKPIDeleted := FALSE;

        end;
     */

    procedure CreatAppraisalAssessmentFactorLine(AppraisalNo: Code[20]; AssessmentFactortxt: Text; Score: Decimal) AssessmentFactorCreated: Text
    begin
        AssessmentFactorCreated := '';
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        HRAppraisalAssesmentFactor.INIT;
        HRAppraisalAssesmentFactor."Appraisal No." := AppraisalNo;
        HRAppraisalAssesmentFactor."Assessment Factor" := AssessmentFactortxt;
        HRAppraisalAssesmentFactor."Score (1-5)" := Score;
        IF HRAppraisalAssesmentFactor.INSERT THEN
            AssessmentFactorCreated := '200: Employee Appraisal Assessment factor line Successfully Created'
        ELSE
            AssessmentFactorCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyAppraisalAssessmentFactorLine(AppraisalNo: Code[20]; LineNo: Integer; AssessmentFactor: Text; Score: Decimal) AssessmentFactorModified: Boolean
    begin
        AssessmentFactorModified := FALSE;
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        HRAppraisalAssesmentFactor.RESET;
        HRAppraisalAssesmentFactor.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalAssesmentFactor.SETRANGE("Line No.", LineNo);
        IF HRAppraisalAssesmentFactor.FINDLAST THEN BEGIN
            HRAppraisalAssesmentFactor."Assessment Factor" := AssessmentFactor;
            HRAppraisalAssesmentFactor."Score (1-5)" := Score;
            IF HRAppraisalAssesmentFactor.MODIFY THEN
                AssessmentFactorModified := TRUE//'200: Employee Appraisal Assessment factor line Successfully Created'
            ELSE
                AssessmentFactorModified := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
        END;
    end;


    procedure DeleteAppraisalAssessmentFactorLine(AppraisalNo: Code[20]; LineNo: Integer) AssessmentFactorDeleted: Boolean
    var
        "`": Integer;
    begin
        AssessmentFactorDeleted := FALSE;
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        HRAppraisalAssesmentFactor.RESET;
        HRAppraisalAssesmentFactor.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalAssesmentFactor.SETRANGE("Line No.", LineNo);
        IF HRAppraisalAssesmentFactor.DELETE THEN
            AssessmentFactorDeleted := TRUE//'200: Employee Appraisal Assessment factor line Successfully Created'
        ELSE
            AssessmentFactorDeleted := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
    end;

    /*  
     procedure GetAppraisalAssessmentFactorLine(AppraisalNo: Code[20])
     var
         ImportExportApprAssementFac: XMLport 50062;
     begin
         HRAppraisalAssesmentFactor.RESET;
         HRAppraisalAssesmentFactor.SETRANGE("Appraisal No.", AppraisalNo);
         ImportExportApprAssementFac.SETTABLEVIEW(HRAppraisalAssesmentFactor);
     end; */


    procedure CreateAppraisalChallengeLine(AppraisalNo: Code[20]; Challenge: Text) AppraisalChallengeLineCreated: Text
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalChallengeLineCreated := '';
        HRAppraisalProblemsChalleng.INIT;
        HRAppraisalProblemsChalleng."Problem/Challenge" := Challenge;
        IF HRAppraisalProblemsChalleng.INSERT THEN
            AppraisalChallengeLineCreated := '200: Employee Appraisal Challenge line Successfully Created'
        ELSE
            AppraisalChallengeLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyAppraisalChallengeLine(AppraisalNo: Code[20]; LineNo: Integer; Challenge: Text) AppraisalChallengeLineModify: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalChallengeLineModify := FALSE;
        HRAppraisalProblemsChalleng.RESET;
        HRAppraisalProblemsChalleng.SETRANGE("No.", AppraisalNo);
        HRAppraisalProblemsChalleng.SETRANGE("Line No.", LineNo);
        IF HRAppraisalProblemsChalleng.FINDFIRST THEN BEGIN
            HRAppraisalProblemsChalleng."Problem/Challenge" := Challenge;
            IF HRAppraisalProblemsChalleng.MODIFY THEN
                AppraisalChallengeLineModify := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
            ELSE
                AppraisalChallengeLineModify := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
        END;
    end;


    procedure DeleteAppraisalChallengeLine(AppraisalNo: Code[20]; LineNo: Integer) AppraisalChallengeLineDeleted: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalChallengeLineDeleted := FALSE;
        HRAppraisalProblemsChalleng.RESET;
        HRAppraisalProblemsChalleng.SETRANGE("No.", AppraisalNo);
        HRAppraisalProblemsChalleng.SETRANGE("Line No.", LineNo);
        IF HRAppraisalProblemsChalleng.DELETE THEN
            AppraisalChallengeLineDeleted := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
        ELSE
            AppraisalChallengeLineDeleted := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;

    end;

    /*  
     procedure GetAppraisalChallengeLines(var ImportExportAppProblChalle: XMLport 50056; AppraisalNo: Code[20])
     begin
         HRAppraisalProblemsChalleng.RESET;
         HRAppraisalProblemsChalleng.SETRANGE("No.", AppraisalNo);
         ImportExportAppProblChalle.SETTABLEVIEW(HRAppraisalProblemsChalleng);
     end; */


    procedure CreateAppraisalCourseTrainingAttended(AppraisalNo: Code[20]; TrainingCourse: Text) AppraisalTrainingLineCreated: Text
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalTrainingLineCreated := '';
        HRAppraisalCourseTraining.INIT;
        HRAppraisalCourseTraining."Course/Training" := TrainingCourse;
        IF HRAppraisalCourseTraining.INSERT THEN
            AppraisalTrainingLineCreated := '200: Employee Appraisal training/course line Successfully Created'
        ELSE
            AppraisalTrainingLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyAppraisalTrainingCourseLine(AppraisalNo: Code[20]; LineNo: Integer; TrainingCourse: Text) AppraisalTrainingLineModify: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalTrainingLineModify := FALSE;
        HRAppraisalCourseTraining.RESET;
        HRAppraisalCourseTraining.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalCourseTraining.SETRANGE("Line No.", LineNo);
        IF HRAppraisalCourseTraining.FINDFIRST THEN BEGIN
            HRAppraisalCourseTraining."Course/Training" := TrainingCourse;
            IF HRAppraisalCourseTraining.MODIFY THEN
                AppraisalTrainingLineModify := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
            ELSE
                AppraisalTrainingLineModify := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
        END;
    end;


    procedure DeleteAppraisalTrainingCourseLine(AppraisalNo: Code[20]; LineNo: Integer) AppraisalTrainingLineDeleted: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalTrainingLineDeleted := FALSE;
        HRAppraisalCourseTraining.RESET;
        HRAppraisalCourseTraining.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalCourseTraining.SETRANGE("Line No.", LineNo);
        IF HRAppraisalCourseTraining.DELETE THEN
            AppraisalTrainingLineDeleted := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
        ELSE
            AppraisalTrainingLineDeleted := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;

    end;
    /*
        
         procedure GetAppraisalTrainingLines(var ImportExportApprTraingCours: XMLport "50058"; AppraisalNo: Code[20])
        begin
            HRAppraisalProblemsChalleng.RESET;
            HRAppraisalProblemsChalleng.SETRANGE("No.", AppraisalNo);
            ImportExportApprTraingCours.SETTABLEVIEW(HRAppraisalProblemsChalleng);
        end; */


    procedure CreateAppraisalPerformanceFactorLine(AppraisalNo: Code[20]; PerformanceFactor: Text) AppraisalPerformanceFactLineCreated: Text
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalPerformanceFactLineCreated := '';
        HRAppraisalPerformanceFacto.INIT;
        HRAppraisalPerformanceFacto."Performance Factor" := PerformanceFactor;
        IF HRAppraisalPerformanceFacto.INSERT THEN
            AppraisalPerformanceFactLineCreated := '200: Employee Appraisal Performance Factor line Successfully Created'
        ELSE
            AppraisalPerformanceFactLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyAppraisalPerformanceFactorLine(AppraisalNo: Code[20]; LineNo: Integer; PerformanceFactor: Text) AppraisalPerfFactorLineModify: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalPerfFactorLineModify := FALSE;
        HRAppraisalPerformanceFacto.RESET;
        HRAppraisalPerformanceFacto.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalPerformanceFacto.SETRANGE("Line No.", LineNo);
        IF HRAppraisalPerformanceFacto.FINDFIRST THEN BEGIN
            HRAppraisalPerformanceFacto."Performance Factor" := PerformanceFactor;
            IF HRAppraisalPerformanceFacto.MODIFY THEN
                AppraisalPerfFactorLineModify := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
            ELSE
                AppraisalPerfFactorLineModify := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
        END;
    end;


    procedure DeleteAppraisalPerformanceFactorLine(AppraisalNo: Code[20]; LineNo: Integer) AppraisalPerformanceFactLineDeleted: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalPerformanceFactLineDeleted := FALSE;
        HRAppraisalPerformanceFacto.RESET;
        HRAppraisalPerformanceFacto.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalPerformanceFacto.SETRANGE("Line No.", LineNo);
        IF HRAppraisalPerformanceFacto.DELETE THEN
            AppraisalPerformanceFactLineDeleted := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
        ELSE
            AppraisalPerformanceFactLineDeleted := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;

    end;

    /* 
    procedure GetAppraisalPerformanceFactorLines(var ImportExportApprPerfFactor: XMLport 50057; AppraisalNo: Code[20])
    begin
        HRAppraisalPerformanceFacto.RESET;
        HRAppraisalPerformanceFacto.SETRANGE("Appraisal No.", AppraisalNo);
        ImportExportApprPerfFactor.SETTABLEVIEW(HRAppraisalPerformanceFacto);
    end; */


    procedure CreateAppraisalPerformanceSuggestLine(AppraisalNo: Code[20]; PerformanceSuggestion: Text) AppraisalPerformanSuggestionLineCreated: Text
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);

        AppraisalPerformanSuggestionLineCreated := '';
        HrAppraisalPerformaceSugge.INIT;
        HrAppraisalPerformaceSugge.Suggestion := PerformanceSuggestion;
        IF HrAppraisalPerformaceSugge.INSERT THEN
            AppraisalPerformanSuggestionLineCreated := '200: Employee Appraisal Performance suggestion line Successfully Created'
        ELSE
            AppraisalPerformanSuggestionLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyAppraisalPerformanceSuggestLine(AppraisalNo: Code[20]; LineNo: Integer; PerformanceSuggestion: Text) AppraisalPerfSuggestionLineModify: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalPerfSuggestionLineModify := FALSE;
        HrAppraisalPerformaceSugge.RESET;
        HrAppraisalPerformaceSugge.SETRANGE("Appraisal No.", AppraisalNo);
        HrAppraisalPerformaceSugge.SETRANGE("Line No.", LineNo);
        IF HrAppraisalPerformaceSugge.FINDFIRST THEN BEGIN
            HrAppraisalPerformaceSugge.Suggestion := PerformanceSuggestion;
            IF HrAppraisalPerformaceSugge.MODIFY THEN
                AppraisalPerfSuggestionLineModify := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
            ELSE
                AppraisalPerfSuggestionLineModify := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
        END;
    end;


    procedure DeleteAppraisalPerformanceSuggestLine(AppraisalNo: Code[20]; LineNo: Integer) AppraisalPerformanceSuggestionDeleted: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalPerformanceSuggestionDeleted := FALSE;
        HrAppraisalPerformaceSugge.RESET;
        HrAppraisalPerformaceSugge.SETRANGE("Appraisal No.", AppraisalNo);
        HrAppraisalPerformaceSugge.SETRANGE("Line No.", LineNo);
        IF HrAppraisalPerformaceSugge.DELETE THEN
            AppraisalPerformanceSuggestionDeleted := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
        ELSE
            AppraisalPerformanceSuggestionDeleted := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;

    end;

    // 
    /*  procedure GetAppraisalPerformanceSuggestLines(var ImportExportApprPerfSugg: XMLport "50060"; AppraisalNo: Code[20])
     begin
         HrAppraisalPerformaceSugge.RESET;
         HrAppraisalPerformaceSugge.SETRANGE("Appraisal No.", AppraisalNo);
         ImportExportApprPerfSugg.SETTABLEVIEW(HrAppraisalPerformaceSugge);
     end; */


    procedure CreateAppraisalTrainingNeedLine(AppraisalNo: Code[20]; TrainingNeed: Text) AppraisalTrainingNeedLineCreated: Text
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);

        AppraisalTrainingNeedLineCreated := '';
        HRAppraisalTrainingNeedOb.INIT;
        HRAppraisalTrainingNeedOb."Training Need & Objective" := TrainingNeed;
        IF HRAppraisalTrainingNeedOb.INSERT THEN
            AppraisalTrainingNeedLineCreated := '200: Employee Appraisal Training Need line Successfully Created'
        ELSE
            AppraisalTrainingNeedLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyAppraisalTrainingNeedLine(AppraisalNo: Code[20]; LineNo: Integer; TrainingNeed: Text) AppraisalTrainingNeedLineModify: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalTrainingNeedLineModify := FALSE;
        HRAppraisalTrainingNeedOb.RESET;
        HRAppraisalTrainingNeedOb.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalTrainingNeedOb.SETRANGE("Line No.", LineNo);
        IF HRAppraisalTrainingNeedOb.FINDFIRST THEN BEGIN
            HRAppraisalTrainingNeedOb."Training Need & Objective" := TrainingNeed;
            IF HRAppraisalTrainingNeedOb.MODIFY THEN
                AppraisalTrainingNeedLineModify := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
            ELSE
                AppraisalTrainingNeedLineModify := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
        END;
    end;


    procedure DeleteAppraisalTrainingNeedLine(AppraisalNo: Code[20]; LineNo: Integer) AppraisalTrainingNeedLineDeleted: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalTrainingNeedLineDeleted := FALSE;
        HRAppraisalTrainingNeedOb.RESET;
        HRAppraisalTrainingNeedOb.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalTrainingNeedOb.SETRANGE("Line No.", LineNo);
        IF HRAppraisalTrainingNeedOb.DELETE THEN
            AppraisalTrainingNeedLineDeleted := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
        ELSE
            AppraisalTrainingNeedLineDeleted := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;

    end;

    /* 
    procedure GetAppraisalTrainingNeedLines(var ImportExpoTrainingNEedObje: XMLport 50063; AppraisalNo: Code[20])
    begin
        HRAppraisalTrainingNeedOb.RESET;
        HRAppraisalTrainingNeedOb.SETRANGE("Appraisal No.", AppraisalNo);
        ImportExpoTrainingNEedObje.SETTABLEVIEW(HRAppraisalTrainingNeedOb);
    end; */


    procedure CreateAppraisalIdentPotentialLine(AppraisalNo: Code[20]; IdentifiedPotential: Text) AppraisalIdentifiedPotentialLineCreated: Text
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);

        AppraisalIdentifiedPotentialLineCreated := '';
        HRAppraisalIdentifiedPotent.INIT;
        HRAppraisalIdentifiedPotent."Identified Potential" := IdentifiedPotential;
        IF HRAppraisalIdentifiedPotent.INSERT THEN
            AppraisalIdentifiedPotentialLineCreated := '200: Employee Appraisal Identified potential line Successfully Created'
        ELSE
            AppraisalIdentifiedPotentialLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyAppraisalIdentPotentialLine(AppraisalNo: Code[20]; LineNo: Integer; IdentifiedPotential: Text) AppraisalIdentifiedPotentialLineModify: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalIdentifiedPotentialLineModify := FALSE;
        HRAppraisalIdentifiedPotent.RESET;
        HRAppraisalIdentifiedPotent.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalIdentifiedPotent.SETRANGE("Line No.", LineNo);
        IF HRAppraisalIdentifiedPotent.FINDFIRST THEN BEGIN
            HRAppraisalIdentifiedPotent."Identified Potential" := IdentifiedPotential;
            IF HRAppraisalIdentifiedPotent.MODIFY THEN
                AppraisalIdentifiedPotentialLineModify := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
            ELSE
                AppraisalIdentifiedPotentialLineModify := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
        END;
    end;


    procedure DeleteAppraisalIdentPotentialLine(AppraisalNo: Code[20]; LineNo: Integer) AppraisalIdentifiedPotentialLineDeleted: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalIdentifiedPotentialLineDeleted := FALSE;
        HRAppraisalIdentifiedPotent.RESET;
        HRAppraisalIdentifiedPotent.SETRANGE("Appraisal No.", AppraisalNo);
        HRAppraisalIdentifiedPotent.SETRANGE("Line No.", LineNo);
        IF HRAppraisalIdentifiedPotent.DELETE THEN
            AppraisalIdentifiedPotentialLineDeleted := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
        ELSE
            AppraisalIdentifiedPotentialLineDeleted := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;

    end;

    /*  
     procedure GetAppraisalIdentiPotentialLines(var ImpExpAppraIdentPotentital: XMLport 50064; AppraisalNo: Code[20])
     begin
         HRAppraisalIdentifiedPotent.RESET;
         HRAppraisalIdentifiedPotent.SETRANGE("Appraisal No.", AppraisalNo);
         ImpExpAppraIdentPotentital.SETTABLEVIEW(HRAppraisalIdentifiedPotent);
     end; */


    procedure CreateAppraisalSpecificRecomLine(AppraisalNo: Code[20]; Recommendation: Text; Reason: Text) AppraisalSpecificRecLineCreated: Text
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);

        AppraisalSpecificRecLineCreated := '';
        HRAppraisalRecommendation.INIT;
        HRAppraisalRecommendation.Description := Recommendation;
        IF HRAppraisalRecommendation.INSERT THEN
            AppraisalSpecificRecLineCreated := '200: Employee Appraisal Recommendation line Successfully Created'
        ELSE
            AppraisalSpecificRecLineCreated := GETLASTERRORCODE + '-' + GETLASTERRORTEXT;
    end;


    procedure ModifyAppraisalSpecificRecomLine(AppraisalNo: Code[20]; LineNo: Integer; Recommendation: Text; Reason: Integer) AppraisalSpecificRecommlLineModify: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalSpecificRecommlLineModify := FALSE;
        HRAppraisalIdentifiedPotent.RESET;
        /*  HRAppraisalRecommendation.SETRANGE("Appraisal No.", AppraisalNo);
         HRAppraisalRecommendation.SETRANGE("Line No.", LineNo);
         IF HRAppraisalRecommendation.FINDFIRST THEN BEGIN
             HRAppraisalRecommendation.Recommendation := Recommendation;
             IF HRAppraisalRecommendation.MODIFY THEN
                 AppraisalSpecificRecommlLineModify := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
             ELSE
                 AppraisalSpecificRecommlLineModify := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT;
         END; */
    end;


    procedure DeleteAppraisalSpecificRecomLine(AppraisalNo: Code[20]; LineNo: Integer) AppraisalSpecificRecomLineDeleted: Boolean
    begin
        HREmployeeAppraisalHeaderRec.GET(AppraisalNo);
        AppraisalSpecificRecomLineDeleted := FALSE;
        HRAppraisalRecommendation.RESET;
        /*   HRAppraisalRecommendation.SETRANGE("Appraisal No.", AppraisalNo);
          HRAppraisalRecommendation.SETRANGE("Line No.", LineNo);
          IF HRAppraisalRecommendation.DELETE THEN
              AppraisalSpecificRecomLineDeleted := TRUE//'200: Employee Appraisal Challenge line Successfully Created'
          ELSE
              AppraisalSpecificRecomLineDeleted := FALSE;//GETLASTERRORCODE+'-'+GETLASTERRORTEXT; */

    end;

    /*  
     procedure GetAppraisalSpecificRecomLines(var ImpExpApprRecommendation: XMLport 50064; AppraisalNo: Code[20])
     begin
         HRAppraisalRecommendation.RESET;
         HRAppraisalRecommendation.SETRANGE("Appraisal No.", AppraisalNo);
         ImpExpApprRecommendation.SETTABLEVIEW(HRAppraisalRecommendation);
     end; */
}




codeunit 50082 "Approval Mgt. Ext"
{
    trigger OnRun()
    begin

    end;

    var
        UserIdNotInSetupErr: Label 'User ID %1 does not exist in the Approval User Setup window.', Comment = 'User ID NAVUser does not exist in the Approval User Setup window.';
        ApproverUserIdNotInSetupErr: Label 'You must set up an approver for user ID %1 in the Approval User Setup window.', Comment = 'You must set up an approver for user ID NAVUser in the Approval User Setup window.';
        WFUserGroupNotInSetupErr: Label 'The workflow user group member with user ID %1 does not exist in the Approval User Setup window.', Comment = 'The workflow user group member with user ID NAVUser does not exist in the Approval User Setup window.';
        SubstituteNotFoundErr: Label 'There is no substitute, direct approver, or approval administrator for user ID %1 in the Approval User Setup window.', Comment = 'There is no substitute for user ID NAVUser in the Approval User Setup window.';
        NoSuitableApproverFoundErr: Label 'No qualified approver was found.';
        DelegateOnlyOpenRequestsErr: Label 'You can only delegate open approval requests.';
        ApproveOnlyOpenRequestsErr: Label 'You can only approve open approval requests.';
        RejectOnlyOpenRequestsErr: Label 'You can only reject open approval entries.';
        ApprovalsDelegatedMsg: Label 'The selected approval requests have been delegated.';
        NoReqToApproveErr: Label 'There is no approval request to approve.';
        NoReqToRejectErr: Label 'There is no approval request to reject.';
        NoReqToDelegateErr: Label 'There is no approval request to delegate.';
        PendingApprovalMsg: Label 'An approval request has been sent.';
        NoApprovalsSentMsg: Label 'No approval requests have been sent, either because they are already sent or because related workflows do not support the journal line.';
        PendingApprovalForSelectedLinesMsg: Label 'Approval requests have been sent.';
        PendingApprovalForSomeSelectedLinesMsg: Label 'Approval requests have been sent.\\Requests for some journal lines were not sent, either because they are already sent or because related workflows do not support the journal line.';
        PurchaserUserNotFoundErr: Label 'The salesperson/purchaser user ID %1 does not exist in the Approval User Setup window for %2 %3.', Comment = 'Example: The salesperson/purchaser user ID NAVUser does not exist in the Approval User Setup window for Salesperson/Purchaser code AB.';
        NoApprovalRequestsFoundErr: Label 'No approval requests exist.';
        NoWFUserGroupMembersErr: Label 'A workflow user group with at least one member must be set up.';
        DocStatusChangedMsg: Label '%1 %2 has been automatically approved. The status has been changed to %3.', Comment = 'Order 1001 has been automatically approved. The status has been changed to Released.';
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        SalesPrePostCheckErr: Label 'Sales %1 %2 must be approved and released before you can perform this action.', Comment = '%1=document type, %2="Document No.", e.g. Sales Order 321 must be approved...';
        WorkflowEventHandling: Codeunit 1520;
        WorkflowManagement: Codeunit 1501;
        PurchPrePostCheckErr: Label 'Purchase %1 %2 must be approved and released before you can perform this action.', Comment = '%1=document type, %2="Document No.", e.g. Purchase Order 321 must be approved...';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        ApprovalReqCanceledForSelectedLinesMsg: Label 'The approval request for the selected record has been canceled.';
        PendingJournalBatchApprovalExistsErr: Label 'An approval request already exists.', Comment = '%1 is the "Document No." of the journal line';
        ApporvalChainIsUnsupportedMsg: Label 'Only Direct Approver is supported as Approver Limit Type option for %1. The approval request will be approved automatically.', Comment = 'Only Direct Approver is supported as Approver Limit Type option for Gen. Journal Batch DEFAULT, CASH. The approval request will be approved automatically.';
        RecHasBeenApprovedMsg: Label '%1 has been approved.', Comment = '%1 = Record Id';
        NoPermissionToDelegateErr: Label 'You do not have permission to delegate one or more of the selected approval requests.';
        NothingToApproveErr: Label 'There is nothing to approve.';
        ApproverChainErr: Label 'No sufficient approver was found in the approver chain.';

        HRWFEvents: Codeunit 50039;

        ApprovalMgtCu: Codeunit 1535;
        UserSetup: Record "User Setup";
    // [IntegrationEvent(false,false)]

    procedure CheckHRJobApprovalsWorkflowEnabled(var HRJob: Record 50093): Boolean
    begin
        IF NOT IsHRJobApprovalsWorkflowEnabled(HRJob) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHRJobApprovalsWorkflowEnabled(var HRJob: Record 50093): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HRJob, HRWFEvents.RunWorkflowOnSendHRJobForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHRJobForApproval(var HRJob: Record 50093)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRJobApprovalRequest(var HRJob: Record 50093)
    begin
    end;

    procedure CheckHREmployeeRequisitionApprovalsWorkflowEnabled(var HREmployeeRequisition: Record 50098): Boolean
    begin
        IF NOT IsHREmployeeRequisitionApprovalsWorkflowEnabled(HREmployeeRequisition) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHREmployeeRequisitionApprovalsWorkflowEnabled(var HREmployeeRequisition: Record 50098): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HREmployeeRequisition, HRWFEvents.RunWorkflowOnSendHREmployeeRequisitionForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHREmployeeRequisitionForApproval(var HREmployeeRequisition: Record 50098)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure "OnCancelHREmployee RequisitionApprovalRequest"(var HREmployeeRequisition: Record 50098)
    begin
    end;
    /* 
        procedure CheckHRJobApplicationApprovalsWorkflowEnabled(var HRJobApplication: Record 50099): Boolean
        begin
            IF NOT IsHRJobApplicationApprovalsWorkflowEnabled(HRJobApplication) THEN
                ERROR(NoWorkflowEnabledErr);
            EXIT(TRUE);
        end;

            procedure IsHRJobApplicationApprovalsWorkflowEnabled(var HRJobApplication: Record 50099): Boolean
            begin
                EXIT(WorkflowManagement.CanExecuteWorkflow(HRJobApplication, HRWFEvents.RunWorkflowOnSendHRJobApplicationForApprovalCode));
            end; */

    [IntegrationEvent(false, false)]

    procedure OnSendHRJobApplicationForApproval(var HRJobApplication: Record 50099)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRJobApplicationApprovalRequest(var HRJobApplication: Record 50099)
    begin
    end;

    procedure CheckInterviewAttendanceHeaderApprovalsWorkflowEnabled(var InterviewAttendanceHeader: Record 50108): Boolean
    begin
        IF NOT IsInterviewAttendanceHeaderApprovalsWorkflowEnabled(InterviewAttendanceHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsInterviewAttendanceHeaderApprovalsWorkflowEnabled(var InterviewAttendanceHeader: Record 50108): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(InterviewAttendanceHeader, HRWFEvents.RunWorkflowOnSendInterviewHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendInterviewHeaderAttendanceForApproval(var InterviewAttendanceHeader: Record 50108)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelInterviewAttendanceApprovalRequest(var InterviewAttendanceHeader: Record 50108)
    begin
    end;

    procedure CheckHRLeavePlannerHeaderApprovalsWorkflowEnabled(var HRLeavePlannerHeader: Record 50125): Boolean
    begin
        IF NOT IsHRLeavePlannerHeaderApprovalsWorkflowEnabled(HRLeavePlannerHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHRLeavePlannerHeaderApprovalsWorkflowEnabled(var HRLeavePlannerHeader: Record 50125): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HRLeavePlannerHeader, HRWFEvents.RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHRLeavePlannerHeaderForApproval(var HRLeavePlannerHeader: Record 50125)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRLeavePlannerHeaderApprovalRequest(var HRLeavePlannerHeader: Record 50125)
    begin
    end;

    procedure CheckHRLeaveApplicationApprovalsWorkflowEnabled(var HRLeaveApplication: Record 50127): Boolean
    begin
        IF NOT IsHRLeaveApplicationApprovalsWorkflowEnabled(HRLeaveApplication) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHRLeaveApplicationApprovalsWorkflowEnabled(var HRLeaveApplication: Record 50127): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HRLeaveApplication, HRWFEvents.RunWorkflowOnSendHRLeaveApplicationForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHRLeaveApplicationForApproval(var HRLeaveApplication: Record 50127)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRLeaveApplicationApprovalRequest(var HRLeaveApplication: Record 50127)
    begin
    end;

    procedure CheckHRLeaveReimbusmentApprovalsWorkflowEnabled(var HRLeaveReimbusment: Record 50128): Boolean
    begin
        IF NOT IsHRLeaveReimbusmentApprovalsWorkflowEnabled(HRLeaveReimbusment) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHRLeaveReimbusmentApprovalsWorkflowEnabled(var HRLeaveReimbusment: Record 50128): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HRLeaveReimbusment, HRWFEvents.RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHRLeaveReimbusmentForApproval(var HRLeaveReimbusment: Record 50128)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRLeaveReimbusmentApprovalRequest(var HRLeaveReimbusment: Record 50128)
    begin
    end;

    procedure CheckHRLeaveCarryoverApprovalsWorkflowEnabled(var HRLeaveCarryover: Record 50129): Boolean
    begin
        IF NOT IsHRLeaveCarryoverApprovalsWorkflowEnabled(HRLeaveCarryover) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHRLeaveCarryoverApprovalsWorkflowEnabled(var HRLeaveCarryover: Record 50129): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HRLeaveCarryover, HRWFEvents.RunWorkflowOnSendHRLeaveCarryoverForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHRLeaveCarryoverForApproval(var HRLeaveCarryover: Record 50129)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRLeaveCarryoverApprovalRequest(var HRLeaveCarryover: Record 50129)
    begin
    end;

    procedure CheckHRLeaveAllocationHeaderApprovalsWorkflowEnabled(var HRLeaveAllocationHeader: Record 50130): Boolean
    begin
        IF NOT IsHRLeaveAllocationHeaderApprovalsWorkflowEnabled(HRLeaveAllocationHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHRLeaveAllocationHeaderApprovalsWorkflowEnabled(var HRLeaveAllocationHeader: Record 50130): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HRLeaveAllocationHeader, HRWFEvents.RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHRLeaveAllocationHeaderForApproval(var HRLeaveAllocationHeader: Record 50130)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRLeaveAllocationHeaderApprovalRequest(var HRLeaveAllocationHeader: Record 50130)
    begin
    end;




    [IntegrationEvent(false, false)]

    procedure OnSendHREmployeeAppraisalHeaderForApproval(var HREmployeeAppraisalHeader: Record 50281)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHREmployeeAppraisalHeaderApprovalRequest(var HREmployeeAppraisalHeader: Record 50281)
    begin
    end;

    procedure CheckTrainingEvaluationApprovalsWorkflowEnabled(var TrainingEvaluation: Record 50161): Boolean
    begin
        IF NOT IsTrainingEvaluationApprovalsWorkflowEnabled(TrainingEvaluation) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsTrainingEvaluationApprovalsWorkflowEnabled(var TrainingEvaluation: Record 50161): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(TrainingEvaluation, HRWFEvents.RunWorkflowOnSendTrainingEvaluationForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendTrainingEvaluationForApproval(var TrainingEvaluation: Record 50161)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelTrainingEvaluationApprovalRequest(var TrainingEvaluation: Record 50161)
    begin
    end;

    procedure CheckHrTrainingNeedsHeaderApprovalsWorkflowEnabled(var HRTrainingNeedsHeader: Record 50157): Boolean
    begin
        IF NOT IsHRTrainingNeedsHeaderApprovalsWorkflowEnabled(HRTrainingNeedsHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHRTrainingNeedsHeaderApprovalsWorkflowEnabled(var HRTrainingNeedsHeader: Record 50157): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HRTrainingNeedsHeader, HRWFEvents.RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHRTrainingNeedsHeaderForApproval(var HRTrainingNeedsHeader: Record 50157)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRTrainingNeedsHeaderApprovalRequest(var HRTrainingNeedsHeader: Record 50157)
    begin
    end;

    procedure CheckHrTrainingGroupApprovalsWorkflowEnabled(var HRTrainingGroup: Record 50162): Boolean
    begin
        IF NOT IsHRTrainingGroupApprovalsWorkflowEnabled(HRTrainingGroup) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHRTrainingGroupApprovalsWorkflowEnabled(var HRTrainingGroup: Record 50162): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HRTrainingGroup, HRWFEvents.RunWorkflowOnSendHRTrainingGroupForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHRTrainingGroupForApproval(var HRTrainingGroup: Record 50162)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRTrainingGroupApprovalRequest(var HRTrainingGroup: Record 50162)
    begin
    end;

    procedure CheckHRTrainingApplicationsHeaderApprovalsWorkflowEnabled(var HRTrainingApplications: Record 50164): Boolean
    begin
        IF NOT IsHRTrainingApplicationsHeaderApprovalsWorkflowEnabled(HRTrainingApplications) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsHRTrainingApplicationsHeaderApprovalsWorkflowEnabled(var HRTrainingApplications: Record 50164): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(HRTrainingApplications, HRWFEvents.RunWorkflowOnSendHRTrainingHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendHRTrainingApplicationsHeaderForApproval(var HRTrainingApplications: Record 50164)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelHRTrainingApplicationsHeaderApprovalRequest(var HRTrainingApplications: Record 50164)
    begin
    end;

    procedure CheckLeaveAllowanceApprovalsWorkflowEnabled(var LeaveAllowanceRequest: Record 50207): Boolean
    begin
        IF NOT IsLeaveAllowanceApprovalsWorkflowEnabled(LeaveAllowanceRequest) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsLeaveAllowanceApprovalsWorkflowEnabled(var LeaveAllowanceRequest: Record 50207): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LeaveAllowanceRequest, HRWFEvents.RunWorkflowOnSendLeaveAllowanceForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendLeaveAllowanceForApproval(var LeaveAllowanceRequest: Record 50207)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelLeaveAllowanceApprovalRequest(var LeaveAllowanceRequest: Record 50207)
    begin
    end;



    local procedure ApproveSelectedApprovalRequest(var ApprovalEntry: Record 454)
    begin
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(ApproveOnlyOpenRequestsErr);

        // IF (ApprovalEntry."Approver ID" <> USERID) AND NOT ApprovalEntry."Web Portal Approval" THEN
        //CheckUserAsApprovalAdministrator;

        ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Approved);
        ApprovalEntry.MODIFY(TRUE);
        OnApproveApprovalRequest(ApprovalEntry);
    end;




    local procedure RejectSelectedApprovalRequest(var ApprovalEntry: Record 454)
    begin
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(RejectOnlyOpenRequestsErr);

        // IF (ApprovalEntry."Approver ID" <> USERID) AND NOT ApprovalEntry."Web Portal Approval" THEN
        //  CheckUserAsApprovalAdministrator;

        OnRejectApprovalRequest(ApprovalEntry);
        ApprovalEntry.GET(ApprovalEntry."Entry No.");
        ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Rejected);
        ApprovalEntry.MODIFY(TRUE);
    end;


    procedure DelegateSelectedApprovalRequest(var ApprovalEntry: Record 454; CheckCurrentUser: Boolean)
    begin
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(DelegateOnlyOpenRequestsErr);

        IF CheckCurrentUser AND (NOT ApprovalEntry.CanCurrentUserEdit) THEN
            ERROR(NoPermissionToDelegateErr);

        SubstituteUserIdForApprovalEntry(ApprovalEntry)
    end;

    local procedure SubstituteUserIdForApprovalEntry(ApprovalEntry: Record 454)
    var
        UserSetup: Record 91;
        ApprovalAdminUserSetup: Record 91;
    begin
        IF NOT UserSetup.GET(ApprovalEntry."Approver ID") THEN
            ERROR(ApproverUserIdNotInSetupErr, ApprovalEntry."Sender ID");

        IF UserSetup.Substitute = '' THEN
            IF UserSetup."Approver ID" = '' THEN BEGIN
                ApprovalAdminUserSetup.SETRANGE("Approval Administrator", TRUE);
                IF ApprovalAdminUserSetup.FINDFIRST THEN
                    UserSetup.GET(ApprovalAdminUserSetup."User ID")
                ELSE
                    ERROR(SubstituteNotFoundErr, UserSetup."User ID");
            END ELSE
                UserSetup.GET(UserSetup."Approver ID")
        ELSE
            UserSetup.GET(UserSetup.Substitute);

        ApprovalEntry."Approver ID" := UserSetup."User ID";
        ApprovalEntry.MODIFY(TRUE);
        OnDelegateApprovalRequest(ApprovalEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record 454)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnDelegateApprovalRequest(var ApprovalEntry: Record 454)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record 454)
    begin
    end;


    procedure FindOpenApprovalEntryForCurrUser(var ApprovalEntry: Record 454; RecordID: RecordID): Boolean
    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Approver ID", USERID);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);

        EXIT(ApprovalEntry.FINDFIRST);
    end;


    procedure FindApprovalEntryForCurrUser(var ApprovalEntry: Record 454; RecordID: RecordID): Boolean
    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE("Approver ID", USERID);

        EXIT(ApprovalEntry.FINDFIRST);
    end;
}
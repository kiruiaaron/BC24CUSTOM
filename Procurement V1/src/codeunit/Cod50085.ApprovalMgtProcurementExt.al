

codeunit 50085 "Approval Mgt.Procurement Ext"
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
        FundsWFEvents: Codeunit 50004;
        ProcurementWFEvents: Codeunit 50010;
        InventoryWFEvents: Codeunit 50015;


        ApprovalMgtCu: Codeunit 1535;
        UserSetup: Record "User Setup";
    // [IntegrationEvent(false,false)]


    procedure CheckPurchaseRequisitionApprovalsWorkflowEnabled(var PurchaseRequisition: Record 50046): Boolean
    begin
        IF NOT IsPurchaseRequisitionApprovalsWorkflowEnabled(PurchaseRequisition) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsPurchaseRequisitionApprovalsWorkflowEnabled(var PurchaseRequisition: Record 50046): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(PurchaseRequisition, ProcurementWFEvents.RunWorkflowOnSendPurchaseRequisitionForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendPurchaseRequisitionForApproval(var PurchaseRequisition: Record 50046)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelPurchaseRequisitionApprovalRequest(var PurchaseRequisition: Record 50046)
    begin
    end;

    procedure CheckProcurementPlanApprovalsWorkflowEnabled(var ProcurementPlanningHeader: Record 50063): Boolean
    begin
        IF NOT IsProcurementPlanApprovalsWorkflowEnabled(ProcurementPlanningHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsProcurementPlanApprovalsWorkflowEnabled(var ProcurementPlanningHeader: Record 50063): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ProcurementPlanningHeader, ProcurementWFEvents.RunWorkflowOnSendProcurementPlanForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendProcurementPlanForApproval(var ProcurementPlanningHeader: Record 50063)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelProcurementPlanApprovalRequest(var ProcurementPlanningHeader: Record 50063)
    begin
    end;

    procedure CheckTenderHeaderApprovalsWorkflowEnabled(var TenderHeader: Record 50055): Boolean
    begin
        IF NOT IsTenderHeaderApprovalsWorkflowEnabled(TenderHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsTenderHeaderApprovalsWorkflowEnabled(var TenderHeader: Record 50055): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(TenderHeader, ProcurementWFEvents.RunWorkflowOnSendTenderHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendTenderHeaderForApproval(var TenderHeader: Record 50055)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelTenderHeaderApprovalRequest(var TenderHeader: Record 50055)
    begin
    end;

    procedure CheckStoreRequisitionApprovalsWorkflowEnabled(var StoreRequisition: Record 50068): Boolean
    begin
        IF NOT IsStoreRequisitionApprovalsWorkflowEnabled(StoreRequisition) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsStoreRequisitionApprovalsWorkflowEnabled(var StoreRequisition: Record 50068): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(StoreRequisition, InventoryWFEvents.RunWorkflowOnSendStoreRequisitionForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendStoreRequisitionForApproval(var StoreRequisition: Record 50068)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelStoreRequisitionApprovalRequest(var StoreRequisition: Record 50068)
    begin
    end;


    /*
        procedure CheckHRLoanApprovalsWorkflowEnabled(var EmployeeLoanApplications: Record 50074): Boolean
        begin
            IF NOT IsHRLoanApprovalsWorkflowEnabled(EmployeeLoanApplications) THEN
                ERROR(NoWorkflowEnabledErr);
            EXIT(TRUE);
        end;

        procedure IsHRLoanApprovalsWorkflowEnabled(var EmployeeLoanApplications: Record 50074): Boolean
        begin
            EXIT(WorkflowManagement.CanExecuteWorkflow(EmployeeLoanApplications, HRWFEvents.RunWorkflowOnSendHRLoanForApprovalCode));
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnSendHRLoanForApproval(var EmployeeLoanApplications: Record 50074)
        begin
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnCancelHRLoanApprovalRequest(var EmployeeLoanApplications: Record 50074)
        begin
        end;

        procedure CheckHRLoanDisbursementApprovalsWorkflowEnabled(var EmployeeLoanDisbursement: Record 50076): Boolean
        begin
            IF NOT IsHRLoanDisbursementApprovalsWorkflowEnabled(EmployeeLoanDisbursement) THEN
                ERROR(NoWorkflowEnabledErr);
            EXIT(TRUE);
        end;

        procedure IsHRLoanDisbursementApprovalsWorkflowEnabled(var EmployeeLoanDisbursement: Record 50076): Boolean
        begin
            EXIT(WorkflowManagement.CanExecuteWorkflow(EmployeeLoanDisbursement, HRWFEvents.RunWorkflowOnSendHRLoanDisbursementForApprovalCode));
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnSendHRLoanDisbursementForApproval(var EmployeeLoanDisbursement: Record 50076)
        begin
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnCancelHRLoanDisbursementApprovalRequest(var EmployeeLoanDisbursement: Record 50076)
        begin
        end;

        procedure CheckTransportRequestApprovalsWorkflowEnabled(var TransportRequest: Record 50210): Boolean
        begin
            IF NOT IsTransportRequestApprovalsWorkflowEnabled(TransportRequest) THEN
                ERROR(NoWorkflowEnabledErr);
            EXIT(TRUE);
        end;

        procedure IsTransportRequestApprovalsWorkflowEnabled(var TransportRequest: Record 50210): Boolean
        begin
            EXIT(WorkflowManagement.CanExecuteWorkflow(TransportRequest, HRWFEvents.RunWorkflowOnSendHRTransportRequestForApprovalCode));
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnSendTransportRequestForApproval(var TransportRequest: Record 50210)
        begin
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnCancelTransportRequestApprovalRequest(var TransportRequest: Record 50210)
        begin
        end;

        local procedure GetEmployeeUserId(EmployeeNo: Code[10]) UsrID: Code[50]
        var
            EmployeeRec: Record 5200;
        begin
            IF EmployeeRec.GET(EmployeeNo) THEN
                IF EmployeeRec."User ID" <> '' THEN
                    UsrID := EmployeeRec."User ID"
                ELSE
                    UsrID := USERID;//the default user id.
        end;

        procedure CheckFuelRequestApprovalsWorkflowEnabled(var FuelRequisition: Record 50214): Boolean
        begin
            IF NOT IsFuelRequestApprovalsWorkflowEnabled(FuelRequisition) THEN
                ERROR(NoWorkflowEnabledErr);
            EXIT(TRUE);
        end;

        procedure IsFuelRequestApprovalsWorkflowEnabled(var FuelRequisition: Record 50214): Boolean
        begin
            EXIT(WorkflowManagement.CanExecuteWorkflow(FuelRequisition, HRWFEvents.RunWorkflowOnSendFuelRequestForApprovalCode));
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnSendFuelRequestForApproval(var FuelRequisition: Record 50214)
        begin
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnCancelFuelRequestApprovalRequest(var FuelRequisition: Record 50214)
        begin
        end;

        procedure CheckWorkTickettApprovalsWorkflowEnabled(var WorkTicket: Record 50310): Boolean
        begin
            IF NOT IsWorkticketApprovalsWorkflowEnabled(WorkTicket) THEN
                ERROR(NoWorkflowEnabledErr);
            EXIT(TRUE);
        end;

        procedure IsWorkticketApprovalsWorkflowEnabled(var WorkTicket: Record 50310): Boolean
        begin
            EXIT(WorkflowManagement.CanExecuteWorkflow(WorkTicket, HRWFEvents.RunWorkflowOnSendWorkTicketForApprovalCode));
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnSendWorkTicketForApproval(var WorkTicket: Record 50310)
        begin
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnCancelWorkTicketApprovalRequest(var WorkTicket: Record 50310)
        begin
        end;

        procedure CheckCasualRequestApprovalsWorkflowEnabled(var CasualRequest: Record 50279): Boolean
        begin
            IF NOT IsCasualRequestApprovalsWorkflowEnabled(CasualRequest) THEN
                ERROR(NoWorkflowEnabledErr);
            EXIT(TRUE);
        end;

        procedure IsCasualRequestApprovalsWorkflowEnabled(var CasualRequest: Record 50279): Boolean
        begin
            EXIT(WorkflowManagement.CanExecuteWorkflow(CasualRequest, HRWFEvents.RunWorkflowOnSendCasualRequestForApprovalCode));
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnSendCasualRequestForApproval(var "Casual Request": Record 50279)
        begin
        end;

        [IntegrationEvent(false, false)]
        
        procedure OnCancelCasualRequestApprovalRequest(var CasualRequest: Record 50279)
        begin
        end;
       */

    local procedure ApproveSelectedApprovalRequest(var ApprovalEntry: Record 454)
    begin
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(ApproveOnlyOpenRequestsErr);

        IF (ApprovalEntry."Approver ID" <> USERID) AND NOT ApprovalEntry."Web Portal Approval" THEN
            //CheckUserAsApprovalAdministrator;

        ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Approved);
        ApprovalEntry.MODIFY(TRUE);
        OnApproveApprovalRequest(ApprovalEntry);
    end;




    local procedure RejectSelectedApprovalRequest(var ApprovalEntry: Record 454)
    begin
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(RejectOnlyOpenRequestsErr);

        IF (ApprovalEntry."Approver ID" <> USERID) AND NOT ApprovalEntry."Web Portal Approval" THEN
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var variant: Variant; var IsHandled: Boolean)
    var
        PurchaseRequisitionRec: Record "Purchase Requisitions";
        StoreRequisitionHeaderRec: Record "Store Requisition Header";
    begin
        case RecRef.Number of

            Database::"Purchase Requisitions":
                begin
                    RecRef.SetTable(PurchaseRequisitionRec);
                    PurchaseRequisitionRec.Status := PurchaseRequisitionRec.Status::"Pending Approval";
                    PurchaseRequisitionRec.Modify();

                    IsHandled := true;
                end;
            Database::"Store Requisition Header":
                begin
                    RecRef.SetTable(StoreRequisitionHeaderRec);
                    StoreRequisitionHeaderRec.Status := StoreRequisitionHeaderRec.Status::"Pending Approval";
                    StoreRequisitionHeaderRec.Modify();
                    IsHandled := true;
                end;
        end;
    end;

}
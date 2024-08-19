

codeunit 50083 "Approval Mgt. Fund Ext"
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

        HRWFEvents: Codeunit 50039;

        ApprovalMgtCu: Codeunit 1535;
        UserSetup: Record "User Setup";
    // [IntegrationEvent(false,false)]

    procedure CheckPaymentApprovalsWorkflowEnabled(var PaymentHeader: Record 50002): Boolean
    begin
        IF NOT IsPaymentApprovalsWorkflowEnabled(PaymentHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsPaymentApprovalsWorkflowEnabled(var PaymentHeader: Record 50002): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(PaymentHeader, FundsWFEvents.RunWorkflowOnSendPaymentHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendPaymentHeaderForApproval(var PaymentHeader: Record 50002)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelPaymentHeaderApprovalRequest(var PaymentHeader: Record 50002)
    begin
    end;


    procedure ShowPaymentHeaderApprovalEntries(var "Payment Header": Record 50002)
    var
        ApprovalEntry: Record 454;
    begin
        ApprovalEntry.SETFILTER("Table ID", '%1', DATABASE::"Payment Header");
        ApprovalEntry.SETFILTER("Record ID to Approve", '%1', "Payment Header".RECORDID);
        ApprovalEntry.SETRANGE("Document No.", "Payment Header"."No.");
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        PAGE.RUN(PAGE::"Approval Entries", ApprovalEntry);
    end;

    procedure CheckReceiptApprovalsWorkflowEnabled(var ReceiptHeader: Record 50004): Boolean
    begin
        IF NOT IsReceiptApprovalsWorkflowEnabled(ReceiptHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsReceiptApprovalsWorkflowEnabled(var ReceiptHeader: Record 50004): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ReceiptHeader, FundsWFEvents.RunWorkflowOnSendReceiptHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendReceiptHeaderForApproval(var ReceiptHeader: Record 50004)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelReceiptHeaderApprovalRequest(var ReceiptHeader: Record 50004)
    begin
    end;

    procedure CheckFundsTransferApprovalsWorkflowEnabled(var FundsTransferHeader: Record 50006): Boolean
    begin
        IF NOT IsFundsTransferApprovalsWorkflowEnabled(FundsTransferHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsFundsTransferApprovalsWorkflowEnabled(var FundsTransferHeader: Record 50006): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(FundsTransferHeader, FundsWFEvents.RunWorkflowOnSendFundsTransferHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendFundsTransferHeaderForApproval(var FundsTransferHeader: Record 50006)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelFundsTransferHeaderApprovalRequest(var FundsTransferHeader: Record 50006)
    begin
    end;

    procedure CheckImprestApprovalsWorkflowEnabled(var ImprestHeader: Record 50008): Boolean
    begin
        IF NOT IsImprestApprovalsWorkflowEnabled(ImprestHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsImprestApprovalsWorkflowEnabled(var ImprestHeader: Record 50008): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ImprestHeader, FundsWFEvents.RunWorkflowOnSendImprestHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendImprestHeaderForApproval(var ImprestHeader: Record 50008)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelImprestHeaderApprovalRequest(var ImprestHeader: Record 50008)
    begin
    end;

    procedure CheckImprestSurrenderApprovalsWorkflowEnabled(var ImprestSurrender: Record 50010): Boolean
    begin
        IF NOT IsImprestSurrenderApprovalsWorkflowEnabled(ImprestSurrender) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsImprestSurrenderApprovalsWorkflowEnabled(var ImprestSurrender: Record 50010): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ImprestSurrender, FundsWFEvents.RunWorkflowOnSendImprestSurrenderHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendImprestSurrenderHeaderForApproval(var ImprestSurrender: Record 50010)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelImprestSurrenderHeaderApprovalRequest(var ImprestSurrender: Record 50010)
    begin
    end;

    procedure CheckFundsClaimApprovalsWorkflowEnabled(var FundsClaimHeader: Record 50012): Boolean
    begin
        IF NOT IsFundsClaimApprovalsWorkflowEnabled(FundsClaimHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsFundsClaimApprovalsWorkflowEnabled(var FundsClaimHeader: Record 50012): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(FundsClaimHeader, FundsWFEvents.RunWorkflowOnSendFundsClaimHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendFundsClaimHeaderForApproval(var FundsClaimHeader: Record 50012)
    begin
    end;

    [IntegrationEvent(false, false)]


    procedure OnCancelFundsClaimHeaderApprovalRequest(var FundsClaimHeader: Record 50012)
    begin
    end;

    procedure CheckDocumentReversalApprovalsWorkflowEnabled(var DocumentReversalHeader: Record 50034): Boolean
    begin
        IF NOT IsDocumentReversalApprovalsWorkflowEnabled(DocumentReversalHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsDocumentReversalApprovalsWorkflowEnabled(var DocumentReversalHeader: Record 50034): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(DocumentReversalHeader, FundsWFEvents.RunWorkflowOnSendDocumentReversalHeaderForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendDocumentReversalHeaderForApproval(var DocumentReversalHeader: Record 50034)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelDocumentReversalHeaderApprovalRequest(var DocumentReversalHeader: Record 50034)
    begin
    end;

    procedure CheckJournalVoucherApprovalsWorkflowEnabled(var JournalVoucherHeader: Record 50016): Boolean
    begin
        IF NOT IsJournalVoucherApprovalsWorkflowEnabled(JournalVoucherHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsJournalVoucherApprovalsWorkflowEnabled(var JournalVoucherHeader: Record 50016): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(JournalVoucherHeader, FundsWFEvents.RunWorkflowOnSendJournalVoucherForApprovalCode));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendJournalVoucherForApproval(var JournalVoucherHeader: Record 50016)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelJournalVoucherApprovalRequest(var JournalVoucherHeader: Record 50016)
    begin
    end;



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
}
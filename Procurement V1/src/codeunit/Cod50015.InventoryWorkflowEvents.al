codeunit 50015 "Inventory Workflow Events"
{

    trigger OnRun()
    begin
    end;

    var
        WFHandler: Codeunit 1520;
        WorkflowManagement: Codeunit 1501;

    procedure AddEventsToLibrary()
    begin
        //---------------------------------------------1. Approval Events--------------------------------------------------------------
        //Store Requisition
        WFHandler.AddEventToLibrary(RunWorkflowOnSendStoreRequisitionForApprovalCode,
                                    DATABASE::"Store Requisition Header", 'Approval of a store requisition is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelStoreRequisitionApprovalRequestCode,
                                    DATABASE::"Store Requisition Header", 'An approval request for a store requisition is canceled.', 0, FALSE);

        //Transfer Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendTransferHeaderForApprovalCode,
                                    DATABASE::"Transfer Header", 'Approval of a transfer order is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelTransferHeaderApprovalRequestCode,
                                    DATABASE::"Transfer Header", 'An approval request for a transfer order is canceled.', 0, FALSE);
        //-------------------------------------------End Approval Events-------------------------------------------------------------
    end;

    procedure AddEventsPredecessor()
    begin
        //--------------------------------------1.Approval,Rejection,Delegation Predecessors------------------------------------------------
        //Store Requisition
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendStoreRequisitionForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendStoreRequisitionForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendStoreRequisitionForApprovalCode);//Delegate

        //Transfer Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendTransferHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendTransferHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendTransferHeaderForApprovalCode);//Delegate

        //---------------------------------------End Approval,Rejection,Delegation Predecessors---------------------------------------------
    end;

    procedure RunWorkflowOnSendStoreRequisitionForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendStoreRequisitionForApproval'));
    end;

    procedure RunWorkflowOnCancelStoreRequisitionApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelStoreRequisitionApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnSendStoreRequisitionForApproval', '', false, false)]
    procedure RunWorkflowOnSendStoreRequisitionForApproval(var StoreRequisition: Record 50068)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendStoreRequisitionForApprovalCode, StoreRequisition);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnCancelStoreRequisitionApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelStoreRequisitionApprovalRequest(var StoreRequisition: Record 50068)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelStoreRequisitionApprovalRequestCode, StoreRequisition);
    end;

    procedure RunWorkflowOnSendTransferHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendTransferHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelTransferHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelTransferHeaderApprovalRequest'));
    end;

    /* [EventSubscriber(ObjectType::Codeunit, 50085, 'OnSendPurchaseRequisitionForApproval', '', false, false)]
    procedure RunWorkflowOnSendTransferHeaderForApproval(var TransferHeader: Record 5740)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendTransferHeaderForApprovalCode, TransferHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnCancelPurchaseRequisitionApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelTransferHeaderApprovalRequest(var TransferHeader: Record 5740)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelTransferHeaderApprovalRequestCode, TransferHeader);
    end; */
}


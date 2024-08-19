codeunit 50010 "Procurement Workflow Events"
{

    trigger OnRun()
    begin
    end;

    var
        WFHandler: Codeunit 1520;
        WorkflowManagement: Codeunit 1501;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddEventsToLibrary()
    begin
        //---------------------------------------------1. Approval Events--------------------------------------------------------------
        //Purchase Requisition
        WFHandler.AddEventToLibrary(RunWorkflowOnSendPurchaseRequisitionForApprovalCode,
                                    DATABASE::"Purchase Requisitions", 'Approval of a purchase requisition is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode,
                                    DATABASE::"Purchase Requisitions", 'An approval request for a purchase requisition is canceled.', 0, FALSE);

        //Bid Analysis
        WFHandler.AddEventToLibrary(RunWorkflowOnSendBidAnalysisForApprovalCode,
                                    DATABASE::"Bid Analysis Header", 'Approval of a bid analysis document is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelBidAnalysisApprovalRequestCode,
                                    DATABASE::"Bid Analysis Header", 'An approval request for a bid analysis document is canceled.', 0, FALSE);

        //Procurement Plan
        WFHandler.AddEventToLibrary(RunWorkflowOnSendProcurementPlanForApprovalCode,
                                    DATABASE::"Procurement Planning Header", 'Approval of a Procurement Plan Document is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelProcurementPlanApprovalRequestCode,
                                    DATABASE::"Procurement Planning Header", 'An approval request for a Procurement Plan Document is canceled.', 0, FALSE);

        //Tender Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendTenderHeaderForApprovalCode,
                                    DATABASE::"Tender Header", 'Approval of a Tender Header Document is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelTenderHeaderApprovalRequestCode,
                                    DATABASE::"Tender Header", 'An approval request for a Tender Header Document is canceled.', 0, FALSE);

        //-------------------------------------------End Approval Events-------------------------------------------------------------
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    procedure AddEventsPredecessor()
    begin
        //--------------------------------------1.Approval,Rejection,Delegation Predecessors------------------------------------------------
        //Purchase Requisition
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPurchaseRequisitionForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPurchaseRequisitionForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPurchaseRequisitionForApprovalCode);//Delegate

        //Bid Analysis
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendBidAnalysisForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendBidAnalysisForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendBidAnalysisForApprovalCode);//Delegate

        //Procurement Plan
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendProcurementPlanForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendProcurementPlanForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendProcurementPlanForApprovalCode);//Delegate

        //Tender Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendTenderHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendTenderHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendTenderHeaderForApprovalCode);//Delegate


        //---------------------------------------End Approval,Rejection,Delegation Predecessors---------------------------------------------
    end;

    procedure RunWorkflowOnSendPurchaseRequisitionForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendPurchaseRequisitionForApproval'));
    end;

    procedure RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelPurchaseRequisitionApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnSendPurchaseRequisitionForApproval', '', false, false)]
    procedure RunWorkflowOnSendPurchaseRequisitionForApproval(var PurchaseRequisition: Record 50046)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPurchaseRequisitionForApprovalCode, PurchaseRequisition);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnCancelPurchaseRequisitionApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelPurchaseRequisitionApprovalRequest(var PurchaseRequisition: Record 50046)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode, PurchaseRequisition);
    end;

    procedure RunWorkflowOnSendBidAnalysisForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendBidAnalysisForApproval'));
    end;

    procedure RunWorkflowOnCancelBidAnalysisApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelBidAnalysisApprovalRequest'));
    end;

    /* [EventSubscriber(ObjectType::Codeunit, 50085, 'OnSendBidAnalysisForApproval', '', false, false)]
    procedure RunWorkflowOnSendBidAnalysisForApproval(var BidAnalysis: Record 50053)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendBidAnalysisForApprovalCode, BidAnalysis);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnCancelBidAnalysisApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelBidAnalysisApprovalRequest(var BidAnalysis: Record 50053)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelBidAnalysisApprovalRequestCode, BidAnalysis);
    end; */

    procedure RunWorkflowOnSendProcurementPlanForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendProcurementPlanForApproval'));
    end;

    procedure RunWorkflowOnCancelProcurementPlanApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelProcurementPlanApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnSendProcurementPlanForApproval', '', false, false)]
    procedure RunWorkflowOnSendProcurementPlanForApproval(var ProcurementPlanningHeader: Record 50063)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendProcurementPlanForApprovalCode, ProcurementPlanningHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnCancelProcurementPlanApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelProcurementPlanApprovalRequest(var ProcurementPlanningHeader: Record 50063)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelProcurementPlanApprovalRequestCode, ProcurementPlanningHeader);
    end;

    procedure RunWorkflowOnSendTenderHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendTenderHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelTenderHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelTenderHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnSendTenderHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendTenderHeaderForApproval(var TenderHeader: Record 50055)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendTenderHeaderForApprovalCode, TenderHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50085, 'OnCancelTenderHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelTenderHeaderApprovalRequest(var TenderHeader: Record 50055)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelTenderHeaderApprovalRequestCode, TenderHeader);
    end;
}


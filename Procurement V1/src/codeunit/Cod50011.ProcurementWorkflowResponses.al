codeunit 50011 "Procurement Workflow Responses"
{

    trigger OnRun()
    begin
    end;

    var
        WFEventHandler: Codeunit 1520;
        WFResponseHandler: Codeunit 1521;
        ProcurementWorkflowEvents: Codeunit 50010;

    procedure AddResponsesToLibrary()
    begin
    end;

    procedure AddResponsePredecessors()
    begin
        //--------------------------------------Procurement Response Predecessors------------------------------------------------
        //Purchase Requisition
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode);

        //Bid Analysis
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendBidAnalysisForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendBidAnalysisForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendBidAnalysisForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnCancelBidAnalysisApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnCancelBidAnalysisApprovalRequestCode);


        //Procurement Plan
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendProcurementPlanForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendProcurementPlanForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendProcurementPlanForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnCancelProcurementPlanApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnCancelProcurementPlanApprovalRequestCode);

        //Tender Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendTenderHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendTenderHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnSendTenderHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnCancelTenderHeaderApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  ProcurementWorkflowEvents.RunWorkflowOnCancelTenderHeaderApprovalRequestCode);
    end;
}


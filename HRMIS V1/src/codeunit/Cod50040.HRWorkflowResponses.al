codeunit 50040 "HR Workflow Responses"
{

    trigger OnRun()
    begin
    end;

    var
        WFEventHandler: Codeunit 1520;
        WFResponseHandler: Codeunit 1521;
        HRWFEvents: Codeunit 50039;

    procedure AddResponsesToLibrary()
    begin
    end;

    procedure AddResponsePredecessors()
    begin
        //--------------------------------------HR Management Response Predecessors--------------------------------------------------------------------
        //HR Job
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRJobForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRJobForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRJobForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRJobApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRJobApprovalRequestCode);
        //HR Employee Requisition
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHREmployeeRequisitionForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHREmployeeRequisitionForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHREmployeeRequisitionForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHREmployeeRequisitionApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHREmployeeRequisitionApprovalRequestCode);
        //HR Job Application
        /*    WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                     HRWFEvents.RunWorkflowOnSendHRJobApplicationForApprovalCode);
           WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                     HRWFEvents.RunWorkflowOnSendHRJobApplicationForApprovalCode);
           WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                     HRWFEvents.RunWorkflowOnSendHRJobApplicationForApprovalCode);
           WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                     HRWFEvents.RunWorkflowOnCancelHRJobApplicationApprovalRequestCode);
           WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                     HRWFEvents.RunWorkflowOnCancelHRJobApplicationApprovalRequestCode);
       */     //HR Employee Detail Update
              /* WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                        HRWFEvents.RunWorkflowOnSendHREmployeeDetailUpdateForApprovalCode);
              WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                        HRWFEvents.RunWorkflowOnSendHREmployeeDetailUpdateForApprovalCode);
              WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                        HRWFEvents.RunWorkflowOnSendHREmployeeDetailUpdateForApprovalCode);
            */
              /*       WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                           HRWFEvents.RunWorkflowOnCancelHREmployeeDetailUpdateApprovalRequestCode);
                    WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                              HRWFEvents.RunWorkflowOnCancelHREmployeeDetailUpdateApprovalRequestCode);
             */        //HR Employee Appraisal Header
                       /*    WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                                    HRWFEvents.RunWorkflowOnSendHREmployeeAppraisalHeaderForApprovalCode);
                          WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                                    HRWFEvents.RunWorkflowOnSendHREmployeeAppraisalHeaderForApprovalCode);
                          WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                                    HRWFEvents.RunWorkflowOnSendHREmployeeAppraisalHeaderForApprovalCode);
                          WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                                    HRWFEvents.RunWorkflowOnCancelHREmployeeAppraisalHeaderApprovalRequestCode);
                          WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                                    HRWFEvents.RunWorkflowOnCancelHREmployeeAppraisalHeaderApprovalRequestCode);
                         */  //HR Leave Planner Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeavePlannerHeaderApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeavePlannerHeaderApprovalRequestCode);
        //HR Leave Application
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeaveApplicationApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeaveApplicationApprovalRequestCode);
        //HR Leave Reimbusment
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeaveReimbusmentApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeaveReimbusmentApprovalRequestCode);
        //HR Leave Carryover
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveCarryoverForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveCarryoverForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveCarryoverForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeaveCarryoverApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeaveCarryoverApprovalRequestCode);
        //HR Leave Allocation Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeaveAllocationHeaderApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLeaveAllocationHeaderApprovalRequestCode);
        //HR Asset Transfer Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRAssetTransferHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRAssetTransferHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRAssetTransferHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRAssetTransferHeaderApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRAssetTransferHeaderApprovalRequestCode);

        //HR Employee Transfer Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHREmployeeTransferHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHREmployeeTransferHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHREmployeeTransferHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHREmployeeTransferHeaderApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHREmployeeTransferHeaderApprovalRequestCode);

        //HR Exit Interview Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRExitInterviewHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRExitInterviewHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRExitInterviewHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRExitInterviewHeaderApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRExitInterviewHeaderApprovalRequestCode);


        //HR Training Application Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTrainingHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTrainingHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTrainingHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRTrainingHeaderApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRTrainingHeaderApprovalRequestCode);


        //HR Training Need Header
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRTrainingNeedsHeaderApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRTrainingNeedsHeaderApprovalRequestCode);

        //HR Training Group
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTrainingGroupForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTrainingGroupForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTrainingGroupForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelTrainingEvaluationApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelTrainingEvaluationApprovalRequestCode);

        //HR Training Evaluation
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendTrainingEvaluationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendTrainingEvaluationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendTrainingEvaluationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelTrainingEvaluationApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelTrainingEvaluationApprovalRequestCode);


        //HR Leave Allowance
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendLeaveAllowanceForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendLeaveAllowanceForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendLeaveAllowanceForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelLeaveAllowanceApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelLeaveAllowanceApprovalRequestCode);

        //HR Loan application
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLoanForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLoanForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLoanForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLoanApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLoanApprovalRequestCode);

        //HR Loan Product
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLoanProductForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLoanProductForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRLoanProductForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLoanProductApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRLoanProductApprovalRequestCode);


        //HR Loan Disbursement
        /*   WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                    HRWFEvents.RunWorkflowOnSendHRLoanDisbursementForApprovalCode);
          WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                    HRWFEvents.RunWorkflowOnSendHRLoanDisbursementForApprovalCode);
          WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                    HRWFEvents.RunWorkflowOnSendHRLoanDisbursementForApprovalCode);
          WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                    HRWFEvents.RunWorkflowOnCancelHRLoanDisbursementApprovalRequestCode);
          WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                    HRWFEvents.RunWorkflowOnCancelHRLoanDisbursementApprovalRequestCode);
   */        //HR Transport Request
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTransportRequestForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTransportRequestForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                  HRWFEvents.RunWorkflowOnSendHRTransportRequestForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRTransportRequestApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                  HRWFEvents.RunWorkflowOnCancelHRTransportRequestApprovalRequestCode);

        //------------------------------------End HR Management Response Predecessors------------------------------------------------------------------
    end;
}


codeunit 50039 "HR Workflow Events"
{

    trigger OnRun()
    begin
    end;

    var
        WFHandler: Codeunit 1520;
        WorkflowManagement: Codeunit 1501;
        HRJobApprovalRequest: Label 'Approval of a Human Resource Job is requested.';
        HRJobCancelApprovalRequest: Label 'An Approval request for a Human Resource Job is cancelled.';
        HREmployeeRequisitionApprovalRequest: Label 'Approval of an Employee Requisition document is requested.';
        HREmployeeRequisitionCancelApprovalRequest: Label 'An Approval request for an Employee Requisition document is cancelled.';
        HRJobApplicationApprovalRequest: Label 'Approval of a HR Job Application is requested.';
        HRJobApplicationCancelApprovalRequest: Label 'An Approval request for a HR Job Application is cancelled.';
        HREmployeeDetailUpdateApprovalRequest: Label 'Approval of an Employee Detail Update document is requested.';
        HREmployeeDetailUpdateCancelApprovalRequest: Label 'An Approval request for an Employee Detail Update document is cancelled.';
        HREmployeeAppraisalHeaderApprovalRequest: Label 'Approval of an Employee Appraisal document is requested.';
        HREmployeeAppraisalHeaderCancelApprovalRequest: Label 'An Approval request for an Employee Appraisal document is cancelled.';
        HRLeavePlannerHeaderApprovalRequest: Label 'Approval of a Leave Planner document is requested.';
        HRLeavePlannerHeaderCancelApprovalRequest: Label 'An Approval request for a Leave Planner document is cancelled.';
        HRLeaveApplicationApprovalRequest: Label 'Approval of a Leave Application document is requested.';
        HRLeaveApplicationCancelApprovalRequest: Label 'An Approval request for a Leave Application document is cancelled.';
        HRLeaveReimbusmentApprovalRequest: Label 'Approval of a Leave Reimbusment document is requested.';
        HRLeaveReimbusmentCancelApprovalRequest: Label 'An Approval request for a Leave Reimbusment document is cancelled.';
        HRLeaveCarryoverApprovalRequest: Label 'Approval of a Leave Carryover document is requested.';
        HRLeaveCarryoverCancelApprovalRequest: Label 'An Approval request for a Leave Carryover document is cancelled.';
        HRLeaveAllocationHeaderApprovalRequest: Label 'Approval of a Leave Allocation document is requested.';
        HRLeaveAllocationHeaderCancelApprovalRequest: Label 'An Approval request for a Leave Allocation document is cancelled.';
        HRAssetTransferApprovalRequest: Label 'Approval of a Asset Transfer document is requested.';
        HRAssetTransferCancelApprovalRequest: Label 'Approval of a Asset Transfer document is Cancelled.';
        HREmployeeTransferApprovalRequest: Label 'Approval of a Employee Transfer document is requested.';
        HREmployeeTransferCancelApprovalRequest: Label 'Approval of a Employee Transfer document is Cancelled.';
        HRExitInterviewApprovalRequest: Label 'Approval of a Exit Interview document is requested.';
        HRExitInterviewCancelApprovalRequest: Label 'Approval of a Exit Interview document is Cancelled.';
        HRTrainingApplicationApprovalRequest: Label 'Approval of a Training Application document is requested.';
        HRTrainingApplicationsCancelApprovalRequest: Label 'Approval of a Training Application document is Cancelled.';
        HRTrainingNeedsApplicationApprovalRequest: Label 'Approval of a Training Need Application document is requested.';
        HRTrainingNeedsApplicationsCancelApprovalRequest: Label 'Approval of a Training Need Application document is Cancelled.';
        HRTrainingGroupApplicationApprovalRequest: Label 'Approval of a Training Group Application document is requested.';
        HRTrainingGroupApplicationCancelApprovalRequest: Label 'Approval of a Training Group Application document is Cancelled.';
        HRTrainingEvaluationApplicationApprovalRequest: Label 'Approval of a Training Evaluation Application document is requested.';
        HRTrainingEvaluationApplicationCancelApprovalRequest: Label 'Approval of a Training Evaluation Application document is Cancelled.';
        LeaveAllowanceApprovalRequest: Label 'Approval of a Leave Allowance document is requested.';
        LeaveAllowanceCancelApprovalRequest: Label 'Approval of a Leave Allowance document is  Cancelled.';
        HRLoanApprovalRequest: Label 'Approval of a HR Loan Application document is requested.';
        HRLoanCancelApprovalRequest: Label 'Approval of a HR Loan Application document is  Cancelled.';
        HRLoanProductApprovalRequest: Label 'Approval of an HR Loan Product document is requested.';
        HRLoanProductCancelRequest: Label 'An Approval request for an HR Loan Product document is cancelled.';
        HRLoanDisbursementApprovalRequest: Label 'Approval of an HR Loan Disbursement document is requested.';
        HRLoanDisbursementCancelRequest: Label 'An Approval request for an HR Loan Disbursement document is cancelled.';
        InterviewHeaderApprovalRequest: Label 'Approval of an Interview Header document is requested.';
        InterviewHeaderCancelRequest: Label 'An Approval request for an Interview Header document is cancelled.';
        TransportApprovalRequestTxt: Label 'Approval of a Transport document is requested.';
        TransportApprovalCancelRequestTxt: Label 'An Approval request for Transport document is cancelled.';

    procedure AddEventsToLibrary()
    begin
        //---------------------------------------------HR Management Approval Events--------------------------------------------------------------
        //HR Job
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRJobForApprovalCode,
                                    DATABASE::"HR Jobs", HRJobApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRJobApprovalRequestCode,
                                    DATABASE::"HR Jobs", HRJobCancelApprovalRequest, 0, FALSE);
        //HR Employee Requisition
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHREmployeeRequisitionForApprovalCode,
                                    DATABASE::"HR Employee Requisitions", HREmployeeRequisitionApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHREmployeeRequisitionApprovalRequestCode,
                                    DATABASE::"HR Employee Requisitions", HREmployeeRequisitionCancelApprovalRequest, 0, FALSE);
        //HR Job Application
        /*    WFHandler.AddEventToLibrary(RunWorkflowOnSendHRJobApplicationForApprovalCode,
                                       DATABASE::"HR Job Applications", HRJobApplicationApprovalRequest, 0, FALSE);
           WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRJobApplicationApprovalRequestCode,
                                       DATABASE::"HR Job Applications", HRJobApplicationCancelApprovalRequest, 0, FALSE);
        */    //HR Employee Detail Update
              /*    WFHandler.AddEventToLibrary(RunWorkflowOnSendHREmployeeDetailUpdateForApprovalCode,
                                             DATABASE::"HR Employee Detail Update", HREmployeeDetailUpdateApprovalRequest, 0, FALSE);
                 WFHandler.AddEventToLibrary(RunWorkflowOnCancelHREmployeeDetailUpdateApprovalRequestCode,
                                             DATABASE::"HR Employee Detail Update", HREmployeeDetailUpdateCancelApprovalRequest, 0, FALSE);
          */        //HR Employee Appraisal Header
                    //HR Leave Planner Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode,
                                    DATABASE::"HR Leave Planner Header", HRLeavePlannerHeaderApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRLeavePlannerHeaderApprovalRequestCode,
                                    DATABASE::"HR Leave Planner Header", HRLeavePlannerHeaderCancelApprovalRequest, 0, FALSE);
        //HR Leave Application
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRLeaveApplicationForApprovalCode,
                                    DATABASE::"HR Leave Application", HRLeaveApplicationApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRLeaveApplicationApprovalRequestCode,
                                    DATABASE::"HR Leave Application", HRLeaveApplicationCancelApprovalRequest, 0, FALSE);
        //HR Leave Reimbusment
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode,
                                    DATABASE::"HR Leave Reimbursement", HRLeaveReimbusmentApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRLeaveReimbusmentApprovalRequestCode,
                                    DATABASE::"HR Leave Reimbursement", HRLeaveReimbusmentCancelApprovalRequest, 0, FALSE);
        //HR Leave Carryover
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRLeaveCarryoverForApprovalCode,
                                    DATABASE::"HR Leave Carryover", HRLeaveCarryoverApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRLeaveCarryoverApprovalRequestCode,
                                    DATABASE::"HR Leave Carryover", HRLeaveCarryoverCancelApprovalRequest, 0, FALSE);
        //HR Leave Allocation Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode,
                                    DATABASE::"HR Leave Allocation Header", HRLeaveAllocationHeaderApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRLeaveAllocationHeaderApprovalRequestCode,
                                    DATABASE::"HR Leave Allocation Header", HRLeaveAllocationHeaderCancelApprovalRequest, 0, FALSE);
        //HR Asset Transfer
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRAssetTransferHeaderForApprovalCode,
                                    DATABASE::"HR Asset Transfer Header", HRAssetTransferApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRAssetTransferHeaderApprovalRequestCode,
                                    DATABASE::"HR Asset Transfer Header", HRAssetTransferCancelApprovalRequest, 0, FALSE);
        //HR Employee Transfer
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHREmployeeTransferHeaderForApprovalCode,
                                    DATABASE::"HR Employee Transfer Header", HREmployeeTransferApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHREmployeeTransferHeaderApprovalRequestCode,
                                    DATABASE::"HR Employee Transfer Header", HREmployeeTransferCancelApprovalRequest, 0, FALSE);

        //HR Exit Interview
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode,
                                    DATABASE::"HR Employee Exit Interviews", HRExitInterviewApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRLeaveAllocationHeaderApprovalRequestCode,
                                    DATABASE::"HR Employee Exit Interviews", HRExitInterviewCancelApprovalRequest, 0, FALSE);

        //HR Training Application
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRTrainingHeaderForApprovalCode,
                                    DATABASE::"HR Training Applications", HRTrainingApplicationApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRTrainingHeaderApprovalRequestCode,
                                    DATABASE::"HR Training Applications", HRTrainingApplicationsCancelApprovalRequest, 0, FALSE);

        //HR Training Needs Application
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode,
                                    DATABASE::"HR Training Needs Header", HRTrainingNeedsApplicationApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRTrainingNeedsHeaderApprovalRequestCode,
                                    DATABASE::"HR Training Needs Header", HRTrainingNeedsApplicationsCancelApprovalRequest, 0, FALSE);


        //HR Training Group Application
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRTrainingGroupForApprovalCode,
                                    DATABASE::"HR Training Group", HRTrainingGroupApplicationApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRTrainingGroupApprovalRequestCode,
                                    DATABASE::"HR Training Group", HRTrainingGroupApplicationCancelApprovalRequest, 0, FALSE);

        //HR Training Evaluation
        WFHandler.AddEventToLibrary(RunWorkflowOnSendTrainingEvaluationForApprovalCode,
                                    DATABASE::"Training Evaluation", HRTrainingEvaluationApplicationApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelTrainingEvaluationApprovalRequestCode,
                                    DATABASE::"Training Evaluation", HRTrainingEvaluationApplicationCancelApprovalRequest, 0, FALSE);


        /* //HR Leave Allowance
        WFHandler.AddEventToLibrary(RunWorkflowOnSendLeaveAllowanceForApprovalCode,
                                    DATABASE::"Leave Allowance Request", LeaveAllowanceApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelLeaveAllowanceApprovalRequestCode,
                                    DATABASE::"Leave Allowance Request", LeaveAllowanceCancelApprovalRequest, 0, FALSE);

        //HR Loan Application
        WFHandler.AddEventToLibrary(RunWorkflowOnSendHRLoanForApprovalCode,
                                    DATABASE::"Employee Loan Applications", HRLoanApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRLoanApprovalRequestCode,
                                    DATABASE::"Employee Loan Applications", HRLoanCancelApprovalRequest, 0, FALSE);
 */
        /*      //HR Loan Product
              WFHandler.AddEventToLibrary(RunWorkflowOnSendHRLoanProductForApprovalCode,
                                          DATABASE::"Employee Loan Products",HRLoanProductApprovalRequest,0,FALSE);
              WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRLoanProductApprovalRequestCode,
                                          DATABASE::"Employee Loan Products",HRLoanProductCancelRequest,0,FALSE);
     */
        /*  //HR Loan Disbursement
          WFHandler.AddEventToLibrary(RunWorkflowOnSendHRLoanDisbursementForApprovalCode,
                                      DATABASE::"Employee Loan Disbursement",HRLoanDisbursementApprovalRequest,0,FALSE);
          WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRLoanDisbursementApprovalRequestCode,
                                      DATABASE::"Employee Loan Disbursement",HRLoanDisbursementCancelRequest,0,FALSE);
    */  /*    //HR Tranport Request
          WFHandler.AddEventToLibrary(RunWorkflowOnSendHRTransportRequestForApprovalCode,
                                      DATABASE::"Transport Request",TransportApprovalRequestTxt,0,FALSE);
          WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRTransportRequestApprovalRequestCode,
                                      DATABASE::"Transport Request",TransportApprovalCancelRequestTxt,0,FALSE);
 */
        //HR Interview Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendInterviewHeaderForApprovalCode,
                                    DATABASE::"Interview Attendance Header", InterviewHeaderApprovalRequest, 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelInterviewHeaderApprovalRequestCode,
                                    DATABASE::"Interview Attendance Header", InterviewHeaderCancelRequest, 0, FALSE);
        /*   //Transport Request
            WFHandler.AddEventToLibrary(RunWorkflowOnSendHRTransportRequestForApprovalCode,
                                        DATABASE::"Transport Request",TransportApprovalRequestTxt,0,FALSE);
            WFHandler.AddEventToLibrary(RunWorkflowOnCancelHRTransportRequestApprovalRequestCode,
                                        DATABASE::"Transport Request",TransportApprovalCancelRequestTxt,0,FALSE);
   */
        //-----------------------------------------End HR Management Approval Events--------------------------------------------------------------
    end;

    procedure AddEventsPredecessor()
    begin
        //-----------------------------------HR Management Approval,Rejection,Delegation Predecessors---------------------------------------------
        //HR Job
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRJobForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRJobForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRJobForApprovalCode);

        //HR Employee Requisition
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHREmployeeRequisitionForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHREmployeeRequisitionForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHREmployeeRequisitionForApprovalCode);

        //HR Job Application
        /*      WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRJobApplicationForApprovalCode);
             WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRJobApplicationForApprovalCode);
             WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRJobApplicationForApprovalCode);
      */
        //HR Employee Detail Update
        /*   WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHREmployeeDetailUpdateForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHREmployeeDetailUpdateForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHREmployeeDetailUpdateForApprovalCode);
   */
        //HR Employee Appraisal Header
        /*   WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHREmployeeAppraisalHeaderForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHREmployeeAppraisalHeaderForApprovalCode);
          WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHREmployeeAppraisalHeaderForApprovalCode);
   */
        //HR Leave Planner Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode);

        //HR Leave Application
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRLeaveApplicationForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRLeaveApplicationForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRLeaveApplicationForApprovalCode);

        //HR Leave Reimbusment
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode);

        //HR Leave Carryover
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRLeaveCarryoverForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRLeaveCarryoverForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRLeaveCarryoverForApprovalCode);

        //HR Leave Allocation Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode);

        //HR Asset Transfer
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRAssetTransferHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRAssetTransferHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRAssetTransferHeaderForApprovalCode);

        //HR EmployeeTransfer
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHREmployeeTransferHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHREmployeeTransferHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHREmployeeTransferHeaderForApprovalCode);

        //HR Exit Interview
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRExitInterviewHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRExitInterviewHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRExitInterviewHeaderForApprovalCode);

        //HR Training Application
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRTrainingHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRTrainingHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRTrainingHeaderForApprovalCode);

        //HR Training Needs Application
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode);

        //HR Training Group Application
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRTrainingGroupForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRTrainingGroupForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRTrainingGroupForApprovalCode);

        //HR Leave Allowance
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendLeaveAllowanceForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendLeaveAllowanceForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendLeaveAllowanceForApprovalCode);

        //HR Loan application
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRLoanForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRLoanForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRLoanForApprovalCode);

        //HR Loan Product
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRLoanProductForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRLoanProductForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRLoanProductForApprovalCode);

        //HR Loan Disbursement
        /*     WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRLoanDisbursementForApprovalCode);
            WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRLoanDisbursementForApprovalCode);
            WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRLoanDisbursementForApprovalCode);
     */
        //HR Inteview Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendInterviewHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendInterviewHeaderForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendInterviewHeaderForApprovalCode);
        // HR Transport Request
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendHRTransportRequestForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendHRTransportRequestForApprovalCode);
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendHRTransportRequestForApprovalCode);

        //-----------------------------------End HR Management Approval,Rejection,Delegation Predecessors-----------------------------------------
    end;

    procedure RunWorkflowOnSendHRJobForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRJobForApproval'));
    end;

    procedure RunWorkflowOnCancelHRJobApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRJobApprovalRequest'));
    end;

    /*  [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRJobForApproval', '', false, false)]
     procedure RunWorkflowOnSendHRJobForApproval(var HRJob: Record 50046)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnSendHRJobForApprovalCode, HRJob);
     end;

     [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRJobApprovalRequest', '', false, false)]
     procedure RunWorkflowOnCancelHRJobApprovalRequest(var HRJob: Record 50046)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRJobApprovalRequestCode, HRJob);
     end; */

    procedure RunWorkflowOnSendHREmployeeRequisitionForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHREmployeeRequisitionForApproval'));
    end;

    procedure RunWorkflowOnCancelHREmployeeRequisitionApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHREmployeeRequisitionApprovalRequest'));
    end;
    /* 
        [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHREmployeeRequisitionForApproval', '', false, false)]
         procedure RunWorkflowOnSendHREmployeeRequisitionForApproval(var HREmployeeRequisition: Record 50051)
         begin
             WorkflowManagement.HandleEvent(RunWorkflowOnSendHREmployeeRequisitionForApprovalCode, HREmployeeRequisition);
         end; */

    /* [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHREmployeeRequisitionApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelHREmployeeRequisitionApprovalRequest(var HREmployeeRequisition: Record 50051)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelHREmployeeRequisitionApprovalRequestCode, HREmployeeRequisition);
    end; 

    procedure RunWorkflowOnSendHRJobApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRJobApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelHRJobApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRJobApplicationApprovalRequest'));
    end;
*/

    /* [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRJobApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRJobApplicationForApproval(var HRJobApplication: Record 50052)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRJobApplicationForApprovalCode, HRJobApplication);
    end; */

    /*  [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRJobApplicationApprovalRequest', '', false, false)]
        procedure RunWorkflowOnCancelHRJobApplicationApprovalRequest(var HRJobApplication: Record 50052)
        begin
            WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRJobApplicationApprovalRequestCode, HRJobApplication);
        end;  */

    /*  procedure RunWorkflowOnSendHREmployeeDetailUpdateForApprovalCode(): Code[128]
     begin
         EXIT(UPPERCASE('RunWorkflowOnSendHREmployeeDetailUpdateForApproval'));
     end; */
    /* 
        procedure RunWorkflowOnCancelHREmployeeDetailUpdateApprovalRequestCode(): Code[128]
        begin
            EXIT(UPPERCASE('RunWorkflowOnCancelHREmployeeDetailUpdateApprovalRequest'));
        end; */
    /*  

        /* [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHREmployeeDetailUpdateApprovalRequest', '', false, false)]
        procedure RunWorkflowOnCancelHREmployeeDetailUpdateApprovalRequest(var HREmployeeDetailUpdate: Record 50116)
        begin
            WorkflowManagement.HandleEvent(RunWorkflowOnCancelHREmployeeDetailUpdateApprovalRequestCode, HREmployeeDetailUpdate);
        end;
     */






    procedure RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRLeavePlannerHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelHRLeavePlannerHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRLeavePlannerHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRLeavePlannerHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRLeavePlannerHeaderForApproval(var HRLeavePlannerHeader: Record 50125)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRLeavePlannerHeaderForApprovalCode, HRLeavePlannerHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRLeavePlannerHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelHRLeavePlannerHeaderApprovalRequest(var HRLeavePlannerHeader: Record 50125)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRLeavePlannerHeaderApprovalRequestCode, HRLeavePlannerHeader);
    end;

    procedure RunWorkflowOnSendHRLeaveApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRLeaveApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelHRLeaveApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRLeaveApplicationApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRLeaveApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRLeaveApplicationForApproval(var HRLeaveApplication: Record 50127)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRLeaveApplicationForApprovalCode, HRLeaveApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRLeaveApplicationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelHRLeaveApplicationApprovalRequest(var HRLeaveApplication: Record 50127)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRLeaveApplicationApprovalRequestCode, HRLeaveApplication);
    end;

    procedure RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRLeaveReimbusmentForApproval'));
    end;

    procedure RunWorkflowOnCancelHRLeaveReimbusmentApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRLeaveReimbusmentApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRLeaveReimbusmentForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRLeaveReimbusmentForApproval(var HRLeaveReimbusment: Record 50128)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRLeaveReimbusmentForApprovalCode, HRLeaveReimbusment);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRLeaveReimbusmentApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelHRLeaveReimbusmentApprovalRequest(var HRLeaveReimbusment: Record 50128)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRLeaveReimbusmentApprovalRequestCode, HRLeaveReimbusment);
    end;

    procedure RunWorkflowOnSendHRLeaveCarryoverForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRLeaveCarryoverForApproval'));
    end;

    procedure RunWorkflowOnCancelHRLeaveCarryoverApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRLeaveCarryoverApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRLeaveCarryoverForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRLeaveCarryoverForApproval(var HRLeaveCarryover: Record 50129)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRLeaveCarryoverForApprovalCode, HRLeaveCarryover);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRLeaveCarryoverApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelHRLeaveCarryoverApprovalRequest(var HRLeaveCarryover: Record 50129)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRLeaveCarryoverApprovalRequestCode, HRLeaveCarryover);
    end;

    procedure RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRLeaveAllocationHeaderForApproval'));
    end;


    procedure RunWorkflowOnCancelHRLeaveAllocationHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRLeaveAllocationHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRLeaveAllocationHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRLeaveAllocationHeaderForApproval(var HRLeaveAllocationHeader: Record 50130)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRLeaveAllocationHeaderForApprovalCode, HRLeaveAllocationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRLeaveAllocationHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelHRLeaveAllocationHeaderApprovalRequest(var HRLeaveAllocationHeader: Record 50130)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRLeaveAllocationHeaderApprovalRequestCode, HRLeaveAllocationHeader);
    end;

    procedure RunWorkflowOnSendHRAssetTransferHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRAssetTransferHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelHRAssetTransferHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRAssetTransferHeaderApprovalRequest'));
    end;

    /*  [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRAssetTransferHeaderForApproval', '', false, false)]
     procedure RunWorkflowOnSendHRAssetTransferHeaderForApproval(var AssetTransferHeader: Record 50150)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnSendHRAssetTransferHeaderForApprovalCode, AssetTransferHeader);
     end;

     [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRAssetTransferHeaderApprovalRequest', '', false, false)]
     procedure RunWorkflowOnCancelHRAssetTransferHeaderApprovalRequest(var AssetransferHeader: Record 50150)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRAssetTransferHeaderApprovalRequestCode, AssetransferHeader);
     end; */

    procedure RunWorkflowOnSendHREmployeeTransferHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHREmployeeTransferHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelHREmployeeTransferHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHREmployeeTransferHeaderApprovalRequest'));
    end;

    /*  [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHREmployeeTransferHeaderForApproval', '', false, false)]
     procedure RunWorkflowOnSendHREmployeeTransferHeaderForApproval(var EmployeeTransferHeader: Record 50148)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnSendHREmployeeTransferHeaderForApprovalCode, EmployeeTransferHeader);
     end; */

    /* [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHREmployeeTransferHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelHREmployeeTransferHeaderApprovalRequest(var EmployeeTransferHeader: Record 50148)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelHREmployeeTransferHeaderApprovalRequestCode, EmployeeTransferHeader);
    end; */

    procedure RunWorkflowOnSendHRExitInterviewHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRExitInterviewHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelHRExitInterviewHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRExitInterviewHeaderApprovalRequest'));
    end;

    /* [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRExitInterviewHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRExitInterviewHeaderForApproval(var ExitInterviewHeader: Record 50153)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRExitInterviewHeaderForApprovalCode, ExitInterviewHeader);
    end;
 */
    /*   [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRExitInterviewHeaderApprovalRequest', '', false, false)]
      procedure RunWorkflowOnCancelHRExitInterviewHeaderApprovalRequest(var ExitInterviewHeader: Record 50153)
      begin
          WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRExitInterviewHeaderApprovalRequestCode, ExitInterviewHeader);
      end; */

    procedure RunWorkflowOnSendHRTrainingHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRTrainingHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelHRTrainingHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRTrainingHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRTrainingApplicationsHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRTrainingHeaderForApproval(var HRTrainingApplications: Record 50164)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRTrainingHeaderForApprovalCode, HRTrainingApplications);
    end;

    /*  [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRTrainingHeaderApprovalRequest', '', false, false)]
     procedure RunWorkflowOnCancelHRTrainingHeaderApprovalRequest(var HRTrainingApplications: Record 50164)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRTrainingHeaderApprovalRequestCode, HRTrainingApplications);
     end; */

    procedure RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRTrainingNeedsHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelHRTrainingNeedsHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRTrainingNeedsHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRTrainingNeedsHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRTrainingNeedsHeaderForApproval(var HRTrainingNeedsHeader: Record 50157)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRTrainingNeedsHeaderForApprovalCode, HRTrainingNeedsHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRTrainingNeedsHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelHRTrainingNeedsHeaderApprovalRequest(var HRTrainingNeedsHeader: Record 50157)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRTrainingNeedsHeaderApprovalRequestCode, HRTrainingNeedsHeader);
    end;

    procedure RunWorkflowOnCancelTrainingEvaluationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRTrainingEvaluationHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendTrainingEvaluationForApproval', '', false, false)]
    procedure RunWorkflowOnSendTrainingEvaluationForApproval(var TrainingEvaluation: Record 50161)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendTrainingEvaluationForApprovalCode, TrainingEvaluation);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelTrainingEvaluationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelTrainingEvaluationApprovalRequest(var TrainingEvaluation: Record 50161)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelTrainingEvaluationApprovalRequestCode, TrainingEvaluation);
    end;

    procedure RunWorkflowOnSendTrainingEvaluationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRTrainingEvaluationForApproval'));
    end;

    procedure RunWorkflowOnSendHRTrainingGroupForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRTrainingGroupForApproval'));
    end;

    procedure RunWorkflowOnCancelHRTrainingGroupApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRTrainingGroupApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRTrainingGroupForApproval', '', false, false)]
    procedure RunWorkflowOnSendHRTrainingGroupForApproval(var HRTrainingGroup: Record 50162)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendHRTrainingGroupForApprovalCode, HRTrainingGroup);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRTrainingGroupApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelHRTrainingGroupApprovalRequest(var HRTrainingGroup: Record 50162)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRTrainingGroupApprovalRequestCode, HRTrainingGroup);
    end;

    procedure RunWorkflowOnSendLeaveAllowanceForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendLeaveAllowanceForApproval'));
    end;

    procedure RunWorkflowOnCancelLeaveAllowanceApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelSendLeaveAllowanceApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendLeaveAllowanceForApproval', '', false, false)]
    procedure RunWorkflowOnSendLeaveAllowanceForApproval(var LeaveAllowanceRequest: Record 50207)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendLeaveAllowanceForApprovalCode, LeaveAllowanceRequest);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelLeaveAllowanceApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelLeaveAllowanceApprovalRequest(var LeaveAllowanceRequest: Record 50207)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelLeaveAllowanceApprovalRequestCode, LeaveAllowanceRequest);
    end;

    procedure RunWorkflowOnSendHRLoanForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRLoanForApproval'));
    end;

    procedure RunWorkflowOnCancelHRLoanApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRLoanApprovalRequest'));
    end;

    /*  [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRLoanForApproval', '', false, false)]
     procedure RunWorkflowOnSendHRLoanForApproval(var EmployeeLoanApplications: Record 50074)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnSendHRLoanForApprovalCode, EmployeeLoanApplications);
     end;

     [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRLoanApprovalRequest', '', false, false)]
     procedure RunWorkflowOnCancelHRLoanApprovalRequest(var EmployeeLoanApplications: Record 50074)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRLoanApprovalRequestCode, EmployeeLoanApplications);
     end; */

    procedure RunWorkflowOnSendHRLoanProductForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRLoanProductForApproval'));
    end;

    procedure RunWorkflowOnCancelHRLoanProductApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRLoanProductApprovalRequest'));
    end;

    /*   [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRLoanProductForApproval', '', false, false)]
      procedure RunWorkflowOnSendHRLoanProductForApproval(var HRLoanProducts: Record 50082)
      begin
          WorkflowManagement.HandleEvent(RunWorkflowOnSendHRLoanProductForApprovalCode, HRLoanProducts);
      end;

      [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRLoanProductApprovalRequest', '', false, false)]
      procedure RunWorkflowOnCancelHRLoanProductApprovalRequest(var HRLoanProducts: Record 50082)
      begin
          WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRLoanProductApprovalRequestCode, HRLoanProducts);
      end;

      procedure RunWorkflowOnSendHRLoanDisbursementForApprovalCode(): Code[128]
      begin
          EXIT(UPPERCASE('RunWorkflowOnSendHRLoanDisbursementForApproval'));
      end;

      procedure RunWorkflowOnCancelHRLoanDisbursementApprovalRequestCode(): Code[128]
      begin
          EXIT(UPPERCASE('RunWorkflowOnCancelHRLoanDisbursementApprovalRequest'));
      end; */

    /*  [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendHRLoanDisbursementForApproval', '', false, false)]
     procedure RunWorkflowOnSendHRLoanDisbursementForApproval(var EmployeeLoanDisbursement: Record 50076)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnSendHRLoanDisbursementForApprovalCode, EmployeeLoanDisbursement);
     end;

     [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelHRLoanDisbursementApprovalRequest', '', false, false)]
     procedure RunWorkflowOnCancelHRLoanDisbursementApprovalRequest(var EmployeeLoanDisbursement: Record 50076)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRLoanDisbursementApprovalRequestCode, EmployeeLoanDisbursement);
     end; */

    procedure RunWorkflowOnSendInterviewHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendInterviewHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelInterviewHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelInterviewHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendInterviewHeaderAttendanceForApproval', '', false, false)]
    procedure "`"(var InterviewAttendanceHeader: Record 50108)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendInterviewHeaderForApprovalCode, InterviewAttendanceHeader);
    end;

    /*  [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelInterviewHeaderApprovalRequest', '', false, false)]
     procedure RunWorkflowOnCancelInterviewHeaderApprovalRequest(var InterviewAttendanceHeader: Record 50108)
     begin
         WorkflowManagement.HandleEvent(RunWorkflowOnCancelInterviewHeaderApprovalRequestCode, InterviewAttendanceHeader);
     end; */

    procedure RunWorkflowOnSendHRTransportRequestForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendHRTransportRequestForApproval'));
    end;

    procedure RunWorkflowOnCancelHRTransportRequestApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelHRTransportRequestApprovalRequest'));
    end;

    /*   [EventSubscriber(ObjectType::Codeunit, 50082, 'OnSendTransportRequestForApproval', '', false, false)]
      procedure RunWorkflowOnSendHRTransportRequestForApproval(var TransportRequest: Record 50210)
      begin
          WorkflowManagement.HandleEvent(RunWorkflowOnSendHRTransportRequestForApprovalCode, TransportRequest);
      end;

      [EventSubscriber(ObjectType::Codeunit, 50082, 'OnCancelTransportRequestApprovalRequest', '', false, false)]
      procedure RunWorkflowOnCancelHRTransportRequestApprovalRequest(var TransportRequest: Record 50210)
      begin
          WorkflowManagement.HandleEvent(RunWorkflowOnCancelHRTransportRequestApprovalRequestCode, TransportRequest);
      end; */
}


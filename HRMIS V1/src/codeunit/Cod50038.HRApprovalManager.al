codeunit 50038 "HR Approval Manager"
{

    trigger OnRun()
    begin
    end;

    procedure ReleaseHRJob(var "HR Job": Record 50093)
    var
        HRJob: Record 50093;
        JobSuccessfullyCreated: Label 'Job position has succesfully been approved.';
    begin
        HRJob.RESET;
        HRJob.SETRANGE(HRJob."No.", "HR Job"."No.");
        IF HRJob.FINDFIRST THEN BEGIN
            HRJob.Status := HRJob.Status::Released;
            HRJob.VALIDATE(HRJob.Status);
            HRJob.Active := TRUE;
            HRJob.MODIFY;
            MESSAGE(JobSuccessfullyCreated);
        END;
    end;

    procedure ReOpenHRJob(var "HR Job": Record 50093)
    var
        HRJob: Record 50093;
    begin
        HRJob.RESET;
        HRJob.SETRANGE(HRJob."No.", "HR Job"."No.");
        IF HRJob.FINDFIRST THEN BEGIN
            HRJob.Status := HRJob.Status::Open;
            HRJob.VALIDATE(HRJob.Status);
            "HR Job".Active := FALSE;
            HRJob.MODIFY;
        END;
    end;

    procedure ReleaseHREmployeeRequisition(var "HR Employee Requisition": Record 50098)
    var
        HREmployeeRequisition: Record 50098;
        EmployeeRequisitionApproved: Label 'Employee Requisition has sucessfully been Approved';
    begin
        HREmployeeRequisition.RESET;
        HREmployeeRequisition.SETRANGE(HREmployeeRequisition."No.", "HR Employee Requisition"."No.");
        IF HREmployeeRequisition.FINDFIRST THEN BEGIN
            HREmployeeRequisition.Status := HREmployeeRequisition.Status::Released;
            HREmployeeRequisition.VALIDATE(HREmployeeRequisition.Status);
            HREmployeeRequisition.MODIFY;
            MESSAGE(EmployeeRequisitionApproved);
        END;
    end;

    procedure ReOpenHREmployeeRequisition(var "HR Employee Requisition": Record 50098)
    var
        HREmployeeRequisition: Record 50098;
    begin
        HREmployeeRequisition.RESET;
        HREmployeeRequisition.SETRANGE(HREmployeeRequisition."No.", "HR Employee Requisition"."No.");
        IF HREmployeeRequisition.FINDFIRST THEN BEGIN
            HREmployeeRequisition.Status := HREmployeeRequisition.Status::Open;
            HREmployeeRequisition.VALIDATE(HREmployeeRequisition.Status);
            HREmployeeRequisition.MODIFY;
        END;
    end;

    procedure ReleaseHRJobApplication(var "HR Job Application": Record 50099)
    var
        HRJobApplication: Record 50099;
        JobApplicationApproved: Label 'Job Application has sucessfully been Approved';
    begin
        HRJobApplication.RESET;
        HRJobApplication.SETRANGE(HRJobApplication."No.", "HR Job Application"."No.");
        IF HRJobApplication.FINDFIRST THEN BEGIN
            HRJobApplication.Status := HRJobApplication.Status::Approved;
            HRJobApplication.VALIDATE(HRJobApplication.Status);
            HRJobApplication.MODIFY;
            MESSAGE(JobApplicationApproved);
        END;
    end;

    procedure ReOpenHRJobApplication(var "HR Job Application": Record 50099)
    var
        HRJobApplication: Record 50099;
    begin
        HRJobApplication.RESET;
        HRJobApplication.SETRANGE(HRJobApplication."No.", "HR Job Application"."No.");
        IF HRJobApplication.FINDFIRST THEN BEGIN
            HRJobApplication.Status := HRJobApplication.Status::Open;
            HRJobApplication.VALIDATE(HRJobApplication.Status);
            HRJobApplication.MODIFY;
        END;
    end;

    procedure ReleaseHREmployeeAppraisalHeader(var "HR Employee Appraisal Header": Record 50138)
    var
        HREmployeeAppraisalHeader: Record 50138;
        AppraisalApprovalMessage: Label 'Appraisal Card has sucessfully been approved';
    begin
        HREmployeeAppraisalHeader.RESET;
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."No.", "HR Employee Appraisal Header"."No.");
        IF HREmployeeAppraisalHeader.FINDFIRST THEN BEGIN
            HREmployeeAppraisalHeader.Status := HREmployeeAppraisalHeader.Status::Released;
            HREmployeeAppraisalHeader.VALIDATE(HREmployeeAppraisalHeader.Status);
            HREmployeeAppraisalHeader.MODIFY;
            MESSAGE(AppraisalApprovalMessage);
        END;
    end;

    procedure ReOpenHREmployeeAppraisalHeader(var "HR Employee Appraisal Header": Record 50138)
    var
        HREmployeeAppraisalHeader: Record 50138;
    begin
        HREmployeeAppraisalHeader.RESET;
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."No.", "HR Employee Appraisal Header"."No.");
        IF HREmployeeAppraisalHeader.FINDFIRST THEN BEGIN
            HREmployeeAppraisalHeader.Status := HREmployeeAppraisalHeader.Status::Open;
            HREmployeeAppraisalHeader.VALIDATE(HREmployeeAppraisalHeader.Status);
            HREmployeeAppraisalHeader.MODIFY;
        END;
    end;

    procedure ReleaseHRLeavePlannerHeader(var "HR Leave Planner Header": Record 50125)
    var
        HRLeavePlannerHeader: Record 50125;
        LeavePlannerApprovalMessage: Label 'Leave Planner has successfully been Approved';
    begin
        HRLeavePlannerHeader.RESET;
        HRLeavePlannerHeader.SETRANGE(HRLeavePlannerHeader."No.", "HR Leave Planner Header"."No.");
        IF HRLeavePlannerHeader.FINDFIRST THEN BEGIN
            HRLeavePlannerHeader.Status := HRLeavePlannerHeader.Status::Released;
            HRLeavePlannerHeader.VALIDATE(HRLeavePlannerHeader.Status);
            HRLeavePlannerHeader.MODIFY;
            MESSAGE(LeavePlannerApprovalMessage);
        END;
    end;

    procedure ReOpenHRLeavePlannerHeader(var "HR Leave Planner Header": Record 50125)
    var
        HRLeavePlannerHeader: Record 50125;
    begin
        HRLeavePlannerHeader.RESET;
        HRLeavePlannerHeader.SETRANGE(HRLeavePlannerHeader."No.", "HR Leave Planner Header"."No.");
        IF HRLeavePlannerHeader.FINDFIRST THEN BEGIN
            HRLeavePlannerHeader.Status := HRLeavePlannerHeader.Status::Open;
            HRLeavePlannerHeader.VALIDATE(HRLeavePlannerHeader.Status);
            HRLeavePlannerHeader.MODIFY;
        END;
    end;

    procedure ReleaseHRLeaveApplication(var "HR Leave Application": Record 50127)
    var
        HRLeaveApplication: Record 50127;
        LeaveApplicationMessage: Label 'Leave Application has sucessfully been Approved';
    begin
        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."No.", "HR Leave Application"."No.");
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            HRLeaveApplication.Status := HRLeaveApplication.Status::Released;
            HRLeaveApplication.VALIDATE(HRLeaveApplication.Status);
            HRLeaveApplication.MODIFY;
            MESSAGE(LeaveApplicationMessage);
        END;
    end;

    procedure ReOpenHRLeaveApplication(var "HR Leave Application": Record 50127)
    var
        HRLeaveApplication: Record 50127;
    begin
        HRLeaveApplication.RESET;
        HRLeaveApplication.SETRANGE(HRLeaveApplication."No.", "HR Leave Application"."No.");
        IF HRLeaveApplication.FINDFIRST THEN BEGIN
            HRLeaveApplication.Status := HRLeaveApplication.Status::Open;
            HRLeaveApplication.VALIDATE(HRLeaveApplication.Status);
            HRLeaveApplication.MODIFY;
        END;
    end;

    procedure ReleaseHRLeaveReimbusment(var "HR Leave Reimbusment": Record 50128)
    var
        HRLeaveReimbusment: Record 50128;
        LeaveReimbursementMessage: Label 'Leave Reimbursement has sucessfully been approved';
    begin
        HRLeaveReimbusment.RESET;
        HRLeaveReimbusment.SETRANGE(HRLeaveReimbusment."No.", "HR Leave Reimbusment"."No.");
        IF HRLeaveReimbusment.FINDFIRST THEN BEGIN
            HRLeaveReimbusment.Status := HRLeaveReimbusment.Status::Released;
            HRLeaveReimbusment.VALIDATE(HRLeaveReimbusment.Status);
            HRLeaveReimbusment.MODIFY;
            MESSAGE(LeaveReimbursementMessage);
        END;
    end;

    procedure ReOpenHRLeaveReimbusment(var "HR Leave Reimbusment": Record 50128)
    var
        HRLeaveReimbusment: Record 50128;
    begin
        HRLeaveReimbusment.RESET;
        HRLeaveReimbusment.SETRANGE(HRLeaveReimbusment."No.", "HR Leave Reimbusment"."No.");
        IF HRLeaveReimbusment.FINDFIRST THEN BEGIN
            HRLeaveReimbusment.Status := HRLeaveReimbusment.Status::Open;
            HRLeaveReimbusment.VALIDATE(HRLeaveReimbusment.Status);
            HRLeaveReimbusment.MODIFY;
        END;
    end;

    procedure ReleaseHRLeaveCarryover(var "HR Leave Carryover": Record 50129)
    var
        HRLeaveCarryover: Record 50129;
        LeaveCarryoverMessage: Label 'Leave Carryover has sucessfully been approved';
    begin
        HRLeaveCarryover.RESET;
        HRLeaveCarryover.SETRANGE(HRLeaveCarryover."No.", "HR Leave Carryover"."No.");
        IF HRLeaveCarryover.FINDFIRST THEN BEGIN
            HRLeaveCarryover.Status := HRLeaveCarryover.Status::Released;
            HRLeaveCarryover.VALIDATE(HRLeaveCarryover.Status);
            HRLeaveCarryover.MODIFY;
            MESSAGE(LeaveCarryoverMessage);
        END;
    end;

    procedure ReOpenHRLeaveCarryover(var "HR Leave Carryover": Record 50129)
    var
        HRLeaveCarryover: Record 50129;
    begin
        HRLeaveCarryover.RESET;
        HRLeaveCarryover.SETRANGE(HRLeaveCarryover."No.", "HR Leave Carryover"."No.");
        IF HRLeaveCarryover.FINDFIRST THEN BEGIN
            HRLeaveCarryover.Status := HRLeaveCarryover.Status::Open;
            HRLeaveCarryover.VALIDATE(HRLeaveCarryover.Status);
            HRLeaveCarryover.MODIFY;
        END;
    end;

    procedure ReleaseHRLeaveAllocationHeader(var "HR Leave Allocation Header": Record 50130)
    var
        HRLeaveAllocationHeader: Record 50130;
        LeaveAllocationMessage: Label 'Leave Allocation has successfully been approved.';
    begin
        HRLeaveAllocationHeader.RESET;
        HRLeaveAllocationHeader.SETRANGE(HRLeaveAllocationHeader."No.", "HR Leave Allocation Header"."No.");
        IF HRLeaveAllocationHeader.FINDFIRST THEN BEGIN
            HRLeaveAllocationHeader.Status := HRLeaveAllocationHeader.Status::Released;
            HRLeaveAllocationHeader.VALIDATE(HRLeaveAllocationHeader.Status);
            HRLeaveAllocationHeader.MODIFY;
            MESSAGE(LeaveAllocationMessage);
        END;
    end;

    procedure ReOpenHRLeaveAllocationHeader(var "HR Leave Allocation Header": Record 50130)
    var
        HRLeaveAllocationHeader: Record 50130;
    begin
        HRLeaveAllocationHeader.RESET;
        HRLeaveAllocationHeader.SETRANGE(HRLeaveAllocationHeader."No.", "HR Leave Allocation Header"."No.");
        IF HRLeaveAllocationHeader.FINDFIRST THEN BEGIN
            HRLeaveAllocationHeader.Status := HRLeaveAllocationHeader.Status::Open;
            HRLeaveAllocationHeader.VALIDATE(HRLeaveAllocationHeader.Status);
            HRLeaveAllocationHeader.MODIFY;
        END;
    end;

    procedure ReleaseHRAssetTransferHeader(var "HR Asset Transfer Header": Record 50150)
    var
        HRAssetTransferHeader: Record 50150;
        AssetTransferMessage: Label 'Employee Asset transfer has sucessfully been Approved';
    begin
        HRAssetTransferHeader.RESET;
        HRAssetTransferHeader.SETRANGE(HRAssetTransferHeader."No.", "HR Asset Transfer Header"."No.");
        IF HRAssetTransferHeader.FINDFIRST THEN BEGIN
            HRAssetTransferHeader.Status := HRAssetTransferHeader.Status::Approved;
            HRAssetTransferHeader.VALIDATE(HRAssetTransferHeader.Status);
            HRAssetTransferHeader.MODIFY;
            MESSAGE(AssetTransferMessage);
        END;
    end;

    procedure ReOpenHRAssetTransferHeader(var "HR Asset Transfer Header": Record 50150)
    var
        HRAssetTransferHeader: Record 50150;
    begin
        HRAssetTransferHeader.RESET;
        HRAssetTransferHeader.SETRANGE(HRAssetTransferHeader."No.", "HR Asset Transfer Header"."No.");
        IF HRAssetTransferHeader.FINDFIRST THEN BEGIN
            HRAssetTransferHeader.Status := HRAssetTransferHeader.Status::Open;
            HRAssetTransferHeader.VALIDATE(HRAssetTransferHeader.Status);
            HRAssetTransferHeader.MODIFY;
        END;
    end;

    procedure ReleaseHREmployeeTransferHeader(var "HR Employee Transfer Header": Record 50148)
    var
        HREmployeeTransferHeader: Record 50148;
    begin
        HREmployeeTransferHeader.RESET;
        HREmployeeTransferHeader.SETRANGE(HREmployeeTransferHeader."Request No", "HR Employee Transfer Header"."Request No");
        IF HREmployeeTransferHeader.FINDFIRST THEN BEGIN
            HREmployeeTransferHeader.Status := HREmployeeTransferHeader.Status::Approved;
            HREmployeeTransferHeader.VALIDATE(HREmployeeTransferHeader.Status);
            HREmployeeTransferHeader.MODIFY;
        END;
    end;

    procedure ReOpenHREmployeeTransferHeader(var "HR Employee Transfer Header": Record 50148)
    var
        HREmployeeTransferHeader: Record 50148;
    begin
        HREmployeeTransferHeader.RESET;
        HREmployeeTransferHeader.SETRANGE(HREmployeeTransferHeader."Request No", "HR Employee Transfer Header"."Request No");
        IF HREmployeeTransferHeader.FINDFIRST THEN BEGIN
            HREmployeeTransferHeader.Status := HREmployeeTransferHeader.Status::Open;
            HREmployeeTransferHeader.VALIDATE(HREmployeeTransferHeader.Status);
            HREmployeeTransferHeader.MODIFY;
        END;
    end;

    procedure ReleaseHRExitInterviewHeader(var "HR Exit Interview Header": Record 50152)
    var
        HRExitInterviewHeader: Record 50152;
        ExitInterviewMessage: Label 'Employee Exit Interview has sucessfully been Approved';
    begin
        HRExitInterviewHeader.RESET;
        HRExitInterviewHeader.SETRANGE(HRExitInterviewHeader."Exit Interview No", "HR Exit Interview Header"."Exit Interview No");
        IF HRExitInterviewHeader.FINDFIRST THEN BEGIN
            HRExitInterviewHeader.Status := HRExitInterviewHeader.Status::Approved;
            HRExitInterviewHeader.VALIDATE(HRExitInterviewHeader.Status);
            HRExitInterviewHeader.MODIFY;
            MESSAGE(ExitInterviewMessage);
        END;
    end;

    procedure ReOpenHRExitInterviewHeader(var "HR Exit Interview Header": Record 50152)
    var
        HRExitInterviewHeader: Record 50152;
    begin
        HRExitInterviewHeader.RESET;
        HRExitInterviewHeader.SETRANGE(HRExitInterviewHeader."Exit Interview No", "HR Exit Interview Header"."Exit Interview No");
        IF HRExitInterviewHeader.FINDFIRST THEN BEGIN
            HRExitInterviewHeader.Status := HRExitInterviewHeader.Status::Open;
            HRExitInterviewHeader.VALIDATE(HRExitInterviewHeader.Status);
            HRExitInterviewHeader.MODIFY;
        END;
    end;

    procedure ReleaseHRTrainingHeader(var HRTrainingApplications: Record 50164)
    var
        TrainingApplications: Record 50164;
        HRTrainingApplicationMessage: Label 'Employee Training Application has sucessfully been approved';
    begin
        TrainingApplications.RESET;
        TrainingApplications.SETRANGE(TrainingApplications."Application No.", HRTrainingApplications."Application No.");
        IF TrainingApplications.FINDFIRST THEN BEGIN
            TrainingApplications.Status := TrainingApplications.Status::Approved;
            TrainingApplications.VALIDATE(TrainingApplications.Status);
            TrainingApplications.MODIFY;
            MESSAGE(HRTrainingApplicationMessage);
        END;
    end;

    procedure ReOpenHRTrainingHeader(var HRTrainingApplications: Record 50164)
    var
        TrainingApplications: Record 50164;
    begin
        TrainingApplications.RESET;
        TrainingApplications.SETRANGE(TrainingApplications."Application No.", HRTrainingApplications."Application No.");
        IF TrainingApplications.FINDFIRST THEN BEGIN
            TrainingApplications.Status := TrainingApplications.Status::Open;
            TrainingApplications.VALIDATE(TrainingApplications.Status);
            TrainingApplications.MODIFY;
        END;
    end;

    procedure ReleaseHRTrainingNeedsHeader(var HRTrainingNeedsHeader: Record 50157)
    var
        TrainingNeedsHeader: Record 50157;
        HRTrainingNeedsMessage: Label 'Employee Training Needs Application has sucessfully been approved';
    begin
        TrainingNeedsHeader.RESET;
        TrainingNeedsHeader.SETRANGE(TrainingNeedsHeader."No.", HRTrainingNeedsHeader."No.");
        IF TrainingNeedsHeader.FINDFIRST THEN BEGIN
            TrainingNeedsHeader.Status := TrainingNeedsHeader.Status::Approved;
            TrainingNeedsHeader.VALIDATE(TrainingNeedsHeader.Status);
            TrainingNeedsHeader.MODIFY;
            MESSAGE(HRTrainingNeedsMessage);
        END;
    end;

    procedure ReOpenHRTrainingNeedsHeader(var HRTrainingNeedsHeader: Record 50157)
    var
        TrainingNeedsHeader: Record 50157;
    begin
        TrainingNeedsHeader.RESET;
        TrainingNeedsHeader.SETRANGE(TrainingNeedsHeader."No.", HRTrainingNeedsHeader."No.");
        IF TrainingNeedsHeader.FINDFIRST THEN BEGIN
            TrainingNeedsHeader.Status := TrainingNeedsHeader.Status::Open;
            TrainingNeedsHeader.VALIDATE(TrainingNeedsHeader.Status);
            TrainingNeedsHeader.MODIFY;
        END;
    end;

    procedure ReleaseHRTrainingGroup(var HRTrainingGroup: Record 50162)
    var
        TrainingGroup: Record 50162;
        HRTrainingGroupMessage: Label 'The Group Training Application has sucessfully been Approved';
    begin
        TrainingGroup.RESET;
        TrainingGroup.SETRANGE(TrainingGroup."Training Group App. No.", HRTrainingGroup."Training Group App. No.");
        IF TrainingGroup.FINDFIRST THEN BEGIN
            TrainingGroup.Status := TrainingGroup.Status::Approved;
            TrainingGroup.VALIDATE(TrainingGroup.Status);
            TrainingGroup.MODIFY;
            MESSAGE(HRTrainingGroupMessage);
        END;
    end;

    procedure ReOpenHRTrainingGroup(var HRTrainingGroup: Record 50162)
    var
        TrainingGroup: Record 50162;
    begin
        TrainingGroup.RESET;
        TrainingGroup.SETRANGE(TrainingGroup."Training Group App. No.", HRTrainingGroup."Training Group App. No.");
        IF TrainingGroup.FINDFIRST THEN BEGIN
            TrainingGroup.Status := TrainingGroup.Status::Open;
            TrainingGroup.VALIDATE(TrainingGroup.Status);
            TrainingGroup.MODIFY;
        END;
    end;

    procedure ReleaseTrainingEvaluation(var TrainingEvaluation: Record 50161)
    var
        HRTrainingEvaluation: Record 50161;
        TrainingEvalutionMessage: Label 'Empolyee Training Evalution has successfully been Approved';
    begin
        TrainingEvaluation.RESET;
        TrainingEvaluation.SETRANGE(TrainingEvaluation."Training Evaluation No.", HRTrainingEvaluation."Training Evaluation No.");
        IF TrainingEvaluation.FINDFIRST THEN BEGIN
            TrainingEvaluation.Status := TrainingEvaluation.Status::Approved;
            TrainingEvaluation.VALIDATE(TrainingEvaluation.Status);
            TrainingEvaluation.MODIFY;
            MESSAGE(TrainingEvalutionMessage);
        END;
    end;

    procedure ReOpenTrainingEvaluation(var TrainingEvaluation: Record 50161)
    var
        HRTrainingEvaluation: Record 50161;
    begin
        TrainingEvaluation.RESET;
        TrainingEvaluation.SETRANGE(TrainingEvaluation."Training Evaluation No.", HRTrainingEvaluation."Training Evaluation No.");
        IF TrainingEvaluation.FINDFIRST THEN BEGIN
            TrainingEvaluation.Status := TrainingEvaluation.Status::Open;
            TrainingEvaluation.VALIDATE(TrainingEvaluation.Status);
            TrainingEvaluation.MODIFY;
        END;
    end;

    /*  procedure ReleaseleaveAllowance(var LeaveAllowanceRequest: Record 50207)
     var
         LeaveAllowanceRequest2: Record 50207;
         LeaveAllowanceMessage: Label 'Employee Leave Allowance application has succesfully been approved';
     begin
         LeaveAllowanceRequest2.RESET;
         LeaveAllowanceRequest2.SETRANGE(LeaveAllowanceRequest2."No.", LeaveAllowanceRequest."No.");
         IF LeaveAllowanceRequest2.FINDFIRST THEN BEGIN
             LeaveAllowanceRequest2.Status := LeaveAllowanceRequest2.Status::Approved;
             LeaveAllowanceRequest2.VALIDATE(LeaveAllowanceRequest2.Status);
             LeaveAllowanceRequest2.MODIFY;
             MESSAGE(LeaveAllowanceMessage);
         END;
     end; */

    /* procedure ReOpenLeaveAllowance(var LeaveAllowanceRequest: Record 50207)
    var
        LeaveAllowanceRequest2: Record 50207;
    begin
        LeaveAllowanceRequest2.RESET;
        LeaveAllowanceRequest2.SETRANGE(LeaveAllowanceRequest2."No.", LeaveAllowanceRequest."No.");
        IF LeaveAllowanceRequest2.FINDFIRST THEN BEGIN
            LeaveAllowanceRequest2.Status := LeaveAllowanceRequest2.Status::Open;
            LeaveAllowanceRequest2.MODIFY;
        END;
    end; */

    /* procedure ReleaseHRLoan(var EmployeeLoanApplications: Record 50074)
    var
        EmployeeLoanApplication: Record 50074;
        LoanApplicationMessage: Label 'Employee Loan Application has sucessfully been Approved';
    begin
        EmployeeLoanApplication.RESET;
        EmployeeLoanApplication.SETRANGE(EmployeeLoanApplication."No.", EmployeeLoanApplications."No.");
        IF EmployeeLoanApplication.FINDFIRST THEN BEGIN
            EmployeeLoanApplication.Status := EmployeeLoanApplication.Status::Approved;
            EmployeeLoanApplication.VALIDATE(EmployeeLoanApplication.Status);
            EmployeeLoanApplication.MODIFY;
            MESSAGE(LoanApplicationMessage);
        END;
    end;

    procedure ReOpenHRLoan(var EmployeeLoanApplications: Record 50074)
    var
        EmployeeLoanApplication: Record 50074;
    begin
        EmployeeLoanApplication.RESET;
        EmployeeLoanApplication.SETRANGE(EmployeeLoanApplication."No.", EmployeeLoanApplications."No.");
        IF EmployeeLoanApplication.FINDFIRST THEN BEGIN
            EmployeeLoanApplication.Status := EmployeeLoanApplication.Status::Rejected;
            EmployeeLoanApplication.VALIDATE(EmployeeLoanApplication.Status);
            EmployeeLoanApplication.MODIFY;
        END;
    end;

    procedure InsertLoanRejectionComments(var ApprovalEntry: Record 454)
    var
        EmployeeLoanApplication: Record 50074;
    begin
        EmployeeLoanApplication.RESET;
        EmployeeLoanApplication.SETRANGE(EmployeeLoanApplication."No.", ApprovalEntry."Document No.");
        IF EmployeeLoanApplication.FINDFIRST THEN BEGIN
            EmployeeLoanApplication."Rejection Comment" := ApprovalEntry."Rejection Comments";
            EmployeeLoanApplication.MODIFY;
        END;
    end;

    procedure ReleaseHRLoanProduct(var HRLoanProducts: Record 50082)
    var
        HRLoanProduct: Record 50082;
        HRLoanProductMessage: Label 'Human Resource, Loan Product has successfully been approved';
    begin
        HRLoanProduct.RESET;
        HRLoanProduct.SETRANGE(HRLoanProduct.Code, HRLoanProducts.Code);
        IF HRLoanProduct.FINDFIRST THEN BEGIN
            HRLoanProduct.Status := HRLoanProduct.Status::Approved;
            HRLoanProduct.VALIDATE(HRLoanProduct.Status);
            HRLoanProduct.MODIFY;
            MESSAGE(HRLoanProductMessage);
        END;
    end;

    procedure ReOpenHRLoanProduct(var HRLoanProducts: Record 50082)
    var
        HRLoanProduct: Record 50082;
    begin
        HRLoanProduct.RESET;
        HRLoanProduct.SETRANGE(HRLoanProduct.Code, HRLoanProducts.Code);
        IF HRLoanProduct.FINDFIRST THEN BEGIN
            HRLoanProduct.Status := HRLoanProduct.Status::Open;
            HRLoanProduct.VALIDATE(HRLoanProduct.Status);
            HRLoanProduct.MODIFY;
        END;
    end;

    procedure ReleaseHRLoanDisbursement(var EmployeeLoanDisbursements: Record 50076)
    var
        EmployeeLoanDisbursement: Record 50076;
        EmployeeLoanDisbursementMessage: Label 'Employee Loan disbursement request has sucessfully been approved';
    begin
        EmployeeLoanDisbursement.RESET;
        EmployeeLoanDisbursement.SETRANGE(EmployeeLoanDisbursement."No.", EmployeeLoanDisbursements."No.");
        IF EmployeeLoanDisbursement.FINDFIRST THEN BEGIN
            EmployeeLoanDisbursement.Status := EmployeeLoanDisbursement.Status::Released;
            EmployeeLoanDisbursement.VALIDATE(EmployeeLoanDisbursement.Status);
            EmployeeLoanDisbursement.MODIFY;
            MESSAGE(EmployeeLoanDisbursementMessage);
        END;
    end;

    procedure ReOpenHRLoanDisbursement(var EmployeeLoanDisbursements: Record 50076)
    var
        EmployeeLoanDisbursement: Record 50076;
    begin
        EmployeeLoanDisbursement.RESET;
        EmployeeLoanDisbursement.SETRANGE(EmployeeLoanDisbursement."No.", EmployeeLoanDisbursements."No.");
        IF EmployeeLoanDisbursement.FINDFIRST THEN BEGIN
            EmployeeLoanDisbursement.Status := EmployeeLoanDisbursement.Status::Open;
            EmployeeLoanDisbursement.VALIDATE(EmployeeLoanDisbursement.Status);
            EmployeeLoanDisbursement.MODIFY;
        END;
    end; */

    procedure ReleaseInterviewHeader(var InterviewAttendanceHeader: Record 50108)
    var
        HRInterviewAttendanceHeader: Record 50108;
        InterviewAttendanceHeaderMessage: Label 'Interview Attendance request has sucessfully been approved';
    begin
        HRInterviewAttendanceHeader.RESET;
        HRInterviewAttendanceHeader.SETRANGE(HRInterviewAttendanceHeader."Interview No", InterviewAttendanceHeader."Interview No");
        IF HRInterviewAttendanceHeader.FINDFIRST THEN BEGIN
            HRInterviewAttendanceHeader.Status := HRInterviewAttendanceHeader.Status::Approved;
            HRInterviewAttendanceHeader.VALIDATE(HRInterviewAttendanceHeader.Status);
            HRInterviewAttendanceHeader.MODIFY;
            MESSAGE(InterviewAttendanceHeaderMessage);
        END;
    end;

    procedure ReOpenInterviewHeader(var HRInterviewAttendanceHeader: Record 50108)
    var
        InterviewAttendanceHeader: Record 50108;
    begin
        HRInterviewAttendanceHeader.RESET;
        HRInterviewAttendanceHeader.SETRANGE(HRInterviewAttendanceHeader."Interview No", HRInterviewAttendanceHeader."Interview No");
        IF HRInterviewAttendanceHeader.FINDFIRST THEN BEGIN
            HRInterviewAttendanceHeader.Status := HRInterviewAttendanceHeader.Status::Open;
            HRInterviewAttendanceHeader.VALIDATE(HRInterviewAttendanceHeader.Status);
            HRInterviewAttendanceHeader.MODIFY;
        END;
    end;

    /* procedure ReOpenHRTransportRequest(var HRTransportRequest: Record 50210)
    var
        TransportRequestRec: Record 50210;
    begin
        TransportRequestRec.RESET;
        TransportRequestRec.SETRANGE(TransportRequestRec."Request No.", HRTransportRequest."Request No.");
        IF TransportRequestRec.FINDFIRST THEN BEGIN
            TransportRequestRec.Status := TransportRequestRec.Status::Open;
            TransportRequestRec.VALIDATE(TransportRequestRec.Status);
            TransportRequestRec.MODIFY;
        END;
    end; */

    /*     procedure ReleaseTransportRequest(var TransportRequest: Record 50210)
        var
            TransportRequestRec: Record 50210;
            LeaveAllowanceMessage: Label 'Employee Leave Allowance application has succesfully been approved';
        begin
            TransportRequestRec.RESET;
            TransportRequestRec.SETRANGE(TransportRequestRec."Request No.", TransportRequest."Request No.");
            IF TransportRequestRec.FINDFIRST THEN BEGIN
                TransportRequestRec.Status := TransportRequestRec.Status::Released;
                TransportRequestRec.VALIDATE(TransportRequestRec.Status);
                TransportRequestRec.MODIFY;
            END;
        end; */
}


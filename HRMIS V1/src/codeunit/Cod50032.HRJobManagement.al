codeunit 50032 "HR Job Management"
{

    trigger OnRun()
    begin
    end;

    var
        HRJobs: Record 50093;

    procedure CheckHRJobMandatoryFields("HR Job": Record 50093)
    var
        HRJob: Record 50093;
        EmptyPaymentLine: Label 'You cannot Post Payment with empty Line';
    begin
        HRJob.TRANSFERFIELDS("HR Job", TRUE);
        HRJob.TESTFIELD("Job Title");
        HRJob.TESTFIELD("Job Grade");
        HRJob.TESTFIELD("Maximum Positions");
        //HRJob.TESTFIELD("Global Dimension 1 Code");
    end;

    procedure ReOpenReleasedJobs(var "HR Jobs": Record 50093)
    var
        HRJobs: Record 50093;
        JobReopenedMessage: Label 'The Job has Successfully been Reopened and Deactivated';
    begin
        HRJobs.RESET;
        HRJobs.SETRANGE(HRJobs."No.", "HR Jobs"."No.");
        IF HRJobs.FINDFIRST THEN BEGIN
            HRJobs.Status := HRJobs.Status::Open;
            HRJobs.VALIDATE(HRJobs.Status);
            HRJobs.Active := FALSE;
            HRJobs.MODIFY;
            MESSAGE(JobReopenedMessage);
        END;
    end;

    procedure DeactivateReleasedJobs(var "HR Jobs": Record 50093)
    var
        HRJobs: Record 50093;
        Txt001: Label 'The Job has been sucessfully deactivated';
    begin
        HRJobs.RESET;
        HRJobs.SETRANGE(HRJobs."No.", "HR Jobs"."No.");
        IF HRJobs.FINDFIRST THEN BEGIN
            HRJobs.Active := FALSE;
            HRJobs.MODIFY;
            MESSAGE(Txt001);
        END;
    end;

    procedure CheckOpenJobExists(EmployeeUserID: Code[50]) OpenJobExist: Boolean
    begin
        OpenJobExist := FALSE;
        HRJobs.RESET;
        HRJobs.SETRANGE(HRJobs."User ID", EmployeeUserID);
        HRJobs.SETRANGE(HRJobs.Status, HRJobs.Status::Open);
        IF HRJobs.FINDFIRST THEN BEGIN
            OpenJobExist := TRUE;
        END;
    end;

    procedure ReactivateReleasedJobs(var "HR Jobs": Record 50093)
    var
        HRJobs: Record 50093;
        Txt001: Label 'The Job has been sucessfully Activated';
    begin
        HRJobs.RESET;
        HRJobs.SETRANGE(HRJobs."No.", "HR Jobs"."No.");
        IF HRJobs.FINDFIRST THEN BEGIN
            HRJobs.Active := TRUE;
            HRJobs.MODIFY;
            MESSAGE(Txt001);
        END;
    end;
}


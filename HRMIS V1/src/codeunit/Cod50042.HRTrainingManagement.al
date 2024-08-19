/// <summary>
/// Codeunit HR Training Management (ID 50042).
/// </summary>
codeunit 50042 "HR Training Management"
{

    trigger OnRun()
    begin
    end;

    var
        TrainingType: Option " ","Individual Training","Group Training";
        TrainingGroups: Record 50162;
        Txt001: Label 'Process Complete';

    procedure LoadTrainingAttendeesfromTrainingGroups(TrainingApplications: Record 50164)
    var
        TrainingAttendees: Record 50165;
        TrainingGroupParticipants: Record 50163;
    begin
        TrainingAttendees.RESET;
        TrainingAttendees.SETRANGE("Application No.", TrainingApplications."Application No.");
        IF TrainingAttendees.FINDSET THEN
            TrainingAttendees.DELETEALL;

        TrainingGroupParticipants.RESET;
        TrainingGroupParticipants.SETRANGE("Training Group No.", TrainingApplications."No.");
        IF TrainingGroupParticipants.FINDSET THEN BEGIN
            REPEAT
                TrainingAttendees.INIT;
                TrainingAttendees."Application No." := TrainingApplications."Application No.";
                TrainingAttendees."Employee No" := TrainingGroupParticipants."Employee No.";
                TrainingAttendees."Employee Name" := TrainingGroupParticipants."Employee Name";
                TrainingAttendees."Job Title" := TrainingGroupParticipants."Job Tittle";
                TrainingAttendees."E-mail Address" := TrainingGroupParticipants."E-mail Address";
                TrainingAttendees."Estimated Cost" := TrainingGroupParticipants."Estimated Cost";
                TrainingAttendees.INSERT;
            UNTIL TrainingGroupParticipants.NEXT = 0;
        END;
        MESSAGE(Txt001);
    end;

    procedure InsertProposedTrainingForEmployees(AppraisalPeriod: Code[20]; No: Code[20])
    var
        HRTrainingNeedsLine: Record 50158;
        EmployeesApprovedTraining: Record 50160;
        HRTrainingNeedsHeader: Record 50157;
    begin
        HRTrainingNeedsHeader.RESET;
        HRTrainingNeedsHeader.SETRANGE("Calendar Year", AppraisalPeriod);
        IF HRTrainingNeedsHeader.FINDSET THEN BEGIN
            REPEAT
                HRTrainingNeedsLine.RESET;
                HRTrainingNeedsLine.SETRANGE("No.", HRTrainingNeedsHeader."No.");
                IF HRTrainingNeedsLine.FINDSET THEN BEGIN
                    REPEAT
                        EmployeesApprovedTraining.INIT;
                        EmployeesApprovedTraining."No." := No;
                        EmployeesApprovedTraining."Line No." := 0;
                        EmployeesApprovedTraining."Employee No." := HRTrainingNeedsLine."Employee No.";
                        EmployeesApprovedTraining."Employee Name" := HRTrainingNeedsLine."Employee Name";
                        EmployeesApprovedTraining."Official Mail" := HRTrainingNeedsLine."Official Email Address";
                        EmployeesApprovedTraining."Intervention Required" := HRTrainingNeedsLine."Intervention Required";
                        EmployeesApprovedTraining."Development Needs" := HRTrainingNeedsLine."Development Needs";
                        EmployeesApprovedTraining.Objectives := HRTrainingNeedsLine.Objectives;
                        EmployeesApprovedTraining.Description := HRTrainingNeedsLine.Description;
                        EmployeesApprovedTraining."Proposed Training Provider" := HRTrainingNeedsLine."Proposed Training Provider";
                        EmployeesApprovedTraining."Training Location & Venue" := HRTrainingNeedsLine."Training Location & Venue";
                        EmployeesApprovedTraining."Proposed Period" := HRTrainingNeedsLine."Proposed Period";
                        EmployeesApprovedTraining."Calendar Year" := HRTrainingNeedsLine."Calendar Year";
                        EmployeesApprovedTraining."Training Scheduled Date" := HRTrainingNeedsLine."Training Scheduled Date";
                        EmployeesApprovedTraining."Training Scheduled Date To" := HRTrainingNeedsLine."Training Scheduled Date To";
                        EmployeesApprovedTraining."Estimated Cost" := HRTrainingNeedsLine."Estimated Cost";
                        EmployeesApprovedTraining."Global Dimension 1 Code" := HRTrainingNeedsLine."Global Dimension 1 Code";
                        EmployeesApprovedTraining."Global Dimension 2 Code" := HRTrainingNeedsLine."Global Dimension 2 Code";
                        EmployeesApprovedTraining."Shortcut Dimension 3 Code" := HRTrainingNeedsLine."Shortcut Dimension 3 Code";
                        EmployeesApprovedTraining."Shortcut Dimension 4 Code" := HRTrainingNeedsLine."Shortcut Dimension 4 Code";
                        EmployeesApprovedTraining."Shortcut Dimension 5 Code" := HRTrainingNeedsLine."Shortcut Dimension 5 Code";
                        EmployeesApprovedTraining."Shortcut Dimension 6 Code" := HRTrainingNeedsLine."Shortcut Dimension 6 Code";
                        EmployeesApprovedTraining."Shortcut Dimension 7 Code" := HRTrainingNeedsLine."Shortcut Dimension 7 Code";
                        EmployeesApprovedTraining."Shortcut Dimension 8 Code" := HRTrainingNeedsLine."Shortcut Dimension 8 Code";
                        EmployeesApprovedTraining.INSERT;
                    UNTIL HRTrainingNeedsLine.NEXT = 0;
                END;
            UNTIL HRTrainingNeedsHeader.NEXT = 0;
        END;
    end;

    procedure ValidateTrainingDetails(TrainingApplications: Record 50164)
    var
        TrainingApplications2: Record 50164;
        TrainingAttendees: Record 50165;
        HREmployee: Record 5200;
    begin
        CASE TrainingApplications."Type of Training" OF
            TrainingApplications."Type of Training"::"Group Training":
                BEGIN
                    TrainingGroups.RESET;
                    TrainingGroups.SETRANGE("Training Group App. No.", TrainingApplications."No.");
                    IF TrainingGroups.FINDFIRST THEN BEGIN
                        LoadTrainingAttendeesfromTrainingGroups(TrainingApplications);
                        ModifyTrainingApplication(TrainingApplications);
                    END;
                END;
        END;

        CASE TrainingApplications."Type of Training" OF
            TrainingApplications."Type of Training"::"Individual Training":
                BEGIN
                    TrainingAttendees.RESET;
                    TrainingAttendees.SETRANGE("Application No.", TrainingApplications."Application No.");
                    IF TrainingAttendees.FINDSET THEN
                        TrainingAttendees.DELETEALL;

                    TrainingApplications2.RESET;
                    TrainingApplications2.SETRANGE("Application No.", TrainingApplications."Application No.");
                    IF TrainingApplications2.FINDFIRST THEN BEGIN
                        IF HREmployee.GET(TrainingApplications."No.") THEN
                            TrainingAttendees.INIT;
                        TrainingAttendees."Application No." := TrainingApplications2."Application No.";
                        TrainingAttendees."Employee No" := TrainingApplications2."Employee No.";
                        TrainingAttendees."Employee Name" := TrainingApplications2."Employee Name";
                        TrainingAttendees."Job Title" := HREmployee.Title;
                        TrainingAttendees."Phone Number" := HREmployee."Phone No.";
                        TrainingAttendees."E-mail Address" := HREmployee."Company E-Mail";
                        TrainingAttendees.INSERT;
                    END;
                END;
        END;
    end;

    procedure ModifyTrainingApplication(TrainingApplications: Record 50164)
    var
        TrainingApplications2: Record 50164;
    begin
        TrainingApplications2.RESET;
        TrainingApplications2.SETRANGE("Application No.", TrainingApplications."Application No.");
        IF TrainingApplications2.FINDFIRST THEN BEGIN
            TrainingApplications2.Name := TrainingGroups."Training Group Name";
            // MESSAGE(TrainingApplications2.Name);
            TrainingApplications2."Calendar Year" := TrainingGroups."Calendar Year";
            TrainingApplications2.Description := TrainingGroups."Training Needs Description";
            TrainingApplications2."Development Need" := TrainingGroups."Development Need";
            TrainingApplications2."Purpose of Training" := TrainingGroups.Objective;
            TrainingApplications2."From Date" := TrainingGroups."From Date";
            TrainingApplications2."To Date" := TrainingGroups."To Date";
            TrainingApplications2.MODIFY;
        END;
    end;
}


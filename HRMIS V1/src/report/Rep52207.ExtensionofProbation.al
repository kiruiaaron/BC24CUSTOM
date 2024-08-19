report 52207 "Extension of Probation"
{
    RDLCLayout = './src/layouts/Extension of Probation.rdlc';
    WordLayout = './src/layouts/Extension of Probation.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Probation Review"; 50328)
        {
            column(CompanyInformationRec_Picture; CompanyInformationRec.Picture)
            {
            }
            column(No_ProbationReview; "Probation Review"."No.")
            {
            }
            column(DocumentDate_ProbationReview; FORMAT("Probation Review"."Document Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(EmployeeNo_ProbationReview; "Probation Review"."Employee No.")
            {
            }
            column(EmployeeName_ProbationReview; "Probation Review"."Employee Name")
            {
            }
            column(Grade_ProbationReview; "Probation Review".Grade)
            {
            }
            column(DepartmentSection_ProbationReview; "Probation Review"."Department/Section")
            {
            }
            column(DepartmentName_ProbationReview; "Probation Review"."Department Name")
            {
            }
            column(PostStartDate_ProbationReview; FORMAT("Probation Review"."Post Start Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(LineManager_ProbationReview; "Probation Review"."Line Manager")
            {
            }
            column(LineManagerName_ProbationReview; "Probation Review"."Line Manager Name")
            {
            }
            column(ReviewStage_ProbationReview; "Probation Review"."Review Stage")
            {
            }
            column(NoSeries_ProbationReview; "Probation Review"."No. Series")
            {
            }
            column(JobTitle_; JobTitle)
            {
            }
            column(EmployeeAddress_; EmployeeAddress)
            {
            }
            dataitem("Probation Review Meeting"; 50329)
            {
                DataItemLink = "Review No." = FIELD("No.");
                column(MeetingDate_ProbationReviewMeeting; FORMAT("Probation Review Meeting"."Meeting Date", 0, '<Day,2> <Month Text> <Year4>'))
                {
                }
                dataitem("Probation Meeting Objective"; 50330)
                {
                    DataItemLink = "Review No" = FIELD("Review No.");
                    column(Objective_ProbationMeetingObjective; "Probation Meeting Objective".Objective)
                    {
                    }
                }
                dataitem("Probation Development Plan"; 50331)
                {
                    DataItemLink = "Review No" = FIELD("Review No.");
                    column(DevelopmentPlan_ProbationDevelopmentPlan; "Probation Development Plan"."Development Plan")
                    {
                    }
                }
            }
            dataitem("Probation First Review"; 50332)
            {
                DataItemLink = "Review No." = FIELD("No.");
                column(ReviewNo_ProbationFirstReview; "Probation First Review"."Review No.")
                {
                }
                column(FirstReviewDate_ProbationFirstReview; FORMAT("Probation First Review"."First Review Date", 0, '<Day,2> <Month Text> <Year4>'))
                {
                }
                column(PerformanceSummary_ProbationFirstReview; "Probation First Review"."Performance Summary")
                {
                }
                column(ObjectivesMet_ProbationFirstReview; "Probation First Review"."Objectives Met?")
                {
                }
                column(TrainingNeedAddressed_ProbationFirstReview; "Probation First Review"."Training Need Addressed?")
                {
                }
                column(TrainingNeedAction_ProbationFirstReview; "Probation First Review"."Training Need Action")
                {
                }
                column(TrainingNeedReviewDate_ProbationFirstReview; "Probation First Review"."Training Need Review Date")
                {
                }
                column(ObjectivesMetAction_ProbationFirstReview; "Probation First Review"."Objectives Met Action")
                {
                }
                column(ObjectiveMetReviewDate_ProbationFirstReview; "Probation First Review"."Objective Met Review Date")
                {
                }
                dataitem("Probation First/Final KPI"; 50333)
                {
                    DataItemLink = "Review No." = FIELD("Review No.");
                    DataItemTableView = WHERE("First/Final" = CONST(First));
                    column(AreaOfPerformance_ProbationFirstFinalKPI; "Probation First/Final KPI"."Area Of Performance")
                    {
                    }
                    column(Remarks_ProbationFirstFinalKPI; "Probation First/Final KPI".Remarks)
                    {
                    }
                }
                dataitem(ReviewKPIImprovements; 50334)
                {
                    DataItemLink = "Review No." = FIELD("Review No.");
                    DataItemTableView = WHERE(Type = FILTER(Improvement));
                    column(Description_ReviewKPIImprovements; ReviewKPIImprovements.Description)
                    {
                    }
                }
                dataitem(ReviewKPIConcerns; 50334)
                {
                    DataItemLink = "Review No." = FIELD("Review No.");
                    DataItemTableView = WHERE(Type = CONST(Concern));
                    column(Description_ReviewKPIConcerns; ReviewKPIConcerns.Description)
                    {
                    }
                }
            }
            dataitem("Probation Final Review"; 50335)
            {
                DataItemLink = "Review No." = FIELD("No.");
                column(ReviewNo_ProbationFinalReview; "Probation Final Review"."Review No.")
                {
                }
                column(FinalReviewDate_ProbationFinalReview; FORMAT("Probation Final Review"."Final Review Date", 0, '<Day,2> <Month Text> <Year4>'))
                {
                }
                column(PerformanceSummary_ProbationFinalReview; "Probation Final Review"."Performance Summary")
                {
                }
                column(ObjectivesMet_ProbationFinalReview; "Probation Final Review"."Objectives Met?")
                {
                }
                column(TrainingNeedAddressed_ProbationFinalReview; "Probation Final Review"."Training Need Addressed?")
                {
                }
                column(TrainingNeedAction_ProbationFinalReview; "Probation Final Review"."Training Need Action")
                {
                }
                column(TrainingNeedReviewDate_ProbationFinalReview; "Probation Final Review"."Training Need Review Date")
                {
                }
                column(ObjectivesMetAction_ProbationFinalReview; "Probation Final Review"."Objectives Met Action")
                {
                }
                column(ObjectiveMetReviewDate_ProbationFinalReview; "Probation Final Review"."Objective Met Review Date")
                {
                }
                column(AppointmenttobeConfirmed_ProbationFinalReview; "Probation Final Review"."Appointment to be Confirmed")
                {
                }
                column(ReasonsForNotConfirming_ProbationFinalReview; "Probation Final Review"."Reasons For Not Confirming")
                {
                }
                column(EmployeeComments_ProbationFinalReview; "Probation Final Review"."Employee Comments")
                {
                }
                column(ExtendProbationPeriod_ProbationFinalReview; "Probation Final Review"."Extend Probation Period")
                {
                }
                column(ReasonForExtension_ProbationFinalReview; "Probation Final Review"."Reason For Extension")
                {
                }
                column(LengthOfExtension_ProbationFinalReview; "Probation Final Review"."Length Of Extension")
                {
                }
                column(NewProbationEndDate_ProbationFinalReview; FORMAT("Probation Final Review"."New Probation End Date", 0, '<Day,2> <Month Text> <Year4>'))
                {
                }
                column(ConfirmationLetterSent_ProbationFinalReview; "Probation Final Review"."Confirmation Letter Sent")
                {
                }
                column(ReasonObjectiveNotMet_ProbationFinalReview; "Probation Final Review"."Reason Objective Not Met")
                {
                }
                column(ReasonTrainingNotMet_ProbationFinalReview; "Probation Final Review"."Reason Training Not Met")
                {
                }
                column(SignatoryEmployee_ProbationFinalReview; "Probation Final Review"."Signatory Employee")
                {
                }
                column(SignatoryEmployeeName_ProbationFinalReview; "Probation Final Review"."Signatory Employee Name")
                {
                }
                column(SignatoryEmployeeTitle_ProbationFinalReview; "Probation Final Review"."Signatory Employee Title")
                {
                }
                dataitem(FinalKPI; 50333)
                {
                    DataItemLink = "Review No." = FIELD("Review No.");
                    DataItemTableView = WHERE("First/Final" = CONST(Final));
                    column(AreaOfPerformance_FinalKPI; FinalKPI."Area Of Performance")
                    {
                    }
                    column(Remarks_FinalKPI; FinalKPI.Remarks)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                JobTitle := '';
                IF EmployeeRec.GET("Probation Review"."Employee No.") THEN BEGIN
                    JobTitle := EmployeeRec."Job Title";
                    EmployeeAddress := EmployeeRec.Address;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformationRec.GET;
        CompanyInformationRec.CALCFIELDS(Picture);
    end;

    var
        EmployeeRec: Record 5200;
        JobTitle: Text;
        EmployeeAddress: Text;
        CompanyInformationRec: Record 79;
}


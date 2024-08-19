report 51203 "Employee Appraisal Report MY"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Employee Appraisal Report MY.rdlc';

    dataset
    {
        dataitem("Employee Appraisal Header"; 50281)
        {
            RequestFilterFields = "No.";
            column(Agetext; AgeText)
            {
            }
            column(CName; CompanyInfo.Name)
            {
            }
            column(CAddress; CompanyInfo.Address)
            {
            }
            column(CCity; CompanyInfo.City)
            {
            }
            column(CPic; CompanyInfo.Picture)
            {
            }
            column(CEmail; CompanyInfo."E-Mail")
            {
            }
            column(CPhone; CompanyInfo."Phone No.")
            {
            }
            column(ServiceAgeText; ServiceAgeText)
            {
            }
            column(PeriodFormula; PeriodFormula)
            {
            }
            column(retirementdate; retirementdate)
            {
            }
            column(No_EmployeeAppraisalHeader; "Employee Appraisal Header"."No.")
            {
            }
            column(EmployeeNo_EmployeeAppraisalHeader; "Employee Appraisal Header"."Employee No.")
            {
            }
            column(EmployeeName_EmployeeAppraisalHeader; "Employee Appraisal Header"."Employee Name")
            {
            }
            column(AppraisalPeriod_EmployeeAppraisalHeader; "Employee Appraisal Header"."Appraisal Period")
            {
            }
            column(AppraisalStage_EmployeeAppraisalHeader; "Employee Appraisal Header"."Appraisal Stage")
            {
            }
            column(JobGrade_EmployeeAppraisalHeader; "Employee Appraisal Header"."Job Grade")
            {
            }
            column(Designation_EmployeeAppraisalHeader; "Employee Appraisal Header".Designation)
            {
            }
            column(JobNo_EmployeeAppraisalHeader; "Employee Appraisal Header"."Job No")
            {
            }
            column(JobTitle_EmployeeAppraisalHeader; "Employee Appraisal Header"."Job Title")
            {
            }
            dataitem("Appraisal KPI"; 50285)
            {
                DataItemLink = "Header No" = FIELD("No.");
                column(Criteriacode_AppraisalKPI; "Appraisal KPI"."Criteria code")
                {
                }
                column(PerformanceCriteria_AppraisalKPI; "Appraisal KPI"."Performance Criteria")
                {
                }
                column(ObjectiveWeightage_AppraisalKPI; "Appraisal KPI"."Objective Weightage")
                {
                }
                dataitem("Appraisal Targets"; 50288)
                {
                    DataItemLink = "Header No" = FIELD("Header No"),
                                   "Criteria code" = FIELD("Criteria code");
                    column(PerformanceTargets_AppraisalTargets; "Appraisal Targets"."Performance Targets")
                    {
                    }
                    column(TargetedScore_AppraisalTargets; "Appraisal Targets"."Targeted Score")
                    {
                    }
                    column(TargetCode_AppraisalTargets; "Appraisal Targets"."Target Code")
                    {
                    }
                    dataitem("Appraisal Indicators"; 50283)
                    {
                        DataItemLink = "Header No" = FIELD("Header No"),
                                       "Criteria code" = FIELD("Criteria code"),
                                       "Target Code" = FIELD("Target Code");
                        column(TargetedScore_AppraisalIndicators; "Appraisal Indicators"."Targeted Score")
                        {
                        }
                        column(SpecificIndicator_AppraisalIndicators; "Appraisal Indicators"."Specific Indicator")
                        {
                        }
                        column(TargetCode_AppraisalIndicators; "Appraisal Indicators"."Target Code")
                        {
                        }
                        column(AchievedScoreEndYear_AppraisalIndicators; "Appraisal Indicators"."Achieved Score EY Employee")
                        {
                        }
                        column(AchievedScoreEYSupervisor_AppraisalIndicators; "Appraisal Indicators"."Achieved Score EY Supervisor")
                        {
                        }
                        column(AchievedScoreMidYear_AppraisalIndicators; "Appraisal Indicators"."Achieved Score Employee")
                        {
                        }
                        column(AchievedScoreMYSupervisor_AppraisalIndicators; "Appraisal Indicators"."Achieved Score Supervisor")
                        {
                        }
                    }
                }
            }

            trigger OnAfterGetRecord()
            var
                retirementdateCeil: Date;
            begin
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
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        //gsSegmentPayrollData;
    end;

    var
        PeriodFormula: DateFormula;
        AgeText: Text;
        CompanyInfo: Record 79;
        ServiceAgeText: Text;
        Dates: Codeunit 50043;
        //gvAllowedPayrolls: Record 51182;
        retireagef: DateFormula;
        PeriodFormula2: DateFormula;
        retirementdate: Date;

    /*  procedure gsSegmentPayrollData()
     var
         lvAllowedPayrolls: Record 51182;
         lvPayrollUtilities: Codeunit 51152;
         UsrID: Code[10];
         UsrID2: Code[10];
         StringLen: Integer;
         lvActiveSession: Record 2000000110;
     begin
     end; */
}


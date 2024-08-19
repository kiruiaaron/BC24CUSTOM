codeunit 50041 "HR Appraisal Management"
{

    trigger OnRun()
    begin
    end;

    procedure GetActualandTargetValues(OrganizationAppraisalLines: Record 50139)
    var
        OrganizationAppraisalLines2: Record 50139;
        Results: Decimal;
    begin
        Results := 0;
        IF OrganizationAppraisalLines."Parameter Type" = OrganizationAppraisalLines."Parameter Type"::"Time-Based" THEN BEGIN
            IF OrganizationAppraisalLines."Actual Value" > 0 THEN
                Results := OrganizationAppraisalLines."Target Value" / OrganizationAppraisalLines."Actual Value" * 3;

            IF Results > 1 THEN
                OrganizationAppraisalLines."Self Assessment Rating" := GetMinimumActualValueandTargetValue(Results, OrganizationAppraisalLines."Global Dimension 1 Code",
                OrganizationAppraisalLines."Appraisal Objective", OrganizationAppraisalLines."Appraisal Score Type") ELSE
                OrganizationAppraisalLines."Self Assessment Rating" := 1;
        END ELSE BEGIN
            Results := OrganizationAppraisalLines."Actual Value" / OrganizationAppraisalLines."Target Value" * 3;

            IF Results > 1 THEN
                OrganizationAppraisalLines."Self Assessment Rating" := GetMinimumActualValueandTargetValue(Results, OrganizationAppraisalLines."Global Dimension 1 Code",
                OrganizationAppraisalLines."Appraisal Objective", OrganizationAppraisalLines."Appraisal Score Type") ELSE
                OrganizationAppraisalLines."Self Assessment Rating" := 1;
        END;

        OrganizationAppraisalLines."Self Assessment Weighted Rat." := OrganizationAppraisalLines."Activity Weight" / 100 * OrganizationAppraisalLines."Objective Weight" / 100 * OrganizationAppraisalLines."Self Assessment Rating";
    end;

    procedure GetMinimumActualValueandTargetValue(Results: Decimal; DepartmentCode: Code[20]; ObjectiveCode: Code[20]; Type: Option " ",Core,"Non-Core") MinimumValue: Decimal
    var
        HumanResourcesSetup: Record 5218;
        HRAppraisalObjective: Record 50147;
    begin
        HumanResourcesSetup.GET;
        HRAppraisalObjective.RESET;
        HRAppraisalObjective.SETRANGE("Deparment Code", DepartmentCode);
        HRAppraisalObjective.SETRANGE(Code, ObjectiveCode);
        IF HRAppraisalObjective.FINDFIRST THEN BEGIN
            IF HRAppraisalObjective."Appraisal Score Type" = HRAppraisalObjective."Appraisal Score Type"::Core THEN BEGIN
                IF Results < HumanResourcesSetup."Appraisal Max score (Core)" THEN
                    MinimumValue := Results
                ELSE
                    MinimumValue := HumanResourcesSetup."Appraisal Max score (Core)";
            END ELSE BEGIN
                IF Results < HumanResourcesSetup."Appraisal Max Score(None Core)" THEN
                    MinimumValue := Results
                ELSE
                    MinimumValue := HumanResourcesSetup."Appraisal Max Score(None Core)";
            END;
        END;
    end;
}


codeunit 50026 "HR Employee Appraisal WS"
{

    trigger OnRun()
    begin
    end;

    var
        HREmployeeAppraisalHeader: Record 50138;
        HRIndividualAppraisalLines: Record 50142;
        HumanResourcesSetup: Record 5218;
        ApprovalEntry: Record 454;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";

    procedure CheckOpenEmployeeTargetSettingExists("EmployeeNo.": Code[20]) EmployeeTargetSettingExist: Boolean
    begin
        EmployeeTargetSettingExist := FALSE;

        HREmployeeAppraisalHeader.RESET;
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."Employee No.", "EmployeeNo.");
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader.Status, HREmployeeAppraisalHeader.Status::Open);
        IF HREmployeeAppraisalHeader.FINDFIRST THEN BEGIN
            EmployeeTargetSettingExist := TRUE;
        END;
    end;

    procedure CheckEmployeeTargetSettingExists("AppraisalNo.": Code[20]; "EmployeeNo.": Code[20]) EmployeeTargetSettingExist: Boolean
    begin
        EmployeeTargetSettingExist := FALSE;

        HREmployeeAppraisalHeader.RESET;
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."Employee No.", "EmployeeNo.");
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."No.", "AppraisalNo.");
        IF HREmployeeAppraisalHeader.FINDFIRST THEN BEGIN
            EmployeeTargetSettingExist := TRUE;
        END;
    end;

    procedure CreateEmployeeTargetSetting("EmployeeNo.": Code[20]) EmployeeTargetSettingCreated: Boolean
    begin
        EmployeeTargetSettingCreated := FALSE;

        HumanResourcesSetup.GET;
        HREmployeeAppraisalHeader.INIT;

        HREmployeeAppraisalHeader."No." := NoSeriesManagement.GetNextNo(HumanResourcesSetup."Employee Appraisal Nos.", 0D, TRUE);
        HREmployeeAppraisalHeader.Date := TODAY;
        HREmployeeAppraisalHeader."Employee No." := "EmployeeNo.";
        HREmployeeAppraisalHeader.VALIDATE(HREmployeeAppraisalHeader."Employee No.");

        IF HREmployeeAppraisalHeader.INSERT THEN BEGIN
            EmployeeTargetSettingCreated := TRUE;
        END;
    end;

    procedure GetEmployeeAppraisalNo("EmployeeNo.": Code[20]) "OpenAppraisalNo.": Code[20]
    begin
        "OpenAppraisalNo." := '';

        HREmployeeAppraisalHeader.RESET;
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."Employee No.", "EmployeeNo.");
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader.Status, HREmployeeAppraisalHeader.Status::Open);

        IF HREmployeeAppraisalHeader.FINDFIRST THEN BEGIN
            "OpenAppraisalNo." := HREmployeeAppraisalHeader."No.";
        END;
    end;

    procedure CreateEmployeeTargetSettingLine(EmployeeNo: Code[20]; AppraisalPeriod: Code[50]; AppraisalObjective: Code[30]; OrganizationalAppraisalCode: Code[20]; DepartmentalAppraisalCode: Code[20]; DivisionalAppraisalCode: Code[30]; ActivityDescription: Text[250]; ActivityWeight: Decimal; TargetValue: Decimal; BUM: Code[30]) EmployeeTargetSettingLineCreated: Boolean
    begin
        EmployeeTargetSettingLineCreated := FALSE;

        HREmployeeAppraisalHeader.RESET;
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."Employee No.", EmployeeNo);
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader.Status, HREmployeeAppraisalHeader.Status::Open);

        IF HREmployeeAppraisalHeader.FINDFIRST THEN BEGIN
            HumanResourcesSetup.GET;
            //Initialize Individual Appraisal Line
            HRIndividualAppraisalLines.INIT;
            HRIndividualAppraisalLines."Appraisal No" := HREmployeeAppraisalHeader."No.";
            HRIndividualAppraisalLines."Appraisal Period" := AppraisalPeriod;
            HRIndividualAppraisalLines.VALIDATE(HRIndividualAppraisalLines."Appraisal Period");
            HRIndividualAppraisalLines."Appraisal Objective" := AppraisalObjective;
            // HRIndividualAppraisalLines.VALIDATE("Appraisal Objective");
            HRIndividualAppraisalLines."Organization Activity Code" := OrganizationalAppraisalCode;
            // HRIndividualAppraisalLines.VALIDATE(HRIndividualAppraisalLines."Organization Activity Code");
            HRIndividualAppraisalLines."Departmental Activity Code" := DepartmentalAppraisalCode;
            // HRIndividualAppraisalLines.VALIDATE(HRIndividualAppraisalLines."Departmental Activity Code");
            HRIndividualAppraisalLines."Divisional Activity Code" := DivisionalAppraisalCode;
            //  HRIndividualAppraisalLines.VALIDATE("Divisional Activity Code");
            HRIndividualAppraisalLines."Activity Code" := NoSeriesManagement.GetNextNo(HumanResourcesSetup."Appraisal Activity Code Nos", 0D, TRUE);
            HRIndividualAppraisalLines."Activity Description" := ActivityDescription;
            HRIndividualAppraisalLines."Activity Weight" := ActivityWeight;
            //HRIndividualAppraisalLines.VALIDATE("Activity Weight");
            HRIndividualAppraisalLines."Target Value" := TargetValue;
            HRIndividualAppraisalLines."Base Unit of Measure" := BUM;

            IF HRIndividualAppraisalLines.INSERT THEN BEGIN
                EmployeeTargetSettingLineCreated := TRUE;
            END;
        END;
    end;

    procedure ModifyEmployeeTargetSetting("AppraisalNo.": Code[20]; "EmployeeNo.": Code[20]) EmployeeTargetSettingModified: Boolean
    begin
        EmployeeTargetSettingModified := FALSE;

        HRIndividualAppraisalLines.RESET;
        HRIndividualAppraisalLines.SETRANGE(HRIndividualAppraisalLines."Appraisal No", "AppraisalNo.");

        IF HRIndividualAppraisalLines.FINDFIRST THEN BEGIN
            HREmployeeAppraisalHeader.RESET;
            HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."No.", "AppraisalNo.");
            //HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."Employee No.","EmployeeNo.");
            IF HREmployeeAppraisalHeader.FINDFIRST THEN BEGIN
                HREmployeeAppraisalHeader.Date := TODAY;
                HREmployeeAppraisalHeader."No." := "AppraisalNo.";
                HREmployeeAppraisalHeader."Appraisal Period" := HRIndividualAppraisalLines."Appraisal Period";
                HREmployeeAppraisalHeader.VALIDATE(HREmployeeAppraisalHeader."Appraisal Period");
                HREmployeeAppraisalHeader.Description := 'APPRAISAL PERIOD ' + HREmployeeAppraisalHeader."Appraisal Period";
                HREmployeeAppraisalHeader."Employee No." := "EmployeeNo.";
                HREmployeeAppraisalHeader.VALIDATE(HREmployeeAppraisalHeader."Employee No.");

                HREmployeeAppraisalHeader.MODIFY;
                EmployeeTargetSettingModified := TRUE;
            END;
        END;
    end;

    procedure ModifyEmployeeTargetSettingLine("AppraisalNo.": Code[20]; AppraisalObjective: Code[30]; AppraisalPeriod: Code[50]; OrganizationalAppraisalCode: Code[30]; DepartmentalAppraisalCode: Code[30]; DivisionalAppraisalCode: Code[30]; ActivityDescription: Text[250]; ActivityWeight: Decimal; TargetValue: Decimal; BUM: Code[30]) EmployeeTargetSettingLineModified: Boolean
    begin
        EmployeeTargetSettingLineModified := FALSE;

        HRIndividualAppraisalLines.RESET;
        HRIndividualAppraisalLines.SETRANGE(HRIndividualAppraisalLines."Appraisal No", "AppraisalNo.");
        HRIndividualAppraisalLines.SETRANGE(HRIndividualAppraisalLines."Appraisal Objective", AppraisalObjective);

        IF HRIndividualAppraisalLines.FINDFIRST THEN BEGIN
            //Initialize Individual Appraisal Line
            HRIndividualAppraisalLines.INIT;
            HRIndividualAppraisalLines."Appraisal No" := HRIndividualAppraisalLines."Appraisal No";
            HRIndividualAppraisalLines."Appraisal Period" := HRIndividualAppraisalLines."Appraisal Period";
            HRIndividualAppraisalLines.VALIDATE(HRIndividualAppraisalLines."Appraisal Period");
            HRIndividualAppraisalLines."Appraisal Objective" := AppraisalObjective;
            HRIndividualAppraisalLines.VALIDATE("Appraisal Objective");
            HRIndividualAppraisalLines."Organization Activity Code" := OrganizationalAppraisalCode;
            HRIndividualAppraisalLines.VALIDATE(HRIndividualAppraisalLines."Organization Activity Code");
            HRIndividualAppraisalLines."Departmental Activity Code" := DepartmentalAppraisalCode;
            HRIndividualAppraisalLines.VALIDATE(HRIndividualAppraisalLines."Departmental Activity Code");
            HRIndividualAppraisalLines."Divisional Activity Code" := DivisionalAppraisalCode;
            HRIndividualAppraisalLines.VALIDATE("Divisional Activity Code");
            HRIndividualAppraisalLines."Activity Code" := HRIndividualAppraisalLines."Activity Code";
            HRIndividualAppraisalLines."Activity Weight" := HRIndividualAppraisalLines."Activity Weight";
            HRIndividualAppraisalLines.VALIDATE("Activity Weight");
            HRIndividualAppraisalLines."Target Value" := TargetValue;
            HRIndividualAppraisalLines."Base Unit of Measure" := BUM;

            IF HRIndividualAppraisalLines.MODIFY THEN BEGIN
                EmployeeTargetSettingLineModified := TRUE;
            END;
        END;
    end;

    procedure GetEmployeeTargetSettingStatus("AppraisalNo.": Code[20]) EmployeeTargetSettingStatus: Text
    begin
        EmployeeTargetSettingStatus := '';

        HREmployeeAppraisalHeader.RESET;
        HREmployeeAppraisalHeader.SETRANGE(HREmployeeAppraisalHeader."No.", "AppraisalNo.");
        IF HREmployeeAppraisalHeader.FINDFIRST THEN BEGIN
            EmployeeTargetSettingStatus := FORMAT(HREmployeeAppraisalHeader.Status);
        END;
    end;

    procedure CheckEmployeeTargetSettingLinesExist("AppraisalNo.": Code[20]) EmployeeTargetSettingLinesExist: Boolean
    begin
        EmployeeTargetSettingLinesExist := FALSE;

        HRIndividualAppraisalLines.RESET;
        HRIndividualAppraisalLines.SETRANGE(HRIndividualAppraisalLines."Appraisal No", "AppraisalNo.");
        IF HRIndividualAppraisalLines.FINDFIRST THEN BEGIN
            EmployeeTargetSettingLinesExist := TRUE;
        END;
    end;

    procedure DeleteEmployeeTargetSettingLine("AppraisalNo.": Code[20]; AppraisalObjective: Code[20]) IndividualAppraisalLineDeleted: Boolean
    begin
        IndividualAppraisalLineDeleted := FALSE;

        HRIndividualAppraisalLines.RESET;
        HRIndividualAppraisalLines.SETRANGE(HRIndividualAppraisalLines."Appraisal No", "AppraisalNo.");
        HRIndividualAppraisalLines.SETRANGE(HRIndividualAppraisalLines."Appraisal Objective", AppraisalObjective);

        IF HRIndividualAppraisalLines.FINDFIRST THEN BEGIN
            HRIndividualAppraisalLines.DELETE;
            IndividualAppraisalLineDeleted := TRUE;
        END;
    end;

    procedure CheckEmployeeTargetSettingApprovalWorkflowEnabled("AppraisalNo.": Code[20]) ApprovalWorkflowEnabled: Boolean
    begin
        ApprovalWorkflowEnabled := FALSE;

        HREmployeeAppraisalHeader.RESET;
        // IF HREmployeeAppraisalHeader.GET("AppraisalNo.") THEN
        //  ApprovalWorkflowEnabled := ApprovalsMgmtExt.CheckHREmployeeAppraisalHeaderApprovalsWorkflowEnabled(HREmployeeAppraisalHeader);
    end;

    procedure SendEmployeeTargetSettingApprovalRequest("AppraisalNo.": Code[20]) ApprovalRequestSent: Boolean
    begin
        ApprovalRequestSent := FALSE;

        HREmployeeAppraisalHeader.RESET;
        IF HREmployeeAppraisalHeader.GET("AppraisalNo.") THEN BEGIN
            // ApprovalsMgmtExt.OnSendHREmployeeAppraisalHeaderForApproval(HREmployeeAppraisalHeader);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", HREmployeeAppraisalHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            IF ApprovalEntry.FINDFIRST THEN
                ApprovalRequestSent := TRUE;
        END;
    end;

    procedure CancelEmployeeTargetSettingApprovalRequest("AppraisalNo.": Code[20]) ApprovalRequestCanceled: Boolean
    begin
        ApprovalRequestCanceled := FALSE;

        HREmployeeAppraisalHeader.RESET;
        IF HREmployeeAppraisalHeader.GET("AppraisalNo.") THEN BEGIN
            // ApprovalsMgmtExt.OnCancelHREmployeeAppraisalHeaderApprovalRequest(HREmployeeAppraisalHeader);
            COMMIT;
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", HREmployeeAppraisalHeader."No.");
            IF ApprovalEntry.FINDLAST THEN BEGIN
                IF ApprovalEntry.Status = ApprovalEntry.Status::Canceled THEN
                    ApprovalRequestCanceled := TRUE;
            END;
        END;
    end;
}


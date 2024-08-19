codeunit 50023 "HR Job Management WS"
{

    trigger OnRun()
    begin
    end;

    var
        SERVERDIRECTORYPATH: Label 'C:\inetpub\wwwroot\HWWK\EmployeeData\';
        TxtCharsToKeep: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        HROnlineApplicant: Record "HR  Online Applicant";
        HRJobApplication: Record "HR Job Applications";
        HRJobApplication2: Record "HR Job Applications";
        Dates: Codeunit Dates;
        HRJobs: Record "HR Jobs";
        HRJobLookupValues: Record "HR Job Lookup Value";
        HRJobApplicantQualifications: Record "HR Job Applicant Qualification";
        HRApplicantEmploymentHist: Record "HR Applicant Employment Hist";
        HRApplicantWorkExperience: Record "HR Job Online Requirements";
        Employee: Record Employee;
        FileName: Text;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        HRJobQualifications: Record "HR Job Qualifications";
        HRJobApplicantDataDirectory: Text;
        HRTrainingNeedsHeader: Record "HR Training Needs Header";
        HRTrainingNeedsLine: Record "HR Training Needs Line";
        HRApplicantRefereeLine: Record "HR Online Referee Details";
        CompanyDataDirectory: Text;
        CompanyInformation: Record "Company Information";
        HumanResourcesSetup: Record "Human Resources Setup";
        HRJobsData: Text;
        HRApplicantAccountWS: Codeunit "HR Applicant Account WS";

    procedure CreateHROnlineApplicantDirectory(EmailAddress: Text[100])
    var
        CompanyDataDirectory: Text;
        HROnlineApplicantDataDirectory: Text;
        //   [RunOnClient]
        // DirectoryHelper: DotNet Directory;
        DirectoryPath: Label '%1\%2\%3';
        HROnlineApplicantDirectoryPath: Text;
    begin
        CompanyInformation.GET;
        HumanResourcesSetup.GET;
        CompanyInformation.TESTFIELD(CompanyInformation."Company Data Directory Path");
        HumanResourcesSetup.TESTFIELD(HumanResourcesSetup."HR Job Applicant Data Dir.Name");
        CompanyDataDirectory := CompanyInformation."Company Data Directory Path";
        HROnlineApplicantDataDirectory := HumanResourcesSetup."HR Job Applicant Data Dir.Name";

        HROnlineApplicantDirectoryPath := STRSUBSTNO(DirectoryPath, CompanyDataDirectory, HROnlineApplicantDataDirectory, EmailAddress);
        /* 
                IF NOT DirectoryHelper.Exists(HROnlineApplicantDirectoryPath) THEN BEGIN
                    DirectoryHelper.CreateDirectory(HROnlineApplicantDirectoryPath);
            END; */
    end;

    procedure CheckOpenJobApplicationExists(EmailAddress: Code[20]) OpeNJobApplicantionExist: Boolean
    begin
        OpeNJobApplicantionExist := FALSE;
        HRJobApplication.RESET;
        HRJobApplication.SETRANGE(HRJobApplication."Email Address", EmailAddress);
        HRJobApplication.SETRANGE(HRJobApplication.Status, HRJobApplication.Status::Open);
        IF HRJobApplication.FINDFIRST THEN BEGIN
            OpeNJobApplicantionExist := TRUE;
        END;
    end;

    procedure GetJobApplicationNo(EmailAddress: Text[100]) JobApplicationNo: Code[30]
    begin
        JobApplicationNo := '';
        HRJobApplication.RESET;
        HRJobApplication.SETRANGE(HRJobApplication."Personal Email Address", EmailAddress);
        HRJobApplication.SETRANGE(HRJobApplication.Status, HRJobApplication.Status::Open);
        IF HRJobApplication.FINDFIRST THEN BEGIN
            JobApplicationNo := HRJobApplication."No.";
        END;
    end;

    procedure CheckHRJobApplicationQualificationExist(EmailAddress: Text[100]) QualificationsLinesExist: Boolean
    begin
        QualificationsLinesExist := FALSE;
        HRJobApplicantQualifications.RESET;
        HRJobApplicantQualifications.SETRANGE(HRJobApplicantQualifications."E-mail", EmailAddress);
        IF HRJobApplicantQualifications.FINDFIRST THEN BEGIN
            QualificationsLinesExist := TRUE;
        END;
    end;

    procedure CreateHRJobApplicationQualificationLine(EmailAddress: Text[100]; QualificationCode: Code[50]; QualificationName: Text[100]; InstitutionName: Code[100]; QualificationCadre: Code[50]; GraduationYear: Date) JobQualificationsLineCreated: Boolean
    begin
        JobQualificationsLineCreated := FALSE;
        HRJobApplicantQualifications.INIT;
        HRJobApplicantQualifications."E-mail" := EmailAddress;
        HRJobApplicantQualifications."Qualification Code" := QualificationCode;
        HRJobApplicantQualifications."Qualification Name" := QualificationName;
        HRJobApplicantQualifications.VALIDATE(HRJobApplicantQualifications."Qualification Code");
        // HRJobApplicantQualifications."Joining Date":=FromYear;
        // HRJobApplicantQualifications."Completion Date":=ToYear;
        HRJobApplicantQualifications."Institution Name" := InstitutionName;
        HRJobApplicantQualifications.Award := QualificationCadre;
        HRJobApplicantQualifications."Award Date" := GraduationYear;
        IF HRJobApplicantQualifications.INSERT THEN BEGIN
            JobQualificationsLineCreated := TRUE;
        END;
    end;

    procedure ModifyHRJobApplicationQualificationLine("Line No.": Integer; EmailAddress: Text[100]; QualificationCode: Code[50]; QualificationName: Text[100]; InstitutionName: Code[100]; QualificationCadre: Code[50]; GraduationYear: Date) JobQualificationsLineModified: Boolean
    begin
        JobQualificationsLineModified := FALSE;
        HRJobApplicantQualifications.RESET;
        HRJobApplicantQualifications.SETRANGE("Line No.", "Line No.");
        HRJobApplicantQualifications.SETRANGE("E-mail", EmailAddress);
        IF HRJobApplicantQualifications.FINDFIRST THEN BEGIN
            HRJobApplicantQualifications."Qualification Code" := QualificationCode;
            HRJobApplicantQualifications."Qualification Name" := QualificationName;
            HRJobApplicantQualifications.VALIDATE(HRJobApplicantQualifications."Qualification Code");
            // HRJobApplicantQualifications."Joining Date":=FromYear;
            // HRJobApplicantQualifications."Completion Date":=ToYear;
            HRJobApplicantQualifications."Institution Name" := InstitutionName;
            HRJobApplicantQualifications.Award := QualificationCadre;
            HRJobApplicantQualifications."Award Date" := GraduationYear;
            IF HRJobApplicantQualifications.MODIFY THEN BEGIN
                JobQualificationsLineModified := TRUE;
            END;
        END;
    end;

    procedure DeleteHRJobApplicationQualificationLine("LineNo.": Integer; EmailAddress: Text[100]) JobQualificationLineDeleted: Boolean
    begin
        JobQualificationLineDeleted := FALSE;
        HRJobApplicantQualifications.RESET;
        HRJobApplicantQualifications.SETRANGE(HRJobApplicantQualifications."Line No.", "LineNo.");
        HRJobApplicantQualifications.SETRANGE(HRJobApplicantQualifications."E-mail", EmailAddress);
        IF HRJobApplicantQualifications.FINDFIRST THEN BEGIN
            IF HRJobApplicantQualifications.DELETE THEN BEGIN
                JobQualificationLineDeleted := TRUE;
            END;
        END;
    end;

    procedure ValidateHRJobApplicationQualificationLines(EmailAddress: Text[100]) JobQualificationLinesError: Text
    var
        "JobQualificationLineNo.": Integer;
    begin
        JobQualificationLinesError := '';
        "JobQualificationLineNo." := 0;
        HRJobApplicantQualifications.RESET;
        HRJobApplicantQualifications.SETRANGE(HRJobApplicantQualifications."E-mail", EmailAddress);
        IF HRJobApplicantQualifications.FINDSET THEN BEGIN
            REPEAT
                "JobQualificationLineNo." := "JobQualificationLineNo." + 1;
                IF HRJobApplicantQualifications."E-mail" = '' THEN BEGIN
                    JobQualificationLinesError := 'Email address. missing on line no.' + FORMAT("JobQualificationLineNo.") + ', it should not cannot be zero or empty';
                    BREAK;
                END;
            UNTIL HRJobApplicantQualifications.NEXT = 0;
        END;
    end;

    procedure CheckMandatoryAcademicRequirements(EmailAddress: Text[100]; "EmployeeRequisitionNo.": Code[20]) RequirementsMet: Boolean
    var
        HRJobRequirements: Record "HR Job Requirements";
        HRJobApplicantRequirements: Record "HR Job Applicant Requirement";
        EmployeeRequisitions: Record "HR Employee Requisitions";
    begin
        RequirementsMet := FALSE;
        EmployeeRequisitions.GET("EmployeeRequisitionNo.");
        //Check Mandatory Academic Qualifications
        HRJobQualifications.RESET;
        HRJobQualifications.SETRANGE("Job No.", EmployeeRequisitions."Job No.");
        HRJobQualifications.SETRANGE(Mandatory, TRUE);
        IF HRJobQualifications.FINDSET THEN BEGIN
            REPEAT
                HRJobApplicantQualifications.RESET;
                HRJobApplicantQualifications.SETRANGE("E-mail", EmailAddress);
                HRJobApplicantQualifications.SETRANGE("Qualification Code", HRJobQualifications."Qualification Code");
                IF HRJobApplicantQualifications.FINDFIRST THEN BEGIN
                    RequirementsMet := TRUE;
                END ELSE BEGIN
                    RequirementsMet := FALSE;
                    EXIT(RequirementsMet);
                END;
            UNTIL HRJobQualifications.NEXT = 0;
            EXIT(RequirementsMet);
        END;
    end;

    procedure CheckJobMandatoryRequirements(EmailAddress: Text[100]; "EmployeeRequisitionNo.": Code[20]) RequirementsMet: Boolean
    var
        HRJobRequirements: Record "HR Job Requirements";
        HRJobApplicantRequirements: Record "HR Job Applicant Requirement";
        EmployeeRequisitions: Record "HR Employee Requisitions";
    begin
        RequirementsMet := FALSE;
        EmployeeRequisitions.GET("EmployeeRequisitionNo.");
        //Check Mandatory Requirements
        HRJobRequirements.RESET;
        HRJobRequirements.SETRANGE("Job No.", EmployeeRequisitions."Job No.");
        HRJobRequirements.SETRANGE(Mandatory, TRUE);
        IF HRJobRequirements.FINDSET THEN BEGIN
            REPEAT
                HRJobApplicantRequirements.RESET;
                HRJobApplicantRequirements.SETRANGE("E-mail", EmailAddress);
                HRJobApplicantRequirements.SETRANGE("Requirement Code", HRJobRequirements."Requirement Code");
                IF HRJobApplicantRequirements.FINDFIRST THEN BEGIN
                    RequirementsMet := TRUE;
                END ELSE BEGIN
                    RequirementsMet := FALSE;
                    EXIT(RequirementsMet);
                END;
            UNTIL HRJobRequirements.NEXT = 0;
        END ELSE BEGIN
            RequirementsMet := TRUE;
        END;
        EXIT(RequirementsMet);
    end;

    procedure CreateApplicantWorkExperienceLine(EmailAddress: Text[100]; ExperienceType: Code[50]; Description: Text[250]; "No. Of Years": Integer) ApplicantWorkExperienceCreated: Boolean
    var
        Text0001: Label 'Kwera';
    begin
        ApplicantWorkExperienceCreated := FALSE;
        HRApplicantWorkExperience.INIT;
        HRApplicantWorkExperience."E-mail" := EmailAddress;
        HRApplicantWorkExperience."Requirement Code" := ExperienceType;
        HRApplicantWorkExperience.Description := Description;
        HRApplicantWorkExperience."No. of Years" := "No. Of Years";
        IF HRApplicantWorkExperience.INSERT THEN
            ApplicantWorkExperienceCreated := TRUE;
    end;

    procedure ModifyApplicantWorkExperienceLine(LineNo: Integer; EmailAddress: Text[100]; ExperienceType: Code[50]; Description: Text[250]; "No. Of Years": Integer) HRApplicantWorkExperienceLineModified: Boolean
    begin
        HRApplicantWorkExperienceLineModified := FALSE;
        HRApplicantWorkExperience.RESET;
        HRApplicantWorkExperience.SETRANGE(HRApplicantWorkExperience."Line No", LineNo);
        HRApplicantWorkExperience.SETRANGE("E-mail", EmailAddress);
        IF HRApplicantWorkExperience.FINDFIRST THEN BEGIN
            HRApplicantWorkExperience."Requirement Code" := ExperienceType;
            HRApplicantWorkExperience.Description := Description;
            HRApplicantWorkExperience."No. of Years" := "No. Of Years";
            IF HRApplicantWorkExperience.MODIFY THEN BEGIN
                HRApplicantWorkExperienceLineModified := TRUE;
            END;
        END;
    end;

    procedure DeleteApplicantWorkExperienceLine("LineNo.": Integer; EmailAddress: Text[100]) HRApplicantWorkExperienceLineDeleted: Boolean
    begin
        HRApplicantWorkExperienceLineDeleted := FALSE;
        HRApplicantWorkExperience.RESET;
        HRApplicantWorkExperience.SETRANGE(HRApplicantWorkExperience."Line No", "LineNo.");
        HRApplicantWorkExperience.SETRANGE(HRApplicantWorkExperience."E-mail", EmailAddress);
        IF HRApplicantWorkExperience.FINDFIRST THEN BEGIN
            IF HRApplicantWorkExperience.DELETE THEN BEGIN
                HRApplicantWorkExperienceLineDeleted := TRUE;
            END;
        END;
    end;

    procedure CreateProfessionalCertificationLine(EmailAddress: Text[100]; Description: Text[250]) ProfessionalCertificationCreated: Boolean
    var
        Text0001: Label 'Kwera';
    begin
        ProfessionalCertificationCreated := FALSE;
        HRApplicantWorkExperience.INIT;
        HRApplicantWorkExperience."E-mail" := EmailAddress;
        HRApplicantWorkExperience."Requirement Code" := 'OTHER';
        HRApplicantWorkExperience.Description := Description;
        IF HRApplicantWorkExperience.INSERT THEN
            ProfessionalCertificationCreated := TRUE;
    end;

    procedure ModifyProfessionalCertificationLine(LineNo: Integer; EmailAddress: Text[100]; Description: Text[250]) ProfessionalCertificationLineModified: Boolean
    begin
        ProfessionalCertificationLineModified := FALSE;
        HRApplicantWorkExperience.RESET;
        HRApplicantWorkExperience.SETRANGE(HRApplicantWorkExperience."Line No", LineNo);
        HRApplicantWorkExperience.SETRANGE("E-mail", EmailAddress);
        IF HRApplicantWorkExperience.FINDFIRST THEN BEGIN
            HRApplicantWorkExperience."Requirement Code" := 'OTHER';
            HRApplicantWorkExperience.Description := Description;
            IF HRApplicantWorkExperience.MODIFY THEN BEGIN
                ProfessionalCertificationLineModified := TRUE;
            END;
        END;
    end;

    procedure DeleteProfessionalCertificationLine("LineNo.": Integer; EmailAddress: Text[100]) ProfessionalCertificationLineDeleted: Boolean
    begin
        ProfessionalCertificationLineDeleted := FALSE;
        HRApplicantWorkExperience.RESET;
        HRApplicantWorkExperience.SETRANGE(HRApplicantWorkExperience."Line No", "LineNo.");
        HRApplicantWorkExperience.SETRANGE(HRApplicantWorkExperience."E-mail", EmailAddress);
        IF HRApplicantWorkExperience.FINDFIRST THEN BEGIN
            IF HRApplicantWorkExperience.DELETE THEN BEGIN
                ProfessionalCertificationLineDeleted := TRUE;
            END;
        END;
    end;

    procedure ValidateApplicantWorkExperienceLines(EmailAddress: Text[100]) HRApplicantWkExpLineError: Text
    var
        "HRApplicantWkExpLineNo.": Integer;
    begin
        HRApplicantWkExpLineError := '';
        "HRApplicantWkExpLineNo." := 0;
        HRApplicantWorkExperience.RESET;
        HRApplicantWorkExperience.SETRANGE(HRApplicantWorkExperience."E-mail", EmailAddress);
        IF HRApplicantWorkExperience.FINDSET THEN BEGIN
            REPEAT
                "HRApplicantWkExpLineNo." := "HRApplicantWkExpLineNo." + 1;
                IF HRApplicantWorkExperience."E-mail" = '' THEN BEGIN
                    HRApplicantWkExpLineError := 'Email address. missing on line no.' + FORMAT("HRApplicantWkExpLineNo.") + ', it should not cannot be zero or empty';
                    BREAK;
                END;
            UNTIL HRApplicantWorkExperience.NEXT = 0;
        END;
    end;

    procedure CreateApplicantEmploymentHistLine(EmailAddress: Text[100]; EmployerName: Code[50]; EmploymentFromDate: Date; EmploymentToDate: Date; Designation: Text; Salary: Decimal) EmploymentHistoryCreated: Boolean
    begin
        EmploymentHistoryCreated := FALSE;
        HROnlineApplicant.RESET;
        HROnlineApplicant.SETRANGE("Email Address", EmailAddress);
        IF HROnlineApplicant.FINDFIRST THEN BEGIN
            HRApplicantEmploymentHist.INIT;
            HRApplicantEmploymentHist."E-mail" := HROnlineApplicant."Email Address";
            HRApplicantEmploymentHist."Employer Name/Organization" := EmployerName;
            //HRApplicantEmploymentHist."Address of the Organization":=EmployerAddress;
            HRApplicantEmploymentHist."From Date" := EmploymentFromDate;
            HRApplicantEmploymentHist."To Date" := EmploymentToDate;
            HRApplicantEmploymentHist.VALIDATE(HRApplicantEmploymentHist."To Date");
            HRApplicantEmploymentHist."Job Designation/Position Held" := Designation;
            HRApplicantEmploymentHist."Gross Salary" := Salary;
            IF HRApplicantEmploymentHist.INSERT THEN BEGIN
                EmploymentHistoryCreated := TRUE;
            END;
        END
    end;

    procedure ModifyApplicantEmploymentHistLine(LineNo: Integer; EmailAddress: Text[100]; EmployerName: Code[50]; EmploymentFromDate: Date; EmploymentToDate: Date; Designation: Text; Salary: Decimal) HRApplicantEmpHistLineModified: Boolean
    begin
        HRApplicantEmpHistLineModified := FALSE;
        HRApplicantEmploymentHist.RESET;
        HRApplicantEmploymentHist.SETRANGE(HRApplicantEmploymentHist."Line No", LineNo);
        HRApplicantEmploymentHist.SETRANGE("E-mail", EmailAddress);
        IF HRApplicantEmploymentHist.FINDFIRST THEN BEGIN
            HRApplicantEmploymentHist."Employer Name/Organization" := EmployerName;
            //HRApplicantEmploymentHist."Address of the Organization":=EmployerAddress;
            HRApplicantEmploymentHist."From Date" := EmploymentFromDate;
            HRApplicantEmploymentHist."To Date" := EmploymentToDate;
            HRApplicantEmploymentHist."Job Designation/Position Held" := Designation;
            HRApplicantEmploymentHist."Gross Salary" := Salary;
            IF HRApplicantEmploymentHist.MODIFY THEN BEGIN
                HRApplicantEmpHistLineModified := TRUE;
            END;
        END;
    end;

    procedure DeleteApplicantEmploymentHistLine("LineNo.": Integer; EmailAddress: Text[100]) ApplicantEmploymentHistLineDeleted: Boolean
    begin
        ApplicantEmploymentHistLineDeleted := FALSE;
        HRApplicantEmploymentHist.RESET;
        HRApplicantEmploymentHist.SETRANGE(HRApplicantEmploymentHist."Line No", "LineNo.");
        HRApplicantEmploymentHist.SETRANGE(HRApplicantEmploymentHist."E-mail", EmailAddress);
        IF HRApplicantEmploymentHist.FINDFIRST THEN BEGIN
            IF HRApplicantEmploymentHist.DELETE THEN BEGIN
                ApplicantEmploymentHistLineDeleted := TRUE;
            END;
        END;
    end;

    procedure ValidateApplicantEmploymentHistLines(EmailAddress: Text[100]) ApplicantEmploymentHistLineError: Text
    var
        "ApplicantEmploymentHistLineNo.": Integer;
    begin
        ApplicantEmploymentHistLineError := '';
        "ApplicantEmploymentHistLineNo." := 0;
        HRApplicantEmploymentHist.RESET;
        HRApplicantEmploymentHist.SETRANGE(HRApplicantEmploymentHist."E-mail", EmailAddress);
        IF HRApplicantEmploymentHist.FINDSET THEN BEGIN
            REPEAT
                "ApplicantEmploymentHistLineNo." := "ApplicantEmploymentHistLineNo." + 1;
                IF HRApplicantEmploymentHist."E-mail" = '' THEN BEGIN
                    ApplicantEmploymentHistLineError := 'Email address. missing on line no.' + FORMAT("ApplicantEmploymentHistLineNo.") + ', it should not cannot be empty';
                    BREAK;
                END;
            UNTIL HRApplicantWorkExperience.NEXT = 0;
        END;
    end;

    procedure CreateProfessionalRefereeLine(EmailAddress: Text[100]; FirstName: Code[30]; MiddleName: Code[30]; Surname: Code[30]; RefereeEmail: Text[100]; Address: Text[100]; PostalCode: Code[50]; PhysicalAddress: Text[100]) ProfessionalRefereeLineCreated: Boolean
    begin
        ProfessionalRefereeLineCreated := FALSE;
        HRApplicantRefereeLine.INIT;
        HRApplicantRefereeLine."Applicant E-mail" := EmailAddress;
        HRApplicantRefereeLine.Firstname := FirstName;
        HRApplicantRefereeLine.Middlename := MiddleName;
        HRApplicantRefereeLine.Surname := Surname;
        HRApplicantRefereeLine."Personal E-Mail Address" := RefereeEmail;
        HRApplicantRefereeLine."Postal Address" := Address;
        HRApplicantRefereeLine."Post Code" := PostalCode;
        HRApplicantRefereeLine."Residential Address" := PhysicalAddress;
        HRApplicantRefereeLine."Referee Category" := HRApplicantRefereeLine."Referee Category"::Professional;
        IF HRApplicantRefereeLine.INSERT THEN BEGIN
            ProfessionalRefereeLineCreated := TRUE;
        END;
    end;

    procedure ModifyProfessionalRefereeLine(LineNo: Integer; EmailAddress: Text[100]; FirstName: Code[30]; MiddleName: Code[30]; Surname: Code[30]; RefereeEmail: Text[100]; Address: Text[100]; PostalCode: Code[50]; PhysicalAddress: Text[100]) ProfessionalRefereeLineModified: Boolean
    begin
        ProfessionalRefereeLineModified := FALSE;
        HRApplicantRefereeLine.RESET;
        HRApplicantRefereeLine.SETRANGE(HRApplicantRefereeLine."Line No.", LineNo);
        HRApplicantRefereeLine.SETRANGE("Applicant E-mail", EmailAddress);
        IF HRApplicantRefereeLine.FINDFIRST THEN BEGIN
            HRApplicantRefereeLine."Applicant E-mail" := EmailAddress;
            HRApplicantRefereeLine.Firstname := FirstName;
            HRApplicantRefereeLine.Middlename := MiddleName;
            HRApplicantRefereeLine.Surname := Surname;
            HRApplicantRefereeLine."Personal E-Mail Address" := RefereeEmail;
            HRApplicantRefereeLine."Postal Address" := Address;
            HRApplicantRefereeLine."Post Code" := PostalCode;
            HRApplicantRefereeLine."Residential Address" := PhysicalAddress;
            HRApplicantRefereeLine."Referee Category" := HRApplicantRefereeLine."Referee Category"::Professional;
            IF HRApplicantRefereeLine.MODIFY THEN BEGIN
                ProfessionalRefereeLineModified := TRUE;
            END;
        END;
    end;

    procedure DeleteProfessionalRefereeLine("LineNo.": Integer; EmailAddress: Text[100]) ProfessionalRefereeLineDeleted: Boolean
    begin
        ProfessionalRefereeLineDeleted := FALSE;
        HRApplicantRefereeLine.RESET;
        HRApplicantRefereeLine.SETRANGE(HRApplicantRefereeLine."Line No.", "LineNo.");
        HRApplicantRefereeLine.SETRANGE(HRApplicantRefereeLine."Applicant E-mail", EmailAddress);
        IF HRApplicantRefereeLine.FINDFIRST THEN BEGIN
            IF HRApplicantRefereeLine.DELETE THEN BEGIN
                ProfessionalRefereeLineDeleted := TRUE;
            END;
        END;
    end;

    procedure CreatePersonalRefereeLine(EmailAddress: Text[100]; FirstName: Code[30]; MiddleName: Code[30]; Surname: Code[30]; RefereeEmail: Text[100]; Address: Text[100]; PostalCode: Text[250]; PhysicalAddress: Text[100]) PersonalRefereeLineCreated: Boolean
    begin
        PersonalRefereeLineCreated := FALSE;
        HRApplicantRefereeLine.INIT;
        HRApplicantRefereeLine."Applicant E-mail" := EmailAddress;
        HRApplicantRefereeLine.Firstname := FirstName;
        HRApplicantRefereeLine.Middlename := MiddleName;
        HRApplicantRefereeLine.Surname := Surname;
        HRApplicantRefereeLine."Personal E-Mail Address" := RefereeEmail;
        HRApplicantRefereeLine."Postal Address" := Address;
        HRApplicantRefereeLine."Post Code" := PostalCode;
        HRApplicantRefereeLine."Residential Address" := PhysicalAddress;
        HRApplicantRefereeLine."Referee Category" := HRApplicantRefereeLine."Referee Category"::Personal;
        IF HRApplicantRefereeLine.INSERT THEN BEGIN
            PersonalRefereeLineCreated := TRUE;
        END;
    end;

    procedure ModifyPersonalRefereeLine(LineNo: Integer; EmailAddress: Text[100]; FirstName: Code[30]; MiddleName: Code[30]; Surname: Code[30]; RefereeEmail: Text[100]; Address: Text[250]; PostalCode: Text[250]; PhysicalAddress: Text[100]) PersonalRefereeLineModified: Boolean
    begin
        PersonalRefereeLineModified := FALSE;
        HRApplicantRefereeLine.RESET;
        HRApplicantRefereeLine.SETRANGE(HRApplicantRefereeLine."Line No.", LineNo);
        HRApplicantRefereeLine.SETRANGE("Applicant E-mail", EmailAddress);
        IF HRApplicantRefereeLine.FINDFIRST THEN BEGIN
            HRApplicantRefereeLine."Applicant E-mail" := EmailAddress;
            HRApplicantRefereeLine.Firstname := FirstName;
            HRApplicantRefereeLine.Middlename := MiddleName;
            HRApplicantRefereeLine.Surname := Surname;
            HRApplicantRefereeLine."Personal E-Mail Address" := RefereeEmail;
            HRApplicantRefereeLine."Postal Address" := Address;
            HRApplicantRefereeLine."Post Code" := PostalCode;
            HRApplicantRefereeLine."Residential Address" := PhysicalAddress;
            HRApplicantRefereeLine."Referee Category" := HRApplicantRefereeLine."Referee Category"::Personal;
            IF HRApplicantRefereeLine.MODIFY THEN BEGIN
                PersonalRefereeLineModified := TRUE;
            END;
        END;
    end;

    procedure DeletePersonalRefereeLine("LineNo.": Integer; EmailAddress: Text[100]) PersonalRefereeLineDeleted: Boolean
    begin
        PersonalRefereeLineDeleted := FALSE;
        HRApplicantRefereeLine.RESET;
        HRApplicantRefereeLine.SETRANGE(HRApplicantRefereeLine."Line No.", "LineNo.");
        HRApplicantRefereeLine.SETRANGE(HRApplicantRefereeLine."Applicant E-mail", EmailAddress);
        IF HRApplicantRefereeLine.FINDFIRST THEN BEGIN
            IF HRApplicantRefereeLine.DELETE THEN BEGIN
                PersonalRefereeLineDeleted := TRUE;
            END;
        END;
    end;

    procedure CheckJobApplicationLowerAgeLimit(EmailAddress: Text[100]) LimitedAge: Boolean
    begin
        LimitedAge := FALSE;
        HumanResourcesSetup.GET;

        HROnlineApplicant.RESET;
        HROnlineApplicant.SETRANGE(HROnlineApplicant."Email Address", EmailAddress);
        IF HROnlineApplicant.FINDFIRST THEN BEGIN
            IF Dates.DetermineAge_Years(HROnlineApplicant."Date of Birth", TODAY) < HumanResourcesSetup."Job App. Lower Age Limit" THEN
                LimitedAge := TRUE;
        END;


        /*HumanResourcesSetup.GET;
        IF Dates.DetermineAge_Years(DateOfBirth,TODAY) < HumanResourcesSetup."Job App. Lower Age Limit" THEN
          LimitedAge:=TRUE ELSE
          LimitedAge:=FALSE;*/

    end;

    procedure CheckJobApplicationHigherAgeLimit(EmailAddress: Text[100]) LimitedAge: Boolean
    begin
        LimitedAge := FALSE;
        HumanResourcesSetup.GET;

        HROnlineApplicant.RESET;
        HROnlineApplicant.SETRANGE(HROnlineApplicant."Email Address", EmailAddress);
        IF HROnlineApplicant.FINDFIRST THEN BEGIN
            IF Dates.DetermineAge_Years(HROnlineApplicant."Date of Birth", TODAY) > HumanResourcesSetup."Job App. Upper Age Limit" THEN
                LimitedAge := TRUE;
        END;
        /*HumanResourcesSetup.GET;
        IF Dates.DetermineAge_Years(DateOfBirth,TODAY) > HumanResourcesSetup."Job App. Upper Age Limit" THEN
          LimitedAge:=TRUE ELSE
          LimitedAge:=FALSE;*/

    end;

    procedure CheckSubmittedJobApplicationExists(EmailAddress: Text[100]; EmployeeRequisitionNo: Code[20]) SubmittedApplicationExist: Boolean
    var
        error0001: Label 'A similar application for %1 exist. Please find a different vacancy to apply.';
    begin
        SubmittedApplicationExist := FALSE;
        HRJobApplication.RESET;
        HRJobApplication.SETRANGE(HRJobApplication."Email Address", EmailAddress);
        HRJobApplication.SETRANGE(HRJobApplication."Employee Requisition No.", EmployeeRequisitionNo);
        IF HRJobApplication.FINDFIRST THEN BEGIN
            SubmittedApplicationExist := TRUE;
        END;
    end;

    procedure CreateJobApplication(EmployeeRequisitionNo: Code[50]; EmailAddress: Text[100]) JobApplicationCreated: Boolean
    var
        HRJobQualifications: Record "HR Job Qualifications";
        HREmployeeRequisitions: Record "HR Employee Requisitions";
        HRJobOnlineRequirements: Record "HR Job Online Requirements";
        HRJobApplicantRequirements: Record "HR Job Applicant Requirement";
        error0001: Label '% 1 not found';
        HRJobOnlineQualifications: Record "HR Job Online Qualifications";
        HRJobApplicantQualification: Record "HR Job Applicant Qualification";
        HRJobApplicantRequirement: Record "HR Job Applicant Requirement";
        HROnlineEmploymentHist: Record "HR Online Employment Hist.";
        HRApplicantEmploymentHist: Record "HR Applicant Employment Hist";
        HROnlineRefereeDetails: Record "HR Online Referee Details";
        HRApplicantRefereeDetails: Record "HR Applicant Referee Details";
    begin
        JobApplicationCreated := FALSE;

        HROnlineApplicant.GET(EmailAddress);

        //Check similar application exist
        CheckSubmittedJobApplicationExists(HROnlineApplicant."Email Address", EmployeeRequisitionNo);

        /*//Check cover letter attached
        HRApplicantAccountWS.CheckCoverLetterAttached(HROnlineApplicant."Email Address");
        
        //Check Cv attached
        HRApplicantAccountWS.CheckCurriculumVitaeAttached(HROnlineApplicant."Email Address");*/

        HumanResourcesSetup.GET;

        HROnlineApplicant.RESET;
        HROnlineApplicant.SETRANGE("Email Address", EmailAddress);
        IF HROnlineApplicant.FINDFIRST THEN BEGIN
            HRJobApplication.INIT;
            HRJobApplication."Email Address" := HROnlineApplicant."Email Address";
            HRJobApplication."Employee Requisition No." := EmployeeRequisitionNo;
            HRJobApplication."No." := NoSeriesMgt.GetNextNo(HumanResourcesSetup."Job Application Nos.", 0D, TRUE);
            HRJobApplication.VALIDATE(HRJobApplication."Employee Requisition No.");
            HRJobApplication.Firstname := HROnlineApplicant.Firstname;
            HRJobApplication.Middlename := HROnlineApplicant.Middlename;
            HRJobApplication.Surname := HROnlineApplicant.Surname;
            HRJobApplication."Personal Email Address" := HROnlineApplicant."Email Address";
            HRJobApplication."Date of Birth" := HROnlineApplicant."Date of Birth";
            HRJobApplication."National ID No." := HROnlineApplicant."National ID No.";
            HRJobApplication."Residential Address" := HROnlineApplicant.Address;
            HRJobApplication.Gender := HROnlineApplicant.Gender;
            HRJobApplication."County Name" := HROnlineApplicant."County Name";
            HRJobApplication."Ethnic Group" := HROnlineApplicant."Ethnic Group";
            HRJobApplication."Marital Status" := HROnlineApplicant."Marital Status";
            HRJobApplication.Religion := HROnlineApplicant.Religion;
            HRJobApplication.Citizenship := HROnlineApplicant.Citizenship;
            HRJobApplication."Mobile Phone No." := HROnlineApplicant."Mobile Phone No.";
            HRJobApplication."Person Living With Disability" := HROnlineApplicant."Person With Disability";
            HRJobApplication."Application Date" := TODAY;
            IF HRJobApplication.INSERT THEN BEGIN
                HRJobApplication2.RESET;
                HRJobApplication2.SETRANGE(HRJobApplication2."No.", HRJobApplication."No.");
                IF HRJobApplication2.FINDFIRST THEN BEGIN
                    HRJobApplication2.Status := HRJobApplication2.Status::Submitted;
                    HRJobApplication2.ShortListed := TRUE;
                    HRJobApplication2."Application Date" := TODAY;
                    HRJobApplication2.MODIFY;
                END;
                JobApplicationCreated := TRUE;
            END;
        END;

        //Job Application Qualifications
        HRJobOnlineQualifications.RESET;
        HRJobOnlineQualifications.SETRANGE(HRJobOnlineQualifications."E-mail", EmailAddress);
        IF HRJobOnlineQualifications.FINDSET THEN BEGIN
            REPEAT
                HRJobApplicantQualification.INIT;
                HRJobApplicantQualification."Line No." := 0;
                HRJobApplicantQualification."Job Application No." := HRJobApplication."No.";
                HRJobApplicantQualification."Qualification Code" := HRJobOnlineQualifications."Qualification Code";
                HRJobApplicantQualification."Qualification Name" := HRJobOnlineQualifications."Qualification Name";
                HRJobApplicantQualification."Joining Date" := HRJobOnlineQualifications."Joining Date";
                HRJobApplicantQualification."Completion Date" := HRJobOnlineQualifications."Completion Date";
                HRJobApplicantQualification.Award := HRJobOnlineQualifications.Award;
                HRJobApplicantQualification."Award Date" := HRJobOnlineQualifications."Award Date";
                HRJobApplicantQualification."E-mail" := HRJobOnlineQualifications."E-mail";
                HRJobApplicantQualification.INSERT;
            UNTIL HRJobOnlineQualifications.NEXT = 0;
        END;

        //applicant employment history
        HROnlineEmploymentHist.RESET;
        HROnlineEmploymentHist.SETRANGE(HROnlineEmploymentHist."E-mail", EmailAddress);
        IF HROnlineEmploymentHist.FINDSET THEN BEGIN
            REPEAT
                HRApplicantEmploymentHist."Line No" := 0;
                HRApplicantEmploymentHist."Job Application No." := HRJobApplication."No.";
                HRApplicantEmploymentHist."Employer Name/Organization" := HROnlineEmploymentHist."Employer Name/Organization";
                HRApplicantEmploymentHist."Address of the Organization" := HROnlineEmploymentHist."Address of the Organization";
                HRApplicantEmploymentHist."Job Designation/Position Held" := HROnlineEmploymentHist."Job Designation/Position Held";
                HRApplicantEmploymentHist."From Date" := HROnlineEmploymentHist."From Date";
                HRApplicantEmploymentHist."To Date" := HROnlineEmploymentHist."To Date";
                HRApplicantEmploymentHist."Days/Years of service" := HROnlineEmploymentHist."Days/Years of service";
                HRApplicantEmploymentHist."Gross Salary" := HROnlineEmploymentHist."Gross Salary";
                HRApplicantEmploymentHist.Benefits := HROnlineEmploymentHist.Benefits;
                HRApplicantEmploymentHist."E-mail" := HROnlineEmploymentHist."E-mail";
                HRApplicantEmploymentHist.INSERT;
            UNTIL HROnlineEmploymentHist.NEXT = 0;
        END;

        // applicant referees
        HROnlineRefereeDetails.RESET;
        HROnlineRefereeDetails.SETRANGE(HROnlineRefereeDetails."Applicant E-mail", EmailAddress);
        IF HROnlineRefereeDetails.FINDSET THEN BEGIN
            REPEAT
                HRApplicantRefereeDetails."Line No." := 0;
                HRApplicantRefereeDetails."Job Application  No." := HRJobApplication."No.";
                HRApplicantRefereeDetails.Surname := HROnlineRefereeDetails.Surname;
                HRApplicantRefereeDetails.Firstname := HROnlineRefereeDetails.Firstname;
                HRApplicantRefereeDetails.Middlename := HROnlineRefereeDetails.Middlename;
                HRApplicantRefereeDetails."Personal E-Mail Address" := HROnlineRefereeDetails."Personal E-Mail Address";
                HRApplicantRefereeDetails."Postal Address" := HROnlineRefereeDetails."Postal Address";
                HRApplicantRefereeDetails."Post Code" := HROnlineRefereeDetails."Post Code";
                HRApplicantRefereeDetails."Residential Address" := HROnlineRefereeDetails."Residential Address";
                HRApplicantRefereeDetails."Referee Category" := HROnlineRefereeDetails."Referee Category";
                HRApplicantRefereeDetails.Verified := FALSE;
                HRApplicantRefereeDetails."Applicant E-mail" := HROnlineRefereeDetails."Applicant E-mail";
                HRApplicantRefereeDetails.County := HROnlineRefereeDetails.County;
                HRApplicantRefereeDetails."Mobile No." := HROnlineRefereeDetails."Mobile No.";
                HRApplicantRefereeDetails."Country/Region Code" := HROnlineRefereeDetails."Country/Region Code";
                HRApplicantRefereeDetails.INSERT;
            UNTIL HROnlineRefereeDetails.NEXT = 0;
        END;

        HRJobOnlineRequirements.RESET;
        HRJobOnlineRequirements.SETRANGE(HRJobOnlineRequirements."E-mail", EmailAddress);
        IF HRJobOnlineRequirements.FINDSET THEN BEGIN
            REPEAT
                HRJobApplicantRequirement.INIT;
                HRJobApplicantRequirement."Line No" := 0;
                HRJobApplicantRequirement."Job Application No." := HRJobApplication."No.";
                HRJobApplicantRequirement."Requirement Code" := HRJobOnlineRequirements."Requirement Code";
                HRJobApplicantRequirement.Description := HRJobOnlineRequirements.Description;
                HRJobApplicantRequirement."No. of Years" := HRJobOnlineRequirements."No. of Years";
                HRJobApplicantRequirement."E-mail" := HRJobOnlineRequirements."E-mail";
                HRJobApplicantRequirement.INSERT;
            UNTIL HRJobOnlineRequirements.NEXT = 0;
        END;

    end;

    procedure InitializeDirectoryPaths()
    var
        CompanyInformation: Record "Company Information";
        HumanResourcesSetup: Record "Human Resources Setup";
    begin
        CompanyInformation.GET;
        HumanResourcesSetup.GET;
        CompanyDataDirectory := CompanyInformation."Company Data Directory Path";
        HRJobsData := HumanResourcesSetup."HR Jobs Data";
    end;

    procedure PreviewJobDetailsReport(EmailAddress: Text[100]; EmpRequisitionNo: Code[20]) JobDetailsPreviewed: Boolean
    var
        HRJobsDataFilePath: Label '%1\%2HRJobsReport.pdf';
        HREmployeeRequisitions: Record "HR Employee Requisitions";
        HRApplicantAccountWS: Codeunit "HR Applicant Account WS";
    begin
        JobDetailsPreviewed := FALSE;
        InitializeDirectoryPaths();
        EmailAddress := HRApplicantAccountWS.GetHROnlineEmailAddress(EmailAddress);
        FileName := STRSUBSTNO(HRJobsDataFilePath, CompanyDataDirectory, HRJobsData);

        /* to be uncommented later
         IF EXISTS(FileName) THEN BEGIN
             ERASE(FileName);
         END; */

        HREmployeeRequisitions.RESET;
        HREmployeeRequisitions.SETRANGE(HREmployeeRequisitions."No.", EmpRequisitionNo);
        IF HREmployeeRequisitions.FINDFIRST THEN BEGIN
            //   REPORT.SaveAs(REPORT::"HR Job Advert", FileName, HREmployeeRequisitions);
            JobDetailsPreviewed := TRUE;
        END;
    end;
}


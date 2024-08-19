codeunit 50033 "HR Employee Recruitment"
{

    trigger OnRun()
    begin
    end;

    var
        ProgressWindow: Dialog;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record 5218;
        /*  SMTPMail: Codeunit 400;
         SMTP: Record 409; */
        Txt070: Label 'Close requisition No.?';
        HREmployeeRefereeDetails: Record 50113;
        HRApplicantRefereeDetails: Record 50170;
        HRJobs: Record 50093;
        LineNo: Integer;
        Text100: Label 'Employee Created Successfully. Employee assigned number is %1';
        HRJobApplicantQualification: Record 50167;
        EmployeeQualification: Record 5203;
        Successemail: Label 'Emails successfully Sent!';
        "Purchases&PayablesSetup": Record 312;
        BringOriginalCertsTestimonialsMessage: Label '. Please bring your original academic and professional certificates and testimonials.';
        HREmployeeEmploymentHist: Record 50124;
        HRApplicantEmploymentHist: Record 50169;

    procedure LoadApplicantsToInterviewPannel(EmployeeRequisitionNo: Code[20]; JobNo: Code[20])
    var
        JobApplications: Record 50099;
        JobApplicantResults: Record 50110;
    begin
        JobApplicantResults.RESET;
        JobApplicantResults.SETRANGE("Job Requistion No", EmployeeRequisitionNo);
        IF JobApplicantResults.FINDSET THEN
            JobApplicantResults.DELETEALL;

        JobApplications.RESET;
        JobApplications.SETRANGE("Employee Requisition No.", EmployeeRequisitionNo);
        /*         JobApplications.SETRANGE(ShortListed,TRUE);
                JobApplications.SETRANGE("Committee Shortlisted",TRUE);
                JobApplications.SETRANGE("To be Interviewed",TRUE); */
        IF JobApplications.FINDSET THEN BEGIN
            REPEAT
                JobApplicantResults.INIT;
                JobApplicantResults."Job Applicant No" := JobApplications."No.";
                // JobApplicantResults."Job No":=JobApplications."Job No.";
                JobApplicantResults."Job Requistion No" := JobApplications."Employee Requisition No.";
                JobApplicantResults.Surname := JobApplications.Surname;
                JobApplicantResults.Firstname := JobApplications.Firstname;
                JobApplicantResults.Middlename := JobApplications.Middlename;
                JobApplicantResults.INSERT;
            UNTIL JobApplications.NEXT = 0;
        END;
    end;

    procedure TransferQualifiedApplicantDetailsToEmployee(JobApplications: Record 50099)
    var
        Employees: Record 5200;
        EmployeeManagement: Codeunit 50034;
        HRMandatoryDocChecklist: Record 50112;
        HRApplicantEmploymentHist: Record 50169;
        HREmployeeEmploymentHist: Record 50124;
    begin
        /*         JobApplications.TESTFIELD("Emplymt. Contract Code");
                JobApplications.TESTFIELD("National ID No.");
                JobApplications.TESTFIELD("PIN  No.");
                JobApplications.TESTFIELD("NHIF No.");
                JobApplications.TESTFIELD("NSSF No."); */


        HRSetup.GET;

        Employees.INIT;
        Employees."No." := '';// NoSeriesMgt.GetNextNo(HRSetup."Employee Nos.", 0D, TRUE);
        Employees."First Name" := JobApplications.Firstname;
        Employees."Middle Name" := JobApplications.Middlename;
        Employees."Last Name" := JobApplications.Surname;
        Employees."Birth Date" := JobApplications."Date of Birth";
        /*  Employees.Gender:=JobApplications.Gender;
         Employees."Person Living with Disability":=JobApplications."Person Living With Disability";
  */
        // Employees.Title:=JobApplications."Job Title";
        /* HRJobs.RESET;
        HRJobs.SETRANGE(HRJobs."No.",JobApplications."Job No.");
        IF HRJobs.FINDFIRST THEN BEGIN
          Employees."Supervisor Job No.":=HRJobs."Supervisor Job No.";
          Employees."Supervisor Job Title":=HRJobs."Supervisor Job Title";
        END; */
        /*         Employees."Emplymt. Contract Code":=JobApplications."Emplymt. Contract Code";
                Employees."HR Salary Notch":=JobApplications."HR Salary Notch";
                Employees."Global Dimension 1 Code":=JobApplications."Global Dimension 1 Code";
                Employees."Global Dimension 2 Code":=JobApplications."Global Dimension 2 Code";
                Employees."Shortcut Dimension 3 Code":=JobApplications."Shortcut Dimension 3 Code";
                Employees."Shortcut Dimension 4 Code":=JobApplications."Shortcut Dimension 4 Code"; */
        /*         Employees."Marital Status-d":=JobApplications."Marital Status";
                Employees."National ID No.-d":=JobApplications."National ID No.";
                Employees."PIN No.-d":=JobApplications."PIN  No.";
                Employees."Huduma No.":=JobApplications."Huduma No.";
                Employees."Passport No.-d":=JobApplications."Passport No.";
                Employees."NHIF No.-d":=JobApplications."NHIF No.";
                Employees."NSSF No.-d":=JobApplications."NSSF No.";
                Employees."Emplymt. Contract Code":=JobApplications."Emplymt. Contract Code"; */
        Employees."Post Code" := JobApplications."Post Code";
        Employees.City := JobApplications."City/Town";
        Employees."County Code" := JobApplications.County;
        Employees."County Name" := JobApplications."County Name";
        /*         Employees.Citizenship:=JobApplications.Citizenship;
                Employees.Religion:=JobApplications.Religion;
                Employees."Ethnic Group":=JobApplications."Ethnic Group"; */
        Employees."SubCounty Code" := JobApplications.SubCounty;
        // Employees."SubCounty Name":=JobApplications."SubCounty Name";
        Employees.Address := JobApplications."Postal Address";
        Employees."Address 2" := JobApplications."Residential Address";
        /*         Employees."Phone No.":=JobApplications."Mobile Phone No.";
                Employees."Mobile Phone No.":=JobApplications"Alternative Phone No.";
                Employees."E-Mail":=JobApplications."Personal Email Address"; */
        Employees."On Probation" := TRUE;
        //   Employees."Bank Code-d":=JobApplications."Bank Code";
        //  Employees."Bank Name":=JobApplications."Bank Name";

        // Employees."Bank Branch Name":=JobApplications."Bank Branch Name";
        Employees."Employment Date" := TODAY;
        /*     Employees."Contract Start Date":=JobApplications."Contract Start Date";
            Employees."Probation Start Date":=JobApplications."Probation Start Date";
            Employees."Probation End date":=JobApplications."Probation End date";
     */
        Employees.INSERT;


        HRApplicantRefereeDetails.RESET;
        HRApplicantRefereeDetails.SETRANGE(HRApplicantRefereeDetails."Job Application  No.", JobApplications."No.");
        IF HRApplicantRefereeDetails.FINDSET THEN BEGIN
            LineNo := 1;
            REPEAT

                HREmployeeRefereeDetails.INIT;
                HREmployeeRefereeDetails."Line No." += LineNo;
                HREmployeeRefereeDetails."Employee No." := Employees."No.";
                HREmployeeRefereeDetails.Surname := HRApplicantRefereeDetails.Surname;
                HREmployeeRefereeDetails.Firstname := HRApplicantRefereeDetails.Firstname;
                HREmployeeRefereeDetails.Middlename := HRApplicantRefereeDetails.Middlename;
                HREmployeeRefereeDetails."Personal E-Mail Address" := HRApplicantRefereeDetails."Personal E-Mail Address";
                //   HREmployeeRefereeDetails."Mobile No.":=HRApplicantRefereeDetails."Mobile No.";
                HREmployeeRefereeDetails."Postal Address" := HRApplicantRefereeDetails."Postal Address";
                HREmployeeRefereeDetails."Post Code" := HRApplicantRefereeDetails."Post Code";
            /*       HREmployeeRefereeDetails."City/Town":=HRApplicantRefereeDetails."Applicant E-mail";
                  HREmployeeRefereeDetails."Country/Region Code":=HRApplicantRefereeDetails."Country/Region Code";
                  HREmployeeRefereeDetails."Residential Address":=HRApplicantRefereeDetails."Residential Address";
                  HREmployeeRefereeDetails."Referee Category":=HRApplicantRefereeDetails."Referee Category";
                  HREmployeeRefereeDetails.INSERT;
         */
            UNTIL HRApplicantRefereeDetails.NEXT = 0;
        END;
        HRJobApplicantQualification.RESET;
        HRJobApplicantQualification.SETRANGE(HRJobApplicantQualification."Job Application No.", JobApplications."No.");
        IF HRJobApplicantQualification.FINDSET THEN BEGIN
            LineNo := 1;
            REPEAT

                EmployeeQualification.INIT;
                EmployeeQualification."Line No." += LineNo;
                EmployeeQualification."Employee No." := Employees."No.";
                EmployeeQualification."Qualification Code" := HRJobApplicantQualification."Qualification Code";
                EmployeeQualification.Description := HRJobApplicantQualification."Qualification Name";
                EmployeeQualification."From Date" := HRJobApplicantQualification."Joining Date";
                EmployeeQualification."To Date" := HRJobApplicantQualification."Completion Date";
                //  EmployeeQualification.Award:=HRJobApplicantQualification.Award;
                // EmployeeQualification."Award Date":=HRJobApplicantQualification."Award Date";
                EmployeeQualification."Institution/Company" := HRJobApplicantQualification."Institution Name";
                EmployeeQualification.INSERT;
            UNTIL HRJobApplicantQualification.NEXT = 0;
        END;
        HRApplicantEmploymentHist.RESET;
        HRApplicantEmploymentHist.SETRANGE(HRApplicantEmploymentHist."Job Application No.", JobApplications."No.");
        IF HRApplicantEmploymentHist.FINDSET THEN BEGIN
            LineNo := 1;
            REPEAT

                HREmployeeEmploymentHist.INIT;
                HREmployeeEmploymentHist."Line No." += LineNo;
                HREmployeeEmploymentHist."Employee No." := Employees."No.";
                HREmployeeEmploymentHist."E-mail" := HRApplicantEmploymentHist."E-mail";
                HREmployeeEmploymentHist."Employer Name/Organization" := HRApplicantEmploymentHist."Employer Name/Organization";
                HREmployeeEmploymentHist."Address of the Organization" := HRApplicantEmploymentHist."Address of the Organization";
                HREmployeeEmploymentHist."Job Designation/Position Held" := HRApplicantEmploymentHist."Job Designation/Position Held";
                HREmployeeEmploymentHist."From Date" := HRApplicantEmploymentHist."From Date";
                HREmployeeEmploymentHist."To Date" := HRApplicantEmploymentHist."To Date";
                HREmployeeEmploymentHist."Days/Years of service" := HRApplicantEmploymentHist."Days/Years of service";
                HREmployeeEmploymentHist."Gross Salary" := HRApplicantEmploymentHist."Gross Salary";
                HREmployeeEmploymentHist.Benefits := HRApplicantEmploymentHist.Benefits;
                HREmployeeEmploymentHist.INSERT;
            UNTIL HRApplicantEmploymentHist.NEXT = 0;
        END;


        MESSAGE(Text100, Employees."No.");

        // JobApplications."Employee Created":=TRUE;
        /*IF JobApplications.MODIFY THEN BEGIN
          EmployeeManagement.SendEmailNotificationToICT(Employees."No.");
       END;*/

    end;

    procedure LoadInterviewPanelFromCommittee(InterviewAttendanceHeader: Record 50108)
    var
        InterviewCommitteeDeptLine: Record 50107;
        InterviewAttendanceLine: Record 50109;
    begin
        InterviewAttendanceLine.RESET;
        InterviewAttendanceLine.SETRANGE("Interview No.", InterviewAttendanceHeader."Interview No");
        IF InterviewAttendanceLine.FINDSET THEN
            InterviewAttendanceLine.DELETEALL;

        InterviewCommitteeDeptLine.RESET;
        InterviewCommitteeDeptLine.SETRANGE(Code, InterviewAttendanceHeader."Interview Committee code");
        IF InterviewCommitteeDeptLine.FINDSET THEN BEGIN
            REPEAT
                InterviewAttendanceLine.INIT;
                InterviewAttendanceLine."Interview No." := InterviewAttendanceHeader."Interview No";
                InterviewAttendanceLine."Employee No." := InterviewCommitteeDeptLine."Employee No.";
                InterviewAttendanceLine."Employee Name" := InterviewCommitteeDeptLine."Employee Name";
                InterviewAttendanceLine."Employee Email" := InterviewCommitteeDeptLine."Employee Email";
                InterviewAttendanceLine.INSERT;
            UNTIL InterviewCommitteeDeptLine.NEXT = 0;
        END;
    end;

    procedure SendEmailNotificationToICTOnPublishingJobAdvert(EmpReqNo: Code[20])
    var
        HRJobApplication: Record 50099;
        HREmpRequisition: Record 50098;
        InterviewAttendanceLine: Record 50109;
        JobName: Text;
        UserSetup: Record 91;
        Employee: Record 5200;
        HREmployee: Record 5200;
    begin
        //Send Email Notification to ICT upon Publishing of Job Advert on the portal
        /*  SMTP.GET;
         UserSetup.RESET;
         UserSetup.SETRANGE(UserSetup."Receive ICT Notifications", TRUE);
         IF UserSetup.FINDSET THEN BEGIN
             REPEAT
                 HREmpRequisition.RESET;
                 HREmpRequisition.SETRANGE(HREmpRequisition."No.", EmpReqNo);
                 IF HREmpRequisition.FINDFIRST THEN BEGIN
                     // SMTPMail.CreateMessage(SMTP."Sender Name",SMTP."Sender Email Address",UserSetup."E-Mail",'Publishing of Job Advertisement on the Website ','',TRUE);
                     HREmployee.RESET;
                     HREmployee.SETRANGE(HREmployee."User ID", UserSetup."User ID");
                     IF HREmployee.FINDFIRST THEN BEGIN
                         SMTPMail.AppendBody('Dear' + ' ' + HREmployee."First Name" + ',');
                         SMTPMail.AppendBody('<br><br>');
                         SMTPMail.AppendBody('Please proceed to Publish Job Advertisement vacancy for the ' + '  ' + HREmpRequisition."Job Title" + ',' + ' on the website as the Job advertisement has been posted on the recruitment portal.');
                         SMTPMail.AppendBody('Thank you.');
                         SMTPMail.AppendBody('<br><br>');
                         //  SMTPMail.AppendBody(SMTP."Sender Name");
                         SMTPMail.AppendBody('<br><br>');
                         SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this Email');
                         SMTPMail.Send;
                     END;
                 END;
             UNTIL UserSetup.NEXT = 0;
         END; */
    end;

    procedure SendInterviewShortlistedApplicantEmail(JobNo: Code[20]; EmpReqNo: Code[20]; InterviewDateFrom: Date; InterviewTime: Text; InterviewLocation: Text; InterviewNo: Code[30]; InterviewDateTo: Date)
    var
        HRJobApplication: Record 50099;
        HREmpRequisition: Record 50098;
        InterviewAttendanceLine: Record 50109;
        JobName: Text;
    begin
        // SMTP.GET;
        JobName := '';
        HRJobApplication.RESET;
        HRJobApplication.SETRANGE("Employee Requisition No.", EmpReqNo);
        /*         HRJobApplication.SETRANGE("Job No.",JobNo);
                HRJobApplication.SETRANGE(ShortListed,TRUE);
                HRJobApplication.SETRANGE("To be Interviewed",TRUE);
                HRJobApplication.SETFILTER("Personal Email Address",'<>%1',''); */
        IF HRJobApplication.FINDSET THEN BEGIN
            // JobName:=HRJobApplication."Job Title";
            REPEAT
            /*  //SMTPMail.CreateMessage(SMTP."Sender Name",SMTP."Sender Email Address",HRJobApplication."Personal Email Address",'Interview Invitation '+HRJobApplication."Job Title",'',TRUE);
             SMTPMail.AppendBody('Dear' + ' ' + HRJobApplication.Surname + ' ' + HRJobApplication.Middlename + ' ' + HRJobApplication.Firstname + ',');
             SMTPMail.AppendBody('<br><br>');
             SMTPMail.AppendBody('Thank you for applying for the position of ' + HRJobApplication."Job Title" + '.' + 'Following consideration of your application, we are pleased to inform you that you have been shortlisted for interview.');
             SMTPMail.AppendBody('The Interview will take place on' + ' ' + FORMAT(HRJobApplication."Interview Date", 0, 4) + ' ' + 'at' + ' ' + HRJobApplication."Interview Time" + ' at,' + HRJobApplication."Interview Location" + BringOriginalCertsTestimonialsMessage);
             SMTPMail.AppendBody('Thank you.');
             SMTPMail.AppendBody('<br><br>');
             // SMTPMail.AppendBody(SMTP."Sender Name");
             SMTPMail.AppendBody('<br><br>');
             SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this Email');
             SMTPMail.Send; */
            UNTIL HRJobApplication.NEXT = 0;
        END;

        InterviewAttendanceLine.RESET;
        InterviewAttendanceLine.SETRANGE(InterviewAttendanceLine."Interview No.", InterviewNo);
        InterviewAttendanceLine.SETFILTER(InterviewAttendanceLine."Employee Email", '<>%1', '');
        IF InterviewAttendanceLine.FINDSET THEN BEGIN
            REPEAT
            /*  //  SMTPMail.CreateMessage(SMTP."Sender Name",SMTP."Sender Email Address",InterviewAttendanceLine."Employee Email",'Interview Panel Invitation - '+HRJobApplication."Job Title",'',TRUE);
             SMTPMail.AppendBody('Dear' + ' ' + InterviewAttendanceLine."Employee Name" + ',');
             SMTPMail.AppendBody('<br><br>');
             SMTPMail.AppendBody('I wish to inform you,that you have been nominated to be part of the interview panel for the shortlisted candidates to be interviewed.');
             SMTPMail.AppendBody('The Interview will be conducted from' + ' ' + FORMAT(InterviewDateFrom, 0, 4) + ' ' + ' to ' + ' ' + FORMAT(InterviewDateTo, 0, 4) + ' ' + HRJobApplication."Interview Time" + ' at  the, ' + HRJobApplication."Interview Location");
             SMTPMail.AppendBody('<br><br>');
             SMTPMail.AppendBody('Thank you.');
             SMTPMail.AppendBody('<br><br>');
             //   SMTPMail.AppendBody(SMTP."Sender Name");
             SMTPMail.AppendBody('<br><br>');
             SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this Email');
             SMTPMail.Send; */
            UNTIL InterviewAttendanceLine.NEXT = 0;
        END;
        MESSAGE(Successemail);
    end;

    procedure SendInterviewRejectedApplicantEmail(JobNo: Code[20]; EmpReqNo: Code[20])
    var
        HRJobApplication: Record 50099;
    begin
        //       SMTP.GET;
        HRJobApplication.RESET;
        HRJobApplication.SETRANGE("Employee Requisition No.", EmpReqNo);
        /*         HRJobApplication.SETRANGE("Job No.",JobNo);
                HRJobApplication.SETRANGE("To be Interviewed",FALSE);
                HRJobApplication.SETFILTER("Email Address",'<>%1',''); */
        IF HRJobApplication.FINDSET THEN BEGIN
            REPEAT
            /*   //   SMTPMail.CreateMessage(SMTP."Sender Name",SMTP."Sender Email Address",HRJobApplication."Personal Email Address",'Job Application Regret '+HRJobApplication."Job Title",'',TRUE);
              SMTPMail.AppendBody('Dear' + ' ' + HRJobApplication.Surname + ' ' + HRJobApplication.Middlename + ' ' + HRJobApplication.Firstname + ',');
              SMTPMail.AppendBody('<br><br>');
              SMTPMail.AppendBody('Thank you for applying for the position of ,' + HRJobApplication."Job Title" + '.We really appreciate your interest and we thank you for the time and energy you invested in applying for the position.');
              SMTPMail.AppendBody('<br><br>');
              SMTPMail.AppendBody('After carefully reviewing your application, we regret to inform you that we will not progress your application to the next phase of our selection process.');
              SMTPMail.AppendBody('<br><br>');
              SMTPMail.AppendBody('We do encourage you to apply for open positions that you qualify for in future.');
              SMTPMail.AppendBody('<br><br>');
              SMTPMail.AppendBody('Thank you again for your application and best wishes.');
              SMTPMail.AppendBody('<br><br>');
              //   SMTPMail.AppendBody(SMTP."Sender Name");
              SMTPMail.AppendBody('<br><br>');
              SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this Email');
              SMTPMail.Send; */
            UNTIL HRJobApplication.NEXT = 0;
        END;
        MESSAGE(Successemail);
    end;

    procedure CloseEmployeeRequisition(EmployeeRequisitionNo: Code[20])
    var
        JobApplications: Record 50099;
        InterviewAttendanceHeader: Record 50108;
        InterviewAttendanceLines: Record 50109;
        EmployeeRequisition: Record 50098;
        JobApplicantResults: Record 50110;
    begin
        IF CONFIRM(Txt070) = FALSE THEN EXIT;
        //close job applications
        JobApplications.RESET;
        JobApplications.SETRANGE("Employee Requisition No.", EmployeeRequisitionNo);
        IF JobApplications.FINDSET THEN BEGIN
            REPEAT
                // JobApplications.Status:=JobApplications.Status::Shortlisted;
                JobApplications.MODIFY;
            UNTIL JobApplications.NEXT = 0;
        END;

        //close interviews
        InterviewAttendanceHeader.RESET;
        InterviewAttendanceHeader.SETRANGE("Job Requisition No.", EmployeeRequisitionNo);
        IF InterviewAttendanceHeader.FINDSET THEN BEGIN
            InterviewAttendanceHeader.Closed := TRUE;
            InterviewAttendanceHeader.MODIFY;

            InterviewAttendanceLines.RESET;
            InterviewAttendanceLines.SETRANGE("Interview No.", InterviewAttendanceHeader."Interview No");
            IF InterviewAttendanceLines.FINDSET THEN BEGIN
                REPEAT
                    InterviewAttendanceLines.Closed := TRUE;
                    InterviewAttendanceLines.MODIFY;
                UNTIL InterviewAttendanceLines.NEXT = 0;
            END;
        END;

        //close requisition
        EmployeeRequisition.RESET;
        EmployeeRequisition.SETRANGE("No.", EmployeeRequisitionNo);
        IF EmployeeRequisition.FINDFIRST THEN BEGIN
            EmployeeRequisition.Status := EmployeeRequisition.Status::Closed;
            EmployeeRequisition.MODIFY;
        END;

        //close results
        JobApplicantResults.RESET;
        JobApplicantResults.SETRANGE("Job Requistion No", EmployeeRequisitionNo);
        IF JobApplicantResults.FINDSET THEN BEGIN
            REPEAT
                JobApplicantResults.Closed := TRUE;
                JobApplicantResults.MODIFY;
            UNTIL JobApplicantResults.NEXT = 0;
        END;
    end;

    procedure RankInterviewees(JobRequisitionNo: Code[20]; JobNo: Code[20])
    var
        JobApplicantResults: Record 50110;
        Position: Integer;
    begin
        Position := 1;
        JobApplicantResults.RESET;
        /*         JobApplicantResults.SETRANGE("Job Requistion No",JobRequisitionNo);
                JobApplicantResults.SETRANGE("Job No",JobNo);
                JobApplicantResults.SETCURRENTKEY(Total);
                JobApplicantResults.SETASCENDING(Total,FALSE); */
        IF JobApplicantResults.FINDSET THEN BEGIN
            ProgressWindow.OPEN('Ranking for applicant no. #1#######');
            REPEAT
                JobApplicantResults.Position := Position;
                JobApplicantResults.MODIFY;
                Position := Position + 1;
                ProgressWindow.UPDATE(1, JobApplicantResults."Job Applicant No");
            UNTIL JobApplicantResults.NEXT = 0;
        END;
        ProgressWindow.CLOSE;
    end;

    procedure ShortlistApplicants(EmployeeRequisitions: Record 50098)
    var
        HRJobApplications: Record 50099;
        HRJobQualifications: Record 50094;
        HRJobApplicantQualifications: Record 50167;
        HRJobRequirements: Record 50095;
        HRJobApplicantRequirements: Record 50168;
        JobApplicantShortlisting: Label 'Job Applicant Shortlisting is Successful.';
    begin
        //Check Mandatory Academic Qualifications
        HRJobApplications.RESET;
        HRJobApplications.SETRANGE(HRJobApplications."Employee Requisition No.", EmployeeRequisitions."No.");
        IF HRJobApplications.FINDSET THEN BEGIN
            REPEAT
                HRJobQualifications.RESET;
                HRJobQualifications.SETRANGE("Job No.", HRJobApplications."Job No.");
                HRJobQualifications.SETRANGE(Mandatory, TRUE);
                IF HRJobQualifications.FINDSET THEN BEGIN
                    REPEAT
                        HRJobApplicantQualifications.RESET;
                        HRJobApplicantQualifications.SETRANGE("E-mail", HRJobApplications."Personal Email Address");
                        HRJobApplicantQualifications.SETRANGE("Qualification Code", HRJobQualifications."Qualification Code");
                        IF HRJobApplicantQualifications.FINDFIRST THEN BEGIN
                            HRJobApplications.ShortListed := TRUE;
                            HRJobApplications."To be Interviewed" := TRUE;
                            HRJobApplications.Status := HRJobApplications.Status::"Pending Approval";
                            HRJobApplications.MODIFY;
                        END ELSE BEGIN
                            HRJobApplications.ShortListed := FALSE;
                            HRJobApplications."To be Interviewed" := FALSE;
                            HRJobApplications.Status := HRJobApplications.Status::Approved;
                            HRJobApplications.MODIFY;
                            EXIT;
                        END;
                    UNTIL HRJobQualifications.NEXT = 0;
                END;
            UNTIL HRJobApplications.NEXT = 0;
        END;
        //Check Mandatory Requirements
        HRJobApplications.RESET;
        HRJobApplications.SETRANGE(HRJobApplications."Employee Requisition No.", EmployeeRequisitions."No.");
        IF HRJobApplications.FINDSET THEN BEGIN
            REPEAT
                HRJobRequirements.RESET;
                HRJobRequirements.SETRANGE("Job No.", HRJobApplications."Job No.");
                HRJobRequirements.SETRANGE(Mandatory, TRUE);
                IF HRJobRequirements.FINDSET THEN BEGIN
                    REPEAT
                        HRJobApplicantRequirements.RESET;
                        HRJobApplicantRequirements.SETRANGE("E-mail", HRJobApplications."Personal Email Address");
                        HRJobApplicantRequirements.SETRANGE("Requirement Code", HRJobRequirements."Requirement Code");
                        IF HRJobApplicantRequirements.FINDFIRST THEN BEGIN
                            HRJobApplications.ShortListed := TRUE;
                            HRJobApplications."To be Interviewed" := TRUE;
                            HRJobApplications.Status := HRJobApplications.Status::"Pending Approval";
                            HRJobApplications.MODIFY;
                        END ELSE BEGIN
                            HRJobApplications.ShortListed := FALSE;
                            HRJobApplications."To be Interviewed" := FALSE;
                            HRJobApplications.Status := HRJobApplications.Status::Approved;
                            HRJobApplications.MODIFY;
                            EXIT;
                        END;
                    UNTIL HRJobRequirements.NEXT = 0;
                END;
            UNTIL HRJobApplications.NEXT = 0;
        END;
        MESSAGE(JobApplicantShortlisting);
    end;

    procedure CalculateResultsTotals(JobRequisitionNo: Code[20]; JobNo: Code[20])
    var
        JobApplicantResults: Record 50110;
        ResultsTotal: Decimal;
    begin
        JobApplicantResults.RESET;
        JobApplicantResults.SETRANGE("Job Requistion No", JobRequisitionNo);
        JobApplicantResults.SETRANGE("Job No", JobNo);
        IF JobApplicantResults.FINDSET THEN BEGIN
            JobApplicantResults.CALCFIELDS("EV 1");
            JobApplicantResults.CALCFIELDS("EV 2");
            JobApplicantResults.CALCFIELDS("EV 3");
            JobApplicantResults.CALCFIELDS("EV 4");
            JobApplicantResults.CALCFIELDS("EV 5");
            JobApplicantResults.CALCFIELDS("EV 6");
            JobApplicantResults.CALCFIELDS("EV 7");
            JobApplicantResults.CALCFIELDS("EV 8");
            JobApplicantResults.CALCFIELDS("EV 9");
            JobApplicantResults.CALCFIELDS("EV 10");
            ProgressWindow.OPEN('Calculating Totals for applicant no. #1#######');
            REPEAT
                ResultsTotal := 0;
                ResultsTotal := JobApplicantResults."EV 1" + JobApplicantResults."EV 2" + JobApplicantResults."EV 3" + JobApplicantResults."EV 4" + JobApplicantResults."EV 5" +
                              JobApplicantResults."EV 6" + JobApplicantResults."EV 7" + JobApplicantResults."EV 8" + JobApplicantResults."EV 9" + JobApplicantResults."EV 10";
                JobApplicantResults.Total := ResultsTotal;
                JobApplicantResults.MODIFY;
                ProgressWindow.UPDATE(1, JobApplicantResults."Job Applicant No");
            UNTIL JobApplicantResults.NEXT = 0;
        END;
        ProgressWindow.CLOSE;
    end;
    /* 
        procedure CreatePurchaseRequisitionForJobAdvertisement(EmpReqNo: Code[20])
        var
            HREmployeeRequisitions: Record 50098;
            PurchaseRequisitions: Record 50046;
            PurchaseRequisitions2: Record 50046;
        begin
            "Purchases&PayablesSetup".GET;
            HREmployeeRequisitions.RESET;
            HREmployeeRequisitions.SETRANGE(HREmployeeRequisitions."No.", EmpReqNo);
            IF HREmployeeRequisitions.FINDFIRST THEN BEGIN
                PurchaseRequisitions2.RESET;
                PurchaseRequisitions2.SETRANGE("Reference Document No.", HREmployeeRequisitions."No.");
                IF NOT PurchaseRequisitions2.FINDFIRST THEN BEGIN
                    PurchaseRequisitions.INIT;
                    PurchaseRequisitions."No." := NoSeriesMgt.GetNextNo("Purchases&PayablesSetup"."Purchase Requisition Nos.", 0D, TRUE);
                    PurchaseRequisitions."Document Date" := TODAY;
                    PurchaseRequisitions."Requested Receipt Date" := TODAY;
                    PurchaseRequisitions."Reference Document No." := EmpReqNo;
                    PurchaseRequisitions."Global Dimension 1 Code" := HREmployeeRequisitions."Global Dimension 1 Code";
                    PurchaseRequisitions."Global Dimension 2 Code" := HREmployeeRequisitions."Global Dimension 2 Code";
                    PurchaseRequisitions."Shortcut Dimension 3 Code" := HREmployeeRequisitions."Shortcut Dimension 3 Code";
                    PurchaseRequisitions."Shortcut Dimension 4 Code" := HREmployeeRequisitions."Shortcut Dimension 4 Code";
                    PurchaseRequisitions."Shortcut Dimension 5 Code" := HREmployeeRequisitions."Shortcut Dimension 5 Code";
                    PurchaseRequisitions.Description := HREmployeeRequisitions."Emp. Requisition Description";
                    IF PurchaseRequisitions.INSERT THEN BEGIN
                        HREmployeeRequisitions."Purchase Requisition Created" := TRUE;
                        HREmployeeRequisitions."Purchase Requisition No." := PurchaseRequisitions."No.";
                        HREmployeeRequisitions.MODIFY;
                    END;
                END;
            END;
        end;
     */
    procedure PublishJobAdvertisement(EmpReqNo: Code[20])
    var
        Txt080: Label 'Are you sure you want to Publish the Job Advertisement? Please note this will make the Job Advertisement to be visible on the portal for Applications.';
        Txt081: Label 'Are you sure you want to drop the Published Job Advertisement? Please note this will make the Job Advertisement not to be visible on the portal for Applications.';
        HREmployeeRequisitions: Record 50098;
    begin
        HREmployeeRequisitions.RESET;
        HREmployeeRequisitions.SETRANGE(HREmployeeRequisitions."No.", EmpReqNo);
        IF HREmployeeRequisitions.FINDFIRST THEN BEGIN
            HREmployeeRequisitions."Job Advert Published" := TRUE;
            HREmployeeRequisitions."Job Advert Dropped" := FALSE;
            HREmployeeRequisitions.MODIFY;
            SendEmailNotificationToICTOnPublishingJobAdvert(EmpReqNo);
            MESSAGE(Txt080);
        END;
    end;

    procedure DropJobAdvertisement(EmpReqNo: Code[20])
    var
        Txt080: Label 'Are you sure you want to Publish the Job Advertisement? Please note this will make the Job Advertisement to be visible on the portal for Applications.';
        Txt081: Label 'Are you sure you want to drop the Published Job Advertisement? Please note this will make the Job Advertisement not to be visible on the portal for Applications.';
        HREmployeeRequisitions: Record 50098;
    begin
        HREmployeeRequisitions.RESET;
        HREmployeeRequisitions.SETRANGE(HREmployeeRequisitions."No.", EmpReqNo);
        IF HREmployeeRequisitions.FINDFIRST THEN BEGIN
            HREmployeeRequisitions."Job Advert Published" := FALSE;
            HREmployeeRequisitions."Job Advert Dropped" := TRUE;
            HREmployeeRequisitions.MODIFY;
            MESSAGE(Txt081);
        END;
    end;
}


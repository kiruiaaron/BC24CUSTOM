codeunit 50034 "HR Employee Management"
{

    trigger OnRun()
    begin
    end;

    var
        Employee: Record 5200;
        CompanyInformation: Record 79;
        HumanResourcesSetup: Record 5218;
        EmployeePortalServices: Codeunit 50035;
        //  SMTPMail: Codeunit 400;
        //  SMTP: Record 409;
        UserSetup: Record 91;

    procedure CreateEmployeeDirectory("EmployeeNo.": Code[20])
    var
        CompanyDataDirectory: Text;
        EmployeeDataDirectory: Text;
        /* [RunOnClient]
        DirectoryHelper: DotNet Directory; */
        DirectoryPath: Label '%1\%2\%3';
        EmployeeDirectoryPath: Text;
    begin
        CompanyInformation.GET;
        HumanResourcesSetup.GET;
        CompanyInformation.TESTFIELD(CompanyInformation."Company Data Directory Path");
        HumanResourcesSetup.TESTFIELD(HumanResourcesSetup."Employee Data Directory Name");
        CompanyDataDirectory := CompanyInformation."Company Data Directory Path";
        EmployeeDataDirectory := HumanResourcesSetup."Employee Data Directory Name";

        EmployeeDirectoryPath := STRSUBSTNO(DirectoryPath, CompanyDataDirectory, EmployeeDataDirectory, EmployeePortalServices.GetCleanedEmployeeNo("EmployeeNo."));
        /* 
                IF NOT DirectoryHelper.Exists(EmployeeDirectoryPath) THEN BEGIN
                  DirectoryHelper.CreateDirectory(EmployeeDirectoryPath);
                END; */
    end;

    procedure TransferAsset(AssetTransferLines: Record 50151)
    var
        FA: Record 5600;
    begin
        FA.RESET;
        FA.SETRANGE("No.", AssetTransferLines."Asset No.");
        IF FA.FINDFIRST THEN BEGIN
            FA."Responsible Employee" := AssetTransferLines."New Responsible Employee Code";
            // FA."Employee Name":=AssetTransferLines."New Responsible Employee Name";
            FA."Location Code" := AssetTransferLines."New Asset Location";
            FA."Serial No." := AssetTransferLines."Asset Serial No";
            //FA."FA Tag No.":=AssetTransferLines."Asset Tag No.";
            FA."Global Dimension 1 Code" := AssetTransferLines."New Global Dimension 1 Code";
            FA."Global Dimension 2 Code" := AssetTransferLines."New Global Dimension 2 Code";
            /*  FA."Shortcut Dimension 3 Code":=AssetTransferLines."New Shortcut Dimension 3 Code";
             FA."Shortcut Dimension 4 Code":=AssetTransferLines."New Shortcut Dimension 4 Code";
             FA."Shortcut Dimension 5 Code":=AssetTransferLines."New Shortcut Dimension 5 Code";
             FA."Shortcut Dimension 6 Code":=AssetTransferLines."New Shortcut Dimension 6 Code"; */

        END;
    end;

    procedure SendEmailNotificationToICT(EmpNo: Code[20])
    var
        Employee: Record 5200;
        HREmployee: Record 5200;
        EmployeeEmail: List of [Text];
    begin
        //Send Email Notification to ICT upon Onboarding of a new Employee
        //SMTP.GET;
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."Receive ICT Notifications", TRUE);
        IF UserSetup.FINDSET THEN BEGIN
            REPEAT
                Employee.RESET;
                Employee.SETRANGE(Employee."No.", EmpNo);
                IF Employee.FINDFIRST THEN BEGIN
                    EmployeeEmail.Add(Employee."E-Mail");
                    /*  //  SMTPMail.CreateMessage(SMTP."Sender Name", SMTP."Sender Email Address", EmployeeEmail, 'New Staff Account Creation and Setup ', '', TRUE);
                        HREmployee.RESET;
                        HREmployee.SETRANGE(HREmployee."User ID", UserSetup."User ID");
                        IF HREmployee.FINDFIRST THEN BEGIN
                            SMTPMail.AppendBody('Dear' + ' ' + HREmployee."First Name" + ',');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('You are notified of a new staff, who has joined the Organization.');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Employee No: ' + Employee."No.");
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Employee Name: ' + Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name");
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Job Title: ' + Employee.Title);
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Please create for Him/Her an account and setup with the relevant Rolecentre and Permission set.');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Thank you.');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Regards,');
                            SMTPMail.AppendBody('<br><br>');
                            //  SMTPMail.AppendBody(SMTP."Sender Name");
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this Email');
                            SMTPMail.Send;
                        END; */
                END;
            UNTIL UserSetup.NEXT = 0;
        END;
    end;
}


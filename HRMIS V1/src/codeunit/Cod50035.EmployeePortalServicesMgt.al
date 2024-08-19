codeunit 50035 "Employee Portal Services Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        Employee: Record 5200;
        SERVERDIRECTORYPATH: Label 'C:\inetpub\wwwroot\HWWK\EmployeeData\';
        TxtCharsToKeep: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        CompanyInformation: Record 79;
        HumanResourcesSetup: Record 5218;

    procedure EmployeeExists("EmployeeNo.": Code[20]) EmployeeExist: Boolean
    begin
        EmployeeExist := FALSE;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            EmployeeExist := TRUE;
        END;
    end;

    procedure EmployeeAccountIsActive("EmployeeNo.": Code[20]) EmployeeAccountActive: Boolean
    begin
        EmployeeAccountActive := FALSE;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            IF Employee.Status = Employee.Status::Active THEN
                EmployeeAccountActive := TRUE;
        END;
    end;

    procedure GetCleanedEmployeeNo("EmployeeNo.": Code[20]) "CleanedEmployeeNo.": Text
    begin
        "CleanedEmployeeNo." := '';
        "CleanedEmployeeNo." := DELCHR("EmployeeNo.", '=', DELCHR("EmployeeNo.", '=', TxtCharsToKeep));
    end;

    procedure GetEmployeeName("EmployeeNo.": Code[20]) EmployeeName: Text
    begin
        EmployeeName := '';
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            EmployeeName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
        END;
    end;

    procedure GetEmployeeEmailAddress("EmployeeNo.": Code[20]) EmployeeEmailAddress: Text
    begin
        EmployeeEmailAddress := '';
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            EmployeeEmailAddress := Employee."E-Mail";
        END;
    end;

    procedure CreateEmployeeDirectory("EmployeeNo.": Code[20])
    var
        CompanyDataDirectory: Text;
        EmployeeDataDirectory: Text;
        //  [RunOnClient]
        //  DirectoryHelper: DotNet Directory;
        DirectoryPath: Label '%1\%2\%3';
        EmployeeDirectoryPath: Text;
    begin
        CompanyInformation.GET;
        HumanResourcesSetup.GET;
        CompanyInformation.TESTFIELD(CompanyInformation."Company Data Directory Path");
        HumanResourcesSetup.TESTFIELD(HumanResourcesSetup."Employee Data Directory Name");
        CompanyDataDirectory := CompanyInformation."Company Data Directory Path";
        EmployeeDataDirectory := HumanResourcesSetup."Employee Data Directory Name";

        EmployeeDirectoryPath := STRSUBSTNO(DirectoryPath, CompanyDataDirectory, EmployeeDataDirectory, GetCleanedEmployeeNo("EmployeeNo."));

        /*   IF NOT DirectoryHelper.Exists(EmployeeDirectoryPath) THEN BEGIN
              DirectoryHelper.CreateDirectory(EmployeeDirectoryPath);
          END; */
    end;

    procedure LoginEmployee("EmployeeNo.": Code[20]; Password: Text) LoginSuccessful: Boolean
    begin
        LoginSuccessful := FALSE;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            IF (Employee."Portal Password" = Password) THEN
                LoginSuccessful := TRUE;
        END;
    end;

    procedure IsEmployeeDefaultPassword("EmployeeNo.": Code[20]) IsDefaultPassword: Boolean
    begin
        IsDefaultPassword := FALSE;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            IF Employee."Default Portal Password" THEN
                IsDefaultPassword := TRUE;
        END;
    end;

    procedure SetPasswordResetToken("EmployeeNo.": Code[20]; PasswordResetToken: Text[250]) TokenSetSuccessfully: Boolean
    begin
        TokenSetSuccessfully := FALSE;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            Employee.PasswordResetToken := PasswordResetToken;
            Employee.PasswordResetTokenExpiry := CREATEDATETIME(CALCDATE('+1D', TODAY), TIME);
            IF Employee.MODIFY THEN
                TokenSetSuccessfully := TRUE;
        END;
    end;

    procedure GetPasswordResetToken("EmployeeNo.": Code[20]) PasswordResetToken: Text[250]
    begin
        PasswordResetToken := '';
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            PasswordResetToken := Employee.PasswordResetToken;
        END;
    end;

    procedure IsPasswordResetTokenExpired("EmployeeNo.": Code[20]; PasswordResetToken: Text[250]) TokenExpired: Boolean
    begin
        TokenExpired := FALSE;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            IF (CURRENTDATETIME > Employee.PasswordResetTokenExpiry) THEN
                TokenExpired := TRUE;
        END;
    end;

    procedure SendPasswordResetLink("EmployeeNo.": Code[20]; EmailMessage: Text) LinkSendSuccessful: Boolean
    var
        //  SMTPMailSetup: Record 409;
        //   SMTPMail: Codeunit 400;
        EmailSubject: Label 'Employee Account Password Reset';
        EmailSalutation: Label '<p>Dear %1,</p>';
        EmailSpacing: Label '<br><br>';
        EmailFooter: Label 'Sincerely,<br>%1, ICT Department';
        EmailFooter2: Label '<hr><p><i>This message was sent from an unmonitored email address. Please do not reply to this message.</i></p>';
        EmployeeEmail: List of [Text];
    begin
        LinkSendSuccessful := FALSE;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            CompanyInformation.GET;
            /*  SMTPMailSetup.GET;
             EmployeeEmail.Add(Employee."E-Mail");
             SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", EmployeeEmail, EmailSubject, '', TRUE);
             SMTPMail.AppendBody(STRSUBSTNO(EmailSalutation, GetEmployeeName("EmployeeNo.")));
             SMTPMail.AppendBody(EmailSpacing);
             SMTPMail.AppendBody(EmailMessage);
             SMTPMail.AppendBody(EmailSpacing);
             SMTPMail.AppendBody(STRSUBSTNO(EmailFooter, CompanyInformation.Name));
             SMTPMail.AppendBody(EmailFooter2);
             LinkSendSuccessful := SMTPMail.Send(); */
        END;
    end;

    procedure ResetEmployeePortalPassword("EmployeeNo.": Code[20]; NewPassword: Text[250]) PasswordResetSuccessful: Boolean
    begin
        PasswordResetSuccessful := FALSE;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            Employee."Portal Password" := NewPassword;
            Employee."Default Portal Password" := FALSE;
            Employee.PasswordResetTokenExpiry := CREATEDATETIME(CALCDATE('-1D', TODAY), TIME);
            IF Employee.MODIFY THEN
                PasswordResetSuccessful := TRUE;
        END;
    end;
}


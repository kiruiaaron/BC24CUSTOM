codeunit 50037 "Employee Account WS"
{

    trigger OnRun()
    begin
    end;

    var
        Employee: Record 5200;
        SERVERDIRECTORYPATH: Label 'C:\inetpub\wwwroot\HWWK\EmployeeData\';
        TxtCharsToKeep: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_';
        CompanyInformation: Record 79;
        HumanResourcesSetup: Record 5218;

    procedure EmployeeExists("EmployeeNo.": Code[20]) EmployeeExist: Boolean
    begin
        EmployeeExist := FALSE;
        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            EmployeeExist := TRUE;
        END;
    end;

    procedure EmployeeAccountIsActive("EmployeeNo.": Code[20]) EmployeeAccountActive: Boolean
    begin
        EmployeeAccountActive := FALSE;

        Employee.RESET;
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

        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            EmployeeName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
        END;
    end;

    procedure GetEmployeeGender("EmployeeNo.": Code[20]) EmployeeGender: Text
    begin
        EmployeeGender := '';

        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            EmployeeGender := FORMAT(Employee.Gender);
        END;
    end;

    procedure GetEmployeeDateOfBirth("EmployeeNo.": Code[20]) BirthDay: Text
    var
        Age: Text;
        FucnDates: Codeunit 50043;
    begin
        BirthDay := '';
        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            BirthDay := FORMAT(Employee."Birth Date");
        END;
    end;

    procedure GetEmployeeAge("EmployeeNo.": Code[20]) EmployeeAge: Text
    var
        Age: Text;
        FucnDates: Codeunit 50043;
    begin
        EmployeeAge := '';
        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            EmployeeAge := FucnDates.DetermineAge(Employee."Birth Date", TODAY);
        END;
    end;

    procedure GetEmployeeRetirementDate("EmployeeNo.": Code[20]) RetirementDate: Text
    var
        Age: Text;
        FucnDates: Codeunit 50043;
        HumanResourcesSetup: Record 5218;
    begin
        RetirementDate := '';
        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            HumanResourcesSetup.GET;
            RetirementDate := FORMAT(CALCDATE(HumanResourcesSetup."Retirement Age", Employee."Birth Date"));
        END;
    end;

    procedure GetEmployeeEmailAddress("EmployeeNo.": Code[20]) EmployeeEmailAddress: Text
    begin
        EmployeeEmailAddress := '';

        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            EmployeeEmailAddress := Employee."Company E-Mail";
        END;
    end;

    procedure GetEmployeeUserID("EmployeeNo.": Code[20]) EmployeeUserID: Text
    begin
        EmployeeUserID := '';

        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            EmployeeUserID := Employee."User ID";
        END;
    end;

    procedure CreateEmployeeDirectory("EmployeeNo.": Code[20])
    var
        CompanyDataDirectory: Text;
        EmployeeDataDirectory: Text;
        //  [RunOnClient]
        // DirectoryHelper: DotNet Directory;
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

        //IF NOT DirectoryHelper.Exists(EmployeeDirectoryPath) THEN BEGIN
        //    DirectoryHelper.CreateDirectory(EmployeeDirectoryPath);
        //END;
    end;

    procedure LoginEmployee("EmployeeNo.": Code[20]; Password: Text) LoginSuccessful: Boolean
    begin
        LoginSuccessful := FALSE;

        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            IF (Employee."Portal Password" = Password) THEN
                LoginSuccessful := TRUE;
        END;
    end;

    procedure IsEmployeeDefaultPassword("EmployeeNo.": Code[20]) IsDefaultPassword: Boolean
    begin
        IsDefaultPassword := FALSE;

        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            IF Employee."Default Portal Password" THEN
                IsDefaultPassword := TRUE;
        END;
    end;

    procedure SetPasswordResetToken("EmployeeNo.": Code[20]; PasswordResetToken: Text[250]) TokenSetSuccessfully: Boolean
    begin
        TokenSetSuccessfully := FALSE;

        Employee.RESET;
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

        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            PasswordResetToken := Employee.PasswordResetToken;
        END;
    end;

    procedure IsPasswordResetTokenExpired("EmployeeNo.": Code[20]; PasswordResetToken: Text[250]) TokenExpired: Boolean
    begin
        TokenExpired := FALSE;
        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            IF (CURRENTDATETIME > Employee.PasswordResetTokenExpiry) THEN
                TokenExpired := TRUE;
        END;
    end;

    procedure SendPasswordResetLink("EmployeeNo.": Code[20]; EmailMessage: Text) LinkSendSuccessful: Boolean
    var
        // SMTPMailSetup: Record 409;
        //    SMTPMail: Codeunit "SMTP Message";
        EmailCu: Codeunit Email;
        EmailMessageCu: Codeunit "Email Message";
        EmailSubject: Label 'New Password Setup';
        EmailSalutation: Label '<p>Dear %1,</p>';
        EmailSpacing: Label '<br>';
        EmailFooter: Label 'Sincerely,<br>%1, ICT Division';
        EmailFooter2: Label '<hr><p><i>This message was sent from an unmonitored email address. Please do not reply to this message.</i></p>';
        Email: Text;
        Receipients: List of [Text];
        Text_0001: Label 'No official email address found, contact ICT division for assistance';
    begin
        LinkSendSuccessful := FALSE;
        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            IF Employee."Company E-Mail" <> '' THEN BEGIN
                CompanyInformation.GET;
                //   SMTPMailSetup.GET;
                Receipients.Add(Employee."Company E-Mail");
                EmailMessageCu.Create(Format(Receipients), EmailSubject, EmailMessage);//.Name, SMTPMailSetup."User ID", Receipients, EmailSubject, '', TRUE);
                EmailMessageCu.AppendToBody((STRSUBSTNO(EmailSalutation, GetEmployeeName("EmployeeNo."))));
                EmailMessageCu.AppendToBody(EmailSpacing);
                EmailMessageCu.AppendToBody(EmailMessage);
                EmailMessageCu.AppendToBody(EmailSpacing);
                EmailMessageCu.AppendToBody(STRSUBSTNO(EmailFooter, CompanyInformation.Name));
                EmailMessageCu.AppendToBody(EmailFooter2);
                LinkSendSuccessful := EmailCu.Send(EmailMessageCu, Enum::"Email Scenario"::Default);
            END ELSE
                ERROR(Text_0001);
        END;
    end;

    procedure ResetEmployeePortalPassword("EmployeeNo.": Code[20]; NewPassword: Text[250]) PasswordResetSuccessful: Boolean
    begin
        PasswordResetSuccessful := FALSE;
        Employee.RESET;
        IF Employee.GET("EmployeeNo.") THEN BEGIN
            Employee."Portal Password" := NewPassword;
            Employee."Default Portal Password" := FALSE;
            Employee.PasswordResetTokenExpiry := CREATEDATETIME(CALCDATE('-1D', TODAY), TIME);
            IF Employee.MODIFY THEN
                PasswordResetSuccessful := TRUE;
        END;
    end;
}


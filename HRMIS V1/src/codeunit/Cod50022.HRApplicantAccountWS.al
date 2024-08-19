/// <summary>
/// Codeunit HR Applicant Account WS (ID 50022).
/// </summary>
codeunit 50022 "HR Applicant Account WS"
{

    trigger OnRun()
    begin
    end;

    var
        HROnlineApplicant: Record "HR  Online Applicant";
        SERVERDIRECTORYPATH: Label 'C:\inetpub\wwwroot\HWWK\EmployeeData\';
        TxtCharsToKeep: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    /// <summary>
    /// HROnlineApplicantEmailExist.
    /// </summary>
    /// <param name="EmailAddress">Text[100].</param>
    /// <returns>Return variable EmailExists of type Boolean.</returns>
    procedure HROnlineApplicantEmailExist(EmailAddress: Text[100]) EmailExists: Boolean
    begin
        EmailExists := FALSE;
        HROnlineApplicant.RESET;

        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            EmailExists := TRUE;
        END;
    end;

    /// <summary>
    /// CreateApplicantProfile.
    /// </summary>
    /// <param name="FirstName">Text[50].</param>
    /// <param name="Surname">Text[50].</param>
    /// <param name="EmailAddress">Text[100].</param>
    /// <returns>Return variable OnlineApplicantRegistered of type Boolean.</returns>
    procedure CreateApplicantProfile(FirstName: Text[50]; Surname: Text[50]; EmailAddress: Text[100]) OnlineApplicantRegistered: Boolean
    var
        CurriculumVitae: Record "Curriculum Vitae";
        CoverLetter: Record "Cover Letter";
        HROnlineApplicant2: Record "HR  Online Applicant";
    begin
        OnlineApplicantRegistered := FALSE;
        HROnlineApplicant.INIT;
        HROnlineApplicant.Firstname := FirstName;
        HROnlineApplicant.Surname := Surname;
        HROnlineApplicant."Email Address" := EmailAddress;
        IF HROnlineApplicant.INSERT THEN BEGIN
            OnlineApplicantRegistered := TRUE;
        END;

        InsertRequiredApplicationDocuments(EmailAddress);
    end;

    /// <summary>
    /// ModifyApplicantProfile.
    /// </summary>
    /// <param name="EmailAddress">Text[100].</param>
    /// <param name="MiddleName">Text[50].</param>
    /// <param name="DOB">Date.</param>
    /// <param name="IDNO">Code[20].</param>
    /// <param name="PostCode">Code[20].</param>
    /// <param name="PostalAddress">Text[100].</param>
    /// <param name="PhysicalAddress">Text[100].</param>
    /// <param name="Gender">Text[50].</param>
    /// <param name="City">Text[50].</param>
    /// <param name="Country">Text[50].</param>
    /// <param name="County">Text[50].</param>
    /// <param name="SubCounty">Text[50].</param>
    /// <param name="Citizenship">Text[50].</param>
    /// <param name="OtherCitizenship">Text[50].</param>
    /// <param name="MobilePhoneNo">Code[20].</param>
    /// <param name="AlternativeMobileNo">Code[20].</param>
    /// <param name="PersonWithDisability">Code[10].</param>
    /// <returns>Return variable HROnlineApplicantModified of type Boolean.</returns>
    procedure ModifyApplicantProfile(EmailAddress: Text[100]; MiddleName: Text[50]; DOB: Date; IDNO: Code[20]; PostCode: Code[20]; PostalAddress: Text[100]; PhysicalAddress: Text[100]; Gender: Text[50]; City: Text[50]; Country: Text[50]; County: Text[50]; SubCounty: Text[50]; Citizenship: Text[50]; OtherCitizenship: Text[50]; MobilePhoneNo: Code[20]; AlternativeMobileNo: Code[20]; PersonWithDisability: Code[10]) HROnlineApplicantModified: Boolean
    begin
        HROnlineApplicantModified := FALSE;
        HROnlineApplicant.RESET;
        HROnlineApplicant.SETRANGE(HROnlineApplicant."Email Address", EmailAddress);
        IF HROnlineApplicant.FINDFIRST THEN BEGIN
            HROnlineApplicant."Email Address" := HROnlineApplicant."Email Address";
            HROnlineApplicant.Firstname := HROnlineApplicant.Firstname;
            HROnlineApplicant.Middlename := MiddleName;
            HROnlineApplicant.Surname := HROnlineApplicant.Surname;
            HROnlineApplicant."Date of Birth" := DOB;
            HROnlineApplicant.VALIDATE(HROnlineApplicant."Date of Birth");
            HROnlineApplicant."National ID No." := IDNO;
            HROnlineApplicant.Address := PostalAddress;
            HROnlineApplicant."Post Code" := PostCode;
            HROnlineApplicant.Address2 := PhysicalAddress;
            CASE Gender OF
                'Male':
                    HROnlineApplicant.Gender := HROnlineApplicant.Gender::Male;
            END;
            CASE Gender OF
                'Female':
                    HROnlineApplicant.Gender := HROnlineApplicant.Gender::Female;
            END;
            HROnlineApplicant.City := City;
            HROnlineApplicant.Country := Country;
            HROnlineApplicant.County := County;
            HROnlineApplicant."County Name" := County;
            HROnlineApplicant.SubCounty := SubCounty;
            HROnlineApplicant."SubCounty Name" := SubCounty;
            HROnlineApplicant.Citizenship := Citizenship;
            HROnlineApplicant."Other Citizenship" := OtherCitizenship;
            HROnlineApplicant."Mobile Phone No." := MobilePhoneNo;
            HROnlineApplicant."Home Phone No." := AlternativeMobileNo;
            CASE PersonWithDisability OF
                'No':
                    HROnlineApplicant."Person With Disability" := HROnlineApplicant."Person With Disability"::No;
            END;
            CASE Gender OF
                'Yes':
                    HROnlineApplicant."Person With Disability" := HROnlineApplicant."Person With Disability"::Yes;
            END;
            MESSAGE(FORMAT(PersonWithDisability));
            IF HROnlineApplicant.MODIFY THEN BEGIN
                HROnlineApplicantModified := TRUE;
            END;
        END;
    end;

    /// <summary>
    /// GetFirstName.
    /// </summary>
    /// <param name="EmailAddress">Text[100].</param>
    /// <returns>Return variable Fname of type Text.</returns>
    procedure GetFirstName(EmailAddress: Text[100]) Fname: Text
    begin
        Fname := '';
        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            Fname := HROnlineApplicant.Firstname;
        END;
    end;

    /// <summary>
    /// GetSurname.
    /// </summary>
    /// <param name="EmailAddress">Text[100].</param>
    /// <returns>Return variable Sname of type Text.</returns>
    procedure GetSurname(EmailAddress: Text[100]) Sname: Text
    begin
        Sname := '';
        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            Sname := HROnlineApplicant.Surname;
        END;
    end;

    procedure GetDateOfBirth(EmailAddress: Text[100]) BirthDay: Text[30]
    begin
        BirthDay := '';
        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(BirthDay) THEN BEGIN
            BirthDay := FORMAT(HROnlineApplicant."Date of Birth");
        END;
    end;

    procedure GetHROnlineEmailAddress(EmailAddress: Text[100]) HROnlineEmail: Text
    begin
        HROnlineEmail := '';
        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            HROnlineEmail := HROnlineApplicant."Email Address";
        END;
    end;

    procedure GetHROnlineApplicantName(EmailAddress: Text[100]) HROnlineApplicantName: Text
    begin
        HROnlineApplicantName := '';
        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            HROnlineApplicantName := HROnlineApplicant.Firstname + ' ' + HROnlineApplicant.Middlename + ' ' + HROnlineApplicant.Surname;
        END;
    end;

    procedure GetHROnlineApplicantGender(EmailAddress: Text[100]) HROnlineApplicantGender: Text
    begin
        HROnlineApplicantGender := '';

        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            HROnlineApplicantGender := FORMAT(HROnlineApplicant.Gender);
        END;
    end;

    procedure LoginHROnlineApplicant(EmailAddress: Text[100]; Password: Text) LoginSuccessful: Boolean
    begin
        LoginSuccessful := FALSE;

        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            IF (HROnlineApplicant."Portal Password" = Password) THEN
                LoginSuccessful := TRUE;
        END;
    end;

    procedure IsHROnlineApplicantDefaultPassword(EmailAddress: Text[100]) IsDefaultPassword: Boolean
    begin
        IsDefaultPassword := FALSE;

        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            IF HROnlineApplicant."Default Portal Password" THEN
                IsDefaultPassword := TRUE;
        END;
    end;

    procedure SetPasswordResetToken(EmailAddress: Text[100]; PasswordResetToken: Text[250]) TokenSetSuccessfully: Boolean
    begin
        TokenSetSuccessfully := FALSE;
        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            HROnlineApplicant.PasswordResetToken := PasswordResetToken;
            HROnlineApplicant.PasswordResetTokenExpiry := CREATEDATETIME(CALCDATE('+1D', TODAY), TIME);
            IF HROnlineApplicant.MODIFY THEN
                TokenSetSuccessfully := TRUE;
        END;
    end;

    procedure GetPasswordResetToken(EmailAddress: Text[100]) PasswordResetToken: Text[250]
    begin
        PasswordResetToken := '';

        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            PasswordResetToken := HROnlineApplicant.PasswordResetToken;
        END;
    end;

    procedure IsPasswordResetTokenExpired(EmailAddress: Text[100]; PasswordResetToken: Text[250]) TokenExpired: Boolean
    begin
        TokenExpired := FALSE;
        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
            IF (CURRENTDATETIME > HROnlineApplicant.PasswordResetTokenExpiry) THEN
                TokenExpired := TRUE;
        END;
    end;

    procedure SendPasswordResetLink(EmailAddress: Text[100]; EmailMessage: Text) LinkSendSuccessful: Boolean
    var
        /*   SMTPMailSetup: Record "SMTP Mail Setup";
          SMTPMail: Codeunit "SMTP Mail"; */
        EmailSubject: Label 'New Password Setup.';
        EmailSalutation: Label '<p>Dear %1,</p>';
        EmailSpacing: Label '<br>';
        EmailFooter: Label 'Sincerely,<br>%1, ICT Division';
        EmailFooter2: Label '<hr><p><i>This message was sent from an unmonitored email address. Please do not reply to this message.</i></p>';
        CompanyInformation: Record "Company Information";
        ApplicantEmailAddress: List of [Text];
    begin
        /*  LinkSendSuccessful := FALSE;
         HROnlineApplicant.RESET;
         IF HROnlineApplicant.GET(EmailAddress) THEN BEGIN
             CompanyInformation.GET;
             ApplicantEmailAddress.Add(HROnlineApplicant."Email Address");
             SMTPMailSetup.GET;
             SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", ApplicantEmailAddress, EmailSubject, '', TRUE);
             SMTPMail.AppendBody(STRSUBSTNO(EmailSalutation, GetHROnlineApplicantName(EmailAddress)));
             SMTPMail.AppendBody(EmailMessage);
             SMTPMail.AppendBody(EmailSpacing);
             SMTPMail.AppendBody(STRSUBSTNO(EmailFooter, CompanyInformation.Name));
             SMTPMail.AppendBody(EmailFooter2);
             LinkSendSuccessful := SMTPMail.Send();
         END; */
    end;

    procedure ResetHROnlineApplicantPortalPassword(EmailAdddress: Text[100]; NewPassword: Text[250]) PasswordResetSuccessful: Boolean
    begin
        PasswordResetSuccessful := FALSE;
        HROnlineApplicant.RESET;
        IF HROnlineApplicant.GET(EmailAdddress) THEN BEGIN
            HROnlineApplicant."Portal Password" := NewPassword;
            HROnlineApplicant."Default Portal Password" := FALSE;
            HROnlineApplicant.PasswordResetTokenExpiry := CREATEDATETIME(CALCDATE('-1D', TODAY), TIME);
            IF HROnlineApplicant.MODIFY THEN
                PasswordResetSuccessful := TRUE;
        END;
    end;

    procedure InsertRequiredApplicationDocuments(EmailAddress: Code[80]) ApplicationDocumentsInserted: Boolean
    var
        CurriculumVitae: Record "Curriculum Vitae";
        CoverLetter: Record "Cover Letter";
        Text123: Label 'The Email is %1';
    begin

        ApplicationDocumentsInserted := FALSE;
        //curriculum vitae
        CurriculumVitae.INIT;
        CurriculumVitae."Email Address" := HROnlineApplicant."Email Address";
        CurriculumVitae."Document Code" := UPPERCASE('Curriculum Vitae');
        CurriculumVitae."Document Description" := UPPERCASE('Curriculum Vitae');
        CurriculumVitae."Document Attached" := FALSE;
        CurriculumVitae.INSERT;

        //cover letter
        CoverLetter.INIT;
        CoverLetter."Email Address" := HROnlineApplicant."Email Address";
        CoverLetter."Document Code" := UPPERCASE('Cover Letter');
        CoverLetter."Document Description" := UPPERCASE('Cover Letter');
        CoverLetter."Document Attached" := FALSE;
        CoverLetter.INSERT;

        ApplicationDocumentsInserted := TRUE;
    end;

    procedure ModifyCurriculumVitaeLocalURL(EmailAddress: Code[80]; DocumentCode: Code[50]; LocalURL: Text[250]) ApplicationDocumentModified: Boolean
    var
        CurriculumVitae: Record "Curriculum Vitae";
        FromString: Text;
        ToString: Text;
    begin
        ApplicationDocumentModified := FALSE;
        CurriculumVitae.RESET;
        CurriculumVitae.SETRANGE(CurriculumVitae."Email Address", EmailAddress);
        CurriculumVitae.SETRANGE(CurriculumVitae."Document Code", DocumentCode);
        IF CurriculumVitae.FINDFIRST THEN BEGIN
            CurriculumVitae."Local File URL" := LocalURL;
            CurriculumVitae."Document Attached" := TRUE;
            FromString := '\';
            ToString := '/';
            CurriculumVitae."Local File URL" := CONVERTSTR(CurriculumVitae."Local File URL", FromString, ToString);
            IF CurriculumVitae.MODIFY THEN
                ApplicationDocumentModified := TRUE;
        END;
    end;

    procedure ModifyCoverLetterLocalURL(EmailAddress: Code[80]; DocumentCode: Code[50]; LocalURL: Text[250]) ApplicationDocumentModified: Boolean
    var
        CoverLetter: Record "Cover Letter";
        FromString: Text;
        ToString: Text;
    begin
        ApplicationDocumentModified := FALSE;
        CoverLetter.RESET;
        CoverLetter.SETRANGE(CoverLetter."Email Address", EmailAddress);
        CoverLetter.SETRANGE(CoverLetter."Document Code", DocumentCode);
        IF CoverLetter.FINDFIRST THEN BEGIN
            CoverLetter."Local File URL" := LocalURL;
            CoverLetter."Document Attached" := TRUE;
            FromString := '\';
            ToString := '/';
            CoverLetter."Local File URL" := CONVERTSTR(CoverLetter."Local File URL", FromString, ToString);
            IF CoverLetter.MODIFY THEN
                ApplicationDocumentModified := TRUE;
        END;
    end;

    procedure CheckCurriculumVitaeAttached(EmailAddress: Code[80]) CurriculumVitaeAttached: Boolean
    var
        CurriculumVitae: Record "Curriculum Vitae";
    begin
        CurriculumVitaeAttached := FALSE;
        CurriculumVitae.RESET;
        CurriculumVitae.SETRANGE(CurriculumVitae."Email Address", EmailAddress);
        IF CurriculumVitae.FINDSET THEN BEGIN
            REPEAT
                IF CurriculumVitae."Local File URL" = '' THEN
                    ERROR(CurriculumVitae."Document Description" + ' has not been attached. This is a mandatory document at application.');
            UNTIL CurriculumVitae.NEXT = 0;
            CurriculumVitaeAttached := TRUE;
        END;
    end;

    procedure CheckCoverLetterAttached(EmailAddress: Code[80]) CoverLetterAttached: Boolean
    var
        CoverLetter: Record "Cover Letter";
    begin
        CoverLetterAttached := FALSE;
        CoverLetter.RESET;
        CoverLetter.SETRANGE(CoverLetter."Email Address", EmailAddress);
        IF CoverLetter.FINDSET THEN BEGIN
            REPEAT
                IF CoverLetter."Local File URL" = '' THEN
                    ERROR(CoverLetter."Document Description" + ' has not been attached. This is a mandatory document at application.');
            UNTIL CoverLetter.NEXT = 0;
            CoverLetterAttached := TRUE;
        END;
    end;

    procedure DeleteCurrilumVitae(EmailAddress: Code[80]) CurriculumVitaeDeleted: Boolean
    var
        CurriculumVitae: Record "Curriculum Vitae";
    begin
        CurriculumVitaeDeleted := FALSE;
        CurriculumVitae.RESET;
        CurriculumVitae.SETRANGE(CurriculumVitae."Email Address", EmailAddress);
        IF CurriculumVitae.FINDSET THEN BEGIN
            CurriculumVitae.DELETEALL;
            CurriculumVitaeDeleted := TRUE;
        END;
    end;

    procedure DeleteCoverLetter(EmailAddress: Code[80]) CoverLetterDeleted: Boolean
    var
        CoverLetter: Record "Cover Letter";
    begin
        CoverLetterDeleted := FALSE;
        CoverLetter.RESET;
        CoverLetter.SETRANGE(CoverLetter."Email Address", EmailAddress);
        IF CoverLetter.FINDSET THEN BEGIN
            CoverLetter.DELETEALL;
            CoverLetterDeleted := TRUE;
        END;
    end;
}


report 51120 SendPayslips
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                ORDER(Ascending)
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            dataitem(Employee; 5200)
            {
                DataItemTableView = SORTING("No.")
                                    WHERE(Status = CONST(Active));
                RequestFilterFields = "No.";

                trigger OnAfterGetRecord()
                var
                    Filename: Text;
                    Filepath: Text;
                    Subject: Text;
                    Body: Text;
                begin
                    CLEAR(Payslips);
                    Payslips.sSetParameters(Periods."Period ID", Employee."No.");
                    Filename := FORMAT(Employee."No.") + '_' + Periods."Period ID" + '_Payslip.pdf';
                    Filepath := 'C:\Payslip\' + Filename;

                    /*  IF FILE.EXISTS(Filepath) THEN
                         FILE.ERASE(Filepath);
                     Payslips.SAVEASPDF(Filepath);
                     ProgressWindow.UPDATE(1, Employee."No." + ':' + Employee.FullName);
                     Subject := 'Payslip for -' + MonthText;
                     SMTP.GET;
                     //SMTPMail.CreateMessage(SMTP."Sender Name",SMTP."Sender Email Address",Employee."Company E-Mail",Subject,'',TRUE);
                     SMTPMail.CreateMessage(SMTP."Sender Name", SMTP."Sender Email Address", Employee."Company E-Mail", Subject, '', TRUE);
                     SMTPMail.AddBCC('payrol@nakuruwater.co.ke');

                     SMTPMail.AppendBody('Dear' + ' ' + Employee."First Name" + ',');
                     SMTPMail.AppendBody('<br><br>');
                     Body := 'Herein, Please find your attached Payslip for ' + MonthText;
                     SMTPMail.AppendBody(Body);
                     SMTPMail.AppendBody('<br><br>');
                     SMTPMail.AppendBody('Thank you.');
                     SMTPMail.AppendBody('<br><br>');
                     SMTPMail.AppendBody('Regards,');
                     SMTPMail.AppendBody('<br><br>');
                     SMTPMail.AppendBody('HR & Administration Department');
                     SMTPMail.AppendBody('<br><br>');
                     SMTPMail.AppendBody('<br><br>');
                     SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this Email');
                     SMTPMail.AddAttachment(Filepath, Filename);
                     SMTPMail.Send;
                     ProgressWindow.UPDATE(1, Employee."No." + ':' + Employee.FullName);
  */

                    //END;
                end;

                trigger OnPostDataItem()
                begin
                    ProgressWindow.CLOSE;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                    //skm070307 payslip e-mailing
                    IF gvEmployeeNoFilter <> '' THEN BEGIN

                        SETFILTER("No.", '%1..%2', gvEmployeeNoMinFilter, gvEmployeeNoMaxFilter);

                    END;
                    ProgressWindow.OPEN('Sending payslip for Employee No. #1#######');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                MonthText := Periods.Description;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

                //skm070307 payslip e-mailing
                IF gvPeriodIDFilter <> '' THEN SETRANGE("Period ID", gvPeriodIDFilter);
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
        gsSegmentPayrollData;
        PayrollSetupRec.GET(gvAllowedPayrolls."Payroll Code");
        CompanyNameText := PayrollSetupRec."Employer Name";
        PeriodRec.SETCURRENTKEY("Start Date");
        PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        PeriodRec.FIND('-');
        gvPeriodIDFilter := Employee.GETFILTER("Period Filter");//ICS APR2018
        gvEmployeeNoFilter := Employee.GETFILTER("No.");//ICS APR2018
        IF gvEmployeeNoFilter <> '' THEN BEGIN
            gvEmployeeNoMaxFilter := Employee.GETRANGEMAX("No.");
            gvEmployeeNoMinFilter := Employee.GETRANGEMIN("No.");
        END;
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record 79;
        PeriodRec: Record 51151;
        EmployeeRec: Record 5200;
        PayrollSetupRec: Record 51165;
        HeaderRec: Record 51159;
        EDDefRec: Record 51158;
        TotalText: Text[60];
        NetPayText: Text[60];
        MonthText: Text[60];
        EmploNameText: Text[100];
        CompanyNameText: Text[100];
        TotalAmountDec: Decimal;
        NetPaydec: Decimal;
        CumilativeDec: Decimal;
        EmplankAccount: Record 51152;
        EmpBank: Text[30];
        AccountNo: Text[30];
        EmpBankBranch: Text[30];
        gvNhifNo: Code[20];
        gvNssfNo: Code[20];
        gvPinNo: Code[20];
        EndDate: Date;
        gvAllowedPayrolls: Record 51182;
        gvModeofPayment: Record 51187;
        gvPeriodIDFilter: Code[100];
        gvEmployeeNoFilter: Code[100];
        CalculationHeader: Record 51153;
        gvPayrollCode: Text[30];
        AmountCaptionLbl: Label 'Amount';
        Rate__RepaymentCaptionLbl: Label 'Rate/\Repayment';
        Quantity__InterestCaptionLbl: Label 'Quantity/\Interest';
        Branch_CaptionLbl: Label 'Branch:';
        Employee__Job_Title_CaptionLbl: Label 'Job Title :';
        Employee__No__CaptionLbl: Label 'Personnel No. :';
        Payslip_for_CaptionLbl: Label 'Payslip for:';
        EmploNameTextCaptionLbl: Label 'Employee Name :';
        Cumulative_Contribution___Total_Principal__To_DateCaptionLbl: Label 'Cumulative\Contribution /\Total Principal\ To Date';
        Outstanding_Principal_to_DateCaptionLbl: Label 'Outstanding\Principal to\Date';
        gvPinNoCaptionLbl: Label 'PIN Code';
        gvNhifNoCaptionLbl: Label 'NHIF No';
        gvNssfNoCaptionLbl: Label 'NSSF No';
        Bank_CaptionLbl: Label 'Bank:';
        Account_No_CaptionLbl: Label 'Account No.';
        Branch_Caption_Control1000000002Lbl: Label 'Branch:';
        Payroll_CodeCaptionLbl: Label 'Payroll Code';
        Dept_CodeCaptionLbl: Label 'Dept Code';
        IsPayslipLineP9: Boolean;
        payrollSetup: Record 51165;
        Payslips: Report 51150;
        // SMTP: Record 409;
        // SMTPMail: Codeunit 400;
        ProgressWindow: Dialog;
        gvEmployeeNoMinFilter: Code[100];
        gvEmployeeNoMaxFilter: Code[100];

    procedure sSetParameters(pPeriodIDFilter: Code[10]; pEmployeeNoFilter: Code[10])
    begin
        //skm080307 this function sets global parameters for filtering the payslip when e-mailing
        gvPeriodIDFilter := pPeriodIDFilter;
        gvEmployeeNoFilter := pEmployeeNoFilter;
    end;

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        gvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        gvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF NOT gvAllowedPayrolls.FINDFIRST THEN
            ERROR('You are not allowed access to this payroll dataset.');
    end;
}


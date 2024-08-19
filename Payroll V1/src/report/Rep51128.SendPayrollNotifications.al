report 51128 "Send Payroll Notifications"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Send Payroll Notifications.rdlc';

    dataset
    {
        dataitem(Periods; 51151)
        {
            DataItemTableView = SORTING("Start Date")
                                ORDER(Ascending)
                                WHERE(Status = FILTER(Open | Posted));
            RequestFilterFields = "Period ID";
            dataitem("Employee Payroll Notifications"; 50250)
            {
                DataItemLink = "Payroll Code" = FIELD("Payroll Code");

                trigger OnAfterGetRecord()
                begin
                    IF Employee.GET("Employee Payroll Notifications"."Employee no") THEN BEGIN

                        /*lvPayrollPeriod.SETCURRENTKEY("Start Date");
                        lvPayrollPeriod.SETRANGE(Status,1);
                        lvPayrollPeriod.SETRANGE("Payroll Code", "Employee Payroll Notifications"."Payroll Code");
                        IF lvPayrollPeriod.FIND('-') THEN ;
                        lvPayrollPeriod2.SETRANGE("Payroll Code", "Employee Payroll Notifications"."Payroll Code");
                          lvPayrollPeriod2.SETRANGE("Period ID",lvPayrollPeriod."Period ID");*/


                        // CLEAR(PayrollReconciliationAllED);


                        //{Periods.SETRANGE("Payroll Code","Employee Payroll Notifications"."Payroll Code");
                        //IF Periods.FINDFIRST THEN BEGIN
                        lvPayrollPeriod.SETRANGE("Payroll Code", Periods."Payroll Code");
                        lvPayrollPeriod.SETRANGE("Period ID", Periods."Period ID");
                        lvPayrollPeriod.FINDFIRST;


                        // PayrollReconciliationAllED.SETTABLEVIEW(lvPayrollPeriod);
                        //
                        Filename := Periods."Period ID" + '_Reconilliation.pdf';
                        Filepath := 'C:\Payslip\' + Filename;

                        /*  IF FILE.EXISTS(Filepath) THEN
                             FILE.ERASE(Filepath);
                         PayrollReconciliationAllED.SAVEASPDF(Filepath);

                         Subject := 'Payroll reconciliation for -' + Periods.Description;
                         SMTP.GET;
                         //SMTPMail.CreateMessage(SMTP."Sender Name",SMTP."Sender Email Address",Employee."Company E-Mail",Subject,'',TRUE);
                         SMTPMail.CreateMessage(SMTP."Sender Name", SMTP."Sender Email Address", Employee."Company E-Mail", Subject, '', TRUE);
                         //SMTPMail.AddBCC('payrol@nakuruwater.co.ke');

                         SMTPMail.AppendBody('Dear' + ' ' + Employee."First Name" + ',');
                         SMTPMail.AppendBody('<br><br>');
                         Body := 'Herein, Please find the attached ' + lvPayrollPeriod."Payroll Code" + ' Payroll reconciliation for ' + lvPayrollPeriod.Description;
                         SMTPMail.AppendBody(Body);
                         SMTPMail.AppendBody('<br><br>');
                         SMTPMail.AppendBody('Thank you.');
                         SMTPMail.AppendBody('<br><br>');
                         SMTPMail.AppendBody('Regards,');
                         SMTPMail.AppendBody('<br><br>');
                         SMTPMail.AppendBody('HR & Administration Department');
                         SMTPMail.AppendBody('<br><br>');
                         SMTPMail.AppendBody('<br><br>');
                         SMTPMail.AppendBody('This is a system generated mail. Please do not reply.');
                         SMTPMail.AddAttachment(Filepath, Filename);
                         SMTPMail.Send;*/
                    END;

                end;
            }

            trigger OnPreDataItem()
            begin
                //Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

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

    trigger OnPostReport()
    begin
        MESSAGE('Report successfully sent');
    end;

    trigger OnPreReport()
    begin
        gsSegmentPayrollData;
        PayrollSetupRec.GET(gvAllowedPayrolls."Payroll Code");
        PeriodRec.SETCURRENTKEY("Start Date");
        PeriodRec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        PeriodRec.FIND('-');
        gvPeriodIDFilter := Employee.GETFILTER("Period Filter");//ICS APR2018
    end;

    var
        Employee: Record 5200;
        //PayrollReconciliationAllED: Report 50115;
        //  SMTP: Record 409;
        //SMTPMail: Codeunit 400;
        lvPayrollPeriod: Record 51151;
        lvPayrollPeriod2: Record 51151;
        Filename: Text;
        Filepath: Text;
        Subject: Text;
        Body: Text;
        PeriodRec: Record 51151;
        gvAllowedPayrolls: Record 51182;
        gvPeriodIDFilter: Code[100];
        gvPayrollCode: Text[30];
        PayrollSetupRec: Record 51165;

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


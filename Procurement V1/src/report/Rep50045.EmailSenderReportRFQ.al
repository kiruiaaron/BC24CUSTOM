report 50045 "Email Sender-Report(RFQ)"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Request for Quotation Header"; 50049)
        {

            trigger OnAfterGetRecord()
            begin
                // SMTP.GET;
                RFQNumber := RFQNo;

                RFQVendor.RESET;
                RFQVendor.SETRANGE("RFQ Document No.", "Request for Quotation Header"."No.");
                IF RFQVendor.FINDSET THEN BEGIN
                    REPEAT

                        IF RFQVendor."E-Mail" <> '' THEN
                            ProgressWindow.OPEN('Sending RFQ for Vendor No. #1#######');
                        FileName := '';
                        // FileName := SMTP."Path to Save Documents" + 'RFQ.pdf';
                        /* REPORT.SAVEASPDF(REPORT::"Request for Quatation Report", FileName, "Request for Quotation Header");

                        SMTPMail.CreateMessage(SMTP."Sender Name", SMTP."Sender Email Address", RFQVendor."E-Mail", 'Request For Quatation Report', '', TRUE);

                        SMTPMail.AppendBody('Dear' + ' ' + RFQVendor."Vendor Name" + ',');
                        SMTPMail.AppendBody('<br><br>');
                        SMTPMail.AppendBody('Please find attached your Request for Quatation');
                        SMTPMail.AppendBody('<br><br>');
                        SMTPMail.AppendBody('Thank you.');
                        SMTPMail.AppendBody('<br><br>');
                        SMTPMail.AppendBody('Regards,');
                        SMTPMail.AppendBody('<br><br>');
                        SMTPMail.AppendBody(SMTP."Sender Name");
                        SMTPMail.AppendBody('<br><br>');
                        SMTPMail.AppendBody('<br><br>');
                        SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this Email');
                        SMTPMail.AddAttachment(FileName, RFQAttachment);
                        SMTPMail.Send; */
                        ProgressWindow.UPDATE(1, RFQVendor."Vendor No." + ':' + RFQVendor."Vendor Name");
                        ProgressWindow.CLOSE;
                    UNTIL RFQVendor.NEXT = 0;
                END;
                //END;
            end;

            trigger OnPostDataItem()
            begin
                MESSAGE(Text001);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(RFQNo; RFQNo)
                {
                    Caption = 'RFQNo';

                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Vendors: Record 23;
        /*   SMTP: Record 409;
          SMTPMail: Codeunit 400; */
        PayPeriod: Text;
        FileName: Text;
        RFQAttachment: Text;
        RFQVendor: Record 50051;
        PeriodName: Text;
        ProgressWindow: Dialog;
        RFQNumber: Code[30];
        Text001: Label 'Emails sent successfully';
        RFQNo: Code[30];
}


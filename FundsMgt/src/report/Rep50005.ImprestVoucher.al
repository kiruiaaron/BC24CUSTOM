report 50005 "Imprest Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Imprest Voucher.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Imprest Header"; 50008)
        {

            RequestFilterFields = "Cheque Type";
            column(No; "Imprest Header"."No.")
            {
            }
            column(ChequeNo; "Imprest Header"."Reference No.")
            {
            }
            column(Payee; "Imprest Header"."Employee Name")
            {
            }
            column(PaymentDate; "Imprest Header"."Posting Date")
            {
            }
            column(Bank; "Imprest Header"."Bank Account No.")
            {
            }
            column(BankName; "Imprest Header"."Bank Account Name")
            {
            }
            column(PhoneNo; "Imprest Header"."Phone No.")
            {
            }
            column(NumberText; NumberText[1])
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(CompanyInfoAddress; CompanyInfo.Address)
            {
            }
            column(CompanyInfoPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoPic; CompanyInfo.Picture)
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyWebPage; CompanyInfo."Home Page")
            {
            }
            column(BankAccountNo; BankAccountNo)
            {
            }
            column(PayeeAddress; PayeeAddress)
            {
            }
            column(PreparedBy; PreparedBy)
            {
            }
            column(CheckedBy; CheckedBy)
            {
            }
            column(AuthorisedBy; AuthorizedBy)
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            dataitem("Imprest Line"; 50009)
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(InvoiceDate; "Posting Date")
                {
                }
                column(ImprestCode; "Imprest Line"."Imprest Code")
                {
                }
                column(Amount; "Imprest Line"."Gross Amount")
                {
                }
                column(AmountLCY; "Imprest Line"."Gross Amount(LCY)")
                {
                }
                column(Description; "Imprest Line".Description)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Bank.GET("Imprest Line"."Account No.") THEN BEGIN
                        Payee := Bank.Name;
                    END;
                end;
            }
            dataitem("Approval Entry"; 454)
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Status = CONST(Approved));
                column(SequenceNo; "Approval Entry"."Sequence No.")
                {
                }
                column(LastDateTimeModified; "Approval Entry"."Last Date-Time Modified")
                {
                }
                column(ApproverID; "Approval Entry"."Approver ID")
                {
                }
                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID")
                {
                }
                column(SenderID; "Approval Entry"."Sender ID")
                {
                }
                dataitem(Employee; 5200)
                {
                    DataItemLink = "User ID" = FIELD("Approver ID");
                    column(EmployeeFirstName; Employee."First Name")
                    {
                    }
                    column(EmployeeMiddleName; Employee."Middle Name")
                    {
                    }
                    column(EmployeeLastName; Employee."Last Name")
                    {
                    }
                    column(EmployeeSignature; Employee."Employee Signature")
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmount := 0;
                "Imprest Header".CALCFIELDS("Imprest Header".Amount);
                TotalAmount := "Imprest Header".Amount;
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, (TotalAmount), "Imprest Header"."Currency Code");

                IF Bank.GET("Imprest Header"."Bank Account No.") THEN BEGIN
                    BankName := Bank.Name;
                    BankAccountNo := Bank."Bank Account No.";
                END;
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
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CheckReport: Report Check;
        NumberText: array[2] of Text[80];
        CompanyInfo: Record 79;
        Bank: Record 270;
        BankAccountNo: Code[20];
        BankName: Text[100];
        PayeeAddress: Text[100];
        InvoiceDate: Date;
        InvoiceNo: Code[50];
        TotalAmount: Decimal;
        PurchaseInvoice: Record 122;
        PreparedBy: Text;
        CheckedBy: Text;
        AuthorizedBy: Text;
        User: Record 2000000120;
        Vendor: Record 23;
        PostedInvoice: Record 122;
        Payee: Text;
}


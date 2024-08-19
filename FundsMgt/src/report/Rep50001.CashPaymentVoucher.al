report 50001 "Cash Payment Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Cash Payment Voucher.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Payment Header"; 50002)
        {
            DataItemTableView = WHERE("Payment Mode" = CONST(Cash));
            RequestFilterFields = "Cheque Type";
            column(No; "No.")
            {
            }
            column(ChequeNo; "Payment Header"."Reference No.")
            {
            }
            column(Payee; "Payment Header"."Payee Name")
            {
            }
            column(PaymentDate; "Posting Date")
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
            column(Bank; "Payment Header"."Bank Account No.")
            {
                IncludeCaption = true;
            }
            column(BankName; "Payment Header"."Bank Account Name")
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
            column(GrossAmount; "Total Amount")
            {
            }
            column(WithHoldingTaxAmount; "WithHolding Tax Amount")
            {
            }
            column(WHTPercentage; "WHT%")
            {
            }
            dataitem("Payment Line"; 50003)
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Line No.", "Document No.", "Payment Code")
                                    ORDER(Ascending);
                column(InvoiceDate; InvoiceDate)
                {
                }
                column(InvoiceNo; InvoiceNo)
                {
                }
                column(NetAmount; "Net Amount")
                {
                }
                column(Amount; "Total Amount")
                {
                }
                column(Description; Description)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Vendor.GET("Account No.") THEN BEGIN
                        PayeeAddress := Vendor.Address;
                    END;
                    IF PostedInvoice.GET("Applies-to Doc. No.") THEN BEGIN
                        InvoiceNo := PostedInvoice."Vendor Invoice No.";
                        InvoiceDate := PostedInvoice."Posting Date";
                    END;

                    IF "Withholding Tax Code" <> '' THEN BEGIN
                        IF FundsTaxCodes.GET("Withholding Tax Code") THEN
                            "WHT%" := FORMAT(FundsTaxCodes.Percentage);
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
                CALCFIELDS("Total Amount", "Net Amount", "WithHolding Tax Amount");
                TotalAmount := "Net Amount";
                // CheckReport.InitTextVariable();
                //CheckReport.FormatNoText(NumberText, ("Net Amount"), "Currency Code");

                IF Bank.GET("Bank Account No.") THEN BEGIN
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
        // CheckReport: Report Check;
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
        "WHT%": Text;
        FundsTaxCodes: Record 50028;
}


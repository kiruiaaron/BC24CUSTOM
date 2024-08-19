report 50013 "Funds Claim Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Funds Claim Voucher.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Funds Claim Header"; 50012)
        {
            column(No_FundsClaimHeader; "Funds Claim Header"."No.")
            {
            }
            column(ReferenceNo_FundsClaimHeader; "Funds Claim Header"."Reference No.")
            {
            }
            column(PayeeName_FundsClaimHeader; "Funds Claim Header"."Payee Name")
            {
            }
            column(PostingDate_FundsClaimHeader; "Funds Claim Header"."Posting Date")
            {
            }
            column(BankAccountNo_FundsClaimHeader; "Funds Claim Header"."Bank Account No.")
            {
            }
            column(BankAccountName_FundsClaimHeader; "Funds Claim Header"."Bank Account Name")
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
            dataitem("Funds Claim Line"; 50013)
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(PostingDate_FundsClaimLine; "Funds Claim Line"."Posting Date")
                {
                }
                column(FundsClaimCode_FundsClaimLine; "Funds Claim Line"."Funds Claim Code")
                {
                }
                column(Amount_FundsClaimLine; "Funds Claim Line".Amount)
                {
                }
                column(AmountLCY_FundsClaimLine; "Funds Claim Line"."Amount(LCY)")
                {
                }
                column(Description_FundsClaimLine; "Funds Claim Line".Description)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Bank.GET("Funds Claim Line"."Account No.") THEN BEGIN
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
                "Funds Claim Header".CALCFIELDS("Funds Claim Header".Amount);
                TotalAmount := "Funds Claim Header".Amount;
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, (TotalAmount), "Funds Claim Header"."Currency Code");

                IF Bank.GET("Funds Claim Header"."Bank Account No.") THEN BEGIN
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


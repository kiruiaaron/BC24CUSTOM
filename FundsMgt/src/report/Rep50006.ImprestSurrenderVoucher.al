report 50006 "Imprest Surrender Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Imprest Surrender Voucher.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Imprest Surrender Header"; 50010)
        {
            column(No; "Imprest Surrender Header"."No.")
            {
            }
            column(ImprestNo; "Imprest Surrender Header"."Imprest No.")
            {
            }
            column(Payee; "Imprest Surrender Line"."Account Name")
            {
            }
            column(EmployeeName_ImprestSurrenderHeader; "Imprest Surrender Header"."Employee Name")
            {
            }
            column(PaymentDate; "Imprest Surrender Header"."Posting Date")
            {
            }
            column(GlobalDimension1Code_ImprestSurrenderHeader; "Imprest Surrender Header"."Global Dimension 1 Code")
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
            column(ActualSpent_ImprestSurrenderHeader; "Imprest Surrender Header"."Actual Spent")
            {
            }
            column(Difference_ImprestSurrenderHeader; "Imprest Surrender Header".Difference)
            {
            }
            column(Amount_ImprestSurrenderHeader; "Imprest Surrender Header".Amount)
            {
            }
            dataitem("Imprest Surrender Line"; 50011)
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(InvoiceDate; "Imprest Surrender Line"."Posting Date")
                {
                }
                column(ImprestCode; "Imprest Surrender Line"."Imprest Code")
                {
                }
                column(Amount; "Imprest Surrender Line"."Gross Amount")
                {
                }
                column(AmountLCY; "Imprest Surrender Line"."Gross Amount(LCY)")
                {
                }
                column(Description; "Imprest Surrender Line".Description)
                {
                }
                column(ActualSpent_ImprestSurrenderLine; "Imprest Surrender Line"."Actual Spent")
                {
                }
                column(Difference_ImprestSurrenderLine; "Imprest Surrender Line".Difference)
                {
                }
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
        ImprestSurrender: Record 50010;
        PreparedBy: Text;
        CheckedBy: Text;
        AuthorizedBy: Text;
        User: Record 2000000120;
        Emp: Record 5200;
        PostedImp: Record 50008;
        Payee: Text;
}


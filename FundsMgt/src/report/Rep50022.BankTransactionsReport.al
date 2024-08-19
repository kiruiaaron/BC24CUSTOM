report 50022 "Bank Transactions Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Bank Transactions Report.rdlc';

    dataset
    {
        dataitem("Bank Account Ledger Entry"; 271)
        {
            RequestFilterFields = "Posting Date", "Document No.", "Bank Account No.", "External Document No.", "User ID";
            column(EntryNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Entry No.")
            {
            }
            column(BankAccountNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Bank Account No.")
            {
            }
            column(PostingDate_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Posting Date")
            {
            }
            column(DocumentType_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Document Type")
            {
            }
            column(DocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Document No.")
            {
            }
            column(Description_BankAccountLedgerEntry; "Bank Account Ledger Entry".Description)
            {
            }
            column(CurrencyCode_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Currency Code")
            {
            }
            column(Amount_BankAccountLedgerEntry; "Bank Account Ledger Entry".Amount)
            {
            }
            column(DebitAmount_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Debit Amount")
            {
            }
            column(CreditAmount_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Credit Amount")
            {
            }
            column(DebitAmountLCY_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Debit Amount (LCY)")
            {
            }
            column(CreditAmountLCY_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Credit Amount (LCY)")
            {
            }
            column(ExternalDocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."External Document No.")
            {
            }
            column(UserID_BankAccountLedgerEntry; "Bank Account Ledger Entry"."User ID")
            {
            }
            column(BankName; BankName)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2; CompanyInfo."Address 2")
            {
            }
            column(pic; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo_Phone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_Fax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Email; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfo_Web; CompanyInfo."Home Page")
            {
            }
            dataitem("Approval Entry"; 454)
            {
                DataItemLink = "Document No." = FIELD("Document No.");
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
                IF BankAccount.GET("Bank Account Ledger Entry"."Bank Account No.") THEN
                    BankName := BankAccount.Name;
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
        CompanyInfo.CALCFIELDS(Picture)
    end;

    var
        CompanyInfo: Record 79;
        BankName: Text;
        BankAccount: Record 270;
}


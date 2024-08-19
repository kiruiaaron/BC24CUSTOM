report 50021 "Journal Voucher Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Journal Voucher Report.rdlc';

    dataset
    {
        dataitem("Journal Voucher Header"; 50016)
        {
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
            column(JVNo_JournalVoucherHeader; "Journal Voucher Header"."JV No.")
            {
            }
            column(Documentdate_JournalVoucherHeader; "Journal Voucher Header"."Document date")
            {
            }
            column(PostingDate_JournalVoucherHeader; "Journal Voucher Header"."Posting Date")
            {
            }
            column(DateCreated_JournalVoucherHeader; "Journal Voucher Header"."Date Created")
            {
            }
            column(UserID_JournalVoucherHeader; "Journal Voucher Header"."User ID")
            {
            }
            column(Status_JournalVoucherHeader; "Journal Voucher Header".Status)
            {
            }
            column(Description_JournalVoucherHeader; "Journal Voucher Header".Description)
            {
            }
            column(JVLinesCont_JournalVoucherHeader; "Journal Voucher Header"."JV Lines Cont")
            {
            }
            column(TotalAmount_JournalVoucherHeader; "Journal Voucher Header"."Total Amount")
            {
            }
            column(NoSeries_JournalVoucherHeader; "Journal Voucher Header"."No. Series")
            {
            }
            column(Posted_JournalVoucherHeader; "Journal Voucher Header".Posted)
            {
            }
            column(TimePosted_JournalVoucherHeader; "Journal Voucher Header"."Time Posted")
            {
            }
            column(PostedBy_JournalVoucherHeader; "Journal Voucher Header"."Posted By")
            {
            }
            column(Reversed_JournalVoucherHeader; "Journal Voucher Header".Reversed)
            {
            }
            column(ReversalDate_JournalVoucherHeader; "Journal Voucher Header"."Reversal Date")
            {
            }
            column(ReversalTime_JournalVoucherHeader; "Journal Voucher Header"."Reversal Time")
            {
            }
            column(ReversedBy_JournalVoucherHeader; "Journal Voucher Header"."Reversed By")
            {
            }
            dataitem("Journal Voucher Lines"; 50017)
            {
                DataItemLink = "JV No." = FIELD("JV No.");
                column(JVNo_JournalVoucherLines; "Journal Voucher Lines"."JV No.")
                {
                }
                column(AccountName_JournalVoucherLines; "Journal Voucher Lines"."Account Name")
                {
                }
                column(BalAccountName_JournalVoucherLines; "Journal Voucher Lines"."Bal. Account Name")
                {
                }
                column(LineNo_JournalVoucherLines; "Journal Voucher Lines"."Line No.")
                {
                }
                column(AccountType_JournalVoucherLines; "Journal Voucher Lines"."Account Type")
                {
                }
                column(AccountNo_JournalVoucherLines; "Journal Voucher Lines"."Account No.")
                {
                }
                column(PostingDate_JournalVoucherLines; "Journal Voucher Lines"."Posting Date")
                {
                }
                column(DocumentType_JournalVoucherLines; "Journal Voucher Lines"."Document Type")
                {
                }
                column(DocumentNo_JournalVoucherLines; "Journal Voucher Lines"."Document No.")
                {
                }
                column(Description_JournalVoucherLines; "Journal Voucher Lines".Description)
                {
                }
                column(VAT_JournalVoucherLines; "Journal Voucher Lines"."VAT %")
                {
                }
                column(BalAccountNo_JournalVoucherLines; "Journal Voucher Lines"."Bal. Account No.")
                {
                }
                column(CurrencyCode_JournalVoucherLines; "Journal Voucher Lines"."Currency Code")
                {
                }
                column(Amount_JournalVoucherLines; "Journal Voucher Lines".Amount)
                {
                }
                column(DebitAmount_JournalVoucherLines; "Journal Voucher Lines"."Debit Amount")
                {
                }
                column(CreditAmount_JournalVoucherLines; "Journal Voucher Lines"."Credit Amount")
                {
                }
                column(AmountLCY_JournalVoucherLines; "Journal Voucher Lines"."Amount (LCY)")
                {
                }
                column(BalanceLCY_JournalVoucherLines; "Journal Voucher Lines"."Balance (LCY)")
                {
                }
                column(CurrencyFactor_JournalVoucherLines; "Journal Voucher Lines"."Currency Factor")
                {
                }
                column(ShortcutDimension1Code_JournalVoucherLines; "Journal Voucher Lines"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_JournalVoucherLines; "Journal Voucher Lines"."Shortcut Dimension 2 Code")
                {
                }
                column(AppliestoDocType_JournalVoucherLines; "Journal Voucher Lines"."Applies-to Doc. Type")
                {
                }
                column(AppliestoDocNo_JournalVoucherLines; "Journal Voucher Lines"."Applies-to Doc. No.")
                {
                }
                column(BalAccountType_JournalVoucherLines; "Journal Voucher Lines"."Bal. Account Type")
                {
                }
                column(ExternalDocumentNo_JournalVoucherLines; "Journal Voucher Lines"."External Document No.")
                {
                }
                column(FAPostingDate_JournalVoucherLines; "Journal Voucher Lines"."FA Posting Date")
                {
                }
                column(FAPostingType_JournalVoucherLines; "Journal Voucher Lines"."FA Posting Type")
                {
                }
                column(DepreciationBookCode_JournalVoucherLines; "Journal Voucher Lines"."Depreciation Book Code")
                {
                }
                column(Description2_JournalVoucherLines; "Journal Voucher Lines".Description2)
                {
                }
                column(ShortcutDimension3Code_JournalVoucherLines; "Journal Voucher Lines"."Shortcut Dimension 3 Code")
                {
                }
                column(ShortcutDimension4Code_JournalVoucherLines; "Journal Voucher Lines"."Shortcut Dimension 4 Code")
                {
                }
                column(ShortcutDimension5Code_JournalVoucherLines; "Journal Voucher Lines"."Shortcut Dimension 5 Code")
                {
                }
                column(ShortcutDimension6Code_JournalVoucherLines; "Journal Voucher Lines"."Shortcut Dimension 6 Code")
                {
                }
                column(ShortcutDimension7Code_JournalVoucherLines; "Journal Voucher Lines"."Shortcut Dimension 7 Code")
                {
                }
                column(ShortcutDimension8Code_JournalVoucherLines; "Journal Voucher Lines"."Shortcut Dimension 8 Code")
                {
                }
                column(PostingGroup_JournalVoucherLines; "Journal Voucher Lines"."Posting Group")
                {
                }
                column(Posted_JournalVoucherLines; "Journal Voucher Lines".Posted)
                {
                }
                column(DatePosted_JournalVoucherLines; "Journal Voucher Lines"."Date Posted")
                {
                }
                column(PostedBy_JournalVoucherLines; "Journal Voucher Lines"."Posted By")
                {
                }
                column(TimePosted_JournalVoucherLines; "Journal Voucher Lines"."Time Posted")
                {
                }
            }
            dataitem("Approval Entry"; 454)
            {
                DataItemLink = "Document No." = FIELD("No. Series");
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
        CompanyInfo.CALCFIELDS(Picture)
    end;

    var
        CompanyInfo: Record 79;
}


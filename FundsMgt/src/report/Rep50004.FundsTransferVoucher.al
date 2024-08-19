report 50004 "Funds Transfer Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Funds Transfer Voucher.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Funds Transfer Header"; 50006)
        {

            RequestFilterFields = "Cheque Type";
            column(No; "No.")
            {
            }
            column(ChequeNo; "Reference No.")
            {
            }
            column(Payee; "Funds Transfer Header".Payee)
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
            column(Bank; "Funds Transfer Header"."Bank Account No.")
            {
                IncludeCaption = true;
            }
            column(BankName; "Funds Transfer Header"."Bank Account Name")
            {
            }
            column(TransferTo_FundsTransferHeader; "Funds Transfer Header"."Transfer To")
            {
            }
            column(BankAccountNo; BankAccountNo)
            {
            }
            column(PayeeAddress; PayeeAddress)
            {
            }
            column(LNo; LNo)
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
            column(UserRecApp1; UserRecApp1.Picture)
            {
            }
            column(UserRecApp2; UserRecApp2.Picture)
            {
            }
            column(UserRecApp3; UserRecApp3.Picture)
            {
            }
            column(Approver1; "1stApprover")
            {
            }
            column(Approver2; "2ndApprover")
            {
            }
            column(approverDate1; "1stapproverDate")
            {
            }
            column(approverdate2; "2ndapproverdate")
            {
            }
            column(Approver3; "3rdApprover")
            {
            }
            column(Approverdate3; "3rdApproverdate")
            {
            }
            column(Approver4; "4thApprover")
            {
            }
            column(Approverdate4; "4thApproverdate")
            {
            }
            column(Approver5; "5thApprover")
            {
            }
            column(Approverdate5; "5thApproverdate")
            {
            }
            dataitem(DataItem15; 39)
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");

                trigger OnAfterGetRecord()
                begin
                    LNo := LNo + 1;
                end;
            }
            dataitem("Funds Transfer Line"; 50007)
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(InvoiceDate; "Posting Date")
                {
                }
                column(InvoiceNo; "Funds Transfer Line"."Document No.")
                {
                }
                column(NetAmount; "Funds Transfer Line".Amount)
                {
                }
                column(Amount; "Funds Transfer Line"."Amount(LCY)")
                {
                }
                column(AccountName_FundsTransferLine; "Funds Transfer Line"."Account Name")
                {
                }
                column(Description; "Funds Transfer Line".Description)
                {
                }
                column(MoneyTransferDescription_FundsTransferLine; "Funds Transfer Line"."Money Transfer Description")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Bank.GET("Funds Transfer Line"."Account No.") THEN BEGIN
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

                TotalAmount := "Funds Transfer Header"."Amount To Transfer";
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, (TotalAmount), "Funds Transfer Header"."Currency Code");

                IF Bank.GET("Funds Transfer Header"."Bank Account No.") THEN BEGIN
                    BankName := Bank.Name;
                    BankAccountNo := Bank."Bank Account No.";
                END;
                ApprovalEntries.RESET;
                ApprovalEntries.SETRANGE(ApprovalEntries."Table ID", 50006);
                ApprovalEntries.SETRANGE(ApprovalEntries."Document No.", "Funds Transfer Header"."No.");
                ApprovalEntries.SETRANGE(ApprovalEntries.Status, ApprovalEntries.Status::Approved);
                IF ApprovalEntries.FIND('-') THEN //BEGIN
                BEGIN
                    //IF ApprovalEntries."Sequence No.":=0;
                    REPEAT
                        IF ApprovalEntries."Sequence No." = 1 THEN
                        //MESSAGE("1stApprover");

                        //IF i=1 THEN
                        BEGIN
                            //IF ApprovalEntries."Sender ID"=ApprovalEntries."Sender ID" THEN
                            "1stApprover" := ApprovalEntries."Sender ID";
                            "1stapproverDate" := ApprovalEntries."Last Date-Time Modified";
                            IF UserRecApp1.GET("1stApprover") THEN BEGIN
                                UserRecApp1.CALCFIELDS(UserRecApp1.Picture);
                            END;
                        END;
                        //MESSAGE("2stApprover");
                        IF ApprovalEntries."Sequence No." = 1 THEN
                        //IF i=1 THEN
                        BEGIN
                            //IF ApprovalEntries."Sender ID"<>ApprovalEntries."Approver ID" THEN
                            "2ndApprover" := ApprovalEntries."Approver ID";
                            "2ndapproverdate" := ApprovalEntries."Last Date-Time Modified";
                            IF UserRecApp2.GET("2ndApprover") THEN BEGIN
                                UserRecApp2.CALCFIELDS(UserRecApp2.Picture);
                            END;
                        END;
                        //MESSAGE("3ndApprover");
                        IF ApprovalEntries."Sequence No." = 2 THEN
                        //IF i=2 THEN
                        BEGIN
                            //IF ApprovalEntries."Sender ID"<>ApprovalEntries."Approver ID" THEN
                            "3rdApprover" := ApprovalEntries."Approver ID";
                            "3rdApproverdate" := ApprovalEntries."Last Date-Time Modified";
                            IF UserRecApp3.GET("3rdApprover") THEN BEGIN
                                UserRecApp3.CALCFIELDS(UserRecApp3.Picture);
                            END;
                        END;
                    /*IF ApprovalEntries."Sequence No."=3 THEN
                   //IF i=3 THEN
                   BEGIN
                   "4thApprover":=ApprovalEntries."Approver ID";
                   "4thApproverdate":=ApprovalEntries."Last Date-Time Modified";
                    IF UserRecApp4.GET("4thApprover") THEN
                    UserRecApp4.CALCFIELDS(UserRecApp4.Picture);
                   END;

                   IF ApprovalEntries."Sequence No."=4 THEN
                   //IF i=4 THEN
                   BEGIN
                   "5thApprover":=ApprovalEntries."Approver ID";
                   "5thApproverdate":=ApprovalEntries."Last Date-Time Modified";
                    IF UserRecApp4.GET("5thApprover") THEN
                    UserRecApp5.CALCFIELDS(UserRecApp5.Picture);

                   END;*/


                    //END;

                    UNTIL ApprovalEntries.NEXT = 0;
                END;
                //END;
                //Get Signatures from the UserSetup Table****End

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
        i: Integer;
        UserRec: Record 91;
        "1stApprover": Text[100];
        "2ndApprover": Text[100];
        "1stapproverDate": DateTime;
        "2ndapproverdate": DateTime;
        UserRecApp1: Record 91;
        UserRecApp2: Record 91;
        UserRecApp3: Record 91;
        "3rdApprover": Text[100];
        "3rdApproverdate": DateTime;
        ApprovalEntries: Record 454;
        ImprestHeader: Record 50008;
        "4thApprover": Text[100];
        "4thApproverdate": DateTime;
        "5thApprover": Text[100];
        "5thApproverdate": DateTime;
        UserRecApp4: Record 91;
        UserRecApp5: Record 91;
        LNo: Integer;
        Employees: Record 5200;
}


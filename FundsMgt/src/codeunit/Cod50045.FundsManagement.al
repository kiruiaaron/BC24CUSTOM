codeunit 50045 "Funds Management"
{

    trigger OnRun()
    begin
    end;

    var
        TaxCodes: Record 50028;
        AdjustGenJnl: Codeunit 407;
        DocPrint: Codeunit 229;
        ReversalEntry: Record 179;
        GLEntry: Record 17;
        FundsSetup: Record 50031;
        CustEntry: Record 21;
        CustEntry2: Record 21;
        GenJnlPost: Codeunit 231;
        PAYMENTJNL: Label 'PAYMENTJNL';
        RECEIPTJNL: Label 'RECEIPTJNL';
        TRANJNL: Label 'TRANJNL';
        IMPJNL: Label 'IMPJNL';
        IMPSURRJNL: Label 'IMPSURRJNL';
        ImprestHeader: Record 50008;
        // SMTPMail: Codeunit smtp m;
        // SMTP: Record 409;
        ChequeRegisterLines: Record 50025;
        //"HRLoanMgt.": Codeunit 50078;
        //EmployeeLoanDisbursement: Record 50076;
        //HRLoanProducts: Record 50082;
        FundsGeneralSetup: Record 50031;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text_0001: Label 'Loan %1 Repayment';
        FundsTransactionCode: Record 50027;
        Text_0002: Label 'Loan  %1  repayment';
        //   InvstReceiptApplication: Codeunit 50064;
        TransactionNo: Integer;
        DocNo: Code[20];
        InvNo: Code[20];
        TotalDisbursedAmount: Decimal;
        Amount1: Decimal;
        FundsTransactionCodes: Record 50027;
        FundsTaxCode: Record 50028;

    procedure PostPayment("Payment Header": Record 50002; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        PaymentLine: Record 50003;
        PaymentHeader: Record 50002;
        SourceCode: Code[20];
        BankLedgerEntries: Record 271;
        PaymentLine2: Record 50003;
        PaymentHeader2: Record 50002;
        DocumentExist: Label 'Payment Document is already posted, "Document No.":%1 already exists in Bank No:%2';
        // EmployeeLoanAccounts: Record 50075;
        //LoanRepayment: Record 50077;
        PaymentCodes: Record 50027;
        ImprestLine: Record 50009;
    begin
        PaymentHeader.TRANSFERFIELDS("Payment Header", TRUE);
        SourceCode := PAYMENTJNL;
        /*
        BankLedgerEntries.RESET;
        BankLedgerEntries.SETRANGE(BankLedgerEntries."Document No.",PaymentHeader."No.");
        BankLedgerEntries.SETRANGE(BankLedgerEntries.Reversed,FALSE);
        IF BankLedgerEntries.FINDFIRST THEN BEGIN
          ERROR(DocumentExist,PaymentHeader."No.",PaymentHeader."Bank Account No.");
        END;
        */
        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;
        //*********************************************Add Payment Header***************************************************************//
        PaymentHeader.CALCFIELDS("Net Amount");
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE("Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE("Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := PaymentHeader."No.";
        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
        GenJnlLine."Cheque No." := PaymentHeader."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := PaymentHeader."Bank Account No.";
        GenJnlLine.VALIDATE("Account No.");
        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
        GenJnlLine.VALIDATE("Currency Code");
        GenJnlLine.Amount := -(PaymentHeader."Net Amount");  //Credit Amount
        GenJnlLine.VALIDATE(Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE("Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := UPPERCASE(COPYSTR(PaymentHeader.Description, 1, 100));
        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
        GenJnlLine.VALIDATE(Description);
        IF PaymentHeader."Loan No." <> '' THEN BEGIN
            GenJnlLine."Investment Account No." := PaymentHeader."Loan No.";
            GenJnlLine."Investment Transaction Type" := GenJnlLine."Investment Transaction Type"::"Loan Disbursement";
        END;
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;
        //************************************************End Add to Bank***************************************************************//

        //***********************************************Add Payment Lines**************************************************************//
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", PaymentHeader."No.");
        PaymentLine.SETFILTER("Total Amount", '<>%1', 0);
        IF PaymentLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line Amounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE("Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE("Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                GenJnlLine."Document No." := PaymentLine."Document No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Account Type" := PaymentLine."Account Type";
                GenJnlLine."Account No." := PaymentLine."Account No.";
                GenJnlLine.VALIDATE("Account No.");
                GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                PaymentHeader.CALCFIELDS("Total Amount");
                GenJnlLine.Amount := PaymentLine."Total Amount" - PaymentLine."Retention Amount";//-PaymentLine."Withholding Tax Amount"-PaymentLine."Withholding VAT Amount";  //Debit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                IF PaymentHeader."Loan No." <> '' THEN BEGIN
                    GenJnlLine."Investment Account No." := PaymentHeader."Loan No.";
                    GenJnlLine."Investment Transaction Type" := GenJnlLine."Investment Transaction Type"::"Loan Disbursement";
                END;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PaymentLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PaymentLine."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, PaymentLine."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, PaymentLine."Shortcut Dimension 6 Code");
                GenJnlLine.ValidateShortcutDimCode(7, PaymentLine."Shortcut Dimension 7 Code");
                GenJnlLine.ValidateShortcutDimCode(8, PaymentLine."Shortcut Dimension 8 Code");
                GenJnlLine.Description := UPPERCASE(COPYSTR(PaymentLine.Description, 1, 100));
                GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                GenJnlLine.VALIDATE(Description);
                GenJnlLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                GenJnlLine.VALIDATE("Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                GenJnlLine."Employee Transaction Type" := PaymentLine."Employee Transaction Type";
                IF PaymentHeader."Loan No." <> '' THEN BEGIN
                    GenJnlLine."Investment Account No." := PaymentHeader."Loan No.";
                    GenJnlLine."Investment Transaction Type" := GenJnlLine."Investment Transaction Type"::"Loan Disbursement";
                END;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;



            UNTIL PaymentLine.NEXT = 0;
        END;
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", PaymentHeader."No.");
        PaymentLine.SETFILTER("Total Amount", '<>%1', 0);
        IF PaymentLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line Amounts***********************************************************//


                //**************************************Add W/TAX Amounts************************************************************//
                IF PaymentLine."Withholding Tax Code" <> '' THEN BEGIN
                    TaxCodes.RESET;
                    TaxCodes.SETRANGE("Tax Code", PaymentLine."Withholding Tax Code");
                    IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD("Account No.");
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE("Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE("Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PaymentLine."Document No.";
                        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No.";
                        GenJnlLine.VALIDATE("Account No.");
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE("Currency Code");
                        GenJnlLine.Amount := -(PaymentLine."Withholding Tax Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        // GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        // GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        IF PaymentHeader."Payment Type" = "Payment Header"."Payment Type"::"Project Payment" THEN
                            GenJnlLine.Description := UPPERCASE(COPYSTR('W/TAX:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name") + '-Project', 1, 100))
                        ELSE
                            GenJnlLine.Description := UPPERCASE(COPYSTR('W/TAX:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name"), 1, 100));

                        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        //W/TAX Balancing
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE("Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE("Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PaymentLine."Document No.";
                        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                        GenJnlLine."Account Type" := PaymentLine."Account Type";
                        GenJnlLine."Account No." := PaymentLine."Account No.";
                        GenJnlLine.VALIDATE("Account No.");
                        GenJnlLine."Posting Group" := PaymentLine."Posting Group";
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE("Currency Code");
                        GenJnlLine.Amount := PaymentLine."Withholding Tax Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        // GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        // GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        IF PaymentHeader."Payment Type" = "Payment Header"."Payment Type"::"Project Payment" THEN
                            GenJnlLine.Description := UPPERCASE(COPYSTR('W/TAX:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name" + '-Project'), 1, 100))

                        ELSE
                            GenJnlLine.Description := UPPERCASE(COPYSTR('W/TAX:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name"), 1, 100));
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                        GenJnlLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                        GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE("Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                        GenJnlLine."Employee Transaction Type" := PaymentLine."Employee Transaction Type";
                        /*IF GenJnlLine.Amount<>0 THEN
                            GenJnlLine.INSERT;*/
                    END;
                END;
                //****************************************End Add W/TAX Amounts************************************************************//

                //****************************************Add W/VAT Amounts***************************************************************//
                IF PaymentLine."Withholding VAT Code" <> '' THEN BEGIN
                    TaxCodes.RESET;
                    TaxCodes.SETRANGE("Tax Code", PaymentLine."Withholding VAT Code");
                    IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD("Account No.");
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE("Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE("Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PaymentLine."Document No.";
                        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No.";
                        GenJnlLine.VALIDATE("Account No.");
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE("Currency Code");
                        GenJnlLine.Amount := -(PaymentLine."Withholding VAT Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        //GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        // GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        IF PaymentHeader."Payment Type" = "Payment Header"."Payment Type"::"Project Payment" THEN
                            GenJnlLine.Description := UPPERCASE(COPYSTR('W/VAT:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name") + '-Project', 1, 100))

                        ELSE
                            GenJnlLine.Description := UPPERCASE(COPYSTR('W/VAT:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name"), 1, 100));
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        //W/VAT Balancing
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE("Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE("Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PaymentLine."Document No.";
                        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                        GenJnlLine."Account Type" := PaymentLine."Account Type";
                        GenJnlLine."Account No." := PaymentLine."Account No.";
                        GenJnlLine.VALIDATE("Account No.");
                        GenJnlLine."Posting Group" := PaymentLine."Posting Group";
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE("Currency Code");
                        GenJnlLine.Amount := PaymentLine."Withholding VAT Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        //GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        // GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        IF PaymentHeader."Payment Type" = "Payment Header"."Payment Type"::"Project Payment" THEN
                            GenJnlLine.Description := UPPERCASE(COPYSTR('W/VAT:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name" + '-Project'), 1, 100))

                        ELSE
                            GenJnlLine.Description := UPPERCASE(COPYSTR('W/VAT:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name"), 1, 100));
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                        GenJnlLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                        GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE("Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                        GenJnlLine."Employee Transaction Type" := PaymentLine."Employee Transaction Type";
                        /*IF GenJnlLine.Amount<>0 THEN
                            GenJnlLine.INSERT;*/
                    END;
                END;
                //***********************************End Add W/VAT Amounts*************************************************************//

                //*******Surrender Board allowance********************
                //imprestTAX
                IF PaymentLine."Payee Type" = PaymentLine."Payee Type"::Imprest THEN BEGIN
                    ImprestLine.RESET;
                    ImprestLine.SETRANGE("Document No.", PaymentLine."Payee No.");
                    IF ImprestLine.FINDFIRST THEN
                        REPEAT
                            LineNo := LineNo + 1;
                            GenJnlLine.INIT;
                            GenJnlLine."Journal Template Name" := "Journal Template";
                            GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                            GenJnlLine."Journal Batch Name" := "Journal Batch";
                            GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                            GenJnlLine."Source Code" := SourceCode;
                            GenJnlLine."Line No." := LineNo;
                            GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::"Imprest Surrender";
                            GenJnlLine."Document No." := ImprestLine."Document No.";
                            GenJnlLine."Account Type" := ImprestLine."Account Type";
                            GenJnlLine."Account No." := ImprestLine."Account No.";
                            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                            IF ImprestLine."Account Type" <> ImprestLine."Account Type"::"G/L Account" THEN BEGIN
                                GenJnlLine."Posting Group" := ImprestLine."Posting Group";
                                GenJnlLine.VALIDATE("Posting Group");
                            END;
                            //GenJnlLine."Currency Code":=ImprestSurrenderHeader."Currency Code";
                            GenJnlLine.VALIDATE("Currency Code");
                            GenJnlLine.Amount := ImprestLine."Tax Amount";  //Debit Amount
                            GenJnlLine.VALIDATE(GenJnlLine.Amount);
                            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                            FundsTransactionCodes.RESET;
                            FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code", ImprestLine."Imprest Code");
                            FundsTransactionCodes.FINDFIRST;
                            IF FundsTransactionCodes."Include Withholding Tax" THEN BEGIN
                                FundsTransactionCodes.TESTFIELD("Withholding Tax Code");
                                FundsTaxCode.GET(FundsTransactionCodes."Withholding Tax Code");

                                FundsTaxCode.TESTFIELD("Account No.");

                            END;


                            GenJnlLine."Bal. Account No." := FundsTaxCode."Account No.";
                            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                            GenJnlLine."Shortcut Dimension 1 Code" := ImprestLine."Global Dimension 1 Code";
                            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                            GenJnlLine."Shortcut Dimension 2 Code" := ImprestLine."Global Dimension 2 Code";
                            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                            GenJnlLine.ValidateShortcutDimCode(3, ImprestLine."Shortcut Dimension 3 Code");
                            GenJnlLine.ValidateShortcutDimCode(4, ImprestLine."Shortcut Dimension 4 Code");
                            GenJnlLine.ValidateShortcutDimCode(5, ImprestLine."Shortcut Dimension 5 Code");
                            GenJnlLine.ValidateShortcutDimCode(6, ImprestLine."Shortcut Dimension 6 Code");
                            //GenJnlLine.ValidateShortcutDimCode(7,ImprestLine."Shortcut Dimension 7 Code");
                            // GenJnlLine.ValidateShortcutDimCode(8,ImprestLine."Shortcut Dimension 8 Code");
                            GenJnlLine.Description := COPYSTR('Imprest Tax-' + ImprestLine.Description, 1, 100);
                            GenJnlLine.Description2 := COPYSTR('Imprest Tax-' + PaymentLine."Account Name", 1, 100);
                            GenJnlLine.VALIDATE(GenJnlLine.Description);

                            GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
                            IF GenJnlLine.Amount <> 0 THEN
                                GenJnlLine.INSERT;

                        UNTIL ImprestLine.NEXT = 0;
                END;
            //********Surrender Board End****************



            UNTIL PaymentLine.NEXT = 0;
        END;
        //*******************************************
        //*********************************************End Add Payment Lines************************************************************//
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            BankLedgerEntries.RESET;
            BankLedgerEntries.SETRANGE("Document No.", PaymentHeader."No.");
            IF BankLedgerEntries.FINDFIRST THEN BEGIN
                PaymentHeader2.RESET;
                PaymentHeader2.SETRANGE("No.", PaymentHeader."No.");
                IF PaymentHeader2.FINDFIRST THEN BEGIN
                    PaymentHeader2.Status := PaymentHeader2.Status::Posted;
                    PaymentHeader2.VALIDATE(PaymentHeader2.Status);
                    PaymentHeader2.Posted := TRUE;
                    PaymentHeader2."Posted By" := USERID;
                    PaymentHeader2."Date Posted" := TODAY;
                    PaymentHeader2."Time Posted" := TIME;
                    IF PaymentHeader2.MODIFY THEN
                        MarkImprestAsPosted(PaymentHeader."No.", PaymentHeader."Posting Date");
                END;
            END;
            COMMIT;
            //***********************************************End Update Document************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;

        BankLedgerEntries.RESET;
        BankLedgerEntries.SETRANGE("Document No.", PaymentHeader."No.");
        IF BankLedgerEntries.FINDFIRST THEN BEGIN
            ChequeRegisterLines.RESET;
            ChequeRegisterLines.SETRANGE(ChequeRegisterLines."Cheque No.", PaymentHeader."Cheque No.");
            IF ChequeRegisterLines.FINDFIRST THEN BEGIN
                ChequeRegisterLines."Assigned to PV" := TRUE;
                ChequeRegisterLines."PV Posted with Cheque" := TRUE;
                ChequeRegisterLines."Payee No" := PaymentHeader."Payee No.";
                ChequeRegisterLines.Payee := PaymentHeader."Payee Name";
                ChequeRegisterLines."PV No" := PaymentHeader."No.";
                ChequeRegisterLines."PV Description" := PaymentHeader.Description;
                ChequeRegisterLines."PV Prepared By" := PaymentHeader."User ID";
                ChequeRegisterLines.MODIFY;
            END;
        END;//SASA

    end;

    procedure PostHRLoanPayment("Payment Header": Record 50002; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        PaymentLine: Record 50003;
        PaymentHeader: Record 50002;
        SourceCode: Code[20];
        BankLedgerEntries: Record 271;
        PaymentLine2: Record 50003;
        PaymentHeader2: Record 50002;
        DocumentExist: Label 'Payment Document is already posted, "Document No.":%1 already exists in Bank No:%2';
        /*  EmployeeLoanAccounts: Record 50075;
         LoanRepayment: Record 50077; */
        PaymentCodes: Record 50027;
    //EmployeeLoanProducts: Record 50082;
    begin
        PaymentHeader.TRANSFERFIELDS("Payment Header", TRUE);
        SourceCode := PAYMENTJNL;

        /*   EmployeeLoanAccounts.GET(PaymentHeader."Loan No.");

          EmployeeLoanProducts.GET(EmployeeLoanAccounts."Loan Product Code");
   */
        BankLedgerEntries.RESET;
        BankLedgerEntries.SETRANGE(BankLedgerEntries."Document No.", PaymentHeader."No.");
        BankLedgerEntries.SETRANGE(BankLedgerEntries.Reversed, FALSE);
        IF BankLedgerEntries.FINDFIRST THEN BEGIN
            ERROR(DocumentExist, PaymentHeader."No.", PaymentHeader."Bank Account No.");
        END;

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;
        //*********************************************Add Payment Header***************************************************************//
        PaymentHeader.CALCFIELDS("Net Amount");
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE("Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE("Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := PaymentHeader."No.";
        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
        GenJnlLine."Cheque No." := PaymentHeader."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := PaymentHeader."Bank Account No.";
        GenJnlLine.VALIDATE("Account No.");
        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
        GenJnlLine.VALIDATE("Currency Code");
        GenJnlLine.Amount := -(PaymentHeader."Net Amount");  //Credit Amount
        GenJnlLine.VALIDATE(Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE("Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := UPPERCASE(COPYSTR(PaymentHeader.Description, 1, 100));
        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
        GenJnlLine.VALIDATE(Description);
        IF PaymentHeader."Loan No." <> '' THEN BEGIN
            GenJnlLine."Investment Account No." := PaymentHeader."Loan No.";
            GenJnlLine."Investment Transaction Type" := GenJnlLine."Investment Transaction Type"::"Loan Disbursement";
        END;
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;
        //************************************************End Add to Bank***************************************************************//

        //***********************************************Add Payment Lines**************************************************************//
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", PaymentHeader."No.");
        PaymentLine.SETFILTER("Total Amount", '<>%1', 0);
        IF PaymentLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line Amounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE("Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE("Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                GenJnlLine."Document No." := PaymentLine."Document No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                //    GenJnlLine."Account No." := EmployeeLoanAccounts."Employee No.";
                GenJnlLine."Investment Account No." := PaymentHeader."Loan No.";
                GenJnlLine."Investment Transaction Type" := GenJnlLine."Investment Transaction Type"::"Loan Disbursement";
                GenJnlLine.VALIDATE("Account No.");
                GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := PaymentLine."Total Amount";  //Debit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                // GenJnlLine."Posting Group" := EmployeeLoanProducts."Disbursement Payment Code";
                GenJnlLine.VALIDATE(GenJnlLine."Posting Group");
                GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PaymentLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PaymentLine."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, PaymentLine."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, PaymentLine."Shortcut Dimension 6 Code");
                GenJnlLine.ValidateShortcutDimCode(7, PaymentLine."Shortcut Dimension 7 Code");
                GenJnlLine.ValidateShortcutDimCode(8, PaymentLine."Shortcut Dimension 8 Code");
                GenJnlLine.Description := UPPERCASE(COPYSTR(PaymentHeader.Description, 1, 100));
                GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                GenJnlLine.VALIDATE(Description);
                GenJnlLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                GenJnlLine.VALIDATE("Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                GenJnlLine."Employee Transaction Type" := PaymentLine."Employee Transaction Type";
                GenJnlLine."Investment Account No." := PaymentHeader."Loan No.";
                GenJnlLine."Investment Transaction Type" := GenJnlLine."Investment Transaction Type"::"Loan Disbursement";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            //*************************************End Add Line Amounts**********************************************************//
            UNTIL PaymentLine.NEXT = 0;
        END;
        //*********************************************End Add Payment Lines************************************************************//
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            BankLedgerEntries.RESET;
            BankLedgerEntries.SETRANGE("Document No.", PaymentHeader."No.");
            IF BankLedgerEntries.FINDFIRST THEN BEGIN
                PaymentHeader2.RESET;
                PaymentHeader2.SETRANGE("No.", PaymentHeader."No.");
                IF PaymentHeader2.FINDFIRST THEN BEGIN
                    PaymentHeader2.Status := PaymentHeader2.Status::Posted;
                    PaymentHeader2.VALIDATE(PaymentHeader2.Status);
                    PaymentHeader2.Posted := TRUE;
                    PaymentHeader2."Posted By" := USERID;
                    PaymentHeader2."Date Posted" := TODAY;
                    PaymentHeader2."Time Posted" := TIME;
                    PaymentHeader2.MODIFY;

                    //create payroll deduction
                    /*                     "HRLoanMgt.".CreateLoanPayrollDeduction(PaymentHeader2."No.", PaymentHeader."Loan No.", TotalDisbursedAmount);
                                        //update disbursement voucher
                                        "HRLoanMgt.".UpdateDisbursementVoucher(PaymentHeader2."No.");

                                        PaymentHeader2.CALCFIELDS("Net Amount");
                                        EmployeeLoanAccounts.RESET;
                                        EmployeeLoanAccounts.GET(PaymentHeader2."Loan No.");

                                        IF EmployeeLoanAccounts."Repayment Start Date" = 0D THEN
                                            EmployeeLoanAccounts."Repayment Start Date" := PaymentHeader2."Posting Date";
                                        EmployeeLoanAccounts.MODIFY; */
                END;
            END;
            COMMIT;
            //***********************************************End Update Document************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;

        BankLedgerEntries.RESET;
        BankLedgerEntries.SETRANGE("Document No.", PaymentHeader."No.");
        IF BankLedgerEntries.FINDFIRST THEN BEGIN
            ChequeRegisterLines.RESET;
            ChequeRegisterLines.SETRANGE(ChequeRegisterLines."Cheque No.", PaymentHeader."Cheque No.");
            IF ChequeRegisterLines.FINDFIRST THEN BEGIN
                ChequeRegisterLines."Assigned to PV" := TRUE;
                ChequeRegisterLines."PV Posted with Cheque" := TRUE;
                ChequeRegisterLines."Payee No" := PaymentHeader."Payee No.";
                ChequeRegisterLines.Payee := PaymentHeader."Payee Name";
                ChequeRegisterLines."PV No" := PaymentHeader."No.";
                ChequeRegisterLines."PV Description" := PaymentHeader.Description;
                ChequeRegisterLines."PV Prepared By" := PaymentHeader."User ID";
                ChequeRegisterLines.MODIFY;
            END;
        END;



        /*//Send email to supplier
        PaymentLine2.RESET;
        PaymentLine2.SETRANGE(PaymentLine2."Document No.",PaymentHeader."No.");
        PaymentLine2.SETRANGE(PaymentLine2."Account Type",PaymentLine2."Account Type"::Vendor);
        IF PaymentLine2.FINDFIRST THEN BEGIN
         //IF CONFIRM(Txt070)=FALSE THEN EXIT
         SendVendorEmail(PaymentLine2."Document No.",PaymentLine2."Account No.",PaymentLine2."Net Amount");
        END;
        */

    end;

    procedure PostPaymentLineByLine("Payment Header": Record 50002; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        PaymentLine: Record 50003;
        PaymentHeader: Record 50002;
        SourceCode: Code[20];
        BankLedgerEntries: Record 271;
        PaymentLine2: Record 50003;
        PaymentHeader2: Record 50002;
        DocumentExist: Label 'Payment Document is already posted, "Document No.":%1 already exists in Bank No:%2';
    begin
        PaymentHeader.TRANSFERFIELDS("Payment Header", TRUE);
        SourceCode := PAYMENTJNL;

        BankLedgerEntries.RESET;
        BankLedgerEntries.SETRANGE(BankLedgerEntries."Document Type", BankLedgerEntries."Document Type"::Payment);
        BankLedgerEntries.SETRANGE(BankLedgerEntries."Document No.", PaymentHeader."No.");
        IF BankLedgerEntries.FINDFIRST THEN BEGIN
            ERROR(DocumentExist, PaymentHeader."No.", PaymentHeader."Bank Account No.");
        END;

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;

        //***********************************************Add Payment Lines**************************************************************//
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", PaymentHeader."No.");
        PaymentLine.SETFILTER("Total Amount", '<>%1', 0);
        IF PaymentLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line Amounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE("Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE("Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                GenJnlLine."Document No." := PaymentLine."Document No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Account Type" := PaymentLine."Account Type";
                GenJnlLine."Account No." := PaymentLine."Account No.";
                GenJnlLine.VALIDATE("Account No.");
                GenJnlLine."Posting Group" := PaymentLine."Posting Group";
                GenJnlLine."External Document No." := PaymentLine."Reference No.";
                GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := PaymentLine."Total Amount";  //Debit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                GenJnlLine."Bal. Account No." := PaymentHeader."Bank Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PaymentLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PaymentLine."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, PaymentLine."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, PaymentLine."Shortcut Dimension 6 Code");
                //GenJnlLine.ValidateShortcutDimCode(7,PaymentLine."Shortcut Dimension 7 Code");
                // GenJnlLine.ValidateShortcutDimCode(8,PaymentLine."Shortcut Dimension 8 Code");
                GenJnlLine.Description := UPPERCASE(COPYSTR(PaymentHeader.Description, 1, 100));
                GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                GenJnlLine.VALIDATE(Description);
                GenJnlLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                GenJnlLine.VALIDATE("Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                GenJnlLine."Employee Transaction Type" := PaymentLine."Employee Transaction Type";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
                //*************************************End Add Line Amounts**********************************************************//

                //**************************************Add W/TAX Amounts************************************************************//
                IF PaymentLine."Withholding Tax Code" <> '' THEN BEGIN
                    TaxCodes.RESET;
                    TaxCodes.SETRANGE("Tax Code", PaymentLine."Withholding Tax Code");
                    IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD("Account No.");
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE("Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE("Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PaymentLine."Document No.";
                        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No.";
                        GenJnlLine.VALIDATE("Account No.");
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE("Currency Code");
                        GenJnlLine.Amount := -(PaymentLine."Withholding Tax Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        // GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        // GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := UPPERCASE(COPYSTR('W/TAX:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name"), 1, 100));
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        //W/TAX Balancing
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE("Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE("Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PaymentLine."Document No.";
                        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                        GenJnlLine."Account Type" := PaymentLine."Account Type";
                        GenJnlLine."Account No." := PaymentLine."Account No.";
                        GenJnlLine.VALIDATE("Account No.");
                        GenJnlLine."Posting Group" := PaymentLine."Posting Group";
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE("Currency Code");
                        GenJnlLine.Amount := PaymentLine."Withholding Tax Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        // GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        // GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := UPPERCASE(COPYSTR('W/TAX:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name"), 1, 100));
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                        GenJnlLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                        GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE("Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                        GenJnlLine."Employee Transaction Type" := PaymentLine."Employee Transaction Type";
                        /*IF GenJnlLine.Amount<>0 THEN
                            GenJnlLine.INSERT;*/
                    END;
                END;
                //****************************************End Add W/TAX Amounts************************************************************//

                //****************************************Add W/VAT Amounts***************************************************************//
                IF PaymentLine."Withholding VAT Code" <> '' THEN BEGIN
                    TaxCodes.RESET;
                    TaxCodes.SETRANGE("Tax Code", PaymentLine."Withholding VAT Code");
                    IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD("Account No.");
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE("Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE("Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PaymentLine."Document No.";
                        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No.";
                        GenJnlLine.VALIDATE("Account No.");
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE("Currency Code");
                        GenJnlLine.Amount := -(PaymentLine."Withholding VAT Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        // GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        // GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := UPPERCASE(COPYSTR('W/VAT:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name"), 1, 100));
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        //W/VAT Balancing
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE("Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE("Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                        GenJnlLine."Document No." := PaymentLine."Document No.";
                        GenJnlLine."External Document No." := PaymentHeader."Reference No.";
                        GenJnlLine."Account Type" := PaymentLine."Account Type";
                        GenJnlLine."Account No." := PaymentLine."Account No.";
                        GenJnlLine.VALIDATE("Account No.");
                        GenJnlLine."Posting Group" := PaymentLine."Posting Group";
                        GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                        GenJnlLine.VALIDATE("Currency Code");
                        GenJnlLine.Amount := PaymentLine."Withholding VAT Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, PaymentHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, PaymentHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, PaymentHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, PaymentHeader."Shortcut Dimension 6 Code");
                        //  GenJnlLine.ValidateShortcutDimCode(7,PaymentHeader."Shortcut Dimension 7 Code");
                        //  GenJnlLine.ValidateShortcutDimCode(8,PaymentHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := UPPERCASE(COPYSTR('W/VAT:' + FORMAT(PaymentLine."Document No.") + '::' + FORMAT(PaymentLine."Account Name"), 1, 100));
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR(PaymentHeader."Payee Name", 1, 100));
                        GenJnlLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                        GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                        GenJnlLine.VALIDATE("Applies-to Doc. No.");
                        GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                        GenJnlLine."Employee Transaction Type" := PaymentLine."Employee Transaction Type";
                        /*IF GenJnlLine.Amount<>0 THEN
                            GenJnlLine.INSERT;*/
                    END;
                END;
            //***********************************End Add W/VAT Amounts*************************************************************//
            UNTIL PaymentLine.NEXT = 0;
        END;
        //*********************************************End Add Payment Lines************************************************************//
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            BankLedgerEntries.RESET;
            BankLedgerEntries.SETRANGE("Document No.", PaymentHeader."No.");
            IF BankLedgerEntries.FINDFIRST THEN BEGIN
                PaymentHeader2.RESET;
                PaymentHeader2.SETRANGE("No.", PaymentHeader."No.");
                IF PaymentHeader2.FINDFIRST THEN BEGIN
                    PaymentHeader2.Status := PaymentHeader2.Status::Posted;
                    PaymentHeader2.VALIDATE(PaymentHeader2.Status);
                    PaymentHeader2.Posted := TRUE;
                    PaymentHeader2."Posted By" := USERID;
                    PaymentHeader2."Date Posted" := TODAY;
                    PaymentHeader2."Time Posted" := TIME;
                    PaymentHeader2.MODIFY;
                END;
            END;
            COMMIT;
            //***********************************************End Update Document************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;

    end;

    procedure CheckPaymentMandatoryFields("Payment Header": Record 50002; Posting: Boolean)
    var
        PaymentHeader: Record 50002;
        PaymentLine: Record 50003;
        EmptyPaymentLine: Label 'You cannot Post Payment with empty Line';
        "G/LAccount": Record 15;
    begin
        PaymentHeader.TRANSFERFIELDS("Payment Header", TRUE);
        PaymentHeader.TESTFIELD("Posting Date");
        //PaymentHeader.TESTFIELD("Reference No.");
        IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::"Cash Payment" THEN BEGIN
            PaymentHeader.CALCFIELDS("Net Amount", "Bank Account Balance");
            /*IF (PaymentHeader."Bank Account Balance"-PaymentHeader."Net Amount")<0  THEN
              ERROR('You cannot withdraw Below Zero')*///Commented By Shem

        END;
        IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::"Cheque Payment" THEN BEGIN
            IF PaymentHeader."Payment Mode" = "Payment Header"."Payment Mode"::EFT THEN BEGIN
                //PaymentHeader.TESTFIELD("Reference No.");
            END;
            //PaymentHeader.TESTFIELD("Cheque No.");
            PaymentHeader.TESTFIELD("Payee Name");
        END;
        PaymentHeader.TESTFIELD("Bank Account No.");
        PaymentHeader.TESTFIELD(Description);
        PaymentHeader.TESTFIELD("Global Dimension 1 Code");
        IF Posting THEN BEGIN
            PaymentHeader.TESTFIELD(Status, PaymentHeader.Status::Approved);//mesh
            PaymentHeader.TESTFIELD("Reference No.");
        END;

        //Check Payment Lines
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", PaymentHeader."No.");
        IF PaymentLine.FINDSET THEN BEGIN
            REPEAT
                PaymentLine.TESTFIELD("Account No.");
                PaymentLine.TESTFIELD("Total Amount");
                PaymentLine.TESTFIELD(Description);
                IF PaymentLine."Account Type" = PaymentLine."Account Type"::"G/L Account" THEN BEGIN
                    "G/LAccount".RESET;
                    "G/LAccount".GET(PaymentLine."Account No.");
                    IF "G/LAccount"."Income/Balance" = "G/LAccount"."Income/Balance"::"Income Statement" THEN BEGIN
                        //PaymentLine.TESTFIELD("Global Dimension 2 Code");
                        /* PaymentLine.TESTFIELD("Shortcut Dimension 3 Code");
                         PaymentLine.TESTFIELD("Shortcut Dimension 4 Code");
                         PaymentLine.TESTFIELD("Shortcut Dimension 5 Code");
                         PaymentLine.TESTFIELD("Shortcut Dimension 6 Code");*/
                    END;
                END;
            UNTIL PaymentLine.NEXT = 0;
        END ELSE BEGIN
            ERROR(EmptyPaymentLine);
        END;

    end;

    procedure PostReceipt("Receipt Header": Record 50004; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        ReceiptLine: Record 50005;
        ReceiptHeader: Record 50004;
        SourceCode: Code[20];
        BankLedgers: Record 271;
        ReceiptLine2: Record 50005;
        ReceiptHeader2: Record 50004;
        DocumentExist: Label 'Receipt is already posted, "Document No.":%1 already exists in Bank No:%2';
        GLEntry: Record 17;
    begin
        ReceiptHeader.TRANSFERFIELDS("Receipt Header", TRUE);
        SourceCode := RECEIPTJNL;
        /*
        BankLedgers.RESET;
        BankLedgers.SETRANGE(BankLedgers."Document No.",ReceiptHeader."No.");
        IF BankLedgers.FINDFIRST THEN BEGIN
          ERROR(DocumentExist,ReceiptHeader."No.",ReceiptHeader."Account No.");
        END;*/

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        //***************************************************Add to Bank***************************************************************//
        ReceiptHeader.CALCFIELDS("Line Amount", "Line Amount(LCY)");
        LineNo := 1000;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
        GenJnlLine."Document No." := ReceiptHeader."No.";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
        IF ReceiptHeader."Receipt Types" = ReceiptHeader."Receipt Types"::Bank THEN BEGIN
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
            GenJnlLine."Account No." := ReceiptHeader."Account No.";
        END ELSE BEGIN
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            IF FundsTransactionCode.GET(ReceiptHeader."Account No.") THEN
                GenJnlLine."Account No." := FundsTransactionCode."Account No.";
        END;
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        GenJnlLine.Amount := ReceiptHeader."Line Amount";  //Debit Amount
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := COPYSTR(ReceiptHeader.Description, 1, 100);
        GenJnlLine.Description2 := UPPERCASE(COPYSTR("Receipt Header"."Received From", 1, 100));
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;
        //************************************************End Add to Bank***************************************************************//
        //***********************************************Add Receipt Lines**************************************************************//
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE(ReceiptLine."Document No.", ReceiptHeader."No.");
        ReceiptLine.SETFILTER(ReceiptLine.Amount, '<>%1', 0);
        IF ReceiptLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line NetAmounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                GenJnlLine."Document No." := ReceiptLine."Document No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Account Type" := ReceiptLine."Account Type";
                GenJnlLine."Account No." := ReceiptLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Posting Group" := ReceiptLine."Posting Group";
                GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
                GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := -(ReceiptLine.Amount);  //Credit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                // IF ReceiptLine."Posting Group" <> '' THEN BEGIN
                GenJnlLine."Investment Transaction Type" := ReceiptLine."Loan Transaction Type";
                GenJnlLine."Investment Account No." := ReceiptLine."Loan Account No.";
                GenJnlLine."Customer No." := ReceiptLine."Account No.";
                //  END;
                GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                GenJnlLine.Description := COPYSTR(ReceiptHeader.Description, 1, 100);
                GenJnlLine.Description2 := UPPERCASE(COPYSTR("Receipt Header"."Received From", 1, 100));
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                IF ReceiptLine."Loan Account No." <> '' THEN BEGIN
                    GenJnlLine."Applies-to ID" := '';
                    GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                END ELSE BEGIN
                    GenJnlLine."Applies-to ID" := ReceiptLine."Applies-to ID";
                    GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                END;
                GenJnlLine."Employee Transaction Type" := ReceiptLine."Employee Transaction Type";
                GenJnlLine."Investment Application No." := ReceiptLine."Investment Application No.";
                // GenJnlLine."Loan Account No.":=ReceiptLine."Investment Account No.";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
                //*************************************End add Line NetAmounts**********************************************************//
                //****************************************Add VAT Amounts***************************************************************//
                IF ReceiptLine."VAT Code" <> '' THEN BEGIN
                    TaxCodes.RESET;
                    TaxCodes.SETRANGE(TaxCodes."Tax Code", ReceiptLine."VAT Code");
                    IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD(TaxCodes."Account No.");
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        GenJnlLine."Document No." := ReceiptLine."Document No.";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                        GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group" := '';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group" := '';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount := -(ReceiptLine."VAT Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        //  GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        //  GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := COPYSTR('VAT:' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"), 1, 100);
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR("Receipt Header"."Received From", 1, 50));
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        //VAT Balancing goes to Vendor
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        GenJnlLine."Document No." := ReceiptLine."Document No.";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                        GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
                        GenJnlLine."Account Type" := ReceiptLine."Account Type";
                        GenJnlLine."Account No." := ReceiptLine."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine.Amount := ReceiptLine."VAT Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        //GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        // GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := COPYSTR('VAT:' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"), 1, 100);
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR("Receipt Header"."Received From", 1, 50));
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                    END;
                END;
            //*************************************End Add VAT Amounts**************************************************************//
            UNTIL ReceiptLine.NEXT = 0;
        END;
        //*********************************************End Add Payment Lines************************************************************//
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", ReceiptHeader."No.");
            IF GLEntry.FINDFIRST THEN BEGIN
                ReceiptHeader2.RESET;
                ReceiptHeader2.SETRANGE(ReceiptHeader2."No.", ReceiptHeader."No.");
                IF ReceiptHeader2.FINDFIRST THEN BEGIN

                    //Apply loan
                    /*      IF ReceiptHeader2."Receipt Type" = ReceiptHeader2."Receipt Type"::"Investment Loan" THEN BEGIN
                             IF ReceiptHeader2."Investment Account No." <> '' THEN BEGIN
                                 InvstReceiptApplication.SuggestInvestmentLoanRepaymentsDefined(ReceiptHeader2."No.", ReceiptHeader2."Amount Received", ReceiptHeader2."Investment Account No.");
                             END ELSE BEGIN
                                 InvstReceiptApplication.SuggestInvestmentLoanRepaymentsUnDefined(ReceiptHeader2."No.", ReceiptHeader2."Amount Received");
                             END;
                         END; */
                    //End Loan Application;
                    //Apply equity
                    /*    IF ReceiptHeader2."Receipt Type" = ReceiptHeader2."Receipt Type"::Equity THEN BEGIN
                           IF ReceiptHeader2."Investment Account No." <> '' THEN BEGIN
                               InvstReceiptApplication.SuggestInvestmentEquityRepaymentsDefined(ReceiptHeader2."No.", ReceiptHeader2."Amount Received", ReceiptHeader2."Investment Account No.");
                           END ELSE BEGIN
                               InvstReceiptApplication.SuggestInvestmentEquityRepaymentsUnDefined(ReceiptHeader2."No.", ReceiptHeader2."Amount Received");
                           END;
                       END; */
                    //End Equity Application;

                    ReceiptHeader2.Status := ReceiptHeader2.Status::Posted;
                    ReceiptHeader2.Posted := TRUE;
                    ReceiptHeader2."Posted By" := USERID;
                    ReceiptHeader2."Date Posted" := TODAY;
                    ReceiptHeader2."Time Posted" := TIME;
                    ReceiptHeader2.MODIFY;
                    ReceiptLine2.RESET;
                    ReceiptLine2.SETRANGE(ReceiptLine2."Document No.", ReceiptHeader2."No.");
                    IF ReceiptLine2.FINDSET THEN BEGIN
                        REPEAT
                            ReceiptLine2.Status := ReceiptLine2.Status::Posted;
                            ReceiptLine2.Posted := TRUE;
                            ReceiptLine2."Posted By" := USERID;
                            ReceiptLine2."Date Posted" := TODAY;
                            ReceiptLine2."Time Posted" := TIME;
                            ReceiptLine2.MODIFY;

                        /*TenantApplication.RESET;
                        TenantApplication.SETRANGE(TenantApplication."Tenant Account No.",ReceiptLine2."Account No.");
                        TenantApplication.SETRANGE(TenantApplication.Receipted,FALSE);
                        IF TenantApplication.FINDFIRST THEN BEGIN
                          TenantApplication.Receipted:=TRUE;
                          TenantApplication."Receipt Date":=TODAY;
                          TenantApplication."Receipt No.":=ReceiptLine2."Document No.";
                        END;*/
                        UNTIL ReceiptLine2.NEXT = 0;
                    END;
                END;
            END;
            COMMIT;
            //***********************************************End Update Document************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;

    end;

    procedure PostChequeReceipt("ReceiptNo.": Code[20]; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        ReceiptLine: Record 50005;
        ReceiptHeader: Record 50004;
        SourceCode: Code[20];
        BankLedgers: Record 271;
        ReceiptLine2: Record 50005;
        ReceiptHeader2: Record 50004;
        DocumentExist: Label 'Receipt is already posted, "Document No.":%1 already exists in Bank No:%2';
        GLEntry: Record 17;
    begin
        ReceiptHeader.GET("ReceiptNo.");
        SourceCode := RECEIPTJNL;

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        //***************************************************Add to Bank***************************************************************//
        ReceiptHeader.CALCFIELDS("Line Amount", "Line Amount(LCY)");
        LineNo := 1000;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
        GenJnlLine."Document No." := ReceiptHeader."No.";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
        IF ReceiptHeader."Receipt Types" = ReceiptHeader."Receipt Types"::Bank THEN BEGIN
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
            GenJnlLine."Account No." := ReceiptHeader."Account No.";
        END ELSE BEGIN
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            IF FundsTransactionCode.GET(ReceiptHeader."Account No.") THEN
                GenJnlLine."Account No." := FundsTransactionCode."Account No.";
        END;
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        GenJnlLine.Amount := ReceiptHeader."Line Amount";  //Debit Amount
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := COPYSTR(ReceiptHeader.Description, 1, 100);
        GenJnlLine.Description2 := UPPERCASE(COPYSTR(ReceiptHeader."Received From", 1, 100));
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;
        //************************************************End Add to Bank***************************************************************//
        //***********************************************Add Receipt Lines**************************************************************//
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE(ReceiptLine."Document No.", ReceiptHeader."No.");
        ReceiptLine.SETFILTER(ReceiptLine.Amount, '<>%1', 0);
        IF ReceiptLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line NetAmounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                GenJnlLine."Document No." := ReceiptLine."Document No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Account Type" := ReceiptLine."Account Type";
                GenJnlLine."Account No." := ReceiptLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Posting Group" := ReceiptLine."Posting Group";
                GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
                GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := -(ReceiptLine.Amount);  //Credit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Investment Transaction Type" := ReceiptLine."Loan Transaction Type";
                GenJnlLine."Investment Account No." := ReceiptLine."Loan Account No.";
                GenJnlLine."Customer No." := ReceiptLine."Account No.";
                GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                GenJnlLine.Description := COPYSTR(ReceiptHeader.Description, 1, 100);
                GenJnlLine.Description2 := UPPERCASE(COPYSTR(ReceiptHeader."Received From", 1, 100));
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                IF ReceiptLine."Loan Account No." <> '' THEN BEGIN
                    GenJnlLine."Applies-to ID" := '';
                    GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                END ELSE BEGIN
                    GenJnlLine."Applies-to ID" := ReceiptLine."Applies-to ID";
                    GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                END;
                GenJnlLine."Employee Transaction Type" := ReceiptLine."Employee Transaction Type";
                GenJnlLine."Investment Application No." := ReceiptLine."Investment Application No.";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            //*************************************End add Line NetAmounts**********************************************************//

            UNTIL ReceiptLine.NEXT = 0;
        END;
        //*********************************************End Add Payment Lines************************************************************//
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", ReceiptHeader."No.");
            IF GLEntry.FINDFIRST THEN BEGIN
                ReceiptHeader2.RESET;
                ReceiptHeader2.SETRANGE(ReceiptHeader2."No.", ReceiptHeader."No.");
                IF ReceiptHeader2.FINDFIRST THEN BEGIN
                    //Apply loan
                    /*  IF ReceiptHeader2."Receipt Type" = ReceiptHeader2."Receipt Type"::"Investment Loan" THEN BEGIN
                         IF ReceiptHeader2."Investment Account No." <> '' THEN BEGIN
                             InvstReceiptApplication.SuggestInvestmentLoanRepaymentsDefined(ReceiptHeader2."No.", ReceiptHeader2."Amount Received", ReceiptHeader2."Investment Account No.");
                         END ELSE BEGIN
                             InvstReceiptApplication.SuggestInvestmentLoanRepaymentsUnDefined(ReceiptHeader2."No.", ReceiptHeader2."Amount Received");
                         END;
                     END; */
                    //End Loan Application;

                    ReceiptHeader2.Status := ReceiptHeader2.Status::Posted;
                    ReceiptHeader2.Posted := TRUE;
                    ReceiptHeader2."Posted By" := USERID;
                    ReceiptHeader2."Date Posted" := TODAY;
                    ReceiptHeader2."Time Posted" := TIME;
                    ReceiptHeader2.MODIFY;
                    ReceiptLine2.RESET;
                    ReceiptLine2.SETRANGE(ReceiptLine2."Document No.", ReceiptHeader2."No.");
                    IF ReceiptLine2.FINDSET THEN BEGIN
                        REPEAT
                            ReceiptLine2.Status := ReceiptLine2.Status::Posted;
                            ReceiptLine2.Posted := TRUE;
                            ReceiptLine2."Posted By" := USERID;
                            ReceiptLine2."Date Posted" := TODAY;
                            ReceiptLine2."Time Posted" := TIME;
                            ReceiptLine2.MODIFY;

                        /*TenantApplication.RESET;
                        TenantApplication.SETRANGE(TenantApplication."Tenant Account No.",ReceiptLine2."Account No.");
                        TenantApplication.SETRANGE(TenantApplication.Receipted,FALSE);
                        IF TenantApplication.FINDFIRST THEN BEGIN
                          TenantApplication.Receipted:=TRUE;
                          TenantApplication."Receipt Date":=TODAY;
                          TenantApplication."Receipt No.":=ReceiptLine2."Document No.";
                        END;*/
                        UNTIL ReceiptLine2.NEXT = 0;
                    END;
                END;
            END;
            COMMIT;
            //***********************************************End Update Document************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;

    end;

    procedure CheckReceiptMandatoryFields("Receipt Header": Record 50004; Posting: Boolean)
    var
        EmptyReceiptLine: Label 'You cannot Post Receipt with empty Line';
        ReceiptHeader: Record 50004;
        ReceiptLine: Record 50005;
        AmountsNotEqual: Label 'The Amount Received:%1 is not equal to the Total Line Amount:%2';
        ReceiptLine2: Record 50005;
    begin
        ReceiptHeader.TRANSFERFIELDS("Receipt Header", TRUE);
        ReceiptHeader.TESTFIELD("Posting Date");
        ReceiptHeader.TESTFIELD("Account No.");
        ReceiptHeader.TESTFIELD("Received From");
        ReceiptHeader.TESTFIELD(Description);
        ReceiptHeader.TESTFIELD("Receipt Type");

        //ReceiptHeader.TESTFIELD("Global Dimension 1 Code");
        //Check Receipt Lines
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE("Document No.", ReceiptHeader."No.");
        IF ReceiptLine.FINDSET THEN BEGIN
            REPEAT
                ReceiptLine.TESTFIELD("Account No.");
                ReceiptLine.TESTFIELD(Amount);
                ReceiptLine.TESTFIELD(Description);
            UNTIL ReceiptLine.NEXT = 0;
        END ELSE BEGIN
            ERROR(EmptyReceiptLine);
        END;

        //Check Investment Mandatory fields
        CheckInvestmentReceiptCode(ReceiptHeader."No.");

        ReceiptHeader.CALCFIELDS("Line Amount", "Line Amount(LCY)");
        IF ReceiptHeader."Amount Received" <> ReceiptHeader."Line Amount" THEN
            ERROR(AmountsNotEqual, ReceiptHeader."Amount Received", ReceiptHeader."Line Amount");


        IF ReceiptHeader."Receipt Type" = ReceiptHeader."Receipt Type"::"Investment Loan" THEN BEGIN
            ReceiptHeader.TESTFIELD("Client No.");
        END;
    end;

    procedure PostFundsTransfer("Funds Transfer Header": Record 50006; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        FundsTransferLine: Record 50007;
        FundsTransferHeader: Record 50006;
        SourceCode: Code[20];
        BankLedgers: Record 271;
        FundsTransferLine2: Record 50007;
        FundsTransferHeader2: Record 50006;
        DocumentExist: Label 'Funds Transfer document is already posted, "Document No.":%1 already exists in Bank No.:%2';
    begin
        FundsTransferHeader.TRANSFERFIELDS("Funds Transfer Header", TRUE);
        SourceCode := TRANJNL;
        BankLedgers.RESET;
        //BankLedgers.SETRANGE("Document Type",BankLedgers."Document Type"::);
        BankLedgers.SETRANGE("Document No.", FundsTransferHeader."No.");
        IF BankLedgers.FINDFIRST THEN BEGIN
            ERROR(DocumentExist, FundsTransferHeader."No.", FundsTransferHeader."Bank Account No.");
        END;

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;
        //********************************************Add to Paying Bank***************************************************************//
        FundsTransferHeader.CALCFIELDS("Line Amount");
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE("Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE("Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := FundsTransferHeader."Posting Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := FundsTransferHeader."No.";
        GenJnlLine."External Document No." := FundsTransferHeader."Reference No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := FundsTransferHeader."Bank Account No.";
        GenJnlLine.VALIDATE("Account No.");
        GenJnlLine."Currency Code" := FundsTransferHeader."Currency Code";
        GenJnlLine.VALIDATE("Currency Code");
        GenJnlLine.Amount := -(FundsTransferHeader."Amount To Transfer");  //Credit Amount
        GenJnlLine.VALIDATE(Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE("Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := FundsTransferHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := FundsTransferHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, FundsTransferHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, FundsTransferHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, FundsTransferHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, FundsTransferHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,FundsTransferHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,FundsTransferHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := UPPERCASE(COPYSTR(FundsTransferHeader.Description, 1, 100));
        GenJnlLine.Description2 := UPPERCASE(COPYSTR(FundsTransferHeader."Transfer To", 1, 100));
        GenJnlLine.VALIDATE(Description);
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;
        //************************************************End Add to Paying Bank***********************************************************//

        //***********************************************Add Receiving Bank Lines**********************************************************//
        FundsTransferLine.RESET;
        FundsTransferLine.SETRANGE("Document No.", FundsTransferHeader."No.");
        FundsTransferLine.SETFILTER(Amount, '<>%1', 0);
        IF FundsTransferLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line NetAmounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE("Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE("Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := FundsTransferHeader."Posting Date";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Other Payment";
                GenJnlLine."Document No." := FundsTransferLine."Document No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                GenJnlLine."Account No." := FundsTransferLine."Account No.";
                GenJnlLine.VALIDATE("Account No.");
                GenJnlLine."External Document No." := FundsTransferHeader."Reference No.";
                GenJnlLine."Currency Code" := FundsTransferHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := FundsTransferLine.Amount;
                GenJnlLine.VALIDATE(Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE("Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := FundsTransferHeader."Global Dimension 1 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := FundsTransferHeader."Global Dimension 2 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, FundsTransferHeader."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, FundsTransferHeader."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, FundsTransferHeader."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, FundsTransferHeader."Shortcut Dimension 6 Code");
                // GenJnlLine.ValidateShortcutDimCode(7,FundsTransferHeader."Shortcut Dimension 7 Code");
                // GenJnlLine.ValidateShortcutDimCode(8,FundsTransferHeader."Shortcut Dimension 8 Code");
                GenJnlLine.Description := UPPERCASE(COPYSTR(FundsTransferHeader.Description, 1, 100));
                GenJnlLine.Description2 := UPPERCASE(COPYSTR(FundsTransferHeader."Transfer To", 1, 50));
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            //***************************************End Add Line Amounts************************************************************//
            UNTIL FundsTransferLine.NEXT = 0;
        END;
        COMMIT;
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            BankLedgers.RESET;
            BankLedgers.SETRANGE("Document Type", BankLedgers."Document Type"::Payment);
            BankLedgers.SETRANGE("Document No.", FundsTransferHeader."No.");
            IF BankLedgers.FINDFIRST THEN BEGIN
                FundsTransferHeader2.RESET;
                FundsTransferHeader2.SETRANGE("No.", FundsTransferHeader."No.");
                IF FundsTransferHeader2.FINDFIRST THEN BEGIN
                    FundsTransferHeader2.Status := FundsTransferHeader2.Status::Posted;
                    FundsTransferHeader2.Posted := TRUE;
                    FundsTransferHeader2."Posted By" := USERID;
                    FundsTransferHeader2."Date Posted" := TODAY;
                    FundsTransferHeader2."Time Posted" := TIME;
                    FundsTransferHeader2.MODIFY;
                    FundsTransferLine2.RESET;
                    FundsTransferLine2.SETRANGE("Document No.", FundsTransferHeader2."No.");
                    IF FundsTransferLine2.FINDSET THEN BEGIN
                        REPEAT
                            FundsTransferLine2.Status := FundsTransferLine2.Status::Posted;
                            FundsTransferLine2.Posted := TRUE;
                            FundsTransferLine2."Posted By" := USERID;
                            FundsTransferLine2."Date Posted" := TODAY;
                            FundsTransferLine2."Time Posted" := TIME;
                            FundsTransferLine2.MODIFY;
                        UNTIL FundsTransferLine2.NEXT = 0;
                    END;
                END;
            END;
            COMMIT;
            //************************************************End Update Document**********************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;
    end;

    procedure CheckFundsTransferMandatoryFields("Money Transfer Header": Record 50006; Posting: Boolean)
    var
        EmptyFundsTransferLine: Label 'You cannot Post Funds Transfer with empty Line';
        AmountsNotEqual: Label 'The Amount to Transfer:%1 is not equal to the Total Line Amount:%2';
        MoneyTransferHeader: Record 50006;
        MoneyTransferLine: Record 50007;
    begin
        MoneyTransferHeader.TRANSFERFIELDS("Money Transfer Header", TRUE);
        MoneyTransferHeader.TESTFIELD("Posting Date");
        MoneyTransferHeader.TESTFIELD("Bank Account No.");
        MoneyTransferHeader.TESTFIELD(Description);
        //MoneyTransferHeader.TESTFIELD("Global Dimension 1 Code");
        //MoneyTransferHeader.TESTFIELD(Status,MoneyTransferHeader.Status::Released);
        //Check Funds Transfer Lines
        MoneyTransferLine.RESET;
        MoneyTransferLine.SETRANGE("Document No.", MoneyTransferHeader."No.");
        IF MoneyTransferLine.FINDSET THEN BEGIN
            REPEAT
                MoneyTransferLine.TESTFIELD("Account No.");
                MoneyTransferLine.TESTFIELD(Amount);
            //MoneyTransferLine.TESTFIELD(Description);
            UNTIL MoneyTransferLine.NEXT = 0;
        END ELSE BEGIN
            ERROR(EmptyFundsTransferLine);
        END;
        MoneyTransferHeader.CALCFIELDS("Line Amount", "Line Amount(LCY)");
        IF MoneyTransferHeader."Amount To Transfer" <> MoneyTransferHeader."Line Amount" THEN
            ERROR(AmountsNotEqual, MoneyTransferHeader."Amount To Transfer", MoneyTransferHeader."Line Amount");
    end;

    procedure PostImprest("Imprest Header": Record 50008; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        ImprestLine: Record 50009;
        ImprestHeader: Record 50008;
        SourceCode: Code[20];
        BankLedgers: Record 271;
        ImprestLine2: Record 50009;
        ImprestHeader2: Record 50008;
        DocumentExist: Label 'Imprest document is already posted. "Document No.":%1  already exists in Bank No:%2';
    begin
        ImprestHeader.TRANSFERFIELDS("Imprest Header", TRUE);
        SourceCode := IMPJNL;
        BankLedgers.RESET;
        BankLedgers.SETRANGE("Document No.", ImprestHeader."No.");
        BankLedgers.SETRANGE(Reversed, FALSE);
        IF BankLedgers.FINDFIRST THEN BEGIN
            ERROR(DocumentExist, ImprestHeader."No.", ImprestHeader."Bank Account No.");
        END;

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;
        //********************************************Add Imprest Header*******************************************************//
        ImprestHeader.CALCFIELDS(ImprestHeader.Amount, ImprestHeader."Amount(LCY)");
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := ImprestHeader."Posting Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := ImprestHeader."No.";
        GenJnlLine."External Document No." := ImprestHeader."Reference No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
        GenJnlLine."Account No." := ImprestHeader."Employee No.";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine."Posting Group" := ImprestHeader."Employee Posting Group";
        GenJnlLine.VALIDATE("Posting Group");
        GenJnlLine."Currency Code" := ImprestHeader."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        GenJnlLine.Amount := (ImprestHeader.Amount);  //Debit Amount
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ImprestHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, ImprestHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, ImprestHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, ImprestHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, ImprestHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,ImprestHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,ImprestHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := UPPERCASE(COPYSTR(ImprestHeader.Description, 1, 100));
        GenJnlLine.Description2 := UPPERCASE(COPYSTR(ImprestHeader."Employee Name", 1, 100));
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;

        LineNo := LineNo + 1;
        //Credit Bank
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := ImprestHeader."Posting Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := ImprestHeader."No.";
        GenJnlLine."External Document No." := ImprestHeader."Reference No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := ImprestHeader."Bank Account No.";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine."Currency Code" := ImprestHeader."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        GenJnlLine.Amount := -(ImprestHeader.Amount);  //Credit Amount
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ImprestHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, ImprestHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, ImprestHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, ImprestHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, ImprestHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,ImprestHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,ImprestHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := UPPERCASE(COPYSTR(ImprestHeader.Description, 1, 100));
        GenJnlLine.Description2 := UPPERCASE(COPYSTR(ImprestHeader."Employee Name", 1, 100));
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            BankLedgers.RESET;
            BankLedgers.SETRANGE(BankLedgers."Document No.", ImprestHeader."No.");
            IF BankLedgers.FINDFIRST THEN BEGIN
                ImprestHeader2.RESET;
                ImprestHeader2.SETRANGE(ImprestHeader2."No.", ImprestHeader."No.");
                IF ImprestHeader2.FINDFIRST THEN BEGIN
                    ImprestHeader2.Status := ImprestHeader2.Status::Posted;
                    ImprestHeader2.Posted := TRUE;
                    ImprestHeader2."Posted By" := USERID;
                    ImprestHeader2."Date Posted" := TODAY;
                    ImprestHeader2."Time Posted" := TIME;
                    ImprestHeader2.MODIFY;
                END;
            END;
            //**********************************************End Update Document***************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;
    end;

    procedure CheckImprestMandatoryFields("Imprest Header": Record 50008; Posting: Boolean)
    var
        ImprestHeader: Record 50008;
        ImprestLine: Record 50009;
        EmptyImprestLine: Label 'You cannot Post Imprest with empty Line';
    begin
        ImprestHeader.TRANSFERFIELDS("Imprest Header", TRUE);
        ImprestHeader.TESTFIELD("Posting Date");
        //ImprestHeader.TESTFIELD("Bank Account No.");
        ImprestHeader.TESTFIELD("Employee No.");
        ImprestHeader.TESTFIELD(Description);
        ImprestHeader.TESTFIELD("Employee Posting Group");
        //ImprestHeader.TESTFIELD("Global Dimension 1 Code");
        ImprestHeader.TESTFIELD(Type);
        ImprestHeader.TESTFIELD("Date From");
        ImprestHeader.TESTFIELD("Date To");
        IF Posting THEN
            // ImprestHeader.TESTFIELD(Status,ImprestHeader.Status::Released);
            //Check Imprest Lines
            ImprestLine.RESET;
        ImprestLine.SETRANGE("Document No.", ImprestHeader."No.");
        IF ImprestLine.FINDSET THEN BEGIN
            REPEAT
                ImprestLine.TESTFIELD("Account No.");
                ImprestLine.TESTFIELD("Gross Amount");
                IF ImprestLine."Account Type" = ImprestLine."Account Type"::"G/L Account" THEN BEGIN
                    //  ImprestLine.TESTFIELD("Global Dimension 1 Code");
                    // ImprestLine.TESTFIELD("Global Dimension 2 Code");
                    // ImprestLine.TESTFIELD("Shortcut Dimension 4 Code");
                    // ImprestLine.TESTFIELD("Shortcut Dimension 5 Code");
                    //ImprestLine.TESTFIELD("Shortcut Dimension 6 Code");
                END;
            UNTIL ImprestLine.NEXT = 0;
        END ELSE BEGIN
            ERROR(EmptyImprestLine);
        END;
    end;

    procedure PostImprestSurrender("Imprest Surrender Header": Record 50010; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        SourceCode: Code[20];
        ImprestSurrenderLine: Record 50011;
        ImprestSurrenderHeader: Record 50010;
        ImprestSurrenderLine2: Record 50011;
        ImprestSurrenderHeader2: Record 50010;
        DocumentExist: Label 'Imprest Surrender document is already posted. "Document No.":%1  already exists in Employee No:%2';
        ImprestHeader: Record 50008;
        EmployeeLedgers: Record 5222;
        FundsTransactionCodes: Record 50027;
        FundsTaxCode: Record 50028;
        PaymentLine: Record 50003;
        EmployeeLedgerEntry: Record 5222;
    begin
        ImprestSurrenderHeader.TRANSFERFIELDS("Imprest Surrender Header", TRUE);
        SourceCode := IMPSURRJNL;
        EmployeeLedgers.RESET;
        EmployeeLedgers.SETRANGE(EmployeeLedgers."Document No.", ImprestSurrenderHeader."No.");
        IF EmployeeLedgers.FINDFIRST THEN BEGIN
            ERROR(DocumentExist, ImprestSurrenderHeader."No.", ImprestSurrenderHeader."Employee No.");
        END;

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;
        //********************************************Add Surrender Header*******************************************************//
        ImprestSurrenderHeader.CALCFIELDS(ImprestSurrenderHeader."Actual Spent");
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := ImprestSurrenderHeader."Posting Date";
        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::"Imprest Surrender";
        GenJnlLine."Document No." := ImprestSurrenderHeader."No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
        GenJnlLine."Account No." := ImprestSurrenderHeader."Employee No.";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        ImprestHeader.GET(ImprestSurrenderHeader."Imprest No.");
        GenJnlLine."Posting Group" := ImprestHeader."Employee Posting Group";
        GenJnlLine.VALIDATE("Posting Group");
        GenJnlLine."Currency Code" := ImprestSurrenderHeader."Currency Code";
        GenJnlLine.VALIDATE("Currency Factor");
        GenJnlLine.Amount := -(ImprestSurrenderHeader."Actual Spent");  //Credit Amount
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ImprestSurrenderHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ImprestSurrenderHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, ImprestSurrenderHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, ImprestSurrenderHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, ImprestSurrenderHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, ImprestSurrenderHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,ImprestSurrenderHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,ImprestSurrenderHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := COPYSTR(ImprestSurrenderHeader.Description, 1, 100);
        GenJnlLine.Description2 := COPYSTR(ImprestSurrenderHeader."Employee Name", 1, 100);
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        PaymentLine.RESET;
        PaymentLine.SETRANGE("Payee No.", ImprestHeader."No.");
        PaymentLine.SETRANGE(Reversed, FALSE);
        IF PaymentLine.FINDFIRST THEN BEGIN
            REPEAT
                EmployeeLedgerEntry.RESET;
                EmployeeLedgerEntry.SETRANGE("Employee No.", ImprestSurrenderHeader."Employee No.");
                EmployeeLedgerEntry.SETRANGE("Document No.", PaymentLine."Document No.");
                EmployeeLedgerEntry.SETRANGE(Reversed, FALSE);
                IF EmployeeLedgerEntry.FINDFIRST THEN BEGIN
                    GenJnlLine."Applies-to Doc. Type" := EmployeeLedgerEntry."Document Type";
                    GenJnlLine."Applies-to Doc. No." := EmployeeLedgerEntry."Document No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    //MESSAGE(EmployeeLedgerEntry."Document No.");
                END;
            UNTIL PaymentLine.NEXT = 0;
        END;
        GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;
        //********************************End Add Surrender Header********************************************************************//
        //**********************************Add Surrender Lines***********************************************************************//
        ImprestSurrenderLine.RESET;
        ImprestSurrenderLine.SETRANGE(ImprestSurrenderLine."Document No.", ImprestSurrenderHeader."No.");
        ImprestSurrenderLine.SETFILTER(ImprestSurrenderLine."Actual Spent", '<>%1', 0);
        IF ImprestSurrenderLine.FINDSET THEN BEGIN
            REPEAT
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := ImprestSurrenderHeader."Posting Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::"Imprest Surrender";
                GenJnlLine."Document No." := ImprestSurrenderLine."Document No.";

                GenJnlLine."Account Type" := ImprestSurrenderLine."Account Type";
                GenJnlLine."Account No." := ImprestSurrenderLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                IF ImprestSurrenderLine."Account Type" <> ImprestSurrenderLine."Account Type"::"G/L Account" THEN BEGIN
                    GenJnlLine."Posting Group" := ImprestSurrenderLine."Posting Group";
                    GenJnlLine.VALIDATE("Posting Group");
                END;
                GenJnlLine."Currency Code" := ImprestSurrenderHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := ImprestSurrenderLine."Actual Spent";  //Debit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := ImprestSurrenderLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ImprestSurrenderLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, ImprestSurrenderLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, ImprestSurrenderLine."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, ImprestSurrenderLine."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, ImprestSurrenderLine."Shortcut Dimension 6 Code");
                //GenJnlLine.ValidateShortcutDimCode(7,ImprestSurrenderLine."Shortcut Dimension 7 Code");
                // GenJnlLine.ValidateShortcutDimCode(8,ImprestSurrenderLine."Shortcut Dimension 8 Code");
                GenJnlLine.Description := COPYSTR(ImprestSurrenderLine.Description, 1, 100);
                GenJnlLine.Description2 := COPYSTR(ImprestSurrenderHeader."Employee Name", 1, 100);
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                IF ImprestSurrenderLine."Account Type" = ImprestSurrenderLine."Account Type"::"Fixed Asset" THEN BEGIN
                    GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost";
                    GenJnlLine."FA Posting Date" := ImprestSurrenderHeader."Posting Date";
                    GenJnlLine."Depreciation Book Code" := ImprestSurrenderLine."FA Depreciation Book";
                    GenJnlLine.VALIDATE(GenJnlLine."Depreciation Book Code");
                    GenJnlLine."FA Add.-Currency Factor" := 0;
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                END;
                GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            /*
            //TAX
              LineNo:=LineNo+1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name":="Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name":="Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code":=SourceCode;
                GenJnlLine."Line No.":=LineNo;
                GenJnlLine."Posting Date":=ImprestSurrenderHeader."Posting Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::"Imprest Surrender";
                GenJnlLine."Document No.":=ImprestSurrenderLine."Document No.";
                GenJnlLine."Account Type":=ImprestSurrenderLine."Account Type";
                GenJnlLine."Account No.":=ImprestSurrenderLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                IF ImprestSurrenderLine."Account Type"<>ImprestSurrenderLine."Account Type"::"G/L Account" THEN BEGIN
                  GenJnlLine."Posting Group":=ImprestSurrenderLine."Posting Group";
                  GenJnlLine.VALIDATE("Posting Group");
                END;
                GenJnlLine."Currency Code":=ImprestSurrenderHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount:=ImprestSurrenderLine."Tax Amount";  //Debit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                FundsTransactionCodes.RESET;
                FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code",ImprestSurrenderLine."Imprest Code");
                FundsTransactionCodes.FINDFIRST;
                IF FundsTransactionCodes."Include Withholding Tax" THEN BEGIN
                FundsTransactionCodes.TESTFIELD("Withholding Tax Code");
                FundsTaxCode.GET(FundsTransactionCodes."Withholding Tax Code");

                 FundsTaxCode.TESTFIELD("Account No.");

               END ;


                GenJnlLine."Bal. Account No.":=FundsTaxCode."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code":=ImprestSurrenderLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code":=ImprestSurrenderLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3,ImprestSurrenderLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4,ImprestSurrenderLine."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5,ImprestSurrenderLine."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6,ImprestSurrenderLine."Shortcut Dimension 6 Code");
                //GenJnlLine.ValidateShortcutDimCode(7,ImprestSurrenderLine."Shortcut Dimension 7 Code");
               // GenJnlLine.ValidateShortcutDimCode(8,ImprestSurrenderLine."Shortcut Dimension 8 Code");
                GenJnlLine.Description:=COPYSTR(ImprestSurrenderLine.Description+'-Imprest Tax',1,100);
                GenJnlLine.Description2:=COPYSTR(ImprestSurrenderHeader."Employee Name"+'-Imprest Tax',1,100);
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                IF ImprestSurrenderLine."Account Type"=ImprestSurrenderLine."Account Type"::"Fixed Asset" THEN BEGIN
                  GenJnlLine."FA Posting Type":=GenJnlLine."FA Posting Type"::"Acquisition Cost";
                  GenJnlLine."FA Posting Date":=ImprestSurrenderHeader."Posting Date";
                  GenJnlLine."Depreciation Book Code":=ImprestSurrenderLine."FA Depreciation Book";
                  GenJnlLine.VALIDATE(GenJnlLine."Depreciation Book Code");
                  GenJnlLine."FA Add.-Currency Factor":=0;
                  GenJnlLine."Gen. Bus. Posting Group":='';
                END;
                GenJnlLine."Employee Transaction Type":=GenJnlLine."Employee Transaction Type"::Imprest;
                IF GenJnlLine.Amount<>0 THEN
                    GenJnlLine.INSERT;

            */


            UNTIL ImprestSurrenderLine.NEXT = 0;
        END;
        //**********************************End Add Surrender Lines*********************************************************************//
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            EmployeeLedgers.RESET;
            EmployeeLedgers.SETRANGE(EmployeeLedgers."Document No.", ImprestSurrenderHeader."No.");
            IF EmployeeLedgers.FINDFIRST THEN BEGIN
                ImprestSurrenderHeader2.RESET;
                ImprestSurrenderHeader2.SETRANGE(ImprestSurrenderHeader2."No.", ImprestSurrenderHeader."No.");
                IF ImprestSurrenderHeader2.FINDFIRST THEN BEGIN
                    ImprestSurrenderHeader2.Status := ImprestSurrenderHeader2.Status::Posted;
                    ImprestSurrenderHeader2.Posted := TRUE;
                    ImprestSurrenderHeader2."Posted By" := USERID;
                    ImprestSurrenderHeader2."Date Posted" := TODAY;
                    ImprestSurrenderHeader2."Time Posted" := TIME;
                    IF ImprestSurrenderHeader2.MODIFY THEN BEGIN
                        ImprestSurrenderLine2.RESET;
                        ImprestSurrenderLine2.SETRANGE(ImprestSurrenderLine2."Document No.", ImprestSurrenderHeader2."No.");
                        IF ImprestSurrenderLine2.FINDSET THEN BEGIN
                            REPEAT
                                ImprestSurrenderLine2."Posting Date" := ImprestSurrenderHeader2."Posting Date";
                                ImprestSurrenderLine2.Posted := ImprestSurrenderHeader2.Posted;
                                ImprestSurrenderLine2."Posted By" := USERID;
                                ImprestSurrenderLine2."Date Posted" := TODAY;
                                ImprestSurrenderLine2."Time Posted" := TIME;
                                ImprestSurrenderLine2.MODIFY;
                            UNTIL ImprestSurrenderLine2.NEXT = 0;
                        END;
                        //Update imprest surrender status
                        ImprestHeader.RESET;
                        ImprestHeader.SETRANGE(ImprestHeader."No.", ImprestSurrenderHeader2."Imprest No.");
                        IF ImprestHeader.FINDFIRST THEN BEGIN
                            ImprestHeader.CALCFIELDS(Amount);
                            ImprestSurrenderHeader.CALCFIELDS(Amount);
                            IF (ImprestHeader.Amount = ImprestSurrenderHeader.Amount) OR (ImprestSurrenderHeader.Amount > ImprestHeader.Amount) THEN BEGIN
                                ImprestHeader.Surrendered := TRUE;
                                ImprestHeader."Surrender status" := ImprestHeader."Surrender status"::"Fully surrendered";
                                ImprestHeader.MODIFY;
                            END ELSE BEGIN
                                ImprestHeader.Surrendered := TRUE;
                                ImprestHeader."Surrender status" := ImprestHeader."Surrender status"::"Partially Surrendered";
                                ImprestHeader.MODIFY;
                            END;
                        END;
                    END;
                END;
            END;
            //**********************************************End Update Document*************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting***********************************************************//
        END;

    end;

    procedure CheckImprestSurrenderMandatoryFields("Imprest Surrender Header": Record 50010; Posting: Boolean)
    var
        ImprestSurrenderHeader: Record 50010;
        ImprestSurrenderLine: Record 50011;
        EmptyImprestSurrenderLine: Label 'You cannot Post Imprest Surrender with empty Line';
    begin
        ImprestSurrenderHeader.TRANSFERFIELDS("Imprest Surrender Header", TRUE);
        ImprestSurrenderHeader.TESTFIELD("Posting Date");
        ImprestSurrenderHeader.TESTFIELD("Employee No.");
        ImprestSurrenderHeader.TESTFIELD("Imprest No.");
        ImprestSurrenderHeader.TESTFIELD(Description);
        ImprestSurrenderHeader.TESTFIELD("Global Dimension 1 Code");
        //ImprestSurrenderHeader.TESTFIELD("Shortcut Dimension 4 Code");
        //ImprestSurrenderHeader.TESTFIELD("Shortcut Dimension 6 Code");
        IF Posting THEN
            ImprestSurrenderHeader.TESTFIELD(Status, ImprestSurrenderHeader.Status::Released);
        //Check Imprest Lines
        ImprestSurrenderLine.RESET;
        ImprestSurrenderLine.SETRANGE("Document No.", ImprestSurrenderHeader."No.");
        IF ImprestSurrenderLine.FINDSET THEN BEGIN
            REPEAT
                ImprestSurrenderLine.TESTFIELD("Account No.");
                ImprestSurrenderLine.TESTFIELD(Description);
                IF ImprestSurrenderLine."Account Type" = ImprestSurrenderLine."Account Type"::"G/L Account" THEN BEGIN
                    // ImprestSurrenderLine.TESTFIELD("Global Dimension 1 Code");

                END;
            UNTIL ImprestSurrenderLine.NEXT = 0;
        END ELSE BEGIN
            ERROR(EmptyImprestSurrenderLine);
        END;
    end;

    procedure PostFundsClaim("Funds Claim Header": Record 50012; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        FundsClaimLine: Record 50013;
        FundsClaimHeader: Record 50012;
        SourceCode: Code[20];
        BankLedgerEntries: Record 271;
        FundsClaimLine2: Record 50013;
        FundsClaimHeader2: Record 50012;
        DocumentExist: Label 'Payment Document is already posted, "Document No.":%1 already exists in Bank No:%2';
    begin
        FundsClaimHeader.TRANSFERFIELDS("Funds Claim Header", TRUE);
        SourceCode := PAYMENTJNL;

        BankLedgerEntries.RESET;
        BankLedgerEntries.SETRANGE(BankLedgerEntries."Document Type", BankLedgerEntries."Document Type"::Payment);
        BankLedgerEntries.SETRANGE(BankLedgerEntries."Document No.", FundsClaimHeader."No.");
        IF BankLedgerEntries.FINDFIRST THEN BEGIN
            ERROR(DocumentExist, FundsClaimHeader."No.", FundsClaimHeader."Bank Account No.");
        END;

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;
        //*********************************************Add Payment Header***************************************************************//
        FundsClaimHeader.CALCFIELDS("Net Amount");
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE("Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE("Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := FundsClaimHeader."Posting Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := FundsClaimHeader."No.";
        GenJnlLine."External Document No." := FundsClaimHeader."Reference No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := FundsClaimHeader."Bank Account No.";
        GenJnlLine.VALIDATE("Account No.");
        GenJnlLine."Currency Code" := FundsClaimHeader."Currency Code";
        GenJnlLine.VALIDATE("Currency Code");
        GenJnlLine.Amount := -(FundsClaimHeader."Net Amount");  //Credit Amount
        GenJnlLine.VALIDATE(Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE("Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := FundsClaimHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := FundsClaimHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, FundsClaimHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, FundsClaimHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, FundsClaimHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, FundsClaimHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,FundsClaimHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,FundsClaimHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := UPPERCASE(COPYSTR(FundsClaimHeader.Description, 1, 100));
        GenJnlLine.Description2 := UPPERCASE(COPYSTR(FundsClaimHeader."Payee Name", 1, 100));
        GenJnlLine.VALIDATE(Description);
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;
        //************************************************End Add to Bank***************************************************************//

        //*********************************************Add Funds Claim Lines************************************************************//
        FundsClaimLine.RESET;
        FundsClaimLine.SETRANGE(FundsClaimLine."Document No.", FundsClaimHeader."No.");
        FundsClaimLine.SETFILTER(FundsClaimLine.Amount, '<>%1', 0);
        IF FundsClaimLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line Amounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE("Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE("Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := FundsClaimHeader."Posting Date";
                GenJnlLine."Document No." := FundsClaimLine."Document No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Account Type" := FundsClaimLine."Account Type";
                GenJnlLine."Account No." := FundsClaimLine."Account No.";
                GenJnlLine.VALIDATE("Account No.");
                GenJnlLine."Posting Group" := FundsClaimLine."Posting Group";
                GenJnlLine."External Document No." := FundsClaimHeader."Reference No.";
                GenJnlLine."Currency Code" := FundsClaimHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := FundsClaimLine.Amount;  //Debit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := FundsClaimHeader."Global Dimension 1 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := FundsClaimLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, FundsClaimLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, FundsClaimLine."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, FundsClaimLine."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, FundsClaimLine."Shortcut Dimension 6 Code");
                // GenJnlLine.ValidateShortcutDimCode(7,FundsClaimLine."Shortcut Dimension 7 Code");
                // GenJnlLine.ValidateShortcutDimCode(8,FundsClaimLine."Shortcut Dimension 8 Code");
                GenJnlLine.Description := UPPERCASE(COPYSTR(FundsClaimHeader.Description, 1, 100));
                GenJnlLine.Description2 := UPPERCASE(COPYSTR(FundsClaimHeader."Payee Name", 1, 100));
                GenJnlLine.VALIDATE(Description);
                GenJnlLine."Employee Transaction Type" := FundsClaimLine."Employee Transaction Type";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            //*************************************End Add Line Amounts**********************************************************//
            UNTIL FundsClaimLine.NEXT = 0;
        END;
        //*********************************************End Add Funds Claim Lines************************************************************//
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            BankLedgerEntries.RESET;
            BankLedgerEntries.SETRANGE(BankLedgerEntries."Document No.", FundsClaimHeader."No.");
            IF BankLedgerEntries.FINDFIRST THEN BEGIN
                FundsClaimHeader2.RESET;
                FundsClaimHeader2.SETRANGE("No.", FundsClaimHeader."No.");
                IF FundsClaimHeader2.FINDFIRST THEN BEGIN
                    FundsClaimHeader2.Status := FundsClaimHeader2.Status::Posted;
                    FundsClaimHeader2.Posted := TRUE;
                    FundsClaimHeader2."Posted By" := USERID;
                    FundsClaimHeader2."Date Posted" := TODAY;
                    FundsClaimHeader2."Time Posted" := TIME;
                    FundsClaimHeader2.MODIFY;
                    FundsClaimLine2.RESET;
                    FundsClaimLine2.SETRANGE("Document No.", FundsClaimHeader2."No.");
                    IF FundsClaimLine2.FINDSET THEN BEGIN
                        REPEAT
                            FundsClaimLine2.Status := FundsClaimLine2.Status::Posted;
                            FundsClaimLine2.Posted := TRUE;
                            FundsClaimLine2."Posted By" := USERID;
                            FundsClaimLine2."Date Posted" := TODAY;
                            FundsClaimLine2."Time Posted" := TIME;
                            FundsClaimLine2.MODIFY;
                        UNTIL FundsClaimLine2.NEXT = 0;
                    END;
                END;
            END;
            COMMIT;
            //***********************************************End Update Document************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;
    end;

    procedure CheckFundsClaimMandatoryFields("Funds Claim Header": Record 50012; Posting: Boolean)
    var
        EmptyFundsClaimLine: Label 'You cannot Post Funds Claim with empty Line';
        FundsClaimHeader: Record 50012;
        FundsClaimLine: Record 50013;
    begin
        FundsClaimHeader.TRANSFERFIELDS("Funds Claim Header", TRUE);
        FundsClaimHeader.TESTFIELD("Posting Date");
        IF FundsClaimHeader."Payment Mode" = FundsClaimHeader."Payment Mode"::Cheque THEN BEGIN
            FundsClaimHeader.TESTFIELD("Reference No.");
        END;
        FundsClaimHeader.TESTFIELD("Payee No.");
        FundsClaimHeader.TESTFIELD(Description);
        FundsClaimHeader.TESTFIELD("Global Dimension 1 Code");
        IF Posting THEN BEGIN
            FundsClaimHeader.TESTFIELD("Bank Account No.");
            FundsClaimHeader.TESTFIELD(Status, FundsClaimHeader.Status::Released);
        END;

        //Check Funds Claim Lines
        FundsClaimLine.RESET;
        FundsClaimLine.SETRANGE("Document No.", FundsClaimHeader."No.");
        IF FundsClaimLine.FINDSET THEN BEGIN
            REPEAT
                FundsClaimLine.TESTFIELD("Account No.");
                FundsClaimLine.TESTFIELD(Amount);
                FundsClaimLine.TESTFIELD(Description);
                FundsClaimLine.TESTFIELD("Global Dimension 1 Code");
                IF FundsClaimLine."Account Type" = FundsClaimLine."Account Type"::"G/L Account" THEN BEGIN
                    FundsClaimLine.TESTFIELD("Global Dimension 2 Code");
                    /*
                    FundsClaimLine.TESTFIELD("Shortcut Dimension 3 Code");
                    FundsClaimLine.TESTFIELD("Shortcut Dimension 4 Code");
                    FundsClaimLine.TESTFIELD("Shortcut Dimension 5 Code");
                    FundsClaimLine.TESTFIELD("Shortcut Dimension 6 Code");
                    */
                END;
            UNTIL FundsClaimLine.NEXT = 0;
        END ELSE BEGIN
            ERROR(EmptyFundsClaimLine);
        END;

    end;

    local procedure CustomerLinesExist("Payment Header": Record 50002): Boolean
    var
        "Payment Line": Record 50003;
        "Payment Line2": Record 50003;
    begin
        "Payment Line".RESET;
        "Payment Line".SETRANGE("Payment Line"."Document No.", "Payment Header"."No.");
        "Payment Line".SETRANGE("Payment Line"."Account Type", "Payment Line"."Account Type"::Customer);
        IF "Payment Line".FINDFIRST THEN BEGIN
            EXIT(TRUE);
        END ELSE BEGIN
            EXIT(FALSE)
        END;
    end;
    /* 
        procedure SendVendorEmail(DocumentNo: Code[50]; AccountNo: Code[20]; Amount: Decimal)
        var
            Payment: Record 50003;
            VendorAccount: Record 23;
        begin
            VendorAccount.RESET;
            VendorAccount.SETRANGE(VendorAccount."No.", AccountNo);
            VendorAccount.SETFILTER(VendorAccount."E-Mail", '<>%1', '');
            IF VendorAccount.FINDFIRST THEN BEGIN
                SMTP.GET;
                 SMTPMail.CreateMessage(SMTP."Sender Name", SMTP."Sender Email Address",format(VendorAccount."E-Mail"), 'Payment No: ' + DocumentNo, '', TRUE);
                SMTPMail.AppendBody('Dear' + ' ' + VendorAccount.Name + ',');
                SMTPMail.AppendBody('<br><br>');
                SMTPMail.AppendBody('Payment voucher ' + DocumentNo + ' has been approved and funds will be available in your account within 5 working days');
                SMTPMail.AppendBody('<br><br>');
                SMTPMail.AppendBody('Thank you.');
                SMTPMail.AppendBody('<br><br>');
                SMTPMail.AppendBody(SMTP."Sender Name");
                SMTPMail.AppendBody('<br><br>');
                SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this Email');
                SMTPMail.Send;
            END;
        end; */

    procedure FnCreateGnlJournalLine(TemplateName: Text; BatchName: Text; DocumentNo: Code[30]; LineNo: Integer; TransactionType: Option " ","Registration Fee","Share Capital","Interest Paid","Loan Repayment","Deposit Contribution","Insurance Contribution","Benevolent Fund",Loan,"Unallocated Funds",Dividend,"FOSA Account"; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Member,Investor; AccountNo: Code[50]; TransactionDate: Date; TransactionAmount: Decimal; DimensionActivity: Code[40]; ExternalDocumentNo: Code[50]; TransactionDescription: Text; LoanNumber: Code[50])
    var
        GenJournalLine: Record 81;
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := TemplateName;
        GenJournalLine."Journal Batch Name" := BatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine."Account No." := AccountNo;
        //GenJournalLine."Transaction Type":=TransactionType;
        //GenJournalLine."Loan No":=LoanNumber;
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Posting Date" := TransactionDate;
        GenJournalLine.Description := TransactionDescription;
        GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
        GenJournalLine.Amount := TransactionAmount;
        GenJournalLine."External Document No." := ExternalDocumentNo;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        //GenJournalLine."Shortcut Dimension 1 Code":=DimensionActivity;
        //GenJournalLine."Shortcut Dimension 2 Code":=FnGetUserBranch();
        //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
        //GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    procedure PostDocumentReversal("Reversal Header": Record 50034; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        ReversalLine: Record 50035;
        ReversalHeader: Record 50034;
        SourceCode: Code[20];
        BankLedgers: Record 271;
        ReversalLine2: Record 50035;
        ReversalHeader2: Record 50034;
        DocumentExist: Label 'Imprest document is already posted. "Document No.":%1  already exists in Bank No:%2';
        PaymentHeader: Record 50002;
        ReceiptHeader: Record 50004;
        FundsTransferHeader: Record 50006;
        GLEntry: Record 17;
        VendorLedgerEntry: Record 25;
        DetailedVendorLedgEntry: Record 380;
        CustLedgerEntry: Record 21;
        DetailedCustLedgEntry: Record 379;
        EmployeeLedgerEntry: Record 5222;
        DetailedEmployeeLedgerEntry: Record 5223;
        BankAccountLedgerEntry: Record 271;
    begin
        ReversalHeader.TRANSFERFIELDS("Reversal Header", TRUE);
        SourceCode := IMPJNL;

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;
        //********************************************Add Imprest Header*******************************************************//
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := TODAY;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := ReversalHeader."Document No.";
        GenJnlLine."Account Type" := ReversalHeader."Account Type";
        GenJnlLine."Account No." := ReversalHeader."Account No.";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        //GenJnlLine."Posting Group":=ReversalHeader."Employee Posting Group";
        //GenJnlLine.VALIDATE("Posting Group");
        //GenJnlLine."Currency Code":=ReversalHeader."Currency Code";
        //GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        IF (ReversalHeader."Document Type" = ReversalHeader."Document Type"::Payment) OR (ReversalHeader."Document Type" = ReversalHeader."Document Type"::"Funds Transfer") THEN BEGIN
            GenJnlLine.Amount := ReversalHeader.Amount;
        END ELSE BEGIN
            GenJnlLine.Amount := ReversalHeader.Amount * -1;
        END;
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ReversalHeader."Shortcut Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ReversalHeader."Shortcut Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, ReversalHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, ReversalHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, ReversalHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, ReversalHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,ReversalHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,ReversalHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := UPPERCASE(COPYSTR(ReversalHeader.Description, 1, 100));
        GenJnlLine.Description2 := UPPERCASE(COPYSTR(ReversalHeader.Description + ' Reversal', 1, 100));
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;

        ReversalLine.RESET;
        ReversalLine.SETRANGE(ReversalLine."No.", ReversalHeader."No.");
        ReversalLine.SETFILTER(ReversalLine.Amount, '<>%1', 0);
        IF ReversalLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line NetAmounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := TODAY;
                GenJnlLine."Document No." := ReversalLine."Document No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Account Type" := ReversalLine."Account Type";
                GenJnlLine."Account No." := ReversalLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                /*GenJnlLine."External Document No.":=ReversalHeader."Reference No.";
                GenJnlLine."Currency Code":=ReversalHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");*/
                IF (ReversalHeader."Document Type" = ReversalHeader."Document Type"::Payment) OR (ReversalHeader."Document Type" = ReversalHeader."Document Type"::"Funds Transfer") THEN BEGIN
                    GenJnlLine.Amount := ReversalLine.Amount * -1;
                END ELSE BEGIN
                    GenJnlLine.Amount := ReversalLine.Amount;
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := ReversalHeader."Shortcut Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ReversalHeader."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, ReversalHeader."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, ReversalHeader."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, ReversalHeader."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, ReversalHeader."Shortcut Dimension 6 Code");
                GenJnlLine.ValidateShortcutDimCode(7, ReversalHeader."Shortcut Dimension 7 Code");
                GenJnlLine.ValidateShortcutDimCode(8, ReversalHeader."Shortcut Dimension 8 Code");
                GenJnlLine.Description := COPYSTR(ReversalHeader.Description, 1, 100);
                GenJnlLine.Description2 := UPPERCASE(COPYSTR("Reversal Header".Description + ' Reversal', 1, 100));
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                // GenJnlLine."Applies-to Doc. Type":=ReversalLine."Applies-to Doc. Type";
                // GenJnlLine."Applies-to ID":=ReversalLine."Applies-to ID";
                // GenJnlLine."Applies-to Doc. No.":=ReversalLine."Applies-to Doc. No.";
                /* GenJnlLine."Employee Transaction Type":=ReversalLine."Employee Transaction Type";
                 GenJnlLine."Loan Application No.":=ReversalLine."Investment Application No.";
                 GenJnlLine."Loan Account No.":=ReversalLine."Investment Account No.";*/
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            UNTIL ReversalLine.NEXT = 0;
        END;

        COMMIT;

        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            ReversalHeader2.RESET;
            ReversalHeader2.SETRANGE(ReversalHeader2."No.", ReversalHeader."No.");
            IF ReversalHeader2.FINDFIRST THEN BEGIN
                ReversalHeader2."Reversal Posted" := TRUE;
                ReversalHeader2."Reversal Posted By" := USERID;
                ReversalHeader2."Reversal Posting Date" := TODAY;
                ReversalHeader2.MODIFY;
                IF ReversalHeader2."Document Type" = ReversalHeader2."Document Type"::Payment THEN BEGIN
                    PaymentHeader.RESET;
                    PaymentHeader.SETRANGE(PaymentHeader."No.", ReversalHeader2."Document No.");
                    IF PaymentHeader.FINDFIRST THEN BEGIN
                        PaymentHeader.Reversed := TRUE;
                        PaymentHeader.MODIFY;
                    END;
                END ELSE
                    IF ReversalHeader2."Document Type" = ReversalHeader2."Document Type"::Receipt THEN BEGIN
                        ReceiptHeader.RESET;
                        ReceiptHeader.SETRANGE(ReceiptHeader."No.", ReversalHeader2."Document No.");
                        IF ReceiptHeader.FINDFIRST THEN BEGIN
                            ReceiptHeader.Reversed := TRUE;
                            ReceiptHeader.MODIFY;
                        END;
                    END ELSE
                        IF ReversalHeader2."Document Type" = ReversalHeader2."Document Type"::"Funds Transfer" THEN BEGIN
                            FundsTransferHeader.RESET;
                            FundsTransferHeader.SETRANGE(FundsTransferHeader."No.", ReversalHeader2."Document No.");
                            IF FundsTransferHeader.FINDFIRST THEN BEGIN
                                FundsTransferHeader.Reversed := TRUE;
                                FundsTransferHeader.MODIFY;
                            END;
                        END;
                GLEntry.RESET;
                GLEntry.SETRANGE(GLEntry."Document No.", "Reversal Header"."Document No.");
                GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
                IF GLEntry.FINDSET THEN BEGIN
                    REPEAT
                        GLEntry.Reversed := TRUE;
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                CustEntry.RESET;
                CustEntry.SETRANGE(CustEntry."Document No.", "Reversal Header"."Document No.");
                CustEntry.SETRANGE(CustEntry.Reversed, FALSE);
                IF CustEntry.FINDSET THEN BEGIN
                    REPEAT
                        CustEntry.Reversed := TRUE;
                        CustEntry.MODIFY;
                    UNTIL CustEntry.NEXT = 0;
                END;
                BankAccountLedgerEntry.RESET;
                BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Document No.", "Reversal Header"."Document No.");
                BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry.Reversed, FALSE);
                IF BankAccountLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        BankAccountLedgerEntry.Reversed := TRUE;
                        BankAccountLedgerEntry.MODIFY;
                    UNTIL BankAccountLedgerEntry.NEXT = 0;
                END;
                VendorLedgerEntry.RESET;
                VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Document No.", "Reversal Header"."Document No.");
                VendorLedgerEntry.SETRANGE(VendorLedgerEntry.Reversed, FALSE);
                IF VendorLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        VendorLedgerEntry.Reversed := TRUE;
                        VendorLedgerEntry.MODIFY;
                    UNTIL VendorLedgerEntry.NEXT = 0;
                END;
                /* DetailedVendorLedgEntry.RESET;
                  DetailedVendorLedgEntry.SETRANGE(DetailedVendorLedgEntry."Document No.","Reversal Header"."Document No.");
                  DetailedVendorLedgEntry.SETRANGE(DetailedVendorLedgEntry.Reversed,FALSE);
                  IF DetailedVendorLedgEntry.FINDSET THEN BEGIN
                  REPEAT
                    DetailedVendorLedgEntry.Reversed:=TRUE;
                    DetailedVendorLedgEntry.MODIFY;
                  UNTIL DetailedVendorLedgEntry.NEXT=0;
                 END; */
                EmployeeLedgerEntry.RESET;
                EmployeeLedgerEntry.SETRANGE(EmployeeLedgerEntry."Document No.", "Reversal Header"."Document No.");
                EmployeeLedgerEntry.SETRANGE(EmployeeLedgerEntry.Reversed, FALSE);
                IF EmployeeLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        EmployeeLedgerEntry.Reversed := TRUE;
                        EmployeeLedgerEntry.MODIFY;
                    UNTIL EmployeeLedgerEntry.NEXT = 0;
                END;
                /* DetailedEmployeeLedgerEntry.RESET;
                 DetailedEmployeeLedgerEntry.SETRANGE(DetailedEmployeeLedgerEntry."Document No.","Reversal Header"."Document No.");
                 DetailedEmployeeLedgerEntry.SETRANGE(DetailedEmployeeLedgerEntry.Reversed,FALSE);
                 IF DetailedEmployeeLedgerEntry.FINDSET THEN BEGIN
                 REPEAT
                   DetailedEmployeeLedgerEntry.Reversed:=TRUE;
                   DetailedEmployeeLedgerEntry.MODIFY;
                 UNTIL DetailedEmployeeLedgerEntry.NEXT=0;
                END;*/
            END;



            //**********************************************End Update Document***************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;

    end;

    procedure CreateEmployeeLoanReceipt(LineNo: Integer)
    var
        ReceiptHeader: Record 50004;
        ReceiptLine: Record 50005;
        Employee: Record 5200;
        CustomerLedgerEntry: Record 21;/*  */
                                       /*    EmployeeLoanProducts: Record 50082;
                                          EmployeeLoanAccounts: Record 50075; */
    begin
        /*insert receipt header
        FundsGeneralSetup.GET;
        
        ReceiptHeader.INIT;
        ReceiptHeader."No.":=NoSeriesManagement.GetNextNo(FundsGeneralSetup."Receipt Nos.",0D,TRUE);
        ReceiptHeader."Posting Date":=TODAY;
        ReceiptHeader."Payment Mode":=ReceiptHeader."Payment Mode"::" ";
        ReceiptHeader."Receipt Types":=ReceiptHeader."Receipt Types"::"G/L Account";
        ReceiptHeader."Receipt Type":=ReceiptHeader."Receipt Type"::"Staff Loan";
        FundsTransactionCode.RESET;
        FundsTransactionCode.SETRANGE("Loan Transaction Type",FundsTransactionCode."Loan Transaction Type"::"Staff Loan");
        IF FundsTransactionCode.FINDFIRST THEN
         ReceiptHeader."Account No.":=FundsTransactionCode."Transaction Code";
        ReceiptHeader.VALIDATE("Account No.");
        ReceiptHeader."Amount Received":=EmployeeDeduction.Amount;
        ReceiptHeader.VALIDATE("Amount Received");
        IF Employee.GET(EmployeeDeduction."Employee No.") THEN
         ReceiptHeader."Received From":=Employee."First Name"+' '+Employee."Middle Name"+' '+Employee."Last Name";
        ReceiptHeader.Description:='Loan'+ EmployeeDeduction."Loan No."+ ' repayment';
        ReceiptHeader.INSERT;
        
        //insert lines+1;
        CustomerLedgerEntry.RESET;
        CustomerLedgerEntry.SETRANGE("Customer No.",EmployeeDeduction."Employee No.");
        CustomerLedgerEntry.SETFILTER("Investment Transaction Type",'=%1|%2',2,4);
        CustomerLedgerEntry.SETFILTER(Amount,'>%1',0);
        IF CustomerLedgerEntry.FINDSET THEN BEGIN
          REPEAT
            CustomerLedgerEntry.CALCFIELDS("Remaining Amount");
            CustomerLedgerEntry.SETFILTER("Remaining Amount",'<>%1',0);
            LineNo:=LineNo+1;
            ReceiptLine.INIT;
            ReceiptLine."Line No.":=LineNo;
            ReceiptLine."Document No.":=ReceiptHeader."No.";
            ReceiptLine."Receipt Code":='EMPLOYEE';
            ReceiptLine."Account Type":=ReceiptLine."Account Type"::Customer;
            ReceiptLine."Account No.":=EmployeeDeduction."Employee No.";
            ReceiptLine.VALIDATE("Account No.");
            ReceiptLine.Description:='Loan '+ EmployeeDeduction."Loan No."+ ' repayment';
            ReceiptLine.Amount:=CustomerLedgerEntry."Remaining Amount";
            ReceiptLine.VALIDATE(Amount);
        
            ReceiptLine."Applies-to Doc. No.":=CustomerLedgerEntry."Document No.";
            ReceiptLine."Loan Account No.":=CustomerLedgerEntry."Investment Account No.";
            IF CustomerLedgerEntry."Investment Transaction Type" = CustomerLedgerEntry."Investment Transaction Type"::"Interest Receivable" THEN BEGIN
             ReceiptLine."Loan Transaction Type" := CustomerLedgerEntry."Investment Transaction Type"::"Interest Payment";
             IF EmployeeLoanAccounts.GET(ReceiptLine."Loan Account No.") THEN BEGIN
              IF EmployeeLoanProducts.GET(EmployeeLoanAccounts."Loan Product Code") THEN
               ReceiptLine."Posting Group":=EmployeeLoanProducts."Interest Receivable PG";
             END;
            END;
            IF CustomerLedgerEntry."Investment Transaction Type" = CustomerLedgerEntry."Investment Transaction Type"::"Principal Receivable" THEN BEGIN
              ReceiptLine."Loan Transaction Type" := CustomerLedgerEntry."Investment Transaction Type"::"Principal Payment";
             IF EmployeeLoanAccounts.GET(ReceiptLine."Loan Account No.") THEN BEGIN
              IF EmployeeLoanProducts.GET(EmployeeLoanAccounts."Loan Product Code") THEN
               ReceiptLine."Posting Group":=EmployeeLoanProducts."Principal Receivable PG";
             END;
            END;
            ReceiptLine.INSERT;
          UNTIL CustomerLedgerEntry.NEXT = 0;
        END;
        */

    end;

    procedure PostLoanReceipts(ReceiptHeader: Record 50004; JournalTemplate: Code[20]; JournalBatch: Code[20])
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        FundsTransactionCode: Record 50027;
        ReceiptLine: Record 50005;
        EmployeeLedgerEntry: Record 5222;
        ReceiptHeader2: Record 50004;
    begin
        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JournalTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JournalBatch);
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;

        //add header
        LineNo := LineNo + 1;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := JournalTemplate;
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Journal Batch Name" := JournalBatch;
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
        GenJnlLine."Document No." := ReceiptHeader."No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        IF FundsTransactionCode.GET(ReceiptHeader."Account No.") THEN
            GenJnlLine."Account No." := FundsTransactionCode."Account No.";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine."Currency Code" := '';
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        GenJnlLine.Amount := ReceiptHeader."Amount Received";  //Credit Amount
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
        GenJnlLine.Description := ReceiptHeader.Description;
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;

        ReceiptLine.RESET;
        ReceiptLine.SETRANGE("Document No.", ReceiptHeader."No.");
        IF ReceiptLine.FINDSET THEN BEGIN
            REPEAT
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := JournalTemplate;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := JournalBatch;
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                GenJnlLine."Document No." := ReceiptHeader."No.";
                GenJnlLine."Account Type" := ReceiptLine."Account Type";
                GenJnlLine."Account No." := ReceiptLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine.Amount := -ReceiptLine.Amount;  //credirt Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := ReceiptLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ReceiptLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.Description := ReceiptLine.Description;
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;

            UNTIL ReceiptLine.NEXT = 0;
        END;

        COMMIT;

        //post lines
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", JournalTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", JournalBatch);
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        AdjustGenJnl.RUN(GenJnlLine);

        //Now Post the Journal Lines
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Line", GenJnlLine);

        //end posting
        COMMIT;

        //update posted receipts
        EmployeeLedgerEntry.RESET;
        EmployeeLedgerEntry.SETRANGE("Document No.", ReceiptHeader."No.");
        IF EmployeeLedgerEntry.FINDFIRST THEN BEGIN
            ReceiptHeader2.RESET;
            ReceiptHeader2.SETRANGE("No.", ReceiptHeader."No.");
            IF ReceiptHeader2.FINDFIRST THEN BEGIN
                ReceiptHeader2.Status := ReceiptHeader2.Status::Posted;
                ReceiptHeader2.Posted := TRUE;
                ReceiptHeader2."Posted By" := USERID;
                ReceiptHeader2."Date Posted" := TODAY;
                ReceiptHeader2."Time Posted" := TIME;
                ReceiptHeader2.MODIFY;
            END;
        END;
    end;

    procedure CheckInvestmentReceiptCode(DocumentNumber: Code[30])
    var
        ReceiptLine: Record 50005;
    begin
        /*InvestmentGeneralSetup.GET;
        
        InvestmentGeneralSetup.TESTFIELD(InvestmentGeneralSetup."Appraisal Receipt Code");
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE(ReceiptLine."Document No.",DocumentNumber);
        ReceiptLine.SETRANGE(ReceiptLine."Receipt Code",InvestmentGeneralSetup."Appraisal Receipt Code");
        IF ReceiptLine.FINDSET THEN BEGIN
          REPEAT
            ReceiptLine.TESTFIELD(ReceiptLine."Investment Application No.");
          UNTIL ReceiptLine.NEXT=0;
        END;
        */

    end;

    procedure SuggestInvestmentLoanRepayments("ReceiptNo.": Code[20])
    var
        ReceiptHeader: Record 50004;
        CustomerLedgerEntry: Record 21;
        LineNo: Integer;
        ReceiptLine: Record 50005;
    begin
        /*ReceiptHeader.GET("ReceiptNo.");
        //delete existing lines
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE("Document No.","ReceiptNo.");
        ReceiptLine.DELETEALL;
        
        //insert lines;
        CustomerLedgerEntry.RESET;
        CustomerLedgerEntry.SETRANGE("Customer No.",ReceiptHeader."Client No.");
        CustomerLedgerEntry.SETRANGE("Investment Transaction Type",CustomerLedgerEntry."Investment Transaction Type"::"6");
        CustomerLedgerEntry.SETRANGE(Reversed,FALSE);
        IF CustomerLedgerEntry.FINDSET THEN BEGIN
          REPEAT
            CustomerLedgerEntry.CALCFIELDS("Remaining Amount");
            CustomerLedgerEntry.SETFILTER("Remaining Amount",'<>%1',0);
            ReceiptLine.INIT;
            ReceiptLine."Line No.":=0;
            ReceiptLine."Document No.":=ReceiptHeader."No.";
            ReceiptLine."Receipt Code":='CUSTOMER';
            ReceiptLine."Account Type":=ReceiptLine."Account Type"::Customer;
            ReceiptLine."Account No.":=ReceiptHeader."Client No.";
            ReceiptLine.VALIDATE("Account No.");
            ReceiptLine.Description:='Loan '+ CustomerLedgerEntry."Investment Account No."+ ' repayment';
            ReceiptLine.Amount:=CustomerLedgerEntry."Remaining Amount";
            ReceiptLine.VALIDATE(Amount);
        
            ReceiptLine."Applies-to Doc. No.":=CustomerLedgerEntry."Document No.";
            ReceiptLine."Loan Account No.":=CustomerLedgerEntry."Investment Account No.";
             ReceiptLine."Loan Transaction Type" := CustomerLedgerEntry."Investment Transaction Type"::"7";
             IF LoanAccounts.GET(ReceiptLine."Loan Account No.") THEN BEGIN
              IF InvestmentProducts.GET(LoanAccounts."Product Code") THEN
               ReceiptLine."Posting Group":=InvestmentProducts."Penalty Receivable PG";
             END;
            ReceiptLine.INSERT;
          UNTIL CustomerLedgerEntry.NEXT = 0;
         END;
          CustomerLedgerEntry.RESET;
          CustomerLedgerEntry.SETRANGE("Customer No.",ReceiptHeader."Client No.");
          CustomerLedgerEntry.SETRANGE("Investment Transaction Type",CustomerLedgerEntry."Investment Transaction Type"::"4");
          IF CustomerLedgerEntry.FINDSET THEN BEGIN
          REPEAT
            CustomerLedgerEntry.CALCFIELDS("Remaining Amount");
            CustomerLedgerEntry.SETFILTER("Remaining Amount",'<>%1',0);
            ReceiptLine.INIT;
            ReceiptLine."Line No.":=0;
            ReceiptLine."Document No.":=ReceiptHeader."No.";
            ReceiptLine."Receipt Code":='CUSTOMER';
            ReceiptLine."Account Type":=ReceiptLine."Account Type"::Customer;
            ReceiptLine."Account No.":=ReceiptHeader."Client No.";
            ReceiptLine.VALIDATE("Account No.");
            ReceiptLine.Description:='Loan '+ CustomerLedgerEntry."Investment Account No."+ ' repayment';
            ReceiptLine.Amount:=CustomerLedgerEntry."Remaining Amount";
            ReceiptLine.VALIDATE(Amount);
        
            ReceiptLine."Applies-to Doc. No.":=CustomerLedgerEntry."Document No.";
            ReceiptLine."Loan Account No.":=CustomerLedgerEntry."Investment Account No.";
             ReceiptLine."Loan Transaction Type" := CustomerLedgerEntry."Investment Transaction Type"::"5";
             IF LoanAccounts.GET(ReceiptLine."Loan Account No.") THEN BEGIN
              IF InvestmentProducts.GET(LoanAccounts."Product Code") THEN
               ReceiptLine."Posting Group":=InvestmentProducts."Interest Receivable PG";
             END;
            ReceiptLine.INSERT;
          UNTIL CustomerLedgerEntry.NEXT = 0;
        END;
        
        CustomerLedgerEntry.RESET;
        CustomerLedgerEntry.SETRANGE("Customer No.",ReceiptHeader."Client No.");
        CustomerLedgerEntry.SETRANGE("Investment Transaction Type",CustomerLedgerEntry."Investment Transaction Type"::"2");
        IF CustomerLedgerEntry.FINDSET THEN BEGIN
          REPEAT
            CustomerLedgerEntry.CALCFIELDS("Remaining Amount");
            CustomerLedgerEntry.SETFILTER("Remaining Amount",'<>%1',0);
            ReceiptLine.INIT;
            ReceiptLine."Line No.":=0;
            ReceiptLine."Document No.":=ReceiptHeader."No.";
            ReceiptLine."Receipt Code":='CUSTOMER';
            ReceiptLine."Account Type":=ReceiptLine."Account Type"::Customer;
            ReceiptLine."Account No.":=ReceiptHeader."Client No.";
            ReceiptLine.VALIDATE("Account No.");
            ReceiptLine.Description:='Loan '+ CustomerLedgerEntry."Investment Account No."+ ' repayment';
            ReceiptLine.Amount:=CustomerLedgerEntry."Remaining Amount";
            ReceiptLine.VALIDATE(Amount);
        
            ReceiptLine."Applies-to Doc. No.":=CustomerLedgerEntry."Document No.";
            ReceiptLine."Loan Account No.":=CustomerLedgerEntry."Investment Account No.";
             ReceiptLine."Loan Transaction Type" := CustomerLedgerEntry."Investment Transaction Type"::"3";
             IF LoanAccounts.GET(ReceiptLine."Loan Account No.") THEN BEGIN
              IF InvestmentProducts.GET(LoanAccounts."Product Code") THEN
               ReceiptLine."Posting Group":=InvestmentProducts."Principal Receivable PG";
             END;
            ReceiptLine.INSERT;
          UNTIL CustomerLedgerEntry.NEXT=0;
        END;
        */

    end;

    procedure MarkImprestAsPosted(PaymentNumber: Code[30]; PostingDate: Date)
    var
        ImprestHeader: Record 50008;
        PaymentLine: Record 50003;
    begin
        PaymentLine.RESET;
        PaymentLine.SETRANGE(PaymentLine."Document No.", PaymentNumber);
        IF PaymentLine.FINDSET THEN BEGIN
            REPEAT
                ImprestHeader.RESET;
                ImprestHeader.SETRANGE(ImprestHeader."No.", PaymentLine."Payee No.");
                IF ImprestHeader.FINDFIRST THEN BEGIN
                    ImprestHeader.Status := ImprestHeader.Status::Posted;
                    ImprestHeader.Posted := TRUE;
                    ImprestHeader."Posted By" := USERID;
                    ImprestHeader."Posting Date" := PostingDate;
                    ImprestHeader.MODIFY;
                END;
            UNTIL PaymentLine.NEXT = 0;
        END;
    end;

    procedure CreateApplicationDocuments("ReceiptNo.": Code[20]; LoanAccountNo: Code[20]; CustomerNo: Code[20])
    var
        ReceiptHeader: Record 50004;
        ReceiptLine: Record 50005;
    begin
        /*LoanAccounts.RESET;
        LoanAccounts.SETRANGE("Customer No.",CustomerNo);
        LoanAccounts.SETRANGE("No.",LoanAccountNo);
        IF LoanAccounts.FINDSET THEN BEGIN
          REPEAT
            LoanAccounts.SETCURRENTKEY("Date Created");
            CreateLoanAccountApplication(LoanAccounts."No.","ReceiptNo.",CustomerNo);
          UNTIL LoanAccounts.NEXT =0;
        END;*/

    end;

    procedure CreateLoanAccountApplication("LoanAccountNo.": Code[20]; "ReceiptNo.": Code[20]; CustomerNo: Code[20])
    var
        CustLedgerEntry: Record 21;
        ReceiptHeader: Record 50004;
        ReceiptLine: Record 50005;
        TotalDueAmounts: Decimal;
        AmountApplied: Decimal;
        RemainingAppliedAmount: Decimal;
        AmountApplied2: Decimal;
        CustLedgerEntry2: Record 21;
        PenaltyReceivable: Decimal;
        InterestReceivable: Decimal;
        PrincipalReceivable: Decimal;
    begin
        /*//get total amount
        ReceiptHeader.GET("ReceiptNo.");
        //ReceiptLine.GET("ReceiptNo.");
        FundsGeneralSetup.GET;
        FundsGeneralSetup.TESTFIELD("Loan Receipt Nos.");
        
        TotalDueAmounts:=0;
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.",CustomerNo);
        CustLedgerEntry.SETRANGE("Investment Account No.","LoanAccountNo.");
        CustLedgerEntry.SETRANGE("Due Date",0D,ReceiptHeader."Posting Date");
        IF CustLedgerEntry.FINDSET THEN BEGIN
          REPEAT
            CustLedgerEntry.CALCFIELDS("Remaining Amount");
            TotalDueAmounts:=TotalDueAmounts+CustLedgerEntry."Remaining Amount";
          UNTIL CustLedgerEntry.NEXT =0;
        END;
        
        IF TotalDueAmounts < ReceiptHeader."Amount Received" THEN BEGIN
          //create document header
          AccountApplicationHeader.INIT;
          AccountApplicationHeader."No.":=NoSeriesManagement.GetNextNo(FundsGeneralSetup."Loan Receipt Nos.",0D,TRUE);
          AccountApplicationHeader."Document Date":=TODAY;
          AccountApplicationHeader."Posting Date":=ReceiptHeader."Posting Date";
          AccountApplicationHeader."Customer No.":=ReceiptLine."Account No.";
          AccountApplicationHeader."Customer Name":=ReceiptLine."Account Name";
          AccountApplicationHeader."Account Type":=AccountApplicationHeader."Account Type"::"1";
          AccountApplicationHeader."Account No.":="LoanAccountNo.";
          AccountApplicationHeader."Currency Code":=ReceiptHeader."Currency Code";
          AccountApplicationHeader."Created By":=USERID;
          AccountApplicationHeader."Date Created":=TODAY;
          AccountApplicationHeader."Time Created":=TIME;
          AccountApplicationHeader."User ID":=USERID;
          AccountApplicationHeader.INSERT;
        
          //create document lines
          CustLedgerEntry.RESET;
          CustLedgerEntry.SETRANGE("Customer No.",CustomerNo);
          CustLedgerEntry.SETRANGE("Investment Account No.","LoanAccountNo.");
          CustLedgerEntry.SETRANGE("Due Date",0D,ReceiptHeader."Posting Date");
          IF CustLedgerEntry.FINDSET THEN BEGIN
            REPEAT
              AccountApplicationLine.INIT;
              AccountApplicationLine."Line No.":=0;
              AccountApplicationLine."Document No.":=AccountApplicationHeader."No.";
              AccountApplicationLine."Posting Date":=ReceiptHeader."Posting Date";
              AccountApplicationLine."Account Type":=AccountApplicationLine."Account Type"::"2";
              AccountApplicationLine."Account No.":="LoanAccountNo.";
              AccountApplicationLine."Receipt No.":=ReceiptHeader."No.";
              AccountApplicationLine."Customer No.":=ReceiptLine."Account No.";
              AccountApplicationLine."Customer Name":=ReceiptLine."Account Name";
        
              //Interest
              IF CustLedgerEntry."Investment Transaction Type" = CustLedgerEntry."Investment Transaction Type"::"4" THEN BEGIN
               AccountApplicationLine."Transaction Type" := AccountApplicationLine."Transaction Type"::"2";
               IF LoanAccounts.GET(AccountApplicationLine."Account No.") THEN BEGIN
                IF InvestmentProducts.GET(LoanAccounts."Product Code") THEN
                 AccountApplicationLine."Posting Group":=InvestmentProducts."Interest Receivable PG";
                 AccountApplicationLine."Applied Amount":=CustLedgerEntry."Remaining Amount";
               END;
              END;
              //principal
              IF CustLedgerEntry."Investment Transaction Type" = CustLedgerEntry."Investment Transaction Type"::"2" THEN BEGIN
                AccountApplicationLine."Transaction Type" := AccountApplicationLine."Transaction Type"::"1";
               IF LoanAccounts.GET(AccountApplicationLine."Account No.") THEN BEGIN
                IF InvestmentProducts.GET(LoanAccounts."Product Code") THEN
                 AccountApplicationLine."Posting Group":=InvestmentProducts."Principal Receivable PG";
                 AccountApplicationLine."Applied Amount":=CustLedgerEntry."Remaining Amount";
               END;
              END;
              //penalty
              IF CustLedgerEntry."Investment Transaction Type" = CustLedgerEntry."Investment Transaction Type"::"6" THEN BEGIN
                AccountApplicationLine."Transaction Type" := AccountApplicationLine."Transaction Type"::"3";
               IF LoanAccounts.GET(AccountApplicationLine."Account No.") THEN BEGIN
                IF InvestmentProducts.GET(LoanAccounts."Product Code") THEN
                 AccountApplicationLine."Posting Group":=InvestmentProducts."Penalty Receivable PG";
                 AccountApplicationLine."Applied Amount":=CustLedgerEntry."Remaining Amount";
               END;
              END;
              AccountApplicationLine.INSERT;
            UNTIL CustLedgerEntry.NEXT =0;
          END;
        
        END ELSE BEGIN
         //create document header
          AccountApplicationHeader.INIT;
          AccountApplicationHeader."No.":=NoSeriesManagement.GetNextNo(FundsGeneralSetup."Loan Receipt Nos.",0D,TRUE);
          AccountApplicationHeader."Document Date":=TODAY;
          AccountApplicationHeader."Posting Date":=ReceiptHeader."Posting Date";
          AccountApplicationHeader."Customer No.":=ReceiptLine."Account No.";
          AccountApplicationHeader."Customer Name":=ReceiptLine."Account Name";
          AccountApplicationHeader."Account Type":=AccountApplicationHeader."Account Type"::"1";
          AccountApplicationHeader."Account No.":="LoanAccountNo.";
          AccountApplicationHeader."Currency Code":=ReceiptHeader."Currency Code";
          AccountApplicationHeader."Created By":=USERID;
          AccountApplicationHeader."Date Created":=TODAY;
          AccountApplicationHeader."Time Created":=TIME;
          AccountApplicationHeader."User ID":=USERID;
          AccountApplicationHeader.INSERT;
        
          AmountApplied:=0;
          RemainingAppliedAmount:=0;
          AmountApplied2:=0;
          //create document lines
          CustLedgerEntry.RESET;
          CustLedgerEntry.SETRANGE("Customer No.",CustomerNo);
          CustLedgerEntry.SETRANGE("Investment Account No.","LoanAccountNo.");
          CustLedgerEntry.SETRANGE("Due Date",0D,ReceiptHeader."Posting Date");
          IF CustLedgerEntry.FINDSET THEN BEGIN
            REPEAT
              AccountApplicationLine.INIT;
              AccountApplicationLine."Line No.":=0;
              AccountApplicationLine."Document No.":=AccountApplicationHeader."No.";
              AccountApplicationLine."Posting Date":=ReceiptHeader."Posting Date";
              AccountApplicationLine."Account Type":=AccountApplicationLine."Account Type"::"2";
              AccountApplicationLine."Account No.":="LoanAccountNo.";
              AccountApplicationLine."Receipt No.":=ReceiptHeader."No.";
              AccountApplicationLine."Customer No.":=ReceiptLine."Account No.";
              AccountApplicationLine."Customer Name":=ReceiptLine."Account Name";
        
              //penalty
              PenaltyReceivable:=0;
              CustLedgerEntry2.RESET;
              CustLedgerEntry2.SETRANGE("Customer No.",CustomerNo);
              CustLedgerEntry2.SETRANGE("Investment Account No.","LoanAccountNo.");
              CustLedgerEntry2.SETRANGE("Due Date",0D,ReceiptHeader."Posting Date");
              CustLedgerEntry2.SETRANGE("Investment Transaction Type",CustLedgerEntry2."Investment Transaction Type"::"6");
              IF CustLedgerEntry2.FINDSET THEN BEGIN
               REPEAT
                 CustLedgerEntry2.CALCFIELDS(CustLedgerEntry2."Remaining Amount");
                 PenaltyReceivable:=PenaltyReceivable+CustLedgerEntry2."Remaining Amount";
        
                 AccountApplicationLine."Transaction Type" := AccountApplicationLine."Transaction Type"::"3";
                 IF LoanAccounts.GET(AccountApplicationLine."Account No.") THEN BEGIN
                  IF InvestmentProducts.GET(LoanAccounts."Product Code") THEN
                   AccountApplicationLine."Posting Group":=InvestmentProducts."Penalty Receivable PG";
        
                  IF PenaltyReceivable < ReceiptHeader."Amount Received" THEN
                   AccountApplicationLine."Applied Amount":=PenaltyReceivable
                  ELSE
                   AccountApplicationLine."Applied Amount":=ReceiptHeader."Amount Received";
                 END;
                 AmountApplied:=AmountApplied+AccountApplicationLine."Applied Amount";
                 UNTIL CustLedgerEntry2.NEXT=0;
               END;
        
              //Interest
              IF AmountApplied < ReceiptHeader."Amount Received" THEN BEGIN
                InterestReceivable:=0;
                CustLedgerEntry2.RESET;
                CustLedgerEntry2.SETRANGE("Customer No.",CustomerNo);
                CustLedgerEntry2.SETRANGE("Investment Account No.","LoanAccountNo.");
                CustLedgerEntry2.SETRANGE("Due Date",0D,ReceiptHeader."Posting Date");
                CustLedgerEntry2.SETRANGE("Investment Transaction Type",CustLedgerEntry2."Investment Transaction Type"::"4");
                IF CustLedgerEntry2.FINDSET THEN BEGIN
                 REPEAT
                   CustLedgerEntry2.CALCFIELDS(CustLedgerEntry2."Remaining Amount");
                   InterestReceivable:=InterestReceivable+CustLedgerEntry2."Remaining Amount";
        
                   AccountApplicationLine."Transaction Type" := AccountApplicationLine."Transaction Type"::"2";
                   IF LoanAccounts.GET(AccountApplicationLine."Account No.") THEN BEGIN
                    IF InvestmentProducts.GET(LoanAccounts."Product Code") THEN
                     AccountApplicationLine."Posting Group":=InvestmentProducts."Interest Receivable PG";
        
                    IF InterestReceivable < ReceiptHeader."Amount Received" THEN
                     AccountApplicationLine."Applied Amount":=InterestReceivable
                    ELSE
                     AccountApplicationLine."Applied Amount":=ReceiptHeader."Amount Received";
                   END;
                   AmountApplied2:=AmountApplied2+AmountApplied+AccountApplicationLine."Applied Amount";
                   UNTIL CustLedgerEntry2.NEXT=0;
                 END;
                END;
        
              //principal
              IF AmountApplied2 < ReceiptHeader."Amount Received" THEN BEGIN
                PrincipalReceivable:=0;
                CustLedgerEntry2.RESET;
                CustLedgerEntry2.SETRANGE("Customer No.",CustomerNo);
                CustLedgerEntry2.SETRANGE("Investment Account No.","LoanAccountNo.");
                CustLedgerEntry2.SETRANGE("Due Date",0D,ReceiptHeader."Posting Date");
                CustLedgerEntry2.SETRANGE("Investment Transaction Type",CustLedgerEntry2."Investment Transaction Type"::"2");
                IF CustLedgerEntry2.FINDSET THEN BEGIN
                 REPEAT
                   CustLedgerEntry2.CALCFIELDS(CustLedgerEntry2."Remaining Amount");
                   InterestReceivable:=InterestReceivable+CustLedgerEntry2."Remaining Amount";
        
                   AccountApplicationLine."Transaction Type" := AccountApplicationLine."Transaction Type"::"1";
                   IF LoanAccounts.GET(AccountApplicationLine."Account No.") THEN BEGIN
                    IF InvestmentProducts.GET(LoanAccounts."Product Code") THEN
                     AccountApplicationLine."Posting Group":=InvestmentProducts."Principal Receivable PG";
        
                    IF PrincipalReceivable < ReceiptHeader."Amount Received" THEN
                     AccountApplicationLine."Applied Amount":=PrincipalReceivable
                    ELSE
                     AccountApplicationLine."Applied Amount":=ReceiptHeader."Amount Received";
                   END;
                   UNTIL CustLedgerEntry2.NEXT=0;
                 END;
                END;
              AccountApplicationLine.INSERT;
            UNTIL CustLedgerEntry.NEXT =0;
          END;
        END;
        */

    end;

    procedure PostJournalVoucher("Journal Voucher": Record 50016; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        JournalVoucherLines: Record 50017;
        JournalVoucherHeader: Record 50016;
        SourceCode: Code[20];
        JournalVoucherLines2: Record 50017;
        JournalVoucherHeader2: Record 50016;
        GLEntry: Record 17;
    begin
        JournalVoucherHeader.TRANSFERFIELDS("Journal Voucher", TRUE);



        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete


        //***********************************************Add Receipt Lines**************************************************************//
        JournalVoucherLines.RESET;
        JournalVoucherLines.SETRANGE(JournalVoucherLines."JV No.", JournalVoucherHeader."JV No.");
        JournalVoucherLines.SETFILTER(JournalVoucherLines.Amount, '<>%1', 0);
        IF JournalVoucherLines.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Amounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := JournalVoucherHeader."Posting Date";
                GenJnlLine."Document No." := JournalVoucherLines."JV No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Account Type" := JournalVoucherLines."Account Type";
                GenJnlLine."Account No." := JournalVoucherLines."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Posting Group" := JournalVoucherLines."Posting Group";
                GenJnlLine."External Document No." := JournalVoucherLines."External Document No.";
                GenJnlLine."Currency Code" := JournalVoucherLines."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := -(JournalVoucherLines.Amount);  //Credit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := JournalVoucherLines."Bal. Account Type";
                GenJnlLine."Bal. Account No." := JournalVoucherLines."Bal. Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                IF JournalVoucherLines."Account Type" = JournalVoucherLines."Account Type"::"Fixed Asset" THEN BEGIN
                    GenJnlLine."FA Posting Date" := JournalVoucherLines."FA Posting Date";
                    GenJnlLine."FA Posting Type" := JournalVoucherLines."FA Posting Type";
                    GenJnlLine."Depreciation Book Code" := JournalVoucherLines."Depreciation Book Code";
                END;
                GenJnlLine."Shortcut Dimension 1 Code" := JournalVoucherLines."Shortcut Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := JournalVoucherLines."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, JournalVoucherLines."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, JournalVoucherLines."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, JournalVoucherLines."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, JournalVoucherLines."Shortcut Dimension 6 Code");
                GenJnlLine.ValidateShortcutDimCode(7, JournalVoucherLines."Shortcut Dimension 7 Code");
                GenJnlLine.ValidateShortcutDimCode(8, JournalVoucherLines."Shortcut Dimension 8 Code");
                GenJnlLine.Description := COPYSTR(JournalVoucherLines.Description, 1, 100);
                GenJnlLine.Description2 := COPYSTR(JournalVoucherHeader.Description, 1, 100);
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            //*************************************End add Line NetAmounts**********************************************************//

            UNTIL JournalVoucherLines.NEXT = 0;
        END;

        COMMIT;

        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", JournalVoucherHeader."JV No.");
            IF GLEntry.FINDFIRST THEN BEGIN
                JournalVoucherHeader2.RESET;
                JournalVoucherHeader2.SETRANGE(JournalVoucherHeader2."JV No.", JournalVoucherHeader."JV No.");
                IF JournalVoucherHeader2.FINDFIRST THEN BEGIN
                    JournalVoucherHeader2.Posted := TRUE;
                    JournalVoucherHeader2."Posted By" := USERID;
                    JournalVoucherHeader2."Time Posted" := TIME;
                    JournalVoucherHeader2.Status := JournalVoucherHeader2.Status::Approved;
                    JournalVoucherHeader2.MODIFY;
                    JournalVoucherLines2.RESET;
                    JournalVoucherLines2.SETRANGE(JournalVoucherLines2."Document No.", JournalVoucherHeader2."JV No.");
                    IF JournalVoucherLines2.FINDSET THEN BEGIN
                        REPEAT
                            JournalVoucherLines2.Posted := TRUE;
                            JournalVoucherLines2."Posted By" := USERID;
                            JournalVoucherLines2."Date Posted" := TODAY;
                            JournalVoucherLines2."Time Posted" := TIME;
                            JournalVoucherLines2.MODIFY;
                        UNTIL JournalVoucherLines2.NEXT = 0;
                    END;
                END;
            END;
            COMMIT;
            //***********************************************End Update Document************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;
    end;

    procedure CheckJournalVoucherMandatoryFields("Journal Voucher": Record 50016; Posting: Boolean)
    var
        JournalVoucherHeader: Record 50016;
        JournalVoucherLines: Record 50017;
        EmptyJournalVoucherLines: Label 'You cannot Post the journal with empty Line';
        "G/LAccount": Record 15;
    begin
        JournalVoucherHeader.TRANSFERFIELDS("Journal Voucher", TRUE);
        JournalVoucherHeader.TESTFIELD("Posting Date");
        JournalVoucherHeader.TESTFIELD(Description);

        IF Posting THEN
            JournalVoucherHeader.TESTFIELD(Status, JournalVoucherHeader.Status::Approved);

        //Check Lines
        JournalVoucherLines.RESET;
        JournalVoucherLines.SETRANGE("JV No.", JournalVoucherHeader."JV No.");
        IF JournalVoucherLines.FINDSET THEN BEGIN
            REPEAT
                JournalVoucherLines.TESTFIELD("Account No.");
                JournalVoucherLines.TESTFIELD(Amount);
                JournalVoucherLines.TESTFIELD(Description);
            UNTIL JournalVoucherLines.NEXT = 0;
        END ELSE BEGIN
            ERROR(EmptyJournalVoucherLines);
        END;
    end;

    procedure GetEmployeeuserID(EmployeeNo: Code[30]) UserCode: Code[20]
    var
        UserSetup: Record 91;
    begin
        UserSetup.RESET;
        //UserSetup.SETRANGE("Employee No", EmployeeNo);
        IF UserSetup.FINDFIRST THEN
            EXIT(UserSetup."User ID")
        ELSE
            ERROR('User has not been setup In Nav');
    end;

    procedure PostBoardAllowance("Imprest Header": Record 50008; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        ImprestLine: Record 50009;
        ImprestHeader: Record 50008;
        SourceCode: Code[20];
        BankLedgers: Record 271;
        ImprestLine2: Record 50009;
        ImprestHeader2: Record 50008;
        DocumentExist: Label 'Imprest document is already posted. "Document No.":%1  already exists in Bank No:%2';
        FundsTransactionCodes: Record 50027;
        FundsTaxCode: Record 50028;
    begin
        ImprestHeader.TRANSFERFIELDS("Imprest Header", TRUE);
        SourceCode := IMPJNL;
        ImprestHeader.TESTFIELD(Status, ImprestHeader.Status::Approved);

        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        LineNo := 1000;
        //********************************************Add Imprest Header*******************************************************//
        ImprestHeader.CALCFIELDS(ImprestHeader.Amount, ImprestHeader."Amount(LCY)");
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := ImprestHeader."Posting Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := ImprestHeader."No.";
        GenJnlLine."External Document No." := ImprestHeader."Reference No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
        GenJnlLine."Account No." := ImprestHeader."Employee No.";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine."Posting Group" := ImprestHeader."Employee Posting Group";
        GenJnlLine.VALIDATE("Posting Group");
        GenJnlLine."Currency Code" := ImprestHeader."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        GenJnlLine.Amount := -(ImprestHeader.Amount);  //Debit Amount
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ImprestHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, ImprestHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, ImprestHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, ImprestHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, ImprestHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,ImprestHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,ImprestHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := UPPERCASE(COPYSTR(ImprestHeader.Description, 1, 100));
        GenJnlLine.Description2 := UPPERCASE(COPYSTR(ImprestHeader."Employee Name", 1, 100));
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;

        LineNo := LineNo + 1;
        //**********************************Add Surrender Lines***********************************************************************//
        ImprestLine.RESET;
        ImprestLine.SETRANGE(ImprestLine."Document No.", ImprestHeader."No.");

        IF ImprestLine.FINDSET THEN BEGIN
            REPEAT
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := ImprestHeader."Posting Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::"Imprest Surrender";
                GenJnlLine."Document No." := ImprestLine."Document No.";
                GenJnlLine."Account Type" := ImprestLine."Account Type";
                GenJnlLine."Account No." := ImprestLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                IF ImprestLine."Account Type" <> ImprestLine."Account Type"::"G/L Account" THEN BEGIN
                    GenJnlLine."Posting Group" := ImprestLine."Posting Group";
                    GenJnlLine.VALIDATE("Posting Group");
                END;
                GenJnlLine."Currency Code" := ImprestHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := ImprestLine."Net Amount";  //Debit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := ImprestLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ImprestLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, ImprestLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, ImprestLine."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, ImprestLine."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, ImprestLine."Shortcut Dimension 6 Code");
                //GenJnlLine.ValidateShortcutDimCode(7,ImprestLine."Shortcut Dimension 7 Code");
                // GenJnlLine.ValidateShortcutDimCode(8,ImprestLine."Shortcut Dimension 8 Code");
                GenJnlLine.Description := COPYSTR(ImprestLine.Description, 1, 100);
                GenJnlLine.Description2 := COPYSTR(ImprestHeader."Employee Name", 1, 100);
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                IF ImprestLine."Account Type" = ImprestLine."Account Type"::"Fixed Asset" THEN BEGIN
                    GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost";
                    GenJnlLine."FA Posting Date" := ImprestHeader."Posting Date";
                    GenJnlLine."Depreciation Book Code" := ImprestLine."FA Depreciation Book";
                    GenJnlLine.VALIDATE(GenJnlLine."Depreciation Book Code");
                    GenJnlLine."FA Add.-Currency Factor" := 0;
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                END;
                GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;

                //TAX
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := ImprestHeader."Posting Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::"Imprest Surrender";
                GenJnlLine."Document No." := ImprestLine."Document No.";
                GenJnlLine."Account Type" := ImprestLine."Account Type";
                GenJnlLine."Account No." := ImprestLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                IF ImprestLine."Account Type" <> ImprestLine."Account Type"::"G/L Account" THEN BEGIN
                    GenJnlLine."Posting Group" := ImprestLine."Posting Group";
                    GenJnlLine.VALIDATE("Posting Group");
                END;
                GenJnlLine."Currency Code" := ImprestHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := ImprestLine."Tax Amount";  //Debit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                FundsTransactionCodes.RESET;
                FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code", ImprestLine."Imprest Code");
                FundsTransactionCodes.FINDFIRST;
                IF FundsTransactionCodes."Include Withholding Tax" THEN BEGIN
                    FundsTransactionCodes.TESTFIELD("Withholding Tax Code");
                    FundsTaxCode.GET(FundsTransactionCodes."Withholding Tax Code");

                    FundsTaxCode.TESTFIELD("Account No.");

                END;


                GenJnlLine."Bal. Account No." := FundsTaxCode."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := ImprestLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ImprestLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, ImprestLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, ImprestLine."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, ImprestLine."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, ImprestLine."Shortcut Dimension 6 Code");
                //GenJnlLine.ValidateShortcutDimCode(7,ImprestLine."Shortcut Dimension 7 Code");
                // GenJnlLine.ValidateShortcutDimCode(8,ImprestLine."Shortcut Dimension 8 Code");
                GenJnlLine.Description := COPYSTR(ImprestLine.Description + '-Board Tax', 1, 100);
                GenJnlLine.Description2 := COPYSTR(ImprestHeader."Employee Name" + '-Board Tax', 1, 100);
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                IF ImprestLine."Account Type" = ImprestLine."Account Type"::"Fixed Asset" THEN BEGIN
                    GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost";
                    GenJnlLine."FA Posting Date" := ImprestHeader."Posting Date";
                    GenJnlLine."Depreciation Book Code" := ImprestLine."FA Depreciation Book";
                    GenJnlLine.VALIDATE(GenJnlLine."Depreciation Book Code");
                    GenJnlLine."FA Add.-Currency Factor" := 0;
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                END;
                GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;




            UNTIL ImprestLine.NEXT = 0;
        END;
        //**********************************End Add Surrender Lines*********************************************************************//

        // END  LINES
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//

        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            ImprestHeader2.RESET;
            ImprestHeader2.SETRANGE(ImprestHeader2."No.", ImprestHeader."No.");
            IF ImprestHeader2.FINDFIRST THEN BEGIN
                ImprestHeader2.Status := ImprestHeader2.Status::Posted;
                ImprestHeader2.Surrendered := TRUE;
                /*ImprestHeader2."Posted By":=USERID;
                ImprestHeader2."Date Posted":=TODAY;
                ImprestHeader2."Time Posted":=TIME;*/
                ImprestHeader2.MODIFY;

            END;
            //**********************************************End Update Document***************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;

    end;

    procedure ReverseReceipt("Receipt Header": Record 50004; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        ReceiptLine: Record 50005;
        ReceiptHeader: Record 50004;
        SourceCode: Code[20];
        BankLedgers: Record 271;
        ReceiptLine2: Record 50005;
        ReceiptHeader2: Record 50004;
        DocumentExist: Label 'Receipt is already posted, "Document No.":%1 already exists in Bank No:%2';
        GLEntry: Record 17;
    begin
        ReceiptHeader.TRANSFERFIELDS("Receipt Header", TRUE);
        SourceCode := RECEIPTJNL;
        /*
        BankLedgers.RESET;
        BankLedgers.SETRANGE(BankLedgers."Document No.",ReceiptHeader."No.");
        IF BankLedgers.FINDFIRST THEN BEGIN
          ERROR(DocumentExist,ReceiptHeader."No.",ReceiptHeader."Account No.");
        END;
        */
        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        //End Delete

        //***************************************************Add to Bank***************************************************************//
        ReceiptHeader.CALCFIELDS("Line Amount", "Line Amount(LCY)");
        LineNo := 1000;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := "Journal Template";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name" := "Journal Batch";
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
        GenJnlLine."Document No." := ReceiptHeader."No.";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
        IF ReceiptHeader."Receipt Types" = ReceiptHeader."Receipt Types"::Bank THEN BEGIN
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
            GenJnlLine."Account No." := ReceiptHeader."Account No.";
        END ELSE BEGIN
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            IF FundsTransactionCode.GET(ReceiptHeader."Account No.") THEN
                GenJnlLine."Account No." := FundsTransactionCode."Account No.";
        END;
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        GenJnlLine.Amount := -ReceiptHeader."Line Amount";  //Debit Amount
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := '';
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
        //GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
        //GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
        GenJnlLine.Description := COPYSTR(ReceiptHeader.Description + '-Reversal', 1, 249);
        GenJnlLine.Description2 := UPPERCASE(COPYSTR("Receipt Header"."Received From", 1, 249));
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        IF GenJnlLine.Amount <> 0 THEN
            GenJnlLine.INSERT;
        //************************************************End Add to Bank***************************************************************//
        //***********************************************Add Receipt Lines**************************************************************//
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE(ReceiptLine."Document No.", ReceiptHeader."No.");
        ReceiptLine.SETFILTER(ReceiptLine.Amount, '<>%1', 0);
        IF ReceiptLine.FINDSET THEN BEGIN
            REPEAT
                //****************************************Add Line NetAmounts***********************************************************//
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                GenJnlLine."Document No." := ReceiptLine."Document No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Account Type" := ReceiptLine."Account Type";
                GenJnlLine."Account No." := ReceiptLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine."Posting Group" := ReceiptLine."Posting Group";
                GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
                GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := (ReceiptLine.Amount);  //Credit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '';
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                // IF ReceiptLine."Posting Group" <> '' THEN BEGIN
                GenJnlLine."Investment Transaction Type" := ReceiptLine."Loan Transaction Type";
                GenJnlLine."Investment Account No." := ReceiptLine."Loan Account No.";
                GenJnlLine."Customer No." := ReceiptLine."Account No.";
                //  END;
                GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                GenJnlLine.ValidateShortcutDimCode(7, ReceiptHeader."Shortcut Dimension 7 Code");
                GenJnlLine.ValidateShortcutDimCode(8, ReceiptHeader."Shortcut Dimension 8 Code");
                GenJnlLine.Description := COPYSTR(ReceiptHeader.Description + '-Reversal', 1, 249);
                GenJnlLine.Description2 := UPPERCASE(COPYSTR("Receipt Header"."Received From", 1, 249));
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                IF ReceiptLine."Loan Account No." <> '' THEN BEGIN
                    GenJnlLine."Applies-to ID" := '';
                    GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                END ELSE BEGIN
                    GenJnlLine."Applies-to ID" := ReceiptLine."Applies-to ID";
                    GenJnlLine."Applies-to Doc. No." := ReceiptLine."Applies-to Doc. No.";
                END;
                GenJnlLine."Employee Transaction Type" := ReceiptLine."Employee Transaction Type";
                GenJnlLine."Investment Application No." := ReceiptLine."Investment Application No.";
                // GenJnlLine."Loan Account No.":=ReceiptLine."Investment Account No.";
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
                //*************************************End add Line NetAmounts**********************************************************//
                //****************************************Add VAT Amounts***************************************************************//
                IF ReceiptLine."VAT Code" <> '' THEN BEGIN
                    TaxCodes.RESET;
                    TaxCodes.SETRANGE(TaxCodes."Tax Code", ReceiptLine."VAT Code");
                    IF TaxCodes.FINDFIRST THEN BEGIN
                        TaxCodes.TESTFIELD(TaxCodes."Account No.");
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        GenJnlLine."Document No." := ReceiptLine."Document No.";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                        GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
                        GenJnlLine."Account Type" := TaxCodes."Account Type";
                        GenJnlLine."Account No." := TaxCodes."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
                        GenJnlLine."VAT Bus. Posting Group" := '';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
                        GenJnlLine."VAT Prod. Posting Group" := '';
                        GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine.Amount := (ReceiptLine."VAT Amount");   //Credit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        //  GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        //  GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := COPYSTR('VAT:-Reversal' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"), 1, 249);
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR("Receipt Header"."Received From", 1, 50));
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        //VAT Balancing goes to Vendor
                        LineNo := LineNo + 1;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := "Journal Template";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Source Code" := SourceCode;
                        GenJnlLine."Posting Date" := ReceiptHeader."Posting Date";
                        GenJnlLine."Document No." := ReceiptLine."Document No.";
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                        GenJnlLine."External Document No." := ReceiptHeader."Reference No.";
                        GenJnlLine."Account Type" := ReceiptLine."Account Type";
                        GenJnlLine."Account No." := ReceiptLine."Account No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine.Amount := -ReceiptLine."VAT Amount";   //Debit Amount
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3, ReceiptHeader."Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4, ReceiptHeader."Shortcut Dimension 4 Code");
                        GenJnlLine.ValidateShortcutDimCode(5, ReceiptHeader."Shortcut Dimension 5 Code");
                        GenJnlLine.ValidateShortcutDimCode(6, ReceiptHeader."Shortcut Dimension 6 Code");
                        //GenJnlLine.ValidateShortcutDimCode(7,ReceiptHeader."Shortcut Dimension 7 Code");
                        // GenJnlLine.ValidateShortcutDimCode(8,ReceiptHeader."Shortcut Dimension 8 Code");
                        GenJnlLine.Description := COPYSTR('VAT:' + FORMAT(ReceiptLine."Account Type") + '::' + FORMAT(ReceiptLine."Account Name"), 1, 249);
                        GenJnlLine.Description2 := UPPERCASE(COPYSTR("Receipt Header"."Received From", 1, 50));
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                    END;
                END;
            //*************************************End Add VAT Amounts**************************************************************//
            UNTIL ReceiptLine.NEXT = 0;
        END;
        //*********************************************End Add Payment Lines************************************************************//
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//
        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", ReceiptHeader."No.");
            IF GLEntry.FINDFIRST THEN BEGIN
                ReceiptHeader2.RESET;
                ReceiptHeader2.SETRANGE(ReceiptHeader2."No.", ReceiptHeader."No.");
                IF ReceiptHeader2.FINDFIRST THEN BEGIN

                    ReceiptHeader2.Status := ReceiptHeader2.Status::Reversed;
                    ReceiptHeader2.Reversed := TRUE;
                    ReceiptHeader2."Reversed By" := USERID;
                    ReceiptHeader2."Reversal Date" := TODAY;
                    ReceiptHeader2."Reversal Time" := TIME;
                    ReceiptHeader2.MODIFY;
                    ReceiptLine2.RESET;
                    ReceiptLine2.SETRANGE(ReceiptLine2."Document No.", ReceiptHeader2."No.");
                    IF ReceiptLine2.FINDSET THEN BEGIN
                        REPEAT
                            ReceiptLine2.Status := ReceiptLine2.Status::Reversed;
                            ReceiptLine2.Reversed := TRUE;
                            ReceiptLine2."Reversed By" := USERID;
                            ReceiptLine2."Reversal Date" := TODAY;
                            ReceiptLine2."Reversal Time" := TIME;
                            ReceiptLine2.MODIFY;


                        UNTIL ReceiptLine2.NEXT = 0;
                    END;
                END;
            END;
            COMMIT;
            //***********************************************End Update Document************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;

    end;

    procedure PostAllowanceTax("Imprest Header": Record 50008; "Journal Template": Code[20]; "Journal Batch": Code[20]; Preview: Boolean)
    var
        GenJnlLine: Record 81;
        LineNo: Integer;
        ImprestLine: Record 50009;
        ImprestHeader: Record 50008;
        SourceCode: Code[20];
        BankLedgers: Record 271;
        ImprestLine2: Record 50009;
        ImprestHeader2: Record 50008;
        DocumentExist: Label 'Imprest document is already posted. "Document No.":%1  already exists in Bank No:%2';
        FundsTransactionCodes: Record 50027;
        FundsTaxCode: Record 50028;
    begin
        ImprestHeader.TRANSFERFIELDS("Imprest Header", TRUE);
        SourceCode := IMPJNL;


        //Delete Journal Lines if Exist
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        IF GenJnlLine.FINDSET THEN BEGIN
            GenJnlLine.DELETEALL;
        END;

        //**********************************Add Surrender Lines***********************************************************************//
        ImprestLine.RESET;
        ImprestLine.SETRANGE(ImprestLine."Document No.", ImprestHeader."No.");

        IF ImprestLine.FINDSET THEN BEGIN
            REPEAT


                //TAX
                LineNo := LineNo + 1;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := "Journal Template";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
                GenJnlLine."Journal Batch Name" := "Journal Batch";
                GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
                GenJnlLine."Source Code" := SourceCode;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := ImprestHeader."Posting Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::"Imprest Surrender";
                GenJnlLine."Document No." := ImprestLine."Document No.";
                GenJnlLine."Account Type" := ImprestLine."Account Type";
                GenJnlLine."Account No." := ImprestLine."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                IF ImprestLine."Account Type" <> ImprestLine."Account Type"::"G/L Account" THEN BEGIN
                    GenJnlLine."Posting Group" := ImprestLine."Posting Group";
                    GenJnlLine.VALIDATE("Posting Group");
                END;
                GenJnlLine."Currency Code" := ImprestHeader."Currency Code";
                GenJnlLine.VALIDATE("Currency Code");
                GenJnlLine.Amount := ImprestLine."Tax Amount";  //Debit Amount
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                FundsTransactionCodes.RESET;
                FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code", ImprestLine."Imprest Code");
                FundsTransactionCodes.FINDFIRST;
                IF FundsTransactionCodes."Include Withholding Tax" THEN BEGIN
                    FundsTransactionCodes.TESTFIELD("Withholding Tax Code");
                    FundsTaxCode.GET(FundsTransactionCodes."Withholding Tax Code");

                    FundsTaxCode.TESTFIELD("Account No.");

                END;


                GenJnlLine."Bal. Account No." := FundsTaxCode."Account No.";
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := ImprestLine."Global Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := ImprestLine."Global Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, ImprestLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, ImprestLine."Shortcut Dimension 4 Code");
                GenJnlLine.ValidateShortcutDimCode(5, ImprestLine."Shortcut Dimension 5 Code");
                GenJnlLine.ValidateShortcutDimCode(6, ImprestLine."Shortcut Dimension 6 Code");
                //GenJnlLine.ValidateShortcutDimCode(7,ImprestLine."Shortcut Dimension 7 Code");
                // GenJnlLine.ValidateShortcutDimCode(8,ImprestLine."Shortcut Dimension 8 Code");
                GenJnlLine.Description := COPYSTR(ImprestLine.Description + '-PAYE Tax', 1, 100);
                GenJnlLine.Description2 := COPYSTR(ImprestHeader."Employee Name" + '-PAYE Tax', 1, 100);
                GenJnlLine.VALIDATE(GenJnlLine.Description);
                IF ImprestLine."Account Type" = ImprestLine."Account Type"::"Fixed Asset" THEN BEGIN
                    GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost";
                    GenJnlLine."FA Posting Date" := ImprestHeader."Posting Date";
                    GenJnlLine."Depreciation Book Code" := ImprestLine."FA Depreciation Book";
                    GenJnlLine.VALIDATE(GenJnlLine."Depreciation Book Code");
                    GenJnlLine."FA Add.-Currency Factor" := 0;
                    GenJnlLine."Gen. Bus. Posting Group" := '';
                END;
                GenJnlLine."Employee Transaction Type" := GenJnlLine."Employee Transaction Type"::Imprest;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;




            UNTIL ImprestLine.NEXT = 0;
        END;
        //**********************************End Add Surrender Lines*********************************************************************//

        // END  LINES
        COMMIT;
        //********************************************Post the Journal Lines************************************************************//

        //Adjust GenJnlLine Exchange Rate Rounding Balances
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Journal Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Journal Batch");
        AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust GenJnlLine Exchange Rate Rounding Balances
        IF NOT Preview THEN BEGIN
            //Now Post the Journal Lines
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            //***************************************************End Posting****************************************************************//
            COMMIT;
            //*************************************************Update Document**************************************************************//
            ImprestHeader2.RESET;
            ImprestHeader2.SETRANGE(ImprestHeader2."No.", ImprestHeader."No.");
            IF ImprestHeader2.FINDFIRST THEN BEGIN
                ImprestHeader2.Status := ImprestHeader2.Status::Posted;
                ImprestHeader2.Surrendered := TRUE;
                /*ImprestHeader2."Posted By":=USERID;
                ImprestHeader2."Date Posted":=TODAY;
                ImprestHeader2."Time Posted":=TIME;*/
                ImprestHeader2.MODIFY;

            END;
            //**********************************************End Update Document***************************************************************//
        END ELSE BEGIN
            //************************************************Preview Posting***************************************************************//
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", "Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch");
            IF GenJnlLine.FINDSET THEN BEGIN
                GenJnlPost.Preview(GenJnlLine);
            END;
            //**********************************************End Preview Posting*************************************************************//
        END;

    end;
}


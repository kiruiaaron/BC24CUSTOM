/// <summary>
/// Codeunit Payroll Posting (ID 51152).
/// </summary>
codeunit 51152 "Payroll Posting"
{


    trigger OnRun()
    begin
        gvTestPost := STRMENU('Print Test Journal Only,Print and Generate Journals,Generate Journals Without Printing');
        IF gvTestPost = 0 THEN EXIT;

        gvPayrollUtilities.sGetActivePayroll(gvAllowedPayrolls);

        IF gvTestPost > 1 THEN
            IF CONFIRM('Once you generate payroll journals, the payroll month will not be\' +
                     'available for edit.\\' +
                     'Proceed anayway ?') = FALSE THEN
                EXIT;

        IF sGetPeriod THEN BEGIN
            gvPostBuffer.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
            gvPostBuffer.DELETEALL(TRUE);
            gvPostBuffer.RESET;
            IF gvPostBuffer.FINDLAST THEN gvLastBufferNo := gvPostBuffer."Buffer No";

            sInitialInfo;
            sLoopHeader;
            sWriteToGenJnlLines;
            sDeleteEntry;
        END
    end;

    var
        gvPostBuffer: Record 51164;
        gvLastBufferNo: BigInteger;
        gvPostingDate: Date;
        gvWindow: Dialog;
        gvPeriodID: Code[10];
        gvMonth: Integer;
        gvYear: Integer;
        gvBalAccount: Code[20];
        gvBalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account";
        gvEmploPostingGroup: Code[20];
        gvEDPostingGroup: Code[20];
        gvEDAccount: Code[20];
        gvTemplateName: Code[10];
        gvBatchName: Code[10];
        gvEDPostingType: Option "None","G/L Account",Direct,Customer,Vendor;
        gvEDDebitCredit: Option Debit,Credit;
        gvWindowCounter: Integer;
        gvEmpCustNo: Code[10];
        gvEmpRec: Record 5200;
        gvAllowedPayrolls: Record 51182;
        gvPayrollUtilities: Codeunit 51152;
        gvPayrollDims: Record 51184;
        gvTestPost: Integer;
        gvLineNo: Integer;
        "---V.6.1.65---": Integer;
        gvGenJnlLine: Record 81;
        "=TestCalculated=": Integer;
        gvAllowedPayrolls2: Record 51182;
        gvPayrollUtilities2: Codeunit 51152;
        "=PayrollUtilities": Integer;
        LoginMgmt: Codeunit 418;
        DimMgt: Codeunit DimensionManagement;

    procedure sGetPeriod(): Boolean
    var
        lvPayrollPeriod: Record 51151;
        lvHeader: Record 51159;
    begin
        //This function gets the first period which is "Open" and tests if the next period is open      *

        lvPayrollPeriod.SETCURRENTKEY("Start Date");
        lvPayrollPeriod.SETRANGE(Status, 1);
        lvPayrollPeriod.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

        IF lvPayrollPeriod.FIND('-') THEN BEGIN
            gvPeriodID := lvPayrollPeriod."Period ID";
            gvMonth := lvPayrollPeriod."Period Month";
            gvYear := lvPayrollPeriod."Period Year";
            gvPostingDate := lvPayrollPeriod."Posting Date";
        END ELSE
            ERROR('There are no periods to be Posted');

        IF gvTestPost > 1 THEN BEGIN
            IF CONFIRM('Do you really want to generate entries\for the period %1', FALSE, gvPeriodID) THEN BEGIN
                IF NOT lvPayrollPeriod.FIND('>') THEN ERROR('The next period must be open to post this period');
                lvPayrollPeriod.GET(gvPeriodID, gvMonth, gvYear, gvAllowedPayrolls."Payroll Code");
                lvPayrollPeriod.Status := lvPayrollPeriod.Status::Posted;
                lvPayrollPeriod.MODIFY;

                gvWindow.OPEN('Creating Total           #1######\' +
                              'Posting to G/L Journal   #2######\' +
                              'Moving Payroll Header    #3######\' +
                              'Moving Payroll Lines     #4######');

                lvHeader.SETRANGE("Payroll ID", gvPeriodID);
                lvHeader.SETRANGE(Calculated, FALSE);
                lvHeader.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                IF lvHeader.FIND('-') THEN ERROR('Not all Payroll entries are calculated!\Calculate them before posting.');
                EXIT(TRUE);
            END ELSE
                EXIT(FALSE);
        END ELSE BEGIN
            IF NOT lvPayrollPeriod.FIND('>') THEN ERROR('The next period must be open to post this period');
            lvPayrollPeriod.GET(gvPeriodID, gvMonth, gvYear, gvAllowedPayrolls."Payroll Code");
            lvPayrollPeriod.Status := lvPayrollPeriod.Status::Posted;
            lvPayrollPeriod.MODIFY;

            gvWindow.OPEN('Creating Total           #1######\' +
                          'Posting to G/L Journal   #2######\' +
                          'Moving Payroll Header    #3######\' +
                          'Moving Payroll Lines     #4######');

            lvHeader.SETRANGE("Payroll ID", gvPeriodID);
            lvHeader.SETRANGE(Calculated, FALSE);
            lvHeader.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
            IF lvHeader.FIND('-') THEN ERROR('Not all Payroll entries are calculated!\Calculate them before posting.');
            EXIT(TRUE);
        END;
    end;

    procedure sInitialInfo()
    var
        lvPayrollSetup: Record 51165;
    begin
        //Get payroll setup info.
        lvPayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
        lvPayrollSetup.TESTFIELD("Payroll Template");
        lvPayrollSetup.TESTFIELD("Payroll Batch");

        gvTemplateName := lvPayrollSetup."Payroll Template";
        gvBatchName := lvPayrollSetup."Payroll Batch";
    end;

    procedure sLoopHeader()
    var
        lvHeader: Record 51159;
    begin
        lvHeader.LOCKTABLE(TRUE);
        lvHeader.SETRANGE("Payroll ID", gvPeriodID);
        lvHeader.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

        gvWindowCounter := 0;
        lvHeader.FIND('-');
        REPEAT
            gvWindowCounter := gvWindowCounter + 1;
            gvWindow.UPDATE(1, gvWindowCounter);
            sLoopLines(lvHeader);
            sInsertNetpayLine(lvHeader);
            lvHeader.Posted := TRUE;
            lvHeader.MODIFY;
        UNTIL lvHeader.NEXT = 0;

        //V.6.1.65 >>
        CLEAR(gvGenJnlLine);
        gvGenJnlLine.SETRANGE("Journal Batch Name", gvBatchName);
        gvGenJnlLine.SETRANGE("Journal Template Name", 'CASHRCPT');
        gvGenJnlLine.SETRANGE("Document Type", gvGenJnlLine."Document Type"::Payment);
        gvGenJnlLine.SETRANGE("Posting Date", gvPostingDate);
        IF gvGenJnlLine.FINDFIRST THEN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", gvGenJnlLine);
        //V.6.1.65 >>
    end;

    procedure sLoopLines(var Header: Record 51159)
    var
        lvLines: Record 51160;
        lvLoanTypeRec: Record 51178;
        lvLoansRec: Record 51171;
        lvLoanEntryRec: Record 51172;
        lvAmount: Decimal;
        lvInterestAmount: Decimal;
        lvRepaymentAmount: Decimal;
        lvPayrollSetup: Record 51165;
    begin
        lvLines.LOCKTABLE(TRUE);
        lvLines.SETCURRENTKEY("Payroll ID", "Employee No.");
        lvLines.SETRANGE("Payroll ID", gvPeriodID);
        lvLines.SETRANGE("Employee No.", Header."Employee no.");
        //lvPayrollSetup.GET(lvLines."Payroll Code");

        sGetEmployeeInfo(Header);
        IF lvLines.FIND('-') THEN BEGIN
            REPEAT
                //V.6.1.65 >>
                IF lvPayrollSetup."Make Personal A/C Recoveries" THEN
                    IF lvPayrollSetup."Personal Account Recoveries ED" = lvLines."ED Code" THEN sWriteToGenJnlLinesForPayment(lvLines);
                //V.6.1.65 >>

                IF lvLines."Loan Entry" THEN BEGIN
                    lvLoansRec.GET(lvLines."Loan ID");
                    lvLoanEntryRec.GET(lvLines."Loan Entry No", lvLines."Loan ID");
                    lvLoanTypeRec.GET(lvLoansRec."Loan Types");
                    lvLoanTypeRec.TESTFIELD("Loan Interest Account");

                    lvLoanEntryRec.Posted := TRUE;
                    lvLoanEntryRec.MODIFY;
                    lvInterestAmount := -lvLines.Interest;
                    lvRepaymentAmount := -lvLines.Repayment;

                    IF lvLoanTypeRec."Loan Accounts Type" = lvLoanTypeRec."Loan Accounts Type"::Customer THEN BEGIN
                        gvEmpRec.GET(Header."Employee no.");
                        //gvEmpCustNo := gvPayrollUtilities.fGetEmplyeeLoanAccount(gvEmpRec, lvLoanTypeRec);
                        sInsertLineWithAccountType(gvEmpCustNo, lvRepaymentAmount, Header, lvLines, gvPostBuffer."Account Type"::Customer,
                          -lvLines."Repayment (LCY)");
                    END ELSE BEGIN
                        lvLoanTypeRec.TESTFIELD("Loan Account");
                        sInsertLineWithAccountType(lvLoanTypeRec."Loan Account", lvRepaymentAmount, Header, lvLines,
                          lvLoanTypeRec."Loan Accounts Type", -lvLines."Repayment (LCY)");
                    END;
                    sInsertLineWithAccountType(lvLoanTypeRec."Loan Interest Account", lvInterestAmount, Header, lvLines,
                        lvLoanTypeRec."Loan Interest Account Type", -lvLines."Interest (LCY)");
                END ELSE BEGIN
                    sGetEDInfo(lvLines."ED Code", lvLines."Employee No.");
                    lvAmount := lvLines.Amount;

                    CASE gvEDPostingType OF
                        gvEDPostingType::"G/L Account":
                            sGLPosting(lvAmount, Header, lvLines, lvLines."Amount (LCY)");

                        gvEDPostingType::Direct:
                            BEGIN
                                IF gvEDDebitCredit = gvEDDebitCredit::Debit THEN
                                    sInsertLine(gvEDAccount, lvAmount, Header, lvLines, lvLines."Amount (LCY)")
                                ELSE BEGIN
                                    lvAmount := -lvAmount;
                                    sInsertLine(gvEDAccount, lvAmount, Header, lvLines, -lvLines."Amount (LCY)")
                                END;
                            END; //case

                        gvEDPostingType::Customer:
                            BEGIN
                                gvEmpRec.GET(Header."Employee no.");
                                gvEmpRec.TESTFIELD("Customer No.");
                                gvEmpCustNo := gvEmpRec."Customer No.";
                                IF gvEDDebitCredit = gvEDDebitCredit::Debit THEN
                                    sInsertLineWithAccountType(gvEmpCustNo, lvAmount, Header, lvLines, gvPostBuffer."Account Type"::Customer,
                                      lvLines."Amount (LCY)")
                                ELSE BEGIN
                                    lvAmount := -lvAmount;
                                    sInsertLineWithAccountType(gvEmpCustNo, lvAmount, Header, lvLines, gvPostBuffer."Account Type"::Customer,
                                      -lvLines."Amount (LCY)")
                                END;
                            END;

                        gvEDPostingType::Vendor:
                            BEGIN
                                IF gvEDDebitCredit = gvEDDebitCredit::Debit THEN
                                    sInsertLineWithAccountType(gvEDAccount, lvAmount, Header, lvLines, gvPostBuffer."Account Type"::Vendor,
                                      lvLines."Amount (LCY)")
                                ELSE BEGIN
                                    lvAmount := -lvAmount;
                                    sInsertLineWithAccountType(gvEDAccount, lvAmount, Header, lvLines, gvPostBuffer."Account Type"::Vendor,
                                     -lvLines."Amount (LCY)")
                                END;
                            END;
                    END; //Case
                END; //Else
            UNTIL lvLines.NEXT = 0;
        END;
    end;

    procedure sGetEmployeeInfo(var Header: Record 51159)
    var
        lvEmployee: Record 5200;
        lvModeOfPayment: Record 51187;
    begin
        IF lvEmployee.GET(Header."Employee no.") THEN BEGIN
            gvEmpCustNo := '';
            lvEmployee.TESTFIELD("Posting Group");
            gvEmploPostingGroup := lvEmployee."Posting Group";

            lvEmployee.TESTFIELD("Mode of Payment");
            lvModeOfPayment.GET(lvEmployee."Mode of Payment");
            gvBalAccountType := lvModeOfPayment."Net Pay Account Type";
            gvBalAccount := lvModeOfPayment."Net Pay Account No";
        END ELSE
            ERROR('Employee No. %1 does not exits\create the employee again', Header."Employee no.");
    end;

    procedure sGetEDInfo(var EDCode: Code[20]; EmpNo: Code[10])
    var
        lvEDDef: Record 51158;
        lvEmpRec: Record 5200;
    begin
        lvEDDef.GET(EDCode);
        gvEDPostingType := lvEDDef."Posting type";

        IF lvEDDef."Posting type" = lvEDDef."Posting type"::Customer THEN BEGIN
            lvEmpRec.GET(EmpNo);
            lvEmpRec.TESTFIELD("Customer No.");
            gvEDAccount := lvEmpRec."Customer No.";
        END ELSE
            gvEDAccount := lvEDDef."Account No";

        gvEDPostingGroup := lvEDDef."ED Posting Group";

        lvEmpRec.GET(EmpNo);
        gvEDDebitCredit := lvEDDef."Debit/Credit";
    end;

    procedure sGLPosting(Amount: Decimal; PayrollHdr: Record 51159; PayrollLine: Record 51160; AmountLCY: Decimal)
    var
        PostSetup: Record 51157;
    begin
        PostSetup.GET(gvEmploPostingGroup, gvEDPostingGroup);
        //PostSetup.TESTFIELD("Debit Account");
        //PostSetup.TESTFIELD("Credit Account");

        IF PostSetup."Debit Account" <> '' THEN
            sInsertLine(PostSetup."Debit Account", Amount, PayrollHdr, PayrollLine, AmountLCY);

        IF PostSetup."Credit Account" <> '' THEN BEGIN
            sInsertLine(PostSetup."Credit Account", -Amount, PayrollHdr, PayrollLine, -AmountLCY)
        END;
    end;

    procedure sInsertLine(var AccountNo: Code[20]; Amount: Decimal; PayrollHdr: Record 51159; PayrollLine: Record 51160; AmountLCY: Decimal)
    var
        "Account Type": Option "G/L Account",Customer,Vendor;
        PayrollBufferDims: Record 51184 temporary;
    begin
        //Posting to to a G/L Account
        gvPostBuffer.RESET;
        gvPostBuffer.SETCURRENTKEY("Account Type", "Account No", "Payroll Code", "ED Code");
        gvPostBuffer.SETRANGE("Account Type", gvPostBuffer."Account Type"::"G/L Account");
        gvPostBuffer.SETRANGE("Account No", AccountNo);
        gvPostBuffer.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
        gvPostBuffer.SETRANGE("ED Code", PayrollLine."ED Code");
        gvPostBuffer.SETRANGE("Currency Code", PayrollLine."Currency Code");

        IF gvPostBuffer.FINDFIRST THEN
            IF fWithSameDimensions(gvPostBuffer, PayrollHdr, PayrollLine, PayrollBufferDims) THEN BEGIN
                gvPostBuffer.Amount += Amount;
                gvPostBuffer."Amount (LCY)" += AmountLCY;
                gvPostBuffer."Employee No." := PayrollHdr."Employee no."; //cmm 161011 add employee on journal posting line descrption AAFH
                gvPostBuffer.MODIFY;
            END ELSE BEGIN
                gvLastBufferNo += 1;
                gvPostBuffer.RESET;
                gvPostBuffer.INIT;
                gvPostBuffer."Buffer No" := gvLastBufferNo;
                gvPostBuffer."Account Type" := gvPostBuffer."Account Type"::"G/L Account";
                gvPostBuffer."Account No" := AccountNo;
                gvPostBuffer."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                gvPostBuffer."ED Code" := PayrollLine."ED Code";
                gvPostBuffer."Currency Code" := PayrollLine."Currency Code";
                gvPostBuffer.Amount := Amount;
                gvPostBuffer."Amount (LCY)" := AmountLCY;
                gvPostBuffer."Currency Factor" := PayrollLine."Currency Factor";
                gvPostBuffer."Employee No." := PayrollHdr."Employee no."; //cmm 161011 add employee on journal posting line descrption AAFH
                gvPostBuffer.INSERT;
                sEnforceEmpEDDimRules(PayrollBufferDims, PayrollHdr, gvPostBuffer);
                sSetPostingDims(gvPostBuffer, PayrollBufferDims);
            END
        ELSE BEGIN
            gvLastBufferNo += 1;
            gvPostBuffer.RESET;
            gvPostBuffer.INIT;
            gvPostBuffer."Buffer No" := gvLastBufferNo;
            gvPostBuffer."Account Type" := gvPostBuffer."Account Type"::"G/L Account";
            gvPostBuffer."Account No" := AccountNo;
            gvPostBuffer."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            gvPostBuffer."ED Code" := PayrollLine."ED Code";
            gvPostBuffer."Currency Code" := PayrollLine."Currency Code";
            gvPostBuffer.Amount := Amount;
            gvPostBuffer."Amount (LCY)" := AmountLCY;
            gvPostBuffer."Currency Factor" := PayrollLine."Currency Factor";
            gvPostBuffer."Employee No." := PayrollLine."Employee No.";//cmm 161011 add employee on journal posting line descrption AAFH
            gvPostBuffer.INSERT;
            sGetBufferDimsFromHdrandLine(PayrollHdr, PayrollLine, PayrollBufferDims);
            sEnforceEmpEDDimRules(PayrollBufferDims, PayrollHdr, gvPostBuffer);
            sSetPostingDims(gvPostBuffer, PayrollBufferDims);
        END;
    end;

    procedure sInsertLineWithAccountType(AccountNo: Code[20]; Amount: Decimal; PayrollHdr: Record 51159; PayrollLine: Record 51160; AccountType: Option "G/L Account",Customer,Vendor; AmountLCY: Decimal)
    var
        PayrollBufferDims: Record 51184 temporary;
    begin
        //Posting to customer, vendor account

        gvPostBuffer.RESET;
        gvPostBuffer.SETCURRENTKEY("Account Type", "Account No", "Payroll Code", "ED Code");
        gvPostBuffer.SETRANGE("Account Type", AccountType);
        gvPostBuffer.SETRANGE("Account No", AccountNo);
        gvPostBuffer.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
        gvPostBuffer.SETRANGE("ED Code", PayrollLine."ED Code");
        gvPostBuffer.SETRANGE("Currency Code", PayrollLine."Currency Code");

        IF gvPostBuffer.FINDFIRST THEN
            IF fWithSameDimensions(gvPostBuffer, PayrollHdr, PayrollLine, PayrollBufferDims) THEN BEGIN
                gvPostBuffer.Amount += Amount;
                gvPostBuffer."Amount (LCY)" += AmountLCY;
                gvPostBuffer."Employee No." := PayrollHdr."Employee no."; //cmm 161011 add employee on journal posting line descrption AAFH
                gvPostBuffer.MODIFY;
            END ELSE BEGIN
                gvLastBufferNo += 1;
                gvPostBuffer.RESET;
                gvPostBuffer.INIT;
                gvPostBuffer."Buffer No" := gvLastBufferNo;
                gvPostBuffer."Account Type" := AccountType;
                gvPostBuffer."Account No" := AccountNo;
                gvPostBuffer."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                gvPostBuffer."ED Code" := PayrollLine."ED Code";
                gvPostBuffer."Currency Code" := PayrollLine."Currency Code";
                gvPostBuffer.Amount := Amount;
                gvPostBuffer."Amount (LCY)" := AmountLCY;
                gvPostBuffer."Currency Factor" := PayrollLine."Currency Factor";
                gvPostBuffer."Employee No." := PayrollHdr."Employee no."; //cmm 161011 add employee on journal posting line descrption AAFH
                gvPostBuffer.INSERT;
                sEnforceEmpEDDimRules(PayrollBufferDims, PayrollHdr, gvPostBuffer);
                sSetPostingDims(gvPostBuffer, PayrollBufferDims);
            END
        ELSE BEGIN
            gvLastBufferNo += 1;
            gvPostBuffer.RESET;
            gvPostBuffer.INIT;
            gvPostBuffer."Buffer No" := gvLastBufferNo;
            gvPostBuffer."Account Type" := AccountType;
            gvPostBuffer."Account No" := AccountNo;
            gvPostBuffer."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            gvPostBuffer."ED Code" := PayrollLine."ED Code";
            gvPostBuffer."Currency Code" := PayrollLine."Currency Code";
            gvPostBuffer.Amount := Amount;
            gvPostBuffer."Amount (LCY)" := AmountLCY;
            gvPostBuffer."Currency Factor" := PayrollLine."Currency Factor";
            gvPostBuffer."Employee No." := PayrollLine."Employee No."; //cmm 161011 add employee on journal posting line descrption AAFH
            gvPostBuffer.INSERT;
            sGetBufferDimsFromHdrandLine(PayrollHdr, PayrollLine, PayrollBufferDims);
            sEnforceEmpEDDimRules(PayrollBufferDims, PayrollHdr, gvPostBuffer);
            sSetPostingDims(gvPostBuffer, PayrollBufferDims);
        END;
    end;

    procedure sInsertNetpayLine(PayrollHdr: Record 51159)
    var
        AmountLCY: Decimal;
        PayrollBufferDims: Record 51184 temporary;
        EmpNetPay: Record 5200;
    begin
        gvPostBuffer.RESET;
        gvPostBuffer.SETCURRENTKEY("Account Type", "Account No", "Payroll Code", "ED Code");
        gvPostBuffer.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        gvPostBuffer.CALCSUMS("Amount (LCY)");
        AmountLCY := -gvPostBuffer."Amount (LCY)";

        gvPostBuffer.RESET;
        gvPostBuffer.SETCURRENTKEY("Account Type", "Account No", "Payroll Code", "ED Code");
        EmpNetPay.GET(PayrollHdr."Employee no.");//ICS 28APR2017
        IF EmpNetPay."Bank Code" = '001' THEN
            gvPostBuffer.SETRANGE("Account Type", gvPostBuffer."Account Type"::Vendor)//ICS 28APR2017
        ELSE
            gvPostBuffer.SETRANGE("Account Type", gvBalAccountType);
        IF EmpNetPay."Bank Code" = '001' THEN
            gvPostBuffer.SETRANGE("Account No", EmpNetPay."Bank Account No")
        ELSE
            gvPostBuffer.SETRANGE("Account No", gvBalAccount);
        gvPostBuffer.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");

        IF gvPostBuffer.FINDFIRST THEN
            IF fWithSameDimensions2(gvPostBuffer, PayrollHdr, PayrollBufferDims) THEN BEGIN
                gvPostBuffer.Amount += AmountLCY;
                gvPostBuffer."Amount (LCY)" += AmountLCY;
                gvPostBuffer."Employee No." := PayrollHdr."Employee no."; //cmm 161011 add employee on journal posting line descrption AAFH
                gvPostBuffer.MODIFY;
            END ELSE BEGIN
                gvLastBufferNo += 1;
                gvPostBuffer.RESET;
                gvPostBuffer.INIT;
                gvPostBuffer."Buffer No" := gvLastBufferNo;
                IF EmpNetPay."Bank Code" = '001' THEN
                    gvPostBuffer."Account Type" := gvPostBuffer."Account Type"::Vendor ELSE
                    gvPostBuffer."Account Type" := gvBalAccountType;
                IF EmpNetPay."Bank Code" = '001' THEN gvPostBuffer."Account No" := EmpNetPay."Bank Account No";
                gvPostBuffer."Account No" := gvBalAccount;
                gvPostBuffer."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                gvPostBuffer.Amount := AmountLCY;
                gvPostBuffer."Amount (LCY)" := AmountLCY;
                gvPostBuffer."Employee No." := PayrollHdr."Employee no."; //cmm 161011 add employee on journal posting line descrption AAFH
                gvPostBuffer.INSERT;
                sEnforceEmpEDDimRules(PayrollBufferDims, PayrollHdr, gvPostBuffer);
                sSetPostingDims(gvPostBuffer, PayrollBufferDims);
            END
        ELSE BEGIN
            gvLastBufferNo += 1;
            gvPostBuffer.RESET;
            gvPostBuffer.INIT;
            gvPostBuffer."Buffer No" := gvLastBufferNo;
            IF EmpNetPay."Bank Code" = '001' THEN
                gvPostBuffer."Account Type" := gvPostBuffer."Account Type"::Vendor ELSE
                gvPostBuffer."Account Type" := gvBalAccountType;
            //gvPostBuffer."Account Type" := gvBalAccountType;
            IF EmpNetPay."Bank Code" = '001' THEN
                gvPostBuffer."Account No" := EmpNetPay."Bank Account No"
            ELSE //ICS 28APR
                gvPostBuffer."Account No" := gvBalAccount;
            gvPostBuffer."Account No" := gvBalAccount;
            gvPostBuffer."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            gvPostBuffer.Amount := AmountLCY;
            gvPostBuffer."Amount (LCY)" := AmountLCY;
            gvPostBuffer."Employee No." := PayrollHdr."Employee no."; //cmm 161011 add employee on journal posting line descrption AAFH
            gvPostBuffer.INSERT;
            sGetBufferDimsFromHdr(PayrollHdr, PayrollBufferDims);
            sEnforceEmpEDDimRules(PayrollBufferDims, PayrollHdr, gvPostBuffer);
            sSetPostingDims(gvPostBuffer, PayrollBufferDims);
        END;
    end;

    procedure fWithSameDimensions(var PayrollPostingBuffer: Record 51164; PayrollHdr: Record 51159; PayrollLine: Record 51160; var PayrollBufferDims: Record 51184 temporary): Boolean
    var
        lvPayrollPostingBuffer: Record 51164;
        lvPayrollDimsTemp: Record 51184 temporary;
        lvPayrollSetup: Record 51165;
        lvNewBufferEntryHasDims: Boolean;
        lvSameDims: Boolean;
        lvIndex: Integer;
    begin
        //skm060606 this function checks whether a payroll posting buffer entry with same dimensions as
        //for the current payroll header and payroll line combination already exists

        sGetBufferDimsFromHdrandLine(PayrollHdr, PayrollLine, PayrollBufferDims);
        lvNewBufferEntryHasDims := PayrollBufferDims.FINDFIRST;

        //Check if posting buffer entry with same dimensions exists
        IF lvNewBufferEntryHasDims THEN BEGIN
            lvSameDims := FALSE; //Assume there isn't a buffer entry with same dimensions as the new buffer entry
            lvPayrollPostingBuffer.SETCURRENTKEY("Account Type", "Account No", "Payroll Code", "ED Code", "Currency Code");
            lvPayrollPostingBuffer.SETRANGE("Account Type", PayrollPostingBuffer."Account Type");
            lvPayrollPostingBuffer.SETRANGE("Account No", PayrollPostingBuffer."Account No");
            lvPayrollPostingBuffer.SETRANGE("Payroll Code", PayrollPostingBuffer."Payroll Code");
            lvPayrollPostingBuffer.SETRANGE("ED Code", PayrollPostingBuffer."ED Code");
            lvPayrollPostingBuffer.SETRANGE("Currency Code", PayrollPostingBuffer."Currency Code");
            IF lvPayrollPostingBuffer.FINDSET(FALSE, FALSE) THEN
                REPEAT //compare dimensions if any
                    lvIndex := 1;
                    gvPayrollDims.RESET;
                    gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                    gvPayrollDims.SETRANGE("Entry No", lvPayrollPostingBuffer."Buffer No");
                    IF gvPayrollDims.FINDSET(FALSE, FALSE) THEN //buffer entry has dimensions
                        REPEAT
                            PayrollBufferDims.RESET;
                            PayrollBufferDims.SETRANGE("Table ID", gvPayrollDims."Table ID");
                            PayrollBufferDims.SETRANGE("ED Code", gvPayrollDims."ED Code");
                            PayrollBufferDims.SETRANGE("Dimension Code", gvPayrollDims."Dimension Code");
                            PayrollBufferDims.SETRANGE("Dimension Value Code", gvPayrollDims."Dimension Value Code");
                            PayrollBufferDims.SETRANGE("Payroll Code", gvPayrollDims."Payroll Code");
                            IF lvIndex = 1 THEN
                                lvSameDims := PayrollBufferDims.FINDFIRST
                            ELSE
                                lvSameDims := PayrollBufferDims.FINDFIRST AND lvSameDims;
                            lvIndex += 1;
                        UNTIL gvPayrollDims.NEXT = 0;

                    IF lvSameDims THEN BEGIN
                        PayrollPostingBuffer.GET(lvPayrollPostingBuffer."Buffer No");
                        EXIT(TRUE);
                    END;
                UNTIL lvPayrollPostingBuffer.NEXT = 0;

            EXIT(FALSE);
        END;

        //Check if same posting buffer entry without dimensions exists
        lvPayrollPostingBuffer.RESET;
        lvPayrollPostingBuffer.SETCURRENTKEY("Account Type", "Account No", "Payroll Code", "ED Code", "Currency Code");
        lvPayrollPostingBuffer.SETRANGE("Account Type", PayrollPostingBuffer."Account Type");
        lvPayrollPostingBuffer.SETRANGE("Account No", PayrollPostingBuffer."Account No");
        lvPayrollPostingBuffer.SETRANGE("Payroll Code", PayrollPostingBuffer."Payroll Code");
        lvPayrollPostingBuffer.SETRANGE("ED Code", PayrollPostingBuffer."ED Code");
        lvPayrollPostingBuffer.SETRANGE("Currency Code", PayrollPostingBuffer."Currency Code");
        IF lvPayrollPostingBuffer.FINDSET(FALSE, FALSE) THEN
            REPEAT
                gvPayrollDims.RESET;
                gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                gvPayrollDims.SETRANGE("Entry No", lvPayrollPostingBuffer."Buffer No");
                IF NOT gvPayrollDims.FINDSET(FALSE, FALSE) THEN //same buffer entry without dimensions
                    REPEAT
                        PayrollBufferDims.RESET;
                        PayrollBufferDims.SETRANGE("Table ID", gvPayrollDims."Table ID");
                        PayrollBufferDims.SETRANGE("ED Code", gvPayrollDims."ED Code");
                        PayrollBufferDims.SETRANGE("Dimension Code", gvPayrollDims."Dimension Code");
                        PayrollBufferDims.SETRANGE("Dimension Value Code", gvPayrollDims."Dimension Value Code");
                        PayrollBufferDims.SETRANGE("Payroll Code", gvPayrollDims."Payroll Code");

                        IF NOT PayrollBufferDims.FINDFIRST THEN BEGIN //same buffer entry without dimensions
                            PayrollPostingBuffer.GET(lvPayrollPostingBuffer."Buffer No");
                            EXIT(TRUE);
                        END
                    UNTIL gvPayrollDims.NEXT = 0
            UNTIL lvPayrollPostingBuffer.NEXT = 0;

        EXIT(FALSE);
        //End
    end;

    procedure fWithSameDimensions2(var PayrollPostingBuffer: Record 51164; PayrollHdr: Record 51159; var PayrollBufferDims: Record 51184 temporary): Boolean
    var
        lvPayrollPostingBuffer: Record 51164;
        lvNewBufferEntryHasDims: Boolean;
        lvSameDims: Boolean;
        lvIndex: Integer;
    begin
        //skm070606 this function checkS whether a payroll posting buffer entry with same dimensions as
        //for the current payroll header already exists

        sGetBufferDimsFromHdr(PayrollHdr, PayrollBufferDims);
        lvNewBufferEntryHasDims := PayrollBufferDims.FINDFIRST;

        //Check if posting buffer entry with same dimensions exists
        IF lvNewBufferEntryHasDims THEN BEGIN
            lvSameDims := FALSE; //Assume there isn't a buffer entry with same dimensions as the new buffer entry
            lvPayrollPostingBuffer.SETCURRENTKEY("Account Type", "Account No", "Payroll Code", "ED Code", "Currency Code");
            lvPayrollPostingBuffer.SETRANGE("Account Type", PayrollPostingBuffer."Account Type");
            lvPayrollPostingBuffer.SETRANGE("Account No", PayrollPostingBuffer."Account No");
            lvPayrollPostingBuffer.SETRANGE("Payroll Code", PayrollPostingBuffer."Payroll Code");
            lvPayrollPostingBuffer.SETRANGE("ED Code", PayrollPostingBuffer."ED Code");
            lvPayrollPostingBuffer.SETRANGE("Currency Code", PayrollPostingBuffer."Currency Code");
            IF lvPayrollPostingBuffer.FINDSET(FALSE, FALSE) THEN
                REPEAT //compare dimensions if any
                    lvIndex := 1;
                    gvPayrollDims.RESET;
                    gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                    gvPayrollDims.SETRANGE("Entry No", lvPayrollPostingBuffer."Buffer No");
                    IF gvPayrollDims.FINDSET(FALSE, FALSE) THEN //buffer entry has dimensions
                        REPEAT
                            PayrollBufferDims.RESET;
                            PayrollBufferDims.SETRANGE("Table ID", gvPayrollDims."Table ID");
                            PayrollBufferDims.SETRANGE("ED Code", gvPayrollDims."ED Code");
                            PayrollBufferDims.SETRANGE("Dimension Code", gvPayrollDims."Dimension Code");
                            PayrollBufferDims.SETRANGE("Dimension Value Code", gvPayrollDims."Dimension Value Code");
                            PayrollBufferDims.SETRANGE("Payroll Code", gvPayrollDims."Payroll Code");
                            IF lvIndex = 1 THEN
                                lvSameDims := PayrollBufferDims.FINDFIRST
                            ELSE
                                lvSameDims := PayrollBufferDims.FINDFIRST AND lvSameDims;
                            lvIndex += 1;
                        UNTIL gvPayrollDims.NEXT = 0;

                    IF lvSameDims THEN BEGIN
                        PayrollPostingBuffer.GET(lvPayrollPostingBuffer."Buffer No");
                        EXIT(TRUE);
                    END;
                UNTIL lvPayrollPostingBuffer.NEXT = 0;

            EXIT(FALSE);
        END;
        //Check if posting buffer entry with same dimensions exists

        /*skm20110317 AAFH payroll expense allocation. Due to change in payroll utilities not to use both Payroll Expense Allocaions
        and Employee/Payroll Header Dimensions at the same time, this code is no longer usable.
        //Check if same posting buffer entry without dimensions exists
          lvPayrollPostingBuffer.RESET;
          lvPayrollPostingBuffer.SETCURRENTKEY("Account Type", "Account No", "Payroll Code", "ED Code", "Currency Code");
          lvPayrollPostingBuffer.SETRANGE("Account Type", PayrollPostingBuffer."Account Type");
          lvPayrollPostingBuffer.SETRANGE("Account No", PayrollPostingBuffer."Account No");
          lvPayrollPostingBuffer.SETRANGE("Payroll Code", PayrollPostingBuffer."Payroll Code");
          lvPayrollPostingBuffer.SETRANGE("ED Code", PayrollPostingBuffer."ED Code");
          lvPayrollPostingBuffer.SETRANGE("Currency Code", PayrollPostingBuffer."Currency Code");
          IF lvPayrollPostingBuffer.FINDSET(FALSE, FALSE) THEN
            REPEAT
              gvPayrollDims.RESET;
              gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
              gvPayrollDims.SETRANGE("Entry No", lvPayrollPostingBuffer."Buffer No");
              IF NOT gvPayrollDims.FINDSET(FALSE, FALSE) THEN //same buffer entry without dimensions
                REPEAT
                  PayrollBufferDims.RESET;
                  PayrollBufferDims.SETRANGE("Table ID", gvPayrollDims."Table ID");
                  PayrollBufferDims.SETRANGE("ED Code", gvPayrollDims."ED Code");
                  PayrollBufferDims.SETRANGE("Dimension Code", gvPayrollDims."Dimension Code");
                  PayrollBufferDims.SETRANGE("Dimension Value Code", gvPayrollDims."Dimension Value Code");
                  PayrollBufferDims.SETRANGE("Payroll Code", gvPayrollDims."Payroll Code");
        
                  IF NOT PayrollBufferDims.FINDFIRST THEN BEGIN //same buffer entry without dimensions
                    PayrollPostingBuffer.GET(lvPayrollPostingBuffer."Buffer No");
                    EXIT(TRUE);
                  END
                UNTIL gvPayrollDims.NEXT = 0
            UNTIL lvPayrollPostingBuffer.NEXT = 0;
        
          EXIT(FALSE);
        //End
        */

    end;

    procedure sGetBufferDimsFromHdrandLine(PayrollHdr: Record 51159; PayrollLine: Record 51160; var PayrollBufferDims: Record 51184 temporary)
    var
        lvPayrollDimsTemp: Record 51184 temporary;
        lvPayrollSetup: Record 51165;
    begin
        //skm060606 this sub generates payroll posting buffer dimensions from a given
        //payroll header and payroll line

        lvPayrollSetup.GET(PayrollHdr."Payroll Code");

        //Generate dims for current header & line comnination
        IF lvPayrollSetup."Priority to Dims Assigned To" = lvPayrollSetup."Priority to Dims Assigned To"::Employee THEN BEGIN
            //Copy header/employee dims to temporary dim merge table
            gvPayrollDims.RESET;
            gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Header");
            gvPayrollDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
            gvPayrollDims.SETRANGE("Employee No", PayrollHdr."Employee no.");
            gvPayrollDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
            IF gvPayrollDims.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    lvPayrollDimsTemp.COPY(gvPayrollDims);
                    lvPayrollDimsTemp."Table ID" := DATABASE::"Payroll Posting Buffer";
                    lvPayrollDimsTemp.INSERT;
                UNTIL gvPayrollDims.NEXT = 0;

            //Merge header and line dims giving priority to header/employee dimension in case of conflict
            gvPayrollDims.RESET;
            gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Lines");
            gvPayrollDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
            gvPayrollDims.SETRANGE("Employee No", PayrollHdr."Employee no.");
            gvPayrollDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
            gvPayrollDims.SETRANGE("Entry No", PayrollLine."Entry No.");
            gvPayrollDims.SETRANGE("ED Code", PayrollLine."ED Code");
            IF gvPayrollDims.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    lvPayrollDimsTemp.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                    lvPayrollDimsTemp.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
                    lvPayrollDimsTemp.SETRANGE("Employee No", PayrollHdr."Employee no.");
                    lvPayrollDimsTemp.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
                    lvPayrollDimsTemp.SETRANGE("Dimension Code", gvPayrollDims."Dimension Code");

                    IF lvPayrollDimsTemp.FINDFIRST THEN BEGIN //conflict, copy from header
                        PayrollBufferDims.COPY(lvPayrollDimsTemp);
                        PayrollBufferDims."Employee No" := '';
                        PayrollBufferDims."Entry No" := gvPayrollDims."Entry No";
                        PayrollBufferDims."ED Code" := gvPayrollDims."ED Code";
                        PayrollBufferDims.INSERT;
                        lvPayrollDimsTemp.DELETE;
                    END ELSE BEGIN //no conflict, copy from line
                        PayrollBufferDims.COPY(gvPayrollDims);
                        PayrollBufferDims."Employee No" := '';
                        PayrollBufferDims."Table ID" := DATABASE::"Payroll Posting Buffer";
                        PayrollBufferDims.INSERT;
                    END
                UNTIL gvPayrollDims.NEXT = 0;

            //copy from header dims not in line
            lvPayrollDimsTemp.RESET;
            IF lvPayrollDimsTemp.FINDSET(TRUE, FALSE) THEN
                REPEAT
                    PayrollBufferDims.COPY(lvPayrollDimsTemp);
                    PayrollBufferDims."Employee No" := '';
                    PayrollBufferDims."Entry No" := PayrollLine."Entry No.";
                    PayrollBufferDims."ED Code" := PayrollLine."ED Code";
                    PayrollBufferDims.INSERT;
                UNTIL lvPayrollDimsTemp.NEXT = 0;
            lvPayrollDimsTemp.DELETEALL;
        END ELSE BEGIN //Priority to dims on the line
            //Copy line dims to temporary dim merge table
            gvPayrollDims.RESET;
            gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Lines");
            gvPayrollDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
            gvPayrollDims.SETRANGE("Employee No", PayrollHdr."Employee no.");
            gvPayrollDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
            gvPayrollDims.SETRANGE("Entry No", PayrollLine."Entry No.");
            gvPayrollDims.SETRANGE("ED Code", PayrollLine."ED Code");
            IF gvPayrollDims.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    lvPayrollDimsTemp.COPY(gvPayrollDims);
                    lvPayrollDimsTemp."Table ID" := DATABASE::"Payroll Posting Buffer";
                    lvPayrollDimsTemp.INSERT;
                UNTIL gvPayrollDims.NEXT = 0;

            //Merge header and line dims giving priority to line dimension in case of conflict
            gvPayrollDims.RESET;
            gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Header");
            gvPayrollDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
            gvPayrollDims.SETRANGE("Employee No", PayrollHdr."Employee no.");
            gvPayrollDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
            IF gvPayrollDims.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    lvPayrollDimsTemp.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                    lvPayrollDimsTemp.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
                    lvPayrollDimsTemp.SETRANGE("Employee No", PayrollHdr."Employee no.");
                    lvPayrollDimsTemp.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
                    lvPayrollDimsTemp.SETRANGE("Dimension Code", gvPayrollDims."Dimension Code");

                    IF lvPayrollDimsTemp.FINDFIRST THEN BEGIN //conflict, copy from line
                        PayrollBufferDims.COPY(lvPayrollDimsTemp);
                        PayrollBufferDims."Employee No" := '';
                        PayrollBufferDims.INSERT;
                        lvPayrollDimsTemp.DELETE;
                    END ELSE BEGIN //no conflict, copy from header
                        PayrollBufferDims.COPY(gvPayrollDims);
                        PayrollBufferDims."Employee No" := '';
                        PayrollBufferDims."Table ID" := DATABASE::"Payroll Posting Buffer";
                        PayrollBufferDims.INSERT;
                    END
                UNTIL gvPayrollDims.NEXT = 0;

            //copy from line dims not in header
            lvPayrollDimsTemp.RESET;
            IF lvPayrollDimsTemp.FIND('-') THEN
                REPEAT
                    PayrollBufferDims.COPY(lvPayrollDimsTemp);
                    PayrollBufferDims."Employee No" := '';
                    PayrollBufferDims.INSERT;
                UNTIL lvPayrollDimsTemp.NEXT = 0;
            lvPayrollDimsTemp.DELETEALL;
        END;
        //Generate dims for current header & line comnination
    end;

    procedure sGetBufferDimsFromHdr(PayrollHdr: Record 51159; var PayrollBufferDims: Record 51184 temporary)
    begin
        //skm070606 this sub generates payroll posting buffer entry dimensions
        //from a given payroll header

        //Copy header/employee dims to temporary posting buffer dims
        gvPayrollDims.RESET;
        gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Header");
        gvPayrollDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
        gvPayrollDims.SETRANGE("Employee No", PayrollHdr."Employee no.");
        gvPayrollDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
        IF gvPayrollDims.FINDSET(FALSE, FALSE) THEN
            REPEAT
                PayrollBufferDims.COPY(gvPayrollDims);
                PayrollBufferDims."Employee No" := '';
                PayrollBufferDims."Table ID" := DATABASE::"Payroll Posting Buffer";
                PayrollBufferDims.INSERT;
            UNTIL gvPayrollDims.NEXT = 0;
    end;

    procedure sEnforceEmpEDDimRules(var PayrollBufferDims: Record 51184 temporary; PayrollHdr: Record 51159; PayrollPostingBuffer: Record 51164)
    var
        lvDefaultDimension: Record 352;
    begin
        //skm140606 this function validates temporary payroll posting buffer dimensions before they are
        //assigned to the payroll posting buffer for comformity with dimension rules for the associated
        //Employee and ED

        //Validate against employee dimension rules
        lvDefaultDimension.RESET;
        lvDefaultDimension.SETRANGE("Table ID", DATABASE::Employee);
        lvDefaultDimension.SETRANGE("No.", PayrollHdr."Employee no.");
        IF lvDefaultDimension.FINDSET(FALSE, FALSE) THEN
            REPEAT
                CASE lvDefaultDimension."Value Posting" OF
                    lvDefaultDimension."Value Posting"::"Code Mandatory":
                        BEGIN
                            PayrollBufferDims.RESET;
                            PayrollBufferDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                            PayrollBufferDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
                            PayrollBufferDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
                            PayrollBufferDims.SETRANGE("Dimension Code", lvDefaultDimension."Dimension Code");
                            IF NOT PayrollBufferDims.FINDFIRST THEN
                                ERROR('Please specify a %1 dimension in Payroll Header %2 %3.',
                                      lvDefaultDimension."Dimension Code", PayrollHdr."Payroll ID", PayrollHdr."Employee no.")
                        END;

                    lvDefaultDimension."Value Posting"::"Same Code":
                        BEGIN
                            PayrollBufferDims.RESET;
                            PayrollBufferDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                            PayrollBufferDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
                            PayrollBufferDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
                            PayrollBufferDims.SETRANGE("Dimension Code", lvDefaultDimension."Dimension Code");
                            PayrollBufferDims.SETRANGE("Dimension Value Code", lvDefaultDimension."Dimension Value Code");
                            IF NOT PayrollBufferDims.FINDFIRST THEN
                                ERROR('Please specify %1 %2 dimension in Payroll Header %3 %4.',
                                      lvDefaultDimension."Dimension Code", lvDefaultDimension."Dimension Value Code",
                                      PayrollHdr."Payroll ID", PayrollHdr."Employee no.")
                        END;

                    lvDefaultDimension."Value Posting"::"No Code":
                        BEGIN
                            PayrollBufferDims.RESET;
                            PayrollBufferDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                            PayrollBufferDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
                            PayrollBufferDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
                            PayrollBufferDims.SETRANGE("Dimension Code", lvDefaultDimension."Dimension Code");
                            IF PayrollBufferDims.FINDFIRST THEN
                                ERROR('You must not specify a %1 dimension in Payroll Header %2 %3.',
                                      lvDefaultDimension."Dimension Code", PayrollHdr."Payroll ID", PayrollHdr."Employee no.")
                        END;
                END
            UNTIL lvDefaultDimension.NEXT = 0;
        //End Validate against employee dimension rules

        //Validate against ED dimension rules
        lvDefaultDimension.RESET;
        lvDefaultDimension.SETRANGE("Table ID", DATABASE::"ED Definitions");
        lvDefaultDimension.SETRANGE("No.", PayrollPostingBuffer."ED Code");
        IF lvDefaultDimension.FINDSET(FALSE, FALSE) THEN
            REPEAT
                CASE lvDefaultDimension."Value Posting" OF
                    lvDefaultDimension."Value Posting"::"Code Mandatory":
                        BEGIN
                            PayrollBufferDims.RESET;
                            PayrollBufferDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                            PayrollBufferDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
                            PayrollBufferDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
                            PayrollBufferDims.SETRANGE("ED Code", PayrollPostingBuffer."ED Code");
                            PayrollBufferDims.SETRANGE("Dimension Code", lvDefaultDimension."Dimension Code");
                            IF NOT PayrollBufferDims.FINDFIRST THEN
                                ERROR('Please specify a %1 dimension in Payroll Header %2 %3 for ED %4.',
                                      lvDefaultDimension."Dimension Code", PayrollHdr."Payroll ID",
                                      PayrollHdr."Employee no.", PayrollPostingBuffer."ED Code")
                        END;

                    lvDefaultDimension."Value Posting"::"Same Code":
                        BEGIN
                            PayrollBufferDims.RESET;
                            PayrollBufferDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                            PayrollBufferDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
                            PayrollBufferDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
                            PayrollBufferDims.SETRANGE("ED Code", PayrollPostingBuffer."ED Code");
                            PayrollBufferDims.SETRANGE("Dimension Code", lvDefaultDimension."Dimension Code");
                            PayrollBufferDims.SETRANGE("Dimension Value Code", lvDefaultDimension."Dimension Value Code");
                            IF NOT PayrollBufferDims.FINDFIRST THEN
                                ERROR('Please specify %1 %2 dimension in Payroll Header %3 %4 for ED %5.',
                                      lvDefaultDimension."Dimension Code", lvDefaultDimension."Dimension Value Code",
                                      PayrollHdr."Payroll ID", PayrollHdr."Employee no.", PayrollPostingBuffer."ED Code")
                        END;

                    lvDefaultDimension."Value Posting"::"No Code":
                        BEGIN
                            PayrollBufferDims.RESET;
                            PayrollBufferDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
                            PayrollBufferDims.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
                            PayrollBufferDims.SETRANGE("Payroll Code", PayrollHdr."Payroll Code");
                            PayrollBufferDims.SETRANGE("ED Code", PayrollPostingBuffer."ED Code");
                            PayrollBufferDims.SETRANGE("Dimension Code", lvDefaultDimension."Dimension Code");
                            IF PayrollBufferDims.FINDFIRST THEN
                                ERROR('You must not specify a %1 dimension in Payroll Header %2 %3 ED %4.',
                                      lvDefaultDimension."Dimension Code", PayrollHdr."Payroll ID",
                                      PayrollHdr."Employee no.", PayrollPostingBuffer."ED Code")
                        END;
                END
            UNTIL lvDefaultDimension.NEXT = 0;
        //End Validate against employee dimension rules

        PayrollBufferDims.RESET;
    end;

    procedure sSetPostingDims(PayrollPostingBuffer: Record 51164; var PayrollBufferDims: Record 51184 temporary)
    begin
        //skm060606 this function sets posting dimensions for a payroll posting buffer entry given the
        //dimensions copied from the current payroll header and payroll line

        PayrollBufferDims.RESET;
        IF PayrollBufferDims.FINDSET(TRUE, FALSE) THEN
            REPEAT
                gvPayrollDims.COPY(PayrollBufferDims);
                gvPayrollDims."Entry No" := PayrollPostingBuffer."Buffer No";
                gvPayrollDims.INSERT;
            UNTIL PayrollBufferDims.NEXT = 0;
        PayrollBufferDims.DELETEALL
    end;

    procedure sWriteToGenJnlLines()
    var
        lvGenJnlLine: Record 81;
        lvLineNo: Integer;
        lvGenjnlPost: Codeunit 231;
        lvED: Record 51158;
        rptPayrollPostingBuffer: Report 51183;
        lvPayrollSetup: Record 51165;
        lvTestRptName: Text[250];
        lvPPSetup: Record 51157;
        lvDescString: Text[1024];
        lvTempName: Text[250];
        lvToFile: Text[100];
        lvPayrollEntryLoans: Record 51161;
        lvHdrLoan: Record 51159;
        lvEmpLoan: Record 5200;
    begin
        lvPayrollSetup.GET(gvAllowedPayrolls."Payroll Code");
        gvPostBuffer.RESET;
        gvPostBuffer.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");

        //Print Posting Buffer
        CASE gvTestPost OF
            1:
                BEGIN
                    lvPayrollSetup.TESTFIELD("Payroll Transfer Path");
                    // lvTempName := TEMPORARYPATH + '\' + 'gvPeriodID' + '.pdf';
                    lvTestRptName := lvPayrollSetup."Payroll Transfer Path" + '\';
                    rptPayrollPostingBuffer.SETTABLEVIEW(gvPostBuffer);
                    //rptPayrollPostingBuffer.saSaveAsPdf(lvTempName); //Added by csm for Windows/web client
                    lvToFile := gvPeriodID + '.pdf';
                    //IF DOWNLOAD(lvTempName, 'Save Payroll Transfer as', lvTestRptName, 'PDF file(*.pdf)|*.pdf', lvToFile) THEN;
                    // rptPayrollPostingBuffer.SAVEASHTML(lvTestRptName);  Commented by CSM 30072013 obsolete
                    ERROR('Test report saved as: %1', lvTestRptName);
                END;

            2:
                BEGIN
                    lvPayrollSetup.TESTFIELD("Payroll Transfer Path");
                    // lvTempName := TEMPORARYPATH + '\' + 'gvPeriodID' + '.pdf';
                    lvTestRptName := lvPayrollSetup."Payroll Transfer Path" + '\';
                    lvToFile := gvPeriodID + '.pdf';
                    rptPayrollPostingBuffer.SETTABLEVIEW(gvPostBuffer);
                    // rptPayrollPostingBuffer.SAVEASPDF(lvTempName); //Added by csm for Windows/web client
                    lvToFile := gvPeriodID + '.pdf';
                    //  IF DOWNLOAD(lvTempName, 'Save Payroll Transfer as', lvTestRptName, 'PDF file(*.pdf)|*.pdf', lvToFile) THEN;
                    MESSAGE('Test report saved as: %1', lvTestRptName);
                END;
        END;

        //Convert Posting Buffer Entries into General Journal Line
        lvGenJnlLine.LOCKTABLE(TRUE);
        lvGenJnlLine.SETRANGE("Journal Batch Name", gvBatchName);
        lvGenJnlLine.SETRANGE("Journal Template Name", gvTemplateName);

        IF lvGenJnlLine.FIND('+') THEN
            ERROR('The Batch name %1 is not empty', gvBatchName)
        ELSE
            lvLineNo := 0;

        WITH gvPostBuffer DO BEGIN
            FIND('-');
            gvWindowCounter := 0;
            REPEAT
                IF gvPostBuffer.Amount <> 0 THEN BEGIN
                    gvWindowCounter := gvWindowCounter + 1;
                    gvWindow.UPDATE(2, gvWindowCounter);

                    lvGenJnlLine."Journal Batch Name" := gvBatchName;
                    lvGenJnlLine."Journal Template Name" := gvTemplateName;
                    lvLineNo := lvLineNo + 10;
                    lvGenJnlLine."Line No." := lvLineNo;
                    lvGenJnlLine."Document No." := gvAllowedPayrolls."Payroll Code" + '-' + gvPeriodID;
                    lvGenJnlLine."Document Type" := 0;
                    lvGenJnlLine.VALIDATE("Posting Date", gvPostingDate);
                    lvGenJnlLine.VALIDATE("Account Type", "Account Type");
                    lvGenJnlLine.VALIDATE("Account No.", "Account No");
                    lvGenJnlLine.VALIDATE("Currency Code", gvPostBuffer."Currency Code");
                    lvGenJnlLine."Currency Factor" := gvPostBuffer."Currency Factor";

                    //Reset VAT Fields
                    lvGenJnlLine."Gen. Posting Type" := lvGenJnlLine."Gen. Posting Type"::" ";
                    lvGenJnlLine."VAT Bus. Posting Group" := '';
                    lvGenJnlLine."VAT %" := 0;
                    lvGenJnlLine."VAT Prod. Posting Group" := '';
                    lvGenJnlLine."Gen. Bus. Posting Group" := '';
                    lvGenJnlLine."Gen. Prod. Posting Group" := '';
                    //end reset vat

                    lvGenJnlLine.VALIDATE(Amount, gvPostBuffer.Amount);
                    lvGenJnlLine.VALIDATE("Amount (LCY)", gvPostBuffer."Amount (LCY)");

                    IF gvPostBuffer."ED Code" <> '' THEN BEGIN
                        lvED.GET("ED Code");
                        //cmm 161011 description shows Emp ID if setup is set - orginal code n {}
                        lvDescString := '';
                        IF lvPayrollSetup."Emp ID in Payroll Posting Jnl" THEN BEGIN
                            lvDescString := lvED.Description + '-' + gvPostBuffer."Employee No.";
                            IF STRLEN(lvDescString) > 50 THEN
                                lvGenJnlLine.Description := COPYSTR(lvDescString, STRLEN(lvDescString) - 49, 50)
                            ELSE
                                lvGenJnlLine.Description := lvDescString
                        END ELSE
                            lvGenJnlLine.Description := lvED.Description;
                        //end cmm
                        /*lvGenJnlLine.Description :=  lvED.Description; */
                        //cmm 161011 description shows Emp ID if setup is set - orginal code n {}
                    END ELSE BEGIN
                        lvDescString := '';
                        IF lvPayrollSetup."Emp ID in Payroll Posting Jnl" THEN BEGIN
                            lvDescString := 'Payroll Batch for ' + gvPeriodID + '-' + gvPostBuffer."Employee No.";
                            IF STRLEN(lvDescString) > 50 THEN
                                lvGenJnlLine.Description := COPYSTR(lvDescString, STRLEN(lvDescString) - 49, 50)
                            ELSE
                                lvGenJnlLine.Description := lvDescString;
                        END ELSE
                            lvGenJnlLine.Description := 'Payroll Batch for ' + gvPeriodID;
                    END;
                    //end cmm
                    /* END ELSE
                    lvGenJnlLine.Description :=  'Payroll Batch for ' + gvPeriodID;*/
                    lvGenJnlLine.INSERT;
                    lvGenJnlLine."Dimension Set ID" := sCopyPayrollBufferDims(lvGenJnlLine, gvPostBuffer);//cmm 020813 new Dim NAV2013
                    IF lvGenJnlLine."Dimension Set ID" <> 0 THEN
                        DimMgt.UpdateGlobalDimFromDimSetID(lvGenJnlLine."Dimension Set ID",
                        lvGenJnlLine."Shortcut Dimension 1 Code", lvGenJnlLine."Shortcut Dimension 2 Code");  //cmm 020813 new Dim NAV2013
                    lvGenJnlLine.MODIFY;   //cmm 020813
                END;
            UNTIL NEXT = 0;
            //  lvGenJnlLine."Payroll Calculated" := TRUE;//mesh
        END; //with

        //ICS28APR2017 for the loans linked to SACCO module
        lvHdrLoan.SETFILTER(lvHdrLoan."Payroll ID", gvPeriodID);
        IF lvHdrLoan.FINDFIRST THEN
            REPEAT
                lvEmpLoan.GET(lvHdrLoan."Employee no.");
                lvPayrollEntryLoans.SETFILTER("Payroll ID", lvHdrLoan."Payroll ID");
                lvPayrollEntryLoans.SETFILTER(lvPayrollEntryLoans."Employee No.", lvHdrLoan."Employee no.");
                lvPayrollEntryLoans.SETFILTER("Staff Vendor Entry", '<>%1', '');
                lvPayrollEntryLoans.SETFILTER("ED Code", '<>%1', '10000');
                IF lvPayrollEntryLoans.FINDFIRST THEN
                    REPEAT
                        lvGenJnlLine."Journal Batch Name" := gvBatchName;
                        lvGenJnlLine."Journal Template Name" := gvTemplateName;
                        lvLineNo := lvLineNo + 10;
                        lvGenJnlLine."Line No." := lvLineNo;
                        lvGenJnlLine."Document No." := gvAllowedPayrolls."Payroll Code" + '-' + gvPeriodID;
                        lvGenJnlLine."Document Type" := 0;
                        lvGenJnlLine.VALIDATE("Posting Date", gvPostingDate);
                        lvGenJnlLine.VALIDATE("Account Type", lvGenJnlLine."Account Type"::Vendor);
                        lvGenJnlLine.VALIDATE("Account No.", lvPayrollEntryLoans."Staff Vendor Entry");
                        lvGenJnlLine.VALIDATE("Currency Code", gvPostBuffer."Currency Code");
                        lvGenJnlLine."Currency Factor" := gvPostBuffer."Currency Factor";

                        //Reset VAT Fields
                        lvGenJnlLine."Gen. Posting Type" := lvGenJnlLine."Gen. Posting Type"::" ";
                        lvGenJnlLine."VAT Bus. Posting Group" := '';
                        lvGenJnlLine."VAT %" := 0;
                        lvGenJnlLine."VAT Prod. Posting Group" := '';
                        lvGenJnlLine."Gen. Bus. Posting Group" := '';
                        lvGenJnlLine."Gen. Prod. Posting Group" := '';
                        //end reset vat

                        lvGenJnlLine.VALIDATE(Amount, lvPayrollEntryLoans.Amount);
                        lvGenJnlLine.VALIDATE("Amount (LCY)", lvPayrollEntryLoans.Amount);

                        //IF gvPostBuffer."ED Code" <> '' THEN BEGIN
                        lvED.GET(lvPayrollEntryLoans."ED Code");
                        //  //cmm 161011 description shows Emp ID if setup is set - orginal code n {}
                        lvDescString := '';
                        IF lvPayrollSetup."Emp ID in Payroll Posting Jnl" THEN BEGIN
                            lvDescString := lvED.Description + '-' + gvPostBuffer."Employee No.";
                            IF STRLEN(lvDescString) > 50 THEN
                                lvGenJnlLine.Description := COPYSTR(lvDescString, STRLEN(lvDescString) - 49, 50)
                            ELSE
                                lvGenJnlLine.Description := lvDescString
                        END ELSE
                            lvGenJnlLine.Description := lvED.Description;
                        //end cmm
                        /*lvGenJnlLine.Description :=  lvED.Description; */
                        //cmm 161011 description shows Emp ID if setup is set - orginal code n {}
                        //END ELSE BEGIN
                        //  lvDescString:='';
                        //  IF lvPayrollSetup."Emp ID in Payroll Posting Jnl" THEN BEGIN
                        //    lvDescString:='Payroll Batch for ' + gvPeriodID + '-'+ gvPostBuffer."Employee No.";
                        //    IF STRLEN(lvDescString) > 50 THEN
                        //       lvGenJnlLine.Description := COPYSTR(lvDescString,STRLEN(lvDescString)-49,50)
                        //    ELSE
                        //    lvGenJnlLine.Description :=  lvDescString;
                        //  END ELSE lvGenJnlLine.Description :=  'Payroll Batch for ' + gvPeriodID;
                        //END;
                        //end cmm
                        /* END ELSE
                        lvGenJnlLine.Description :=  'Payroll Batch for ' + gvPeriodID;*/
                        lvGenJnlLine.INSERT;
                    UNTIL lvPayrollEntryLoans.NEXT = 0;
            UNTIL lvHdrLoan.NEXT = 0;
        //lvGenJnlLine."Dimension Set ID":= sCopyPayrollBufferDims(lvGenJnlLine, gvPostBuffer);//cmm 020813 new Dim NAV2013
        //IF lvGenJnlLine."Dimension Set ID" <> 0 THEN
        //DimMgt.UpdateGlobalDimFromDimSetID(lvGenJnlLine."Dimension Set ID",
        //lvGenJnlLine."Shortcut Dimension 1 Code",lvGenJnlLine."Shortcut Dimension 2 Code");  //cmm 020813 new Dim NAV2013
        lvGenJnlLine.MODIFY;   //cmm 020813
                               //END;
                               //ICS 28APR2017

        IF lvPayrollSetup."Auto-Post Payroll Journals" THEN lvGenjnlPost.RUN(lvGenJnlLine);

    end;

    procedure sCopyPayrollBufferDims(GenJournalLine: Record 81; PayrollBuffer: Record 51164): Integer
    var
        lvDimSetEntryTemp: Record 480 temporary;
        lvDimSetEntry: Record 480;
    begin
        //This sub copies dimensions from the payroll posting buffer to Journal Line Dimension

        gvPayrollDims.RESET;
        gvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
        gvPayrollDims.SETRANGE("Entry No", PayrollBuffer."Buffer No");
        gvPayrollDims.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        IF gvPayrollDims.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT
                //cmm 020813 new dimensions impl. NAV2013
                lvDimSetEntryTemp.INIT;
                lvDimSetEntryTemp.VALIDATE("Dimension Code", gvPayrollDims."Dimension Code");
                lvDimSetEntryTemp.VALIDATE("Dimension Value Code", gvPayrollDims."Dimension Value Code");
                lvDimSetEntryTemp.INSERT(TRUE);
            //end cmm
            /*
            //clear any default dims from account
            lvJournalLineDimension.SETRANGE("Table ID", DATABASE::"Gen. Journal Line");
            lvJournalLineDimension.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
            lvJournalLineDimension.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
            lvJournalLineDimension.SETRANGE("Journal Line No.", GenJournalLine."Line No.");
            lvJournalLineDimension.SETRANGE("Allocation Line No.", 0);
            lvJournalLineDimension.SETRANGE("Dimension Code", gvPayrollDims."Dimension Code");
            lvJournalLineDimension.DELETEALL(TRUE);
            //end clear
        
            //Insert dims from payroll
            lvJournalLineDimension."Table ID" := DATABASE::"Gen. Journal Line";
            lvJournalLineDimension."Journal Template Name" := GenJournalLine."Journal Template Name";
            lvJournalLineDimension."Journal Batch Name" := GenJournalLine."Journal Batch Name";
            lvJournalLineDimension."Journal Line No." := GenJournalLine."Line No.";
            lvJournalLineDimension.VALIDATE("Dimension Code", gvPayrollDims."Dimension Code");
            lvJournalLineDimension.VALIDATE("Dimension Value Code", gvPayrollDims."Dimension Value Code");
            lvJournalLineDimension.INSERT(TRUE);
            */
            UNTIL gvPayrollDims.NEXT = 0;
            EXIT(DimMgt.GetDimensionSetID(lvDimSetEntryTemp)); //new dimension impl. NAV2013 CMM 020813
        END ELSE
            EXIT(0);

    end;

    procedure sDeleteEntry()
    var
        Entry: Record 51161;
    begin
        Entry.LOCKTABLE(TRUE);
        Entry.SETCURRENTKEY("Payroll ID", "Employee No.");
        Entry.SETRANGE("Payroll ID", gvPeriodID);
        Entry.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        Entry.DELETEALL;
    end;

    procedure sDeleteLumpSumPayments()
    var
        lvLumpsumPayments: Record 51168;
        lvPayrollEntry: Record 51161;
    begin
        //Clear lump sum payments already paid
        lvLumpsumPayments.SETFILTER("Linked Payroll Entry No", '<>0');
        lvLumpsumPayments.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        IF lvLumpsumPayments.FIND('-') THEN
            REPEAT
                IF NOT lvPayrollEntry.GET(lvLumpsumPayments."Linked Payroll Entry No") THEN lvLumpsumPayments.DELETE
            UNTIL lvLumpsumPayments.NEXT = 0;
    end;

    procedure "---V.6.1.65 ----"()
    begin
    end;

    procedure sWriteToGenJnlLinesForPayment(var lvLines: Record 51160)
    var
        lvPayrollSetup: Record 51165;
        lvGenJnlLine: Record 81;
        lvLineNo: Integer;
        lvED: Record 51158;
        lvEmp: Record 5200;
        lvPPSetup: Record 51157;
    begin
        lvPayrollSetup.GET(lvLines."Payroll Code");
        IF lvPayrollSetup."Personal Account Recoveries ED" = lvLines."ED Code" THEN BEGIN
            IF gvPostBuffer.Amount <> 0 THEN BEGIN
                gvWindowCounter := gvWindowCounter + 1;
                gvWindow.UPDATE(2, gvWindowCounter);

                lvGenJnlLine."Journal Batch Name" := gvBatchName;
                lvGenJnlLine."Journal Template Name" := 'CASHRCPT';
                gvLineNo += 10;
                lvGenJnlLine."Line No." := gvLineNo;
                lvGenJnlLine."Document Type" := lvGenJnlLine."Document Type"::Payment;
                lvGenJnlLine."Document No." := gvAllowedPayrolls."Payroll Code" + '-' + gvPeriodID;
                lvGenJnlLine.VALIDATE("Posting Date", gvPostingDate);
                lvGenJnlLine.VALIDATE("Account Type", lvGenJnlLine."Account Type"::Customer);

                CLEAR(lvEmp);
                lvEmp.GET(lvLines."Employee No.");
                lvGenJnlLine.VALIDATE("Account No.", lvEmp."Customer No.");

                lvGenJnlLine.VALIDATE("Currency Code", gvPostBuffer."Currency Code");
                lvGenJnlLine."Currency Factor" := gvPostBuffer."Currency Factor";

                //Reset VAT Fields
                lvGenJnlLine."Gen. Posting Type" := lvGenJnlLine."Gen. Posting Type"::" ";
                lvGenJnlLine."VAT Bus. Posting Group" := '';
                lvGenJnlLine."VAT %" := 0;
                lvGenJnlLine."VAT Prod. Posting Group" := '';
                lvGenJnlLine."Gen. Bus. Posting Group" := '';
                lvGenJnlLine."Gen. Prod. Posting Group" := '';
                //end reset vat

                lvGenJnlLine.VALIDATE(Amount, -lvLines.Amount);
                lvGenJnlLine.VALIDATE("Amount (LCY)", -lvLines."Amount (LCY)");
                lvGenJnlLine."Bal. Account Type" := 0;

                lvPPSetup.RESET;
                lvPPSetup.SETRANGE(lvPPSetup."Posting Group", lvLines."Posting Group");
                lvPPSetup.SETRANGE(lvPPSetup."ED Posting Group", lvLines."ED Code");
                IF lvPPSetup.FINDFIRST THEN
                    lvGenJnlLine."Bal. Account No." := lvPPSetup."Debit Account";

                IF gvPostBuffer."ED Code" <> '' THEN BEGIN
                    lvED.GET(lvLines."ED Code");
                    lvGenJnlLine.Description := lvED.Description;
                END ELSE
                    lvGenJnlLine.Description := 'Payroll Batch for ' + gvPeriodID;
                lvGenJnlLine.INSERT;
            END;
        END;
    end;

    procedure "==TestCalculated"()
    begin
    end;

    procedure TestCalculated(PayrollPeriod: Code[10]): Boolean
    var
        Header: Record 51159;
    begin
        gvPayrollUtilities2.sGetActivePayroll(gvAllowedPayrolls2);
        Header.SETRANGE("Payroll ID", PayrollPeriod);
        Header.SETRANGE(Calculated, FALSE);
        Header.SETRANGE("Payroll Code", gvAllowedPayrolls2."Payroll Code");
        IF Header.FIND('-') THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
    end;

    procedure "==PayrollUtilities"()
    begin
    end;

    procedure sGetActivePayroll(var AllowedPayrolls: Record 51182)
    var
        lvActiveSession: Record 2000000110;
    begin
        //SKM 260506 This sub retieve the authorized payroll that the current db user is logged to

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;

        AllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        AllowedPayrolls.SETRANGE("User ID", USERID);
        AllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF NOT AllowedPayrolls.FINDFIRST THEN ERROR('You are not allowed access to any payroll dataset.');
    end;

    procedure sGetDefaultEmpDims(PayrollHdr: Record 51159)
    var
        lvPayrollDim: Record 51184;
        lvDefaultDim: Record 352;
    begin
        //skm 300506
        //This function copies default dimensions from the Employee to the Payroll Header table

        lvDefaultDim.SETRANGE("Table ID", DATABASE::Employee);
        lvDefaultDim.SETRANGE("No.", PayrollHdr."Employee no.");
        IF lvDefaultDim.FINDFIRST THEN
            REPEAT
                lvPayrollDim."Table ID" := DATABASE::"Payroll Header";
                lvPayrollDim."Payroll ID" := PayrollHdr."Payroll ID";
                lvPayrollDim."Employee No" := lvDefaultDim."No.";
                lvPayrollDim."Dimension Code" := lvDefaultDim."Dimension Code";
                lvPayrollDim."Dimension Value Code" := lvDefaultDim."Dimension Value Code";
                lvPayrollDim."Payroll Code" := PayrollHdr."Payroll Code";
                lvPayrollDim.INSERT
            UNTIL lvDefaultDim.NEXT = 0
    end;

    procedure sGetDefaultEDDims(PayrollEntry: Record 51161)
    var
        lvPayrollDim: Record 51184;
        lvDefaultDim: Record 352;
    begin
        //skm 300506
        //This function copies default dimensions from the ED to the Payroll Entry table

        lvDefaultDim.SETRANGE("Table ID", DATABASE::"ED Definitions");
        lvDefaultDim.SETRANGE("No.", PayrollEntry."ED Code");
        IF lvDefaultDim.FINDFIRST THEN
            REPEAT
                lvPayrollDim."Table ID" := DATABASE::"Payroll Entry";
                lvPayrollDim."Payroll ID" := PayrollEntry."Payroll ID";
                lvPayrollDim."Employee No" := PayrollEntry."Employee No.";
                lvPayrollDim."Entry No" := PayrollEntry."Entry No.";
                lvPayrollDim."ED Code" := PayrollEntry."ED Code";
                lvPayrollDim."Dimension Code" := lvDefaultDim."Dimension Code";
                lvPayrollDim."Dimension Value Code" := lvDefaultDim."Dimension Value Code";
                lvPayrollDim."Payroll Code" := PayrollEntry."Payroll Code";
                lvPayrollDim.INSERT
            UNTIL lvDefaultDim.NEXT = 0
    end;

    procedure sGetDefaultEDDims2(PayrollLine: Record 51160)
    var
        lvPayrollDim: Record 51184;
        lvDefaultDim: Record 352;
    begin
        //skm 060606
        //This function copies default dimensions from the ED to the Payroll Line table

        lvDefaultDim.SETRANGE("Table ID", DATABASE::"ED Definitions");
        lvDefaultDim.SETRANGE("No.", PayrollLine."ED Code");
        IF lvDefaultDim.FINDFIRST THEN
            REPEAT
                lvPayrollDim."Table ID" := DATABASE::"Payroll Lines";
                lvPayrollDim."Payroll ID" := PayrollLine."Payroll ID";
                lvPayrollDim."Employee No" := PayrollLine."Employee No.";
                lvPayrollDim."Entry No" := PayrollLine."Entry No.";
                lvPayrollDim."ED Code" := PayrollLine."ED Code";
                lvPayrollDim."Dimension Code" := lvDefaultDim."Dimension Code";
                lvPayrollDim."Dimension Value Code" := lvDefaultDim."Dimension Value Code";
                lvPayrollDim."Payroll Code" := PayrollLine."Payroll Code";
                lvPayrollDim.INSERT
            UNTIL lvDefaultDim.NEXT = 0
    end;

    procedure sDeleteDefaultEmpDims(PayrollHdr: Record 51159)
    var
        lvPayrollDim: Record 51184;
    begin
        //skm 310506
        //This function deletes payroll dimensions assigned to a payroll header

        //lvPayrollDim.SETRANGE("Table ID", DATABASE::"Payroll Header"); skm20110316, delete even those for the payroll lines and payroll en
        lvPayrollDim.SETRANGE("Employee No", PayrollHdr."Employee no.");
        lvPayrollDim.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
        lvPayrollDim.DELETEALL;
    end;

    procedure sDeleteDefaultEDDims(PayrollEntry: Record 51161)
    var
        lvPayrollDim: Record 51184;
    begin
        //skm 310506
        //This function deletes payroll dimensions assigned to a payroll entry

        lvPayrollDim.SETRANGE("Table ID", DATABASE::"Payroll Entry");
        lvPayrollDim.SETRANGE("Employee No", PayrollEntry."Employee No.");
        lvPayrollDim.SETRANGE("Payroll ID", PayrollEntry."Payroll ID");
        lvPayrollDim.SETRANGE("Entry No", PayrollEntry."Entry No.");
        lvPayrollDim.SETRANGE("ED Code", PayrollEntry."ED Code");
        lvPayrollDim.DELETEALL;
    end;

    procedure sDeletePayrollLineDims(PayrollLine: Record 51160)
    var
        lvPayrollDim: Record 51184;
    begin
        //skm 060606
        //This function deletes payroll dimensions assigned to a payroll line

        lvPayrollDim.SETRANGE("Table ID", DATABASE::"Payroll Lines");
        lvPayrollDim.SETRANGE("Employee No", PayrollLine."Employee No.");
        lvPayrollDim.SETRANGE("Payroll ID", PayrollLine."Payroll ID");
        lvPayrollDim.SETRANGE("Entry No", PayrollLine."Entry No.");
        lvPayrollDim.SETRANGE("ED Code", PayrollLine."ED Code");
        lvPayrollDim.DELETEALL;
    end;

    procedure sDeletePostingBufferDims(PayrollPostingBuffer: Record 51164)
    var
        lvPayrollDim: Record 51184;
    begin
        //skm 060606
        //This function deletes payroll dimensions assigned to a payroll posting buffer entry

        lvPayrollDim.SETRANGE("Table ID", DATABASE::"Payroll Posting Buffer");
        lvPayrollDim.SETRANGE("Entry No", PayrollPostingBuffer."Buffer No");
        lvPayrollDim.DELETEALL;
    end;

    procedure sCopyDimsFromEntryToLines(PayrollEntry: Record 51161; PayrollLine: Record 51160)
    var
        lvFromPayrollDim: Record 51184;
        lvToPayrollDim: Record 51184;
    begin
        //skm 060606 this function copies dimensions assigned to the payroll entry to the payroll line
        //associated to the payroll entry when payroll is calculated.

        lvFromPayrollDim.SETRANGE("Table ID", DATABASE::"Payroll Entry");
        lvFromPayrollDim.SETRANGE("Payroll ID", PayrollEntry."Payroll ID");
        lvFromPayrollDim.SETRANGE("Employee No", PayrollEntry."Employee No.");
        lvFromPayrollDim.SETRANGE("Entry No", PayrollEntry."Entry No.");
        lvFromPayrollDim.SETRANGE("ED Code", PayrollEntry."ED Code");
        IF lvFromPayrollDim.FINDFIRST THEN
            REPEAT
                lvToPayrollDim.COPY(lvFromPayrollDim);
                lvToPayrollDim."Table ID" := DATABASE::"Payroll Lines";
                lvToPayrollDim."Entry No" := PayrollLine."Entry No.";
                lvToPayrollDim.INSERT;
            UNTIL lvFromPayrollDim.NEXT = 0
    end;

    procedure sCopyDimsFromLineToLine(FromPayrollLine: Record 51160; ToPayrollLine: Record 51160)
    var
        lvFromPayrollDim: Record 51184;
        lvToPayrollDim: Record 51184;
    begin
        //skm 060606 this function copies dimensions assigned to the payroll line to another payroll line

        lvFromPayrollDim.SETRANGE("Table ID", DATABASE::"Payroll Lines");
        lvFromPayrollDim.SETRANGE("Payroll ID", FromPayrollLine."Payroll ID");
        lvFromPayrollDim.SETRANGE("Employee No", FromPayrollLine."Employee No.");
        lvFromPayrollDim.SETRANGE("Entry No", FromPayrollLine."Entry No.");
        lvFromPayrollDim.SETRANGE("ED Code", FromPayrollLine."ED Code");
        IF lvFromPayrollDim.FINDFIRST THEN
            REPEAT
                lvToPayrollDim.COPY(lvFromPayrollDim);
                lvToPayrollDim."Entry No" := ToPayrollLine."Entry No.";
                lvToPayrollDim.INSERT;
            UNTIL lvFromPayrollDim.NEXT = 0
    end;

    procedure fGetEmplyeeLoanAccount(pEmployee: Record 5200; pLoanType: Record 51178): Code[20]
    var
        lvEmpCustLoanLink: Record 51185;
    begin
        //Pick customer loan account from Employee-Loan Type Matrix if any
        lvEmpCustLoanLink.SETRANGE("Employee No", pEmployee."No.");
        lvEmpCustLoanLink.SETRANGE("Loan Type", pLoanType.Code);
        IF lvEmpCustLoanLink.FINDFIRST THEN EXIT(lvEmpCustLoanLink."Customer No");

        //Pick From Employee Card
        IF pEmployee."Customer No." <> '' THEN EXIT(pEmployee."Customer No.");

        //Lastly pick from Loan Type
        IF (pLoanType."Loan Accounts Type" = pLoanType."Loan Accounts Type"::Customer) AND
           (pLoanType."Loan Account" <> '') THEN
            EXIT(pLoanType."Loan Account");

        ERROR('Customer Loan A/C is missing in ALL three possible sources:\' +
              '1. Employee Customer Loan Link\' +
              '2. Customer No on the Payroll tab of the Employee Card\' +
              '3. Loan Types\\' +
              'For Employee %1, Loan Type %2', pEmployee."No.", pLoanType.Code)
    end;

    procedure sAllocatePayroll(pPeriodID: Code[10]; pPayrollCode: Code[10]; pEmpNo: Code[20])
    var
        lvAllocationMatrix: Record 51188;
        lvPayrollLineToAllocate: Record 51160;
        lvPayrollLineAllocated: Record 51160;
        lvPayrollDims: Record 51184;
        lvPreviousEntryNo: Integer;
        lvDefaultDimension: Record 352;
        lvPeriod: Record 51151;
        lvPayrollSetup: Record 51165;
    begin
        //skm060706 this sub alloactes payroll as per alloaction criteria of each employee
        //called by calculate payroll code units.

        //cmm 020813 VSF PAY1 - variable allocations per month
        lvPayrollSetup.GET(pPayrollCode);
        lvPeriod.RESET;
        lvPeriod.SETRANGE("Period ID", pPeriodID);
        lvPeriod.SETRANGE("Payroll Code", pPayrollCode);
        lvPeriod.FINDFIRST;
        lvPeriod.TESTFIELD("Start Date");
        lvPeriod.TESTFIELD("End Date");
        //end cmm

        //skm20110317 - AAFH payroll posting buffer dimensions are incorrect if both payroll expense and employee dims are specified. Block.
        lvAllocationMatrix.SETCURRENTKEY("Employee No");
        lvAllocationMatrix.SETRANGE("Employee No", pEmpNo);

        //cmm 050913 VSF PAY 1
        IF lvAllocationMatrix.FINDFIRST THEN BEGIN
            IF lvPayrollSetup."Payroll Expense Based On" = lvPayrollSetup."Payroll Expense Based On"::" " THEN
                ERROR('You must specify Payroll Expense Based in Payroll Setup for Payroll Code %1', pPayrollCode);
            IF lvPayrollSetup."Payroll Expense Based On" = lvPayrollSetup."Payroll Expense Based On"::Month THEN
                lvAllocationMatrix.SETRANGE("Posting Date", lvPeriod."Start Date", lvPeriod."End Date");
        END;
        //end cmm

        IF lvAllocationMatrix.FINDFIRST THEN BEGIN
            lvDefaultDimension.SETRANGE("Table ID", DATABASE::Employee);
            lvDefaultDimension.SETRANGE("No.", pEmpNo);
            IF lvDefaultDimension.FINDFIRST THEN
                ERROR('Employee %1: Both Employee Dimensions and Payroll Expense Allocations are not supported at the same time. ' +
                  'Delete either the Employee Dimensions or Payroll Expense Allocations for this employee and try again.', pEmpNo);

            lvPayrollDims.SETRANGE("Table ID", DATABASE::"Payroll Header");
            lvPayrollDims.SETRANGE("Payroll ID", pPeriodID);
            lvPayrollDims.SETRANGE("Employee No", pEmpNo);
            IF lvPayrollDims.FINDFIRST THEN
                ERROR('Employee %1: Both Payroll Header Dimensions and Payroll Expense Allocations are not supported at the same time. ' +
                  'Delete either the Payroll Header Dimensions or Payroll Expense Allocations for this employee and try again.', pEmpNo);
        END;

        lvPayrollDims.RESET;
        lvAllocationMatrix.RESET;
        //skm end

        IF lvPayrollLineToAllocate.FINDLAST THEN lvPreviousEntryNo := lvPayrollLineToAllocate."Entry No.";

        lvPayrollLineToAllocate.SETCURRENTKEY("Payroll ID", "Employee No.", "ED Code");
        lvPayrollLineToAllocate.SETRANGE("Payroll ID", pPeriodID);
        lvPayrollLineToAllocate.SETRANGE("Employee No.", pEmpNo);
        lvPayrollLineToAllocate.SETRANGE("Payroll Code", pPayrollCode);
        lvPayrollLineToAllocate.SETFILTER("Entry No.", '<=%1', lvPreviousEntryNo);

        lvAllocationMatrix.SETCURRENTKEY("Employee No", "ED Code");
        IF lvPayrollLineToAllocate.FINDFIRST THEN
            REPEAT
                lvAllocationMatrix.SETRANGE("Employee No", pEmpNo);
                lvAllocationMatrix.SETRANGE("ED Code", lvPayrollLineToAllocate."ED Code");
                IF lvPayrollSetup."Payroll Expense Based On" = lvPayrollSetup."Payroll Expense Based On"::Month THEN
                    lvAllocationMatrix.SETRANGE("Posting Date", lvPeriod."Start Date", lvPeriod."End Date");   //cmm 020813 VSF PAY1
                IF lvAllocationMatrix.FINDFIRST THEN BEGIN
                    REPEAT
                        //Allocate Payroll Line
                        lvPayrollLineAllocated.COPY(lvPayrollLineToAllocate);
                        lvPreviousEntryNo += 1;
                        lvPayrollLineAllocated."Entry No." := lvPreviousEntryNo;
                        lvPayrollLineAllocated.Amount :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate.Amount, 0.01);
                        lvPayrollLineAllocated."Amount (LCY)" :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate."Amount (LCY)", 0.01);
                        lvPayrollLineAllocated.Quantity :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate.Quantity, 0.01);
                        lvPayrollLineAllocated.Rate :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate.Rate, 0.01);
                        lvPayrollLineAllocated.Interest :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate.Interest, 0.01);
                        lvPayrollLineAllocated.Repayment :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate.Repayment, 0.01);
                        //skm20110715 fix error on loan allocation, reported by AAFH. The following loan fields were not being allocated
                        lvPayrollLineAllocated."Interest (LCY)" :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate."Interest (LCY)", 0.01);
                        lvPayrollLineAllocated."Repayment (LCY)" :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate."Repayment (LCY)", 0.01);
                        lvPayrollLineAllocated."Remaining Debt (LCY)" :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate."Remaining Debt (LCY)", 0.01);
                        lvPayrollLineAllocated."Paid (LCY)" :=
                          ROUND(lvAllocationMatrix.Allocated / 100 * lvPayrollLineToAllocate."Paid (LCY)", 0.01);
                        //skm end
                        lvPayrollLineAllocated.INSERT;

                        //Assign Payroll Line Dims from Allocation table
                        lvPayrollDims."Table ID" := DATABASE::"Payroll Lines";
                        lvPayrollDims."Payroll ID" := pPeriodID;
                        lvPayrollDims."Employee No" := lvPayrollLineToAllocate."Employee No.";
                        lvPayrollDims."Entry No" := lvPreviousEntryNo;
                        lvPayrollDims."ED Code" := lvPayrollLineToAllocate."ED Code";
                        lvPayrollDims."Dimension Code" := lvAllocationMatrix."Dimension Code1";
                        lvPayrollDims."Dimension Value Code" := lvAllocationMatrix."Dimension Value Code1";
                        lvPayrollDims."Payroll Code" := pPayrollCode;
                        lvPayrollDims.INSERT;
                        IF lvAllocationMatrix."Dimension Value Code2" <> '' THEN BEGIN
                            lvPayrollDims."Dimension Code" := lvAllocationMatrix."Dimension Code2";
                            lvPayrollDims."Dimension Value Code" := lvAllocationMatrix."Dimension Value Code2";
                            lvPayrollDims.INSERT;
                        END;
                        IF lvAllocationMatrix."Dimension Value Code3" <> '' THEN BEGIN
                            lvPayrollDims."Dimension Code" := lvAllocationMatrix."Dimension Code3";
                            lvPayrollDims."Dimension Value Code" := lvAllocationMatrix."Dimension Value Code3";
                            lvPayrollDims.INSERT;
                        END;
                        IF lvAllocationMatrix."Dimension Value Code4" <> '' THEN BEGIN
                            lvPayrollDims."Dimension Code" := lvAllocationMatrix."Dimension Code4";
                            lvPayrollDims."Dimension Value Code" := lvAllocationMatrix."Dimension Value Code4";
                            lvPayrollDims.INSERT;
                        END;
                        //CSM extra dimensions Added for Ticket 45 08122011
                        IF lvAllocationMatrix."Dimension Value Code5" <> '' THEN BEGIN
                            lvPayrollDims."Dimension Code" := lvAllocationMatrix."Dimension Code5";
                            lvPayrollDims."Dimension Value Code" := lvAllocationMatrix."Dimension Value Code5";
                            lvPayrollDims.INSERT;
                        END;
                        IF lvAllocationMatrix."Dimension Value Code6" <> '' THEN BEGIN
                            lvPayrollDims."Dimension Code" := lvAllocationMatrix."Dimension Code6";
                            lvPayrollDims."Dimension Value Code" := lvAllocationMatrix."Dimension Value Code6";
                            lvPayrollDims.INSERT;
                        END;
                        IF lvAllocationMatrix."Dimension Value Code7" <> '' THEN BEGIN
                            lvPayrollDims."Dimension Code" := lvAllocationMatrix."Dimension Code7";
                            lvPayrollDims."Dimension Value Code" := lvAllocationMatrix."Dimension Value Code7";
                            lvPayrollDims.INSERT;
                        END;
                        IF lvAllocationMatrix."Dimension Value Code8" <> '' THEN BEGIN
                            lvPayrollDims."Dimension Code" := lvAllocationMatrix."Dimension Code8";
                            lvPayrollDims."Dimension Value Code" := lvAllocationMatrix."Dimension Value Code8";
                            lvPayrollDims.INSERT;
                        END;
                    //End CSM
                    UNTIL lvAllocationMatrix.NEXT = 0;

                    lvPayrollLineToAllocate.DELETE(TRUE);
                END;
            UNTIL lvPayrollLineToAllocate.NEXT = 0;
    end;

    procedure gfShortUserID(var UserID: Text[100]): Code[20]
    var
        lvUserID: Code[50];
    begin
        //skm2200409 AA Timesheets, return a short user id from a windows login
        IF STRPOS(UserID, '\') IN [0, STRLEN(UserID)] THEN
            IF STRLEN(UserID) <= 20 THEN BEGIN
                EVALUATE(lvUserID, UserID);
                EXIT(lvUserID)
            END ELSE
                EXIT('')
        ELSE BEGIN
            EVALUATE(lvUserID, COPYSTR(UserID, STRPOS(UserID, '\') + 1, 20));
            EXIT(lvUserID);
        END;
    end;

    procedure gsAssignPayrollCode() "Payroll Code": Code[10]
    var
        lvAllowedPayrolls: Record 51182;
        lvActiveSession: Record 2000000110;
    begin
        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;

        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF lvAllowedPayrolls.FINDFIRST THEN
            EXIT(lvAllowedPayrolls."Payroll Code");
    end;
}


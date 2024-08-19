page 51189 "Pay Off Loan"
{
    PageType = List;
    Permissions = TableData 51159 = rimd,
                  TableData 51161 = rimd,
                  TableData 51172 = rimd;
    SourceTable = 51172;
    SourceTableView = SORTING("No.", "Loan ID")
                      WHERE(Posted = FILTER(False));

    layout
    {
        area(content)
        {
            field(PayOffCode; PayOffCode)
            {
                Caption = '"Payment Type"';
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    IF ACTION::LookupOK = PAGE.RUNMODAL(0, LoanPaymentRec) THEN
                        PayOffCode := LoanPaymentRec.Code;
                end;
            }
            repeater(r)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Remaining Debt"; Rec."Remaining Debt")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Pay Off")
            {
                Caption = 'Pay Off';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    lvEmployee: Record 5200;
                begin
                    IF PayOffCode = '' THEN ERROR('There must be a Payment Code');

                    IF NOT CONFIRM('Do you realy want to Pay Off This loan', FALSE) THEN EXIT;

                    LoanEntryRecTmp.COPY(Rec);
                    LoanEntryRecTmp.Interest := 0;
                    LoanEntryRecTmp.Repayment := Rec."Remaining Debt" + Rec.Repayment;
                    LoanEntryRecTmp."Transfered To Payroll" := TRUE;
                    LoanEntryRecTmp."Remaining Debt" := 0;
                    LoanEntryRecTmp.Posted := TRUE;
                    LoanEntryRecTmp.INSERT;

                    Rec.SETFILTER("No.", '>=%1', LoanEntryRecTmp."No.");
                    Rec.DELETEALL;

                    Rec.COPY(LoanEntryRecTmp);
                    Rec.INSERT;

                    Rec.GET(LoanEntryRecTmp."No.", LoanEntryRecTmp."Loan ID");

                    LoanPaymentRec.GET(PayOffCode);
                    LoanPaymentRec.TESTFIELD("Account No.");

                    Loansetup.GET(Rec."Payroll Code");
                    Loansetup.TESTFIELD(Loansetup."Loan Template");
                    Loansetup.TESTFIELD("Loan Payments Batch");

                    LoansRec.GET(Rec."Loan ID");
                    IF NOT LoansRec."Paid to Employee" THEN ERROR('The Loan is not paid out to Employee');
                    LoanTypeRec.GET(LoansRec."Loan Types");
                    lvEmployee.GET(Rec.Employee);

                    TemplateName := Loansetup."Loan Template";
                    BatchName := Loansetup."Loan Payments Batch";

                    GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
                    GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
                    IF GenJnlLine.FIND('+') THEN
                        LineNo := GenJnlLine."Line No."
                    ELSE
                        LineNo := 0;

                    GenJnlLine."Journal Batch Name" := BatchName;
                    GenJnlLine."Journal Template Name" := TemplateName;
                    LineNo := LineNo + 10000;
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Document No." := STRSUBSTNO('%1', Rec."Loan ID");
                    GenJnlLine."Posting Date" := WORKDATE;

                    CASE LoanTypeRec."Loan Accounts Type" OF
                        LoanTypeRec."Loan Accounts Type"::"G/L Account":
                            BEGIN
                                LoanTypeRec.TESTFIELD("Loan Account");
                                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                                GenJnlLine.VALIDATE("Account No.", LoanTypeRec."Loan Account");
                            END;

                        LoanTypeRec."Loan Accounts Type"::Customer:
                            BEGIN
                                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                                GenJnlLine.VALIDATE("Account No.", gvPayrollUtilities.fGetEmplyeeLoanAccount(lvEmployee, LoanTypeRec));
                            END;

                        LoanTypeRec."Loan Accounts Type"::Vendor:
                            BEGIN
                                LoanTypeRec.TESTFIELD("Loan Account");
                                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                                GenJnlLine.VALIDATE("Account No.", LoanTypeRec."Loan Account");
                            END;
                    END; //Case

                    GenJnlLine.Description := STRSUBSTNO('Pay off Loan %1', Rec."Loan ID");
                    GenJnlLine.VALIDATE("Currency Code", LoansRec."Currency Code");
                    GenJnlLine.VALIDATE(Amount, -Rec.Repayment);
                    IF LoanPaymentRec."Account Type" = LoanPaymentRec."Account Type"::"G/L Account" THEN
                        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account")
                    ELSE
                        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Bal. Account No.", LoanPaymentRec."Account No.");
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", lvEmployee."Global Dimension 1 Code");
                    GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", lvEmployee."Global Dimension 2 Code");
                    GenJnlLine.UpdateLineBalance;
                    GenJnlLine.INSERT;

                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //gsSegmentPayrollData;
        //IF FIND('-') THEN;
    end;

    var
        LoanEntryRecTmp: Record 51172 temporary;
        GenJnlLine: Record 81;
        Loansetup: Record 51165;
        LoanTypeRec: Record 51178;
        LoansRec: Record 51171;
        LoanPaymentRec: Record 51179;
        TemplateName: Code[10];
        BatchName: Code[10];
        LineNo: Integer;
        PayOffCode: Code[20];
        gvPayrollUtilities: Codeunit 51152;

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin
        /*lvSession.SETRANGE("My Session", TRUE);
        lvSession.FINDFIRST; //fire error in absence of a login
        IF lvSession."Login Type" = lvSession."Login Type"::Database THEN
          lvAllowedPayrolls.SETRANGE("User ID", USERID)
        ELSE*/

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF lvAllowedPayrolls.FINDFIRST THEN
            Rec.SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
            ERROR('You are not allowed access to this payroll dataset.');
        Rec.FILTERGROUP(100);

    end;
}


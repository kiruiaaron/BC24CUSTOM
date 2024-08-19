report 50015 "Bank Acc ReconciliationTest"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Bank Acc ReconciliationTest.rdlc';

    dataset
    {
        dataitem("Bank Acc. Reconciliation"; 273)
        {
            column(BankAccNo; "Bank Acc. Reconciliation"."Bank Account No.")
            {
            }
            column(StmtNo; "Bank Acc. Reconciliation"."Statement No.")
            {
            }
            column(StmtBal; "Bank Acc. Reconciliation"."Statement Ending Balance")
            {
            }
            column(BankName; BankAccName)
            {
            }
            column(StmtDate; "Bank Acc. Reconciliation"."Statement Date")
            {
            }
            column(CashBookBal; CashBookBal)
            {
            }
            column(RecMsg; RecMsg)
            {
            }
            column(TotalUncreditedChqs; TotalUncreditedChqs)
            {
            }
            column(TotalUnpresentedChqs; TotalUnpresentedChqs)
            {
            }
            column(Pic; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            dataitem(BankRec; 50023)
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."),
                               "Statement No." = FIELD("Statement No.");
                column(DocNo; BankRec."Document No.")
                {
                }
                column(Amount; BankRec.Difference)
                {
                }
                column(Description; BankRec.Description)
                {
                }
                column(ChequeNo; BankRec."Check No.")
                {
                }
                column(PostingDate; BankRec."Transaction Date")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                BankAccount.RESET;
                BankAccount.SETRANGE(BankAccount."No.", "Bank Acc. Reconciliation"."Bank Account No.");
                IF BankAccount.FINDSET THEN BEGIN
                    BankAccName := BankAccount.Name;
                END;

                BankAccount.RESET;
                BankAccount.SETRANGE(BankAccount."No.", "Bank Acc. Reconciliation"."Bank Account No.");
                IF BankAccount.FINDFIRST THEN BEGIN
                END;

                CashBookBal := 0;
                BankEntries.RESET;
                BankEntries.SETRANGE(BankEntries."Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                BankEntries.SETRANGE(BankEntries."Posting Date", 0D, "Bank Acc. Reconciliation"."Statement Date");
                IF BankEntries.FINDSET THEN BEGIN
                    REPEAT
                        CashBookBal := CashBookBal + BankEntries.Amount;
                    UNTIL BankEntries.NEXT = 0;
                END;

                TotalUncreditedChqs := 0;
                TotalUnpresentedChqs := 0;
                BankRecLine.RESET;
                BankRecLine.SETRANGE(BankRecLine."Bank Account No.", "Bank Account No.");
                BankRecLine.SETRANGE(BankRecLine."Statement Type", "Statement Type");
                BankRecLine.SETRANGE(BankRecLine."Statement No.", "Statement No.");
                BankRecLine.SETFILTER(BankRecLine.Difference, '<>%1', 0);
                IF BankRecLine.FINDSET THEN BEGIN
                    REPEAT
                        IF BankRecLine.Difference > 0 THEN BEGIN
                            //UncreditedChqs
                            TotalUncreditedChqs := TotalUncreditedChqs + BankRecLine.Difference;
                        END ELSE BEGIN
                            //UnpresentedChqs
                            TotalUnpresentedChqs := TotalUnpresentedChqs + BankRecLine.Difference;
                        END;
                    UNTIL BankRecLine.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
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
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
    end;

    var
        DefinedBankNo: Code[10];
        DefinedStatementNo: Code[10];
        CashBookBal: Decimal;
        BankStatBalance: Decimal;
        BankAccount: Record 270;
        BankRecHdr: Record 273;
        BankRecLine: Record 50023;
        TotalDifference: Decimal;
        TotalUncreditedChqs: Decimal;
        TotalUnpresentedChqs: Decimal;
        BankAccNo: Code[10];
        BankAccName: Text[50];
        BankRecLineDiff: Record 274;
        BankRecCash: Record 273;
        RecMsg: Text[250];
        BancRecReconciled: Record 274;
        TotalReconciled: Decimal;
        LastStatBal: Decimal;
        DiffBal: Decimal;
        CompanyInfo: Record 79;
        BankEntries: Record 271;
        BankRecLineNew: Record 274;
        PeriodStart: Date;
        PeriodEnd: Date;
}


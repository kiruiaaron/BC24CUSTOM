report 50020 "Vote Book"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Vote Book.rdlc';

    dataset
    {
        dataitem("G/L Account"; 15)
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            column(AccNo; "G/L Account"."No.")
            {
            }
            column(AccName; "G/L Account".Name)
            {
            }
            column(IncomeBalance; "G/L Account"."Income/Balance")
            {
            }
            column(DebitAmt; "G/L Account"."Debit Amount")
            {
            }
            column(CreditAmt; "G/L Account"."Credit Amount")
            {
            }
            column(BDAmt; "G/L Account"."Budgeted Debit Amount")
            {
            }
            column(CDAmt; "G/L Account"."Budgeted Credit Amount")
            {
            }
            column(AccBalance; "G/L Account".Balance)
            {
            }
            column(BudgetedAmt; "G/L Account"."Budgeted Amount")
            {
            }
            column(Logo; CompInf.Picture)
            {
            }
            column(ActualExpenditure; ActualExpenditure)
            {
            }
            column(TotalCommitment; TotalCommitment)
            {
            }
            column(BudgetedAmount; BudgetedAmount)
            {
            }
            column(TotalCommAct; TotalCommAct)
            {
            }
            column(Balance; Balance)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(BudgetedAmount);
                CLEAR(TotalCommitment);
                CLEAR(ActualExpenditure);
                CLEAR(TotalCommAct);
                CLEAR(Balance);

                BudgetEntry.RESET;
                BudgetEntry.SETRANGE(BudgetEntry."Budget Name", BudgetCode);
                BudgetEntry.SETRANGE(BudgetEntry."G/L Account No.", "G/L Account"."No.");
                IF BudgetEntry.FINDFIRST THEN BEGIN
                    BudgetedAmount := BudgetEntry.Amount;
                END;

                Committments.RESET;
                Committments.SETRANGE(Committments.Budget, BudgetCode);
                Committments.SETRANGE(Committments."G/L Account No.", "G/L Account"."No.");
                IF Committments.FINDSET THEN BEGIN
                    REPEAT
                        TotalCommitment := TotalCommitment + Committments.Amount;
                    UNTIL Committments.NEXT = 0;
                END;


                BudgetControl.GET();
                GLEntry.RESET;
                GLEntry.SETRANGE(GLEntry."G/L Account No.", "G/L Account"."No.");
                GLEntry.SETRANGE("Posting Date", BudgetControl."Current Budget Start Date", BudgetControl."Current Budget End Date");
                IF GLEntry.FINDSET THEN BEGIN
                    REPEAT
                        ActualExpenditure := ActualExpenditure + GLEntry.Amount;
                    UNTIL GLEntry.NEXT = 0;
                END;


                TotalCommAct := TotalCommitment + ActualExpenditure;

                IF TotalCommAct >= 0 THEN
                    Balance := BudgetedAmount - TotalCommAct
                ELSE
                    IF TotalCommAct < 0 THEN
                        Balance := BudgetedAmount + TotalCommAct;
            end;

            trigger OnPreDataItem()
            begin
                CompInf.GET;
                CompInf.CALCFIELDS(CompInf.Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(BudgetCode; BudgetCode)
                {
                    TableRelation = "G/L Budget Name".Name;
                    ApplicationArea = All;
                }
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
        //GLFilter := "G/L Account".GETFILTERS;
        //PeriodText := "G/L Account".GETFILTER("Date Filter");
    end;

    var
        Committments: Record 50019;
        BudgetName: Code[7];
        Spend: Decimal;
        BudgetBalance: Decimal;
        PostingDateFilter: Date;
        AmtCommitted: Decimal;
        BudgetEntry: Record 96;
        CompInf: Record 79;
        GLFilter: Text;
        PeriodText: Text[30];
        BudgetCode: Code[80];
        ActualExpenditure: Decimal;
        TotalCommitment: Decimal;
        BudgetedAmount: Decimal;
        Balance: Decimal;
        GLEntry: Record 17;
        TotalCommAct: Decimal;
        BudgetControl: Record 50018;
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
}


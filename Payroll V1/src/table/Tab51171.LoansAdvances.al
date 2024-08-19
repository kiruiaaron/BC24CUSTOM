table 51171 "Loans/Advances"
{
    //DrillDownPageID = 51180;
    //LookupPageID = 51180;
    Permissions = TableData 51159 = rimd,
                  TableData 51160 = rimd,
                  TableData 51161 = rimd,
                  TableData 51166 = rimd,
                  TableData 51172 = rimd;

    fields
    {
        field(1; LID; BigInteger)
        {
        }
        field(2; Employee; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            var
                lvEmployee: Record 5200;
            begin
            end;
        }
        field(3; Type; Option)
        {
            Editable = false;
            OptionMembers = Annuity,Serial,Advance;

            trigger OnValidate()
            begin
                IF Type = Type::Advance THEN "Interest Rate" := 0;
            end;
        }
        field(4; "Loan Types"; Code[20])
        {
            NotBlank = true;
            TableRelation = IF (Type = CONST(Advance)) "Loan Types" WHERE(Type = CONST(Advance))
            ELSE
            IF (Type = FILTER(Annuity | Serial)) "Loan Types" WHERE(Type = FILTER(Annuity | Serial));

            trigger OnValidate()
            var
                LoanTypeRec: Record "Loan Types";
            begin
                LoanTypeRec.GET("Loan Types", "Payroll Code");
                LoanTypeRec.GET("Loan Types");
                Type := LoanTypeRec.Type;
                "Calculate Interest Benefit" := LoanTypeRec."Calculate Interest Benefit";
                Description := LoanTypeRec.Description;
            end;
        }
        field(5; "Interest Rate"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF Type = Type::Advance THEN "Interest Rate" := 0;
                VALIDATE(Installments);
            end;
        }
        field(6; Principal; Decimal)
        {

            trigger OnValidate()
            begin
                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Principal (LCY)" := Principal
                ELSE
                    "Principal (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Currency Code", Principal, "Currency Factor"));

                Principal := ROUND(Principal, gvCurrency."Amount Rounding Precision");
                VALIDATE(Installments);
            end;
        }
        field(7; "Remaining Debt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Loan Entry".Repayment WHERE("Loan ID" = FIELD(LID),
                                                            "Transfered To Payroll" = CONST(true)));
            Editable = false;

        }
        field(8; "Number of Installments"; Integer)
        {
            CalcFormula = Count("Loan Entry" WHERE("Loan ID" = FIELD(LID)));
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(9; Repaid; Decimal)
        {
            CalcFormula = Sum("Loan Entry".Repayment WHERE("Loan ID" = FIELD(LID),
                                                            "Transfered To Payroll" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Start Period"; Code[10])
        {
            TableRelation = Periods."Period ID" WHERE(Status = CONST(Open));

            trigger OnValidate()
            var
                PeriodRec: Record 51151;
                PayrollHeaderrec: Record 51159;
            begin
                PeriodRec.SETRANGE("Period ID", "Start Period");
                PeriodRec.SETRANGE("Payroll Code", "Payroll Code");
                PeriodRec.FIND('-');
                "Period Month" := PeriodRec."Period Month";
                "Period Year" := PeriodRec."Period Year";
                IF PayrollHeaderrec.GET("Start Period", Employee) THEN BEGIN
                    IF PayrollHeaderrec.Calculated = TRUE THEN BEGIN
                        PayrollHeaderrec.Calculated := FALSE;
                        PayrollHeaderrec.MODIFY;
                    END;
                END;
            end;
        }
        field(11; "Payment Date"; Date)
        {
        }
        field(12; Description; Text[50])
        {
        }
        field(13; "First Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE("No." = FIELD(Employee)));
            FieldClass = FlowField;
        }
        field(14; "Last Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."Last Name" WHERE("No." = FIELD(Employee)));
            FieldClass = FlowField;
        }
        field(15; "Type Text"; Text[50])
        {
            CalcFormula = Lookup("Loan Types".Description WHERE(Code = FIELD("Loan Types")));
            FieldClass = FlowField;
        }
        field(16; Created; Boolean)
        {
            InitValue = false;
        }
        field(17; "Period Month"; Integer)
        {
        }
        field(18; "Period Year"; Integer)
        {
        }
        field(19; Changed; Boolean)
        {
            InitValue = false;
        }
        field(20; "Total Interest"; Decimal)
        {
            CalcFormula = Sum("Loan Entry".Interest WHERE("Loan ID" = FIELD(LID)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Interest Paid"; Decimal)
        {
            CalcFormula = Sum("Loan Entry".Interest WHERE("Loan ID" = FIELD(LID),
                                                           "Transfered To Payroll" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; Installments; Integer)
        {

            trigger OnValidate()
            begin
                IF Installments = 0 THEN EXIT;
                IF Type = Type::Annuity THEN BEGIN
                    IF "Interest Rate" <= 0 THEN
                        "Installment Amount" := ROUND(Principal / Installments, 1, '>')
                    ELSE
                        "Installment Amount" := ROUND(DebtService(Principal, "Interest Rate", Installments), 1, '>');
                END ELSE
                    IF Type = Type::Serial THEN
                        "Installment Amount" := ROUND(Principal / Installments, 1, '>')
                    ELSE
                        IF Type = Type::Advance THEN
                            "Installment Amount" := ROUND(Principal / Installments, 1, '>');

                //ELSE
                // Installments := 1;

                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Installment Amount (LCY)" := "Installment Amount"
                ELSE
                    "Installment Amount (LCY)" :=
                    ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Currency Code", "Installment Amount", "Currency Factor"));

                "Installment Amount" := ROUND("Installment Amount", gvCurrency."Amount Rounding Precision");
            end;
        }
        field(23; "Installment Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF Type = Type::Annuity THEN ERROR('For an annuity enter the number of installments only');
                //IF Type = Type::Advance THEN ERROR('Not valid');
                Installments := ROUND((Principal / "Installment Amount"), 1, '>');

                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Installment Amount (LCY)" := "Installment Amount"
                ELSE
                    "Installment Amount (LCY)" := ROUND(
                      gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Currency Code", "Installment Amount", "Currency Factor"));

                "Installment Amount" := ROUND("Installment Amount", gvCurrency."Amount Rounding Precision");
            end;
        }
        field(24; "Paid to Employee"; Boolean)
        {
            InitValue = false;
        }
        field(26; "Payments Method"; Code[20])
        {
            TableRelation = "Loan Payments";
        }
        field(27; "Calculate Interest Benefit"; Boolean)
        {
            Editable = false;
        }
        field(28; "Last Suspension Date"; Date)
        {
        }
        field(29; "Last Suspension Duration"; Integer)
        {
            Description = 'In months';
        }
        field(30; Cleared; Boolean)
        {
            Editable = false;
        }
        field(31; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                ERROR('Manual Edits not allowed.');
            end;
        }
        field(32; Create; Boolean)
        {
            InitValue = true;

            trigger OnValidate()
            begin
                Rec.TESTFIELD(Created, FALSE);
            end;
        }
        field(33; Pay; Boolean)
        {
            InitValue = true;

            trigger OnValidate()
            begin
                Rec.TESTFIELD("Paid to Employee", FALSE);
            end;
        }
        field(34; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF "Currency Code" <> '' THEN BEGIN
                    gsGetCurrency;
                    IF ("Currency Code" <> xRec."Currency Code") OR (CurrFieldNo = FIELDNO("Currency Code")) OR ("Currency Factor" = 0) THEN
                        "Currency Factor" := gvCurrExchRate.ExchangeRate(WORKDATE, "Currency Code");
                END ELSE
                    "Currency Factor" := 0;
                VALIDATE("Currency Factor");
                VALIDATE(Installments);
            end;
        }
        field(35; "Principal (LCY)"; Decimal)
        {
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                IF "Currency Code" = '' THEN BEGIN
                    Principal := "Principal (LCY)";
                    VALIDATE(Principal);
                END ELSE BEGIN
                    Rec.TESTFIELD("Principal (LCY)");
                    Rec.TESTFIELD(Principal);
                    "Currency Factor" := Principal / "Principal (LCY)";
                END;
            end;
        }
        field(36; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Principal);
            end;
        }
        field(37; "Remaining Debt (LCY)"; Decimal)
        {
            CalcFormula = Sum("Loan Entry"."Repayment (LCY)" WHERE("Loan ID" = FIELD(LID),
                                                                    "Transfered To Payroll" = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Repaid (LCY)"; Decimal)
        {
            CalcFormula = Sum("Loan Entry"."Repayment (LCY)" WHERE("Loan ID" = FIELD(LID),
                                                                    "Transfered To Payroll" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Total Interest (LCY)"; Decimal)
        {
            CalcFormula = Sum("Loan Entry"."Interest (LCY)" WHERE("Loan ID" = FIELD(LID)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Interest Paid (LCY)"; Decimal)
        {
            CalcFormula = Sum("Loan Entry"."Interest (LCY)" WHERE("Loan ID" = FIELD(LID),
                                                                   "Transfered To Payroll" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Installment Amount (LCY)"; Decimal)
        {

            trigger OnValidate()
            begin
                IF Type = Type::Annuity THEN ERROR('For an annuity enter the number of installments only');
                IF Type = Type::Advance THEN ERROR('Not valid');
                "Installment Amount (LCY)" := ROUND(("Principal (LCY)" / "Installment Amount (LCY)"), 1, '>');

                IF "Currency Code" = '' THEN BEGIN
                    "Installment Amount" := "Installment Amount (LCY)";
                    VALIDATE("Installment Amount");
                END;
            end;
        }
        field(42; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }
        field(43; "Loan ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; LID)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        GlobalLoanEntryRec.SETRANGE("Loan ID", LID);
        GlobalLoanEntryRec.SETRANGE(Posted, FALSE);

        IF (NOT "Paid to Employee") OR (NOT GlobalLoanEntryRec.FIND('-')) THEN BEGIN
            GlobalLoanEntryRec.SETRANGE(Posted);
            GlobalLoanEntryRec.SETRANGE("Loan ID", LID);
            GlobalLoanEntryRec.DELETEALL;
        END ELSE
            ERROR('Loan is already paid to employee');
    end;

    trigger OnInsert()
    var
        LoanRec: Record 51171;
    begin
        IF LID = 0 THEN BEGIN
            IF LoanRec.FIND('+') THEN
                LID := LoanRec.LID + 1
            ELSE
                LID := 1;
        END;
        IF "Payroll Code" = '' THEN "Payroll Code" := gvPayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation
        "Loan ID" := FORMAT(LID);
    end;

    trigger OnModify()
    begin
        IF NOT "Paid to Employee" THEN Created := FALSE;
    end;

    var
        LoanTypeRec: Record 51178;
        GlobalLoanEntryRec: Record 51172;
        gvPayrollUtilities: Codeunit "Payroll Posting";
        gvCurrencyCode: Code[10];
        gvCurrency: Record 4;
        gvCurrExchRate: Record 330;
        Text002: Label 'cannot be specified without %1';
        TableCodeTransfer: Codeunit 51154;

    procedure CreateLoan()
    var
        PeriodRec: Record 51151;
    begin

        TableCodeTransfer.LoanAdvancesCreateLoan(Rec);
    end;

    procedure CreateAdvance()
    var
        LoanEntryRec: Record 51172;
    begin
        TableCodeTransfer.LoanAdvancesCreateAdvance(Rec);
    end;

    procedure CreateSerialLoan()
    var
        LoanEntryRec: Record 51172;
        Periodrec: Record 51151;
        LoanTypeRec: Record 51178;
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin
        TableCodeTransfer.LoanAdvancesCreateSerialLoan(Rec);
    end;

    procedure CreateAnnuityLoan()
    var
        LoanEntryRec: Record 51172;
        Periodrec: Record 51151;
        LoanTypeRec: Record 51178;
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin
        TableCodeTransfer.LoanAdvancesCreateAnnuityLoan(Rec);
    end;

    procedure PayLoan()
    var
        GenJnlLine: Record 81;
        Loansetup: Record 51165;
        LoanTypeRec: Record 51178;
        LoanPaymentRec: Record 51179;
        EmployeeRec: Record 5200;
        PeriodRec: Record 51151;
        HeaderRec: Record 51159;
        TemplateName: Code[10];
        BatchName: Code[10];
        LineNo: Integer;
    begin
        TableCodeTransfer.LoanAdvancesPayLoan(Rec);
    end;

    procedure DebtService(Principal: Decimal; Interest: Decimal; PayPeriods: Integer): Decimal
    var
        PeriodInterest: Decimal;
    begin
        EXIT(TableCodeTransfer.LoanAdvancesDebtService(Principal, Interest, PayPeriods));
    end;

    procedure CreateLoanfromSchedule()
    var
        PeriodRec: Record 51151;
        lvLoansSchedule: Record 51169;
        lvEmp: Record 5200;
    begin
        TableCodeTransfer.LoanAdvancesCreateLoanfromSchedule(Rec);
    end;

    local procedure gsGetCurrency()
    begin
        gvCurrencyCode := "Currency Code";

        IF gvCurrencyCode = '' THEN BEGIN
            CLEAR(gvCurrency);
            gvCurrency.InitRoundingPrecision
        END ELSE
            IF gvCurrencyCode <> gvCurrency.Code THEN BEGIN
                gvCurrency.GET(gvCurrencyCode);
                gvCurrency.TESTFIELD("Amount Rounding Precision");
            END;
    end;
}


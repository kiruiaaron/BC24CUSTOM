table 51169 "Recurring Loans Schedule"
{
    //DrillDownPageID = 52021083;
    // LookupPageID = 52021083;

    fields
    {
        field(1; "Line No"; BigInteger)
        {
        }
        field(2; Employee; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            var
                LoanRec: Record 51177;
            begin
            end;
        }
        field(3; "Loan Types"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Loan Types";

            trigger OnValidate()
            begin
                LoanTypeRec.GET("Loan Types");
                Type := LoanTypeRec.Type;
                Description := LoanTypeRec.Description;
                IF Type = Type::Advance THEN Installments := 1;
            end;
        }
        field(4; "Interest Rate"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF Type = Type::Advance THEN "Interest Rate" := 0;
            end;
        }
        field(5; Principal; Decimal)
        {
            MinValue = 0;
        }
        field(6; Description; Text[50])
        {
        }
        field(7; Installments; Integer)
        {
            MinValue = 1;

            trigger OnValidate()
            begin
                IF Type = Type::Annuity THEN BEGIN
                    IF "Interest Rate" <= 0 THEN
                        "Installment Amount" := ROUND(Principal / Installments, 1, '>')
                    ELSE
                        "Installment Amount" := ROUND(DebtService(Principal, "Interest Rate", Installments), 1, '>');
                END ELSE
                    IF Type = Type::Serial THEN
                        "Installment Amount" := ROUND(Principal / Installments, 1, '>')
                    ELSE
                        Installments := 1;
            end;
        }
        field(8; "Payments Method"; Code[20])
        {
            TableRelation = "Loan Payments";
        }
        field(9; Type; Option)
        {
            Editable = false;
            OptionMembers = Annuity,Serial,Advance;
        }
        field(10; Skip; Boolean)
        {
            Description = 'Skip During Loans Creation';
        }
        field(11; "Installment Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF Type = Type::Annuity THEN ERROR('For an annuity enter the number of installments only');
                IF Type = Type::Advance THEN ERROR('Not valid');
                Installments := ROUND((Principal / "Installment Amount"), 1, '>');
            end;
        }
        field(12; "Payroll Code"; Code[10])
        {
            Editable = false;
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                //ERROR('Manual Edits not allowed.');   //Commented out by SNG240511
            end;
        }
    }

    keys
    {
        key(Key1; "Payroll Code", "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Payroll Code" = '' THEN "Payroll Code" := gvPayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation
    end;

    var
        LoanTypeRec: Record 51178;
        gvPayrollUtilities: Codeunit 51152;
        TableCodeTransfer: Codeunit 51154;

    procedure DebtService(Principal: Decimal; Interest: Decimal; PayPeriods: Integer): Decimal
    var
        PeriodInterest: Decimal;
    begin
        EXIT(TableCodeTransfer.RecurLoanScheduleDebtService(Principal, Interest, PayPeriods));
    end;
}


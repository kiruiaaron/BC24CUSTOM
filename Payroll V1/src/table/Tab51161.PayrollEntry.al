table 51161 "Payroll Entry"
{
    Permissions = TableData 51159 = rimd,
                  TableData 51160 = rimd;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Payroll ID"; Code[10])
        {
            TableRelation = Periods."Period ID";
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(4; "ED Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "ED Definitions";

            trigger OnLookup()
            var
                EDCodeRec: Record 51158;
                Employee: Record 5200;
                CalcSchemes: Record 51154;
                lvPayrollHdr: Record 51159;
                lvRoundDirection: Text[1];
                Periods: Record 51151;
            begin
                EDCodeRec.SETRANGE("System Created", FALSE);
                IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"ED Definitions List", EDCodeRec) THEN BEGIN

                    IF Employee.GET("Employee No.") THEN BEGIN
                        CalcSchemes.SETRANGE("Scheme ID", Employee."Calculation Scheme");
                        CalcSchemes.SETCURRENTKEY("Payroll Entry");
                        CalcSchemes.SETRANGE("Payroll Entry", EDCodeRec."ED Code");

                        IF NOT CalcSchemes.FIND('-') THEN
                            ERROR('The "ED Code" does not exits in the Calculation Scheme')
                        ELSE BEGIN
                            "ED Code" := EDCodeRec."ED Code";
                            Text := EDCodeRec.Description;
                            "Copy to next" := EDCodeRec."Copy to next";
                            "Reset Amount" := EDCodeRec."Reset Amount";
                            Absence := EDCodeRec.Absence;
                        END;
                    END;
                END;

                //Direct Overtime Entry
                IF EDCodeRec.GET("ED Code") THEN
                    IF EDCodeRec."Overtime ED" THEN BEGIN
                        PayrollSetupRec.GET("Payroll Code");
                        CASE PayrollSetupRec."Hourly Rate Rounding" OF
                            PayrollSetupRec."Hourly Rate Rounding"::None:
                                lvRoundDirection := '=';
                            PayrollSetupRec."Hourly Rate Rounding"::Up:
                                lvRoundDirection := '>';
                            PayrollSetupRec."Hourly Rate Rounding"::Down:
                                lvRoundDirection := '<';
                            PayrollSetupRec."Hourly Rate Rounding"::Nearest:
                                lvRoundDirection := '=';
                        END;

                        lvPayrollHdr.GET("Payroll ID", "Employee No.");
                        lvPayrollHdr.TESTFIELD("Hour Rate");
                        LineRate := ROUND(EDCodeRec."Overtime ED Weight" * lvPayrollHdr."Hour Rate",
                          PayrollSetupRec."Hourly Rounding Precision", lvRoundDirection);
                        VALIDATE(Rate, LineRate);
                        //MODIFY;
                    END;
                //Direct Overtime Entry
                IF Absence THEN BEGIN
                    PayrollSetupRec.GET("Payroll Code");
                    CASE PayrollSetupRec."Hourly Rate Rounding" OF
                        PayrollSetupRec."Hourly Rate Rounding"::None:
                            lvRoundDirection := '=';
                        PayrollSetupRec."Hourly Rate Rounding"::Up:
                            lvRoundDirection := '>';
                        PayrollSetupRec."Hourly Rate Rounding"::Down:
                            lvRoundDirection := '<';
                        PayrollSetupRec."Hourly Rate Rounding"::Nearest:
                            lvRoundDirection := '=';
                    END;
                    lvPayrollHdr.GET("Payroll ID", "Employee No.");
                    Periods.GET(lvPayrollHdr."Payroll ID", lvPayrollHdr."Payroll Month", lvPayrollHdr."Payroll Year", "Payroll Code");
                    LineRate := ROUND(lvPayrollHdr."Basic Pay" / Periods.Hours,
                             PayrollSetupRec."Hourly Rounding Precision", lvRoundDirection);
                    VALIDATE(Rate, LineRate);
                END;
            end;

            trigger OnValidate()
            var
                EDCodeRec: Record 51158;
                Employee: Record 5200;
                CalcSchemes: Record 51154;
                lvPayrollHdr: Record 51159;
                lvRoundDirection: Text[1];
            begin
                TableCodeTransfer.PayrollEntryEDCodeValidate(Rec, xRec);
            end;
        }
        field(5; Quantity; Decimal)
        {

            trigger OnValidate()
            begin

                CalcAmount();
            end;
        }
        field(6; Rate; Decimal)
        {

            trigger OnValidate()
            begin
                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Rate (LCY)" := Rate
                ELSE
                    "Rate (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Currency Code", Rate, "Currency Factor"));

                Rate := ROUND(Rate, gvCurrency."Amount Rounding Precision");
                CalcAmount();
            end;
        }
        field(7; Amount; Decimal)
        {

            trigger OnValidate()
            var
                lvAllowedPayrolls: Record 51182;
                lvPayrollSetupRec: Record 51165;
            begin
                lvAllowedPayrolls.SETRANGE("User ID", USERID);
                lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
                IF lvAllowedPayrolls.FINDFIRST THEN
                    lvPayrollSetupRec.GET(lvAllowedPayrolls."Payroll Code")
                ELSE
                    ERROR('You are not allowed access to any payroll');

                IF Editable = FALSE THEN
                    IF "ED Code" = lvPayrollSetupRec."Mid Month ED Code" THEN
                        ERROR('Mid Month has been closed and cannot be modified');

                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    Rec.TESTFIELD(Date);
                    "Amount (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(Date, "Currency Code", Amount, "Currency Factor"));
                END;
                Amount := ROUND(Amount, gvCurrency."Amount Rounding Precision");
            end;
        }
        field(8; "Copy to next"; Boolean)
        {
        }
        field(9; "Reset Amount"; Boolean)
        {
        }
        field(10; Text; Text[50])
        {
            CalcFormula = Lookup("ED Definitions".Description WHERE("ED Code" = FIELD("ED Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; Date; Date)
        {
        }
        field(12; Editable; Boolean)
        {
            InitValue = true;
        }
        field(13; "Loan ID"; BigInteger)
        {
            TableRelation = "Loans/Advances";
        }
        field(14; Interest; Decimal)
        {

            trigger OnValidate()
            begin
                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Interest (LCY)" := Interest
                ELSE
                    "Interest (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Currency Code", Interest, "Currency Factor"));

                Interest := ROUND(Interest, gvCurrency."Amount Rounding Precision");
            end;
        }
        field(15; Repayment; Decimal)
        {

            trigger OnValidate()
            begin
                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Repayment (LCY)" := Repayment
                ELSE
                    "Repayment (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Currency Code", Repayment, "Currency Factor"));

                Repayment := ROUND(Repayment, gvCurrency."Amount Rounding Precision");
            end;
        }
        field(16; "Remaining Debt"; Decimal)
        {

            trigger OnValidate()
            begin
                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Remaining Debt (LCY)" := "Remaining Debt"
                ELSE
                    "Remaining Debt (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Currency Code", "Remaining Debt",
                      "Currency Factor"));

                "Remaining Debt" := ROUND("Remaining Debt", gvCurrency."Amount Rounding Precision");
            end;
        }
        field(17; Paid; Decimal)
        {

            trigger OnValidate()
            begin
                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Paid (LCY)" := Paid
                ELSE
                    "Paid (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Currency Code", Paid, "Currency Factor"));

                Paid := ROUND(Paid, gvCurrency."Amount Rounding Precision");
            end;
        }
        field(18; "Loan Text"; Text[50])
        {
        }
        field(19; "Loan Entry"; Boolean)
        {
            InitValue = false;
        }
        field(20; "Basic Pay Entry"; Boolean)
        {
            InitValue = false;
        }
        field(21; "Time Entry"; Boolean)
        {
            InitValue = false;
        }
        field(22; "Loan Entry No"; Integer)
        {
        }
        field(23; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                //ERROR('Manual Edits not allowed.');
            end;
        }
        field(24; "ED Expiry Date"; Date)
        {
        }
        field(25; "Currency Code"; Code[10])
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
            end;
        }
        field(26; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                IF (Quantity <> 0) AND (Rate <> 0) THEN
                    VALIDATE(Rate)
                ELSE
                    VALIDATE(Amount);
            end;
        }
        field(27; "Rate (LCY)"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Currency Code" = '' THEN
                    Rate := "Rate (LCY)"
                ELSE BEGIN
                    Rec.TESTFIELD("Rate (LCY)");
                    Rec.TESTFIELD(Rate);
                    "Currency Factor" := Rate / "Rate (LCY)";
                END;
                CalcAmount;
            end;
        }
        field(28; "Amount (LCY)"; Decimal)
        {

            trigger OnValidate()
            var
                lvAllowedPayrolls: Record 51182;
                lvPayrollSetupRec: Record 51165;
            begin
                lvAllowedPayrolls.SETRANGE("User ID", USERID);
                lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
                IF lvAllowedPayrolls.FINDFIRST THEN
                    lvPayrollSetupRec.GET(lvAllowedPayrolls."Payroll Code")
                ELSE
                    ERROR('You are not allowed access to any payroll');

                IF Editable = FALSE THEN
                    IF "ED Code" = lvPayrollSetupRec."Mid Month ED Code" THEN
                        ERROR('Mid Month has been closed and cannot be modified');

                IF "Currency Code" = '' THEN
                    Amount := "Amount (LCY)"
                ELSE BEGIN
                    Rec.TESTFIELD("Amount (LCY)");
                    Rec.TESTFIELD(Amount);
                    "Currency Factor" := Amount / "Amount (LCY)";
                END;
            end;
        }
        field(29; "Interest (LCY)"; Decimal)
        {
        }
        field(30; "Repayment (LCY)"; Decimal)
        {
        }
        field(31; "Remaining Debt (LCY)"; Decimal)
        {
        }
        field(32; "Paid (LCY)"; Decimal)
        {

            trigger OnValidate()
            begin
                gsGetCurrency;
                IF "Currency Code" = '' THEN
                    "Paid (LCY)" := Paid
                ELSE
                    "Paid (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(WORKDATE, "Currency Code", Paid, "Currency Factor"));

                Paid := ROUND(Paid, gvCurrency."Amount Rounding Precision");
            end;
        }
        field(50002; "Created From"; Option)
        {
            OptionCaption = ' ,Leave Encash,Recovered Lost Day,Leave Allowance,Leave Advance';
            OptionMembers = " ","Leave Encash","Recovered Lost Day","Leave Allowance","Leave Advance";
        }
        field(50003; "Leave Request No."; Code[20])
        {
        }
        field(50004; "Staff Vendor Entry"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50005; Absence; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "ED Code", "Employee No.")
        {
        }
        key(Key2; "Payroll ID", "Employee No.", "ED Code")
        {
        }
        key(Key3; Rate)
        {
        }
        key(Key4; "Payroll ID", "Employee No.", "ED Code", "Loan Entry", "Basic Pay Entry", "Time Entry")
        {
        }
        key(Key5; "Employee No.", "Payroll ID", "ED Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        SetHeaderFalse;
        //PayrollUtilities.sDeleteDefaultEDDims(Rec);
    end;

    trigger OnInsert()
    begin
        IF "Payroll Code" = '' THEN "Payroll Code" := PayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation
        SetHeaderFalse;
    end;

    trigger OnModify()
    begin
        SetHeaderFalse;
    end;

    trigger OnRename()
    begin
        SetHeaderFalse;
    end;

    var
        EmploreeRec: Record 5200;
        EDDef: Record 51158;
        PayrollSetupRec: Record 51165;
        LineRate: Decimal;
        PayrollUtilities: Codeunit 51152;
        gvCurrencyCode: Code[10];
        gvCurrency: Record 4;
        gvCurrExchRate: Record 330;
        Text002: Label 'cannot be specified without %1';
        TableCodeTransfer: Codeunit 51154;

    procedure CalcAmount()
    begin
        TableCodeTransfer.PayrollEntryCalcAmount(Rec);
    end;

    procedure SetHeaderFalse()
    var
        Header: Record 51159;
    begin
        TableCodeTransfer.PayrollEntrySetHeaderFalse(Rec);
    end;

    procedure ShowDimensions()
    var
        PayrollDim: Record 51184;
        PayrollDimensions: Page 51199;
    begin
        TableCodeTransfer.PayrollEntryShowDimensions(Rec);
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


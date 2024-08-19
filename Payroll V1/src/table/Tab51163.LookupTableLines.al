table 51163 "Lookup Table Lines"
{

    fields
    {
        field(1; "Table ID"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Lookup Table Header";
        }
        field(2; "Lower Amount (LCY)"; Decimal)
        {

            trigger OnValidate()
            begin
                gvAllowedPayrolls.SETRANGE("User ID", USERID);
                IF gvAllowedPayrolls.FINDFIRST THEN BEGIN
                    PayrollSetup.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    IF PayrollSetup.FINDFIRST THEN BEGIN

                        IF PayrollSetup."Tax Calculation" = PayrollSetup."Tax Calculation"::Kenya THEN BEGIN
                            IF Percent <> 0 THEN
                                "Cumulate (LCY)" := (("Upper Amount (LCY)" - "Lower Amount (LCY)") * Percent) / 100
                            ELSE
                                "Cumulate (LCY)" := 0;
                        END ELSE
                            IF PayrollSetup."Tax Calculation" = PayrollSetup."Tax Calculation"::Ethiopia THEN BEGIN
                                IF Percent <> 0 THEN
                                    "Cumulate (LCY)" := ((("Upper Amount (LCY)" - "Lower Amount (LCY)") * Percent) / 100) - "Relief Amount"
                                ELSE
                                    "Cumulate (LCY)" := 0;
                            END;
                    END;
                END;
            end;
        }
        field(3; "Upper Amount (LCY)"; Decimal)
        {

            trigger OnValidate()
            begin
                gvAllowedPayrolls.SETRANGE("User ID", USERID);
                IF gvAllowedPayrolls.FINDFIRST THEN BEGIN
                    PayrollSetup.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    IF PayrollSetup.FINDFIRST THEN BEGIN
                        IF PayrollSetup."Tax Calculation" = PayrollSetup."Tax Calculation"::Kenya THEN
                            CalcCum(Rec)
                        ELSE
                            IF PayrollSetup."Tax Calculation" = PayrollSetup."Tax Calculation"::Ethiopia THEN
                                CalcCumEthiopia(Rec);
                    END;
                END
            end;
        }
        field(4; "Extract Amount (LCY)"; Decimal)
        {
        }
        field(5; Percent; Decimal)
        {

            trigger OnValidate()
            begin
                gvAllowedPayrolls.SETRANGE("User ID", USERID);
                IF gvAllowedPayrolls.FINDFIRST THEN BEGIN
                    PayrollSetup.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    IF PayrollSetup.FINDFIRST THEN BEGIN
                        IF PayrollSetup."Tax Calculation" = PayrollSetup."Tax Calculation"::Kenya THEN
                            CalcCum(Rec)
                        ELSE
                            IF PayrollSetup."Tax Calculation" = PayrollSetup."Tax Calculation"::Ethiopia THEN
                                CalcCumEthiopia(Rec);
                    END;
                END;
            end;
        }
        field(6; "Cumulate (LCY)"; Decimal)
        {
            Description = 'Not in use for Ethiopia';
        }
        field(7; Month; Integer)
        {
            MaxValue = 12;
            MinValue = 1;
        }
        field(50001; "Relief Amount"; Decimal)
        {
            Description = 'Ethiopian tax has a Relief for every income bracket';

            trigger OnValidate()
            begin
                gvAllowedPayrolls.SETRANGE("User ID", USERID);
                IF gvAllowedPayrolls.FINDFIRST THEN BEGIN
                    PayrollSetup.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                    IF PayrollSetup.FINDFIRST THEN BEGIN
                        IF PayrollSetup."Tax Calculation" = PayrollSetup."Tax Calculation"::Kenya THEN
                            CalcCum(Rec)
                        ELSE
                            IF PayrollSetup."Tax Calculation" = PayrollSetup."Tax Calculation"::Ethiopia THEN
                                CalcCumEthiopia(Rec);
                    END;
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Lower Amount (LCY)", Month)
        {
        }
    }

    fieldgroups
    {
    }

    var
        TableLines: Record 51163;
        PayrollSetup: Record 51165;
        gvAllowedPayrolls: Record 51182;
        TableCodeTransfer: Codeunit 51154;

    procedure CalcCum(TableLinesRec: Record 51163)
    begin
        TableCodeTransfer.LookupTableLinesCalcCum(Rec, TableLinesRec);
    end;

    procedure CalcCumEthiopia(TableLinesRec: Record 51163)
    begin
        TableCodeTransfer.LookupTableLinesCalcCumEthiopia(Rec, TableLinesRec);
    end;
}


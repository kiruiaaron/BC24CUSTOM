report 51223 "Payroll PV"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Payroll PV.rdlc';

    dataset
    {
        dataitem("Payroll Header"; 51159)
        {
            RequestFilterFields = "Payroll ID", "Payroll Code";
            column(EDCode; "Payroll Header"."Payroll ID")
            {
            }
            column(PayrollCode; "Payroll Header"."Payroll Code")
            {
            }
            column(TotalPayable; "Payroll Header"."Total Payable (LCY)")
            {
            }
            column(TotalDeduction; "Payroll Header"."Total Deduction (LCY)")
            {
            }
            column(Amount1; Amount1)
            {
            }
            column(Amount2; Amount2)
            {
            }
            column(GrossPay; GrossPay)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Payroll Header".CALCFIELDS("Payroll Header"."Total Payable (LCY)", "Payroll Header"."Total Deduction (LCY)");
                IF (("Payroll Header"."Payroll Code" <> 'CMT') AND ("Payroll Header"."Payroll Code" <> 'GENERAL')) THEN
                    CurrReport.SKIP;
                IF "Payroll Header"."Payroll Code" = 'GENERAL' THEN BEGIN
                    Amount1 := "Payroll Header"."Total Payable (LCY)" - "Payroll Header"."Total Deduction (LCY)";
                END;


                IF "Payroll Header"."Payroll Code" = 'CMT' THEN BEGIN
                    Amount2 := "Payroll Header"."Total Payable (LCY)" - "Payroll Header"."Total Deduction (LCY)";
                END;
                //END ELSE


                GrossPay := Amount1 + Amount2;
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

    var
        Amount1: Decimal;
        Amount2: Decimal;
        GrossPay: Decimal;
}


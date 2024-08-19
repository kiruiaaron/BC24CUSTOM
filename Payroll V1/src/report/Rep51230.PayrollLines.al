report 51230 PayrollLines
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll Lines"; 51160)
        {

            trigger OnAfterGetRecord()
            begin
                //IF "Payroll Header"."Payroll ID"='1-2020' THEN
                //IF (("Payroll Lines"."Payroll ID"='11-2019') AND ("Payroll Lines"."Payroll Code"<>'CMT'))THEN
                //"Payroll Lines"."ED Code":='NAWASSCO SACCO';
                "Payroll Lines"."Amount (LCY)" := "Payroll Lines".Amount;
                "Payroll Lines".MODIFY;
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
}


report 51234 "Payroll header"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.layout/Payroll header.rdlc';

    dataset
    {
        dataitem("Payroll Header"; 51159)
        {
            DataItemTableView = WHERE("Payroll ID" = CONST('1-2020'),
                                      "Payroll Code" = CONST('GENERAL'));

            trigger OnAfterGetRecord()
            begin
                "Payroll Header".Posted := FALSE;
                "Payroll Header".MODIFY;
            end;
        }
        dataitem(Periods; 51151)
        {
            DataItemTableView = WHERE("Period ID" = CONST('1-2020'),
                                      "Payroll Code" = CONST('GENERAL'));

            trigger OnAfterGetRecord()
            begin
                Periods.Status := Periods.Status::Open;
                Periods.MODIFY;
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


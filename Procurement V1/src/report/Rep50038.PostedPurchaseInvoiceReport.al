report 50038 "Posted Purchase Invoice Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Posted Purchase Invoice Report.rdlc';

    dataset
    {
        dataitem("Purch. Inv. Header"; 122)
        {
            RequestFilterFields = "Posting Date";
            column(no; "Purch. Inv. Header"."No.")
            {
            }
            column(vendname; "Purch. Inv. Header"."Pay-to Name")
            {
            }
            column(pdate; "Purch. Inv. Header"."Posting Date")
            {
            }
            column(invoiceno; "Purch. Inv. Header"."Vendor Invoice No.")
            {
            }
            column(amount; "Purch. Inv. Header".Amount)
            {
            }
            column(amountvat; "Purch. Inv. Header"."Amount Including VAT")
            {
            }
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


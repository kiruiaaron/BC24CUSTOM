report 50039 "Purchases Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Purchases Report.rdlc';

    dataset
    {
        dataitem("Purchase Header"; 38)
        {
            DataItemTableView = ORDER(Ascending)
                                WHERE(Status = FILTER(Released | "Pending Approval"));
            RequestFilterFields = "Posting Date";
            column(no; "Purchase Header"."No.")
            {
            }
            column(vendname; "Purchase Header"."Pay-to Name")
            {
            }
            column(pdate; "Purchase Header"."Posting Date")
            {
            }
            column(invoiceno; "Purchase Header"."Vendor Invoice No.")
            {
            }
            column(amount; "Purchase Header".Amount)
            {
            }
            column(amountvat; "Purchase Header"."Amount Including VAT")
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


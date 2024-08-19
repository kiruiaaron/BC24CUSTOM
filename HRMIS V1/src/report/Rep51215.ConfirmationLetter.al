report 51215 "Confirmation Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Confirmation Letter.rdlc';

    dataset
    {
        dataitem(Employee; 5200)
        {
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


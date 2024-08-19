report 50048 "Vendor Categories Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Vendor Categories Report.rdlc';

    dataset
    {
        dataitem(DataItem1; 50045)
        {
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2; CompanyInfo."Address 2")
            {
            }
            column(pic; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo_Phone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_Fax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Email; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfo_Web; CompanyInfo."Home Page")
            {
            }
            column(DocumentNumber_SupplierCategory; "Document Number")
            {
            }
            column(SupplierCategory_SupplierCategory; "Supplier Category")
            {
            }
            column(CategoryDescription_SupplierCategory; "Category Description")
            {
            }
            column(LiNo; LiNo)
            {
            }
            column(SupplierName; SupplierName)
            {
            }

            trigger OnAfterGetRecord()
            begin
                LiNo := LiNo + 1;

                Vendors.RESET;
                Vendors.SETRANGE("No.", "Document Number");
                IF Vendors.FINDFIRST THEN
                    SupplierName := Vendors.Name;
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

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture)
    end;

    var
        CompanyInfo: Record 79;
        SupplierName: Text;
        LiNo: Integer;
        Vendors: Record 23;
}


report 50037 "New Bid Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/New Bid Analysis.rdlc';

    dataset
    {
        dataitem("Bid Analysis"; 50052)
        {
            RequestFilterFields = "Request for Quotation No.";
            column(RFQNo_BidAnalysis; "Request for Quotation No.")
            {
            }
            column(QuoteNo_BidAnalysis; "Quote No.")
            {
            }
            column(VendorNo_BidAnalysis; "Vendor No.")
            {
            }
            column(ItemNo_BidAnalysis; "Item No.")
            {
            }
            column(Description_BidAnalysis; Description)
            {
            }
            column(Quantity_BidAnalysis; Quantity)
            {
            }
            column(UnitOfMeasure_BidAnalysis; "Unit Of Measure")
            {
            }
            column(Amount_BidAnalysis; Amount)
            {
            }
            column(LineAmount_BidAnalysis; "Line Amount")
            {
            }
            column(RFQLineNo_BidAnalysis; "Line No.")
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(CompanyInfoAddress; CompanyInfo.Address)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            /*    column(LastDirectCost_BidAnalysis; "Last Direct Cost")
               {
               } */
            column(Total_BidAnalysis; Total)
            {
            }
            column(Name_Vendor; VendorName)
            {
            }
            column(SelectedVendor; SelectedVendor)
            {
            }
            column(SelectedPrice; SelectedPrice)
            {
            }
            column(TotalPrice; TotalPrice)
            {
            }
            column(SelectedRemarks; SelectedRemarks)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Vendor.GET("Bid Analysis"."Vendor No.") THEN
                    VendorName := Vendor.Name;
                BidAnalysis.RESET;
                BidAnalysis.SETRANGE("Request for Quotation No.", "Request for Quotation No.");
                BidAnalysis.SETRANGE("Line No.", "Line No.");
                BidAnalysis.SETCURRENTKEY(BidAnalysis."Request for Quotation No.", BidAnalysis."Line No.", BidAnalysis.Amount);
                IF BidAnalysis.FINDFIRST THEN BEGIN
                    Vendor.GET(BidAnalysis."Vendor No.");
                    SelectedVendor := Vendor.Name;
                    SelectedPrice := BidAnalysis.Amount;
                    TotalPrice := BidAnalysis.Amount * BidAnalysis.Quantity;
                    SelectedRemarks := BidAnalysis.Remarks;
                END
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
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record 79;
        Vendor: Record 23;
        BidAnalysis: Record 50052;
        SelectedVendor: Text;
        SelectedPrice: Decimal;
        TotalPrice: Decimal;
        VendorName: Text;
        SelectedRemarks: Text;
}


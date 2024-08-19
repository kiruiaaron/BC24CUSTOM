report 50050 "Item Price Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Item Price Report.rdlc';

    dataset
    {
        dataitem("Item Ledger Entry"; 32)
        {
            RequestFilterFields = "Item No.";
            column(MarketPrice; MarketPrice)
            {
            }
            column(CostAmountActual_ItemLedgerEntry; "Item Ledger Entry"."Cost Amount (Actual)")
            {
            }
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(PostingDate_ItemLedgerEntry; "Item Ledger Entry"."Posting Date")
            {
            }
            column(EntryType_ItemLedgerEntry; "Item Ledger Entry"."Entry Type")
            {
            }
            column(SourceNo_ItemLedgerEntry; "Item Ledger Entry"."Source No.")
            {
            }
            column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
            {
            }
            column(Description_ItemLedgerEntry; "Item Ledger Entry".Description)
            {
            }
            column(ItemDescription; ItemDescription)
            {
            }
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

            trigger OnAfterGetRecord()
            begin
                IF ItemList.GET("Item Ledger Entry"."Item No.") THEN
                    ItemDescription := ItemList.Description;



                ItemMarketPrice.RESET;
                ItemMarketPrice.SETRANGE(ItemMarketPrice.Item, "Item Ledger Entry"."Item No.");
                //ItemMarketPrice.SETRANGE(ItemMarketPrice."From Date",ItemMarketPrice."To Date","Item Ledger Entry"."Posting Date");
                IF ItemMarketPrice.FINDFIRST THEN BEGIN
                    MarketPrice := ItemMarketPrice."Market Price";
                END;
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
        ItemMarketPrice: Record 50072;
        ItemList: Record 27;
        MarketPrice: Decimal;
        CompanyInfo: Record 79;
        ItemDescription: Text;
}


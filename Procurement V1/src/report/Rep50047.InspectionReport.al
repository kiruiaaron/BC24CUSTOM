report 50047 "Inspection Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Inspection Report.rdlc';

    dataset
    {
        dataitem("Purch. Rcpt. Header"; 120)
        {
            column(BuyfromVendorNo_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor No.")
            {
            }
            column(No_PurchRcptHeader; "Purch. Rcpt. Header"."No.")
            {
            }
            column(PaytoVendorNo_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Vendor No.")
            {
            }
            column(PaytoName_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Name")
            {
            }
            column(PaytoName2_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Name 2")
            {
            }
            column(PaytoAddress_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Address")
            {
            }
            column(PaytoAddress2_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Address 2")
            {
            }
            column(PaytoCity_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to City")
            {
            }
            column(PaytoContact_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Contact")
            {
            }
            column(YourReference_PurchRcptHeader; "Purch. Rcpt. Header"."Your Reference")
            {
            }
            column(ShiptoCode_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to Code")
            {
            }
            column(ShiptoName_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to Name")
            {
            }
            column(ShiptoName2_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to Name 2")
            {
            }
            column(ShiptoAddress_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to Address")
            {
            }
            column(ShiptoAddress2_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to Address 2")
            {
            }
            column(ShiptoCity_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to City")
            {
            }
            column(ShiptoContact_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to Contact")
            {
            }
            column(OrderDate_PurchRcptHeader; "Purch. Rcpt. Header"."Order Date")
            {
            }
            column(PostingDate_PurchRcptHeader; "Purch. Rcpt. Header"."Posting Date")
            {
            }
            column(ExpectedReceiptDate_PurchRcptHeader; "Purch. Rcpt. Header"."Expected Receipt Date")
            {
            }
            column(PostingDescription_PurchRcptHeader; "Purch. Rcpt. Header"."Posting Description")
            {
            }
            column(PaymentTermsCode_PurchRcptHeader; "Purch. Rcpt. Header"."Payment Terms Code")
            {
            }
            column(DueDate_PurchRcptHeader; "Purch. Rcpt. Header"."Due Date")
            {
            }
            column(PaymentDiscount_PurchRcptHeader; "Purch. Rcpt. Header"."Payment Discount %")
            {
            }
            column(PmtDiscountDate_PurchRcptHeader; "Purch. Rcpt. Header"."Pmt. Discount Date")
            {
            }
            column(ShipmentMethodCode_PurchRcptHeader; "Purch. Rcpt. Header"."Shipment Method Code")
            {
            }
            column(LocationCode_PurchRcptHeader; "Purch. Rcpt. Header"."Location Code")
            {
            }
            column(ShortcutDimension1Code_PurchRcptHeader; "Purch. Rcpt. Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PurchRcptHeader; "Purch. Rcpt. Header"."Shortcut Dimension 2 Code")
            {
            }
            column(VendorPostingGroup_PurchRcptHeader; "Purch. Rcpt. Header"."Vendor Posting Group")
            {
            }
            column(CurrencyCode_PurchRcptHeader; "Purch. Rcpt. Header"."Currency Code")
            {
            }
            column(CurrencyFactor_PurchRcptHeader; "Purch. Rcpt. Header"."Currency Factor")
            {
            }
            column(InvoiceDiscCode_PurchRcptHeader; "Purch. Rcpt. Header"."Invoice Disc. Code")
            {
            }
            column(LanguageCode_PurchRcptHeader; "Purch. Rcpt. Header"."Language Code")
            {
            }
            column(PurchaserCode_PurchRcptHeader; "Purch. Rcpt. Header"."Purchaser Code")
            {
            }
            column(OrderNo_PurchRcptHeader; "Purch. Rcpt. Header"."Order No.")
            {
            }
            column(Comment_PurchRcptHeader; "Purch. Rcpt. Header".Comment)
            {
            }
            column(NoPrinted_PurchRcptHeader; "Purch. Rcpt. Header"."No. Printed")
            {
            }
            column(OnHold_PurchRcptHeader; "Purch. Rcpt. Header"."On Hold")
            {
            }
            column(AppliestoDocType_PurchRcptHeader; "Purch. Rcpt. Header"."Applies-to Doc. Type")
            {
            }
            column(AppliestoDocNo_PurchRcptHeader; "Purch. Rcpt. Header"."Applies-to Doc. No.")
            {
            }
            column(BalAccountNo_PurchRcptHeader; "Purch. Rcpt. Header"."Bal. Account No.")
            {
            }
            column(VendorOrderNo_PurchRcptHeader; "Purch. Rcpt. Header"."Vendor Order No.")
            {
            }
            column(VendorShipmentNo_PurchRcptHeader; "Purch. Rcpt. Header"."Vendor Shipment No.")
            {
            }
            column(VATRegistrationNo_PurchRcptHeader; "Purch. Rcpt. Header"."VAT Registration No.")
            {
            }
            column(SelltoCustomerNo_PurchRcptHeader; "Purch. Rcpt. Header"."Sell-to Customer No.")
            {
            }
            column(ReasonCode_PurchRcptHeader; "Purch. Rcpt. Header"."Reason Code")
            {
            }
            column(GenBusPostingGroup_PurchRcptHeader; "Purch. Rcpt. Header"."Gen. Bus. Posting Group")
            {
            }
            column(TransactionType_PurchRcptHeader; "Purch. Rcpt. Header"."Transaction Type")
            {
            }
            column(TransportMethod_PurchRcptHeader; "Purch. Rcpt. Header"."Transport Method")
            {
            }
            column(VATCountryRegionCode_PurchRcptHeader; "Purch. Rcpt. Header"."VAT Country/Region Code")
            {
            }
            column(BuyfromVendorName_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor Name")
            {
            }
            column(BuyfromVendorName2_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor Name 2")
            {
            }
            column(BuyfromAddress_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Address")
            {
            }
            column(BuyfromAddress2_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Address 2")
            {
            }
            column(BuyfromCity_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from City")
            {
            }
            column(BuyfromContact_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Contact")
            {
            }
            column(PaytoPostCode_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Post Code")
            {
            }
            column(PaytoCounty_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to County")
            {
            }
            column(PaytoCountryRegionCode_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Country/Region Code")
            {
            }
            column(BuyfromPostCode_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Post Code")
            {
            }
            column(BuyfromCounty_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from County")
            {
            }
            column(BuyfromCountryRegionCode_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Country/Region Code")
            {
            }
            column(ShiptoPostCode_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to Post Code")
            {
            }
            column(ShiptoCounty_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to County")
            {
            }
            column(ShiptoCountryRegionCode_PurchRcptHeader; "Purch. Rcpt. Header"."Ship-to Country/Region Code")
            {
            }
            column(BalAccountType_PurchRcptHeader; "Purch. Rcpt. Header"."Bal. Account Type")
            {
            }
            column(OrderAddressCode_PurchRcptHeader; "Purch. Rcpt. Header"."Order Address Code")
            {
            }
            column(EntryPoint_PurchRcptHeader; "Purch. Rcpt. Header"."Entry Point")
            {
            }
            column(Correction_PurchRcptHeader; "Purch. Rcpt. Header".Correction)
            {
            }
            column(DocumentDate_PurchRcptHeader; "Purch. Rcpt. Header"."Document Date")
            {
            }
            column(Area_PurchRcptHeader; "Purch. Rcpt. Header".Area)
            {
            }
            column(TransactionSpecification_PurchRcptHeader; "Purch. Rcpt. Header"."Transaction Specification")
            {
            }
            column(PaymentMethodCode_PurchRcptHeader; "Purch. Rcpt. Header"."Payment Method Code")
            {
            }
            column(NoSeries_PurchRcptHeader; "Purch. Rcpt. Header"."No. Series")
            {
            }
            column(OrderNoSeries_PurchRcptHeader; "Purch. Rcpt. Header"."Order No. Series")
            {
            }
            column(UserID_PurchRcptHeader; "Purch. Rcpt. Header"."User ID")
            {
            }
            column(SourceCode_PurchRcptHeader; "Purch. Rcpt. Header"."Source Code")
            {
            }
            column(TaxAreaCode_PurchRcptHeader; "Purch. Rcpt. Header"."Tax Area Code")
            {
            }
            column(TaxLiable_PurchRcptHeader; "Purch. Rcpt. Header"."Tax Liable")
            {
            }
            column(VATBusPostingGroup_PurchRcptHeader; "Purch. Rcpt. Header"."VAT Bus. Posting Group")
            {
            }
            column(VATBaseDiscount_PurchRcptHeader; "Purch. Rcpt. Header"."VAT Base Discount %")
            {
            }
            column(QuoteNo_PurchRcptHeader; "Purch. Rcpt. Header"."Quote No.")
            {
            }
            column(DimensionSetID_PurchRcptHeader; "Purch. Rcpt. Header"."Dimension Set ID")
            {
            }
            column(CampaignNo_PurchRcptHeader; "Purch. Rcpt. Header"."Campaign No.")
            {
            }
            column(BuyfromContactNo_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Contact No.")
            {
            }
            column(PaytoContactno_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Contact no.")
            {
            }
            column(ResponsibilityCenter_PurchRcptHeader; "Purch. Rcpt. Header"."Responsibility Center")
            {
            }
            column(RequestedReceiptDate_PurchRcptHeader; "Purch. Rcpt. Header"."Requested Receipt Date")
            {
            }
            column(PromisedReceiptDate_PurchRcptHeader; "Purch. Rcpt. Header"."Promised Receipt Date")
            {
            }
            column(LeadTimeCalculation_PurchRcptHeader; "Purch. Rcpt. Header"."Lead Time Calculation")
            {
            }
            column(InboundWhseHandlingTime_PurchRcptHeader; "Purch. Rcpt. Header"."Inbound Whse. Handling Time")
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
            dataitem("Purch. Rcpt. Line"; 121)
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(TotalCosts; TotalCosts)
                {
                }
                column(BuyfromVendorNo_PurchRcptLine; "Purch. Rcpt. Line"."Buy-from Vendor No.")
                {
                }
                column(DocumentNo_PurchRcptLine; "Purch. Rcpt. Line"."Document No.")
                {
                }
                column(LineNo_PurchRcptLine; "Purch. Rcpt. Line"."Line No.")
                {
                }
                column(Type_PurchRcptLine; "Purch. Rcpt. Line".Type)
                {
                }
                column(No_PurchRcptLine; "Purch. Rcpt. Line"."No.")
                {
                }
                column(LocationCode_PurchRcptLine; "Purch. Rcpt. Line"."Location Code")
                {
                }
                column(PostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."Posting Group")
                {
                }
                column(ExpectedReceiptDate_PurchRcptLine; "Purch. Rcpt. Line"."Expected Receipt Date")
                {
                }
                column(Description_PurchRcptLine; "Purch. Rcpt. Line".Description)
                {
                }
                column(Description2_PurchRcptLine; "Purch. Rcpt. Line"."Description 2")
                {
                }
                column(UnitofMeasure_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure")
                {
                }
                column(Quantity_PurchRcptLine; "Purch. Rcpt. Line".Quantity)
                {
                }
                column(DirectUnitCost_PurchRcptLine; "Purch. Rcpt. Line"."Direct Unit Cost")
                {
                }
                column(UnitCostLCY_PurchRcptLine; "Purch. Rcpt. Line"."Unit Cost (LCY)")
                {
                }
                column(VAT_PurchRcptLine; "Purch. Rcpt. Line"."VAT %")
                {
                }
                column(LineDiscount_PurchRcptLine; "Purch. Rcpt. Line"."Line Discount %")
                {
                }
                column(UnitPriceLCY_PurchRcptLine; "Purch. Rcpt. Line"."Unit Price (LCY)")
                {
                }
                column(AllowInvoiceDisc_PurchRcptLine; "Purch. Rcpt. Line"."Allow Invoice Disc.")
                {
                }
                column(GrossWeight_PurchRcptLine; "Purch. Rcpt. Line"."Gross Weight")
                {
                }
                column(NetWeight_PurchRcptLine; "Purch. Rcpt. Line"."Net Weight")
                {
                }
                column(UnitsperParcel_PurchRcptLine; "Purch. Rcpt. Line"."Units per Parcel")
                {
                }
                column(UnitVolume_PurchRcptLine; "Purch. Rcpt. Line"."Unit Volume")
                {
                }
                column(AppltoItemEntry_PurchRcptLine; "Purch. Rcpt. Line"."Appl.-to Item Entry")
                {
                }
                column(ItemRcptEntryNo_PurchRcptLine; "Purch. Rcpt. Line"."Item Rcpt. Entry No.")
                {
                }
                column(ShortcutDimension1Code_PurchRcptLine; "Purch. Rcpt. Line"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_PurchRcptLine; "Purch. Rcpt. Line"."Shortcut Dimension 2 Code")
                {
                }
                column(JobNo_PurchRcptLine; "Purch. Rcpt. Line"."Job No.")
                {
                }
                column(IndirectCost_PurchRcptLine; "Purch. Rcpt. Line"."Indirect Cost %")
                {
                }
                column(QtyRcdNotInvoiced_PurchRcptLine; "Purch. Rcpt. Line"."Qty. Rcd. Not Invoiced")
                {
                }
                column(QuantityInvoiced_PurchRcptLine; "Purch. Rcpt. Line"."Quantity Invoiced")
                {
                }
                column(OrderNo_PurchRcptLine; "Purch. Rcpt. Line"."Order No.")
                {
                }
                column(OrderLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Order Line No.")
                {
                }
                column(PaytoVendorNo_PurchRcptLine; "Purch. Rcpt. Line"."Pay-to Vendor No.")
                {
                }
                column(VendorItemNo_PurchRcptLine; "Purch. Rcpt. Line"."Vendor Item No.")
                {
                }
                column(SalesOrderNo_PurchRcptLine; "Purch. Rcpt. Line"."Sales Order No.")
                {
                }
                column(SalesOrderLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Sales Order Line No.")
                {
                }
                column(GenBusPostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."Gen. Bus. Posting Group")
                {
                }
                column(GenProdPostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."Gen. Prod. Posting Group")
                {
                }
                column(VATCalculationType_PurchRcptLine; "Purch. Rcpt. Line"."VAT Calculation Type")
                {
                }
                column(TransactionType_PurchRcptLine; "Purch. Rcpt. Line"."Transaction Type")
                {
                }
                column(TransportMethod_PurchRcptLine; "Purch. Rcpt. Line"."Transport Method")
                {
                }
                column(AttachedtoLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Attached to Line No.")
                {
                }
                column(EntryPoint_PurchRcptLine; "Purch. Rcpt. Line"."Entry Point")
                {
                }
                column(Area_PurchRcptLine; "Purch. Rcpt. Line".Area)
                {
                }
                column(TransactionSpecification_PurchRcptLine; "Purch. Rcpt. Line"."Transaction Specification")
                {
                }
                column(TaxAreaCode_PurchRcptLine; "Purch. Rcpt. Line"."Tax Area Code")
                {
                }
                column(TaxLiable_PurchRcptLine; "Purch. Rcpt. Line"."Tax Liable")
                {
                }
                column(TaxGroupCode_PurchRcptLine; "Purch. Rcpt. Line"."Tax Group Code")
                {
                }
                column(UseTax_PurchRcptLine; "Purch. Rcpt. Line"."Use Tax")
                {
                }
                column(VATBusPostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."VAT Bus. Posting Group")
                {
                }
                column(VATProdPostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."VAT Prod. Posting Group")
                {
                }
                column(CurrencyCode_PurchRcptLine; "Purch. Rcpt. Line"."Currency Code")
                {
                }
                column(BlanketOrderNo_PurchRcptLine; "Purch. Rcpt. Line"."Blanket Order No.")
                {
                }
                column(BlanketOrderLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Blanket Order Line No.")
                {
                }
                column(VATBaseAmount_PurchRcptLine; "Purch. Rcpt. Line"."VAT Base Amount")
                {
                }
                column(UnitCost_PurchRcptLine; "Purch. Rcpt. Line"."Unit Cost")
                {
                }
                column(ICPartnerRefType_PurchRcptLine; "Purch. Rcpt. Line"."IC Partner Ref. Type")
                {
                }
                column(ICPartnerReference_PurchRcptLine; "Purch. Rcpt. Line"."IC Partner Reference")
                {
                }
                column(PostingDate_PurchRcptLine; "Purch. Rcpt. Line"."Posting Date")
                {
                }
                column(DimensionSetID_PurchRcptLine; "Purch. Rcpt. Line"."Dimension Set ID")
                {
                }
                column(JobTaskNo_PurchRcptLine; "Purch. Rcpt. Line"."Job Task No.")
                {
                }
                column(JobLineType_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Type")
                {
                }
                column(JobUnitPrice_PurchRcptLine; "Purch. Rcpt. Line"."Job Unit Price")
                {
                }
                column(JobTotalPrice_PurchRcptLine; "Purch. Rcpt. Line"."Job Total Price")
                {
                }
                column(JobLineAmount_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Amount")
                {
                }
                column(JobLineDiscountAmount_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Discount Amount")
                {
                }
                column(JobLineDiscount_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Discount %")
                {
                }
                column(JobUnitPriceLCY_PurchRcptLine; "Purch. Rcpt. Line"."Job Unit Price (LCY)")
                {
                }
                column(JobTotalPriceLCY_PurchRcptLine; "Purch. Rcpt. Line"."Job Total Price (LCY)")
                {
                }
                column(JobLineAmountLCY_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Amount (LCY)")
                {
                }
                column(JobLineDiscAmountLCY_PurchRcptLine; "Purch. Rcpt. Line"."Job Line Disc. Amount (LCY)")
                {
                }
                column(JobCurrencyFactor_PurchRcptLine; "Purch. Rcpt. Line"."Job Currency Factor")
                {
                }
                column(JobCurrencyCode_PurchRcptLine; "Purch. Rcpt. Line"."Job Currency Code")
                {
                }
                column(ProdOrderNo_PurchRcptLine; "Purch. Rcpt. Line"."Prod. Order No.")
                {
                }
                column(VariantCode_PurchRcptLine; "Purch. Rcpt. Line"."Variant Code")
                {
                }
                column(BinCode_PurchRcptLine; "Purch. Rcpt. Line"."Bin Code")
                {
                }
                column(QtyperUnitofMeasure_PurchRcptLine; "Purch. Rcpt. Line"."Qty. per Unit of Measure")
                {
                }
                column(UnitofMeasureCode_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure Code")
                {
                }
                column(QuantityBase_PurchRcptLine; "Purch. Rcpt. Line"."Quantity (Base)")
                {
                }
                column(QtyInvoicedBase_PurchRcptLine; "Purch. Rcpt. Line"."Qty. Invoiced (Base)")
                {
                }
                column(FAPostingDate_PurchRcptLine; "Purch. Rcpt. Line"."FA Posting Date")
                {
                }
                column(FAPostingType_PurchRcptLine; "Purch. Rcpt. Line"."FA Posting Type")
                {
                }
                column(DepreciationBookCode_PurchRcptLine; "Purch. Rcpt. Line"."Depreciation Book Code")
                {
                }
                column(SalvageValue_PurchRcptLine; "Purch. Rcpt. Line"."Salvage Value")
                {
                }
                column(DepruntilFAPostingDate_PurchRcptLine; "Purch. Rcpt. Line"."Depr. until FA Posting Date")
                {
                }
                column(DeprAcquisitionCost_PurchRcptLine; "Purch. Rcpt. Line"."Depr. Acquisition Cost")
                {
                }
                column(MaintenanceCode_PurchRcptLine; "Purch. Rcpt. Line"."Maintenance Code")
                {
                }
                column(InsuranceNo_PurchRcptLine; "Purch. Rcpt. Line"."Insurance No.")
                {
                }
                column(BudgetedFANo_PurchRcptLine; "Purch. Rcpt. Line"."Budgeted FA No.")
                {
                }
                column(DuplicateinDepreciationBook_PurchRcptLine; "Purch. Rcpt. Line"."Duplicate in Depreciation Book")
                {
                }
                column(UseDuplicationList_PurchRcptLine; "Purch. Rcpt. Line"."Use Duplication List")
                {
                }
                column(ResponsibilityCenter_PurchRcptLine; "Purch. Rcpt. Line"."Responsibility Center")
                {
                }
                column(CrossReferenceNo_PurchRcptLine; "Purch. Rcpt. Line"."Item Reference No.")
                {
                }
                column(UnitofMeasureCrossRef_PurchRcptLine; "Purch. Rcpt. Line"."Item Reference Unit of Measure")
                {
                }
                column(CrossReferenceType_PurchRcptLine; "Purch. Rcpt. Line"."Item Reference Type")
                {
                }
                column(CrossReferenceTypeNo_PurchRcptLine; "Purch. Rcpt. Line"."Item Reference Type No.")
                {
                }
                column(ItemCategoryCode_PurchRcptLine; "Purch. Rcpt. Line"."Item Category Code")
                {
                }
                column(Nonstock_PurchRcptLine; "Purch. Rcpt. Line".Nonstock)
                {
                }
                column(PurchasingCode_PurchRcptLine; "Purch. Rcpt. Line"."Purchasing Code")
                {
                }
                /* column(ProductGroupCode_PurchRcptLine; "Purch. Rcpt. Line"."Product Group Code")
                {
                } */
                column(SpecialOrderSalesNo_PurchRcptLine; "Purch. Rcpt. Line"."Special Order Sales No.")
                {
                }
                column(SpecialOrderSalesLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Special Order Sales Line No.")
                {
                }
                column(RequestedReceiptDate_PurchRcptLine; "Purch. Rcpt. Line"."Requested Receipt Date")
                {
                }
                column(PromisedReceiptDate_PurchRcptLine; "Purch. Rcpt. Line"."Promised Receipt Date")
                {
                }
                column(LeadTimeCalculation_PurchRcptLine; "Purch. Rcpt. Line"."Lead Time Calculation")
                {
                }
                column(InboundWhseHandlingTime_PurchRcptLine; "Purch. Rcpt. Line"."Inbound Whse. Handling Time")
                {
                }
                column(PlannedReceiptDate_PurchRcptLine; "Purch. Rcpt. Line"."Planned Receipt Date")
                {
                }
                column(OrderDate_PurchRcptLine; "Purch. Rcpt. Line"."Order Date")
                {
                }
                column(ItemChargeBaseAmount_PurchRcptLine; "Purch. Rcpt. Line"."Item Charge Base Amount")
                {
                }
                column(Correction_PurchRcptLine; "Purch. Rcpt. Line".Correction)
                {
                }
                column(ReturnReasonCode_PurchRcptLine; "Purch. Rcpt. Line"."Return Reason Code")
                {
                }
                column(RoutingNo_PurchRcptLine; "Purch. Rcpt. Line"."Routing No.")
                {
                }
                column(OperationNo_PurchRcptLine; "Purch. Rcpt. Line"."Operation No.")
                {
                }
                column(WorkCenterNo_PurchRcptLine; "Purch. Rcpt. Line"."Work Center No.")
                {
                }
                column(ProdOrderLineNo_PurchRcptLine; "Purch. Rcpt. Line"."Prod. Order Line No.")
                {
                }
                column(OverheadRate_PurchRcptLine; "Purch. Rcpt. Line"."Overhead Rate")
                {
                }
                column(RoutingReferenceNo_PurchRcptLine; "Purch. Rcpt. Line"."Routing Reference No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TotalCosts := "Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Unit Cost";
                end;
            }
            dataitem("Approval Entry"; 454)
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Status = CONST(Approved));
                column(SequenceNo; "Approval Entry"."Sequence No.")
                {
                }
                column(LastDateTimeModified; "Approval Entry"."Last Date-Time Modified")
                {
                }
                column(ApproverID; "Approval Entry"."Approver ID")
                {
                }
                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID")
                {
                }
                column(SenderID; "Approval Entry"."Sender ID")
                {
                }
                dataitem(Employee; 5200)
                {
                    DataItemLink = "User ID" = FIELD("Approver ID");
                    column(EmployeeFirstName; Employee."First Name")
                    {
                    }
                    column(EmployeeMiddleName; Employee."Middle Name")
                    {
                    }
                    column(EmployeeLastName; Employee."Last Name")
                    {
                    }
                    column(EmployeeSignature; Employee."Employee Signature")
                    {
                    }
                }
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

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture)
    end;

    var
        CompanyInfo: Record 79;
        TotalCosts: Decimal;
}


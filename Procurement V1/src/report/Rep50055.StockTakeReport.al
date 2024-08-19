report 50055 "Stock Take Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Stock Take Report.rdlc';

    dataset
    {
        dataitem("Item Journal Line"; 83)
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            column(JournalTemplateName_ItemJournalLine; "Item Journal Line"."Journal Template Name")
            {
            }
            column(LineNo_ItemJournalLine; "Item Journal Line"."Line No.")
            {
            }
            column(ItemNo_ItemJournalLine; "Item Journal Line"."Item No.")
            {
            }
            column(PostingDate_ItemJournalLine; "Item Journal Line"."Posting Date")
            {
            }
            column(EntryType_ItemJournalLine; "Item Journal Line"."Entry Type")
            {
            }
            column(SourceNo_ItemJournalLine; "Item Journal Line"."Source No.")
            {
            }
            column(DocumentNo_ItemJournalLine; "Item Journal Line"."Document No.")
            {
            }
            column(Description_ItemJournalLine; "Item Journal Line".Description)
            {
            }
            column(LocationCode_ItemJournalLine; "Item Journal Line"."Location Code")
            {
            }
            column(InventoryPostingGroup_ItemJournalLine; "Item Journal Line"."Inventory Posting Group")
            {
            }
            column(SourcePostingGroup_ItemJournalLine; "Item Journal Line"."Source Posting Group")
            {
            }
            column(Quantity_ItemJournalLine; "Item Journal Line".Quantity)
            {
            }
            column(InvoicedQuantity_ItemJournalLine; "Item Journal Line"."Invoiced Quantity")
            {
            }
            column(UnitAmount_ItemJournalLine; "Item Journal Line"."Unit Amount")
            {
            }
            column(UnitCost_ItemJournalLine; "Item Journal Line"."Unit Cost")
            {
            }
            column(Amount_ItemJournalLine; "Item Journal Line".Amount)
            {
            }
            column(DiscountAmount_ItemJournalLine; "Item Journal Line"."Discount Amount")
            {
            }
            column(SalespersPurchCode_ItemJournalLine; "Item Journal Line"."Salespers./Purch. Code")
            {
            }
            column(SourceCode_ItemJournalLine; "Item Journal Line"."Source Code")
            {
            }
            column(AppliestoEntry_ItemJournalLine; "Item Journal Line"."Applies-to Entry")
            {
            }
            column(ItemShptEntryNo_ItemJournalLine; "Item Journal Line"."Item Shpt. Entry No.")
            {
            }
            column(ShortcutDimension1Code_ItemJournalLine; "Item Journal Line"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_ItemJournalLine; "Item Journal Line"."Shortcut Dimension 2 Code")
            {
            }
            column(IndirectCost_ItemJournalLine; "Item Journal Line"."Indirect Cost %")
            {
            }
            column(SourceType_ItemJournalLine; "Item Journal Line"."Source Type")
            {
            }
            column(JournalBatchName_ItemJournalLine; "Item Journal Line"."Journal Batch Name")
            {
            }
            column(ReasonCode_ItemJournalLine; "Item Journal Line"."Reason Code")
            {
            }
            column(RecurringMethod_ItemJournalLine; "Item Journal Line"."Recurring Method")
            {
            }
            column(ExpirationDate_ItemJournalLine; "Item Journal Line"."Expiration Date")
            {
            }
            column(RecurringFrequency_ItemJournalLine; "Item Journal Line"."Recurring Frequency")
            {
            }
            column(DropShipment_ItemJournalLine; "Item Journal Line"."Drop Shipment")
            {
            }
            column(TransactionType_ItemJournalLine; "Item Journal Line"."Transaction Type")
            {
            }
            column(TransportMethod_ItemJournalLine; "Item Journal Line"."Transport Method")
            {
            }
            column(CountryRegionCode_ItemJournalLine; "Item Journal Line"."Country/Region Code")
            {
            }
            column(NewLocationCode_ItemJournalLine; "Item Journal Line"."New Location Code")
            {
            }
            column(NewShortcutDimension1Code_ItemJournalLine; "Item Journal Line"."New Shortcut Dimension 1 Code")
            {
            }
            column(NewShortcutDimension2Code_ItemJournalLine; "Item Journal Line"."New Shortcut Dimension 2 Code")
            {
            }
            column(QtyCalculated_ItemJournalLine; "Item Journal Line"."Qty. (Calculated)")
            {
            }
            column(QtyPhysInventory_ItemJournalLine; "Item Journal Line"."Qty. (Phys. Inventory)")
            {
            }
            column(LastItemLedgerEntryNo_ItemJournalLine; "Item Journal Line"."Last Item Ledger Entry No.")
            {
            }
            column(PhysInventory_ItemJournalLine; "Item Journal Line"."Phys. Inventory")
            {
            }
            column(GenBusPostingGroup_ItemJournalLine; "Item Journal Line"."Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostingGroup_ItemJournalLine; "Item Journal Line"."Gen. Prod. Posting Group")
            {
            }
            column(EntryExitPoint_ItemJournalLine; "Item Journal Line"."Entry/Exit Point")
            {
            }
            column(DocumentDate_ItemJournalLine; "Item Journal Line"."Document Date")
            {
            }
            column(ExternalDocumentNo_ItemJournalLine; "Item Journal Line"."External Document No.")
            {
            }
            column(Area_ItemJournalLine; "Item Journal Line".Area)
            {
            }
            column(TransactionSpecification_ItemJournalLine; "Item Journal Line"."Transaction Specification")
            {
            }
            column(PostingNoSeries_ItemJournalLine; "Item Journal Line"."Posting No. Series")
            {
            }
            column(ReservedQuantity_ItemJournalLine; "Item Journal Line"."Reserved Quantity")
            {
            }
            column(UnitCostACY_ItemJournalLine; "Item Journal Line"."Unit Cost (ACY)")
            {
            }
            column(SourceCurrencyCode_ItemJournalLine; "Item Journal Line"."Source Currency Code")
            {
            }
            column(DocumentType_ItemJournalLine; "Item Journal Line"."Document Type")
            {
            }
            column(DocumentLineNo_ItemJournalLine; "Item Journal Line"."Document Line No.")
            {
            }
            column(OrderType_ItemJournalLine; "Item Journal Line"."Order Type")
            {
            }
            column(OrderNo_ItemJournalLine; "Item Journal Line"."Order No.")
            {
            }
            column(OrderLineNo_ItemJournalLine; "Item Journal Line"."Order Line No.")
            {
            }
            column(DimensionSetID_ItemJournalLine; "Item Journal Line"."Dimension Set ID")
            {
            }
            column(NewDimensionSetID_ItemJournalLine; "Item Journal Line"."New Dimension Set ID")
            {
            }
            column(AssembletoOrder_ItemJournalLine; "Item Journal Line"."Assemble to Order")
            {
            }
            column(JobNo_ItemJournalLine; "Item Journal Line"."Job No.")
            {
            }
            column(JobTaskNo_ItemJournalLine; "Item Journal Line"."Job Task No.")
            {
            }
            column(JobPurchase_ItemJournalLine; "Item Journal Line"."Job Purchase")
            {
            }
            column(JobContractEntryNo_ItemJournalLine; "Item Journal Line"."Job Contract Entry No.")
            {
            }
            column(VariantCode_ItemJournalLine; "Item Journal Line"."Variant Code")
            {
            }
            column(BinCode_ItemJournalLine; "Item Journal Line"."Bin Code")
            {
            }
            column(QtyperUnitofMeasure_ItemJournalLine; "Item Journal Line"."Qty. per Unit of Measure")
            {
            }
            column(NewBinCode_ItemJournalLine; "Item Journal Line"."New Bin Code")
            {
            }
            column(UnitofMeasureCode_ItemJournalLine; "Item Journal Line"."Unit of Measure Code")
            {
            }
            column(DerivedfromBlanketOrder_ItemJournalLine; "Item Journal Line"."Derived from Blanket Order")
            {
            }
            column(QuantityBase_ItemJournalLine; "Item Journal Line"."Quantity (Base)")
            {
            }
            column(InvoicedQtyBase_ItemJournalLine; "Item Journal Line"."Invoiced Qty. (Base)")
            {
            }
            column(ReservedQtyBase_ItemJournalLine; "Item Journal Line"."Reserved Qty. (Base)")
            {
            }
            column(Level_ItemJournalLine; "Item Journal Line".Level)
            {
            }
            column(FlushingMethod_ItemJournalLine; "Item Journal Line"."Flushing Method")
            {
            }
            column(ChangedbyUser_ItemJournalLine; "Item Journal Line"."Changed by User")
            {
            }
            column(CrossReferenceNo_ItemJournalLine; "Item Journal Line"."Item Reference No.")
            {
            }
            column(OriginallyOrderedNo_ItemJournalLine; "Item Journal Line"."Originally Ordered No.")
            {
            }
            column(OriginallyOrderedVarCode_ItemJournalLine; "Item Journal Line"."Originally Ordered Var. Code")
            {
            }
            column(OutofStockSubstitution_ItemJournalLine; "Item Journal Line"."Out-of-Stock Substitution")
            {
            }
            column(ItemCategoryCode_ItemJournalLine; "Item Journal Line"."Item Category Code")
            {
            }
            column(Nonstock_ItemJournalLine; "Item Journal Line".Nonstock)
            {
            }
            column(PurchasingCode_ItemJournalLine; "Item Journal Line"."Purchasing Code")
            {
            }
            /*             column(ProductGroupCode_ItemJournalLine; "Item Journal Line"."Product Group Code")
                        {
                        } */
            column(PlannedDeliveryDate_ItemJournalLine; "Item Journal Line"."Planned Delivery Date")
            {
            }
            column(OrderDate_ItemJournalLine; "Item Journal Line"."Order Date")
            {
            }
            column(ValueEntryType_ItemJournalLine; "Item Journal Line"."Value Entry Type")
            {
            }
            column(ItemChargeNo_ItemJournalLine; "Item Journal Line"."Item Charge No.")
            {
            }
            column(InventoryValueCalculated_ItemJournalLine; "Item Journal Line"."Inventory Value (Calculated)")
            {
            }
            column(InventoryValueRevalued_ItemJournalLine; "Item Journal Line"."Inventory Value (Revalued)")
            {
            }
            column(VarianceType_ItemJournalLine; "Item Journal Line"."Variance Type")
            {
            }
            column(InventoryValuePer_ItemJournalLine; "Item Journal Line"."Inventory Value Per")
            {
            }
            column(PartialRevaluation_ItemJournalLine; "Item Journal Line"."Partial Revaluation")
            {
            }
            column(AppliesfromEntry_ItemJournalLine; "Item Journal Line"."Applies-from Entry")
            {
            }
            column(InvoiceNo_ItemJournalLine; "Item Journal Line"."Invoice No.")
            {
            }
            column(UnitCostCalculated_ItemJournalLine; "Item Journal Line"."Unit Cost (Calculated)")
            {
            }
            column(UnitCostRevalued_ItemJournalLine; "Item Journal Line"."Unit Cost (Revalued)")
            {
            }
            column(AppliedAmount_ItemJournalLine; "Item Journal Line"."Applied Amount")
            {
            }
            column(UpdateStandardCost_ItemJournalLine; "Item Journal Line"."Update Standard Cost")
            {
            }
            column(AmountACY_ItemJournalLine; "Item Journal Line"."Amount (ACY)")
            {
            }
            column(Correction_ItemJournalLine; "Item Journal Line".Correction)
            {
            }
            column(Adjustment_ItemJournalLine; "Item Journal Line".Adjustment)
            {
            }
            column(AppliestoValueEntry_ItemJournalLine; "Item Journal Line"."Applies-to Value Entry")
            {
            }
            column(InvoicetoSourceNo_ItemJournalLine; "Item Journal Line"."Invoice-to Source No.")
            {
            }
            column(Type_ItemJournalLine; "Item Journal Line".Type)
            {
            }
            column(No_ItemJournalLine; "Item Journal Line"."No.")
            {
            }
            column(OperationNo_ItemJournalLine; "Item Journal Line"."Operation No.")
            {
            }
            column(WorkCenterNo_ItemJournalLine; "Item Journal Line"."Work Center No.")
            {
            }
            column(SetupTime_ItemJournalLine; "Item Journal Line"."Setup Time")
            {
            }
            column(RunTime_ItemJournalLine; "Item Journal Line"."Run Time")
            {
            }
            column(StopTime_ItemJournalLine; "Item Journal Line"."Stop Time")
            {
            }
            column(OutputQuantity_ItemJournalLine; "Item Journal Line"."Output Quantity")
            {
            }
            column(ScrapQuantity_ItemJournalLine; "Item Journal Line"."Scrap Quantity")
            {
            }
            column(ConcurrentCapacity_ItemJournalLine; "Item Journal Line"."Concurrent Capacity")
            {
            }
            column(SetupTimeBase_ItemJournalLine; "Item Journal Line"."Setup Time (Base)")
            {
            }
            column(RunTimeBase_ItemJournalLine; "Item Journal Line"."Run Time (Base)")
            {
            }
            column(StopTimeBase_ItemJournalLine; "Item Journal Line"."Stop Time (Base)")
            {
            }
            column(OutputQuantityBase_ItemJournalLine; "Item Journal Line"."Output Quantity (Base)")
            {
            }
            column(ScrapQuantityBase_ItemJournalLine; "Item Journal Line"."Scrap Quantity (Base)")
            {
            }
            column(CapUnitofMeasureCode_ItemJournalLine; "Item Journal Line"."Cap. Unit of Measure Code")
            {
            }
            column(QtyperCapUnitofMeasure_ItemJournalLine; "Item Journal Line"."Qty. per Cap. Unit of Measure")
            {
            }
            column(StartingTime_ItemJournalLine; "Item Journal Line"."Starting Time")
            {
            }
            column(EndingTime_ItemJournalLine; "Item Journal Line"."Ending Time")
            {
            }
            column(RoutingNo_ItemJournalLine; "Item Journal Line"."Routing No.")
            {
            }
            column(RoutingReferenceNo_ItemJournalLine; "Item Journal Line"."Routing Reference No.")
            {
            }
            column(ProdOrderCompLineNo_ItemJournalLine; "Item Journal Line"."Prod. Order Comp. Line No.")
            {
            }
            column(Finished_ItemJournalLine; "Item Journal Line".Finished)
            {
            }
            column(UnitCostCalculation_ItemJournalLine; "Item Journal Line"."Unit Cost Calculation")
            {
            }
            column(Subcontracting_ItemJournalLine; "Item Journal Line".Subcontracting)
            {
            }
            column(StopCode_ItemJournalLine; "Item Journal Line"."Stop Code")
            {
            }
            column(ScrapCode_ItemJournalLine; "Item Journal Line"."Scrap Code")
            {
            }
            column(WorkCenterGroupCode_ItemJournalLine; "Item Journal Line"."Work Center Group Code")
            {
            }
            column(WorkShiftCode_ItemJournalLine; "Item Journal Line"."Work Shift Code")
            {
            }
            column(SerialNo_ItemJournalLine; "Item Journal Line"."Serial No.")
            {
            }
            column(LotNo_ItemJournalLine; "Item Journal Line"."Lot No.")
            {
            }
            column(WarrantyDate_ItemJournalLine; "Item Journal Line"."Warranty Date")
            {
            }
            column(NewSerialNo_ItemJournalLine; "Item Journal Line"."New Serial No.")
            {
            }
            column(NewLotNo_ItemJournalLine; "Item Journal Line"."New Lot No.")
            {
            }
            column(NewItemExpirationDate_ItemJournalLine; "Item Journal Line"."New Item Expiration Date")
            {
            }
            column(ItemExpirationDate_ItemJournalLine; "Item Journal Line"."Item Expiration Date")
            {
            }
            column(ReturnReasonCode_ItemJournalLine; "Item Journal Line"."Return Reason Code")
            {
            }
            column(WarehouseAdjustment_ItemJournalLine; "Item Journal Line"."Warehouse Adjustment")
            {
            }
            column(DirectTransfer_ItemJournalLine; "Item Journal Line"."Direct Transfer")
            {
            }
            column(PhysInvtCountingPeriodCode_ItemJournalLine; "Item Journal Line"."Phys Invt Counting Period Code")
            {
            }
            column(PhysInvtCountingPeriodType_ItemJournalLine; "Item Journal Line"."Phys Invt Counting Period Type")
            {
            }
            column(OverheadRate_ItemJournalLine; "Item Journal Line"."Overhead Rate")
            {
            }
            column(SingleLevelMaterialCost_ItemJournalLine; "Item Journal Line"."Single-Level Material Cost")
            {
            }
            column(SingleLevelCapacityCost_ItemJournalLine; "Item Journal Line"."Single-Level Capacity Cost")
            {
            }
            column(SingleLevelSubcontrdCost_ItemJournalLine; "Item Journal Line"."Single-Level Subcontrd. Cost")
            {
            }
            column(SingleLevelCapOvhdCost_ItemJournalLine; "Item Journal Line"."Single-Level Cap. Ovhd Cost")
            {
            }
            column(SingleLevelMfgOvhdCost_ItemJournalLine; "Item Journal Line"."Single-Level Mfg. Ovhd Cost")
            {
            }
            column(RolledupMaterialCost_ItemJournalLine; "Item Journal Line"."Rolled-up Material Cost")
            {
            }
            column(RolledupCapacityCost_ItemJournalLine; "Item Journal Line"."Rolled-up Capacity Cost")
            {
            }
            column(RolledupSubcontractedCost_ItemJournalLine; "Item Journal Line"."Rolled-up Subcontracted Cost")
            {
            }
            column(RolledupMfgOvhdCost_ItemJournalLine; "Item Journal Line"."Rolled-up Mfg. Ovhd Cost")
            {
            }
            column(RolledupCapOverheadCost_ItemJournalLine; "Item Journal Line"."Rolled-up Cap. Overhead Cost")
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
}


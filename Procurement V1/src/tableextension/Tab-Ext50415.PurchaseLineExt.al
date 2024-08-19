tableextension 50415 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Editable = false;
            /* 
                        trigger OnValidate()
                        begin
                            GetPurchHeader;
                            Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                            CASE "VAT Calculation Type" OF
                                "VAT Calculation Type"::"Normal VAT",
                                "VAT Calculation Type"::"Reverse Charge VAT":
                                    BEGIN
                                        "VAT Base Amount" :=
                                          ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                                        "Amount Including VAT" :=
                                          ROUND(Amount + "VAT Base Amount" * "VAT %" / 100, Currency."Amount Rounding Precision");
                                    END;
                                "VAT Calculation Type"::"Full VAT":
                                    IF Amount <> 0 THEN
                                        FIELDERROR(Amount,
                                          STRSUBSTNO(
                                            Text011, FIELDCAPTION("VAT Calculation Type"),
                                            "VAT Calculation Type"));
                                "VAT Calculation Type"::"Sales Tax":
                                    BEGIN
                                        PurchHeader.TESTFIELD("VAT Base Discount %", 0);
                                        "VAT Base Amount" := Amount;
                                        IF "Use Tax" THEN
                                            "Amount Including VAT" := "VAT Base Amount"
                                        ELSE BEGIN
                                            "Amount Including VAT" :=
                                              Amount +
                                              ROUND(
                                                SalesTaxCalculate.CalculateTax(
                                                  "Tax Area Code", "Tax Group Code", "Tax Liable", PurchHeader."Posting Date",
                                                  "VAT Base Amount", "Quantity (Base)", PurchHeader."Currency Factor"),
                                                Currency."Amount Rounding Precision");
                                            IF "VAT Base Amount" <> 0 THEN
                                                "VAT %" :=
                                                  ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                                            ELSE
                                                "VAT %" := 0;
                                        END;
                                    END;
                            END;

                            InitOutstandingAmount;
                            UpdateUnitCost;
                        end; */
        }
        field(50001; "Amount Including VAT  LPO"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                GetPurchHeader;
                "Amount Including VAT" := ROUND("Amount Including VAT", Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        BEGIN
                            Amount :=
                              ROUND(
                                "Amount Including VAT" /
                                (1 + (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                                Currency."Amount Rounding Precision");
                            "VAT Base Amount" :=
                              ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                        END;
                    "VAT Calculation Type"::"Full VAT":
                        BEGIN
                            Amount := 0;
                            "VAT Base Amount" := 0;
                        END;
                    "VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            PurchHeader.TESTFIELD("VAT Base Discount %", 0);
                            IF "Use Tax" THEN BEGIN
                                Amount := "Amount Including VAT";
                                "VAT Base Amount" := Amount;
                            END ELSE BEGIN
                                /*  Amount :=
                                   ROUND(
                                     SalesTaxCalculate.ReverseCalculateTax(
                                       "Tax Area Code", "Tax Group Code", "Tax Liable", PurchHeader."Posting Date",
                                       "Amount Including VAT", "Quantity (Base)", PurchHeader."Currency Factor"),
                                     Currency."Amount Rounding Precision");
                                 "VAT Base Amount" := Amount; */
                                IF "VAT Base Amount" <> 0 THEN
                                    "VAT %" :=
                                      ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                                ELSE
                                    "VAT %" := 0;
                            END;
                        END;
                END;

                InitOutstandingAmount;
                UpdateUnitCost;
            end;

        }
        field(50002; "Unit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                VATProductPostingGroup.GET("VAT Prod. Posting Group");

                "Direct Unit Cost" := ROUND("Unit Amount" * ((100 + VATProductPostingGroup.Percentage) / 100), 0.01);
                VALIDATE("Direct Unit Cost");
                "Base Amount" := "Unit Amount" * Quantity;
            end;
        }
        field(52136923; "Purchase Requisition Line"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre NextGen Addon field, Specifies the purchase requisition line no. for the attached requisition line';
        }
        field(52136924; "Purchase Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Sysre NextGen Addon field, Specifies the purchase requisition document no. for the attached requisition line';
        }
        field(52136925; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(52136926; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(52136927; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(52136928; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(52136929; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(52136930; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(52136931; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
        }
        field(52136983; "Request for Quotation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Request for Quotation Header"."No." WHERE(Status = CONST(Released));

            trigger OnValidate()
            begin
                //Sysre NextGen Addon
                TESTFIELD("Buy-from Vendor No.");
                //Check if the selected vendor was part of the RFQ
                /*RequestforQuotationVendors.RESET;
                RequestforQuotationVendors.SETRANGE(RequestforQuotationVendors."RFQ Document No.","Request for Quotation Code");
                RequestforQuotationVendors.SETRANGE(RequestforQuotationVendors."Vendor No.","Buy-from Vendor No.");
                IF NOT RequestforQuotationVendors.FINDFIRST THEN BEGIN
                  ERROR(Text057,RequestforQuotationVendors."RFQ Document No.");
                END;*/
                //End Check

                /*IF CONFIRM(Text055) THEN BEGIN
                  ProcurementManagement.CreatePurchaseQuoteLinesfromRFQ(Rec,"Request for Quotation Code");
                END ELSE BEGIN
                  ERROR(Text056);
                END
                //End Sysre NextGen Addon


            ;*/
            end;
        }
        field(52136984; "Type (Attributes)"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Purchase Requisition,LPO,Procurement Planning';
            OptionMembers = "Purchase Requisition",LPO,"Procurement Planning";
        }
        field(52136985; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136986; "LPO No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52136987; "Purchase Order Line"; Integer)
        {
            DataClassification = ToBeClassified;
        }


    }


    var
        Text000: Label 'You cannot rename a %1.';
        Text001: Label 'You cannot change %1 because the order line is associated with sales order %2.';
        Text002: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        Text003: Label 'You cannot purchase resources.';
        Text004: Label 'must not be less than %1';
        Text006: Label 'You cannot invoice more than %1 units.';
        Text007: Label 'You cannot invoice more than %1 base units.';
        Text008: Label 'You cannot receive more than %1 units.';
        Text009: Label 'You cannot receive more than %1 base units.';
        Text010: Label 'You cannot change %1 when %2 is %3.';
        Text011: Label ' must be 0 when %1 is %2';
        Text012: Label 'must not be specified when %1 = %2';
        Text016: Label '%1 is required for %2 = %3.';
        Text017: Label '\The entered information may be disregarded by warehouse operations.';
        Text018: Label '%1 %2 is earlier than the work date %3.';
        Text020: Label 'You cannot return more than %1 units.';
        Text021: Label 'You cannot return more than %1 base units.';
        Text022: Label 'You cannot change %1, if item charge is already posted.';
        Text023: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text029: Label 'must be positive.';
        Text030: Label 'must be negative.';
        Text031: Label 'You cannot define item tracking on this line because it is linked to production order %1.';
        Text032: Label '%1 must not be greater than the sum of %2 and %3.';
        Text033: Label 'Warehouse ';
        Text034: Label 'Inventory ';
        Text035: Label '%1 units for %2 %3 have already been returned or transferred. Therefore, only %4 units can be returned.';
        Text037: Label 'cannot be %1.';
        Text038: Label 'cannot be less than %1.';
        Text039: Label 'cannot be more than %1.';
        Text040: Label 'You must use form %1 to enter %2, if item tracking is used.';
        ItemChargeAssignmentErr: Label 'You can only assign Item Charges for Line Types of Charge (Item).';
        Text99000000: Label 'You cannot change %1 when the purchase order is associated to a production order.';
        PurchHeader: Record 38;
        PurchLine2: Record 39;
        GLAcc: Record 15;
        Item: Record 27;
        Currency: Record 4;
        CurrExchRate: Record 330;
        VATPostingSetup: Record 325;
        GenBusPostingGrp: Record 250;
        GenProdPostingGrp: Record 251;
        UnitOfMeasure: Record 204;
        ItemCharge: Record 5800;
        SKU: Record 5700;
        WorkCenter: Record 99000754;
        InvtSetup: Record 313;
        Location: Record 14;
        GLSetup: Record 98;
        CalChange: Record 7602;
        TempJobJnlLine: Record 210 temporary;
        PurchSetup: Record 312;

        TrackingBlocked: Boolean;
        StatusCheckSuspended: Boolean;
        GLSetupRead: Boolean;
        UnitCostCurrency: Decimal;
        UpdateFromVAT: Boolean;
        Text042: Label 'You cannot return more than the %1 units that you have received for %2 %3.';
        Text043: Label 'must be positive when %1 is not 0.';
        Text044: Label 'You cannot change %1 because this purchase order is associated with %2 %3.';
        Text046: Label '%3 will not update %1 when changing %2 because a prepayment invoice has been posted. Do you want to continue?', Comment = '%1 - product name';
        Text047: Label '%1 can only be set when %2 is set.';
        Text048: Label '%1 cannot be changed when %2 is set.';
        PrePaymentLineAmountEntered: Boolean;
        Text049: Label 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text050: Label 'Cancelled.';
        Text051: Label 'must have the same sign as the receipt';
        Text052: Label 'The quantity that you are trying to invoice is greater than the quantity in receipt %1.';
        Text053: Label 'must have the same sign as the return shipment';
        Text054: Label 'The quantity that you are trying to invoice is greater than the quantity in return shipment %1.';
        AnotherItemWithSameDescrQst: Label 'Item No. %1 also has the description "%2".\Do you want to change the current item no. to %1?', Comment = '%1=Item no., %2=item description';
        AnotherChargeItemWithSameDescQst: Label 'Item charge No. %1 also has the description "%2".\Do you want to change the current item charge no. to %1?', Comment = '%1=Item charge no., %2=item charge description';
        PurchSetupRead: Boolean;
        CannotFindDescErr: Label 'Cannot find %1 with Description %2.\\Make sure to use the correct type.', Comment = '%1 = Type caption %2 = Description';
        CommentLbl: Label 'Comment';
        LineDiscountPctErr: Label 'The value in the Line Discount % field must be between 0 and 100.';
        VATProductPostingGroup: Record 324;
}
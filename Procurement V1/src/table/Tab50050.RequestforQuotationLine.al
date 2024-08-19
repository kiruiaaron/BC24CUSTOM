table 50050 "Request for Quotation Line"
{
    Caption = 'Request for Quotation Line';

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
            Editable = false;
        }
        field(2; "Document No.";
        Code[20])
        {
            Caption = '"Document No."';
            Editable = false;
            TableRelation = "Request for Quotation Header"."No.";
        }
        field(3; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(4; "Requisition Type"; Option)
        {
            OptionMembers = Service,Item,"Fixed Asset";
            OptionCaption = 'Service,Item,Fixed Asset';
            Caption = 'Requisition Type';



            trigger OnValidate()
            begin
                "Requisition Code" := '';
                Description := '';
                "Location Code" := '';
                Quantity := 0;
                "Market Price" := 0;
                "Unit Cost" := 0;
                "Unit Cost(LCY)" := 0;
                //"Unit of Measure":='';
                "Global Dimension 1 Code" := '';
                "Global Dimension 2 Code" := '';
                "Shortcut Dimension 3 Code" := '';
                "Shortcut Dimension 4 Code" := '';
                "Shortcut Dimension 5 Code" := '';
                "Shortcut Dimension 6 Code" := '';
                "Shortcut Dimension 7 Code" := '';
                "Shortcut Dimension 8 Code" := '';
                "Total Cost" := 0;
                "Total Cost(LCY)" := 0;
            end;
        }
        field(5; "Requisition Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = IF ("Requisition Type" = CONST(Service)) "Purchase Requisition Codes"."Requisition Code" WHERE("Requisition Type" = CONST(Service))
            ELSE
            IF ("Requisition Type" = CONST("Fixed Asset")) "Fixed Asset"."No."
            ELSE
            IF ("Requisition Type" = CONST(Item)) Item."No.";

            trigger OnValidate()
            begin
                IF ("Requisition Type" = "Requisition Type"::Service) THEN BEGIN
                    IF RequisitionCodes.GET("Requisition Type", "Requisition Code") THEN BEGIN
                        Type := RequisitionCodes.Type;
                        "No." := RequisitionCodes."No.";
                        VALIDATE("No.");
                    END;
                END;

                IF ("Requisition Type" = "Requisition Type"::Item) THEN BEGIN
                    Item.RESET;
                    Item.SETRANGE(Item."No.", "Requisition Code");
                    IF Item.FINDFIRST THEN BEGIN
                        Type := Type::Item;
                        "No." := "Requisition Code";
                        VALIDATE("No.");
                    END;
                END;

                IF ("Requisition Type" = "Requisition Type"::"Fixed Asset") THEN BEGIN
                    FixedAsset.RESET;
                    FixedAsset.SETRANGE(FixedAsset."No.", "Requisition Code");
                    IF FixedAsset.FINDFIRST THEN BEGIN
                        Type := Type::"Fixed Asset";
                        "No." := "Requisition Code";
                        VALIDATE("No.");
                    END;
                END
            end;
        }
        field(6; Type; Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(7; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"."No." WHERE("Direct Posting" = CONST(true))
            ELSE
            IF (Type = CONST(Item)) Item."No." WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No." WHERE(Blocked = CONST(false));

            trigger OnValidate()
            begin
                Name := '';
                IF Type = Type::"G/L Account" THEN BEGIN
                    IF "G/LAccount".GET("No.") THEN
                        Name := "G/LAccount".Name;
                    Description := "G/LAccount".Name;
                END;
                IF Type = Type::Item THEN BEGIN
                    IF Item.GET("No.") THEN BEGIN
                        Name := Item.Description;
                        Description := Item.Description;
                        Item.TESTFIELD("Purch. Unit of Measure");
                        Item.TESTFIELD("Inventory Posting Group");
                        //"Market Price" := Item."Market Price";
                        "Unit of Measure Code" := Item."Purch. Unit of Measure";
                    END;
                END;
                IF Type = Type::"Fixed Asset" THEN BEGIN
                    IF FixedAsset.GET("No.") THEN
                        Name := FixedAsset.Description;
                    Description := FixedAsset.Description;
                END;
            end;
        }
        field(8; Name; Text[50])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(11; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item),
                                "No." = FILTER(<> '')) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                "Unit Cost(LCY)" := 0;
                "Total Cost" := 0;
                "Unit Cost(LCY)" := "Market Price";
                IF "Currency Code" <> '' THEN BEGIN
                    "Unit Cost(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Document Date", "Currency Code", "Market Price", "Currency Factor"));
                END;
                "Total Cost" := Quantity * "Market Price";
                VALIDATE("Total Cost");
            end;
        }
        field(21; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(22; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(23; "Unit Cost"; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TESTFIELD(Quantity);
                "Unit Cost(LCY)" := 0;
                "Total Cost" := 0;
                "Unit Cost(LCY)" := "Unit Cost";
                IF "Currency Code" <> '' THEN BEGIN
                    "Unit Cost(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Document Date", "Currency Code", "Unit Cost", "Currency Factor"));
                END;
                "Total Cost" := Quantity * "Unit Cost";
                VALIDATE("Total Cost");
            end;
        }
        field(24; "Unit Cost(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
            Editable = false;
        }
        field(25; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            Editable = false;

            trigger OnValidate()
            begin
                "Total Cost(LCY)" := "Total Cost";
                IF "Currency Code" <> '' THEN BEGIN
                    "Total Cost(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Document Date", "Currency Code", "Total Cost", "Currency Factor"));
                END;
            end;
        }
        field(26; "Total Cost(LCY)"; Decimal)
        {
            Caption = 'Total Cost(LCY)';
            Editable = false;
        }
        field(27; "Market Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //TESTFIELD(Quantity);
                "Unit Cost(LCY)" := 0;
                "Total Cost" := 0;
                "Unit Cost(LCY)" := "Market Price";
                IF "Currency Code" <> '' THEN BEGIN
                    "Unit Cost(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Document Date", "Currency Code", "Market Price", "Currency Factor"));
                END;
                "Total Cost" := Quantity * "Market Price";
                VALIDATE("Total Cost");
            end;
        }
        field(39; Committed; Boolean)
        {
            Caption = 'Committed';
        }
        field(40; "Budget Code"; Code[20])
        {
            Caption = 'Budget Code';
        }
        field(49; Description; Text[250])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                Description := UPPERCASE(Description);
            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Closed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Closed;
        }
        field(80; "Purchase Requisition No."; Code[20])
        {
            Editable = false;
        }
        field(81; "Purchase Requisition Line"; Integer)
        {
            Editable = false;
        }
        field(82; "Type (Attributes)"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Purchase Requisition,LPO,Procurement Planning,RFQ';
            OptionMembers = "Purchase Requisition",LPO,"Procurement Planning",RFQ;
        }
        field(52137026; "Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(52137027; "Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header";
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PurchCommentLine: Record 43;
        SalesOrderLine: Record 37;
    begin
        Rec.TESTFIELD(Status, Rec.Status::Open);

        PurchaseRequisitionLines.RESET;
        PurchaseRequisitionLines.SETRANGE(PurchaseRequisitionLines."Request for Quotation No.", "Document No.");
        PurchaseRequisitionLines.SETRANGE(PurchaseRequisitionLines."Request for Quotation Line", "Line No.");
        IF PurchaseRequisitionLines.FINDSET THEN BEGIN
            REPEAT
                PurchaseRequisitionLines.Closed := FALSE;
                PurchaseRequisitionLines."Request for Quotation No." := '';
                PurchaseRequisitionLines."Request for Quotation Line" := 0;
                PurchaseRequisitionLines.MODIFY;
            UNTIL PurchaseRequisitionLines.NEXT = 0;
        END;
    end;

    trigger OnInsert()
    begin
        RequestForQuotationHeader.RESET;
        RequestForQuotationHeader.SETRANGE(RequestForQuotationHeader."No.", "Document No.");
        IF RequestForQuotationHeader.FINDFIRST THEN BEGIN
            "Currency Code" := RequestForQuotationHeader."Currency Code";
            "Document Date" := RequestForQuotationHeader."Document Date";
            "Global Dimension 1 Code" := RequestForQuotationHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := RequestForQuotationHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code" := RequestForQuotationHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := RequestForQuotationHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code" := RequestForQuotationHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code" := RequestForQuotationHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code" := RequestForQuotationHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code" := RequestForQuotationHeader."Shortcut Dimension 8 Code";
        END;

        "Type (Attributes)" := "Type (Attributes)"::RFQ;
    end;

    trigger OnModify()
    begin
        RequestForQuotationHeader.RESET;
        RequestForQuotationHeader.SETRANGE(RequestForQuotationHeader."No.", "Document No.");
        IF RequestForQuotationHeader.FINDFIRST THEN BEGIN
            "Currency Code" := RequestForQuotationHeader."Currency Code";
            "Document Date" := RequestForQuotationHeader."Document Date";
            "Global Dimension 1 Code" := RequestForQuotationHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := RequestForQuotationHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code" := RequestForQuotationHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := RequestForQuotationHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code" := RequestForQuotationHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code" := RequestForQuotationHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code" := RequestForQuotationHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code" := RequestForQuotationHeader."Shortcut Dimension 8 Code";
        END;
    end;

    var
        "G/LAccount": Record 15;
        RequisitionCodes: Record 50048;
        RequestForQuotationHeader: Record 50049;
        CurrExchRate: Record 330;
        Item: Record 27;
        FixedAsset: Record 5600;
        PurchaseRequisitionLines: Record 50047;
        Txt_001: Label 'Deleting the RFQ Lines will open the selected purchase requisition lines,Continue?';
        Txt_002: Label 'Deletion Cancelled.';
}


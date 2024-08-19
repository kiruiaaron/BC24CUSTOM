table 50047 "Purchase Requisition Line"
{
    Caption = 'Purchase Requisition Line';
    DrillDownPageID = 518;
    LookupPageID = 518;

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(2; "Document No.";
        Code[20])
        {
            Caption = '"Document No."';
            TableRelation = "Purchase Requisitions"."No.";
        }
        field(3; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(4; "Requisition Type"; Option)
        {
            Caption = 'Requisition Type';
            OptionCaption = 'Service,Item,Fixed Asset';
            OptionMembers = Service,Item,"Fixed Asset";

            trigger OnValidate()
            begin
                "Requisition Code" := '';
                Description := '';
                "Location Code" := '';
                Quantity := 0;
                "Market Price" := 0;
                "Unit Cost" := 0;
                "Unit Cost(LCY)" := 0;
                "Unit of Measure" := '';
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
                /*PurchaseRequisitionLine.RESET;
                PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Requisition Code","Requisition Code");
                PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Document No.","Document No.");
                IF PurchaseRequisitionLine.FINDFIRST THEN BEGIN
                  ERROR(Text00012);
                END;
                */
                PurchaseSetup.GET;

                /*   IF PurchaseSetup."Use Procurement Plan" = TRUE THEN BEGIN
                      ProcPlan.RESET;
                      ProcPlan.SETRANGE(ProcPlan.Budget, Budget);
                      IF ProcPlan.FINDFIRST THEN BEGIN
                          ProcPlanLines.RESET;
                          ProcPlanLines.SETRANGE(ProcPlanLines."Document No.", ProcPlan."No.");
                          ProcPlanLines.SETRANGE(ProcPlanLines."No.", "Requisition Code");
                          IF NOT ProcPlanLines.FINDFIRST THEN BEGIN
                              ERROR(Text00011, Budget);
                          END;
                      END;
                  END; */

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
            Caption = 'Account Type';
            Editable = false;
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(7; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"."No." WHERE("Direct Posting" = CONST(true))
            ELSE
            IF (Type = CONST(Item)) Item."No." WHERE(Blocked = CONST(false));

            trigger OnValidate()
            begin
                Name := '';
                Description := '';
                "Location Code" := '';

                IF Type = Type::"G/L Account" THEN BEGIN
                    IF "G/LAccount".GET("No.") THEN
                        Name := "G/LAccount".Name;
                    Description := "G/LAccount".Name;
                END;

                IF Type = Type::Item THEN BEGIN
                    IF Item.GET("No.") THEN
                        Name := Item.Description;
                    Description := Item.Description;
                    //     "Location Code" := Item."Location Code";
                    //   "Market Price" := Item."Market Price";
                    "Unit of Measure" := Item."Base Unit of Measure";
                    AvailableInventory := 0;
                    Inventory := 0;
                    Quantities := 0;
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item No.", "No.");
                    //ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Location Code","Location Code");
                    IF ItemLedgerEntry.FINDSET THEN BEGIN
                        REPEAT
                            AvailableInventory := AvailableInventory + ItemLedgerEntry.Quantity;
                        UNTIL ItemLedgerEntry.NEXT = 0;
                    END;
                    Inventory := AvailableInventory;
                END;

                IF Type = Type::"Fixed Asset" THEN BEGIN
                    IF FixedAsset.GET("No.") THEN
                        Name := FixedAsset.Description;
                    Description := FixedAsset.Description;
                    "Location Code" := FixedAsset."FA Location Code";
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
        field(11; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                VALIDATE("Unit Cost");
            end;
        }
        field(13; "Market Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Inventory; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; Budget; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "G/L Budget Name";
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
            Caption = 'Unit Cost';

            trigger OnValidate()
            begin
                TESTFIELD(Quantity);
                "Unit Cost(LCY)" := 0;
                "Total Cost" := 0;
                "Unit Cost(LCY)" := "Unit Cost";
                IF "Currency Factor" = 0 THEN "Currency Factor" := 1;
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

                /*PurchaseSetup.GET;
                IF PurchaseSetup."Use Procurement Plan"=TRUE THEN BEGIN
                  ProcPlan.RESET;
                  ProcPlan.SETRANGE(ProcPlan.Budget,Budget);
                  IF ProcPlan.FINDFIRST THEN BEGIN
                    ProcPlanLines.RESET;
                    ProcPlanLines.SETRANGE(ProcPlanLines."Document No.",ProcPlan."No.");
                    ProcPlanLines.SETRANGE(ProcPlanLines."No.","Requisition Code");
                    IF ProcPlanLines.FINDFIRST THEN BEGIN
                      IF "Total Cost">ProcPlanLines."Estimated cost" THEN
                       ERROR(Text00013,ProcPlanLines."Estimated cost");
                    END;
                  END;
                END;*/

            end;
        }
        field(26; "Total Cost(LCY)"; Decimal)
        {
            Caption = 'Total Cost(LCY)';
            Editable = false;
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
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Closed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Closed;
        }
        field(71; Closed; Boolean)
        {
        }
        field(80; "Request for Quotation No.";
        Code[20])
        {
            Editable = false;
            TableRelation = "Request for Quotation Header"."No.";
        }
        field(81; "Request for Quotation Line"; Integer)
        {
            Editable = false;
        }
        field(82; "Purchase Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Purchase Header"."No.";
        }
        field(83; "Purchase Order Line"; Integer)
        {
            Editable = false;
        }
        field(99; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(100; "FA Posting Type"; Option)
        {
            AccessByPermission = TableData 5600 = R;
            Caption = 'FA Posting Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Acquisition Cost,Maintenance';
            OptionMembers = " ","Acquisition Cost",Maintenance;

            trigger OnValidate()
            begin
                /*IF Type = Type::"Fixed Asset" THEN BEGIN
                  TESTFIELD("Job No.",'');
                  IF "FA Posting Type" = "FA Posting Type"::" " THEN
                    "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
                  GetFAPostingGroup;
                END ELSE BEGIN
                  "Depreciation Book Code" := '';
                  "FA Posting Date" := 0D;
                  "Salvage Value" := 0;
                  "Depr. until FA Posting Date" := FALSE;
                  "Depr. Acquisition Cost" := FALSE;
                  "Maintenance Code" := '';
                  "Insurance No." := '';
                  "Budgeted FA No." := '';
                  "Duplicate in Depreciation Book" := '';
                  "Use Duplication List" := FALSE;
                END;
                */

            end;
        }
        field(101; "Type (Attributes)"; Option)
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
        field(52137028; "Imprest Code"; Code[50])
        {
            Caption = 'Imprest Code';
            DataClassification = ToBeClassified;
            TableRelation = "Funds Transaction Code"."Transaction Code" WHERE("Transaction Type" = CONST(Imprest));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);

            end;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.", "Requisition Code")
        {
        }
        key(Key2; "Document No.")
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
    end;

    trigger OnInsert()
    begin
        PurchaseRequisitionHeader.RESET;
        PurchaseRequisitionHeader.SETRANGE(PurchaseRequisitionHeader."No.", "Document No.");
        IF PurchaseRequisitionHeader.FINDFIRST THEN BEGIN
            PurchaseRequisitionHeader.TESTFIELD(PurchaseRequisitionHeader.Budget);
            Budget := PurchaseRequisitionHeader.Budget;
            "Budget Code" := PurchaseRequisitionHeader.Budget;
            "Currency Code" := PurchaseRequisitionHeader."Currency Code";
            "Document Date" := PurchaseRequisitionHeader."Document Date";
            "Global Dimension 1 Code" := PurchaseRequisitionHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := PurchaseRequisitionHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code" := PurchaseRequisitionHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := PurchaseRequisitionHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code" := PurchaseRequisitionHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code" := PurchaseRequisitionHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code" := PurchaseRequisitionHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code" := PurchaseRequisitionHeader."Shortcut Dimension 8 Code";
        END;
        VALIDATE("Requisition Type");
        "Type (Attributes)" := "Type (Attributes)"::"Purchase Requisition";
    end;

    var
        "G/LAccount": Record 15;
        RequisitionCodes: Record 50048;
        PurchaseRequisitionHeader: Record 50046;
        PurchaseRequisitionLine: Record 50047;
        CurrExchRate: Record 330;
        Item: Record 27;
        FixedAsset: Record 5600;
        ItemLedgerEntry: Record 32;
        AvailableInventory: Decimal;
        Quantities: Decimal;
        PurchaseSetup: Record 312;
        ProcPlan: Record 50063;
        ProcPlanLines: Record 50064;
        Text00011: Label 'This Item/Service/FA is not within the budget plan %1';
        Text00012: Label 'The Item code exists in this requisition';
        Text00013: Label 'The cost of this item exceeds what was budgeted in the plan Budget: %1';
}


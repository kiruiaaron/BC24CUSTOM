table 50069 "Store Requisition Line"
{

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
            Editable = false;
            TableRelation = "Store Requisition Header"."No.";
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item,Fixed Asset';
            OptionMembers = Item,"Fixed Asset";
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(Item)) Item."No." WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate()
            begin
                IF Type = Type::Item THEN BEGIN
                    Item.RESET;
                    Item.GET("Item No.");
                    "Unit of Measure Code" := Item."Base Unit of Measure";
                    VALIDATE("Unit of Measure Code");
                    "Unit Cost" := Item."Unit Cost";
                    VALIDATE("Unit Cost");
                    "Item Description" := Item.Description;
                    Description := Item.Description;
                END ELSE BEGIN
                    FixedAsset.GET("Item No.");
                    "Item Description" := FixedAsset.Description;
                    Description := FixedAsset.Description;

                END;
                //If Location Code selected on header
                StoreRequisitionHeader.RESET;
                IF StoreRequisitionHeader.GET("Document No.") THEN BEGIN
                    "Location Code" := StoreRequisitionHeader."Location Code";
                    VALIDATE("Location Code");
                END;
            end;
        }
        field(5; "Location Code"; Code[20])
        {
            TableRelation = Location;

            trigger OnValidate()
            begin
                TESTFIELD("Item No.");
                AvailableInventory := 0;
                Inventory := 0;
                Quantity := 0;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item No.", "Item No.");
                ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Location Code", "Location Code");
                IF ItemLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        AvailableInventory := AvailableInventory + ItemLedgerEntry.Quantity;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                END;
                Inventory := AvailableInventory;
            end;
        }
        field(6; Inventory; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                //TESTFIELD("Location Code");
                IF Type = Type::Item THEN
                    IF Inventory < Quantity THEN BEGIN
                        ERROR(Text_0085, "Item No.", "Location Code", Inventory, "Unit of Measure Code");
                    END;
                "Line Amount" := "Unit Cost" * Quantity;
                "Quantity to Issue" := Quantity;
            end;
        }
        field(11; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(12; "Unit Cost"; Decimal)
        {
            Editable = false;
        }
        field(13; "Line Amount"; Decimal)
        {
            Editable = false;
        }
        field(17; Committed; Boolean)
        {
        }
        field(18; "Gen. Bus. Posting Group"; Code[30])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(19; "Gen. Prod. Posting Group"; Code[30])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(49; Description; Text[150])
        {
            Editable = false;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                                                                              Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                                                                                Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                                                                                   Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                                                                                   Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                                                                                  Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                                                                                   Blocked = CONST(false));
            //  Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Posted';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted;
        }
        field(71; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
        field(72; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(73; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            Editable = false;
        }
        field(74; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            Editable = false;
        }
        field(75; "Item Description"; Text[80])
        {
            Editable = false;
        }
        field(76; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(77; "Quantity to Issue"; Decimal)
        {
            Caption = 'Quantity to Issue';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                //TESTFIELD("Location Code");
                IF Quantity < "Quantity to Issue" THEN
                    ERROR('You cannot issue more that requested');
            end;
        }
        field(78; "Return Requisition No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(79; Returned; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Store Requisition No"; Code[20])
        {
            DataClassification = ToBeClassified;
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
    begin
        Rec.TESTFIELD(Status, Rec.Status::Open);
    end;

    trigger OnInsert()
    begin
        StoreRequisitionHeader.RESET;
        StoreRequisitionHeader.SETRANGE(StoreRequisitionHeader."No.", "Document No.");
        IF StoreRequisitionHeader.FINDFIRST THEN BEGIN
            "Global Dimension 1 Code" := StoreRequisitionHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := StoreRequisitionHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code" := StoreRequisitionHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := StoreRequisitionHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code" := StoreRequisitionHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code" := StoreRequisitionHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code" := StoreRequisitionHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code" := StoreRequisitionHeader."Shortcut Dimension 8 Code";
        END;
    end;

    var
        Text_0080: Label 'You cannot create a new store requisition, you have an open "Document No." %1 ,use this document before creating a new one.';
        Item: Record 27;
        ItemLedgerEntry: Record 32;
        UOMMgt: Codeunit 5402;
        Text_0081: Label 'You cannot delete the store requisition no. %1. The status must be open, current status is %2';
        Text_0082: Label 'You cannot modify the store requisition no. %1. The status must be open, current status is %2';
        Text_0085: Label 'The quantity requested cannot be more than the current inventory for item no. %1 in location %2. The current inventory is %3 %4.';
        StoreRequisitionHeader: Record 50068;
        AvailableInventory: Decimal;
        FixedAsset: Record 5600;
}


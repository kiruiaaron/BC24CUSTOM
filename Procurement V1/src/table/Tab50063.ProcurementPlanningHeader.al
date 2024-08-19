table 50063 "Procurement Planning Header"
{

    fields
    {
        field(10; "No."; Code[20])
        {
        }
        field(11; Name; Text[100])
        {
        }
        field(12; "Financial Year"; Text[100])
        {
            Editable = false;
        }
        field(25; "Document Date"; Date)
        {
        }
        field(26; Budget; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";

            trigger OnValidate()
            begin
                "Budget Description" := '';
                "Financial Year" := '';
                "Procurement Plan No." := '';

                IF Budgets.GET(Budget) THEN BEGIN
                    "Budget Description" := Budgets.Description;
                    "Financial Year" := Budgets.Description;
                    //    "Procurement Plan No." := Budgets."Procurement Plan No.";
                END;
            end;
        }
        field(27; "Budget Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; "Procurement Plan No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30; "User ID"; Code[50])
        {
        }
        field(31; "No. Series"; Code[20])
        {
        }
        field(32; "From Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "To Date" := 0D;

                //IF "From Date"<TODAY THEN
                //  ERROR(Error100);
            end;
        }
        field(33; "To Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("From Date");
                IF "To Date" < "From Date" THEN
                    ERROR(Error101);
            end;
        }
        field(34; "G/L Budget Line A/C"; Code[30])
        {
            Editable = false;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(35; "Budget Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("Budget Name" = FIELD(Budget),
                                                               "G/L Account No." = FIELD("G/L Budget Line A/C")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(41; "Procurement Plan Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Items,Service,Fixed Asset';
            OptionMembers = Items,Service,"Fixed Asset";

            trigger OnValidate()
            begin
                Rec.TESTFIELD(Status, Rec.Status::Open);
                "G/L Budget Line A/C" := '';
                "Procurement Plan No." := '';
            end;
        }
        field(42; "Procurement Plan Grouping"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Procurement Plan Type" = FILTER(Items)) "Inventory Posting Group".Code
            ELSE
            IF ("Procurement Plan Type" = FILTER(Service)) "Purchase Requisition Codes"."Requisition Code"
            ELSE
            IF ("Procurement Plan Type" = FILTER("Fixed Asset")) "FA Posting Group".Code;

            trigger OnValidate()
            begin
                Rec.TESTFIELD(Status, Rec.Status::Open);

                "G/L Budget Line A/C" := '';

                ProcurementPlanningLine.RESET;
                ProcurementPlanningLine.SETRANGE(ProcurementPlanningLine."Document No.", "No.");
                IF ProcurementPlanningLine.FINDLAST THEN BEGIN
                    //ProcurementPlanningLine.DELETEALL;
                    LineNo := ProcurementPlanningLine."Line No.";
                END;

                IF "Procurement Plan Type" = "Procurement Plan Type"::Items THEN BEGIN
                    InventoryPostingGroup.RESET;
                    InventoryPostingGroup.SETRANGE(InventoryPostingGroup.Code, "Procurement Plan Grouping");
                    IF InventoryPostingGroup.FINDFIRST THEN BEGIN
                        // "G/L Budget Line A/C":=InventoryPostingGroup."Budget G/L Account";
                        VALIDATE("G/L Budget Line A/C");
                        ItemList.RESET;
                        ItemList.SETRANGE(ItemList."Inventory Posting Group", InventoryPostingGroup.Code);
                        IF ItemList.FINDSET THEN BEGIN
                            REPEAT
                                LineNo := LineNo + 1;
                                ProcurementPlanningLine.INIT;
                                ProcurementPlanningLine."Line No." := LineNo;
                                ProcurementPlanningLine."Document No." := "No.";
                                ProcurementPlanningLine.Budget := Budget;
                                ProcurementPlanningLine."Source of Funds" := ProcurementPlanningLine."Source of Funds"::Budget;
                                ProcurementPlanningLine."Procurement Plan No." := "Procurement Plan No.";
                                ProcurementPlanningLine.Type := ProcurementPlanningLine.Type::Item;
                                ProcurementPlanningLine."No." := ItemList."No.";
                                ProcurementPlanningLine.VALIDATE(ProcurementPlanningLine."No.");
                                ProcurementPlanningLine.Description := ItemList.Description;
                                ProcurementPlanningLine."Description 2" := Name;
                                ProcurementPlanningLine.INSERT

                          UNTIL ItemList.NEXT = 0;
                        END;
                    END;
                END;

                IF "Procurement Plan Type" = "Procurement Plan Type"::Service THEN BEGIN
                    PurchaseRequisitionCodes.RESET;
                    PurchaseRequisitionCodes.SETRANGE(PurchaseRequisitionCodes."Requisition Code", "Procurement Plan Grouping");
                    IF PurchaseRequisitionCodes.FINDFIRST THEN BEGIN
                        "G/L Budget Line A/C" := PurchaseRequisitionCodes."No.";
                        VALIDATE("G/L Budget Line A/C");
                    END;
                END;

                IF "Procurement Plan Type" = "Procurement Plan Type"::Items THEN BEGIN
                    FAPostingGroup.RESET;
                    FAPostingGroup.SETRANGE(FAPostingGroup.Code, "Procurement Plan Grouping");
                    IF FAPostingGroup.FINDFIRST THEN BEGIN
                        "G/L Budget Line A/C" := FAPostingGroup."Acquisition Cost Account";
                        VALIDATE("G/L Budget Line A/C");
                    END;
                END;
            end;
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
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            PurchSetup.GET();
            // PurchSetup.TESTFIELD(PurchSetup."Procurement Plan Nos");
            // //NoSeriesMgt.InitSeries(PurchSetup."Procurement Plan Nos", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        "Document Date" := TODAY;
        "User ID" := USERID;
    end;

    var
        PurchSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Budgets: Record 95;
        GLBudgetEntry: Record 96;
        FAPostingGroup: Record 5606;
        InventoryPostingGroup: Record 94;
        PurchaseRequisitionCodes: Record 50048;
        ProcurementPlanningLine: Record 50064;
        ItemList: Record 27;
        Error100: Label 'The date must not be before today''s date';
        Error101: Label 'The date must not be before the From Date';
        LineNo: Integer;
}


tableextension 51602 "Job Task Ext" extends "Job Task"
{
    fields
    {
        field(50005; "Quantity to Requisition"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50006; "Requisitioned Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Remainder; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Shorstcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
            end;
        }
        field(50021; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
            end;
        }
        field(50022; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,1,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(5,"Shortcut Dimension 5 Code");
            end;
        }
        field(50023; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Assigned To"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(50025; Completed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; Venue; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50027; Executed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Select To Post"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50029; requisitioned; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50030; Supervisor; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(50031; "Planned Quantity"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                  "Job Task No." = FIELD("Job Task No.")));
            FieldClass = FlowField;
        }
        field(50032; Inhouse; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'To show the items that are already inhouse one can reserve';
        }
        field(50033; Reserved; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Sales Line Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50035; "Sales Line No. of Days"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "No. of Days"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50037; Merchandise; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Received By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Date Received"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Time Received"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50041; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Posted By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Time Posted"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;

            trigger OnValidate()
            begin
                if ItemsRec.Get("Item No.") then begin
                    Description := ItemsRec.Description;
                    "Unit of Measure Code" := ItemsRec."Base Unit of Measure";
                end;
            end;
        }
        field(50046; "Unit of Measure Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(50048; "Billed Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50049; Purpose; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50050; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        ItemsRec: Record Item;
}

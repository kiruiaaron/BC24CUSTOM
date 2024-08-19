tableextension 51609 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
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
        field(50023; Cancelled; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Cancelled By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Cancelled Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Created Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50028; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Normal,Authentication Device,Debit Note';
            OptionMembers = Normal,"Authentication Device","Debit Note";
        }
        field(50029; "Job Description"; Text[50])
        {
            Caption = 'Project Description';
            DataClassification = ToBeClassified;
        }
        field(50030; "Project Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Activation, Event';
            OptionMembers = Activation," Event";
        }
        field(50031; Converted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "Project Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50033; Supplementary; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Agency Fee"; Decimal)
        {
            CalcFormula = Sum("Sales Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                         "Document No." = FIELD("No."),
                                                         Type = FILTER("G/L Account")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50035; "Sub Total amount"; Decimal)
        {
            CalcFormula = Sum("Sales Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                         "Document No." = FIELD("No."),
                                                         Type = FILTER(Resource)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(69036; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Work Type";

            trigger OnValidate()
            var
                WorkType: Record "Work Type";
            begin
            end;
        }
        field(69037; "Project No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;
        }
        field(69038; "Project Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}

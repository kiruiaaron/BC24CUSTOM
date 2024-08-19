/// <summary>
/// Table HR Training Needs Line (ID 50158).
/// </summary>
table 50158 "HR Training Needs Line"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = false;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Employee Name" := '';
                "Global Dimension 1 Code" := '';
                "Global Dimension 2 Code" := '';
                "Shortcut Dimension 3 Code" := '';

                Employee.RESET;
                Employee.SETRANGE(Employee."No.", "Employee No.");
                IF Employee.FINDFIRST THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 1 Code";
                    "Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
                END;
            end;
        }
        field(4; "Employee Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Development Needs"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Intervention Required"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Training,Coaching,Mentoring,Other;
        }
        field(7; Objectives; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Proposed Training Provider"; Text[100])
        {
        }
        field(10; "Proposed Period"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Q1,Q2,Q3,Q4';
            OptionMembers = " ",Q1,Q2,Q3,Q4;
        }
        field(11; "Estimated Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Calendar Year"; Code[20])
        {
            Editable = false;
            FieldClass = Normal;
            TableRelation = "HR Calendar Period".Code;
        }
        field(13; "Training Location & Venue"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Training Scheduled Date"; Date)
        {
            Caption = 'Training Scheduled Date From';
            DataClassification = ToBeClassified;
        }
        field(15; "Training Scheduled Date To"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Official Email Address"; Text[80])
        {
            Caption = '<Official E-mail Address>';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = false;
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Employee No.", "Employee Name", "Development Needs", "Intervention Required", Description)
        {
        }
    }

    trigger OnInsert()
    begin
        TrainingNeedsHeader.RESET;
        TrainingNeedsHeader.SETRANGE(TrainingNeedsHeader."No.", "No.");
        IF TrainingNeedsHeader.FINDFIRST THEN BEGIN
            "Employee No." := TrainingNeedsHeader."Employee No.";
            "Employee Name" := TrainingNeedsHeader."Employee Name";
            "Calendar Year" := TrainingNeedsHeader."Calendar Year";
            "Global Dimension 1 Code" := TrainingNeedsHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := TrainingNeedsHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code" := TrainingNeedsHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := TrainingNeedsHeader."Shortcut Dimension 4 Code";
            /*     "Shortcut Dimension 5 Code":=TrainingNeedsHeader."Shortcut Dimension 5 Code";
                "Shortcut Dimension 6 Code":=TrainingNeedsHeader."Shortcut Dimension 6 Code";
                "Shortcut Dimension 7 Code":=TrainingNeedsHeader."Shortcut Dimension 7 Code";
                "Shortcut Dimension 8 Code":=TrainingNeedsHeader."Shortcut Dimension 8 Code";
       */
        END;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record 5218;
        Txt001: Label 'You cannot change the costs after posting';
        Vendors: Record 23;
        Employee: Record 5200;
        TrainingNeedsHeader: Record 50157;
}


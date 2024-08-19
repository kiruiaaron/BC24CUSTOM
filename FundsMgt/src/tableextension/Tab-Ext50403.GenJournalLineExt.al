tableextension 50403 "Gen Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50003; "Payroll Calculated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136923; Description2; Text[250])
        {
            Caption = 'Description2';
            DataClassification = ToBeClassified;
        }
        field(52136924; "Document Source"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52136925; Document_Type; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52136930; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(52136931; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(52136932; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(52136933; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(52136934; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(52136935; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(52137023; "Employee Transaction Type"; Option)
        {
            Caption = 'Employee Transaction Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Salary,Imprest,Advance';
            OptionMembers = " ",Salary,Imprest,Advance;
        }
        field(52137063; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(52137064; "Customer Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52137123; "Payroll Period"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52137124; "Payroll Group Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52137125; "Cheque No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52137150; "Property No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137151; "Block Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137152; "Floor Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137153; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137630; "Investment Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137650; "Investment Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137651; "Investment Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Loan Disbursement,Principal Receivable,Principal Payment,Interest Receivable,Interest Payment,Penalty Interest Receivable,Penalty Interest Payment,Loan Fee Receivable,Loan Fee Payment,Equity Fair Value';
            OptionMembers = " ","Loan Disbursement","Principal Receivable","Principal Payment","Interest Receivable","Interest Payment","Penalty Interest Receivable","Penalty Interest Payment","Loan Fee Receivable","Loan Fee Payment","Equity Fair Value";
        }
        field(52137652; "Recovery Priority"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52137703; "Investment Product Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137719; "Industry Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137720; "Sector Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
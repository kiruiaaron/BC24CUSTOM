tableextension 51604 "Job Ext" extends Job
{
    fields
    {
        field(50000; "Project Budget"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Cost (LCY)" WHERE("Job No." = FIELD("No."),
                                                                            "Line Type" = CONST(Budget)));
            Caption = 'Total Project Budget';
            Description = '//Daudi changed from schedule to budget as per the new 2017';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Actual Project Costs"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("No."),
                                                                           "Entry Type" = CONST(Usage)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Budget Commitments"; Decimal)
        {
            Caption = 'Total Budget Commitments';
            DataClassification = ToBeClassified;
        }
        field(50003; "Available Funds"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Last Invoice Date"; Date)
        {
            CalcFormula = Max("Job Ledger Entry"."Posting Date" WHERE("Job No." = FIELD("No."),
                                                                       "Entry Type" = CONST(Sale)));
            FieldClass = FlowField;
        }
        field(50007; "Prior Period Turnover"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Prior Period Costs"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Current Period Turnover"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Current Period Costs"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Later Period Turnover"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Later Period Costs"; Decimal)
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
                ///ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
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
        field(50030; "Project Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Activation, Event';
            OptionMembers = Activation," Event";
        }
        field(50050; "Last Invoice Entry Date"; Date)
        {
            CalcFormula = Max("Job Ledger Entry"."Posting Date" WHERE("Job No." = FIELD("No."),
                                                                       "Entry Type" = CONST(Sale)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50051; "Last Usage Entry Date"; Date)
        {
            CalcFormula = Max("Job Ledger Entry"."Posting Date" WHERE("Job No." = FIELD("No."),
                                                                       "Entry Type" = CONST(Usage)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(57000; "No. Of Project Imprest Memos"; Integer)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(57001; "PO Commitments"; Decimal)
        {
            Caption = 'Purchase Order Commitments';
            Editable = false;
            FieldClass = Normal;
        }
        field(57002; "PRN Commitments"; Decimal)
        {
            Caption = 'Purchase Requisition(PRN) Commitments';
            Editable = false;
            FieldClass = Normal;
        }
        field(57003; "Store Requisition Commitments"; Decimal)
        {
            Caption = 'Store Requisition(S11) Commitments';
            Editable = false;
            FieldClass = Normal;
        }
        field(57004; "Imprest Application Commitment"; Decimal)
        {
            Caption = 'Imprest Applications Commitments';
            Editable = false;
            FieldClass = Normal;
        }
        field(57005; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending,Approved, Rejected';
            OptionMembers = Open,Pending,Approved," Rejected";
        }
        field(57006; "Sales Order"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(57007; Supplimentary; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(57008; "PO No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Added on 22/11/2018';
            Editable = false;
        }
        field(57009; Purpose; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }
}

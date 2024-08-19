page 50044 "Payment Codes"
{
    CardPageID = "Funds Transaction Code Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50027;
    SourceTableView = WHERE("Transaction Type" = CONST(Payment));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Include VAT"; Rec."Include VAT")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Include Withholding Tax"; Rec."Include Withholding Tax")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Withholding Tax Code"; Rec."Withholding Tax Code")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Withholding VAT Code"; Rec."Withholding VAT Code")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Include Withholding VAT"; Rec."Include Withholding VAT")
                {
                    ToolTip = 'Specifies field name';
                    ApplicationArea = All;
                }
                field("Funds Claim Code"; Rec."Funds Claim Code")
                {
                    ApplicationArea = All;
                }
                field("Employee Transaction Type"; Rec."Employee Transaction Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Payment;
    end;
}


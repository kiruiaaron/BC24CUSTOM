page 50052 "Funds General Setup"
{
    PageType = Card;
    SourceTable = 50031;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                field("Payment Voucher Nos."; Rec."Payment Voucher Nos.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Cash Voucher Nos."; Rec."Cash Voucher Nos.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Receipt Nos."; Rec."Receipt Nos.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Funds Transfer Nos."; Rec."Funds Transfer Nos.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Imprest Nos."; Rec."Imprest Nos.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Imprest Surrender Nos."; Rec."Imprest Surrender Nos.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Funds Claim Nos."; Rec."Funds Claim Nos.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Travel Advance Nos."; Rec."Travel Advance Nos.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Travel Surrender Nos."; Rec."Travel Surrender Nos.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Payment Voucher Reference Nos."; Rec."Payment Voucher Reference Nos.")
                {
                    ApplicationArea = All;
                }
                field("Budget Allocation Nos."; Rec."Budget Allocation Nos.")
                {
                    ApplicationArea = All;
                }
                field("Cheque Register No."; Rec."Cheque Register No.")
                {
                    ApplicationArea = All;
                }
                field("Reversal Header"; Rec."Reversal Header")
                {
                    ApplicationArea = All;
                }
                field("JV Nos."; Rec."JV Nos.")
                {
                    ApplicationArea = All;
                }
                field("Subsistence Nos"; Rec."Subsistence Nos")
                {
                    ApplicationArea = All;
                }
                field("Projects Nos"; Rec."Projects Nos")
                {
                    ApplicationArea = All;
                }
                field("Overtime Nos"; Rec."Overtime Nos")
                {
                    ApplicationArea = All;
                }
                field("Allowance Nos"; Rec."Allowance Nos")
                {
                    ApplicationArea = All;
                }
            }
            group(Rounding)
            {
                field("Payment Rounding Type"; Rec."Payment Rounding Type")
                {
                    ApplicationArea = All;
                }
                field("Payment Rounding Precision"; Rec."Payment Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field("W/Tax Rounding Type"; Rec."W/Tax Rounding Type")
                {
                    ApplicationArea = All;
                }
                field("W/Tax Rounding Precision"; Rec."W/Tax Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field("W/VAT Rounding Type"; Rec."W/VAT Rounding Type")
                {
                    ApplicationArea = All;
                }
                field("W/VAT Rounding Precision"; Rec."W/VAT Rounding Precision")
                {
                    ApplicationArea = All;
                }
            }
            group("Fixed Deposit")
            {
                field("Fixed Deposit Receivable A/c"; Rec."Fixed Deposit Receivable A/c")
                {
                    ApplicationArea = All;
                }
                field("Fixed Deposit Interest A/c"; Rec."Fixed Deposit Interest A/c")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


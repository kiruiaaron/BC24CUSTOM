page 50043 "Funds Transaction Code Card"
{
    PageType = Card;
    SourceTable = 50027;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Funds Claim Code"; Rec."Funds Claim Code")
                {
                    ApplicationArea = All;
                }
                field("Imprest Type"; Rec."Imprest Type")
                {
                    ApplicationArea = All;
                }
            }
            group(Posting)
            {
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                }
            }
            group(Taxes)
            {
                field("Include VAT"; Rec."Include VAT")
                {
                    ApplicationArea = All;
                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = All;
                }
                field("Include Withholding Tax"; Rec."Include Withholding Tax")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax Code"; Rec."Withholding Tax Code")
                {
                    ApplicationArea = All;
                }
                field("Include Withholding VAT"; Rec."Include Withholding VAT")
                {
                    ApplicationArea = All;
                }
                field("Withholding VAT Code"; Rec."Withholding VAT Code")
                {
                    ApplicationArea = All;
                }
                field("Minimum Non Taxable Amount"; Rec."Minimum Non Taxable Amount")
                {
                    ApplicationArea = All;
                }
            }
            group("HR Integration")
            {
                field("Employee Transaction Type"; Rec."Employee Transaction Type")
                {
                    ApplicationArea = All;
                }
            }
            group("Payroll Integration")
            {
                field("Payroll Taxable"; Rec."Payroll Taxable")
                {
                    ApplicationArea = All;
                }
                field("Payroll Allowance Code"; Rec."Payroll Allowance Code")
                {
                    ApplicationArea = All;
                }
                field("Payroll Deduction Code"; Rec."Payroll Deduction Code")
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


page 50046 "Imprest Codes"
{
    CardPageID = "Funds Transaction Code Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50027;
    SourceTableView = WHERE("Transaction Type" = CONST(Imprest));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Employee Transaction Type"; Rec."Employee Transaction Type")
                {
                    ApplicationArea = All;
                }
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
                field("Imprest Type"; Rec."Imprest Type")
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
        Rec."Transaction Type" := Rec."Transaction Type"::Imprest;
    end;
}


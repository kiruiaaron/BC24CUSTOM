page 50048 "Funds User Setup"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50029;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(UserID; UserID)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Receipt Journal Template"; Rec."Receipt Journal Template")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Receipt Journal Batch"; Rec."Receipt Journal Batch")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Payment Journal Template"; Rec."Payment Journal Template")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Payment Journal Batch"; Rec."Payment Journal Batch")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Fund Transfer Template Name"; Rec."Fund Transfer Template Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Fund Transfer Batch Name"; Rec."Fund Transfer Batch Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Funds Claim Template"; Rec."Funds Claim Template")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Funds Claim  Batch"; Rec."Funds Claim  Batch")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Imprest Template"; Rec."Imprest Template")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Imprest Batch"; Rec."Imprest Batch")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("JV Template"; Rec."JV Template")
                {
                    ApplicationArea = All;
                }
                field("JV Batch"; Rec."JV Batch")
                {
                    ApplicationArea = All;
                }
                field("Reversal Template"; Rec."Reversal Template")
                {
                    ApplicationArea = All;
                }
                field("Reversal Batch"; Rec."Reversal Batch")
                {
                    ApplicationArea = All;
                }
                field("Default Receipts Bank"; Rec."Default Receipts Bank")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Default Payment Bank"; Rec."Default Payment Bank")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Default Petty Cash Bank"; Rec."Default Petty Cash Bank")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


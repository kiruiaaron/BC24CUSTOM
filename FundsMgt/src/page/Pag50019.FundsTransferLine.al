page 50019 "Funds Transfer Line"
{
    PageType = ListPart;
    SourceTable = 50007;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Money Transfer Description"; Rec."Money Transfer Description")
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


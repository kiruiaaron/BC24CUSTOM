page 50000 "Bank Code"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50000;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the Bank Unique Code';
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the name of the bank';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Bank Branches")
            {
                Image = BankAccountRec;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50001;
                RunPageLink = "Bank Code" = FIELD("Bank Code");
                ToolTip = 'List of All Bank Branches';
                ApplicationArea = All;
            }
        }
    }
}


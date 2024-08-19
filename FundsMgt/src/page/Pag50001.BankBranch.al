page 50001 "Bank Branch"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50001;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Bank Branch Code"; Rec."Bank Branch Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Bank Branch Name"; Rec."Bank Branch Name")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Branch Physical Location"; Rec."Branch Physical Location")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Branch Postal Code"; Rec."Branch Postal Code")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Branch Address"; Rec."Branch Address")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Branch Phone No."; Rec."Branch Phone No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Branch Mobile No."; Rec."Branch Mobile No.")
                {
                    ToolTip = 'Specifies the field name';
                    ApplicationArea = All;
                }
                field("Branch Email Address"; Rec."Branch Email Address")
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


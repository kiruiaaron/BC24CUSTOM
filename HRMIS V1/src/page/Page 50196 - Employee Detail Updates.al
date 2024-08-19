page 50196 "Employee Detail Updates"
{
    CardPageID = "Employee Detail Update Card";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50116;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the  No.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the  Employee No.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the  Employee Name.';
                    ApplicationArea = All;
                }
                field("Update Option"; Rec."Update Option")
                {
                    ToolTip = 'Specifies the  update option.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


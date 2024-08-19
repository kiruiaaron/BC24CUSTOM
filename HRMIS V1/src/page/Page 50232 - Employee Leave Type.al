page 50232 "Employee Leave Type"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50133;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the Leave Type.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the allocated days.';
                    ApplicationArea = All;
                }
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ToolTip = 'Specifies the Leave Balance.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


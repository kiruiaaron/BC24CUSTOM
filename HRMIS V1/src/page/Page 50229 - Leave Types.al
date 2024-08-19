page 50229 "Leave Types"
{
    CardPageID = "Leave Type Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50134;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the Gender.';
                    ApplicationArea = All;
                }
                field(Days; Rec.Days)
                {
                    ToolTip = 'Specifies the Days.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


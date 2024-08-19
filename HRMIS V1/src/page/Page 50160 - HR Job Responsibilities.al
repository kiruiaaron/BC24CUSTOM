page 50160 "HR Job Responsibilities"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50096;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the Job Number.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description on the responsibility code.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


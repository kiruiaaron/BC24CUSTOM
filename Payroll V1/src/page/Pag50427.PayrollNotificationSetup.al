page 50427 "Payroll Notification Setup"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50250;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ApplicationArea = All;
                }
                field("Employee no"; Rec."Employee no")
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


page 50179 "Dept Interview Panel List"
{
    CardPageID = "Dept Interview Panel Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50106;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                }
                field("Dept Committee Name"; Rec."Dept Committee Name")
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


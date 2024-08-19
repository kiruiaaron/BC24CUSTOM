page 50062 "Cluster Codes"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50033;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cluster Code"; Rec."Cluster Code")
                {
                    ApplicationArea = All;
                }
                field("Cluster Name"; Rec."Cluster Name")
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


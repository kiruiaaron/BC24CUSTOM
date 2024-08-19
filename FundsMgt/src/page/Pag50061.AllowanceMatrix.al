page 50061 "Allowance Matrix"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50032;
    SourceTableView = WHERE("Allowance Code" = FILTER(<> 'LOCALTRAVEL'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Group"; Rec."Job Group")
                {
                    ApplicationArea = All;
                }
                field("Allowance Code"; Rec."Allowance Code")
                {
                    ApplicationArea = All;
                }
                field("Cluster Code"; Rec."Cluster Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(City; Rec.Tos)
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


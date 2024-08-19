page 50063 "Transport Matrix"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50032;
    SourceTableView = WHERE("Allowance Code" = FILTER('LOCALTRAVEL'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Allowance Code"; Rec."Allowance Code")
                {
                    ApplicationArea = All;
                }
                field(From; Rec.From)
                {
                    ApplicationArea = All;
                }
                field(Tos; Rec.Tos)
                {
                    Caption = 'To';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
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


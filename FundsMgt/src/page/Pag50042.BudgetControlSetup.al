page 50042 "Budget Control Setup"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50018;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Current Budget Code"; Rec."Current Budget Code")
                {
                    ApplicationArea = All;
                }
                field("Current Budget Start Date"; Rec."Current Budget Start Date")
                {
                    ApplicationArea = All;
                }
                field("Current Budget End Date"; Rec."Current Budget End Date")
                {
                    ApplicationArea = All;
                }
                field("Analysis View Code"; Rec."Analysis View Code")
                {
                    ApplicationArea = All;
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = All;
                }
                field("Allow OverExpenditure"; Rec."Allow OverExpenditure")
                {
                    ApplicationArea = All;
                }
                field("Current Item Budget"; Rec."Current Item Budget")
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


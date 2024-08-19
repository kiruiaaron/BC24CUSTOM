page 50272 "HR Medical Cover Setup"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50156;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Category"; Rec."Employee Category")
                {
                    ApplicationArea = All;
                }
                field("In-Patient Amount"; Rec."In-Patient Amount")
                {
                    ApplicationArea = All;
                }
                field("Out-Patient Amount"; Rec."Out-Patient Amount")
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


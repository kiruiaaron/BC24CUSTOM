page 50281 "SubCounty List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50177;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("County Code"; Rec."County Code")
                {
                    ApplicationArea = All;
                }
                field("Sub-County Code"; Rec."Sub-County Code")
                {
                    ApplicationArea = All;
                }
                field("Sub-County Name"; Rec."Sub-County Name")
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


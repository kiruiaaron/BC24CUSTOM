page 50099 "Procurement User Setup"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50060;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(UserID; UserID)
                {
                    ApplicationArea = All;
                }
                field("Procurement Journal Template"; Rec."Procurement Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Procurement Journal Batch"; Rec."Procurement Journal Batch")
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


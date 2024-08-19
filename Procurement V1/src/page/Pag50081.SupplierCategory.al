page 50081 "Supplier Category"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50045;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Supplier Category"; Rec."Supplier Category")
                {
                    ApplicationArea = All;
                }
                field("Category Description"; Rec."Category Description")
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


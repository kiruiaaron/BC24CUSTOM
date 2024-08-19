page 50647 "Evaluation Criteria List"
{
    CardPageID = "Evaluation Criteria";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50306;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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


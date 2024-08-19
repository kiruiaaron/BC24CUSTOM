page 50642 "Appraisal Training Recommd"
{
    Caption = 'Training Recommendations from Performance Appraisals';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50281;
    SourceTableView = WHERE("Appraisal Stage" = FILTER("End Year Evaluation"),
                            "HOD Approval" = CONST(Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Recommendations; Rec.Recommendations)
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


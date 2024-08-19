page 50645 "The Trainers"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50305;
    SourceTableView = WHERE(Category = CONST("THE TRAINERS"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Criteria"; Rec."Evaluation Criteria")
                {
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Category := Rec.Category::"THE TRAINERS"
    end;
}


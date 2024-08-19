page 50644 "Training Content"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50305;
    SourceTableView = WHERE(Category = CONST("TRAINING CONTENT"));

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
        Rec.Category := Rec.Category::"TRAINING CONTENT"
    end;
}


page 50646 "Learning Activities/Materials"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50305;
    SourceTableView = WHERE(Category = CONST("LEARNING ACTIVITIES/MATERIALS"));

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
        Rec.Category := Rec.Category::"LEARNING ACTIVITIES/MATERIALS"
    end;
}


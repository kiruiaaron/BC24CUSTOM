page 50111 "Tender Evaluation Lines"
{
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = 50059;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ApplicationArea = All;
                }
                field(Evaluator; Rec.Evaluator)
                {
                    ApplicationArea = All;
                }
                field("Evaluator Name"; Rec."Evaluator Name")
                {
                    ApplicationArea = All;
                }
                field(Marks; Rec.Marks)
                {
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
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


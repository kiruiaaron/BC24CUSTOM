page 50078 "Tender Evaluators"
{
    PageType = ListPart;
    SourceTable = 50044;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Evaluator; Rec.Evaluator)
                {
                    ApplicationArea = All;
                }
                field("Evaluator Name"; Rec."Evaluator Name")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Committee Chairperson"; Rec."Committee Chairperson")
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


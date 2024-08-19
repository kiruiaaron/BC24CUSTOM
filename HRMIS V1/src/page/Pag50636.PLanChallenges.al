page 50636 "PLan Challenges"
{
    AutoSplitKey = true;
    Caption = 'Challenges';
    PageType = ListPart;
    SourceTable = 50301;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line no"; Rec."Line no")
                {
                    ApplicationArea = All;
                }
                field(Obstacles; Rec.Obstacles)
                {
                    Caption = 'Expected Obstacles';
                    ApplicationArea = All;
                }
                field("How to overcome"; Rec."How to overcome")
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


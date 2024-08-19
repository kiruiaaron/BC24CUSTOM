page 50640 "Plan Support"
{
    AutoSplitKey = true;
    Caption = 'Support/Resources';
    PageType = ListPart;
    SourceTable = 50303;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("AD Code"; Rec."AD Code")
                {
                    ApplicationArea = All;
                }
                field("Line no"; Rec."Line no")
                {
                    ApplicationArea = All;
                }
                field(Support; Rec.Support)
                {
                    Caption = 'Support/Resources';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


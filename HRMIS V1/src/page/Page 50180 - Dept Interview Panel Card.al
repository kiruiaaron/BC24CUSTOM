page 50180 "Dept Interview Panel Card"
{
    PageType = Card;
    SourceTable = 50106;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                }
                field("Dept Committee Name"; Rec."Dept Committee Name")
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50181)
            {
                SubPageLink = Code = FIELD("Department Code");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}


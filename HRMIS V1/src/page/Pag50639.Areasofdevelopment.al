page 50639 "Areas of development"
{
    PageType = ListPart;
    SourceTable = 50302;

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
                field("Areas of Development"; Rec."Areas of Development")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Goals)
            {
                Image = AllocatedCapacity;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                /*   RunObject = Page 50635;
                  RunPageLink = "Plan No" = FIELD(Plan No),
                                "AD Code"=FIELD("AD Code"); */
            }
            action(Challenges)
            {
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                /*    RunObject = Page 50636;
                                   RunPageLink = "Plan No"=FIELD("Plan No"),
                                 "AD Code"=FIELD("AD Code"); */
            }
            action(Support)
            {
                Image = Allocate;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                /*   RunObject = Page 50640;
                                  RunPageLink = "Plan No"=FIELD(Plan No),
                                "AD Code"=FIELD("AD Code"); */
            }
        }
    }
}


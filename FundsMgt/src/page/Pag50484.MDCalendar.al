page 50484 "MD Calendar"
{
    PageType = Card;
    SourceTable = 50272;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50483)
            {
                SubPageLink = "Calendar code" = FIELD(Code);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::CEO;
    end;
}


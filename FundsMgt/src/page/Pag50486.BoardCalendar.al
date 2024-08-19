page 50486 "Board Calendar"
{
    PageType = Card;
    SourceTable = 50272;
    SourceTableView = WHERE(Type = CONST(Board));

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
                field(Notes; Rec.Notes)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50499)
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
        Rec.Type := Rec.Type::Board;
    end;
}


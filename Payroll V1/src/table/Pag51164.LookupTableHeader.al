page 51164 "Lookup Table Header"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 51162;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Min Extract Amount (LCY)"; Rec."Min Extract Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Max Extract Amount (LCY)"; Rec."Max Extract Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Calendar Year"; Rec."Calendar Year")
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
            action(Action10)
            {
                Caption = 'Detail Lines';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 51165;
                RunPageLink = "Table ID" = FIELD("Table ID");
                ApplicationArea = All;
            }
        }
    }
}


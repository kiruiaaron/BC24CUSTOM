page 50684 "Probation Review KPI Subform"
{
    PageType = ListPart;
    SourceTable = 50333;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Area Of Performance"; Rec."Area Of Performance")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
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
            action(Details)
            {
                Caption = 'Details';
                Image = Entries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 50685;
                RunPageLink = "Review No." = FIELD("Review No."),
                              "Review KPI No." = FIELD("Line No.");
                ApplicationArea = All;
            }
        }
    }
}


page 51339 "Casual Request Lines"
{
    PageType = ListPart;
    SourceTable = 50276;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = All;
                }
                field("No Requested"; Rec."No Requested")
                {
                    ApplicationArea = All;
                }
                field("Job Code"; Rec."Job Code")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Administrative Cost"; Rec."Administrative Cost")
                {
                    ApplicationArea = All;
                }
                field("Gross Amount"; Rec."Gross Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


page 51338 "Casual Job Codes"
{
    SourceTable = 50311;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("Casual Cost"; Rec."Casual Cost")
                {
                    ApplicationArea = All;
                }
                field("Administrative Cost"; Rec."Administrative Cost")
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


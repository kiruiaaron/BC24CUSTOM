page 50263 "Training Attendees"
{
    PageType = ListPart;
    SourceTable = 50165;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; Rec."Application No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("E-mail Address"; Rec."E-mail Address")
                {
                    ApplicationArea = All;
                }
                field("Phone Number"; Rec."Phone Number")
                {
                    ApplicationArea = All;
                }
                field("Estimated Cost"; Rec."Estimated Cost")
                {
                    ApplicationArea = All;
                }
                field("Actual Training Cost"; Rec."Actual Training Cost")
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


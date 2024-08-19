page 50260 "Training Group Line"
{
    Caption = 'Training Group Participants';
    PageType = ListPart;
    SourceTable = 50163;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Training Group No."; Rec."Training Group No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Tittle"; Rec."Job Tittle")
                {
                    ApplicationArea = All;
                }
                field("E-mail Address"; Rec."E-mail Address")
                {
                    ApplicationArea = All;
                }
                field("Estimated Cost"; Rec."Estimated Cost")
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


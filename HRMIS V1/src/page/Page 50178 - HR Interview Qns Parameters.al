page 50178 "HR Interview Qns Parameters"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50111;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Applicant No"; Rec."Job Applicant No")
                {
                    ApplicationArea = All;
                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = All;
                }
                field(Firstname; Rec.Firstname)
                {
                    ApplicationArea = All;
                }
                field(Middlename; Rec.Middlename)
                {
                    ApplicationArea = All;
                }
                field("Evaluator No."; Rec."Evaluator No.")
                {
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Preliminary Qns"; Rec."Preliminary Qns")
                {
                    ApplicationArea = All;
                }
                field("Technical Qns"; Rec."Technical Qns")
                {
                    ApplicationArea = All;
                }
                field("Behavioural Qns"; Rec."Behavioural Qns")
                {
                    ApplicationArea = All;
                }
                field("Closing Qns"; Rec."Closing Qns")
                {
                    ApplicationArea = All;
                }
                field(Total; Rec.Total)
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


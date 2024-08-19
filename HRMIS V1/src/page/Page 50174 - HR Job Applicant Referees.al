page 50174 "HR Job Applicant Referees"
{
    Caption = 'Job Applicant Referees';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50170;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = All;
                }
                field("Personal E-Mail Address"; Rec."Personal E-Mail Address")
                {
                    ApplicationArea = All;
                }
                field("Postal Address"; Rec."Postal Address")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("Applicant E-mail"; Rec."Applicant E-mail")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Residential Address"; Rec."Residential Address")
                {
                    ApplicationArea = All;
                }
                field("Referee Category"; Rec."Referee Category")
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


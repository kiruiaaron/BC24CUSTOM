page 50172 "HR Applicant Employment Hist."
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50169;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Application No."; Rec."Job Application No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employer Name/Organization"; Rec."Employer Name/Organization")
                {
                    ApplicationArea = All;
                }
                field("Address of the Organization"; Rec."Address of the Organization")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Job Designation/Position Held"; Rec."Job Designation/Position Held")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field("Days/Years of service"; Rec."Days/Years of service")
                {
                    ApplicationArea = All;
                }
                field("Gross Salary"; Rec."Gross Salary")
                {
                    ApplicationArea = All;
                }
                field(Benefits; Rec.Benefits)
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


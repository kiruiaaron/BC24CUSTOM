page 50193 "HR Employee Employement Hist."
{
    Caption = 'HR Employee Employement History';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50124;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employer Name/Organization"; Rec."Employer Name/Organization")
                {
                    ApplicationArea = All;
                }
                field("Address of the Organization"; Rec."Address of the Organization")
                {
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
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}


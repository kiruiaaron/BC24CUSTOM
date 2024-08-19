page 50169 "Closed Job Applications"
{
    CardPageID = "HR Job Application Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50099;
    SourceTableView = SORTING("No.")
                      ORDER(Descending)
                      WHERE(Status = CONST(Shortlisted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number.';
                    ApplicationArea = All;
                }
                field("Employee Requisition No."; Rec."Employee Requisition No.")
                {
                    ToolTip = 'Specifies the Employee requisition Number.';
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the Job Number.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the Job Title.';
                    ApplicationArea = All;
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ToolTip = 'Specifies the Job Grade.';
                    ApplicationArea = All;
                }
                field(Surname; Rec.Surname)
                {
                    ToolTip = 'Specifies the surname.';
                    ApplicationArea = All;
                }
                field(Firstname; Rec.Firstname)
                {
                    ToolTip = 'Specifies the FirstName.';
                    ApplicationArea = All;
                }
                field(Middlename; Rec.Middlename)
                {
                    ToolTip = 'Specifies the Middle Name.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the Gender.';
                    ApplicationArea = All;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the Date of Birth.';
                    ApplicationArea = All;
                }
                field("National ID No."; Rec."National ID No.")
                {
                    ToolTip = 'Specifies the National ID No.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the document.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the User ID that raised the document.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Job Qualifications")
            {
                Image = BulletList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HR Job Qualifications";
                RunPageLink = "Job No." = FIELD("Job No.");
                ToolTip = 'Specifies the  Job qualification.';
                ApplicationArea = All;
            }
            action("Job Requirements")
            {
                Image = BusinessRelation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HR Job Requirements";
                RunPageLink = "Job No." = FIELD("Job No.");
                ToolTip = 'Specifies the  Job requirements.';
                ApplicationArea = All;
            }
            action("Job Responsibilities")
            {
                Image = ResourceSkills;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50160;
                RunPageLink = "Job No." = FIELD("Job No.");
                ToolTip = 'Specifies the  Job responsibilities.';
                ApplicationArea = All;
            }
        }
        area(processing)
        {
            action("Job Application Qualifications")
            {
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50171;
                RunPageLink = "Job Application No." = FIELD("No.");
                ToolTip = 'Specifies the  Job application and Qualifications.';
                ApplicationArea = All;
            }
        }
    }
}


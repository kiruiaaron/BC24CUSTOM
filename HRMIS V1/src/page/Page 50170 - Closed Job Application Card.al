page 50170 "Closed Job Application Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = 50099;
    SourceTableView = WHERE(Status = CONST(Shortlisted));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the  document number.';
                    ApplicationArea = All;
                }
                field("Employee Requisition No."; Rec."Employee Requisition No.")
                {
                    ToolTip = 'Specifies the  Employee Requisition Number.';
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the Employee Job No.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the  Job Title.';
                    ApplicationArea = All;
                }
                field("Emp. Requisition Description"; Rec."Emp. Requisition Description")
                {
                    ToolTip = 'Specifies the  Job description.';
                    ApplicationArea = All;
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ToolTip = 'Specifies the  Job Grade.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Description = 'Specifies the  approvals.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the  Global Dimension 1 Code.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the  Global Dimension 2 Code.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the  status of the document.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the  User ID that raised the document.';
                    ApplicationArea = All;
                }
            }
            group("Applicant Information")
            {
                field(Surname; Rec.Surname)
                {
                    ToolTip = 'Specifies the  Surname.';
                    ApplicationArea = All;
                }
                field(Firstname; Rec.Firstname)
                {
                    ToolTip = 'Specifies the  Firstname.';
                    ApplicationArea = All;
                }
                field(Middlename; Rec.Middlename)
                {
                    ToolTip = 'Specifies the Middle Name';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the  Gender.';
                    ApplicationArea = All;
                }
                field("Person Living With Disability"; Rec."Person Living With Disability")
                {
                    ApplicationArea = All;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the  Date of Birth.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the  Age.';
                    ApplicationArea = All;
                }
                field("Postal Address"; Rec."Postal Address")
                {
                    ToolTip = 'Specifies the  Address.';
                    ApplicationArea = All;
                }
                field("Residential Address"; Rec."Residential Address")
                {
                    ToolTip = 'Specifies Address 2.';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the  Post Code.';
                    ApplicationArea = All;
                }
                field("City/Town"; Rec."City/Town")
                {
                    ToolTip = 'Specifies the  City.';
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the County Code.';
                    ApplicationArea = All;
                }
                field("County Name"; Rec."County Name")
                {
                    ToolTip = 'Specifies the County Name.';
                    ApplicationArea = All;
                }
                field(SubCounty; Rec.SubCounty)
                {
                    ToolTip = 'Specifies the  SubCounty Code.';
                    ApplicationArea = All;
                }
                field("SubCounty Name"; Rec."SubCounty Name")
                {
                    ToolTip = 'Specifies the  Subcounty Name.';
                    ApplicationArea = All;
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the  Country.';
                    ApplicationArea = All;
                }
                field("Alternative Phone No."; Rec."Alternative Phone No.")
                {
                    ToolTip = 'Specifies the  Home Phone No.';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies Mobile Phone No.';
                    ApplicationArea = All;
                }
                field("Personal Email Address"; Rec."Personal Email Address")
                {
                    ToolTip = 'Specifies Personal Email address';
                    ApplicationArea = All;
                }
                field("Birth Certificate No."; Rec."Birth Certificate No.")
                {
                    ToolTip = 'Specifies the  Birth Certificate Number.';
                    ApplicationArea = All;
                }
                field("National ID No."; Rec."National ID No.")
                {
                    ToolTip = 'Specifies the National ID No.';
                    ApplicationArea = All;
                }
                field("Huduma No."; Rec."Huduma No.")
                {
                    ApplicationArea = All;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ToolTip = 'Specifies Passport No.';
                    ApplicationArea = All;
                }
                field("PIN  No."; Rec."PIN  No.")
                {
                    ApplicationArea = All;
                }
                field("NHIF No."; Rec."NHIF No.")
                {
                    ApplicationArea = All;
                }
                field("NSSF No."; Rec."NSSF No.")
                {
                    ApplicationArea = All;
                }
                field("Driving Licence No."; Rec."Driving Licence No.")
                {
                    ToolTip = 'Specifies driving Licence No.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the  Marital Status.';
                    ApplicationArea = All;
                }
                field(Citizenship; Rec.Citizenship)
                {
                    ToolTip = 'Specifies Citizenship.';
                    ApplicationArea = All;
                }
                field("Ethnic Group"; Rec."Ethnic Group")
                {
                    ApplicationArea = All;
                }
                field(Religion; Rec.Religion)
                {
                    ToolTip = 'Specifies Religion.';
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
                ToolTip = 'Specifies the  Job Qualifications.';
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
                ToolTip = 'Specifies Job requirements';
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
                ToolTip = 'Specifies the  Job Application qualifications.';
                ApplicationArea = All;
            }
            action("HR Applicant Employment Hist.")
            {
                Caption = 'HR Applicant Employment Hist.';
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50172;
                ApplicationArea = All;
            }
        }
    }
}


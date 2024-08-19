page 50167 "HR Job Applications"
{
    CardPageID = "HR Job Application Card";
    DeleteAllowed = true;
    PageType = List;
    ShowFilter = true;
    SourceTable = 50099;
    SourceTableView = WHERE(Status = FILTER(<> Shortlisted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the document number.';
                    ApplicationArea = All;
                }
                field("Employee Requisition No."; Rec."Employee Requisition No.")
                {
                    ToolTip = 'Specifies the Employee requisition number.';
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the Job number.';
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
                    ToolTip = 'Specifies the Surname.';
                    ApplicationArea = All;
                }
                field(Firstname; Rec.Firstname)
                {
                    ToolTip = 'Specifies the Firstname.';
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
                field(Age; Rec.Age)
                {
                    ApplicationArea = All;
                }
                field("National ID No."; Rec."National ID No.")
                {
                    ToolTip = 'Specifies the National ID No.';
                    ApplicationArea = All;
                }
                field("Person Living With Disability"; Rec."Person Living With Disability")
                {
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field("County Name"; Rec."County Name")
                {
                    ApplicationArea = All;
                }
                field("SubCounty Name"; Rec."SubCounty Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the document status.';
                    ApplicationArea = All;
                }
                field(ShortListed; Rec.ShortListed)
                {
                    ApplicationArea = All;
                }
                field("Committee Shortlisted"; Rec."Committee Shortlisted")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field("Interview Date"; Rec."Interview Date")
                {
                    ApplicationArea = All;
                }
                field("Interview Time"; Rec."Interview Time")
                {
                    ApplicationArea = All;
                }
                field("Interview Location"; Rec."Interview Location")
                {
                    ApplicationArea = All;
                }
                field(Qualified; Rec.Qualified)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Send Approval Request';
                ApplicationArea = All;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                ToolTip = 'Cancel Approval Request';
                ApplicationArea = All;
            }
            action(Approvals)
            {
                Caption = 'Approvals';
                ToolTip = 'Approvals';
                ApplicationArea = All;
            }
            action(ReOpen)
            {
                Caption = 'ReOpen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'ReOpen';
                ApplicationArea = All;
            }
        }
        area(navigation)
        {
            action("Job Qualifications")
            {
                Caption = 'Job Qualifications';
                Image = BulletList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "HR Job Qualifications";
                RunPageLink = "Job No." = FIELD("Job No.");
                ToolTip = 'Job Qualifications';
                ApplicationArea = All;
            }
            action("Job Requirements")
            {
                Caption = 'Job Requirements';
                Image = BusinessRelation;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "HR Job Requirements";
                RunPageLink = "Job No." = FIELD("Job No.");
                ToolTip = 'Job Requirements';
                ApplicationArea = All;
            }
            action("Job Responsibilities")
            {
                Caption = 'Job Responsibilities';
                Image = ResourceSkills;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50160;
                RunPageLink = "Job No." = FIELD("Job No.");
                ToolTip = 'Job Responsibilities';
                ApplicationArea = All;
            }
        }
        area(processing)
        {
            action("Academic Qualifications")
            {
                Caption = 'Applicant Academic Qualifications';
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50171;
                RunPageLink = "Job Application No." = FIELD("No.");
                ToolTip = 'Job Application Qualifications';
                ApplicationArea = All;
            }
            action("Applicant Job Requirements")
            {
                Caption = 'Applicant Job Requirements';
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50173;
                RunPageLink = "Job Application No." = FIELD("No.");
                ToolTip = 'Job Application Requirements';
                ApplicationArea = All;
            }
            action("Applicant Employement History ")
            {
                Caption = 'Applicant Employement History';
                Image = ElectronicRegister;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50172;
                RunPageLink = "Job Application No." = FIELD("No.");
                ToolTip = 'Applicant Employement History';
                ApplicationArea = All;
            }
            action("Applicant Referees")
            {
                Image = ResourceGroup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50174;
                RunPageLink = "Job Application  No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("ShortList Applicant")
            {
                Caption = 'ShortList Applicant';
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt080) = FALSE THEN EXIT;
                    Rec.ShortListed := TRUE;
                    REC.MODIFY;
                    MESSAGE(Txt081);
                end;
            }
        }
        area(reporting)
        {
            action("Print Job Offer Letter")
            {
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.SETRANGE("No.", Rec."No.");
                    // ReportSelections.Print(ReportSelections.Usage::"Job Offer", Rec, 0);
                end;
            }
            action("Print Medical Letter")
            {
                Caption = 'Print Medical Examination Letter';
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.SETRANGE("No.", Rec."No.");
                    //ReportSelections.Print(ReportSelections.Usage::"Medical Examination", Rec, 0);
                end;
            }
        }
    }

    var
        Employees: Record 5200;
        EmployeeRecruitment: Codeunit 50033;
        Txt080: Label 'Shortlist Applicant?';
        Txt081: Label 'Applicant Shortlisted ';
        UsageReportSelections: Option "Job Offer";
        ReportSelections: Record 77;
}


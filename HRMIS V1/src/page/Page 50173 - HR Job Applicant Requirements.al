page 50173 "HR Job Applicant Requirements"
{
    Caption = 'Job Applicant Requirements';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50168;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requirement Code"; Rec."Requirement Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("No. of Years"; Rec."No. of Years")
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
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HR Job Qualifications";
                RunPageLink = "Job No." = FIELD("Job Application No.");
                ToolTip = 'Job Qualifications';
                ApplicationArea = All;
            }
            action("Job Requirements")
            {
                Caption = 'Job Requirements';
                Image = BusinessRelation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HR Job Requirements";
                RunPageLink = "Job No." = FIELD("Job Application No.");
                ToolTip = 'Job Requirements';
                ApplicationArea = All;
            }
            action("Job Responsibilities")
            {
                Caption = 'Job Responsibilities';
                Image = ResourceSkills;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50160;
                RunPageLink = "Job No." = FIELD("Job Application No.");
                ToolTip = 'Job Responsibilities';
                ApplicationArea = All;
            }
        }
        area(processing)
        {
            action("Job Application Qualifications")
            {
                Caption = 'Job Application Qualifications';
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50171;
                RunPageLink = "Job Application No." = FIELD("Job Application No.");
                ToolTip = 'Job Application Qualifications';
                ApplicationArea = All;
            }
        }
    }
}


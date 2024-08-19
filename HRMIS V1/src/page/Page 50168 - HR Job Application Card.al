page 50168 "HR Job Application Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 50099;
    SourceTableView = WHERE(Status = FILTER(<> Shortlisted));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the document number.';
                    ApplicationArea = All;
                }
                field("Employee Requisition No."; Rec."Employee Requisition No.")
                {
                    ToolTip = 'Specifies the employee requisition number.';
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
                field("Salary Notch"; Rec."Salary Notch")
                {
                    ApplicationArea = All;
                }
                field("HR Salary Notch"; Rec."HR Salary Notch")
                {
                    Visible = HRSalaryNotchVisible;
                    ApplicationArea = All;
                }
                field("Emp. Requisition Description"; Rec."Emp. Requisition Description")
                {
                    ToolTip = 'Specifies the Job description.';
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 1 Code.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the Global Dimesion 2 Code.';
                    ApplicationArea = All;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the document Status.';
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
                field(Qualified; Rec.Qualified)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the User ID that raised the document.';
                    ApplicationArea = All;
                }
                field("Employee Created"; Rec."Employee Created")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("Applicant Information")
            {
                field(Surname; Rec.Surname)
                {
                    ToolTip = 'Specifies the Surname.';
                    ApplicationArea = All;
                }
                field(Firstname; Rec.Firstname)
                {
                    ToolTip = 'Specifies the Surname';
                    ApplicationArea = All;
                }
                field(Middlename; Rec.Middlename)
                {
                    ToolTip = 'Specifies the middle name.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the Gender';
                    ApplicationArea = All;
                }
                field("Person Living With Disability"; Rec."Person Living With Disability")
                {
                    ApplicationArea = All;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the Date of Birth.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the Age';
                    ApplicationArea = All;
                }
                field("Postal Address"; Rec."Postal Address")
                {
                    ToolTip = 'Specifies the address';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the Post Code. ';
                    ApplicationArea = All;
                }
                field("City/Town"; Rec."City/Town")
                {
                    ToolTip = 'Specifies the City.';
                    ApplicationArea = All;
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the Country Name.';
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    Caption = 'County of Origin';
                    ToolTip = 'Specifies the County';
                    ApplicationArea = All;
                }
                field("County Name"; Rec."County Name")
                {
                    ToolTip = 'Specifies the County Name.';
                    ApplicationArea = All;
                }
                field(SubCounty; Rec.SubCounty)
                {
                    Caption = 'SubCounty of Origin';
                    ToolTip = 'Specifies the Subcounty Code.';
                    ApplicationArea = All;
                }
                field("SubCounty Name"; Rec."SubCounty Name")
                {
                    ToolTip = 'Specifies the Subcounty Name.';
                    ApplicationArea = All;
                }
                field("Residential Address"; Rec."Residential Address")
                {
                    ToolTip = 'Specifies the address 2. ';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the Mobile Phone Number.';
                    ApplicationArea = All;
                }
                field("Alternative Phone No."; Rec."Alternative Phone No.")
                {
                    ToolTip = 'Specifies the Home Phone Number.';
                    ApplicationArea = All;
                }
                field("Birth Certificate No."; Rec."Birth Certificate No.")
                {
                    ToolTip = 'Specifies the Birth Certificate No.';
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
                    ToolTip = 'Specifies the Passport Number.';
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
                field("Personal Email Address"; Rec."Personal Email Address")
                {
                    ToolTip = 'Specifies Persoanal Email address.';
                    ApplicationArea = All;
                }
                field("Driving Licence No."; Rec."Driving Licence No.")
                {
                    ToolTip = 'Specifies the driving license No.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the Marital status.';
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
                    ToolTip = 'Specifies the Religion.';
                    ApplicationArea = All;
                }
            }
            group("Bank Information")
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch Code"; Rec."Bank Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch Name"; Rec."Bank Branch Name")
                {
                    ApplicationArea = All;
                }
            }
            group("Important Dates")
            {
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                }
                field("Probation Start Date"; Rec."Probation Start Date")
                {
                    ApplicationArea = All;
                }
                field("Probation Period"; Rec."Probation Period")
                {
                    ApplicationArea = All;
                }
                field("Probation End date"; Rec."Probation End date")
                {
                    ApplicationArea = All;
                }
            }
            group("Interview Details")
            {
                Visible = InterviewDetailsVisible;
                field("Interview Date"; Rec."Interview Date")
                {
                    Editable = InterviewDateEditable;
                    ApplicationArea = All;
                }
                field("Interview Time"; Rec."Interview Time")
                {
                    Editable = InterviewTimeEditable;
                    ApplicationArea = All;
                }
                field("Interview Location"; Rec."Interview Location")
                {
                    Editable = InterviewLocationEditable;
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
                PromotedCategory = Category10;
                PromotedIsBig = true;
                ToolTip = 'Send Approval Request';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Open);
                    //  IF ApprovalsMgmtExt.ihIsHRJobApplicationApprovalsWorkflowEnabled(Rec) THEN
                    ApprovalsMgmtExt.OnSendHRJobApplicationForApproval(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedIsBig = true;
                ToolTip = 'Cancel Approval Request';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // ApprovalsMgmtExt.CheckHRJobApplicationApprovalsWorkflowEnabled(Rec);
                    //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                    CurrPage.CLOSE;
                end;
            }
            action(Approvals)
            {
                AccessByPermission = TableData 454 = R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedIsBig = true;
                PromotedOnly = true;
                /* RunObject = Page "Approval Entries";
                 RunPageLink = "Document No." = FIELD("No.");*/
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    WorkflowsEntriesBuffer: Record 832;
                    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund",Requisition,"Funds Transfer","HR Document";
                begin
                end;
            }
            action(ReOpen)
            {
                Caption = 'ReOpen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'ReOpen';
                Visible = false;
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
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page 50171;
                RunPageLink = "E-mail" = FIELD("Personal Email Address"),
                              "Job Application No." = FIELD("No.");
                ToolTip = 'Job Application Qualifications';
                ApplicationArea = All;
            }
            action("Applicant Job Requirements")
            {
                Caption = 'Applicant Job Requirements';
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page 50173;
                RunPageLink = "E-mail" = FIELD("Personal Email Address"),
                              "Job Application No." = FIELD("No.");
                ToolTip = 'Job Application Requirements';
                ApplicationArea = All;
            }
            action("Applicant Employement History ")
            {
                Caption = 'Applicant Employement History';
                Image = ElectronicRegister;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page 50172;
                RunPageLink = "E-mail" = FIELD("Personal Email Address"),
                              "Job Application No." = FIELD("No.");
                ToolTip = 'Applicant Employement History';
                ApplicationArea = All;
            }
            action("Applicant Referees")
            {
                Image = ResourceGroup;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page 50174;
                RunPageLink = "Job Application  No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("HR Mandatory Document Checklist")
            {
                Caption = 'HR Mandatory Document Checklist';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                RunObject = Page 50175;
                RunPageLink = "Document No." = FIELD("No.");
                ToolTip = 'HR Mandatory Document Checklist';
                ApplicationArea = All;
            }
            action("Transfer Applicant Details to Employee card")
            {
                Caption = 'Transfer Applicant Details to Employee card';
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Txt050: Label 'Post Transfer Details?';
                begin
                    Rec.TESTFIELD(Qualified, TRUE);
                    IF Rec."Employee Created" = TRUE THEN
                        ERROR(Txt087);

                    //Check if HR Mandatory checklist documents have been attached.
                    /*HRJobLookupValue.RESET;
                    HRJobLookupValue.SETRANGE(HRJobLookupValue."Required Stage",HRJobLookupValue."Required Stage"::"Employee Creation");
                    IF HRJobLookupValue.FINDSET THEN BEGIN
                      REPEAT
                        HRMandatoryDocChecklist.RESET;
                        HRMandatoryDocChecklist.SETRANGE(HRMandatoryDocChecklist."Document No.","No.");
                        HRMandatoryDocChecklist.SETRANGE(HRMandatoryDocChecklist."Mandatory Doc. Code",HRJobLookupValue.Code);
                        IF HRMandatoryDocChecklist.FINDFIRST THEN BEGIN
                          IF NOT HRMandatoryDocChecklist.HASLINKS THEN BEGIN
                            ERROR(HRJobLookupValue.Code+' '+Txt092);
                            BREAK;
                            EXIT;
                          END;
                        END ELSE BEGIN
                            ERROR(HRJobLookupValue.Code+' '+Txt092);
                            BREAK;
                            EXIT;
                        END;
                      UNTIL HRJobLookupValue.NEXT=0;
                    END;*/

                    IF CONFIRM(Txt091) = FALSE THEN EXIT;
                    EmployeeRecruitment.TransferQualifiedApplicantDetailsToEmployee(Rec);

                end;
            }
            action("ShortList Applicant")
            {
                Caption = 'ShortList Applicant';
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt080) = FALSE THEN EXIT;
                    Rec.ShortListed := TRUE;
                    Rec."To be Interviewed" := TRUE;
                    REC.MODIFY;
                    MESSAGE(Txt081);
                end;
            }
            action("ShortList For Interview")
            {
                Caption = 'ShortList For Interview';
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt084) = FALSE THEN EXIT;
                    Rec."Committee Shortlisted" := TRUE;
                    Rec.ShortListed := TRUE;
                    Rec."To be Interviewed" := TRUE;
                    REC.MODIFY;
                    MESSAGE(Txt081);
                end;
            }
            action("Drop Applicant from Shortlist ")
            {
                Caption = 'Drop Applicant from Shortlisted list';
                Image = DeleteAllBreakpoints;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Qualified = TRUE THEN BEGIN
                        ERROR(Txt088);
                    END;
                    IF CONFIRM(Txt085) = FALSE THEN EXIT;
                    Rec.ShortListed := FALSE;
                    REC.MODIFY;
                    MESSAGE(Txt086);
                end;
            }
            action("Drop Applicant From Interview")
            {
                Caption = 'Drop Applicant for Next Interview';
                Image = DeleteExpiredComponents;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Qualified = TRUE THEN BEGIN
                        ERROR(Txt088);
                    END;
                    IF CONFIRM(Txt090) = FALSE THEN EXIT;
                    Rec."To be Interviewed" := FALSE;
                    REC.MODIFY;
                    MESSAGE(Txt089);
                end;
            }
            action("Qualify Applicant")
            {
                Caption = 'Qualify Applicant';
                Image = Opportunity;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt082) = FALSE THEN EXIT;
                    Rec.Qualified := TRUE;
                    REC.MODIFY;
                    MESSAGE(Txt083, Rec."Employee Requisition No.");


                    HRJobLookupValue.RESET;
                    HRJobLookupValue.SETRANGE(HRJobLookupValue.Option, HRJobLookupValue.Option::"Checklist Item");
                    HRJobLookupValue.SETRANGE(HRJobLookupValue."Required Stage", HRJobLookupValue."Required Stage"::"Employee Creation");
                    IF HRJobLookupValue.FINDSET THEN BEGIN
                        REPEAT
                            HRMandatoryDocChecklist.INIT;
                            HRMandatoryDocChecklist."Document No." := Rec."No.";
                            HRMandatoryDocChecklist."Mandatory Doc. Code" := HRJobLookupValue.Code;
                            HRMandatoryDocChecklist."Mandatory Doc. Description" := HRJobLookupValue.Description;
                            HRMandatoryDocChecklist."Document Attached" := FALSE;
                            HRMandatoryDocChecklist.INSERT;
                        UNTIL HRJobLookupValue.NEXT = 0;
                    END;
                end;
            }
            action("Print Job Offer Letter")
            {
                Caption = 'Print Job Offer Letter Permanent';
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.SETRANGE("No.", Rec."No.");
                    //     ReportSelections.Print(ReportSelections.Usage::"Job Offer", Rec, 0);
                end;
            }
            action("Print Job Offer Letter 2")
            {
                Caption = 'Print Job Offer Letter Contract';
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
                    //     ReportSelections.Print(ReportSelections.Usage::"Medical Examination", Rec, 0);
                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    end;

                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Rec."Committee Shortlisted" = FALSE THEN BEGIN
            InterviewDetailsVisible := FALSE;
            InterviewDateEditable := FALSE;
            InterviewTimeEditable := FALSE;
            InterviewLocationEditable := FALSE;
        END;

        IF Rec."Committee Shortlisted" = TRUE THEN BEGIN
            InterviewDetailsVisible := TRUE;
            InterviewDateEditable := TRUE;
            InterviewTimeEditable := TRUE;
            InterviewLocationEditable := TRUE;
        END;

        IF Rec.Qualified = FALSE THEN BEGIN
            HRSalaryNotchVisible := FALSE;
        END;

        IF Rec.Qualified = TRUE THEN BEGIN
            HRSalaryNotchVisible := TRUE;
        END;
    end;

    var
        EmployeeRecruitment: Codeunit 50033;
        Txt080: Label 'Shortlist Applicant?';
        Txt081: Label 'Applicant Shortlisted ';
        Txt082: Label 'Are you sure you Want to Qualify this Applicant for the Job Position, do you confirm the Job Applicant has appeared in person and Signed the Job Offer Letter? If Yes proceed to Qualify the Applicant';
        Txt083: Label 'Applicant for %1 has been qualified for the Job Position';
        HRWebManage: Codeunit 50024;
        Txt084: Label 'Do you want to shortlist Applicant as Approved by Committee?';
        Txt085: Label 'Are you sure you want to drop the Applicant from the shortlisted applicants list?';
        Txt086: Label 'Applicant has been droped from the list of the shortlisted Applicant';
        Txt087: Label 'Employee Is already created.';
        HRSalaryNotchVisible: Boolean;
        InterviewDetailsVisible: Boolean;
        InterviewDateEditable: Boolean;
        InterviewTimeEditable: Boolean;
        InterviewLocationEditable: Boolean;
        Txt088: Label 'You cannot drop an applicant who has been qualified for the Job!';
        Txt089: Label 'Applicant has been droped from the list of candidates to be interviewed';
        Txt090: Label 'Are you sure you want to drop the Applicant from the Interview applicants list?';
        HRJobApplications: Record 50099;
        UsageReportSelections: Option "Job Offer";
        ReportSelections: Record 77;
        Txt091: Label 'Are you sure you want to transfer the Job Applicants details to Employee Biodata?';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        // WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

        HRJobLookupValue: Record 50097;
        HRMandatoryDocChecklist: Record 50112;
        Txt092: Label 'has not been attached. This is a required document.';
}


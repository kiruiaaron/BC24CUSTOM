page 50183 "Interview Header Card"
{
    PageType = Card;
    SourceTable = 50108;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Interview No"; Rec."Interview No")
                {
                    ApplicationArea = All;
                }
                field("Interview Committee code"; Rec."Interview Committee code")
                {
                    ApplicationArea = All;
                }
                field("Interview Committee Name"; Rec."Interview Committee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Requisition No."; Rec."Job Requisition No.")
                {
                    ApplicationArea = All;
                }
                field("Interview Job No."; Rec."Interview Job No.")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Interview Date from"; Rec."Interview Date from")
                {
                    ApplicationArea = All;
                }
                field("Interview Date to"; Rec."Interview Date to")
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
                field("Interview Chairperson Code"; Rec."Interview Chairperson Code")
                {
                    ApplicationArea = All;
                }
                field("Interview Chairperson Name"; Rec."Interview Chairperson Name")
                {
                    ApplicationArea = All;
                }
                field("Interview Purpose"; Rec."Interview Purpose")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Committee Remarks"; Rec."Committee Remarks")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Created by"; Rec."Created by")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Mandatory Docs. Required"; Rec."Mandatory Docs. Required")
                {
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50184)
            {
                SubPageLink = "Interview No." = FIELD("Interview No");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Applicant Results")
            {
                Caption = 'Applicant Results';
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50176;
                RunPageLink = "Job Requistion No" = FIELD("Job Requisition No."),
                              "Job No" = FIELD("Interview Job No.");
                ApplicationArea = All;
            }
            action("Insert Applicant Results")
            {
                Caption = 'Insert Applicant Results';
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    InsertApplicantResults;
                end;
            }
            action("Shortlisted Applicants")
            {
                Caption = 'Shortlisted Applicants';
                Image = ElectronicNumber;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50177;
                RunPageLink = "Employee Requisition No." = FIELD("Job Requisition No.");
                RunPageView = WHERE("To be Interviewed" = FILTER(True));
                ApplicationArea = All;
            }
            action("Email Invitation to Candidates")
            {
                Caption = 'Send Email Invitation to Successfull Candidates';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Confirm Interview Date, Time and Location has been filled for the Interviews before sending Invitation Email
                    HRJobApplications.RESET;
                    HRJobApplications.SETRANGE(HRJobApplications."Employee Requisition No.", Rec."Job Requisition No.");
                    HRJobApplications.SETRANGE(HRJobApplications."Committee Shortlisted", TRUE);
                    IF HRJobApplications.FINDSET THEN BEGIN
                        REPEAT
                            HRJobApplications.TESTFIELD(HRJobApplications."Interview Date");
                            HRJobApplications.TESTFIELD(HRJobApplications."Interview Time");
                            HRJobApplications.TESTFIELD(HRJobApplications."Interview Location");
                        UNTIL HRJobApplications.NEXT = 0;
                    END;

                    EmployeeRecruitment.SendInterviewShortlistedApplicantEmail(Rec."Interview Job No.", Rec."Job Requisition No.", Rec."Interview Date from", Rec."Interview Time", Rec."Interview Location", Rec."Interview No", Rec."Interview Date to");
                end;
            }
            action("HR Interview Questions")
            {
                Caption = 'HR Interview Questions Panelist Scoring';
                Image = ResourceJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50178;
                RunPageLink = "Job Requistion No" = FIELD("Job Requisition No.");
                Visible = false;
                ApplicationArea = All;
            }
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Send Approval Request';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Check if HR Mandatory checklist documents have been attached.
                    IF Rec."Mandatory Docs. Required" = TRUE THEN
                        HRJobLookupValue.RESET;
                    HRJobLookupValue.SETRANGE(HRJobLookupValue."Required Stage", HRJobLookupValue."Required Stage"::"Interview Approval");
                    IF HRJobLookupValue.FINDSET THEN BEGIN
                        REPEAT
                            HRMandatoryDocChecklist.RESET;
                            HRMandatoryDocChecklist.SETRANGE(HRMandatoryDocChecklist."Document No.", Rec."Interview No");
                            HRMandatoryDocChecklist.SETRANGE(HRMandatoryDocChecklist."Mandatory Doc. Code", HRJobLookupValue.Code);
                            IF HRMandatoryDocChecklist.FINDFIRST THEN BEGIN
                                IF NOT HRMandatoryDocChecklist.HASLINKS THEN BEGIN
                                    ERROR(HRJobLookupValue.Code + ' ' + Txt001);
                                    BREAK;
                                    EXIT;
                                END;
                            END ELSE BEGIN
                                ERROR(HRJobLookupValue.Code + ' ' + Txt001);
                                BREAK;
                                EXIT;
                            END;
                        UNTIL HRJobLookupValue.NEXT = 0;
                    END;

                    Rec.TESTFIELD(Status, Rec.Status::Open);
                    IF ApprovalsMgmtExt.CheckInterviewAttendanceHeaderApprovalsWorkflowEnabled(Rec) THEN
                        ApprovalsMgmtExt.OnSendInterviewHeaderAttendanceForApproval(Rec);
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
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Approval Entries";
                RunPageLink = "Document No." = FIELD("Interview No");
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    WorkflowsEntriesBuffer: Record 832;
                    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund",Requisition,"Funds Transfer","HR Document";
                begin
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                    ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                // WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                begin

                    ApprovalsMgmtExt.OnCancelInterviewAttendanceApprovalRequest(Rec);
                    //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                    CurrPage.CLOSE
                end;
            }
            action("HR Mandatory Document Checklist")
            {
                Caption = 'HR Mandatory Document Checklist';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page 50175;
                RunPageLink = "Document No." = FIELD("Interview No");
                ToolTip = 'HR Mandatory Document Checklist';
                ApplicationArea = All;
            }
            action("Insert Mandatory Documents")
            {
                Caption = 'Insert Mandatory Documents for Approval';
                Image = Insert;
                Promoted = true;
                PromotedCategory = Category5;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRJobLookupValue.RESET;
                    HRJobLookupValue.SETRANGE(HRJobLookupValue.Option, HRJobLookupValue.Option::"Checklist Item");
                    HRJobLookupValue.SETRANGE(HRJobLookupValue."Required Stage", HRJobLookupValue."Required Stage"::"Interview Approval");
                    IF HRJobLookupValue.FINDSET THEN BEGIN
                        REPEAT
                            HRMandatoryDocChecklist.INIT;
                            HRMandatoryDocChecklist."Document No." := Rec."Interview No";
                            HRMandatoryDocChecklist."Mandatory Doc. Code" := HRJobLookupValue.Code;
                            HRMandatoryDocChecklist."Mandatory Doc. Description" := HRJobLookupValue.Description;
                            HRMandatoryDocChecklist."Document Attached" := FALSE;
                            HRMandatoryDocChecklist.INSERT;
                        UNTIL HRJobLookupValue.NEXT = 0;
                        Rec."Mandatory Docs. Required" := TRUE;
                        REC.MODIFY;
                    END;
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

    trigger OnAfterGetRecord()
    begin
        IF Rec.Closed = TRUE THEN
            CurrPage.EDITABLE(FALSE);
    end;

    trigger OnOpenPage()
    begin
        IF Rec.Closed = TRUE THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        EmployeeRecruitment: Codeunit 50033;
        HRJobApplications: Record 50099;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        // WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

        HRJobLookupValue: Record 50097;
        HRMandatoryDocChecklist: Record 50112;
        Txt001: Label 'has not been attached. This is a required document.';

    local procedure InsertApplicantResults()
    var
        HRJobApplicantResultsRec: Record 50110;
        HRJobApplications: Record 50099;
    begin
        HRJobApplicantResultsRec.RESET;
        HRJobApplicantResultsRec.SETRANGE("Job Requistion No", Rec."Job Requisition No.");
        IF HRJobApplicantResultsRec.FINDSET THEN
            IF NOT CONFIRM('Applicant results exists, do you want to delete?') THEN
                EXIT;

        HRJobApplicantResultsRec.DELETEALL;
        HRJobApplications.RESET;
        HRJobApplications.SETRANGE("Employee Requisition No.", Rec."Job Requisition No.");
        HRJobApplications.SETRANGE("Committee Shortlisted", TRUE);
        HRJobApplications.SETRANGE("To be Interviewed", TRUE);
        IF HRJobApplications.FINDFIRST THEN
            REPEAT
                HRJobApplicantResultsRec.INIT;
                HRJobApplicantResultsRec.VALIDATE("Job Applicant No", HRJobApplications."No.");
                HRJobApplicantResultsRec.VALIDATE("Job Requistion No", HRJobApplications."Employee Requisition No.");
                HRJobApplicantResultsRec.Firstname := HRJobApplications.Firstname;
                HRJobApplicantResultsRec.Middlename := HRJobApplications.Middlename;
                HRJobApplicantResultsRec.Surname := HRJobApplications.Surname;
                HRJobApplicantResultsRec.VALIDATE("Job No", HRJobApplications."Job No.");
                HRJobApplicantResultsRec.INSERT;


            UNTIL HRJobApplications.NEXT = 0;
    end;
}


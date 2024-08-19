page 50164 "Employee Requisition Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 50098;
    SourceTableView = WHERE(Status = FILTER(<> Closed));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number.';
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
                field("Emp. Requisition Description"; Rec."Emp. Requisition Description")
                {
                    ToolTip = 'Specifies the description for the Job Title.';
                    ApplicationArea = All;
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ApplicationArea = All;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    Editable = EmployeeContractCodeEditable;
                    ApplicationArea = All;
                }
                field("Maximum Positions"; Rec."Maximum Positions")
                {
                    ToolTip = 'Specifies the Maximum positions for a specific Job.';
                    ApplicationArea = All;
                }
                field("Occupied Positions"; Rec."Occupied Positions")
                {
                    ToolTip = 'Specifies the number of occupied positions.';
                    ApplicationArea = All;
                }
                field("Vacant Positions"; Rec."Vacant Positions")
                {
                    ToolTip = 'Specifies the number of vaccant  positions.';
                    ApplicationArea = All;
                }
                field("Requested Employees"; Rec."Requested Employees")
                {
                    ToolTip = 'Specifies the number of requested Employees.';
                    ApplicationArea = All;
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    Editable = ClosingDateEditable;
                    ToolTip = 'Specifies the closing date for a specific Job requisition.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 1 code.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the Global Dimension 2 code.';
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the Responsibility Centre.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Job Advert Published"; Rec."Job Advert Published")
                {
                    ApplicationArea = All;
                }
                field("Regret Email Sent"; Rec."Regret Email Sent")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    OptionCaption = 'Open,Pending Approval,Approved,Rejected,Closed';
                    ToolTip = 'Specifies the status.';
                    ApplicationArea = All;
                }
                field("Job Advert Dropped"; Rec."Job Advert Dropped")
                {
                    Caption = 'Job Advertisement Dropped';
                    ApplicationArea = All;
                }
                field("Purchase Requisition Created"; Rec."Purchase Requisition Created")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Purchase Requisition No."; Rec."Purchase Requisition No.")
                {
                    ApplicationArea = All;
                }
                field("Mandatory Docs. Required"; Rec."Mandatory Docs. Required")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user ID that created the document.';
                    ApplicationArea = All;
                }
            }
            part("System Shortlisted Applicants"; 50167)
            {
                Caption = 'System Shortlisted Applicants';
                SubPageLink = "Employee Requisition No." = FIELD("No."),
                              ShortListed = CONST(True);
                ApplicationArea = All;
            }
            part(" System Shortlisted Applicants"; 50177)
            {
                Caption = 'System Shortlisted Applicants';
                SubPageLink = "Employee Requisition No." = FIELD("No."),
                              ShortListed = CONST(True);
                Visible = false;
                ApplicationArea = All;
            }
            part(" Committee Shortlisted "; 50177)
            {
                Caption = 'Committee Shortlisted Applicants';
                SubPageLink = "Employee Requisition No." = FIELD("No."),
                              "Committee Shortlisted" = CONST(True);
                ApplicationArea = All;
            }
            group("Interview Details")
            {
                Visible = false;
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
        area(processing)
        {
            group(Group)
            {
                action("Print Job Advertisement")
                {
                    Caption = 'Print Job Advertisment';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Print Job Advertisment';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HREmployeeRequisitions.RESET;
                        HREmployeeRequisitions.SETRANGE(HREmployeeRequisitions."No.", Rec."No.");
                        IF HREmployeeRequisitions.FINDFIRST THEN BEGIN
                            //    REPORT.RUNMODAL(REPORT::"HR Job Advert", TRUE, TRUE, HREmployeeRequisitions);
                        END;
                    end;
                }
                action("Requisition for Job Advertisment")
                {
                    Caption = 'Requisition for Job Advertisment';
                    Image = ReservationLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    /*  RunObject = Page 50083;
                     RunPageLink = "Reference Document No." = FIELD("No."); */
                    ToolTip = 'Create Purchase Requisition for Job Advertisment';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //Create a Purchase Requisition for Job Advertisement
                        //  EmployeeRecruitment.CreatePurchaseRequisitionForJobAdvertisement("No.");
                    end;
                }
                action("Publish Job Advertisement")
                {
                    Image = Web;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //Publish Job for Advertisement in the portal and Send Mail Notification to ICT To Publish Job on the website
                        Rec.TESTFIELD(Status, Rec.Status::Released);
                        EmployeeRecruitment.PublishJobAdvertisement(Rec."No.");
                        EmployeeRecruitment.SendEmailNotificationToICTOnPublishingJobAdvert(Rec."No.");
                        MESSAGE(Txt083);
                        CurrPage.CLOSE;
                    end;
                }
                separator(sep1)
                {
                }
                action("Drop Job Advertisement")
                {
                    Image = WorkCenterAbsencexcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //Drop Job from Advertisement in the portal
                        EmployeeRecruitment.DropJobAdvertisement(Rec."No.");
                        MESSAGE(Txt084);
                        CurrPage.CLOSE;
                    end;
                }
                action("Job Qualifications")
                {
                    Caption = 'Job Qualifications';
                    Image = BulletList;
                    Promoted = true;
                    PromotedCategory = Category5;
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
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "HR Job Requirements";
                    RunPageLink = "Job No." = FIELD("Job No.");
                    ToolTip = 'Job Requirements';
                    ApplicationArea = All;
                }
                action("Job Details Report")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRJobs.RESET;
                        HRJobs.SETRANGE("No.", Rec."Job No.");
                        IF HRJobs.FINDFIRST THEN BEGIN
                            //  REPORT.RUN(REPORT::"HR Job Details", TRUE, TRUE, HRJobs);
                        END;
                    end;
                }
                action("Job Responsibilities")
                {
                    Caption = 'Job Responsibilities';
                    Image = ResourceSkills;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page 50160;
                    RunPageLink = "Job No." = FIELD("Job No.");
                    ToolTip = 'Job Responsibilities';
                    ApplicationArea = All;
                }
                action("Job Applications")
                {
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    RunObject = Page 50167;
                    RunPageLink = "Employee Requisition No." = FIELD("No.");
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
                        IF Rec."Requisition Approved" = FALSE THEN BEGIN
                            Rec.TESTFIELD(Status, Rec.Status::Open);
                        END;
                        Rec.TESTFIELD("Requested Employees");


                        HRMandatoryDocChecklist.RESET;
                        HRMandatoryDocChecklist.SETRANGE(HRMandatoryDocChecklist."Document No.", Rec."No.");
                        IF HRMandatoryDocChecklist.FINDSET THEN BEGIN
                            REPEAT
                            UNTIL HRMandatoryDocChecklist.NEXT = 0;
                        END;

                        IF ApprovalsMgmtExt.CheckHREmployeeRequisitionApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendHREmployeeRequisitionForApproval(Rec);
                        CurrPage.CLOSE
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
                    /*       RunObject = Page "Approval Entries";
                           RunPageLink = "Document No." = FIELD("No.");*/
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund",Requisition,"Funds Transfer","HR Document";
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(RECORDID,DATABASE::"HR Employee Requisitions","No.");
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
                        // ApprovalsMgmtExt."OnCancelHREmployeeRequisitionApprovalRequest"(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                        CurrPage.CLOSE
                    end;
                }
            }
            group("Mandatory Documents")
            {
                Caption = 'Mandatory Documents';
            }
            action("HR Mandatory Document Checklist")
            {
                Caption = 'HR Mandatory Document Checklist';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page 50175;
                RunPageLink = "Document No." = FIELD("No.");
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
                    HRJobLookupValue.SETRANGE(HRJobLookupValue."Required Stage", HRJobLookupValue."Required Stage"::"Employee Requisition");
                    IF HRJobLookupValue.FINDSET THEN BEGIN
                        REPEAT
                            HRMandatoryDocChecklist.INIT;
                            HRMandatoryDocChecklist."Document No." := Rec."No.";
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
            group(Communication)
            {
                action("Email Invitation to Candidates")
                {
                    Caption = 'Send Email Invitation to Successfull Candidates';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //EmployeeRecruitment.SendInterviewShortlistedApplicantEmail("Job No.","No.","Interview Date","Interview Time","Interview Location");
                        CurrPage.CLOSE
                    end;
                }
                action("Regret Mail to Candidates")
                {
                    Caption = 'Send Regret Email to Unsuccessfull Applicants';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Regret Email Sent", FALSE);
                        EmployeeRecruitment.SendInterviewRejectedApplicantEmail(Rec."Job No.", Rec."No.");
                        Rec."Regret Email Sent" := TRUE;
                        REC.MODIFY;
                        CurrPage.CLOSE
                    end;
                }
                action("Close Requisition")
                {
                    Caption = 'Close Requisition';
                    Image = ClosePeriod;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Regret Email Sent", TRUE);
                        IF Rec."Regret Email Sent" = FALSE THEN
                            ERROR(ERROR_001);
                        EmployeeRecruitment.CloseEmployeeRequisition(Rec."No.");
                        CurrPage.CLOSE
                    end;
                }
                action("Shortlist Applicants")
                {
                    Caption = 'Shortlist Applicants';
                    Image = AddWatch;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        EmployeeRecruitment.ShortlistApplicants(Rec);
                        //CurrPage.CLOSE
                    end;
                }
                action("Job Application Report")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    //  RunObject = Report 50073;
                }
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
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            EmployeeContractCodeEditable := FALSE;
            RequisitionTypeEditable := FALSE;
            ClosingDateEditable := FALSE;
            InterviewDateEditable := FALSE;
            InterviewTimeEditable := FALSE;
            InterviewLocationEditable := FALSE;
        END;

        IF Rec.Status = Rec.Status::Released THEN BEGIN
            EmployeeContractCodeEditable := TRUE;
            RequisitionTypeEditable := TRUE;
            ClosingDateEditable := TRUE;
            InterviewDateEditable := TRUE;
            InterviewTimeEditable := TRUE;
            InterviewLocationEditable := TRUE;
        END;
    end;

    var
        ApproveRequisitionForJobApplication: Label 'Approve Employee Requisition Form %1 for Job Application?';
        ApproveRequisitionSuccessful: Label 'Employee Requisition Approved Successfully.';
        JobApplicantShortlisting: Label 'Job Applicant Shortlisting is Successful.';
        HRJobManagement: Codeunit 50032;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        EmployeeRecruitment: Codeunit 50033;
        HREmployeeRequisitions: Record 50098;
        //  PurchaseRequisitions: Record 50046;
        "Purchases&PayablesSetup": Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRJobApplications: Record 50099;
        EmployeeContractCodeEditable: Boolean;
        RequisitionTypeEditable: Boolean;
        ClosingDateEditable: Boolean;
        InterviewDateEditable: Boolean;
        InterviewTimeEditable: Boolean;
        InterviewLocationEditable: Boolean;
        //    PurchaseRequisitionLine: Record 50047;
        Txt080: Label 'Are you sure you want to Publish the Job Advertisement? Please note this will make the Job Advertisement to be visible on the portal for Applications.';
        Txt081: Label 'Are you sure you want to drop the Published Job Advertisement? Please note this will make the Job Advertisement not to be visible on the portal for Applications.';
        ERROR_001: Label 'You need send a regret Email to unsucessful Job applicants before closing the Employee requisition process. Please send a regret Email to unsuccessful candidates to Proceed with the Job Closing process.';
        HRJobs: Record 50093;
        Txt082: Label 'A purchase requisition has already been created';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        Txt083: Label 'Job succesfully published for advetisement on the portal and an E-mail has been sent to ICT department';
        Txt084: Label 'Job advertisement has succesfully been pulled down from the Job application portal';
        HRJobLookupValue: Record 50097;
        HRMandatoryDocChecklist: Record 50112;
        ERROR_002: Label 'Please Attach the Mandatory Documents required to proceed';
}


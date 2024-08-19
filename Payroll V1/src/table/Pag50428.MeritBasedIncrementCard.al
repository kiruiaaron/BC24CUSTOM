page 50428 "Merit Based Increment Card"
{
    PageType = Card;
    SourceTable = 50251;

    layout
    {
        area(content)
        {
            group("General- HOD")
            {
                Caption = 'General (By HOD)';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date of Last Increment"; Rec."Date of Last Increment")
                {
                    ApplicationArea = All;
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                }
                field("Current Designation"; Rec."Current Designation")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Active Years Of Service"; Rec."Active Years Of Service")
                {
                    ApplicationArea = All;
                }
                field("Avg Performance Appraisal"; Rec."Avg Performance Appraisal")
                {
                    Caption = 'Avg Performance Appraisal Score for the last 2 years';
                    ApplicationArea = All;
                }
            }
            /*   group("Academic /Professional Qualifications (By HOD & HRO)")
              {
                  Caption = 'Academic /Professional Qualifications (By HOD & HRO)';
                  part("Current Employee Qualifications"; 5206)
                  {
                      Caption = 'Current Employee Qualifications';
                      SubPageLink = "Employee No." = FIELD("Employee No.");
                      ApplicationArea = All;
                  }
                  part("Requirements for Proposed Job"; 50159)
                  {
                      Caption = 'Requirements for Proposed Job';
                      SubPageLink = "Job No." = FIELD("Proposed Designation");
                      ApplicationArea = All;
                  }
                  part("New Employee Qualifications"; 5206)
                  {
                      Caption = 'New Employee Qualifications';
                      SubPageLink = "Employee No." = FIELD("Employee No.");
                      ApplicationArea = All;
                  }
                  part("Registration With Professional Body"; 50192)
                  {
                      Caption = 'Registration With Professional Body';
                      SubPageLink = "Employee No." = FIELD("Employee No.");
                      ApplicationArea = All;
                  }
              }
              group("Relevant Experience (By HOD & HRO)")
              {
                  Caption = 'Relevant Experience (By HOD & HRO)';
                  //The GridLayout property is only supported on controls of type Grid
                  //GridLayout = Columns;
                  part(" Required Experience for Proposed Job"; 50159)
                  {
                      Caption = ' Required Experience for Proposed Job';
                      SubPageLink = "Job No." = FIELD("Proposed Designation");
                      ApplicationArea = All;
                  }
                  part("Employee Experience"; 50193)
                  {
                      Caption = 'Employee Experience';
                      SubPageLink = "Employee No." = FIELD("Employee No.");
                      ApplicationArea = All;
                  }
              } */
            group("Remuneration (By HRAM & MD)")
            {
                Caption = 'Remuneration (By HRAM & MD)';
                group("Current Level")
                {
                    Caption = 'Current Level';
                    field("Current Cadre"; Rec."Current Cadre")
                    {
                        ApplicationArea = All;
                    }
                    field("Current Job Grade"; Rec."Current Job Grade")
                    {
                        ApplicationArea = All;
                    }
                    field("Minimum Basic"; Rec."Minimum Basic")
                    {
                        ApplicationArea = All;
                    }
                    field("Maximum Basic"; Rec."Maximum Basic")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Current Remuneration")
                {
                    Caption = 'Current Remuneration';
                    field("Current Basic Pay"; Rec."Current Basic Pay")
                    {
                        ApplicationArea = All;
                    }
                    field("Current Salary Point"; Rec."Current Salary Point")
                    {
                        ApplicationArea = All;
                    }
                    field("Current House Allowance"; Rec."Current House Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Current Commuter Allowance"; Rec."Current Commuter Allowance")
                    {
                        ApplicationArea = All;
                    }
                    group("Other Allowance1")
                    {
                        Caption = 'Other Allowance';
                    }
                    field("Current Extraneous Allowance"; Rec."Current Extraneous Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Leave Training Allowance"; Rec."Leave Training Allowance")
                    {
                        Caption = 'Leave Travelling Allowance';
                        ApplicationArea = All;
                    }
                    group("Medical Cover1")
                    {
                        Caption = 'Medical Cover';
                        field("Medical Cover Inpatient"; Rec."Medical Cover Inpatient")
                        {
                            ApplicationArea = All;
                        }
                        field("Medical Cover Outpatient"; Rec."Medical Cover Outpatient")
                        {
                            ApplicationArea = All;
                        }
                        field("Club Membership"; Rec."Club Membership")
                        {
                            ApplicationArea = All;
                        }
                    }
                }
                group("Proposed Level")
                {
                    Caption = 'Proposed Level';
                    field("Proposed Cadre"; Rec."Proposed Cadre")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Job Grade"; Rec."Proposed Job Grade")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Minimum Basic"; Rec."Proposed Minimum Basic")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Maximum Basic"; Rec."Proposed Maximum Basic")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Proposed Remuneration")
                {
                    Caption = 'Proposed Remuneration';
                    field("Proposed Basic Pay"; Rec."Proposed Basic Pay")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Salary Point"; Rec."Proposed Salary Point")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed House Allowance"; Rec."Proposed House Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Commuter Allowance"; Rec."Proposed Commuter Allowance")
                    {
                        ApplicationArea = All;
                    }
                    group("Other Allowance")
                    {
                        Caption = 'Other Allowance';
                    }
                    field("Proposed Extraneous Allowance"; Rec."Proposed Extraneous Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Leave Travel Allowanc"; Rec."Proposed Leave Travel Allowanc")
                    {
                        ApplicationArea = All;
                    }
                    group("Medical Cover")
                    {
                        Caption = 'Medical Cover';
                        field("Proposed Inpatient"; Rec."Proposed Inpatient")
                        {
                            ApplicationArea = All;
                        }
                        field("Proposed Outpatient"; Rec."Proposed Outpatient")
                        {
                            ApplicationArea = All;
                        }
                        field("Proposed Club Membership"; Rec."Proposed Club Membership")
                        {
                            ApplicationArea = All;
                        }
                    }
                }
            }
            group("Subsistence (By HR & MD)")
            {
                Caption = 'Subsistence (By HR & MD)';
                group("Applicable Subsistence Allowance (Current)")
                {
                    Caption = 'Applicable Subsistence Allowance (Current)';
                    field("Current Breakfast Allowance"; Rec."Current Breakfast Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Current Lunch Allowance"; Rec."Current Lunch Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Current Dinner Allowance"; Rec."Current Dinner Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Current Per-Diem Allowance"; Rec."Current Per-Diem Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Current Out of the Pocket"; Rec."Current Out of the Pocket")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Applicable Subsistence Allowance (Proposed)")
                {
                    Caption = 'Applicable Subsistence Allowance (Proposed)';
                    field("Proposed Breakfast Allowance"; Rec."Proposed Breakfast Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Lunch Allowance"; Rec."Proposed Lunch Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Dinner Allowance"; Rec."Proposed Dinner Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Per-Diem Allowance"; Rec."Proposed Per-Diem Allowance")
                    {
                        ApplicationArea = All;
                    }
                    field("Proposed Out of the Pocket"; Rec."Proposed Out of the Pocket")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group("Expected Pay Computation Vis a Vis Staff Cost as A share of O & M")
            {
                Caption = 'Expected Pay Computation Vis a Vis Staff Cost as A share of O & M';
                field("Expected Pay Computation PM"; Rec."Expected Pay Computation PM")
                {
                    ApplicationArea = All;
                }
                field("Expected Pay Computation Pa"; Rec."Expected Pay Computation Pa")
                {
                    ApplicationArea = All;
                }
            }
            group("Remarks (By HOD)")
            {
                Caption = 'Remarks (By HOD)';
                field("Remarks By HOD"; Rec."Remarks By HOD")
                {
                    ApplicationArea = All;
                }
                field("HOD Name"; Rec."HOD Name")
                {
                    ApplicationArea = All;
                }
                field("HOD Designation"; Rec."HOD Designation")
                {
                    ApplicationArea = All;
                }
                field("HRM Signature"; Rec."HRM Signature")
                {
                    Caption = 'HOD Signature';
                    ApplicationArea = All;
                }
            }
            group("Remarks (By HRAM)")
            {
                Caption = 'Remarks (By HRAM)';
                field("Remarks by HRAM"; Rec."Remarks by HRAM")
                {
                    ApplicationArea = All;
                }
                field("HRAM Name"; Rec."HRAM Name")
                {
                    ApplicationArea = All;
                }
                field("HRAM Designation"; Rec."HRAM Designation")
                {
                    ApplicationArea = All;
                }
                field("HRAM Signature"; Rec."HRAM Signature")
                {
                    ApplicationArea = All;
                }
                field("HRAM Remarks Date"; Rec."HRAM Remarks Date")
                {
                    ApplicationArea = All;
                }
            }
            group("Approval/Remarks (By MD)")
            {
                Caption = 'Approval/Remarks (By MD)';
                field("Remarks By MD"; Rec."Remarks By MD")
                {
                    ApplicationArea = All;
                }
                field("Is Approved"; Rec."Is Approved")
                {
                    ApplicationArea = All;
                }
                field("MD Name"; Rec."MD Name")
                {
                    ApplicationArea = All;
                }
                field("MD Designation"; Rec."MD Designation")
                {
                    ApplicationArea = All;
                }
                field("MD Signature"; Rec."MD Signature")
                {
                    ApplicationArea = All;
                }
                field("MDs Remarks Date"; Rec."MDs Remarks Date")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
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
        /*  area(navigation)
         {
             action("Proposed Job  Requirements")
             {
                 Caption = 'Proposed Job  Requirements';
                 Image = Resource;
                 Promoted = true;
                 PromotedCategory = Category4;
                 RunObject = Page "HR Job Requirements";
                 RunPageLink = "Job No." = FIELD("Proposed Designation");
                 ApplicationArea = All;
             }
             action("Professional Qualifications for Proposed Job")
             {
                 Caption = 'Professional Qualifications for Proposed Job';
                 Image = QualificationOverview;
                 Promoted = true;
                 PromotedCategory = Category4;
                 RunObject = Page "HR Job Qualifications";
                 RunPageLink = "Job No." = FIELD("Proposed Designation");
                 ApplicationArea = All;
             }
             action("Current Academic Qualifications")
             {
                 Caption = 'Current Academic Qualifications';
                 Image = QualificationOverview;
                 Promoted = true;
                 PromotedCategory = Category4;
                 RunObject = Page "Employee Qualifications";
                 RunPageLink = "Employee No." = FIELD("Employee No.");
                 ApplicationArea = All;
             }
             action("Registration With Professional Bodyf")
             {
                 Caption = 'Registration With Professional Body';
                 Image = ProfileCalender;
                 Promoted = true;
                 PromotedCategory = Category4;
                 RunObject = Page 50192;
                 RunPageLink = "Employee No." = FIELD("Employee No.");
                 ApplicationArea = All;
             }
             action("Relevant Experience")
             {
                 Caption = 'Relevant Experience';
                 Image = TaskList;
                 Promoted = true;
                 PromotedCategory = Category4;
                 RunObject = Page 50193;
                 ApplicationArea = All;
             }
         } */
        area(processing)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(Approvals)
                {
                    AccessByPermission = TableData 454 = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    /*   RunObject = Page "Approval Entries";
                       RunPageLink = "Document Type" = CONST(Imprest),
                                     "Document No." = FIELD("No.");*/
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                    begin
                    end;
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                    //    ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                    begin
                        /*
                       Rec.TESTFIELD("Global Dimension 1 Code");
                       Rec.TESTFIELD(Status,Status::Open);
                        FundsManagement.CheckImprestMandatoryFields(Rec,FALSE);
                        
                        IF ApprovalsMgmtExt.CheckImprestApprovalsWorkflowEnabled(Rec) THEN
                          ApprovalsMgmtExt.OnSendImprestHeaderForApproval(Rec);
                        //"Cancelation Comments":='';
                        //MODIFY;
                        CurrPage.CLOSE;
                        */

                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                    /*   ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                      WorkflowWebhookMgt: Codeunit "Workflow Webhook Management"; */

                    begin
                        /*
                       Rec.TESTFIELD(Posted,FALSE);
                       Rec.TESTFIELD("Paid In Bank",FALSE);
                        ApprovalsMgmtExt.OnCancelImprestHeaderApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                        */

                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        // ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin
        //HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        //CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("No." <> '');

        /*OpenApprovalEntriesExistForCurrUser := ApprovalsMgmtExt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmtExt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmtExt.CanCancelApprovalForRecord(Rec.RECORDID);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);*/
    end;
}


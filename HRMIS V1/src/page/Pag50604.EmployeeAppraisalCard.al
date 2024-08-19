page 50604 "Employee Appraisal Card"
{
    PageType = Card;
    SourceTable = 50281;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Stage"; Rec."Appraisal Stage")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Level"; Rec."Appraisal Level")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Togglepages
                    end;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Appraisal Level");
                    end;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = All;
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    Caption = 'Period';
                    ApplicationArea = All;
                }
                field("Appraiser's No"; Rec."Reporting To")
                {
                    ApplicationArea = All;
                }
                field("Appraiser's Name"; Rec."Reporting To Name")
                {
                    ApplicationArea = All;
                }
                field("Appraiser's Designation"; Rec."Reporting To Designation")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Period Start"; Rec."Evaluation Period Start")
                {
                    Caption = 'Appraisal Start Period';
                    ApplicationArea = All;
                }
                field("Evaluation Period End"; Rec."Evaluation Period End")
                {
                    Caption = 'Appraisal End Period';
                    ApplicationArea = All;
                }
                field("Overall Purpose"; Rec."Overall Purpose")
                {
                    ApplicationArea = All;
                }
                field("Vision Statement"; Rec."Vision Statement")
                {
                    ApplicationArea = All;
                }
                field("Mission Statement"; Rec."Mission Statement")
                {
                    ApplicationArea = All;
                }
                group(Scores)
                {
                    field("Targeted Score"; Rec."Targeted Score")
                    {
                        ApplicationArea = All;
                    }
                    field("Achieved Score"; Rec."Achieved Score")
                    {
                        ApplicationArea = All;
                    }
                }
            }


            part("Responsibilities & Commitments"; 50543)
            {
                Caption = 'Responsibilities & Commitments';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Performance Criteria"; 50605)
            {
                Caption = 'Performance Criteria';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Performance Targets"; 50609)
            {
                Caption = 'Performance Targets';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Performance Indicators"; 50607)
            {
                Caption = 'Performance Indicators';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part(sbpg; 50641)
            {
                SubPageLink = "Appraisal No" = FIELD("No.");
                ApplicationArea = All;
            }
            group("Training Recommendations")
            {
                field(Recommendations; Rec.Recommendations)
                {
                    Caption = 'Training Recommendations';
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("HOD Approval"; Rec."HOD Approval")
                {
                    ApplicationArea = All;
                }
            }
            group("Information Flow freq")
            {
                Caption = 'Frequency of Monitoring Infomation Flow';
                field("Information Flow"; Rec."Information Flow")
                {
                    Caption = 'Information Flow Frequency';
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
            group(EmployeeRmks)
            {
                Caption = 'Employee Remarks';
                field("Employee Remarks"; Rec."Employee Remarks")
                {
                    ApplicationArea = All;
                }
            }
            group(Supervisor)
            {
                Caption = 'Appraiser Remarks';
                field("Supervisor Remarks"; Rec."Supervisor Remarks")
                {
                    Caption = 'Appraiser Remarks';
                    ApplicationArea = All;
                }
            }
            group(Hr)
            {
                Caption = 'HOD Remarks';
                field("HR Remarks"; Rec."HR Remarks")
                {
                    Caption = 'HOD  Remarks';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send To Supervisor")
            {
                Caption = 'Send To Supervisor';
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //IF CONFIRM (Txt060) =FALSE THEN EXIT;
                end;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // IF ApprovalsMgmtExt.CheckHREmployeeAppraisalHeaderApprovalsWorkflowEnabled(Rec) THEN
                    ApprovalsMgmtExt.OnSendHREmployeeAppraisalHeaderForApproval(Rec);
                end;
            }
            action(Close)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Released);
                    Rec.Status := Rec.Status::Closed;
                    Rec.MODIFY;
                end;
            }
            action(ReOpen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*IF CONFIRM(ReOpenLeaveApplication,FALSE,"No.") THEN BEGIN
                      Status:=Status::Open;
                      REC.MODIFY;
                    END;*/

                end;
            }
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
                RunObject = Page "Approval Entries";

                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    WorkflowsEntriesBuffer: Record 832;
                    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund",Requisition,"Funds Transfer","HR Document";
                begin
                    //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(RECORDID,DATABASE::"Training Needs App. Card","No.");
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                    ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                // WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                begin
                    ApprovalsMgmtExt.OnCancelHREmployeeAppraisalHeaderApprovalRequest(Rec);
                    //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                end;
            }
        }
        area(reporting)
        {
            action("Print Appraisal report")
            {
                Caption = 'Print Appraisal report';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*EmployeeAppraisalHeader.RESET;
                    EmployeeAppraisalHeader.SETRANGE(EmployeeAppraisalHeader."Appraisal Level",EmployeeAppraisalHeader."Appraisal Level"::Individual);
                    IF EmployeeAppraisalHeader.FINDFIRST THEN BEGIN
                    IndividualAppraisalLines.RESET;
                    IndividualAppraisalLines.SETRANGE(IndividualAppraisalLines."Appraisal No","No.");
                    IF IndividualAppraisalLines.FINDFIRST THEN
                      REPORT.RUNMODAL(REPORT::"HRIndividual Appraisal  Report",TRUE,FALSE,IndividualAppraisalLines);
                    END ELSE BEGIN
                      EmployeeAppraisalHeader.RESET;
                      EmployeeAppraisalHeader.SETRANGE(EmployeeAppraisalHeader."Appraisal Level",EmployeeAppraisalHeader."Appraisal Level"::Divisional);
                      IF EmployeeAppraisalHeader.FINDFIRST THEN BEGIN
                        DivisionalAppraisalLines.RESET;
                        DivisionalAppraisalLines.SETRANGE(DivisionalAppraisalLines."Appraisal No","No.");
                          IF DivisionalAppraisalLines.FINDFIRST THEN
                            REPORT.RUNMODAL(REPORT::"HR Division Appraisal  Report",TRUE,FALSE,DivisionalAppraisalLines);
                          END ELSE
                          BEGIN
                            EmployeeAppraisalHeader.RESET;
                            EmployeeAppraisalHeader.SETRANGE(EmployeeAppraisalHeader."Appraisal Level",EmployeeAppraisalHeader."Appraisal Level"::Organizational);
                            IF EmployeeAppraisalHeader.FINDFIRST THEN BEGIN
                              OrganizationAppraisalLines.RESET;
                              OrganizationAppraisalLines.SETRANGE(OrganizationAppraisalLines."Appraisal No.","No.");
                              IF OrganizationAppraisalLines.FINDFIRST THEN
                                REPORT.RUNMODAL(REPORT::"HR Org. Appraisal  Report",TRUE,FALSE,OrganizationAppraisalLines);
                              END
                              ELSE
                              BEGIN
                                EmployeeAppraisalHeader.RESET;
                                EmployeeAppraisalHeader.SETRANGE(EmployeeAppraisalHeader."Appraisal Level",EmployeeAppraisalHeader."Appraisal Level"::Departmental);
                                IF EmployeeAppraisalHeader.FINDFIRST THEN BEGIN
                                  DepartmentalAppraisalLines.RESET;
                                  DepartmentalAppraisalLines.SETRANGE(DepartmentalAppraisalLines."Appraisal No","No.");
                                  IF DepartmentalAppraisalLines.FINDFIRST THEN
                                    REPORT.RUNMODAL(REPORT::"HR Org. Appraisal  Report",TRUE,FALSE,DepartmentalAppraisalLines);
                              END;
                           END;
                        END;
                    END;
                    //Organizational
                    
                    
                    
                    {SETRANGE("No.","No.");
                    REPORT.RUN(REPORT::"HR Appraisal Report",TRUE,TRUE,Rec);}
                    */

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
        Togglepages
    end;

    trigger OnOpenPage()
    begin
        Togglepages
    end;

    var
        CMT: Boolean;
        NonCmt: Boolean;
        MGT: Boolean;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        EmployeeAppraisalHeader: Record 50281;

    local procedure Togglepages()
    begin
        IF rec."Appraisal Level" = Rec."Appraisal Level"::CMT THEN BEGIN
            CMT := TRUE;
            NonCmt := FALSE;
            MGT := FALSE
        END ELSE
            IF rec."Appraisal Level" = rec."Appraisal Level"::Management THEN BEGIN
                CMT := FALSE;
                NonCmt := TRUE;
                MGT := TRUE;
            END ELSE BEGIN
                CMT := FALSE;
                NonCmt := TRUE;
                MGT := FALSE
            END
    end;
}


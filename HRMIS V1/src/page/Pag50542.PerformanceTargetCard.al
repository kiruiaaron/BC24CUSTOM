page 50542 "Performance Target Card"
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
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        //TESTFIELD("Appraisal Level");
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
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    Caption = 'Period';
                    ApplicationArea = All;
                }
                field("Manager's No"; Rec."Reporting To")
                {
                    ApplicationArea = All;
                }
                field("Manager's Name"; Rec."Reporting To Name")
                {
                    ApplicationArea = All;
                }
                field("Manager's Designation"; Rec."Reporting To Designation")
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
            }
            part("Key Performance Indicators"; 50547)
            {
                Caption = 'Key Performance Indicators';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        CheckKPITarrgets(Rec."No.");
                        /*  IF ApprovalsMgmtExt.CheckHREmployeeAppraisalHeaderApprovalsWorkflowEnabled(Rec) THEN
                             ApprovalsMgmtExt.OnSendHREmployeeAppraisalHeaderForApproval(Rec); */
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
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
        }
        area(reporting)
        {
            action("Print Appraisal report")
            {
                Caption = 'Print Appraisal Targets report';
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
                    Rec.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(51202, TRUE, TRUE, Rec);

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

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
    end;

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
        AppraisalReport: Report 51203;
        CanCancelApprovalForRecord: Boolean;
        DocumentIsPosted: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;

    local procedure Togglepages()
    begin
        IF Rec."Appraisal Level" = Rec."Appraisal Level"::CMT THEN BEGIN
            CMT := TRUE;
            NonCmt := FALSE;
            MGT := FALSE
        END ELSE
            IF Rec."Appraisal Level" = Rec."Appraisal Level"::Management THEN BEGIN
                CMT := FALSE;
                NonCmt := TRUE;
                MGT := TRUE;
            END ELSE BEGIN
                CMT := FALSE;
                NonCmt := TRUE;
                MGT := FALSE
            END
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
    // WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin

        /*OpenApprovalEntriesExistForCurrUser := ApprovalsMgmtExt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmtExt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmtExt.CanCancelApprovalForRecord(Rec.RECORDID);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);*/
    end;

    local procedure CheckKPITarrgets(HeaderNo: Code[20])
    var
        AppraisalTargetsRec: Record 50288;
        AppraisalKPIRec: Record 50285;
    begin
        //loop through the appraisal KPIS
        AppraisalKPIRec.RESET;
        AppraisalKPIRec.SETRANGE("Header No", HeaderNo);
        IF AppraisalKPIRec.FINDFIRST THEN
            REPEAT
                AppraisalTargetsRec.RESET;
                AppraisalTargetsRec.SETRANGE("Header No", HeaderNo);
                AppraisalTargetsRec.SETRANGE("Criteria code", AppraisalKPIRec."Criteria code");
                IF AppraisalTargetsRec.ISEMPTY THEN
                    ERROR('Please fill in the appraisal targets for KPI %1', AppraisalKPIRec."Performance Criteria");

            UNTIL AppraisalKPIRec.NEXT = 0;
    end;
}


page 51250 "Employee Appraisal-Job"
{
    PageType = Card;
    SourceTable = 50281;
    SourceTableView = WHERE("Appraisal Stage" = CONST("Job Type"));

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
                field("Job No"; Rec."Job No")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        //INSERT(TRUE);
                    end;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Editable = false;
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
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //     IF ApprovalsMgmtExt.CheckHREmployeeAppraisalHeaderApprovalsWorkflowEnabled(Rec) THEN
                    ApprovalsMgmtExt.OnSendHREmployeeAppraisalHeaderForApproval(Rec);
                end;
            }
            action("Create Appraisal Targets")
            {
                Caption = 'Create Appraisal Targets';
                Image = CreateRating;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    HRAppraisalManagementCu: Codeunit 50041;
                begin
                    Rec.TESTFIELD("Job No");
                    CheckKPITarrgets(Rec."No.");

                    IF CONFIRM('Are you sure you want to Create Appraisal Targets for ' + Rec."Job Title" + ' Job?') THEN BEGIN
                        //   IF (HRAppraisalManagementCu.CreateEmployeeAppraisalsPerJob("Appraisal Period", "Job No")) THEN
                        MESSAGE('successfully created');
                    END;
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
                Visible = false;
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
                    AppraisalReportRpt.SETTABLEVIEW(Rec);
                    AppraisalReportRpt.RUN;

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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Appraisal Stage" := Rec."Appraisal Stage"::"Job Type";
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
        AppraisalReportRpt: Report 51202;

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


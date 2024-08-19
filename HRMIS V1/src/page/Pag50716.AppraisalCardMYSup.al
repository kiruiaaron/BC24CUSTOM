page 50716 "Appraisal Card-MY Sup"
{
    Caption = 'Employee Contract Card-MY Supervisor Scoring';
    DeleteAllowed = false;
    InsertAllowed = false;
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
                field("Employee Score Weightage"; Rec."Employee Score Weightage")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Supervisor Score Weightage"; Rec."Supervisor Score Weightage")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("OVerall Score Weightage"; Rec."OVerall Score Weightage")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Evaluation Period End"; Rec."Evaluation Period End")
                {
                    Caption = 'Appraisal End Period';
                    ApplicationArea = All;
                }
            }
            part("Key Performance Indicators"; 50717)
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
            action(Process)
            {
                Image = NewStatusChange;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM('Are you sure you want to move this appraisal to Next stage?') THEN BEGIN
                        AppraisalIndicatorsRec.RESET;
                        AppraisalIndicatorsRec.SETRANGE("Header No", Rec."No.");
                        AppraisalIndicatorsRec.SETFILTER("Specific Indicator", '<>%1', '');
                        IF AppraisalIndicatorsRec.FINDSET THEN
                            REPEAT
                                IF AppraisalIndicatorsRec."Achieved Score Supervisor" <= 0 THEN
                                    ERROR('Achieved Score must not be %1', AppraisalIndicatorsRec."Achieved Score Supervisor");

                            UNTIL AppraisalIndicatorsRec.NEXT = 0;
                        Rec."Appraisal Stage" := Rec."Appraisal Stage"::"Mid Year Evaluation Sup-Emp";
                        Rec.MODIFY;
                    END
                    ELSE
                        EXIT;
                end;
            }
            action("Calculate weights")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    type: Option Employee,Supervisor;
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Released);
                    //   IF HRAppraisalManagementCu.CalculateWeightResults("No.", type::Supervisor) THEN
                    MESSAGE('Weights calculated successfully');
                end;
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
        AppraisalReport: Report 51203;
        AppraisalIndicatorsRec: Record 50283;
        HRAppraisalManagementCu: Codeunit 50041;

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
}


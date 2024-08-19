page 50711 "Employee Appraisal-MY Appraisa"
{
    Caption = 'Employee Appraisal MY Card';
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
                field("Evaluation Period End"; Rec."Evaluation Period End")
                {
                    Caption = 'Appraisal End Period';
                    ApplicationArea = All;
                }
                field("Employee Score Weightage"; Rec."Employee Score Weightage")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Supervisor Score Weightage"; Rec."Supervisor Score Weightage")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("OVerall Score Weightage"; Rec."OVerall Score Weightage")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part("Key Performance Indicators"; 50713)
            {
                Caption = 'Key Performance Indicators';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            group("Your Reflections")
            {
                Caption = 'Your Reflections';
                part("Areas of Achievements/Strengths"; 50744)
                {
                    Caption = 'Areas of Achievements/Strengths';
                    SubPageLink = "Header No" = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Developmental Areas"; 50745)
                {
                    Caption = 'Developmental Areas';
                    SubPageLink = "Header No" = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Specific Focus Areas for Next Quarter"; 50746)
                {
                    Caption = 'Specific Focus Areas for Next Quarter';
                    SubPageLink = "Header No" = FIELD("No.");
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
                Visible = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    AppraisalIndicatorsRec: Record 50283;
                    AppraisalAreaofAchivement: Record 50320;
                    AppraisalAreaofDevelopment: Record 50321;
                    AppraisalSpecificFocusArea: Record 50322;
                begin

                    Rec.TESTFIELD("Reporting To");
                    TestFieldsEmpty(Rec."No.");
                    IF CONFIRM(Txt060) = FALSE THEN
                        EXIT
                    ELSE BEGIN
                        Rec."Appraisal Stage" := Rec."Appraisal Stage"::"Mid Year Evaluation Sup";
                        Rec.MODIFY;
                        MESSAGE('Successfully sent');
                    END;
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
                    type: Option Employee,Supervisor,"Emp-Sup";
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Released);
                    //IF HRAppraisalManagementCu.CalculateWeightResults("No.", type::Employee) THEN
                    MESSAGE('Weights calculated successfully');
                end;
            }
        }
        area(reporting)
        {
            action("Print Appraisal report")
            {
                Caption = 'Print Mid Year Appraisal report';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
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
        Txt060: Label 'Are you sure you want to send this evaluation to your supervisor?';
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

    local procedure TestFieldsEmpty(HeaderNo: Code[20])
    var
        AppraisalAreaofAchivement: Record 50320;
        AppraisalAreaofDevelopment: Record 50321;
        AppraisalSpecificFocusArea: Record 50322;
        AppraisalIndicatorsRec: Record 50283;
    begin
        //
        AppraisalIndicatorsRec.RESET;
        AppraisalIndicatorsRec.SETRANGE("Header No", HeaderNo);
        AppraisalIndicatorsRec.SETFILTER("Specific Indicator", '<>%1', '');
        IF AppraisalIndicatorsRec.FINDSET THEN
            REPEAT
                IF AppraisalIndicatorsRec."Achieved Score Employee" <= 0 THEN
                    ERROR('Achieved Score must not be %1', AppraisalIndicatorsRec."Achieved Score Employee");

            UNTIL AppraisalIndicatorsRec.NEXT = 0;

        //Area of development
        AppraisalAreaofDevelopment.RESET;
        AppraisalAreaofDevelopment.SETRANGE("Header No", HeaderNo);
        IF AppraisalAreaofDevelopment.ISEMPTY THEN
            ERROR('Please fill area of development!');
        //specific area of focus next quarter
        AppraisalSpecificFocusArea.RESET;
        AppraisalSpecificFocusArea.SETRANGE("Header No", HeaderNo);
        IF AppraisalSpecificFocusArea.ISEMPTY THEN
            ERROR('Please fill area of focus for next quarter');

        //AppraisalAreaofAchivement
        AppraisalAreaofAchivement.RESET;
        AppraisalAreaofAchivement.SETRANGE("Header No", HeaderNo);
        IF AppraisalAreaofAchivement.ISEMPTY THEN
            ERROR('Please fill area of achievement');
    end;
}


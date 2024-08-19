page 50618 "Intern Appraisal Card"
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
                    Caption = 'Intern No';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Caption = 'Intern Name';
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
                field("Appraisers No"; Rec."Reporting To")
                {
                    Caption = 'Supervisor''s No';
                    ApplicationArea = All;
                }
                field("Appraisers Name"; Rec."Reporting To Name")
                {
                    Caption = 'Supervisor''s Name';
                    ApplicationArea = All;
                }
                field("Appraisers Designation"; Rec."Reporting To Designation")
                {
                    Caption = 'Supervisor''s Designation';
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
                    field("Achieved Score"; Rec."Achieved Score")
                    {
                        ApplicationArea = All;
                    }
                    field(Rating; Rec.Rating)
                    {
                        ApplicationArea = All;
                    }
                }
            }
            part("Intern Criteria"; 50619)
            {
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Key Performance Indicators"; 50620)
            {
                Caption = 'Key Performance Indicators';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Appraisal Ratings"; 50621)
            {
                ApplicationArea = All;
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
    }

    trigger OnAfterGetRecord()
    begin
        Togglepages
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Appraisal Stage" := Rec."Appraisal Stage"::Internship;
    end;

    trigger OnOpenPage()
    begin
        Togglepages
    end;

    var
        CMT: Boolean;
        NonCmt: Boolean;
        MGT: Boolean;

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


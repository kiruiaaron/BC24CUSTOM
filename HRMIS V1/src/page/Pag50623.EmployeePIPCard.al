page 50623 "Employee PIP Card"
{
    PageType = Card;
    SourceTable = 50290;

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
                field("Appraisal Level"; Rec."Appraisal Level")
                {
                    ApplicationArea = All;
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
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field(Section; Rec.Section)
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
                field("Supervisor's No"; Rec."Reporting To")
                {
                    ApplicationArea = All;
                }
                field("Supervisor's Name"; Rec."Reporting To Name")
                {
                    ApplicationArea = All;
                }
                field("Supervisor's Designation"; Rec."Reporting To Designation")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Period Start"; Rec."Evaluation Period Start")
                {
                    Caption = 'Start Period';
                    ApplicationArea = All;
                }
                field("Evaluation Period End"; Rec."Evaluation Period End")
                {
                    Caption = 'End Period';
                    ApplicationArea = All;
                }
            }
            part(sbpg1; 50624)
            {
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Improvement Goals"; 50626)
            {
                Caption = 'Improvement Goals';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Goals Activities"; 50625)
            {
                Caption = 'Goals Activities';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("PIP Resources"; 50627)
            {
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Progress monitoring"; 50629)
            {
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            group("Training Recommendations")
            {
                Caption = ' Recommendations';
                field(Recommendations; Rec.Recommendations)
                {
                    Caption = 'Recommendations';
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
                Caption = 'Supervisor Remarks';
                field("Supervisor Remarks"; Rec."Supervisor Remarks")
                {
                    Caption = 'Supervisor Remarks';
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


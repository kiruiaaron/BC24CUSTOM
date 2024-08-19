page 50616 "Sections Targets  Card"
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
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Organization Name"; Rec.Description)
                {
                    Caption = 'Section';
                    ApplicationArea = All;
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    Caption = 'Period';
                    ApplicationArea = All;
                }
                field("Evaluation Period Start"; Rec."Evaluation Period Start")
                {
                    Caption = 'Target Start Period';
                    ApplicationArea = All;
                }
                field("Evaluation Period End"; Rec."Evaluation Period End")
                {
                    Caption = 'TargetEnd Period';
                    ApplicationArea = All;
                }
                field("Overall Purpose"; Rec."Overall Purpose")
                {
                    Caption = 'Scope';
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
                field("Core Mandate"; Rec."Core Mandate")
                {
                    Caption = 'Core Values';
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
            part("Performance Target Matrix"; 50547)
            {
                Caption = 'Performance Target Matrix';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Performance Targets"; 50551)
            {
                Caption = 'Performance Targets';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Performance Indicators"; 50544)
            {
                Caption = 'Performance Indicators';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Performance Target Notes"; 50549)
            {
                Caption = 'Performance Target Notes';
                SubPageLink = "Header No" = FIELD("No.");
                ApplicationArea = All;
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
        Rec."Appraisal Stage" := Rec."Appraisal Stage"::Section;
    end;

    trigger OnOpenPage()
    begin
        Togglepages
    end;

    var
        Org: Boolean;
        Dept: Boolean;
        Sec: Boolean;

    local procedure Togglepages()
    begin
        /*IF "Appraisal Level"="Appraisal Level"::CMT THEN BEGIN
          CMT:=TRUE;
          NonCmt:=FALSE;
          MGT:=FALSE
        END ELSE
        IF "Appraisal Level"="Appraisal Level"::Management    THEN BEGIN
          CMT:=FALSE;
          NonCmt:=TRUE;
          MGT:=TRUE;
        END ELSE BEGIN
            CMT:=FALSE;
          NonCmt:=TRUE;
          MGT:=FALSE
        END */

    end;
}


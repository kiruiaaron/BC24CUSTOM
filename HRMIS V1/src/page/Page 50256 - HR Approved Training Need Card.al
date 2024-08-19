page 50256 "HR Approved Training Need Card"
{
    Caption = 'HR Approved Training Needs Card';
    PageType = Card;
    SourceTable = 50159;

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Calendar Year"; Rec."Calendar Year")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50257)
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Insert Proposed Trainings")
            {
                Caption = 'Insert Proposed Trainings for Employees';
                Image = Hierarchy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRTrainingManagement.InsertProposedTrainingForEmployees(Rec."Calendar Year", Rec."No.");
                end;
            }
            action("Approved Training Report")
            {
                Caption = 'Management Approved Training Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;
            }
        }
    }

    var
        HRTrainingNeedsLine: Record 50158;
        HRTrainingNeedsHeader: Record 50157;
        HRTrainingManagement: Codeunit 50042;
        ApprovedTrainingNeedsLine: Record 50160;
}


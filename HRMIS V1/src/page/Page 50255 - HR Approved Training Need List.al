page 50255 "HR Approved Training Need List"
{
    Caption = 'HR Approved Training Needs List';
    CardPageID = "HR Approved Training Need Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50159;

    layout
    {
        area(content)
        {
            repeater(General)
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
        }
    }

    actions
    {
        area(processing)
        {
            action("Approved Training Report")
            {
                Caption = 'Management Approved Training Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ApprovedTrainingNeedsLine.RESET;
                    ApprovedTrainingNeedsLine.SETRANGE(ApprovedTrainingNeedsLine."No.", Rec."No.");
                    IF ApprovedTrainingNeedsLine.FINDFIRST THEN BEGIN
                        //  REPORT.RUNMODAL(REPORT::"Approved Training Needs report", TRUE, FALSE, ApprovedTrainingNeedsLine);
                    END;
                end;
            }
        }
    }

    var
        ApprovedTrainingNeedsLine: Record 50160;
}


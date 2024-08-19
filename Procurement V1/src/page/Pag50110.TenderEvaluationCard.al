page 50110 "Tender Evaluation Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 50058;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Evaluation No."; Rec."Evaluation No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Tender No."; Rec."Tender No.")
                {
                    ApplicationArea = All;
                }
                field("Tender Date"; Rec."Tender Date")
                {
                    ApplicationArea = All;
                }
                field("Tender Close Date"; Rec."Tender Close Date")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Date"; Rec."Evaluation Date")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Criteria"; Rec."Evaluation Criteria")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50111)
            {
                SubPageLink = "Document No." = FIELD("Evaluation No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Submit)
            {
                Caption = 'Submit';
                Image = Migration;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Status = Rec.Status::Submitted THEN ERROR(AlreadySubmitted);

                    IF CONFIRM(Txt060) = FALSE THEN EXIT;

                    Rec.Status := Rec.Status::Submitted;
                    Rec.MODIFY;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Rec.Status = Rec.Status::Submitted THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        Txt060: Label 'Are you sure you want to submit this record?';
        AlreadySubmitted: Label 'Current record has already been submitted.';
}


page 50265 "Disciplinary Case Card"
{
    PageType = Card;
    SourceTable = 50166;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Case Number"; Rec."Case Number")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Type of Disciplinary Case"; Rec."Type of Disciplinary Case")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Case Description"; Rec."Case Description")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Accuser Name"; Rec."Accuser Name")
                {
                    ApplicationArea = All;
                }
                field("Witness #1"; Rec."Witness #1")
                {
                    ApplicationArea = All;
                }
                field("Witness #2"; Rec."Witness #2")
                {
                    ApplicationArea = All;
                }
                field("Action Taken"; Rec."Action Taken")
                {
                    ApplicationArea = All;
                }
                field("Disciplinary Remarks"; Rec."Disciplinary Remarks")
                {
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                }
                field(Recomendations; Rec.Recomendations)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Closed By"; Rec."Closed By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Closed Date"; Rec."Closed Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Close Case")
            {
                Caption = 'Close Case';
                Image = CloseYear;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt060) = FALSE THEN EXIT;
                    Rec.Status := Rec.Status::Closed;
                    Rec."Closed By" := USERID;
                    Rec."Closed Date" := TODAY;
                    Rec.MODIFY;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Rec.Status = Rec.Status::Closed THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        Txt060: Label 'Close Case?';
}


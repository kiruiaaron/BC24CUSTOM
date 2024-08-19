page 50315 "Contract Request Card"
{
    PageType = Card;
    SourceTable = 50208;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Contract Link"; Rec."Contract Link")
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
                field(Description; Rec.Description)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Legal Comments"; Rec."Legal Comments")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Contract Subject"; Rec."Contract Subject")
                {
                    ApplicationArea = All;
                }
                field("Contract Subject Name"; Rec."Contract Subject Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Close Request")
            {
                Caption = 'Close Request';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt060) = FALSE THEN EXIT;
                    Rec.Status := Rec.Status::Closed;
                    Rec.MODIFY;
                    MESSAGE(Txt061);
                    CurrPage.CLOSE;
                end;
            }
            action("Re-Open Request")
            {
                Caption = 'Re-Open Request';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt062) = FALSE THEN EXIT;
                    Rec.Status := Rec.Status::Open;
                    Rec.MODIFY;
                    MESSAGE(Txt063);
                    CurrPage.CLOSE;
                end;
            }
            action("Send to Legal")
            {
                Caption = 'Send to Legal';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM(Txt064) = FALSE THEN EXIT;
                    Rec.Status := Rec.Status::"Under Legal";
                    Rec.MODIFY;
                    MESSAGE(Txt065);
                    CurrPage.CLOSE;
                end;
            }
            action("Tender Details")
            {
                Image = TaskQualityMeasure;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                // RunObject = Page 52137046;
                //  RunPageLink = Field10 = FIELD(Contract Link);
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Rec.Status = Rec.Status::Closed THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        Txt060: Label 'Close Contract Request?';
        Txt061: Label 'Contract Request Closed';
        Txt062: Label 'Re-Open Request?';
        Txt063: Label 'Contract Request Re-Opened';
        Txt064: Label 'Send to Legal?';
        Txt065: Label 'Contract Request sent to Legal';
}


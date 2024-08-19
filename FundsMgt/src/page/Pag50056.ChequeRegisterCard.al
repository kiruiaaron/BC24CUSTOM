page 50056 "Cheque Register Card"
{
    PageType = Card;
    SourceTable = 50024;

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
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                }
                field("Last Cheque No."; Rec."Last Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Cheque Book Number"; Rec."Cheque Book Number")
                {
                    ApplicationArea = All;
                }
                field("No of Leaves"; Rec."No of Leaves")
                {
                    ApplicationArea = All;
                }
                field("Cheque Number From"; Rec."Cheque Number From")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Cheque Number To."; Rec."Cheque Number To.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50014)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Generate Cheque Numbers")
            {
                Image = Interaction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Cheque Number From");
                    Rec.TESTFIELD("Cheque Number To.");

                    IF Rec."Cheque Number To." < Rec."Cheque Number To." THEN
                        ERROR(Error101);



                    IncrNo := Rec."Cheque Number From";

                    WHILE IncrNo <= Rec."Cheque Number To." DO BEGIN

                        ChequeRegisterLines.INIT;
                        ChequeRegisterLines."Document No." := Rec."No.";
                        ChequeRegisterLines."Cheque No." := IncrNo;
                        ChequeRegisterLines."Bank  Account No." := Rec."Bank Account";
                        ChequeRegisterLines.INSERT;

                        IncrNo := INCSTR(IncrNo);
                    END;
                end;
            }
            action("Cheque Register Lines")
            {
                Image = AvailableToPromise;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50057;
                RunPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Authorize Cheque Register")
            {
                Image = AutofillQtyToHandle;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Open);
                    Rec.Status := Rec.Status::Approved;
                    Rec.MODIFY;

                    ChequeRegisterLines.RESET;
                    ChequeRegisterLines.SETRANGE(ChequeRegisterLines."Document No.", Rec."No.");
                    IF ChequeRegisterLines.FINDSET THEN BEGIN
                        REPEAT
                            ChequeRegisterLines.Status := Rec.Status;
                            ChequeRegisterLines.MODIFY;
                        UNTIL ChequeRegisterLines.NEXT = 0;
                    END;

                    MESSAGE(ChequesAuthorized);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Rec.Status = Rec.Status::Approved THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        ChequesAuthorized: Label 'Cheque register successfully authorized for use';
        Error101: Label 'Beginning number is more than ending number';
        IncrNo: Code[10];
        ChequeRegisterLines: Record 50025;
}


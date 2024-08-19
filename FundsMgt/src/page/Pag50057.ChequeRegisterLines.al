page 50057 "Cheque Register Lines"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = 50025;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Payee No"; Rec."Payee No")
                {
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                }
                field("PV No"; Rec."PV No")
                {
                    ApplicationArea = All;
                }
                field("PV Description"; Rec."PV Description")
                {
                    ApplicationArea = All;
                }
                field("PV Prepared By"; Rec."PV Prepared By")
                {
                    ApplicationArea = All;
                }
                field("Cheque Cancelled"; Rec."Cheque Cancelled")
                {
                    ApplicationArea = All;
                }
                field("Cancelled By"; Rec."Cancelled By")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


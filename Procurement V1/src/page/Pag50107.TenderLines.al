page 50107 "Tender Lines"
{
    PageType = ListPart;
    SourceTable = 50056;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Supplier No."; Rec."Supplier No.")
                {
                    ApplicationArea = All;
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ApplicationArea = All;
                }
                field("Bid Amount"; Rec."Bid Amount")
                {
                    ApplicationArea = All;
                }
                field(Disqualified; Rec.Disqualified)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Reason for Disqualification"; Rec."Reason for Disqualification")
                {
                    ApplicationArea = All;
                }
                field("Disqualification point"; Rec."Disqualification point")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


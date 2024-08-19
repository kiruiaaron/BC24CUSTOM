page 50100 "Vendor Directors Details"
{
    PageType = ListPart;
    SourceTable = 50065;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Director Name"; Rec."Director Name")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("ID/Passport No."; Rec."ID/Passport No.")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field("If Other, Nationality"; Rec."If Other, Nationality")
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


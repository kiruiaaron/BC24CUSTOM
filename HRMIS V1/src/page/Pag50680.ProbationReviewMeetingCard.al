page 50680 "Probation Review Meeting Card"
{
    PageType = Card;
    SourceTable = 50329;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Review No."; Rec."Review No.")
                {
                    ApplicationArea = All;
                }
                field("Meeting Date"; Rec."Meeting Date")
                {
                    ApplicationArea = All;
                }
                field("Meeting Chairperson"; Rec."Meeting Chairperson")
                {
                    ApplicationArea = All;
                }
                field("Meeting Chairperson Name"; Rec."Meeting Chairperson Name")
                {
                    ApplicationArea = All;
                }
            }
            part("Probation Review Meeting Objectives"; 50681)
            {
                Caption = 'Probation Review Meeting Objectives';
                SubPageLink = "Review No" = FIELD("Review No.");
                ApplicationArea = All;
            }
            part(sbpg; 50682)
            {
                SubPageLink = "Review No" = FIELD("Review No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}


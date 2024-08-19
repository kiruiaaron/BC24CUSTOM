page 50520 "Incoming Company Mails ES"
{
    CardPageID = "Incoming Mail Card ES";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50263;
    SourceTableView = WHERE("Mail Direction" = CONST(Incoming),
                            Stage = CONST(ES));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Sender Details"; Rec."Sender Details")
                {
                    ApplicationArea = All;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                }
                field("Letter Description"; Rec."Letter Description")
                {
                    ApplicationArea = All;
                }
                field("MD Comments/Instructions"; Rec."MD Comments/Instructions")
                {
                    ApplicationArea = All;
                }
                field("Forwarded For action To"; Rec."Forwarded For action To")
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


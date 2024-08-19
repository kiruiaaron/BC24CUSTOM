page 50522 "Incoming Company Mails Staff"
{
    CardPageID = "Incoming Mail Card Staff";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50263;
    SourceTableView = WHERE("Mail Direction" = CONST(Incoming),
                            Stage = CONST(Staff));

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


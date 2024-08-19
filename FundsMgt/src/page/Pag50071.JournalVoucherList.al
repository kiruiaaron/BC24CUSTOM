page 50071 "Journal Voucher List"
{
    CardPageID = "Journal Voucher";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50016;
    SourceTableView = WHERE(Status = CONST(Open));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("JV No."; Rec."JV No.")
                {
                    ApplicationArea = All;
                }
                field("Document date"; Rec."Document date")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
            }
        }
    }


}


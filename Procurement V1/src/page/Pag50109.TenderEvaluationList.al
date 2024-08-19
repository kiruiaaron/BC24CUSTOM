page 50109 "Tender Evaluation List"
{
    CardPageID = "Tender Evaluation Card";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50058;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Evaluation No."; Rec."Evaluation No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Tender No."; Rec."Tender No.")
                {
                    ApplicationArea = All;
                }
                field("Tender Date"; Rec."Tender Date")
                {
                    ApplicationArea = All;
                }
                field("Evaluation Date"; Rec."Evaluation Date")
                {
                    ApplicationArea = All;
                }
                field("Tender Close Date"; Rec."Tender Close Date")
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


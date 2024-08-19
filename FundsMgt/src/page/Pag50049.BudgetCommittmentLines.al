page 50049 "Budget Committment Lines"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50019;

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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Month Budget"; Rec."Month Budget")
                {
                    ApplicationArea = All;
                }
                field("Month Actual"; Rec."Month Actual")
                {
                    ApplicationArea = All;
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = All;
                }
                field("Committed By"; Rec."Committed By")
                {
                    ApplicationArea = All;
                }
                field("Committed Date"; Rec."Committed Date")
                {
                    ApplicationArea = All;
                }
                field("Committed Time"; Rec."Committed Time")
                {
                    ApplicationArea = All;
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = All;
                }
                field("Cancelled By"; Rec."Cancelled By")
                {
                    ApplicationArea = All;
                }
                field("Cancelled Date"; Rec."Cancelled Date")
                {
                    ApplicationArea = All;
                }
                field("Cancelled Time"; Rec."Cancelled Time")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field(Budget; Rec.Budget)
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


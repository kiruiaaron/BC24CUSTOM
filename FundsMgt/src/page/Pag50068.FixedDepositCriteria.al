page 50068 "Fixed Deposit Criteria"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50039;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field("On Call Interest Rate"; Rec."On Call Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("No of Months"; Rec."No of Months")
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


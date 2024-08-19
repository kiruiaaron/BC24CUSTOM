page 50629 "Progress Monitoring"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50295;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date Scheduled"; Rec."Date Scheduled")
                {
                    ApplicationArea = All;
                }
                field(Activity; Rec.Activity)
                {
                    ApplicationArea = All;
                }
                field("Conducted By"; Rec."Conducted By")
                {
                    ApplicationArea = All;
                }
                field("Date Completed"; Rec."Date Completed")
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


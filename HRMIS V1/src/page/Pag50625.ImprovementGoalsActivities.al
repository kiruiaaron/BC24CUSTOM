page 50625 "Improvement Goals Activities"
{
    PageType = ListPart;
    SourceTable = 50293;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Goal; Rec.Goal)
                {
                    ApplicationArea = All;
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;
                }
                field(Activity; Rec.Activity)
                {
                    Caption = 'Activity';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("Projected date of Completion"; Rec."Projected date of Completion")
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


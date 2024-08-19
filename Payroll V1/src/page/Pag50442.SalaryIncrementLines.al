page 50442 "Salary Increment Lines"
{
    PageType = ListPart;
    SourceTable = 50253;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = All;
                }
                field("Ed Code"; Rec."Ed Code")
                {
                    ApplicationArea = All;
                }
                field("Employee name"; Rec."Employee name")
                {
                    ApplicationArea = All;
                }
                field("Ed Definition"; Rec."Ed Definition")
                {
                    ApplicationArea = All;
                }
                field("Current Amount"; Rec."Current Amount")
                {
                    ApplicationArea = All;
                }
                field("Increment Value"; Rec."Increment Value")
                {
                    ApplicationArea = All;
                }
                field("Proposed Amount"; Rec."Proposed Amount")
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


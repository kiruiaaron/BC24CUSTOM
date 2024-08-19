page 50159 "HR Job Requirements"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50095;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the Job Number.';
                    ApplicationArea = All;
                }
                field("Requirement Code"; Rec."Requirement Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description for the requirement code.';
                    ApplicationArea = All;
                }
                field("No. of Years"; Rec."No. of Years")
                {
                    ApplicationArea = All;
                }
                field(Mandatory; Rec.Mandatory)
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


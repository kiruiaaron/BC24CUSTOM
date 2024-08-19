page 50158 "HR Job Qualifications"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50094;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ToolTip = 'Specifies the Qualification code.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ToolTip = 'Specifies if a qualification is mandatory.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


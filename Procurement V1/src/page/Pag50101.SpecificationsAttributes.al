page 50101 "Specifications Attributes"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50061;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Specification; Rec.Specification)
                {
                    ApplicationArea = All;
                }
                field(Requirement; Rec.Requirement)
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


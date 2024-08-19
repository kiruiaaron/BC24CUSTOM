page 50681 "Probation Review Meeting Objs"
{
    Caption = 'Probation Review Meeting Objectives';
    PageType = ListPart;
    SourceTable = 50330;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Objective; Rec.Objective)
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


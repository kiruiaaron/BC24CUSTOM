page 50182 "Interview Header List"
{
    CardPageID = "Interview Header Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50108;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Interview No"; Rec."Interview No")
                {
                    ApplicationArea = All;
                }
                field("Interview Committee code"; Rec."Interview Committee code")
                {
                    ApplicationArea = All;
                }
                field("Interview Committee Name"; Rec."Interview Committee Name")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}


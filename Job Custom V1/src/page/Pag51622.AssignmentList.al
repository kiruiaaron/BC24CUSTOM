page 51622 "Assignment List"
{
    CardPageID = "Assignment Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Project Assignment Header";
    SourceTableView = WHERE(Deployed = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Assignment Number"; Rec."Assignment Number")
                {
                }
                field(Project; Rec.Project)
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Task No"; Rec."Task No")
                {
                }
                field("Task Description"; Rec."Task Description")
                {
                }
                field("Created On"; Rec."Created On")
                {
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Created By", UserId);
    end;
}


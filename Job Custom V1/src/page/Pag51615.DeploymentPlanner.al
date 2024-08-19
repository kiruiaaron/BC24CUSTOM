page 51615 "Deployment Planner"
{
    CardPageID = "Deployment Planner Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Deployment Header";
    SourceTableView = WHERE(Status = FILTER(<> approved),
                            Deployment = FILTER(true),
                            "Payment Schedule" = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    Editable = false;
                }
                field("B A Category"; Rec."B A Category")
                {
                }
                field("B A Category Name"; Rec."B A Category Name")
                {
                    Editable = false;
                }
                field(Project; Rec.Project)
                {
                    Editable = false;
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = false;
                }
                field("Task No"; Rec."Task No")
                {
                    Editable = false;
                }
                field("Task Description"; Rec."Task Description")
                {
                    Editable = false;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Total; Rec.Total)
                {
                    Editable = false;
                }
                field("Total Number of Days"; Rec."Total Number of Days")
                {
                }
                field("Total Actual No of Days"; Rec."Total Actual No of Days")
                {
                }
                field("Total Actual Amount"; Rec."Total Actual Amount")
                {
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


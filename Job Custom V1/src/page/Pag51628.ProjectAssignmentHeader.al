page 51628 "Project Assignment Header"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Project Assignment Header";

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
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("BA Category"; Rec."BA Category")
                {
                }
                field("BA Category Description"; Rec."BA Category Description")
                {
                }
                field("Region Code"; Rec."Region Code")
                {
                }
                field(Week; Rec.Week)
                {
                }
                field("No. of Brand Ambassadors"; Rec."No. of Brand Ambassadors")
                {
                }
                field("No. of Team Leaders"; Rec."No. of Team Leaders")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Resources to assign"; Rec."Resources to assign")
                {
                }
                field("Quoted Resources"; Rec."Quoted Resources")
                {
                }
                field("Resources Already Deployed"; Rec."Resources Already Deployed")
                {
                }
                field(Deployed; Rec.Deployed)
                {
                }
                field("Date Deployed"; Rec."Date Deployed")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Time Deployed"; Rec."Time Deployed")
                {
                }
                field("Deployed By"; Rec."Deployed By")
                {
                }
            }
        }
    }

    actions
    {
    }
}


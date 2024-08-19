page 50175 "HR Checklist Documents"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50112;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Mandatory Doc. Code"; Rec."Mandatory Doc. Code")
                {
                    ApplicationArea = All;
                }
                field("Document Attached"; Rec."Document Attached")
                {
                    ApplicationArea = All;
                }
                field("Mandatory Doc. Description"; Rec."Mandatory Doc. Description")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = true;
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}


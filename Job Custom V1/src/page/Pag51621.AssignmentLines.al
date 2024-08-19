page 51621 "Assignment Lines"
{
    PageType = ListPart;
    SourceTable = "Assignment Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("BA Code"; Rec."BA Code")
                {
                    Style = Strong;
                    StyleExpr = strong;
                }
                field("BA Name"; Rec."BA Name")
                {
                    Style = Strong;
                    StyleExpr = strong;
                }
                field("Daily Rate"; Rec."Daily Rate")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = strong;
                }
                field("Team Leader"; Rec."Team Leader")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = strong;
                }
                field(Select; Rec.Select)
                {
                }
                field("Phone Number"; Rec."Phone Number")
                {
                }
                field("ID Number"; Rec."ID Number")
                {
                }
                field("Subcontract Type"; Rec."Subcontract Type")
                {
                }
                field("Task No"; Rec."Task No")
                {
                }
                field("Task Description"; Rec."Task Description")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        strong := Rec."Team Leader" = true;
    end;

    var
        strong: Boolean;
}


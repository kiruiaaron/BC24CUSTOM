page 50264 "Disciplinary Case"
{
    CardPageID = "Disciplinary Case Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50166;
    SourceTableView = WHERE(Status = CONST(Open));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Case Number"; Rec."Case Number")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Type of Disciplinary Case"; Rec."Type of Disciplinary Case")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Case Description"; Rec."Case Description")
                {
                    ApplicationArea = All;
                }
                field("Accuser Name"; Rec."Accuser Name")
                {
                    ApplicationArea = All;
                }
                field("Witness #1"; Rec."Witness #1")
                {
                    ApplicationArea = All;
                }
                field("Witness #2"; Rec."Witness #2")
                {
                    ApplicationArea = All;
                }
                field("Action Taken"; Rec."Action Taken")
                {
                    ApplicationArea = All;
                }
                field("Disciplinary Remarks"; Rec."Disciplinary Remarks")
                {
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                }
                field(Recomendations; Rec.Recomendations)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Closed By"; Rec."Closed By")
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


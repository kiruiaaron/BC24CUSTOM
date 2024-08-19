page 50161 "HR Job Values"
{
    DeleteAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50097;
    SourceTableView = SORTING(Option, Code)
                      ORDER(Descending)
                      WHERE(Option = FILTER(<> "Job Grade"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Option; Rec.Option)
                {
                    ToolTip = 'Specifies the following options Qualification,Requirement,Responsibility,Job Grade for a Job value';
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the code.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description for the code.';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Required Stage"; Rec."Required Stage")
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


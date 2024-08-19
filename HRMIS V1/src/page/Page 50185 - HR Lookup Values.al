page 50185 "HR Lookup Values"
{
    DeleteAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50114;
    SourceTableView = SORTING(Code)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the following options Qualification,Requirement,Responsibility,Job Grade for a Job value';
                    ApplicationArea = All;
                }
                field(Option; Rec.Option)
                {
                    ToolTip = 'Specifies the code.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description for the code.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


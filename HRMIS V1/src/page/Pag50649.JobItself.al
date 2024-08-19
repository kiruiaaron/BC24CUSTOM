page 50649 "Job Itself"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50308;
    SourceTableView = WHERE(Category = CONST(Job));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Statement; Rec.Statement)
                {
                    ApplicationArea = All;
                }
                field(Response; Rec.Response)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Category := Rec.Category::Job
    end;
}


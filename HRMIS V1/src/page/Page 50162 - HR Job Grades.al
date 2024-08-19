page 50162 "HR Job Grades"
{
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50097;
    SourceTableView = SORTING(Option, Code)
                      ORDER(Descending)
                      WHERE(Option = CONST("Job Grade"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Option; Rec.Option)
                {
                    Editable = false;
                    ToolTip = 'Specifies the folowing options Qualification, Requirement, Responsibility, Job grade.';
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the code for a specific Job Grade.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description fot the specific Job code.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Job Grade Levels")
            {
                Caption = 'Job Grade Levels';
                Image = LedgerBook;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                ApplicationArea = All;
            }
            action("Job Grade Allowances")
            {
                Caption = 'Job Grade Allowances';
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Option := Rec.Option::"Job Grade";
    end;
}


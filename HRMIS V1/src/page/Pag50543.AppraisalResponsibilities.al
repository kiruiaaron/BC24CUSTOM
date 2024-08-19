page 50543 "Appraisal Responsibilities"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 50282;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                }
                field("Employee's Responsibilities & Commitments"; Rec."Employee Responsibilities")
                {
                    ApplicationArea = All;
                }
                field("Manager's Responsibilities & Commitments"; Rec."Manager Responsibilities")
                {
                    Caption = 'Commitments & Obligations of the Manager';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}


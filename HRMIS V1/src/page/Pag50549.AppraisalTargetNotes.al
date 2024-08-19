page 50549 "Appraisal Target Notes"
{
    AutoSplitKey = true;
    Caption = 'Contract Target Notes';
    PageType = ListPart;
    SourceTable = 50286;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Criteria code"; Rec."Criteria code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Target Code"; Rec."Target Code")
                {
                    ApplicationArea = All;
                }
                field("Line no"; Rec."Line no")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Notes; Rec.Notes)
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


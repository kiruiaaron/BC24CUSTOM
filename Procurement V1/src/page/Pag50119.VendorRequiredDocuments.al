page 50119 "Vendor Required Documents"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50071;
    SourceTableView = WHERE("LPO Invoice No" = FILTER(''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Code"; Rec."Document Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Document Description"; Rec."Document Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Document Verified"; Rec."Document Verified")
                {
                    ApplicationArea = All;
                }
                field("Verified By"; Rec."Verified By")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
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

    trigger OnAfterGetCurrRecord()
    begin
        IF Rec.HASLINKS THEN BEGIN
            Rec."Document Attached" := TRUE;
            Rec.MODIFY;
        END;
    end;
}


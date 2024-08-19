page 50270 "HR Medical Scheme Members"
{
    PageType = ListPart;
    SourceTable = 50155;
    SourceTableView = WHERE("Cover Option" = FILTER(Principal));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Family Size"; Rec."Family Size")
                {
                    ApplicationArea = All;
                }
                field("Cover Option"; Rec."Cover Option")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Relation; Rec.Relation)
                {
                    ApplicationArea = All;
                }
                field("In Patient Benfit"; Rec."In Patient Benfit")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Out patient Benefit"; Rec."Out patient Benefit")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
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
        Rec."Cover Option" := Rec."Cover Option"::Principal;
    end;
}


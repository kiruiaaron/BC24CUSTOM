page 50271 "HR Medical Sch. Beneficiaries"
{
    PageType = ListPart;
    SourceTable = 50155;
    SourceTableView = WHERE("Cover Option" = FILTER(Dependant));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No"; Rec."Employee No")
                {
                    Caption = 'Principal No.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Caption = 'Principal Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Dependant Name"; Rec."Dependant Name")
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
                field(Age; Rec.Age)
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
        Rec."Cover Option" := Rec."Cover Option"::Dependant
    end;
}


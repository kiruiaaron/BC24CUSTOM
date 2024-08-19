page 50570 "HR Employee Beneficiary"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50115;
    SourceTableView = ORDER(Ascending)
                      WHERE(Type = CONST(Beneficiary));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Firstname; Rec.Firstname)
                {
                    ToolTip = 'Specifies the  Firstname.';
                    ApplicationArea = All;
                }
                field(Middlename; Rec.Middlename)
                {
                    ToolTip = 'Specifies the Middlename.';
                    ApplicationArea = All;
                }
                field(Surname; Rec.Surname)
                {
                    ToolTip = 'Specifies the Surname.';
                    ApplicationArea = All;
                }
                field("Relative Code"; Rec."Relative Code")
                {
                    Caption = 'Relationship Type';
                    ApplicationArea = All;
                }
                field("Relationship Description"; Rec."Relationship Description")
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
        Rec.Type := Rec.Type::Beneficiary;
    end;
}


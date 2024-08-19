Page 50194 "HR Employee Next of Kin"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50115;
    SourceTableView = WHERE(Type = CONST("Next Of Kin"));

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
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Middlename; Rec.Middlename)
                {
                    ToolTip = 'Specifies the Middlename.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Surname; Rec.Surname)
                {
                    Caption = 'Name';
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
                field("Postal Address"; Rec."Postal Address")
                {
                    ApplicationArea = All;
                }
                field("Mobile No"; Rec."Mobile No")
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
        Rec.Type := Rec.Type::"Next Of Kin";
    end;
}


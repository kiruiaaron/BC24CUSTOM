page 50190 "HR Employee Relatives"
{
    Caption = 'HR Employee Family Details';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50115;
    SourceTableView = WHERE(Type = CONST(Relative));

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
                    ToolTip = 'Specifies the Relative Code.';
                    ApplicationArea = All;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the  Date of Birth.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the Age';
                    Visible = false;
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
        Rec.Type := Rec.Type::Relative;
    end;
}


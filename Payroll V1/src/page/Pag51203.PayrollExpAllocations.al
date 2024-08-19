page 51203 "Payroll Exp Allocations"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 51188;

    layout
    {
        area(content)
        {
            repeater(r)
            {
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = All;
                }
                field("ED Code"; Rec."ED Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Dimension Code1"; Rec."Dimension Code1")
                {
                    ApplicationArea = All;
                }
                field("Dimension Value Code1"; Rec."Dimension Value Code1")
                {
                    ApplicationArea = All;
                }
                field("Dimension Code2"; Rec."Dimension Code2")
                {
                    ApplicationArea = All;
                }
                field("Dimension Value Code2"; Rec."Dimension Value Code2")
                {
                    ApplicationArea = All;
                }
                field("Dimension Code3"; Rec."Dimension Code3")
                {
                    ApplicationArea = All;
                }
                field("Dimension Value Code3"; Rec."Dimension Value Code3")
                {
                    ApplicationArea = All;
                }
                field("Dimension Code4"; Rec."Dimension Code4")
                {
                    ApplicationArea = All;
                }
                field("Dimension Value Code4"; Rec."Dimension Value Code4")
                {
                    ApplicationArea = All;
                }
                field("Dimension Code5"; Rec."Dimension Code5")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Dimension Value Code5"; Rec."Dimension Value Code5")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Dimension Code6"; Rec."Dimension Code6")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Dimension Value Code6"; Rec."Dimension Value Code6")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Dimension Code7"; Rec."Dimension Code7")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Dimension Value Code7"; Rec."Dimension Value Code7")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Dimension Code8"; Rec."Dimension Code8")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Dimension Value Code8"; Rec."Dimension Value Code8")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Allocated; Rec.Allocated)
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


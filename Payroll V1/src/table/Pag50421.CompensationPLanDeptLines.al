page 50421 "Compensation PLan Dept Lines"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50246;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Compensation Plan code"; Rec."Compensation Plan code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("ED code"; Rec."ED code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Ed Description"; Rec."Ed Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        calculatespent
                    end;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                }
                field("Amount Planned"; Rec."Amount Planned")
                {
                    ApplicationArea = All;
                }
                field("Total spent"; TotalSpent)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Percentage Spent"; ExpenditurePercentage)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        calculatespent
    end;

    var
        PayrollLines: Record 51160;
        TotalSpent: Decimal;
        ExpenditurePercentage: Decimal;
        CompensationPlan: Record 50245;

    local procedure calculatespent()
    begin
        TotalSpent := CompensationPlan.CalculateExpenditure(Rec."Compensation Plan code", Rec."ED code", Rec."Global Dimension 1 Code");
        IF Rec."Amount Planned" <> 0 THEN
            ExpenditurePercentage := (TotalSpent / Rec."Amount Planned") * 100;
    end;
}


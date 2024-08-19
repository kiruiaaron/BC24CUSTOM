page 50420 "Compensation Plan Lines"
{
    PageType = ListPart;
    SourceTable = 50244;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ED code"; Rec."ED code")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        calculatespent
                    end;
                }
                field("Ed Description"; Rec."Ed Description")
                {
                    ApplicationArea = All;
                }
                field("Total Amount Planned"; Rec."Total Amount Planned")
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
        area(processing)
        {
            action("Departmental Plan Lines")
            {
                Image = LedgerEntries;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 50421;
                RunPageLink = "Compensation Plan code" = FIELD("Compensation Plan code"),
                              "ED Code" = FIELD("ED Code");
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        calculatespent
    end;

    trigger OnOpenPage()
    begin
        //calculatespent
    end;

    var
        PayrollLines: Record 51160;
        TotalSpent: Decimal;
        ExpenditurePercentage: Decimal;
        CompensationPlan: Record 50245;

    local procedure calculatespent()
    begin
        TotalSpent := CompensationPlan.CalculateExpenditure(Rec."Compensation Plan code", Rec."ED code", '');
        IF Rec."Total Amount Planned" <> 0 THEN
            ExpenditurePercentage := (TotalSpent / Rec."Total Amount Planned") * 100;
    end;
}


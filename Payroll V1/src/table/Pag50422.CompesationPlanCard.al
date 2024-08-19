page 50422 "Compesation Plan Card"
{
    PageType = Card;
    SourceTable = 50245;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        calculatespent
                    end;
                }
                field("End date"; Rec."End date")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        calculatespent
                    end;
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
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50420)
            {
                SubPageLink = "Compensation Plan code" = FIELD(Code);
                ApplicationArea = All;
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

    trigger OnOpenPage()
    begin

        TotalSpent := 0;
    end;

    var
        PayrollLines: Record 51160;
        TotalSpent: Decimal;
        ExpenditurePercentage: Decimal;

    local procedure calculatespent()
    begin

        TotalSpent := Rec.CalculateExpenditure(Rec.Code, '', '');

        IF Rec."Total Amount Planned" <> 0 THEN
            ExpenditurePercentage := (TotalSpent / Rec."Total Amount Planned") * 100;
    end;
}


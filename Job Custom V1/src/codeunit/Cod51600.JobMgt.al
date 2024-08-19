codeunit 51600 "Job Mgt"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateLineDiscountPercentOnBeforeUpdateAmounts', '', false, false)]
    local procedure CalculateAmt(var SalesLine: Record "Sales Line"; CurrFieldNo: Integer)
    var
        Currency: Record Currency;
    begin
        SalesLine."Line Discount Amount" :=
         Round(
           Round(SalesLine.Quantity * SalesLine."No. of Days" * SalesLine."Unit Price", Currency."Amount Rounding Precision") *
           SalesLine."Line Discount %" / 100, Currency."Amount Rounding Precision");
    end;

}

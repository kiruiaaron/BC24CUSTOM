pageextension 50002 "Apply Vendor Ledger Entry Ext" extends "Apply Vendor Entries"
{

    local procedure "//Custom"()
    begin
    end;


    procedure SetPaymentLine(NewPaymentLine: Record "Payment Line"; ApplnTypeSelect: Integer)
    begin
        PaymentLine := NewPaymentLine;
        PaymentLineApply := true;

        if PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor then
            ApplyingAmount := PaymentLine."Total Amount";
        ApplnDate := PaymentLine."Posting Date";
        ApplnCurrencyCode := PaymentLine."Currency Code";

        CalcType := CalcType::PaymentLine;

        case ApplnTypeSelect of
            PaymentLine.FieldNo("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            PaymentLine.FieldNo("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry;
    end;

    var
        "//CustomCode": Integer;
        PaymentLine: Record "Payment Line";
        PaymentLine2: Record "Payment Line";
        PaymentLineApply: Boolean;
}


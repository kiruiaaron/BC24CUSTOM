tableextension 51608 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(51600; "No. of Days"; Decimal)
        {

            DataClassification = ToBeClassified;
        }
        field(51601; Purpose; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(51602; Inhouse; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51603; "Management Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        modify("Line Amount")
        {
            trigger OnAfterValidate()



            begin
                TESTFIELD(Type);
                TESTFIELD(Quantity);
                TESTFIELD("Unit Price");
                GetSalesHeader;
                "Line Amount" := ROUND("Line Amount", Currency."Amount Rounding Precision");
                VALIDATE(
                  "Line Discount Amount", ROUND(Quantity * "Unit Price" * "No. of Days", Currency."Amount Rounding Precision") - "Line Amount");

            end;

        }
    }
    var
        Currency: Record Currency;

}

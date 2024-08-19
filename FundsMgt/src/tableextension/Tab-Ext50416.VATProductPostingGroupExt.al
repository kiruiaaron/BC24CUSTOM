tableextension 50416 "VAT Product Posting Group Ext" extends "VAT Product Posting Group"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Percentage; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
        }
    }

    var
        myInt: Integer;
}
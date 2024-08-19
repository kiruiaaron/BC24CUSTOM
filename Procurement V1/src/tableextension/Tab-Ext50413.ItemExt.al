tableextension 50413 "Item Ext" extends Item
{
    fields
    {
        // Add changes to table fields here
        field(52136923; "Location Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(52136924; "Market Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52136930; "Item G/L Budget Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }



    }

    var
        myInt: Integer;
}
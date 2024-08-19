table 50072 "Item Market Price"
{

    fields
    {
        field(10;Item;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Market Price";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"From Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"To Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14;Current;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15;Archived;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Adjusted By";Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17;"Archived By";Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;Item,"From Date")
        {
        }
    }

    fieldgroups
    {
    }
}


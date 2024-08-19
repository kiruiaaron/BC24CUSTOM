table 50056 "Tender Lines"
{

    fields
    {
        field(10; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Document No.";
        Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Supplier Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Remarks; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Reason for Disqualification"; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; Disqualified; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Disqualification point"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Bid Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Supplier No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.", "Supplier Name")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Supplier: Record 23;
}


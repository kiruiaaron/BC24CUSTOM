table 50065 "Vendor Directors Details"
{

    fields
    {
        field(10; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(11; "Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(12; "Director Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Address; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Phone No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "E-Mail"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "ID/Passport No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Nationality; Code[30])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "HR Lookup Values".Code WHERE(Option = CONST(Nationality));
        }
        field(18; "If Other, Nationality"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No", "Vendor No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        NationalityEditable: Boolean;
    //LookUpValue: Record 50114;
}


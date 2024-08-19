table 50067 "Procurement  Portal Documents"
{

    fields
    {
        field(1;"LineNo.";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;"DocumentNo.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Document Code";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Document Description";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Document Attached";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Local File URL";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"SharePoint URL";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"LineNo.")
        {
        }
        key(Key2;"DocumentNo.")
        {
        }
    }

    fieldgroups
    {
    }
}


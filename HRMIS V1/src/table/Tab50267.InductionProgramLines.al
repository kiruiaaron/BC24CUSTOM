table 50267 "Induction Program Lines"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;Content;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Plan Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Induction Program";
        }
        field(5;Activity;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Responsible Parties";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;Date;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Start time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"End time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(10;Venue;Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Plan Code","Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}


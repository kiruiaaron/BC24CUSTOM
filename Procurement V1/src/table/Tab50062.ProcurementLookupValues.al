table 50062 "Procurement Lookup Values"
{

    fields
    {
        field(10; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Type"; Option)
        {
            OptionMembers = " ","Tender Criteria",City;
            OptionCaption = ' ,Tender Criteria,City';
            DataClassification = ToBeClassified;

        }
        field(12; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Cluster Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cluster Codes"."Cluster Code";
        }
    }

    keys
    {
        key(Key1; "Line No", "Type", "Code")
        {
        }
    }

    fieldgroups
    {
    }
}


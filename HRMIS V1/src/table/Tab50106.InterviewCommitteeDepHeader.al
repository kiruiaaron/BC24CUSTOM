table 50106 "Interview Committee Dep Header"
{

    fields
    {
        field(1; "Department Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(2; "Dept Committee Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Department Code")
        {
        }
    }

    fieldgroups
    {
    }
}


table 50204 "Areas of Grieavance"
{
    DrillDownPageID = 50363;
    LookupPageID = 50363;

    fields
    {
        field(1; "Grievance Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Grievance Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Grievance Code", "Grievance Description")
        {
        }
    }

    fieldgroups
    {
    }
}


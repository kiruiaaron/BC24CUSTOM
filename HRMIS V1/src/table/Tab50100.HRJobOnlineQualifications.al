table 50100 "HR Job Online Qualifications"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Qualification Code"; Code[20])
        {
            //  TableRelation = "HR Job Lookup Value".Code WHERE(Option = FILTER("Other Certifications|Qualification"));
        }
        field(4; "Qualification Name"; Text[250])
        {
        }
        field(5; "Document Attached"; Boolean)
        {
        }
        field(6; "Joining Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Completion Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Institution Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Award; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Award Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "E-mail"; Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
    }

    keys
    {
        key(Key1; "Line No.", "E-mail")
        {
        }
    }

    fieldgroups
    {
    }
}


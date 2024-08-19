table 50071 "Vendor Required Documents"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Document Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Document Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Document Verified"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Document Verified" = TRUE THEN BEGIN
                    "Verified By" := USERID;
                END;
            end;
        }
        field(6; "Verified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Product Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "LPO Invoice No";
        Code[80])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "LPO Vendor No."; Code[80])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Document Code", "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


/// <summary>
/// Table HR Employee Prof. Membership (ID 50123).
/// </summary>
table 50123 "HR Employee Prof. Membership"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(3; "Employee Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Professional Body Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Membership No."; Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Membership No.");
            end;
        }
        field(6; "Practising Cert/License No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }
}


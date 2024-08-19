table 50269 "Induction Participants"
{

    fields
    {
        field(6; Designation; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Department; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Phone Number"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(11; "Induction Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."No.", "Employee No.");
                IF Employee.FINDFIRST THEN BEGIN
                    "Employee Name" := Employee."Last Name" + '' + Employee."Middle Name" + '' + Employee."First Name";
                    "Employee Email" := Employee."Company E-Mail";
                    Designation := Employee."Job Title";
                    Department := Employee."Global Dimension 1 Code";
                    "Phone Number" := Employee."Mobile Phone No.";

                END;
            end;
        }
        field(13; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Employee Email"; Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(15; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Induction Code", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record 5200;
}


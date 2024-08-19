table 50316 "EHS Items Issue Lines"
{

    fields
    {
        field(1; "Claim No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Claim Lines"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);

                "Employee Name" := '';

                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";

                END;
            end;
        }
        field(41; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(47; "Quantity Issued"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(48; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Claim No", "Claim Lines")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record 5200;
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}


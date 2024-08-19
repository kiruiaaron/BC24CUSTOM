/// <summary>
/// Table HR Training Group Participants (ID 50163).
/// </summary>
table 50163 "HR Training Group Participants"
{

    fields
    {
        field(1; "Training Group No."; Code[10])
        {
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                "Employee Name" := '';
                "E-mail Address" := '';
                "Job Tittle" := '';

                Employees.RESET;
                Employees.SETRANGE("No.", "Employee No.");
                IF Employees.FINDFIRST THEN BEGIN
                    "Employee Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name";
                    "Job Tittle" := Employees.Title;
                    "E-mail Address" := Employees."Company E-Mail";
                END;
            end;
        }
        field(4; "Employee Name"; Text[90])
        {
            Editable = false;
        }
        field(5; "E-mail Address"; Text[60])
        {
            Editable = false;
            ExtendedDatatype = None;
        }
        field(6; "Phone Number"; Text[50])
        {
            Editable = false;
            ExtendedDatatype = None;
        }
        field(7; "Job Tittle"; Text[50])
        {
            Editable = false;
        }
        field(20; "Estimated Cost"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Training Group No.", "Line No", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        TrainingApplications: Record 50164;
        Employees: Record 5200;
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TrainingNeeds: Record 50158;
}


table 50329 "Probation Review Meeting"
{

    fields
    {
        field(1; "Review No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Meeting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Meeting Chairperson"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF EmployeeRc.GET("Meeting Chairperson") THEN
                    "Meeting Chairperson Name" := EmployeeRc.FullName;
            end;
        }
        field(4; "Meeting Chairperson Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Review No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EmployeeRc: Record 5200;
}


table 50153 "HR Exit Interview Checklist"
{

    fields
    {
        field(1; "Exit Interview No"; Code[10])
        {
            // TableRelation = Table55588.Field1;
        }
        field(2; "Clearance Date"; Date)
        {
            Editable = false;
        }
        field(3; "CheckList Item"; Text[80])
        {
        }
        field(4; Cleared; Boolean)
        {

            trigger OnValidate()
            begin
                "Cleared By" := USERID;


                IF Cleared THEN
                    "Clearance Date" := TODAY
                ELSE
                    "Clearance Date" := 0D;
            end;
        }
        field(9; "Cleared By"; Code[20])
        {
        }
        field(11; "Line No"; Integer)
        {
            AutoIncrement = false;
        }
        field(12; "Employee No"; Code[50])
        {
            TableRelation = Employee;
        }
    }

    keys
    {
        key(Key1; "Exit Interview No", "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


table 50263 "Company Mail Management"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Mail Direction"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Incoming,Outgoing';
            OptionMembers = Incoming,Outgoing;
        }
        field(3; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Sender Details"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Subject; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Letter Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "MD Comments/Instructions"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Forwarded For action To"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."No.", "Forwarded For action To");
                IF Employee.FINDFIRST THEN BEGIN
                    "Employee Name" := Employee."Last Name" + ' ' + Employee."Middle Name" + ' ' + Employee."First Name";
                    "Employee Email" := Employee."Company E-Mail";
                    Designation := Employee."Job Title";
                    "Phone No" := Employee."Mobile Phone No.";
                END;
            end;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Sent,Closed;
        }
        field(10; "Action Comments"; Text[120])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Date Time Received"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Date Ttime Sent To MD"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Date Time Sent to Staff"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Date Time Actioned"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; Stage; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'ES,MD,Staff';
            OptionMembers = ES,MD,Staff;
        }
        field(17; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Employee Email"; Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(22; Designation; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Phone No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Reference No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created By" := USERID;
    end;

    var
        Employee: Record 5200;
}


/// <summary>
/// Table HR Training Attendees (ID 50165).
/// </summary>
table 50165 "HR Training Attendees"
{
    Caption = 'HR Training Attendee(s)';

    fields
    {
        field(1; "Application No."; Code[10])
        {
        }
        field(2; "Employee No"; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                "Employee Name" := '';
                "E-mail Address" := '';
                "Phone Number" := '';
                "Job Title" := '';


                Employees.RESET;
                Employees.SETRANGE(Employees."No.", "Employee No");
                IF Employees.FINDFIRST THEN BEGIN
                    "Employee Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name";
                    "E-mail Address" := Employees."Company E-Mail";
                    "Phone Number" := Employees."Mobile Phone No.";
                    "Job Title" := Employees.Title;
                    "Global Dimension 1 Code" := Employees."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employees."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := Employees."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := Employees."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := Employees."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code" := Employees."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code" := Employees."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code" := Employees."Shortcut Dimension 8 Code";
                END;
            end;
        }
        field(3; "Employee Name"; Text[90])
        {
            Editable = false;
        }
        field(4; "E-mail Address"; Text[60])
        {
            Caption = 'Official E-mail Address';
            Editable = false;
            ExtendedDatatype = None;
        }
        field(5; "Phone Number"; Text[50])
        {
            Editable = false;
            ExtendedDatatype = None;
        }
        field(6; "Job Title"; Text[50])
        {
            Editable = false;
        }
        field(20; "Estimated Cost"; Decimal)
        {
            Caption = 'Estimated Cost of Training ';
        }
        field(21; "Actual Training Cost"; Decimal)
        {
            Caption = 'Actual Cost of Training ';
            DataClassification = ToBeClassified;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
    }

    keys
    {
        key(Key1; "Application No.", "Employee No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employees: Record 5200;
}


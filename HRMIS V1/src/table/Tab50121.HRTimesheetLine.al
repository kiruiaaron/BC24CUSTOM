table 50121 "HR Timesheet Line"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()

            begin
                Employee.RESET;
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                END;
            end;
        }
        field(2; "Employee Name"; Text[150])
        {
            Editable = false;
        }
        field(3; Date; Date)
        {
        }
        field(4; "Time In"; Time)
        {
        }
        field(5; "Time Out"; Time)
        {
        }
        field(6; "Based On"; Option)
        {
            OptionCaption = ' ,Day,Session';
            OptionMembers = " ",Day,Session;
        }
        field(7; "No. of Hrs"; Integer)
        {
        }
        field(8; "Rate per Day"; Decimal)
        {
        }
        field(9; Amount; Decimal)
        {
        }
        field(49; Description; Text[250])
        {
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Rejected;
        }
        field(99; "User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
    }

    keys
    {
        key(Key1; "Employee No.", Date)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record Employee;
}


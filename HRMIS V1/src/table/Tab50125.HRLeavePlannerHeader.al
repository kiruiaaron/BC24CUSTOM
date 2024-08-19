table 50125 "HR Leave Planner Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."Last Name" + ' ' + Employee."First Name" + ' ' + Employee."Middle Name";
                    // "Job No." := Employee."Job No.-d";
                    "Job Title" := Employee."Job Title";
                    // "Job Grade" := Employee."Job Grade-d";
                    "Job Description" := Employee."Job Title";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := Employee."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := Employee."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code" := Employee."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code" := Employee."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code" := Employee."Shortcut Dimension 8 Code";
                    HRLeavePeriod.RESET;
                    HRLeavePeriod.SETRANGE(HRLeavePeriod.Closed, FALSE);
                    IF HRLeavePeriod.FINDFIRST THEN BEGIN
                        "Leave Period" := HRLeavePeriod.Code;
                    END;
                END ELSE BEGIN
                    "Employee Name" := '';
                    "Job No." := '';
                    "Job Title" := '';
                    "Job Grade" := '';
                    "Job Description" := '';
                    "Leave Period" := '';
                    "Global Dimension 1 Code" := '';
                    "Global Dimension 2 Code" := '';
                    "Shortcut Dimension 3 Code" := '';
                    "Shortcut Dimension 4 Code" := '';
                    "Shortcut Dimension 5 Code" := '';
                    "Shortcut Dimension 6 Code" := '';
                    "Shortcut Dimension 7 Code" := '';
                    "Shortcut Dimension 8 Code" := '';
                END;
            end;
        }
        field(3; "Employee Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Job No."; Code[20])
        {
            Editable = false;
            TableRelation = "HR Jobs"."No.";
        }
        field(5; "Job Title"; Code[50])
        {
            Editable = false;
        }
        field(6; "Job Description"; Text[100])
        {
            Editable = false;
        }
        field(7; "Job Grade"; Code[20])
        {
            Editable = false;
            TableRelation = "HR Job Lookup Value".Code WHERE(Option = CONST("Job Grade"));
        }
        field(20; "Leave Type"; Code[50])
        {
            TableRelation = "HR Leave Types".Code WHERE("Leave Plan Mandatory" = CONST(true));
        }
        field(21; "Leave Period"; Code[20])
        {
            Editable = false;
            TableRelation = "HR Leave Periods".Code WHERE(Closed = CONST(false));
        }
        field(49; Description; Text[250])
        {

            trigger OnValidate()
            begin
                Description := UPPERCASE(Description);
            end;
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
            OptionCaption = 'Open,Pending Approval,Released,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Rejected;
        }
        field(99; "User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."User ID", "User ID");
                IF Employee.FINDFIRST THEN BEGIN
                    Employee.TESTFIELD("Global Dimension 1 Code");
                    Employee.TESTFIELD("Global Dimension 2 Code");
                    "Employee No." := Employee."No.";
                    "Employee Name" := Employee."Last Name" + ' ' + Employee."Middle Name" + ' ' + Employee."First Name";
                    // "Job No." := Employee."Job No.-d";
                    "Job Title" := Employee."Job Title";
                    // "Job Grade" := Employee."Job Grade-d";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := Employee."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := Employee."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code" := Employee."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code" := Employee."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code" := Employee."Shortcut Dimension 8 Code";
                END;
            end;
        }
        field(100; "No. Series"; Code[20])
        {
        }
        field(102; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Leave Planner Nos.");
            //NoSeriesMgt.InitSeries(HRSetup."Leave Planner Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "User ID" := USERID;
        VALIDATE("User ID");
    end;

    var
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Employee: Record 5200;
        HRLeavePeriod: Record 50135;
}


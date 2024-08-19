/// <summary>
/// Table HR Training Needs Header (ID 50157).
/// </summary>
table 50157 "HR Training Needs Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = false;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                "Employee Name" := '';
                "Global Dimension 1 Code" := '';
                "Global Dimension 2 Code" := '';
                "Shortcut Dimension 3 Code" := '';
                "Job No." := '';
                "Job Title" := '';
                "Appraisal Period" := '';
                "Calendar Year" := '';

                Employee.RESET;
                Employee.SETRANGE(Employee."No.", "Employee No.");
                IF Employee.FINDFIRST THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    "Job No." := Employee.Position;
                    "Job Title" := Employee.Title;
                    "Official E-mail Address" := Employee."Company E-Mail";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 1 Code";
                    "Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
                END;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Job Title"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Date of Request"; Date)
        {
        }
        field(7; "Appraisal Period"; Code[80])
        {
            Caption = 'Recommended Training from Appr. Period';
            DataClassification = ToBeClassified;
            TableRelation = "HR Calendar Period".Code WHERE(Closed = CONST(false));

            trigger OnValidate()
            begin
                TESTFIELD("Calendar Year");
                AppraisalTrainingandDev.RESET;
                AppraisalTrainingandDev.SETRANGE(AppraisalTrainingandDev."Appraisal Period", "Appraisal Period");
                AppraisalTrainingandDev.SETRANGE(AppraisalTrainingandDev."Employee No.", "Employee No.");
                IF AppraisalTrainingandDev.FINDSET THEN BEGIN
                    REPEAT
                        TrainingNeedsLine.INIT;
                        TrainingNeedsLine."Line No." := 0;
                        TrainingNeedsLine."No." := "No.";
                        TrainingNeedsLine.VALIDATE(TrainingNeedsLine."No.");
                        TrainingNeedsLine."Employee No." := AppraisalTrainingandDev."Employee No.";
                        TrainingNeedsLine."Employee Name" := AppraisalTrainingandDev."Employee Name";
                        TrainingNeedsLine."Development Needs" := AppraisalTrainingandDev."Area of Development";
                        TrainingNeedsLine."Official Email Address" := "Official E-mail Address";
                        TrainingNeedsLine."Calendar Year" := "Calendar Year";
                        TrainingNeedsLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        TrainingNeedsLine."Global Dimension 2 Code" := "Global Dimension 2 Code";
                        TrainingNeedsLine."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                        TrainingNeedsLine."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
                        TrainingNeedsLine."Shortcut Dimension 5 Code" := "Shortcut Dimension 5 Code";
                        TrainingNeedsLine."Shortcut Dimension 6 Code" := "Shortcut Dimension 6 Code";
                        TrainingNeedsLine."Shortcut Dimension 7 Code" := "Shortcut Dimension 7 Code";
                        TrainingNeedsLine."Shortcut Dimension 8 Code" := "Shortcut Dimension 8 Code";
                    UNTIL AppraisalTrainingandDev.NEXT = 0;
                END;
            end;
        }
        field(8; "Calendar Year"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Calendar Period".Code;
        }
        field(9; "Official E-mail Address"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = EMail;
        }
        field(13; Description; Text[200])
        {
        }
        field(15; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Cancelled';
            OptionMembers = Open,"Pending Approval",Approved,Cancelled;
        }
        field(18; Closed; Boolean)
        {
            Editable = false;
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
                                                          Blocked = CONST(false)
                                                        );
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
        field(80; "No. Series"; Code[20])
        {
        }
        field(99; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                Employees.RESET;
                Employees.SETRANGE(Employees."User ID", "User ID");
                IF Employees.FINDFIRST THEN BEGIN
                    Employees.TESTFIELD("Global Dimension 1 Code");
                    Employees.TESTFIELD("Global Dimension 2 Code");
                    "Employee No." := Employees."No.";
                    "Employee Name" := Employees."Last Name" + ' ' + Employees."Middle Name" + ' ' + Employees."First Name";
                    "Job Title" := Employees."Job Title";
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

    trigger OnDelete()
    begin
        Rec.TESTFIELD(Status, Rec.Status::Open);
        TrainingNeedsLine.RESET;
        TrainingNeedsLine.SETRANGE(TrainingNeedsLine."No.", "No.");
        IF TrainingNeedsLine.FINDSET THEN
            TrainingNeedsLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Training Needs Nos");
            //NoSeriesMgt.InitSeries(HRSetup."Training Needs Nos", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "User ID" := USERID;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record 5218;
        Txt001: Label 'You cannot change the costs after posting';
        Vendors: Record 23;
        Employee: Record 5200;
        AppraisalTrainingandDev: Record 50143;
        TrainingNeedsHeader: Record 50157;
        TrainingNeedsLine: Record 50158;
        Employees: Record 5200;
}


/// <summary>
/// Table HR Training Applications (ID 50164).
/// </summary>
table 50164 "HR Training Applications"
{

    fields
    {
        field(1; "Application No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Training Need No."; Code[20])
        {
            Caption = 'Approved Training Need No.';
            NotBlank = true;
            TableRelation = IF ("Type of Training" = CONST("Individual Training")) "Approved Training Needs Line"."No." WHERE("Employee No." = FIELD("No."),
                                                                                                                       "No." = FIELD("Training Need No."),
                                                                                                                       "Training Attended" = CONST(false))
            ELSE
            IF ("Type of Training" = CONST("Group Training")) "HR Training Needs Line";

            trigger OnValidate()
            begin
                "Development Need" := '';
                "Purpose of Training" := '';
                Location := '';


                ApprovedTrainingNeedsLine.RESET;
                ApprovedTrainingNeedsLine.SETRANGE("No.", "Training Need No.");
                ApprovedTrainingNeedsLine.SETRANGE("Employee No.", "Employee No.");
                ApprovedTrainingNeedsLine.SETRANGE("Approved By Management", TRUE);
                ApprovedTrainingNeedsLine.SETRANGE("Training Attended", FALSE);
                IF ApprovedTrainingNeedsLine.FINDFIRST THEN BEGIN
                    "Development Need" := ApprovedTrainingNeedsLine."Development Needs";
                    "Purpose of Training" := ApprovedTrainingNeedsLine.Objectives;
                    Location := ApprovedTrainingNeedsLine."Training Location & Venue";
                    "From Date" := ApprovedTrainingNeedsLine."Training Scheduled Date";
                    "To Date" := ApprovedTrainingNeedsLine."Training Scheduled Date To";

                    TrainingAttendees.RESET;
                    TrainingAttendees.SETRANGE(TrainingAttendees."Application No.", "Application No.");
                    IF TrainingAttendees.FINDFIRST THEN BEGIN
                        CALCFIELDS("Estimated Cost Of Training");
                        TrainingAttendees."Estimated Cost" := ApprovedTrainingNeedsLine."Estimated Cost";
                        TrainingAttendees.MODIFY;
                    END;
                END;
            end;
        }
        field(5; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Type of Training" = CONST("Group Training")) "HR Training Group"."Training Group App. No."
            ELSE
            IF ("Type of Training" = CONST("Individual Training")) Employee."No.";

            trigger OnValidate()
            begin
                TESTFIELD("Type of Training");
                Name := '';
                Description := '';
                "Development Need" := '';
                "Purpose of Training" := '';
                "Calendar Year" := '';
                "Number of Days" := '';
                "From Date" := 0D;
                "To Date" := 0D;

                TrainingEvaluation.RESET;
                TrainingEvaluation.SETRANGE(TrainingEvaluation."Employee No.", "No.");
                TrainingEvaluation.SETRANGE(Submitted, FALSE);
                IF TrainingEvaluation.FINDFIRST THEN BEGIN
                    ERROR(ErrorTrainingApplication);
                END;


                IF HREmployee.GET("No.") THEN BEGIN
                    Name := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";
                    "Global Dimension 1 Code" := HREmployee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := HREmployee."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := HREmployee."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := HREmployee."Shortcut Dimension 4 Code";
                END;
                TrainingManagement.ValidateTrainingDetails(Rec);
            end;
        }
        field(6; Name; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Document Date"; Date)
        {
            Editable = false;
        }
        field(8; Description; Text[250])
        {
        }
        field(9; "From Date"; Date)
        {
            Caption = 'Training Start Date';
        }
        field(10; "To Date"; Date)
        {
            Caption = 'Training End Date';

            trigger OnValidate()
            begin
                "Number of Days" := FORMAT("To Date" - "From Date");
            end;
        }
        field(11; "Number of Days"; Text[70])
        {
            Editable = false;
        }
        field(12; "Estimated Cost Of Training"; Decimal)
        {
            CalcFormula = Sum("HR Training Attendees"."Estimated Cost" WHERE("Application No." = FIELD("Application No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; Location; Text[30])
        {
            Caption = 'Training Location and Venue';
            Editable = false;
        }
        field(14; "Provider Code"; Code[10])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                Vendor.RESET;
                Vendor.SETRANGE(Vendor."No.", "Provider Code");
                IF Vendor.FINDFIRST THEN BEGIN
                    "Provider Name" := Vendor.Name;
                END;
            end;
        }
        field(15; "Provider Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Purpose of Training"; Text[100])
        {
            Caption = 'Objective/Purpose of Training';
        }
        field(17; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(18; Posted; Boolean)
        {
            Editable = false;
        }
        field(19; Recommendations; Code[20])
        {
        }
        field(20; "Actual Training Cost"; Decimal)
        {
            Caption = 'Actual Cost of Training';
        }
        field(21; "Total Training Cost"; Decimal)
        {
            CalcFormula = Sum("HR Training Attendees"."Actual Training Cost" WHERE("Application No." = FIELD("Application No.")));
            Caption = 'Total Actual Training Cost ';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Calendar Year"; Code[20])
        {
            Caption = 'Training Calendar Year';
            DataClassification = ToBeClassified;
            TableRelation = "HR Calendar Period".Code;
        }
        field(23; "Development Need"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25; "User ID"; Code[50])
        {
            Editable = false;
        }
        field(26; "Evaluation Submitted"; Boolean)
        {
            Caption = 'Training Evaluation Submitted';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50; "No. Series"; Code[20])
        {
        }
        field(51; "Type of Training"; Option)
        {
            Caption = 'Training Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Individual Training","Group Training";

            trigger OnValidate()
            begin
                "No." := '';
                Name := '';
                Description := '';
                "Development Need" := '';
                "Purpose of Training" := '';
                "Calendar Year" := '';
                "Number of Days" := '';
                "From Date" := 0D;
                "To Date" := 0D;

                //delete all lines
                TrainingAttendees.RESET;
                TrainingAttendees.SETRANGE("Application No.", "Application No.");
                IF TrainingAttendees.FINDSET THEN
                    TrainingAttendees.DELETEALL;
            end;
        }
        field(52; "Employee No."; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                TrainingAttendees.RESET;
                TrainingAttendees.SETRANGE("Application No.", "Application No.");
                IF TrainingAttendees.FINDSET THEN
                    TrainingAttendees.DELETEALL;

                "Employee Name" := '';

                IF HREmployee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";

                    TrainingAttendees.INIT;
                    TrainingAttendees."Application No." := "Application No.";
                    TrainingAttendees."Employee No" := "Employee No.";
                    TrainingAttendees."Employee Name" := "Employee Name";
                    TrainingAttendees."E-mail Address" := HREmployee."Company E-Mail";
                    TrainingAttendees."Global Dimension 1 Code" := HREmployee."Global Dimension 1 Code";
                    TrainingAttendees."Global Dimension 2 Code" := HREmployee."Global Dimension 2 Code";
                    TrainingAttendees."Shortcut Dimension 3 Code" := HREmployee."Shortcut Dimension 3 Code";
                    TrainingAttendees."Shortcut Dimension 4 Code" := HREmployee."Shortcut Dimension 4 Code";
                    TrainingAttendees."Shortcut Dimension 5 Code" := HREmployee."Shortcut Dimension 5 Code";
                    TrainingAttendees."Shortcut Dimension 6 Code" := HREmployee."Shortcut Dimension 6 Code";
                    TrainingAttendees."Shortcut Dimension 7 Code" := HREmployee."Shortcut Dimension 7 Code";
                    TrainingAttendees."Shortcut Dimension 8 Code" := HREmployee."Shortcut Dimension 8 Code";
                    TrainingAttendees.INSERT;
                END;
            end;
        }
        field(53; "Employee Name"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54; "Evaluation Card Created"; Boolean)
        {
            Caption = 'Evaluation Card Created';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(61; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(62; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(63; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(64; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(65; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(66; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(67; "Shortcut Dimension 8 Code"; Code[20])
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
        key(Key1; "Application No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Application No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Training Application Nos");
            //NoSeriesMgt.InitSeries(HRSetup."Training Application Nos", xRec."No. Series", 0D, "Application No.", "No. Series");
        END;

        "User ID" := USERID;
        "Document Date" := TODAY;
    end;

    var
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TrainingNeeds: Record 50158;
        TrainingGroupParticipants: Record 50160;
        TrainingManagement: Codeunit 50042;
        TrainingGroups: Record "HR Training Group";
        Vendor: Record Vendor;
        HREmployee: Record 5200;
        TrainingAttendees: Record 50165;
        Dates: Codeunit 50043;
        ApprovedTrainingNeedsLine: Record 50160;
        TrainingEvaluation: Record 50161;
        ErrorTrainingApplication: Label 'You cannot make another Training application if you have not submiited an Evaluation from your previous training attended! Please submit evaluation for your previous Training to proceed';
}


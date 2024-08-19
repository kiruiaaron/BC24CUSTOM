table 50290 "Employee PIP"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                "Employee Name" := '';
                "Job Grade" := '';
                Designation := '';
                "Reporting To" := '';
                "Reporting To Name" := '';

                Employees.RESET;
                IF Employees.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name";
                    Designation := Employees."Job Title";
                    "Reporting To Name" := Employees."Supervisor Job Title";
                    //Validate Dimensions
                    VALIDATE("Global Dimension 1 Code", Employees."Global Dimension 1 Code");
                    VALIDATE("Global Dimension 2 Code", Employees."Global Dimension 2 Code");
                    VALIDATE("Shortcut Dimension 3 Code", Employees."Shortcut Dimension 3 Code");
                    VALIDATE("Shortcut Dimension 4 Code", Employees."Shortcut Dimension 4 Code");


                    HRJobs.RESET;
                    IF HRJobs.GET(Employees.Position) THEN BEGIN
                        "Appraisal Level" := HRJobs."Appraisal Level";
                        "Reporting To" := HRJobs."Supervisor Job No.";

                    END;
                END;
            end;
        }
        field(3; "Employee Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Appraisal Period"; Code[20])
        {
            TableRelation = "HR Calendar Period".Code WHERE(Closed = CONST(false));

            trigger OnValidate()
            begin
                IF AppraisalPeriods.GET("Appraisal Period") THEN
                    "Evaluation Period Start" := AppraisalPeriods."Start Date";
                "Evaluation Period End" := AppraisalPeriods."End Date";


                HREmployeeAppraisalHeader.RESET;
            end;
        }
        field(5; "Appraisal Stage"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Target Setting,Target Approval,Mid Year Evaluation,End Year Evaluation,Organization,Department,Section,Internship';
            OptionMembers = "Target Setting","Target Approval","Mid Year Evaluation","End Year Evaluation",Organization,Department,Section,Internship;
        }
        field(6; "Job Grade"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Designation; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Appraisal Level"; Option)
        {
            Caption = 'Level';
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = ' ,CMT,Management,Unionisable';
            OptionMembers = " ",CMT,Management,Unionisable;
        }
        field(9; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Reporting To"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Reporting To Name" := '';
                IF Employees.GET("Reporting To") THEN
                    "Reporting To Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name";
                "Reporting To Designation" := Employees."Job Title"
            end;
        }
        field(11; "Reporting To Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Supervisor User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(14; "Reporting To Designation"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Evaluation Period Start"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Evaluation Period End"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Total Self Assement Rating "; Decimal)
        {
            CalcFormula = Sum("Organization Appraisal Lines"."Self Assessment Rating" WHERE("Appraisal No." = FIELD("No.")));
            Caption = 'Total Self Assement Rating';
            FieldClass = FlowField;
        }
        field(18; "Self Assesment Weighted Rating"; Decimal)
        {
            Caption = 'Total Self Assesment Weighted Rating ';
            DataClassification = ToBeClassified;
        }
        field(19; "Agreed Rating with Supervisor"; Decimal)
        {
            Caption = 'Total Agreed Rating with Supervisor';
            DataClassification = ToBeClassified;
        }
        field(20; "Weighted Rating with Superviso"; Decimal)
        {
            Caption = 'Total Agreed Weighted Rating with Supervisor';
            DataClassification = ToBeClassified;
        }
        field(21; "Moderated Assement Rating"; Decimal)
        {
            Caption = 'Total Moderated Assement Rating';
            DataClassification = ToBeClassified;
        }
        field(22; "Weighted Rat. Moderated Value"; Decimal)
        {
            Caption = 'Total Weighted Rating Moderated Value';
            DataClassification = ToBeClassified;
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
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "Global Dimension 1 Code");
                IF DimensionValue.FINDFIRST THEN
                    Department := DimensionValue.Name;
            end;
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

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "Global Dimension 2 Code");
                IF DimensionValue.FINDFIRST THEN
                    Station := DimensionValue.Name;
            end;
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

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "Shortcut Dimension 3 Code");
                IF DimensionValue.FINDFIRST THEN
                    Section := DimensionValue.Name;
            end;
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
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Closed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Closed;
        }
        field(99; "User ID"; Code[50])
        {
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
                    Designation := Employees."Job Title";
                    "Global Dimension 1 Code" := Employees."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employees."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := Employees."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := Employees."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := Employees."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code" := Employees."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code" := Employees."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code" := Employees."Shortcut Dimension 8 Code";
                    HRJobs.RESET;
                    /*  IF HRJobs.GET(Employees."Job No.-d") THEN BEGIN
                         "Appraisal Level" := HRJobs."Appraisal Level";
                         "Reporting To" := HRJobs."Supervisor Job No.";
                     END; */
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
        field(103; "Overall Purpose"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Vision Statement"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(105; "Mission Statement"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(106; "Employee Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(107; "Supervisor Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(108; "HR Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(109; Recommendations; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(110; "Core Mandate"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(111; "Information Flow"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(112; "Targeted Score"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Targeted Score" WHERE("Header No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(113; "Contract no"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(114; "Achieved Score"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score Employee" WHERE("Header No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(115; Rating; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Exceptional,Very Good,Good,Average,Below Average';
            OptionMembers = " ",Exceptional,"Very Good",Good,"Average","Below Average";
        }
        field(117; Department; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(118; Station; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(119; Section; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Appraisal Period")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            IF ("Appraisal Stage" = "Appraisal Stage"::Organization) OR ("Appraisal Stage" = "Appraisal Stage"::Department) OR ("Appraisal Stage" = "Appraisal Stage"::Section) THEN BEGIN
                HRSetup.GET;
                //   HRSetup.TESTFIELD(HRSetup."Target Nos.");
                //    //NoSeriesMgt.InitSeries(HRSetup."Target Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            END ELSE
                IF "Appraisal Stage" = "Appraisal Stage"::"Target Setting" THEN BEGIN
                    HRSetup.GET;
                    // HRSetup.TESTFIELD(HRSetup."Employee Contract Nos.");
                    //  //NoSeriesMgt.InitSeries(HRSetup."Employee Contract Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                END ELSE BEGIN
                    HRSetup.GET;
                    HRSetup.TESTFIELD(HRSetup."Employee Appraisal Nos.");
                    //NoSeriesMgt.InitSeries(HRSetup."Employee Appraisal Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                END

        END;
        "User ID" := USERID;
        VALIDATE("User ID");
    end;

    var
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRJob: Record "HR Jobs";
        Employees: Record 5200;
        AppraisalPeriods: Record 50145;
        EmployeeAppraisalLines: Record 50139;
        Txt001: Label 'This will delete all appraisal lines and create new ones, continue?';
        AppraisalKPIs: Record 50144;
        AppraisalHeader: Record 50138;
        AppraisalTargetOutputs: Record 50147;
        HRJobs: Record 50093;
        AppraisalObjectives: Record 50146;
        AppraisalTrainingandDev: Record 50143;
        HREmployeeAppraisalHeader: Record 50138;
        DimensionValue: Record 349;
}


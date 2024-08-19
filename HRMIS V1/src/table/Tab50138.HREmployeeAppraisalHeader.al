/// <summary>
/// Table HR Employee Appraisal Header (ID 50138).
/// </summary>
table 50138 "HR Employee Appraisal Header"
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
                "Job Title" := '';
                Supervisor := '';
                "Supervisor Name" := '';

                Employees.RESET;
                IF Employees.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name";
                    "Job Title" := Employees."Job Title";
                    "Supervisor Name" := Employees."Supervisor Job Title";
                    //Validate Dimensions
                    "Global Dimension 1 Code" := Employees."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employees."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := Employees."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := Employees."Shortcut Dimension 4 Code";
                    "Date of Appointment" := Employees."Employment Date";
                    "Employment Term" := Employees."Emplymt. Contract Code";
                    "Date Assigned Current Position" := Employees."Employment Date";


                    HRJobs.RESET;
                    IF HRJobs.GET(Employees.Position) THEN BEGIN
                        "Appraisal Level" := HRJobs."Appraisal Level";
                        Supervisor := HRJobs."Supervisor Job No.";

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
            OptionCaption = 'Target Setting,Target Approval,Mid Year Evaluation,End Year Evaluation';
            OptionMembers = "Target Setting","Target Approval","Mid Year Evaluation","End Year Evaluation";
        }
        field(6; "Job Grade"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Job Title"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Appraisal Level"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Organizational,Departmental,Divisional,Individual';
            OptionMembers = " ",Organizational,Departmental,Divisional,Individual;
        }
        field(9; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Supervisor; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Supervisor Name" := '';
                IF Employees.GET(Supervisor) THEN
                    "Supervisor Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name";
            end;
        }
        field(11; "Supervisor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Supervisor User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
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
                    "Job Title" := Employees."Job Title";
                    "Job Grade" := Employees."Employee Grade";
                    "Global Dimension 1 Code" := Employees."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employees."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := Employees."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := Employees."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := Employees."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code" := Employees."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code" := Employees."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code" := Employees."Shortcut Dimension 8 Code";
                    HRJobs.RESET;
                    /*                    IF HRJobs.GET(Employees."") THEN BEGIN
                                         "Appraisal Level":=HRJobs."Appraisal Level";
                                         Supervisor:=HRJobs."Supervisor Job No.";
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
        field(103; "Date of Appointment"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Date Assigned Current Position"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(105; "Date of Last Appraisal"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(106; "Employment Term"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employment Contract";
        }
        field(107; "Special Tasks (if any)"; Text[250])
        {
            Caption = '(b) Special Tasks (if any)';
            DataClassification = ToBeClassified;
        }
        field(108; "Last Performance Rating"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Excellent,Good,Fair';
            OptionMembers = " ",Excellent,Good,Fair;
        }
        field(109; "Comments By HOD"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(110; "Comments By HOD HR"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(111; "Final Comments by Appraiser"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(112; "Objectives Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Objectives".Score WHERE("Appraisal No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(113; "Competency Factor Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Assesment Factor"."Score (1-5)" WHERE("Appraisal No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(114; "Comments By Appraisee"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(115; "Comments By Appraisee Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(116; "Comments by Appraiser Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(117; "Total Rating"; Decimal)
        {
            Caption = 'Total Rating Part C+Part D';
            DataClassification = ToBeClassified;
        }
        field(118; "Approval By MD/CEO"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(119; "Approval By MD Date"; Date)
        {
            DataClassification = ToBeClassified;
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
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Employee Appraisal Nos.");
            //NoSeriesMgt.InitSeries(HRSetup."Employee Appraisal Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "User ID" := USERID;
        VALIDATE("User ID");
        //find and insert appraisal competency factors

        HRAppraisalGlobalCompetency.RESET;
        IF HRAppraisalGlobalCompetency.FINDFIRST THEN
            REPEAT
                LineNo += 10000;
                HRAppraisalCompetencyFactor.INIT;
                HRAppraisalCompetencyFactor."Appraisal No." := "No.";
                HRAppraisalCompetencyFactor."Line No." := LineNo;
                HRAppraisalCompetencyFactor."Assessment Factor" := HRAppraisalGlobalCompetency."Assesment Factor";
                HRAppraisalCompetencyFactor.INSERT;

            UNTIL HRAppraisalGlobalCompetency.NEXT = 0;
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
        HRAppraisalCompetencyFactor: Record 50191;
        HRAppraisalGlobalCompetency: Record 50193;
        LineNo: Integer;
}


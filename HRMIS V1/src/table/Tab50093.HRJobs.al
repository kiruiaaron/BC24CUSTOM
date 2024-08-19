/// <summary>
/// Table HR Jobs (ID 50093).
/// </summary>
table 50093 "HR Jobs"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }

        field(2; "Job Title"; Code[200])
        {
        }
        field(4; "Job Grade"; Code[50])
        {
            TableRelation = "HR Job Lookup Value".Code WHERE(Option = CONST("Job Grade"));
        }
        field(10; "Maximum Positions"; Integer)
        {
            MinValue = 0;

            trigger OnValidate()
            var
                ErrorMaximumPositions: Label 'The Maximum Position(s) cannot be Less than the Occupied Position(s):%1';
            begin
                CALCFIELDS("Occupied Positions");
                IF "Maximum Positions" < "Occupied Positions" THEN BEGIN
                    ERROR(ErrorMaximumPositions, "Occupied Positions");
                END ELSE BEGIN
                    "Vacant Positions" := "Maximum Positions" - "Occupied Positions";
                END;
            END;

        }
        field(11; "Occupied Positions"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(Employee WHERE("Job Title" = FIELD("No.")));


            trigger OnValidate()
            var
                ErrorVaccantPositions: Label 'The Vaccant Position(s) cannot exceed the Maximum Position(s) to be occupied for this Job.';
            begin
                CALCFIELDS("Occupied Positions");
                IF "Occupied Positions" > "Maximum Positions" THEN BEGIN
                    ERROR(ErrorVaccantPositions);
                END;
            end;
        }
        field(12; "Vacant Positions"; Integer)
        {
            Editable = false;
            MinValue = 0;
        }
        field(13; "Supervisor Job No."; Code[20])
        {
            /*
            TableRelation = "HR Jobs".No. WHERE (Status=CONST(Released));

            trigger OnValidate()
            begin
                "Supervisor Job Title":='';
                IF HRJob.GET("Supervisor Job No.") THEN BEGIN
                  "Supervisor Job Title":=HRJob."Job Title";
                END;
            end;
            *
            */
        }
        field(14; "Supervisor Job Title"; Code[50])
        {
            Editable = false;
        }
        field(15; "Appraisal Level"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Organizational,Departmental,Divisional,Individual';
            OptionMembers = " ",Organizational,Departmental,Divisional,Individual;
        }
        field(16; "Job Purpose"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Job Purpose Description 2"; Text[250])
        {
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
        field(59; Active; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Rejected;
        }
        field(99; "User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
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
        fieldgroup(DropDown; "No.", "Job Title")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            // HRSetup.GET;
            // HRSetup.TESTFIELD(HRSetup."Job Nos.");
            ////NoSeriesMgt.InitSeries(HRSetup."Job Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "User ID" := USERID;
    end;

    var
        //HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //HRJob: Record 50093;
        ErrorMaximumPositions: Label 'The Maximum Position(s) cannot be Less than the Occupied Position(s):%1';

    //      ErrorMaximumPositions: Label 'sfgsgsgsdfgsdf';
}


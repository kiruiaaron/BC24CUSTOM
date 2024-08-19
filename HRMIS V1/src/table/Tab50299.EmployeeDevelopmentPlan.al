table 50299 "Employee Development Plan"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                "Employee Name" := '';
                "Job Grade" := '';
                Designation := '';


                Employees.RESET;
                IF Employees.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name";
                    Designation := Employees."Job Title";

                    //Validate Dimensions
                    VALIDATE("Global Dimension 1 Code", Employees."Global Dimension 1 Code");
                    VALIDATE("Global Dimension 2 Code", Employees."Global Dimension 2 Code");
                    VALIDATE("Shortcut Dimension 3 Code", Employees."Shortcut Dimension 3 Code");



                END;
            end;
        }
        field(3; "Employee Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
        field(9; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(49; Description; Text[250])
        {
            DataClassification = ToBeClassified;

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
        field(100; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
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
        field(120; "Employee Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(121; "Supervisor Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(122; Progress; Text[250])
        {
            DataClassification = ToBeClassified;
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
            // HRSetup.TESTFIELD(HRSetup."Employee Development Plans");
            ////NoSeriesMgt.InitSeries(HRSetup."Employee Development Plans", xRec."No. Series", 0D, "No.", "No. Series");


        END;
    end;

    var
        Employees: Record 5200;
        DimensionValue: Record 349;
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}


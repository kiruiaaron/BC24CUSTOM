table 50275 Casuals
{

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "First Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Middle Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Surname; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "ID No"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Created by"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
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
            Editable = true;
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
            Editable = true;
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
        field(107; Department; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(108; Station; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(109; Section; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(110; "No of days worked"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Casuals Days worked" WHERE("Casual no" = FIELD(No)));
            Editable = false;

        }
        field(111; "Daily Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(112; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(113; "Total Number of Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(114; Month; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        HumanResourcesSetupRec.GET;
        IF No = '' THEN BEGIN
            //HumanResourcesSetupRec.TESTFIELD("Casuals Nos.");
            // //NoSeriesMgt.InitSeries(HumanResourcesSetupRec."Casuals Nos.",xRec."No. Series",0D,No,"No. Series");
        END;
        "Created by" := USERID;
    end;

    var
        HumanResourcesSetupRec: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Employee: Record 5200;
        DimensionValue: Record 349;
}


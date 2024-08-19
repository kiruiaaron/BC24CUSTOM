table 50276 "Casual Request Lines"
{

    fields
    {
        field(1; "Casual Request"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
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
        field(4; Station; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "No Requested"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Gross Amount" := ("No Requested" * "Unit Cost") + "Administrative Cost";
            end;
        }
        field(6; "Job Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Casual Job Titles";

            trigger OnValidate()
            begin
                IF CasualJobTitles.GET("Job Code") THEN BEGIN
                    "Unit Cost" := CasualJobTitles."Casual Cost";
                    "Administrative Cost" := CasualJobTitles."Administrative Cost";
                    "Gross Amount" := ("No Requested" * "Unit Cost") + "Administrative Cost";
                    "Job Title" := CasualJobTitles."Job Title";
                END;
            end;
        }
        field(7; "Job Title"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Gross Amount" := ("No Requested" * "Unit Cost") + "Administrative Cost";
            end;
        }
        field(9; "Administrative Cost"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Gross Amount" := ("No Requested" * "Unit Cost") + "Administrative Cost";
            end;
        }
        field(10; "Gross Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Casual Request", "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimensionValue: Record 349;
        CasualJobTitles: Record 50311;
}


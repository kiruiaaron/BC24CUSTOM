table 50246 "Compensation Plan Dept Line"
{

    fields
    {
        field(1; "Compensation Plan code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Compensation Plan".Code;
        }
        field(2; "ED code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ED Definitions"."ED Code";

            trigger OnValidate()
            begin
                EDDefinitions.GET("ED code");
                "Ed Description" := EDDefinitions.Description;
            end;
        }
        field(3; "Ed Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            var
                DimensionValue: Record 349;
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.", 1);
                DimensionValue.SETRANGE(Code, "Global Dimension 1 Code");
                IF DimensionValue.FINDFIRST THEN
                    "Department Name" := DimensionValue.Name
            end;
        }
        field(5; "Department Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Amount Planned"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Compensation Plan code", "ED code", "Global Dimension 1 Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EDDefinitions: Record 51158;
}


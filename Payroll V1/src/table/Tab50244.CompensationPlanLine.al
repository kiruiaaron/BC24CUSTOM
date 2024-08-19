table 50244 "Compensation Plan Line"
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
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Payments));

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
        field(6; "Total Amount Planned"; Decimal)
        {
            CalcFormula = Sum("Compensation Plan Dept Line"."Amount Planned" WHERE("Compensation Plan code" = FIELD("Compensation Plan code"),
                                                                                    "ED code" = FIELD("ED code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Compensation Plan code", "ED code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EDDefinitions: Record 51158;
}


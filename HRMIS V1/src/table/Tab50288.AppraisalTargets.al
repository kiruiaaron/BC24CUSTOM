table 50288 "Appraisal Targets"
{

    fields
    {
        field(1; "Header No";
        Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Appraisal Header";
        }
        field(2; "Criteria code";
        Integer)
        {
            Caption = 'KPI Code';
            DataClassification = ToBeClassified;
        }
        field(3; "Performance Targets"; Text[250])
        {
            Caption = 'Performance Activity';
            DataClassification = ToBeClassified;
        }
        field(4; Indicator; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; UOM; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Targeted Score"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Targeted Score" WHERE("Header No" = FIELD("Header No"),
                                                                             "Criteria code" = FIELD("Criteria code"),
                                                                             "Target Code" = FIELD("Target Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Achieved Score"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score" WHERE("Header No" = FIELD("Header No"),
                                                                             "Criteria code" = FIELD("Criteria code"),
                                                                             "Target Code" = FIELD("Target Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; Weights; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Timelines; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Target Code"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Activity Code';
            DataClassification = ToBeClassified;
        }
        field(12; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Targeted Score EY"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Targeted Score" WHERE("Header No" = FIELD("Header No"),
                                                                             "Criteria code" = FIELD("Criteria code"),
                                                                             "Target Code" = FIELD("Target Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Achieved Score EY"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score EY" WHERE("Header No" = FIELD("Header No"),
                                                                                "Criteria code" = FIELD("Criteria code"),
                                                                                "Target Code" = FIELD("Target Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Achieved Score Employee"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score Employee" WHERE("Header No" = FIELD("Header No"),
                                                                                      "Criteria code" = FIELD("Criteria code"),
                                                                                      "Target Code" = FIELD("Target Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Achieved Score Supervisor"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score Supervisor" WHERE("Header No" = FIELD("Header No"),
                                                                                        "Criteria code" = FIELD("Criteria code"),
                                                                                        "Target Code" = FIELD("Target Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Achieved Score EY Employee"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score EY Employee" WHERE("Header No" = FIELD("Header No"),
                                                                                         "Criteria code" = FIELD("Criteria code"),
                                                                                         "Target Code" = FIELD("Target Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Achieved Score EY Supervisor"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score EY Supervisor" WHERE("Header No" = FIELD("Header No"),
                                                                                           "Criteria code" = FIELD("Criteria code"),
                                                                                           "Target Code" = FIELD("Target Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Header No", "Criteria code", "Target Code")
        {
        }
    }

    fieldgroups
    {
    }
}


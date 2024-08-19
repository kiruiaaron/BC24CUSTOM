table 50285 "Appraisal KPI"
{

    fields
    {
        field(1; "Header No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Appraisal Header";
        }
        field(2; "Criteria code"; Integer)
        {
            AutoIncrement = false;
            Caption = 'KPI Code';
            DataClassification = ToBeClassified;
        }
        field(3; "Performance Criteria"; Text[250])
        {
            Caption = 'Performance Indicator';
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
                                                                             "Criteria code" = FIELD("Criteria code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Achieved Score"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score" WHERE("Header No" = FIELD("Header No"),
                                                                             "Criteria code" = FIELD("Criteria code")));
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
        field(10; "Indicator Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Jobs";
        }
        field(14; "Objective Weightage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Achieved Score EY"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score EY" WHERE("Header No" = FIELD("Header No"),
                                                                                "Criteria code" = FIELD("Criteria code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Achieved Score EY Supervisor"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score EY Supervisor" WHERE("Header No" = FIELD("Header No"),
                                                                                           "Criteria code" = FIELD("Criteria code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Achieved Score EY Employee"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score EY Employee" WHERE("Header No" = FIELD("Header No"),
                                                                                         "Criteria code" = FIELD("Criteria code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Achieved Score Employee"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score Employee" WHERE("Header No" = FIELD("Header No"),
                                                                                      "Criteria code" = FIELD("Criteria code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Achieved Score Supervisor"; Decimal)
        {
            CalcFormula = Sum("Appraisal Indicators"."Achieved Score Supervisor" WHERE("Header No" = FIELD("Header No"),
                                                                                        "Criteria code" = FIELD("Criteria code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "weighted Results Employee"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Weighted Results Supervisor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Overall Weighted Results"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Header No", "Criteria code")
        {
        }
    }

    fieldgroups
    {
    }

    procedure CalculateWeightResults(HeaderNo: Code[20]) ok: Boolean
    var
        AppraisalKPIRec: Record 50285;
    begin
        IF HeaderNo <> '' THEN BEGIN
            AppraisalKPIRec.RESET;
            AppraisalKPIRec.SETRANGE("Header No", HeaderNo);
            IF AppraisalKPIRec.FINDFIRST THEN
                REPEAT
                    AppraisalKPIRec.CALCFIELDS("Achieved Score Employee");
                    AppraisalKPIRec."weighted Results Employee" := AppraisalKPIRec."Achieved Score Employee" * AppraisalKPIRec."Objective Weightage" / 100;
                    IF AppraisalKPIRec.MODIFY THEN
                        ok := TRUE;
                UNTIL AppraisalKPIRec.NEXT = 0;

        END
    end;
}


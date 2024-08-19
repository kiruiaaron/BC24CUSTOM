table 50283 "Appraisal Indicators"
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
            Caption = 'KPI Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Appraisal KPI"."Criteria code";
        }
        field(3; "Performance Targets"; Text[250])
        {
            Caption = 'Performance Activity';
            DataClassification = ToBeClassified;
        }
        field(4; "Specific Indicator"; Text[250])
        {
            Caption = 'Specific Standard';
            DataClassification = ToBeClassified;
        }
        field(5; "Unit of Measurement"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(6; "Targeted Score"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // EmployeeAppraisalHeaderRec.GET("Header No");
                // EmployeeAppraisalHeaderRec.TESTFIELD("Appraisal Stage",EmployeeAppraisalHeaderRec."Appraisal Stage"::"Target Setting");
            end;
        }
        field(7; "Achieved Score Employee"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Achieved Score Employee" > "Targeted Score" THEN
                    ERROR('Achieved score cannot be greater than targeted score');
            end;
        }
        field(8; Weights; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Target Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Indicator Code"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Standard Code';
            DataClassification = ToBeClassified;
        }
        field(11; "Target Code"; Integer)
        {
            Caption = 'Activity Code';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF AppraisalTargets.GET("Header No", "Criteria code", "Target Code") THEN
                    "Performance Targets" := AppraisalTargets."Performance Targets"
            end;
        }
        field(12; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Achieved Score Supervisor"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Achieved Score Supervisor" > "Targeted Score" THEN
                    ERROR('Achieved score cannot be greater than targeted score %1', "Targeted Score");
            end;
        }
        field(14; "Supervisor Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Achieved Score EY Employee"; Decimal)
        {
            Caption = 'Achieved Score End Year';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Achieved Score EY Employee" > "Target Score EY" THEN
                    ERROR('Achieved score cannot be greater than targeted score %1', "Target Score EY");
            end;
        }
        field(16; "Achieved Score EY Supervisor"; Decimal)
        {
            Caption = 'Achieved Score End Year- Supervisor';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Achieved Score EY Supervisor" > "Targeted Score" THEN
                    ERROR('Achieved score cannot be greater than targeted score %1', "Targeted Score");
            end;
        }
        field(17; "Supervisor Comments EY"; Text[250])
        {
            Caption = 'Supervisor Comments End Year';
            DataClassification = ToBeClassified;
        }
        field(18; "Achieved Score"; Decimal)
        {
            Caption = 'Achieved Score';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Achieved Score" > "Targeted Score" THEN
                    ERROR('Achieved score cannot be greater than targeted score %1', "Targeted Score");
            end;
        }
        field(19; "Achieved Score EY"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Achieved Score EY" > "Target Score EY" THEN
                    ERROR('Achieved score cannot be greater than targeted score %1', "Target Score EY");
            end;
        }
        field(20; "Target Score EY"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Employee Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Header No", "Criteria code", "Target Code", "Indicator Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF AppraisalTargets.GET("Header No", "Criteria code", "Target Code") THEN
            "Performance Targets" := AppraisalTargets."Performance Targets"
    end;

    var
        AppraisalTargets: Record 50288;
        EmployeeAppraisalHeaderRec: Record 50281;
}


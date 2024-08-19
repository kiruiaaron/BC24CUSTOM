

/// <summary>
/// 
/// 
/// Table HR Appraisal Objective (ID 50147).
/// </summary>
table 50147 "HR Appraisal Objective"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Global Objectives".Code;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Objective Weight"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TotalObjectiveWeight := 0;
                HRAppraisalObjective.RESET;
                IF HRAppraisalObjective.FINDSET THEN BEGIN
                    REPEAT
                        TotalObjectiveWeight := TotalObjectiveWeight + HRAppraisalObjective."Objective Weight";
                    UNTIL HRAppraisalObjective.NEXT = 0;
                END;
                TotalObjectiveWeight := TotalObjectiveWeight + "Objective Weight";
                IF TotalObjectiveWeight > 100 THEN
                    ERROR(Txt_001);
            end;
        }
        field(4; "Appraisal Period"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Calendar Period".Code;
        }
        field(10; "Deparment Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value"."Dimension Code" WHERE("Global Dimension No." = CONST(2));
        }
        field(11; "Appraisal Score Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Core,"Non-Core";
        }
    }

    keys
    {
        key(Key1; "Code", "Appraisal Period", "Deparment Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        TotalObjectiveWeight: Decimal;
        HRAppraisalObjective: Record "HR Appraisal Objective";
        Txt_001: Label 'The Objective weight should not exceed 100%! Please check';
}


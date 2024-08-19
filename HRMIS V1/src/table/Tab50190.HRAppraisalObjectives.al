table 50190 "HR Appraisal Objectives"
{

    fields
    {
        field(1;"Appraisal No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Line No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Appraisal Objective";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Score;Decimal)
        {
            Caption = 'Score (4-1)';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF Score>4 THEN
                  ERROR('Upper Limit Exceeded');
                IF Score<0 THEN
                  ERROR('Lower Limit Exceeded');
            end;
        }
        field(5;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Appraisal No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


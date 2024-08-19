table 50231 "HR Appraisal Recommendation"
{
    Caption = 'HR Appraisal Recommendation';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Appraisal No."; Code[20])
        {
            Caption = 'Appraisal No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Appraisal No.")
        {
            Clustered = true;
        }
    }
}

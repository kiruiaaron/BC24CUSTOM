table 50059 "Tender Evaluation Line"
{

    fields
    {
        field(10; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document No.";
        Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Tender No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Question; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Marks; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF Marks > 100 THEN ERROR(NotExceed);
            end;
        }
        field(15; "Marks Assigned"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //IF "Marks Assigned">Marks THEN
                // ERROR(AssignedMarks);
            end;
        }
        field(16; Comments; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Supplier Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; Evaluator; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Evaluator Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Evaluator User ID"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AssignedMarks: Label 'Marks assigned cannot be higher than the set Maximum marks per question';
        NotExceed: Label 'Marks should not exceed 100%';
}


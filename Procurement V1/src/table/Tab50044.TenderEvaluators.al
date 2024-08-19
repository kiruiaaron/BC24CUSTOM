table 50044 "Tender Evaluators"
{

    fields
    {
        field(9; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(10; "Tender No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Evaluator; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF HREmployee.GET(Evaluator) THEN
                    "Evaluator Name" := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";
                //    "User ID" := HREmployee."User ID";
                "E-Mail" := HREmployee."E-Mail";
                IF HREmployee."E-Mail" = '' THEN
                    "E-Mail" := HREmployee."Company E-Mail";
            end;
        }
        field(12; "Evaluator Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "User ID"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "E-Mail"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Committee Chairperson"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                TenderEvaluators.RESET;
                TenderEvaluators.SETRANGE("Tender No", "Tender No");
                TenderEvaluators.SETRANGE("Committee Chairperson", TRUE);
                IF TenderEvaluators.FINDSET THEN BEGIN
                    REPEAT
                        TenderEvaluators."Committee Chairperson" := FALSE;
                        TenderEvaluators.MODIFY;
                    UNTIL TenderEvaluators.NEXT = 0;
                END;


                "Committee Chairperson" := TRUE;
            end;
        }
    }

    keys
    {
        key(Key1; "Tender No", "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HREmployee: Record 5200;
        TenderEvaluators: Record 50044;
        Txt10001: Label 'You cannot have two people having the Chaiperson role. Thank you!';
}


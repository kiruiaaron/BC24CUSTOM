table 50057 "Tender Evaluation Results"
{

    fields
    {
        field(10; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(11; "Tender No."; Code[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*TenderHeader.RESET;
                TenderHeader.SETRANGE();
                IF TenderHeader.FINDFIRST THEN BEGIN
                  tende
                  END;
                */

            end;
        }
        field(13; Question; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Marks; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Supplier Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; Score; Decimal)
        {
            CalcFormula = Sum("Tender Evaluation Line".Marks WHERE("Tender No." = FIELD("Tender No."),
                                                                    "Supplier Name" = FIELD("Supplier Name")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Tender Evaluation Line".Marks WHERE("Tender No." = FIELD("Tender No."),
                                                                 "Supplier Name" = FIELD("Supplier Name"));
        }
        field(17; "Average"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; Position; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Drop Supplier"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Reason for Disqualification");

                TenderLines.RESET;
                TenderLines.SETRANGE(TenderLines."Document No.", "Tender No.");
                TenderLines.SETRANGE(TenderLines."Supplier Name", "Supplier Name");
                IF TenderLines.FINDFIRST THEN BEGIN
                    TenderLines.Disqualified := "Drop Supplier";
                    TenderLines."Reason for Disqualification" := "Reason for Disqualification";
                    TenderLines.MODIFY;
                END;
            end;
        }
        field(20; "Reason for Disqualification"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Count Evaluators"; Integer)
        {
            CalcFormula = Count("Tender Evaluators" WHERE("Tender No" = FIELD("Tender No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Tender No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        TenderHeader: Record 50055;
        TenderLines: Record 50056;
}


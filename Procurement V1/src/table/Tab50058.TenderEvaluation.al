table 50058 "Tender Evaluation"
{

    fields
    {
        field(10; "Evaluation No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Tender No."; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tender Header"."No." WHERE("Tender Status" = FILTER("Tender Evaluation"));

            trigger OnValidate()
            begin

                Rec.TESTFIELD(Status, Rec.Status::Open);
                IF "Evaluation No." = '' THEN BEGIN
                    "Purchases&PayablesSetup".GET;
                    // "Purchases&PayablesSetup".TESTFIELD("Purchases&PayablesSetup"."Tender Evaluation No.");
                    //  "Evaluation No." := NoSeriesMgt.GetNextNo("Purchases&PayablesSetup"."Tender Evaluation No.", TODAY, TRUE);
                    ////NoSeriesMgt.InitSeries("Purchases&PayablesSetup"."Tender Evaluation No.",xRec."No. Series",0D,"Evaluation No.","No. Series");
                END;
                "Tender Date" := 0D;
                "Tender Close Date" := 0D;


                TenderEvaluationLine.RESET;
                TenderEvaluationLine.SETRANGE(TenderEvaluationLine."Document No.", "Evaluation No.");
                IF TenderEvaluationLine.FINDSET THEN BEGIN
                    TenderEvaluationLine.DELETEALL;
                END;
                /*
                TenderEvaluators.RESET;
                TenderEvaluators.SETRANGE(TenderEvaluators."Tender No","Tender No.");
                TenderEvaluators.SETRANGE(TenderEvaluators."User ID","User ID");
                IF NOT TenderEvaluators.FINDFIRST THEN
                  ERROR(Txt10002);
                  */

                TenderHeader.RESET;
                TenderHeader.SETRANGE(TenderHeader."No.", "Tender No.");
                IF TenderHeader.FINDFIRST THEN BEGIN
                    "Tender Date" := TenderHeader."Tender Submission (From)";
                    "Tender Close Date" := TenderHeader."Tender Closing Date";
                END;

                /*TenderQuestions.RESET;
                TenderQuestions.SETRANGE(TenderQuestions."Tender No.","Tender No.");
                IF TenderQuestions.FINDSET THEN BEGIN
                  REPEAT
                    LineNo:=LineNo+1;
                    TenderEvaluationLine.INIT;
                    TenderEvaluationLine."Line No.":=LineNo;
                    TenderEvaluationLine."Document No.":="Evaluation No.";
                    TenderEvaluationLine."Tender No.":=TenderQuestions."Tender No.";
                    TenderEvaluationLine.Question:=TenderQuestions.Question;
                    TenderEvaluationLine.Marks:=TenderQuestions.Marks;
                    TenderEvaluationLine.INSERT
                  UNTIL TenderQuestions.NEXT=0;
                END;
                */

                TenderLines.RESET;
                TenderLines.SETRANGE("Document No.", "Tender No.");
                TenderLines.SETRANGE(Disqualified, FALSE);
                IF TenderLines.FINDSET THEN BEGIN
                    REPEAT
                        TenderEvaluators.RESET;
                        TenderEvaluators.SETRANGE(TenderEvaluators."Tender No", "Tender No.");
                        IF TenderEvaluators.FINDSET THEN BEGIN
                            REPEAT
                                LineNo := LineNo + 1;
                                TenderEvaluationLine.INIT;
                                TenderEvaluationLine."Line No." := LineNo;
                                TenderEvaluationLine."Document No." := "Evaluation No.";
                                TenderEvaluationLine."Tender No." := TenderEvaluators."Tender No";
                                TenderEvaluationLine."Supplier Name" := TenderLines."Supplier Name";
                                TenderEvaluationLine.Evaluator := TenderEvaluators.Evaluator;
                                TenderEvaluationLine."Evaluator Name" := TenderEvaluators."Evaluator Name";
                                TenderEvaluationLine."Evaluator User ID" := TenderEvaluators."User ID";
                                TenderEvaluationLine.INSERT
                            UNTIL TenderEvaluators.NEXT = 0;
                        END;
                    UNTIL TenderLines.NEXT = 0;
                END;

            end;
        }
        field(12; "Tender Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Tender Close Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Evaluation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; Supplier; Text[80])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tender Lines"."Supplier Name" WHERE("Document No." = FIELD("Tender No."));

            trigger OnValidate()
            begin
                TESTFIELD("Tender No.");
            end;
        }
        field(16; Marks; Decimal)
        {
            CalcFormula = Sum("Tender Evaluation Line"."Marks Assigned" WHERE("Document No." = FIELD("Evaluation No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "User ID"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(32; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Submitted';
            OptionMembers = Open,"Pending Approval",Approved,Submitted;
        }
        field(33; "Evaluation Criteria"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Procurement Lookup Values".Code WHERE("Type" = CONST());

            trigger OnValidate()
            begin
                TESTFIELD("Tender No.");

                TenderEvaluation.RESET;
                //TenderEvaluation.SETRANGE(TenderEvaluation."Evaluation No.","Evaluation No.");
                TenderEvaluation.SETRANGE(TenderEvaluation."Tender No.", "Tender No.");
                TenderEvaluation.SETRANGE(TenderEvaluation."User ID", "User ID");
                TenderEvaluation.SETRANGE(TenderEvaluation."Evaluation Criteria", "Evaluation Criteria");
                IF TenderEvaluation.FINDFIRST THEN
                    ERROR(Text10001, TenderEvaluation."Evaluation No.");
            end;
        }
    }

    keys
    {
        key(Key1; "Evaluation No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Evaluation No." = '' THEN BEGIN
            "Purchases&PayablesSetup".GET;
            // "Purchases&PayablesSetup".TESTFIELD("Purchases&PayablesSetup"."Tender Evaluation No.");
            // //NoSeriesMgt.InitSeries("Purchases&PayablesSetup"."Tender Evaluation No.",xRec."No. Series",0D,"Evaluation No.","No. Series");
        END;

        "Evaluation Date" := TODAY;
        "Document Date" := TODAY;
        "User ID" := USERID;
    end;

    var
        "Purchases&PayablesSetup": Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TenderHeader: Record 50055;
        TenderLines: Record 50056;
        TenderEvaluationLine: Record 50059;
        TenderQuestions: Record 50057;
        LineNo: Integer;
        TenderEvaluators: Record 50044;
        TenderEvaluation: Record 50058;
        Text10001: Label 'The evaluation criteria has already been used in tender evaluation %1';
        Txt10002: Label 'You are not part of the evaluation Committe for this tender. Consult Procurement!';
}


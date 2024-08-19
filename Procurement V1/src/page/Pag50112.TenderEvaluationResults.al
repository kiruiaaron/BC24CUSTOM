page 50112 "Tender Evaluation Results"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50057;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ApplicationArea = All;
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = All;
                }
                field(Average; Rec.Average)
                {
                    ApplicationArea = All;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                }
                field("Drop Supplier"; Rec."Drop Supplier")
                {
                    ApplicationArea = All;
                }
                field("Reason for Disqualification"; Rec."Reason for Disqualification")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Average Mark")
            {
                Image = BreakRulesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TenderEvaluationResults.RESET;
                    TenderEvaluationResults.SETRANGE(TenderEvaluationResults."Tender No.", Rec."Tender No.");
                    TenderEvaluationResults.SETFILTER(TenderEvaluationResults.Score, '<>%1', 0);
                    TenderEvaluationResults.SETFILTER(TenderEvaluationResults."Count Evaluators", '<>%1', 0);
                    IF TenderEvaluationResults.FINDSET THEN BEGIN
                        REPEAT
                            TenderEvaluationResults.CALCFIELDS(TenderEvaluationResults.Score);
                            TenderEvaluationResults.CALCFIELDS(TenderEvaluationResults."Count Evaluators");
                            TenderEvaluationResults.Average := (TenderEvaluationResults.Score / TenderEvaluationResults."Count Evaluators");
                            // MESSAGE(FORMAT(TenderEvaluationResults.Score));
                            // MESSAGE(FORMAT(TenderEvaluationResults."Count Evaluators"));
                            TenderEvaluationResults.MODIFY;
                        UNTIL TenderEvaluationResults.NEXT = 0;
                    END;

                    COMMIT;
                    Rec.Position := 1;
                    TenderEvaluationResults.RESET;
                    TenderEvaluationResults.SETRANGE("Tender No.", Rec."Tender No.");
                    TenderEvaluationResults.SETCURRENTKEY(Average);
                    TenderEvaluationResults.SETASCENDING(Average, FALSE);
                    IF TenderEvaluationResults.FINDSET THEN BEGIN
                        ProgressWindow.OPEN('Ranking for Supplier no. #1#######');
                        REPEAT
                            TenderEvaluationResults.Position := Rec.Position;
                            TenderEvaluationResults.MODIFY;
                            Rec.Position := Rec.Position + 1;
                            ProgressWindow.UPDATE(1, TenderEvaluationResults."Supplier Name");
                        UNTIL TenderEvaluationResults.NEXT = 0;
                    END;
                    ProgressWindow.CLOSE;

                    MESSAGE('Complete!');
                end;
            }
        }
    }

    var
        TenderEvaluationLine: Record 50059;
        TenderEvaluationResults: Record 50057;
        ProgressWindow: Dialog;
}


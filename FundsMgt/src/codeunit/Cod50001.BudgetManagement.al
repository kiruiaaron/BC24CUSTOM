codeunit 50001 "Budget Management"
{

    trigger OnRun()
    begin
    end;

    local procedure UpdateGLBudgetEntries()
    begin
    end;

    local procedure CheckBudgetForImprest("Imprest No.": Code[20]; "Imprest Line No.": Integer) BudgetAvailable: Boolean
    var
        ImprestHeader: Record 50008;
        ImprestLine: Record 50009;
    begin
        BudgetAvailable := FALSE;
        IF ImprestLine.FINDFIRST THEN BEGIN
        END;
    end;
}


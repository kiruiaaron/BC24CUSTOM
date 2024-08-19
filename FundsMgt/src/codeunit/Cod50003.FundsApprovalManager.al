codeunit 50003 "Funds Approval Manager"
{

    trigger OnRun()
    begin
    end;

    procedure ReleasePaymentHeader(var "Payment Header": Record 50002)
    var
        PaymentHeader: Record 50002;
    begin
        PaymentHeader.RESET;
        PaymentHeader.SETRANGE(PaymentHeader."No.", "Payment Header"."No.");
        IF PaymentHeader.FINDFIRST THEN BEGIN
            PaymentHeader.Status := PaymentHeader.Status::Approved;
            PaymentHeader.VALIDATE(PaymentHeader.Status);
            PaymentHeader.MODIFY;
        END;
    end;

    procedure ReOpenPaymentHeader(var "Payment Header": Record 50002)
    var
        PaymentHeader: Record 50002;
    begin
        PaymentHeader.RESET;
        PaymentHeader.SETRANGE(PaymentHeader."No.", "Payment Header"."No.");
        IF PaymentHeader.FINDFIRST THEN BEGIN
            PaymentHeader.Status := PaymentHeader.Status::Open;
            PaymentHeader.VALIDATE(PaymentHeader.Status);
            PaymentHeader.MODIFY;
        END;
    end;

    procedure ReleaseReceiptHeader(var "Receipt Header": Record 50004)
    var
        ReceiptHeader: Record 50004;
    begin
        ReceiptHeader.RESET;
        ReceiptHeader.SETRANGE(ReceiptHeader."No.", "Receipt Header"."No.");
        IF ReceiptHeader.FINDFIRST THEN BEGIN
            ReceiptHeader.Status := ReceiptHeader.Status::Released;
            ReceiptHeader.VALIDATE(ReceiptHeader.Status);
            ReceiptHeader.MODIFY;
        END;
    end;

    procedure ReOpenReceiptHeader(var "Receipt Header": Record 50004)
    var
        ReceiptHeader: Record 50004;
    begin
        ReceiptHeader.RESET;
        ReceiptHeader.SETRANGE(ReceiptHeader."No.", "Receipt Header"."No.");
        IF ReceiptHeader.FINDFIRST THEN BEGIN
            ReceiptHeader.Status := ReceiptHeader.Status::Open;
            ReceiptHeader.VALIDATE(ReceiptHeader.Status);
            ReceiptHeader.MODIFY;
        END;
    end;

    procedure ReleaseFundsTransferHeader(var "Funds Transfer Header": Record 50006)
    var
        FundsTransferHeader: Record 50006;
    begin
        FundsTransferHeader.RESET;
        FundsTransferHeader.SETRANGE(FundsTransferHeader."No.", "Funds Transfer Header"."No.");
        IF FundsTransferHeader.FINDFIRST THEN BEGIN
            FundsTransferHeader.Status := FundsTransferHeader.Status::Released;
            FundsTransferHeader.VALIDATE(FundsTransferHeader.Status);
            FundsTransferHeader.MODIFY;
        END;
    end;

    procedure ReOpenFundsTransferHeader(var "Funds Transfer Header": Record 50006)
    var
        FundsTransferHeader: Record 50006;
    begin
        FundsTransferHeader.RESET;
        FundsTransferHeader.SETRANGE(FundsTransferHeader."No.", "Funds Transfer Header"."No.");
        IF FundsTransferHeader.FINDFIRST THEN BEGIN
            FundsTransferHeader.Status := FundsTransferHeader.Status::Open;
            FundsTransferHeader.VALIDATE(FundsTransferHeader.Status);
            FundsTransferHeader.MODIFY;
        END;
    end;

    procedure ReleaseImprestHeader(var "Imprest Header": Record 50008)
    var
        ImprestHeader: Record 50008;
    begin
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", "Imprest Header"."No.");
        IF ImprestHeader.FINDFIRST THEN BEGIN
            ImprestHeader.Status := ImprestHeader.Status::Approved;
            ImprestHeader.VALIDATE(ImprestHeader.Status);
            ImprestHeader.MODIFY;
        END;
    end;

    procedure ReOpenImprestHeader(var "Imprest Header": Record 50008)
    var
        ImprestHeader: Record 50008;
    begin
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", "Imprest Header"."No.");
        IF ImprestHeader.FINDFIRST THEN BEGIN
            ImprestHeader.Status := ImprestHeader.Status::Open;
            ImprestHeader.VALIDATE(ImprestHeader.Status);
            ImprestHeader.MODIFY;
        END;
    end;

    procedure ReleaseImprestSurrenderHeader(var "Imprest Surrender Header": Record 50010)
    var
        ImprestSurrenderHeader: Record 50010;
    begin
        ImprestSurrenderHeader.RESET;
        ImprestSurrenderHeader.SETRANGE(ImprestSurrenderHeader."No.", "Imprest Surrender Header"."No.");
        IF ImprestSurrenderHeader.FINDFIRST THEN BEGIN
            ImprestSurrenderHeader.Status := ImprestSurrenderHeader.Status::Released;
            ImprestSurrenderHeader.VALIDATE(ImprestSurrenderHeader.Status);
            ImprestSurrenderHeader.MODIFY;
        END;
    end;

    procedure ReOpenImprestSurrenderHeader(var "Imprest Surrender Header": Record 50010)
    var
        ImprestSurrenderHeader: Record 50010;
    begin
        ImprestSurrenderHeader.RESET;
        ImprestSurrenderHeader.SETRANGE(ImprestSurrenderHeader."No.", "Imprest Surrender Header"."No.");
        IF ImprestSurrenderHeader.FINDFIRST THEN BEGIN
            ImprestSurrenderHeader.Status := ImprestSurrenderHeader.Status::Open;
            ImprestSurrenderHeader.VALIDATE(ImprestSurrenderHeader.Status);
            ImprestSurrenderHeader.MODIFY;
        END;
    end;

    procedure ReleaseFundsClaim(var "Funds Claim Header": Record 50012)
    var
        FundsClaimHeader: Record 50012;
    begin
        FundsClaimHeader.RESET;
        FundsClaimHeader.SETRANGE(FundsClaimHeader."No.", "Funds Claim Header"."No.");
        IF FundsClaimHeader.FINDFIRST THEN BEGIN
            FundsClaimHeader.Status := FundsClaimHeader.Status::Released;
            FundsClaimHeader.VALIDATE(FundsClaimHeader.Status);
            FundsClaimHeader.MODIFY;
        END;
    end;

    procedure ReOpenFundsClaim(var "Funds Claim Header": Record 50012)
    var
        FundsClaimHeader: Record 50012;
    begin
        FundsClaimHeader.RESET;
        FundsClaimHeader.SETRANGE(FundsClaimHeader."No.", "Funds Claim Header"."No.");
        IF FundsClaimHeader.FINDFIRST THEN BEGIN
            FundsClaimHeader.Status := FundsClaimHeader.Status::Open;
            FundsClaimHeader.VALIDATE(FundsClaimHeader.Status);
            FundsClaimHeader.MODIFY;
        END;
    end;

    procedure ReleaseDocumentReversal(var DocumentReversalHeader: Record 50034)
    var
        DocumentReversalHeaders: Record 50034;
    begin
        DocumentReversalHeader.RESET;
        DocumentReversalHeader.SETRANGE(DocumentReversalHeader."No.", DocumentReversalHeaders."No.");
        IF DocumentReversalHeader.FINDFIRST THEN BEGIN
            DocumentReversalHeader.Status := DocumentReversalHeader.Status::Approved;
            DocumentReversalHeader.VALIDATE(DocumentReversalHeader.Status);
            DocumentReversalHeader.MODIFY;
        END;
    end;

    procedure ReOpenDocumentReversal(var DocumentReversalHeader: Record 50034)
    var
        DocumentReversalHeaders: Record 50034;
    begin
        DocumentReversalHeader.RESET;
        DocumentReversalHeader.SETRANGE(DocumentReversalHeader."No.", DocumentReversalHeaders."No.");
        IF DocumentReversalHeader.FINDFIRST THEN BEGIN
            DocumentReversalHeader.Status := DocumentReversalHeader.Status::Open;
            DocumentReversalHeader.VALIDATE(DocumentReversalHeader.Status);
            DocumentReversalHeader.MODIFY;
        END;
    end;

    procedure ReleaseJournalVoucher(var "Journal Voucher": Record 50016)
    var
        JournalVoucherHeader: Record 50016;
    begin
        JournalVoucherHeader.RESET;
        JournalVoucherHeader.SETRANGE(JournalVoucherHeader."JV No.", "Journal Voucher"."JV No.");
        IF JournalVoucherHeader.FINDFIRST THEN BEGIN
            JournalVoucherHeader.Status := JournalVoucherHeader.Status::Approved;
            JournalVoucherHeader.VALIDATE(JournalVoucherHeader.Status);
            // JournalVoucherHeader.MODIFY;
        END;
    end;

    procedure ReOpenJournalVoucher(var "Journal Voucher": Record 50016)
    var
        JournalVoucherHeader: Record 50016;
    begin
        JournalVoucherHeader.RESET;
        JournalVoucherHeader.SETRANGE(JournalVoucherHeader."JV No.", "Journal Voucher"."JV No.");
        IF JournalVoucherHeader.FINDFIRST THEN BEGIN
            JournalVoucherHeader.Status := JournalVoucherHeader.Status::Open;
            JournalVoucherHeader.VALIDATE(JournalVoucherHeader.Status);
            JournalVoucherHeader.MODIFY;
        END;
    end;

    procedure ReleaseSalaryAdvance(var SalaryAdvance: Record 50239)
    var
        SalaryAdvanceRec: Record 50239;
    begin
        SalaryAdvanceRec.RESET;
        SalaryAdvanceRec.SETRANGE(SalaryAdvanceRec."Loan ID", SalaryAdvance."Loan ID");
        IF SalaryAdvanceRec.FINDFIRST THEN BEGIN
            SalaryAdvanceRec.Status := SalaryAdvanceRec.Status::Approved;
            SalaryAdvanceRec.VALIDATE(SalaryAdvanceRec.Status);
            SalaryAdvanceRec.MODIFY;
        END;
    end;

    procedure ReOpenSalaryAdvance(var SalaryAdvance: Record 50239)
    var
        SalaryAdvanceRec: Record 50239;
    begin
        SalaryAdvanceRec.RESET;
        SalaryAdvanceRec.SETRANGE(SalaryAdvanceRec."Loan ID", SalaryAdvance."Loan ID");
        IF SalaryAdvanceRec.FINDFIRST THEN BEGIN
            SalaryAdvanceRec.Status := SalaryAdvanceRec.Status::Open;
            SalaryAdvanceRec.VALIDATE(SalaryAdvanceRec.Status);
            SalaryAdvanceRec.MODIFY;
        END;
    end;

    /*  procedure ReOpenTransferAllowanceHeader(var TransferAllowanceHeader: Record 50240)
     var
         TransferAllowanceHeaderRec: Record 50240;
     begin
         TransferAllowanceHeaderRec.RESET;
         TransferAllowanceHeaderRec.SETRANGE(TransferAllowanceHeaderRec."Request No.", TransferAllowanceHeader."Request No.");
         IF TransferAllowanceHeaderRec.FINDFIRST THEN BEGIN
             TransferAllowanceHeaderRec.Status := TransferAllowanceHeaderRec.Status::"0";
             TransferAllowanceHeaderRec.VALIDATE(TransferAllowanceHeaderRec.Status);
             TransferAllowanceHeaderRec.MODIFY;
         END;
     end; */
}


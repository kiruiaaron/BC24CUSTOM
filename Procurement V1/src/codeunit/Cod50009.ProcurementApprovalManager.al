codeunit 50009 "Procurement Approval Manager"
{

    trigger OnRun()
    begin
    end;

    procedure ReleasePurchaseRequisitionHeader(var "Purchase Requisition Header": Record 50046)
    var
        PurchaseRequisitionHeader: Record 50046;
    begin
        PurchaseRequisitionHeader.RESET;
        PurchaseRequisitionHeader.SETRANGE(PurchaseRequisitionHeader."No.", "Purchase Requisition Header"."No.");
        IF PurchaseRequisitionHeader.FINDFIRST THEN BEGIN
            PurchaseRequisitionHeader.Status := PurchaseRequisitionHeader.Status::Approved;
            PurchaseRequisitionHeader.VALIDATE(PurchaseRequisitionHeader.Status);
            PurchaseRequisitionHeader.MODIFY;
        END;
    end;

    procedure ReOpenPurchaseRequisitionHeader(var "Purchase Requisition Header": Record 50046)
    var
        PurchaseRequisitionHeader: Record 50046;
    begin
        PurchaseRequisitionHeader.RESET;
        PurchaseRequisitionHeader.SETRANGE(PurchaseRequisitionHeader."No.", "Purchase Requisition Header"."No.");
        IF PurchaseRequisitionHeader.FINDFIRST THEN BEGIN
            PurchaseRequisitionHeader.Status := PurchaseRequisitionHeader.Status::Open;
            PurchaseRequisitionHeader.VALIDATE(PurchaseRequisitionHeader.Status);
            PurchaseRequisitionHeader.MODIFY;
        END;
    end;

    procedure ReOpenRequestforQuotation(RequestforQuotation: Record 50049)
    var
        RequestforQuotationHeader: Record 50049;
        RequestforQuotationLine: Record 50050;
    begin
        RequestforQuotationHeader.RESET;
        RequestforQuotationHeader.SETRANGE("No.", RequestforQuotation."No.");
        IF RequestforQuotationHeader.FINDFIRST THEN BEGIN
            RequestforQuotationHeader.Status := RequestforQuotationHeader.Status::Open;
            RequestforQuotationHeader.VALIDATE(Status);
            RequestforQuotationHeader.MODIFY;
        END;
    end;

    procedure ReleaseRequestforQuotation(var RequestforQuotation: Record 50049)
    var
        RequestforQuotationHeader: Record 50049;
        RequestforQuotationLine: Record 50050;
    begin
        RequestforQuotationHeader.RESET;
        RequestforQuotationHeader.SETRANGE("No.", RequestforQuotation."No.");
        IF RequestforQuotationHeader.FINDFIRST THEN BEGIN
            RequestforQuotationHeader.Status := RequestforQuotationHeader.Status::Released;
            RequestforQuotationHeader.VALIDATE(Status);
            RequestforQuotationHeader.MODIFY;
        END;
    end;

    procedure ReopenBidAnalysis("Bid Analysis Header": Record 50053)
    var
        BidAnalysisHeader: Record 50053;
        BidAnalysisLine: Record 50054;
    begin
        BidAnalysisHeader.RESET;
        BidAnalysisHeader.SETRANGE(BidAnalysisHeader."RFQ No.", "Bid Analysis Header"."RFQ No.");
        IF BidAnalysisHeader.FINDFIRST THEN BEGIN
            BidAnalysisHeader.Status := BidAnalysisHeader.Status::Open;
            BidAnalysisHeader.VALIDATE(Status);
            BidAnalysisHeader.MODIFY;
        END;
    end;

    procedure ReleaseBidAnalysis(var "Bid Analysis Header": Record 50053)
    var
        BidAnalysisHeader: Record 50053;
        BidAnalysisLine: Record 50054;
    begin
        BidAnalysisHeader.RESET;
        BidAnalysisHeader.SETRANGE(BidAnalysisHeader."RFQ No.", "Bid Analysis Header"."RFQ No.");
        IF BidAnalysisHeader.FINDFIRST THEN BEGIN
            BidAnalysisHeader.Status := BidAnalysisHeader.Status::Released;
            BidAnalysisHeader.VALIDATE(Status);
            BidAnalysisHeader.MODIFY;
        END;
    end;

    procedure ReopenProcurementPlan(ProcurementPlanningHeaders: Record 50063)
    var
        ProcurementPlanningHeader: Record 50063;
    begin
        ProcurementPlanningHeader.RESET;
        ProcurementPlanningHeader.SETRANGE(ProcurementPlanningHeader."No.", ProcurementPlanningHeaders."No.");
        IF ProcurementPlanningHeader.FINDFIRST THEN BEGIN
            ProcurementPlanningHeader.Status := ProcurementPlanningHeader.Status::Open;
            ProcurementPlanningHeader.VALIDATE(Status);
            ProcurementPlanningHeader.MODIFY;
        END;
    end;

    procedure ReleaseProcurementPlan(ProcurementPlanningHeaders: Record 50063)
    var
        ProcurementPlanningHeader: Record 50063;
    begin
        ProcurementPlanningHeader.RESET;
        ProcurementPlanningHeader.SETRANGE(ProcurementPlanningHeader."No.", ProcurementPlanningHeaders."No.");
        IF ProcurementPlanningHeader.FINDFIRST THEN BEGIN
            ProcurementPlanningHeader.Status := ProcurementPlanningHeader.Status::Approved;
            ProcurementPlanningHeader.VALIDATE(Status);
            ProcurementPlanningHeader.MODIFY;
        END;
    end;

    procedure ReopenTenderHeader(TenderHeader: Record 50055)
    var
        TenderHeaders: Record 50055;
    begin
        TenderHeaders.RESET;
        TenderHeaders.SETRANGE(TenderHeaders."No.", TenderHeader."No.");
        IF TenderHeaders.FINDFIRST THEN BEGIN
            TenderHeaders.Status := TenderHeaders.Status::Open;
            TenderHeaders.VALIDATE(Status);
            TenderHeaders.MODIFY;
        END;
    end;

    procedure ReleaseTenderHeader(TenderHeader: Record 50055)
    var
        TenderHeaders: Record 50055;
    begin
        TenderHeaders.RESET;
        TenderHeaders.SETRANGE(TenderHeaders."No.", TenderHeader."No.");
        IF TenderHeaders.FINDFIRST THEN BEGIN
            TenderHeaders.Status := TenderHeaders.Status::Approved;
            TenderHeaders.VALIDATE(Status);
            TenderHeaders.MODIFY;
        END;
    end;
}


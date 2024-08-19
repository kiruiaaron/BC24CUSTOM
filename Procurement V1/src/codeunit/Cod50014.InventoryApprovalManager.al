codeunit 50014 "Inventory Approval Manager"
{

    trigger OnRun()
    begin
    end;

    procedure ReleaseStoreRequisitionHeader(var "Store Requisition Header": Record 50068)
    var
        StoreRequisitionHeader: Record 50068;
    begin
        StoreRequisitionHeader.RESET;
        StoreRequisitionHeader.SETRANGE(StoreRequisitionHeader."No.", "Store Requisition Header"."No.");
        IF StoreRequisitionHeader.FINDFIRST THEN BEGIN
            StoreRequisitionHeader.Status := StoreRequisitionHeader.Status::Approved;
            StoreRequisitionHeader.VALIDATE(StoreRequisitionHeader.Status);
            StoreRequisitionHeader.MODIFY;
        END;
    end;

    procedure ReOpenStoreRequisitionHeader(var "Store Requisition Header": Record 50068)
    var
        StoreRequisitionHeader: Record 50068;
    begin
        StoreRequisitionHeader.RESET;
        StoreRequisitionHeader.SETRANGE(StoreRequisitionHeader."No.", "Store Requisition Header"."No.");
        IF StoreRequisitionHeader.FINDFIRST THEN BEGIN
            StoreRequisitionHeader.Status := StoreRequisitionHeader.Status::Open;
            StoreRequisitionHeader.VALIDATE(StoreRequisitionHeader.Status);
            StoreRequisitionHeader.MODIFY;
        END;
    end;

    procedure ReOpenTransferHeader("Transfer Header": Record 5740)
    var
        TransferHeader: Record 5740;
    begin
        TransferHeader.RESET;
        TransferHeader.SETRANGE("No.", "Transfer Header"."No.");
        IF TransferHeader.FINDFIRST THEN BEGIN
            TransferHeader.Status := TransferHeader.Status::Open;
            TransferHeader.VALIDATE(Status);
            TransferHeader.MODIFY;
        END;
    end;

    procedure ReleaseTransferHeader(var "Transfer Header": Record 5740)
    var
        TransferHeader: Record 5740;
    begin
        TransferHeader.RESET;
        TransferHeader.SETRANGE("No.", "Transfer Header"."No.");
        IF TransferHeader.FINDFIRST THEN BEGIN
            TransferHeader.Status := TransferHeader.Status::Released;
            TransferHeader.VALIDATE(Status);
            TransferHeader.MODIFY;
        END;
    end;
}


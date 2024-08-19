tableextension 50410 "Incoming Document Att Ext" extends "Incoming Document Attachment"
{
    fields
    {
        // Add changes to table fields here
    }

    procedure NewAttachmentFromFundsTransferDocument(FundsTransferHeader: Record 50006)
    begin
        //Sysre NextGen Addon
        //Attach Funds Transfer Document support documents
        NewAttachmentFromDocument(
          FundsTransferHeader."Incoming Document Entry No.",
          DATABASE::"Funds Transfer Header",
          FundsTransferHeader."Document Type",
          FundsTransferHeader."No.");
    end;


    procedure NewAttachmentFromImprestDocument(ImprestHeader: Record 50008)
    begin
        //Sysre NextGen Addon
        //Attach Imprest Document support documents
        NewAttachmentFromDocument(
          ImprestHeader."Incoming Document Entry No.",
          DATABASE::"Imprest Header",
          ImprestHeader."Document Type",
          ImprestHeader."No.");
    end;


    procedure NewAttachmentFromImprestSurrenderDocument(ImprestSurrenderHeader: Record 50010)
    begin
        //Sysre NextGen Addon
        //Attach Imprest Surrender Document support documents
        NewAttachmentFromDocument(
          ImprestSurrenderHeader."Incoming Document Entry No.",
          DATABASE::"Imprest Surrender Header",
          ImprestSurrenderHeader."Document Type",
          ImprestSurrenderHeader."No.");
    end;


    procedure NewAttachmentFromFundsClaimDocument(FundsClaimHeader: Record 50012)
    begin
        //Sysre NextGen Addon
        //Attach Funds Claim Document support documents
        NewAttachmentFromDocument(
          FundsClaimHeader."Incoming Document Entry No.",
          DATABASE::"Funds Claim Header",
          FundsClaimHeader."Document Type",
          FundsClaimHeader."No.");
    end;


    procedure NewAttachmentFromPaymentDocument(PaymentHeader: Record 50002)
    begin
        //Sysre NextGen Addon
        //Attach Payment Document support documents
        NewAttachmentFromDocument(
          PaymentHeader."Incoming Document Entry No.",
          DATABASE::"Payment Header",
          PaymentHeader."Document Type",
          PaymentHeader."No.");
    end;

    var
        myInt: Integer;
}
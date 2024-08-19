tableextension 50412 "Reversal Entry Ext" extends "Reversal Entry"
{
    fields
    {
        // Add changes to table fields here
    }

    procedure AlreadyReversedDocument(Caption: Text[50]; DocumentNo: Code[20])
    begin

        ERROR(Text011, Caption, DocumentNo);
    end;

    var
        Text010: Label 'You cannot reverse %1 No. %2 because the register has already been involved in a reversal.';
        Text011: Label 'You cannot reverse %1 No. %2 because the entry has already been involved in a reversal.';
        PostedAndAppliedSameTransactionErr: Label 'You cannot reverse register number %1 because it contains customer or vendor or employee ledger entries that have been posted and applied in the same transaction.\\You must reverse each transaction in register number %1 separately.', Comment = '%1="G/L Register No."';
        Text013: Label 'You cannot reverse %1 No. %2 because the entry has an associated Realized Gain/Loss entry.';
        myInt: Integer;
}
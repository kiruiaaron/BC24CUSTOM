table 50042 "Fixed Deposit Bids"
{

    fields
    {
        field(10; "Document No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Bank Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                "Bank Account Name" := '';

                IF BankAccount.GET("Bank Account") THEN
                    "Bank Account Name" := BankAccount.Name;
            end;
        }
        field(12; "Bank Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Desired Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "FD Duration"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Rate; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No", "Bank Account")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        /*         FDProcessing.RESET;
                FDProcessing.SETRANGE(FDProcessing."Document No.", "Document No");
                IF FDProcessing.FINDFIRST THEN BEGIN
                    IF FDProcessing."FD Amount" = 0 THEN ERROR(FDAmountError);
                    //IF FDProcessing."Fixed Duration"=0D THEN ERROR(FDAmountError);
                    //IF FDProcessing."Interest rate"=0 THEN ERROR(FDAmountError);
                    Amount := FDProcessing."FD Amount";
                    "FD Duration" := FDProcessing."Fixed Duration";
                END; */
    end;

    var
        BankAccount: Record "Bank Account";
        //    FDProcessing: Record 50037;
        FDAmountError: Label 'Fixed Deposit Amount Must Be specified before receiving the bids';
}


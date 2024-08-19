table 50034 "Document Reversal Header"
{

    fields
    {
        field(10; "No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,Receipt,Funds Transfer';
            OptionMembers = " ",Payment,Receipt,"Funds Transfer";

            trigger OnValidate()
            begin
                Rec.TESTFIELD(Status, Rec.Status::Open);

                "Document No." := '';
                "Doc. Posting date" := 0D;
                Description := '';
                Amount := 0;
                "Amount (LCY)" := 0;
                "Account No." := '';
                "Account Name" := '';


                DocumentReversalLine.RESET;
                DocumentReversalLine.SETRANGE(DocumentReversalLine."No.", "No.");
                IF DocumentReversalLine.FINDSET THEN BEGIN
                    DocumentReversalLine.DELETEALL;
                END;
            end;
        }
        field(12; "Document No.";
        Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Document Type" = FILTER(Payment)) "Payment Header"."No." WHERE(Reversed = CONST(false),
                                                                                           Posted = CONST(true))
            ELSE
            IF ("Document Type" = FILTER(Receipt)) "Receipt Header"."No." WHERE(Reversed = CONST(false),
        Posted = CONST(true))
            ELSE
            IF ("Document Type" = CONST("Funds Transfer")) "Funds Transfer Header"."No." WHERE(Reversed = CONST(false),
                                                                                        Posted = CONST(true));

            trigger OnValidate()
            begin
                "Doc. Posting date" := 0D;
                Description := '';
                Amount := 0;
                "Amount (LCY)" := 0;
                "Account No." := '';
                "Account Name" := '';
                "Shortcut Dimension 1 Code" := '';
                "Shortcut Dimension 2 Code" := '';
                "Shortcut Dimension 3 Code" := '';
                "Shortcut Dimension 4 Code" := '';
                "Shortcut Dimension 5 Code" := '';
                "Shortcut Dimension 6 Code" := '';
                "Shortcut Dimension 7 Code" := '';
                "Shortcut Dimension 8 Code" := '';

                DocumentReversalLine.RESET;
                DocumentReversalLine.SETRANGE(DocumentReversalLine."No.", "No.");
                IF DocumentReversalLine.FINDSET THEN BEGIN
                    DocumentReversalLine.DELETEALL;
                END;

                IF "Document Type" = "Document Type"::Payment THEN BEGIN
                    PaymentHeader.RESET;
                    PaymentHeader.SETRANGE(PaymentHeader."No.", "Document No.");
                    IF PaymentHeader.FINDFIRST THEN BEGIN
                        PaymentHeader.CALCFIELDS(PaymentHeader."Net Amount");
                        PaymentHeader.CALCFIELDS(PaymentHeader."Net Amount(LCY)");

                        "Doc. Posting date" := PaymentHeader."Posting Date";
                        Description := PaymentHeader.Description;
                        Amount := PaymentHeader."Net Amount";
                        "Amount (LCY)" := PaymentHeader."Net Amount(LCY)";
                        "Account Type" := "Account Type"::"Bank Account";
                        "Account No." := PaymentHeader."Bank Account No.";
                        "Account Name" := PaymentHeader."Bank Account Name";
                        "Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := PaymentHeader."Global Dimension 2 Code";
                        "Shortcut Dimension 3 Code" := PaymentHeader."Shortcut Dimension 3 Code";
                        "Shortcut Dimension 4 Code" := PaymentHeader."Shortcut Dimension 4 Code";
                        "Shortcut Dimension 5 Code" := PaymentHeader."Shortcut Dimension 5 Code";
                        "Shortcut Dimension 6 Code" := PaymentHeader."Shortcut Dimension 6 Code";
                        "Shortcut Dimension 7 Code" := PaymentHeader."Shortcut Dimension 7 Code";
                        "Shortcut Dimension 8 Code" := PaymentHeader."Shortcut Dimension 8 Code";
                        InsertPaymentLines("Document No.", "No.");
                    END;
                END;

                IF "Document Type" = "Document Type"::Receipt THEN BEGIN
                    ReceiptHeader.RESET;
                    ReceiptHeader.SETRANGE(ReceiptHeader."No.", "Document No.");
                    IF ReceiptHeader.FINDFIRST THEN BEGIN
                        //ReceiptHeader.CALCFIELDS(ReceiptHeader."Amount Received");
                        // ReceiptHeader.CALCFIELDS(ReceiptHeader."Amount Received(LCY)");

                        "Doc. Posting date" := ReceiptHeader."Posting Date";
                        Description := ReceiptHeader.Description;
                        Amount := ReceiptHeader."Amount Received";
                        "Amount (LCY)" := ReceiptHeader."Amount Received(LCY)";
                        "Account Type" := "Account Type"::"Bank Account";
                        "Account No." := ReceiptHeader."Account No.";
                        "Account Name" := ReceiptHeader."Account Name";
                        "Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
                        "Shortcut Dimension 3 Code" := ReceiptHeader."Shortcut Dimension 3 Code";
                        "Shortcut Dimension 4 Code" := ReceiptHeader."Shortcut Dimension 4 Code";
                        "Shortcut Dimension 5 Code" := ReceiptHeader."Shortcut Dimension 5 Code";
                        "Shortcut Dimension 6 Code" := ReceiptHeader."Shortcut Dimension 6 Code";
                        "Shortcut Dimension 7 Code" := ReceiptHeader."Shortcut Dimension 7 Code";
                        "Shortcut Dimension 8 Code" := ReceiptHeader."Shortcut Dimension 8 Code";
                        InsertReceiptLines("Document No.", "No.");
                    END;
                END;

                IF "Document Type" = "Document Type"::"Funds Transfer" THEN BEGIN
                    FundsTransferHeader.RESET;
                    FundsTransferHeader.SETRANGE(FundsTransferHeader."No.", "Document No.");
                    IF FundsTransferHeader.FINDFIRST THEN BEGIN
                        //FundsTransferHeader.CALCFIELDS(FundsTransferHeader."Amount Received");
                        // FundsTransferHeader.CALCFIELDS(FundsTransferHeader."Amount Received(LCY)");

                        "Doc. Posting date" := FundsTransferHeader."Posting Date";
                        Description := FundsTransferHeader.Description;
                        Amount := FundsTransferHeader."Amount To Transfer";
                        "Amount (LCY)" := FundsTransferHeader."Amount To Transfer(LCY)";
                        "Account Type" := "Account Type"::"Bank Account";
                        "Account No." := FundsTransferHeader."Bank Account No.";
                        "Account Name" := FundsTransferHeader."Bank Account Name";
                        "Shortcut Dimension 1 Code" := FundsTransferHeader."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := FundsTransferHeader."Global Dimension 2 Code";
                        "Shortcut Dimension 3 Code" := FundsTransferHeader."Shortcut Dimension 3 Code";
                        "Shortcut Dimension 4 Code" := FundsTransferHeader."Shortcut Dimension 4 Code";
                        "Shortcut Dimension 5 Code" := FundsTransferHeader."Shortcut Dimension 5 Code";
                        "Shortcut Dimension 6 Code" := FundsTransferHeader."Shortcut Dimension 6 Code";
                        "Shortcut Dimension 7 Code" := FundsTransferHeader."Shortcut Dimension 7 Code";
                        "Shortcut Dimension 8 Code" := FundsTransferHeader."Shortcut Dimension 8 Code";
                        InsertReceiptLines("Document No.", "No.");
                    END;
                END;
            end;
        }
        field(13; "Doc. Posting date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; Description; Text[150])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(18; "Reversal Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Reversal Posted By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Reversal Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "User ID"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(25; "Account No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26; "Account Name"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(27; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(51; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            FundsSetup.GET;
            FundsSetup.TESTFIELD(FundsSetup."Reversal Header");
            NoSeriesMgt.InitSeries(FundsSetup."Reversal Header", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        "Document Date" := TODAY;
        "User ID" := USERID;
    end;

    var
        FundsClaimHeader: Record 50012;
        ReceiptHeader: Record 50004;
        PaymentHeader: Record 50002;
        ImprestHeader: Record 50008;
        ImprestSurrenderHeader: Record 50010;
        GLEntry: Record 17;
        Customer: Record 18;
        Vendor: Record 23;
        Employee: Record 5200;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FundsSetup: Record 50031;
        DocumentReversalLine: Record 50035;
        LineNo: Integer;
        ClaimLines: Record 50013;
        ClaimHeader: Record 50012;
        ImprestSurrender: Record 50010;
        ImprestLine: Record 50009;
        PaymentLine: Record 50003;
        ReceiptLine: Record 50005;
        FundsTransferLine: Record 50007;
        FundsTransferHeader: Record 50006;

    local procedure InsertFundsTransfer(PayeeNo: Code[20]; DocumentNo: Code[20])
    begin
        MESSAGE(PayeeNo);
        MESSAGE(DocumentNo);
        DocumentReversalLine.RESET;
        DocumentReversalLine.SETRANGE("Document No.", DocumentNo);
        IF DocumentReversalLine.FINDSET THEN
            DocumentReversalLine.DELETEALL;

        FundsTransferLine.RESET;
        FundsTransferLine.SETRANGE("Document No.", PayeeNo);
        IF FundsTransferLine.FINDSET THEN BEGIN
            REPEAT
                LineNo := 10000;
                DocumentReversalLine.INIT;
                DocumentReversalLine."Line No." := LineNo + 1;
                DocumentReversalLine."No." := DocumentNo;
                DocumentReversalLine."Account Type" := FundsTransferLine."Account Type";
                DocumentReversalLine."Document No." := PayeeNo;
                DocumentReversalLine."Account No." := FundsTransferLine."Account No.";
                DocumentReversalLine."Account Name" := FundsTransferLine."Account Name";
                DocumentReversalLine.Description := FundsTransferLine.Description;
                DocumentReversalLine.Amount := FundsTransferLine.Amount;
                DocumentReversalLine."Amount (LCY)" := FundsTransferLine."Amount(LCY)";
                DocumentReversalLine."Shortcut Dimension 1 Code" := FundsTransferLine."Global Dimension 1 Code";
                DocumentReversalLine."Shortcut Dimension 2 Code" := FundsTransferLine."Global Dimension 2 Code";
                DocumentReversalLine."Shortcut Dimension 3 Code" := FundsTransferLine."Shortcut Dimension 3 Code";
                DocumentReversalLine."Shortcut Dimension 4 Code" := FundsTransferLine."Shortcut Dimension 4 Code";
                DocumentReversalLine."Shortcut Dimension 5 Code" := FundsTransferLine."Shortcut Dimension 5 Code";
                DocumentReversalLine."Shortcut Dimension 6 Code" := FundsTransferLine."Shortcut Dimension 6 Code";
                DocumentReversalLine."Shortcut Dimension 7 Code" := FundsTransferLine."Shortcut Dimension 7 Code";
                DocumentReversalLine."Shortcut Dimension 8 Code" := FundsTransferLine."Shortcut Dimension 8 Code";
                DocumentReversalLine.INSERT;
            UNTIL FundsTransferLine.NEXT = 0;
        END;
        //MESSAGE(Txt060);
    end;

    local procedure InsertPaymentLines(PayeeNo: Code[20]; DocumentNo: Code[20])
    begin
        //MESSAGE(PayeeNo);
        //MESSAGE(DocumentNo);
        DocumentReversalLine.RESET;
        DocumentReversalLine.SETRANGE("Document No.", DocumentNo);
        IF DocumentReversalLine.FINDSET THEN
            DocumentReversalLine.DELETEALL;

        PaymentLine.RESET;
        PaymentLine.SETRANGE("Document No.", PayeeNo);
        IF PaymentLine.FINDSET THEN BEGIN
            REPEAT
                LineNo := 10000;
                DocumentReversalLine.INIT;
                DocumentReversalLine."Line No." := LineNo + 1;
                DocumentReversalLine."No." := DocumentNo;
                DocumentReversalLine."Account Type" := PaymentLine."Account Type";
                DocumentReversalLine."Document No." := PayeeNo;
                DocumentReversalLine."Account No." := PaymentLine."Account No.";
                DocumentReversalLine."Account Name" := PaymentLine."Account Name";
                DocumentReversalLine.Description := PaymentLine.Description;
                DocumentReversalLine.Amount := PaymentLine."Net Amount";
                DocumentReversalLine."Amount (LCY)" := PaymentLine."Net Amount(LCY)";
                DocumentReversalLine."Shortcut Dimension 1 Code" := PaymentLine."Global Dimension 1 Code";
                DocumentReversalLine."Shortcut Dimension 2 Code" := PaymentLine."Global Dimension 2 Code";
                DocumentReversalLine."Shortcut Dimension 3 Code" := PaymentLine."Shortcut Dimension 3 Code";
                DocumentReversalLine."Shortcut Dimension 4 Code" := PaymentLine."Shortcut Dimension 4 Code";
                DocumentReversalLine."Shortcut Dimension 5 Code" := PaymentLine."Shortcut Dimension 5 Code";
                DocumentReversalLine."Shortcut Dimension 6 Code" := PaymentLine."Shortcut Dimension 6 Code";
                DocumentReversalLine."Shortcut Dimension 7 Code" := PaymentLine."Shortcut Dimension 7 Code";
                DocumentReversalLine."Shortcut Dimension 8 Code" := PaymentLine."Shortcut Dimension 8 Code";
                DocumentReversalLine.INSERT;
            UNTIL PaymentLine.NEXT = 0;
        END;
        //MESSAGE(Txt060);
    end;

    local procedure InsertReceiptLines(PayeeNo: Code[20]; DocumentNo: Code[20])
    begin
        //MESSAGE(PayeeNo);
        //MESSAGE(DocumentNo);
        DocumentReversalLine.RESET;
        DocumentReversalLine.SETRANGE("Document No.", DocumentNo);
        IF DocumentReversalLine.FINDSET THEN
            DocumentReversalLine.DELETEALL;

        ReceiptLine.RESET;
        ReceiptLine.SETRANGE("Document No.", PayeeNo);
        IF ReceiptLine.FINDSET THEN BEGIN
            REPEAT
                LineNo := 10000;
                DocumentReversalLine.INIT;
                DocumentReversalLine."Line No." := LineNo + 1;
                DocumentReversalLine."No." := DocumentNo;
                DocumentReversalLine."Account Type" := ReceiptLine."Account Type";
                DocumentReversalLine."Document No." := PayeeNo;
                DocumentReversalLine."Account No." := ReceiptLine."Account No.";
                DocumentReversalLine."Account Name" := ReceiptLine."Account Name";
                DocumentReversalLine.Description := ReceiptLine.Description;
                DocumentReversalLine.Amount := ReceiptLine."Net Amount";
                DocumentReversalLine."Amount (LCY)" := ReceiptLine."Net Amount(LCY)";
                DocumentReversalLine."Shortcut Dimension 1 Code" := ReceiptLine."Global Dimension 1 Code";
                DocumentReversalLine."Shortcut Dimension 2 Code" := ReceiptLine."Global Dimension 2 Code";
                DocumentReversalLine."Shortcut Dimension 3 Code" := ReceiptLine."Shortcut Dimension 3 Code";
                DocumentReversalLine."Shortcut Dimension 4 Code" := ReceiptLine."Shortcut Dimension 4 Code";
                DocumentReversalLine."Shortcut Dimension 5 Code" := ReceiptLine."Shortcut Dimension 5 Code";
                DocumentReversalLine."Shortcut Dimension 6 Code" := ReceiptLine."Shortcut Dimension 6 Code";
                DocumentReversalLine."Shortcut Dimension 7 Code" := ReceiptLine."Shortcut Dimension 7 Code";
                DocumentReversalLine."Shortcut Dimension 8 Code" := ReceiptLine."Shortcut Dimension 8 Code";
                DocumentReversalLine.INSERT;
            UNTIL ReceiptLine.NEXT = 0;
        END;
        //MESSAGE(Txt060);
    end;
}


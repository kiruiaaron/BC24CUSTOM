table 50004 "Receipt Header"
{
    Caption = 'Receipt Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt,Funds Transfer,Imprest,Imprest Surrender';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Receipt,"Funds Transfer",Imprest,"Imprest Surrender";
        }
        field(3; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            Editable = true;
            OptionCaption = ' ,Cheque,EFT,RTGS,MPESA,Cash,AutoPay';
            OptionMembers = " ",Cheque,EFT,RTGS,MPESA,Cash,AutoPay;
        }
        field(6; "Receipt Type"; Option)
        {
            Caption = 'Receipt Type';
            OptionCaption = ' ,Staff Loan,Investment Loan,Normal Receipt,Equity';
            OptionMembers = " ","Staff Loan","Investment Loan","Normal Receipt",Equity;
        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            //TableRelation = IF ("Receipt Types"=CONST(Bank)) "Bank Account"."No."
            //                ELSE IF ("Receipt Type"=CONST("G/L Account")) "Funds Transaction Code"."Transaction Code";

            trigger OnValidate()
            begin
                TESTFIELD("Posting Date");
                "Account Name" := '';
                /*  "Currency Code" := '';

                 IF "Receipt Types" = "Receipt Types"::Bank THEN BEGIN
                     BankAccount.RESET;
                     BankAccount.SETRANGE(BankAccount."No.", "Account No.");
                     IF BankAccount.FINDFIRST THEN BEGIN
                         "Account Name" := BankAccount.Name;
                         "Currency Code" := BankAccount."Currency Code";
                         VALIDATE("Currency Code");
                     END;
                 END;

                 IF "Receipt Types" = "Receipt Types"::"G/L Account" THEN BEGIN
                     FundsTransactionCode.RESET;
                     FundsTransactionCode.SETRANGE("Transaction Code", "Account No.");
                     IF FundsTransactionCode.FINDFIRST THEN BEGIN
                         "Account Name" := FundsTransactionCode."Account Name";
                     END;
                 END; */
            end;
        }
        field(8; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
            Editable = false;
        }
        field(9; "Account Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE("Bank Account No." = FIELD("Account No.")));
            Caption = 'Bank Account Balance';
            Editable = false;

        }
        field(11; "Reference No."; Code[20])
        {
            Caption = 'Reference No.';

            trigger OnValidate()
            begin
                /*ReceiptHeader.RESET;
                ReceiptHeader.SETRANGE(ReceiptHeader."Reference No.","Reference No.");
                IF ReceiptHeader.FINDSET THEN BEGIN
                  REPEAT
                    IF ReceiptHeader."No."<>"No." THEN
                      ERROR(ReferenceNoError,"Reference No.",ReceiptHeader."No.");
                  UNTIL ReceiptHeader.NEXT=0;
                END;*/

            end;
        }
        field(14; "Received From"; Text[100])
        {
            Caption = 'Received From';

            trigger OnValidate()
            begin
                "Received From" := UPPERCASE("Received From");
            end;
        }
        field(15; "On Behalf of"; Text[100])
        {
            Caption = 'On Behalf of';
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TESTFIELD("Account No.");
                TESTFIELD("Posting Date");
                IF "Currency Code" <> '' THEN BEGIN
                    IF BankAccount.GET("Account No.") THEN BEGIN
                        BankAccount.TESTFIELD(BankAccount."Currency Code", "Currency Code");
                        "Currency Factor" := CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                    END;
                END ELSE BEGIN
                    IF BankAccount.GET("Account No.") THEN BEGIN
                        BankAccount.TESTFIELD(BankAccount."Currency Code", '');
                    END;
                END;
                VALIDATE("Amount Received");
            end;
        }
        field(17; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(18; "Amount Received"; Decimal)
        {
            Caption = 'Amount Received';

            trigger OnValidate()
            begin
                IF "Currency Code" <> '' THEN BEGIN
                    "Amount Received(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Amount Received", "Currency Factor"));
                END ELSE BEGIN
                    "Amount Received(LCY)" := "Amount Received";
                END;
            end;
        }
        field(19; "Amount Received(LCY)"; Decimal)
        {
            Caption = 'Amount Received(LCY)';
            Editable = false;
        }
        field(20; "Line Amount"; Decimal)
        {
            CalcFormula = Sum("Receipt Line".Amount WHERE("Document No." = FIELD("No.")));
            Caption = 'Line Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Line Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Receipt Line"."Amount(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Line Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(49; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                Description := UPPERCASE(Description);
            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                         "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                            Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                         Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                        Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                           Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                           Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted,Reversed;

            trigger OnValidate()
            begin
                ReceiptLine.RESET;
                ReceiptLine.SETRANGE(ReceiptLine."Document No.", "No.");
                IF ReceiptLine.FINDSET THEN BEGIN
                    REPEAT
                        ReceiptLine.Status := Rec.Status;
                        ReceiptLine.MODIFY;
                    UNTIL ReceiptLine.NEXT = 0;
                END;
            end;
        }
        field(71; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
        field(72; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(73; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            Editable = false;
        }
        field(74; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            Editable = false;
        }
        field(75; Reversed; Boolean)
        {
            Caption = 'Reversed';
            Editable = true;
        }
        field(76; "Reversed By"; Code[50])
        {
            Caption = 'Reversed By';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(77; "Reversal Date"; Date)
        {
            Caption = 'Reversal Date';
            Editable = false;
        }
        field(78; "Reversal Time"; Time)
        {
            Caption = 'Reversal Time';
            Editable = false;
        }
        field(80; "Reversal Posting Date"; Date)
        {
        }
        field(99; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(100; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(102; "Incoming Document Entry No."; Integer)
        {
        }
        field(103; "Receipt Types"; Option)
        {
            Caption = 'Receipt Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Bank,G/L Account';
            OptionMembers = Bank,"G/L Account";
        }
        field(110; "Posted to Cheque Buffer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        /*   field(52137640;"Investment Account No.";Code[20])
          {
              DataClassification = ToBeClassified;
              TableRelation = IF (Receipt Type=CONST(Investment Loan)) "EHS Items Issues"."Issue No" WHERE (Field5=FIELD(Client No.))
                              ELSE IF (Receipt Type=CONST(Equity)) "Appraisal Standard Import"."Employee No" WHERE (KPI Description=FIELD(Client No.));
          } */
        field(52137641; "Loan Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Loan Disbursed,Principal Receivable,Principal Paid,Interest Receivable,Interest Paid,Penalty Receivable,Penalty Paid,Loan Charge Receivable,Loan Charge Paid';
            OptionMembers = " ","Loan Disbursed","Principal Receivable","Principal Paid","Interest Receivable","Interest Paid","Penalty Receivable","Penalty Paid","Loan Charge Receivable","Loan Charge Paid";
        }
        field(52137861; "LP Ready for Posting"; Boolean)
        {
        }
        field(52137862; "Loan Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //  TableRelation = Table52137625.Field1;
        }
        field(52137880; "Client No."; Code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Customer WHERE ("Account Type"=CONST(Investment));

            trigger OnValidate()
            begin
                IF Customer.GET("Client No.") THEN
                    "Client Name" := Customer.Name;
            end;
        }
        field(52137881; "Client Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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

    trigger OnDelete()
    begin
        Rec.TESTFIELD(Status, Rec.Status::Open);

        ReceiptLine.RESET;
        ReceiptLine.SETRANGE(ReceiptLine."Document No.", "No.");
        IF ReceiptLine.FINDSET THEN
            ReceiptLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            FundsSetup.GET;
            FundsSetup.TESTFIELD(FundsSetup."Receipt Nos.");
            NoSeriesMgt.InitSeries(FundsSetup."Receipt Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "Document Type" := "Document Type"::Receipt;
        "Document Date" := TODAY;
        "User ID" := USERID;
        /*IF "Posting Date"=0D THEN
        "Posting Date":=TODAY;*/

    end;

    var
        FundsSetup: Record 50031;
        NoSeriesMgt: Codeunit NoSeriesManagement;

        "G/LAccount": Record 15;
        BankAccount: Record 270;
        Customer: Record 18;
        Vendor: Record 23;
        FixedAsset: Record 5600;
        ICPartner: Record 413;
        ReceiptHeader: Record 50004;
        ReceiptLine: Record 50005;
        CurrExchRate: Record 330;
        ReferenceNoError: Label 'The Reference Number:%1  is already used in Receipt No:%2';
        FundsTransactionCode: Record 50027;
}


table 50013 "Funds Claim Line"
{
    Caption = 'Funds Claim Line';

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(2; "Document No.";
        Code[20])
        {
            Caption = '"Document No."';
            Editable = false;
            TableRelation = "Funds Claim Header"."No.";
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt,Funds Transfer,Imprest,Imprest Surrender';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Receipt,"Funds Transfer",Imprest,"Imprest Surrender";
        }
        field(4; "Funds Claim Code"; Code[50])
        {
            Caption = 'Funds Claim Code';
            TableRelation = "Funds Transaction Code"."Transaction Code" WHERE("Transaction Type" = CONST(Payment),
                                                                               "Funds Claim Code" = CONST(true));

            trigger OnValidate()
            begin
                "Account Type" := "Account Type"::"G/L Account";
                "Account No." := '';
                "Posting Group" := '';
                "Funds Claim Code Description" := '';

                FundsTransactionCodes.RESET;
                FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code", "Funds Claim Code");
                IF FundsTransactionCodes.FINDFIRST THEN BEGIN
                    "Account Type" := FundsTransactionCodes."Account Type";
                    "Account No." := FundsTransactionCodes."Account No.";
                    "Posting Group" := FundsTransactionCodes."Posting Group";
                    "Funds Claim Code Description" := FundsTransactionCodes.Description;
                    //Employee Transaction Type
                    "Employee Transaction Type" := FundsTransactionCodes."Employee Transaction Type";
                END;
                VALIDATE("Account Type");
                VALIDATE("Account No.");
            end;
        }
        field(5; "Funds Claim Code Description"; Text[100])
        {
            Caption = 'Payment Code Description';
            Editable = false;
        }
        field(6; "Account Type"; Option)
        {
            Caption = 'Account Type';
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;

            trigger OnValidate()
            begin
                IF "Account Type" = "Account Type"::Employee THEN BEGIN
                    FundsClaimHeader.RESET;
                    FundsClaimHeader.SETRANGE(FundsClaimHeader."No.", "Document No.");
                    IF FundsClaimHeader.FINDFIRST THEN BEGIN
                        "Account No." := FundsClaimHeader."Payee No.";
                        VALIDATE("Account No.");
                    END;
                END;
            end;
        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            Editable = false;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee."No.";

            trigger OnValidate()
            begin
                "Account Name" := '';
                IF "Account Type" = "Account Type"::"G/L Account" THEN BEGIN
                    IF "G/LAccount".GET("Account No.") THEN BEGIN
                        "Account Name" := "G/LAccount".Name;
                    END;
                END;

                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    IF Customer.GET("Account No.") THEN BEGIN
                        "Account Name" := Customer.Name;
                    END;
                END;

                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Account No.") THEN BEGIN
                        "Account Name" := Vendor.Name;
                    END;
                END;

                IF "Account Type" = "Account Type"::Employee THEN BEGIN
                    IF Employee.GET("Account No.") THEN BEGIN
                        "Account Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    END;
                END;
            end;
        }
        field(8; "Account Name"; Text[50])
        {
            Caption = 'Account Name';
            Editable = false;
        }
        field(9; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group".Code
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group".Code
            ELSE
            IF ("Account Type" = CONST(Employee)) "Employee Posting Group".Code;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(22; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(23; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                "Net Amount" := Amount;
                IF "Currency Code" <> '' THEN BEGIN
                    "Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", Amount, "Currency Factor"));
                    "Net Amount(LCY)" := "Amount(LCY)";
                END ELSE BEGIN
                    "Amount(LCY)" := Amount;
                    "Net Amount(LCY)" := Amount;
                END;
            end;
        }
        field(24; "Amount(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
            Editable = false;
        }
        field(34; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            Editable = false;
        }
        field(35; "Net Amount(LCY)"; Decimal)
        {
            Caption = 'Net Amount(LCY)';
            Editable = false;
        }
        field(36; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(37; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                VendLedgEntry: Record 25;
                PayToVendorNo: Code[20];
                OK: Boolean;
                Text000: Label 'You must specify %1 or %2.';
                AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
                AccNo: Code[20];
            begin
            end;

            trigger OnValidate()
            var
                AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
                AccNo: Code[20];
            begin
            end;
        }
        field(38; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                TempVendLedgEntry: Record 25;
            begin
            end;
        }
        field(39; Committed; Boolean)
        {
            Caption = 'Committed';
        }
        field(40; "Budget Code"; Code[20])
        {
            Caption = 'Budget Code';
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
            //   Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                            Blocked = CONST(false));
            //   Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                            Blocked = CONST(false));
            //   Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                           Blocked = CONST(false));
            //   Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                           Blocked = CONST(false));
            //   Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
            //   Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                           Blocked = CONST(false));
            //   Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted,Reversed;
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
            Editable = false;
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
        field(52137023; "Employee Transaction Type"; Option)
        {
            Caption = 'Employee Transaction Type';
            Description = '//Sysre NextGen Addon-Categories Employee Transactions';
            OptionCaption = ' ,NetPay,Imprest';
            OptionMembers = " ",NetPay,Imprest;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.", "Funds Claim Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //TESTFIELD(Status,Status::Open);
    end;

    trigger OnInsert()
    begin
        FundsClaimHeader.RESET;
        FundsClaimHeader.SETRANGE(FundsClaimHeader."No.", "Document No.");
        IF FundsClaimHeader.FINDFIRST THEN BEGIN
            "Document Type" := "Document Type"::Refund;
            "Posting Date" := FundsClaimHeader."Posting Date";
            "Currency Code" := FundsClaimHeader."Currency Code";
            "Currency Factor" := FundsClaimHeader."Currency Factor";
            /*"Global Dimension 1 Code":=FundsClaimHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code":=FundsClaimHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code":=FundsClaimHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code":=FundsClaimHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code":=FundsClaimHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code":=FundsClaimHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code":=FundsClaimHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code":=FundsClaimHeader."Shortcut Dimension 8 Code";
            "Responsibility Center":=FundsClaimHeader."Responsibility Center";*/
        END;

    end;

    trigger OnModify()
    begin
        //TESTFIELD(Status,Status::Open);
    end;

    trigger OnRename()
    begin
        //TESTFIELD(Status,Status::Open);
    end;

    var
        FundsTransactionCodes: Record 50027;
        FundsTaxCodes: Record 50028;
        "G/LAccount": Record 15;
        BankAccount: Record 270;
        Customer: Record 18;
        Vendor: Record 23;
        FixedAsset: Record 5600;
        ICPartner: Record 413;
        Employee: Record 5200;
        FundsClaimHeader: Record 50012;
        FundsClaimLine: Record 50013;
        CurrExchRate: Record 330;
}


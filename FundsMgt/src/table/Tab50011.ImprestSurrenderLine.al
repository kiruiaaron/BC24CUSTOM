table 50011 "Imprest Surrender Line"
{
    Caption = 'Imprest Surrender Line';

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
            TableRelation = "Imprest Surrender Header"."No.";
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt,Funds Transfer,Imprest,Imprest Surrender';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Receipt,"Funds Transfer",Imprest,"Imprest Surrender";
        }
        field(4; "Imprest Code"; Code[50])
        {
            Caption = 'Imprest Code';
            TableRelation = "Funds Transaction Code"."Transaction Code" WHERE("Transaction Type" = CONST(Imprest));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Account Type" := "Account Type"::"G/L Account";
                "Account No." := '';
                "Posting Group" := '';
                "Imprest Code Description" := '';

                FundsTransactionCodes.RESET;
                FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code", "Imprest Code");
                IF FundsTransactionCodes.FINDFIRST THEN BEGIN
                    "Account Type" := FundsTransactionCodes."Account Type";
                    "Account No." := FundsTransactionCodes."Account No.";
                    "Posting Group" := FundsTransactionCodes."Posting Group";
                    "Imprest Code Description" := FundsTransactionCodes.Description;
                END;

                VALIDATE("Account No.");
            end;
        }
        field(5; "Imprest Code Description"; Text[100])
        {
            Caption = 'Imprest Code Description';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(6; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"."No."
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee."No."
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"."No.";

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

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

                IF "Account Type" = "Account Type"::Employee THEN BEGIN
                    IF Employee.GET("Account No.") THEN BEGIN
                        "Account Name" := Employee."First Name" + '-' + Employee."Last Name";
                    END;
                END;

                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Account No.") THEN BEGIN
                        "Account Name" := Vendor.Name;
                    END;
                END;

                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                    IF BankAccount.GET("Account No.") THEN BEGIN
                        "Account Name" := BankAccount.Name;
                    END;
                END;

                IF "Account Type" = "Account Type"::"Fixed Asset" THEN BEGIN
                    IF FixedAsset.GET("Account No.") THEN BEGIN
                        "Account Name" := FixedAsset.Description;
                    END;
                    DepreciationBook.RESET;
                    DepreciationBook.SETRANGE(DepreciationBook."FA No.", "Account No.");
                    IF DepreciationBook.FINDFIRST THEN BEGIN
                        "FA Depreciation Book" := DepreciationBook."Depreciation Book Code";
                    END;
                END;
            end;
        }
        field(8; "Account Name"; Text[100])
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
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group".Code;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(10; Description; Text[250])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
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
        field(23; "Gross Amount"; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Gross Amount(LCY)" := "Gross Amount";
                IF "Currency Code" <> '' THEN BEGIN
                    "Gross Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Gross Amount", "Currency Factor"));
                END;



                Difference := 0;
                Difference := "Gross Amount" - "Actual Spent";
                VALIDATE(Difference);
            end;
        }
        field(24; "Gross Amount(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
            Editable = false;
        }
        field(25; "Actual Spent"; Decimal)
        {
            Caption = 'Actual Spent';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                Difference := 0;
                Difference := "Paid Amount" - "Actual Spent";
                VALIDATE(Difference);
            end;
        }
        field(26; "Actual Spent(LCY)"; Decimal)
        {
            Caption = 'Actual Spent(LCY)';
        }
        field(27; Difference; Decimal)
        {
            Caption = 'Difference';
            Editable = false;

            trigger OnValidate()
            begin
                "Difference(LCY)" := Difference;
                IF "Currency Code" <> '' THEN BEGIN
                    "Difference(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", Difference, "Currency Factor"));
                END;
            end;
        }
        field(28; "Difference(LCY)"; Decimal)
        {
            Caption = 'Difference(LCY)';
        }
        field(30; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
            TableRelation = "Receipt Header"."No.";

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(31; "Cash Receipt"; Decimal)
        {
            Caption = 'Cash Receipt';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(32; "Cash Receipt(LCY)"; Decimal)
        {
            Caption = 'Cash Receipt(LCY)';
            Editable = false;
        }
        field(33; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Gross Amount(LCY)" := "Gross Amount";
                IF "Currency Code" <> '' THEN BEGIN
                    "Gross Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Gross Amount", "Currency Factor"));
                END;



                Difference := 0;
                Difference := "Gross Amount" - "Actual Spent";
                VALIDATE(Difference);
            end;
        }
        field(34; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Gross Amount(LCY)" := "Gross Amount";
                IF "Currency Code" <> '' THEN BEGIN
                    "Gross Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Gross Amount", "Currency Factor"));
                END;



                Difference := 0;
                Difference := "Gross Amount" - "Actual Spent";
                VALIDATE(Difference);
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
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);
            end;
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
        field(79; "FA Depreciation Book"; Code[30])
        {
            TableRelation = "Depreciation Book";
        }
        field(80; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Editable = false;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Employee Name" := '';
                //"Imprest No.":='';
                //VALIDATE("Imprest No.");
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                END;
            end;
        }
        field(81; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.")
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
        ImprestSurrenderHeader.RESET;
        ImprestSurrenderHeader.SETRANGE(ImprestSurrenderHeader."No.", "Document No.");
        IF ImprestSurrenderHeader.FINDFIRST THEN BEGIN
            "Document Type" := "Document Type"::"Imprest Surrender";
            "Posting Date" := ImprestSurrenderHeader."Posting Date";
            "Currency Code" := ImprestSurrenderHeader."Currency Code";
            "Currency Factor" := ImprestSurrenderHeader."Currency Factor";
            "Employee No." := ImprestSurrenderHeader."Employee No.";
            "Employee Name" := ImprestSurrenderHeader."Employee Name";
            /*"Global Dimension 1 Code":=ImprestSurrenderHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code":=ImprestSurrenderHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code":=ImprestSurrenderHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code":=ImprestSurrenderHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code":=ImprestSurrenderHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code":=ImprestSurrenderHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code":=ImprestSurrenderHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code":=ImprestSurrenderHeader."Shortcut Dimension 8 Code";*/
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
        ImprestSurrenderHeader: Record 50010;
        "G/LAccount": Record 15;
        BankAccount: Record 270;
        Customer: Record 18;
        Vendor: Record 23;
        FixedAsset: Record 5600;
        ICPartner: Record 413;
        ImprestHeader: Record 50008;
        ImprestLine: Record 50009;
        CurrExchRate: Record 330;
        Employee: Record 5200;
        DepreciationBook: Record 5612;

    local procedure TestStatusOpen(AllowApproverEdit: Boolean)
    var
        ApprovalEntry: Record 454;
    begin
        ImprestSurrenderHeader.GET("Document No.");
        IF AllowApproverEdit THEN BEGIN
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", ImprestSurrenderHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", USERID);
            IF NOT ApprovalEntry.FINDFIRST THEN BEGIN
                ImprestSurrenderHeader.TESTFIELD(Status, ImprestSurrenderHeader.Status::Open);
            END;
        END ELSE BEGIN
            ImprestSurrenderHeader.TESTFIELD(Status, ImprestSurrenderHeader.Status::Open);
        END;
    end;
}


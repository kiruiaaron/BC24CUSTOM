table 50017 "Journal Voucher Lines"
{

    fields
    {
        field(9; "JV No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(11; "Account Type"; Option)
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;

            trigger OnValidate()
            begin
                IF ("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Fixed Asset",
                                       "Account Type"::"IC Partner", "Account Type"::Employee]) AND
                   ("Bal. Account Type" IN ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor, "Bal. Account Type"::"Fixed Asset",
                                            "Bal. Account Type"::"IC Partner", "Bal. Account Type"::Employee])
                THEN
                    ERROR(
                      Text000,
                      FIELDCAPTION("Account Type"), FIELDCAPTION("Bal. Account Type"));

                IF ("Account Type" = "Account Type"::Employee) AND ("Currency Code" <> '') THEN
                    ERROR(OnlyLocalCurrencyForEmployeeErr);

                VALIDATE("Account No.", '');
                VALIDATE(Description, '');

                IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Bank Account", "Account Type"::Employee] THEN BEGIN

                END ELSE
                    IF "Bal. Account Type" IN [
                                               "Bal. Account Type"::"G/L Account", "Account Type"::"Bank Account", "Bal. Account Type"::"Fixed Asset"]
                    THEN

                        //UpdateSource;

                        IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                THEN BEGIN
                            "Depreciation Book Code" := '';
                            VALIDATE("FA Posting Type", "FA Posting Type"::" ");
                        END;
                IF xRec."Account Type" IN
                   [xRec."Account Type"::Customer, xRec."Account Type"::Vendor]
                THEN BEGIN

                END;
            end;
        }
        field(12; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                      Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee;

            trigger OnValidate()
            begin
                "Account Name" := '';

                IF "Account Type" = "Account Type"::"G/L Account" THEN BEGIN
                    GLAccount.RESET;
                    GLAccount.SETRANGE(GLAccount."No.", "Account No.");
                    IF GLAccount.FINDFIRST THEN BEGIN
                        "Account Name" := GLAccount.Name;
                    END;
                END;


                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    CustomerCard.RESET;
                    CustomerCard.SETRANGE(CustomerCard."No.", "Account No.");
                    IF CustomerCard.FINDFIRST THEN BEGIN
                        "Account Name" := CustomerCard.Name;
                    END;
                END;


                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    VendorCard.RESET;
                    VendorCard.SETRANGE(VendorCard."No.", "Account No.");
                    IF VendorCard.FINDFIRST THEN BEGIN
                        "Account Name" := VendorCard.Name;
                    END;
                END;

                IF "Account Type" = "Account Type"::"Fixed Asset" THEN BEGIN
                    FixedAsset.RESET;
                    FixedAsset.SETRANGE(FixedAsset."No.", "Account No.");
                    IF FixedAsset.FINDFIRST THEN BEGIN
                        "Account Name" := FixedAsset.Description;
                    END;
                END;

                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                    BankAccount.RESET;
                    BankAccount.SETRANGE(BankAccount."No.", "Account No.");
                    IF BankAccount.FINDFIRST THEN BEGIN
                        "Account Name" := BankAccount.Name;
                    END;
                END;
            end;
        }
        field(13; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
            DataClassification = ToBeClassified;
        }
        field(14; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;

            trigger OnValidate()
            var
                Cust: Record 18;
                Vend: Record 23;
            begin
            end;
        }
        field(15; "Document No.";
        Code[20])
        {
            Caption = '"Document No."';
            DataClassification = ToBeClassified;
        }
        field(16; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(17; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(18; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                           Blocked = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Bal. Account Type" = CONST(Employee)) Employee;

            trigger OnValidate()
            begin
                "Bal. Account Name" := '';

                IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN BEGIN
                    GLAccount.RESET;
                    GLAccount.SETRANGE(GLAccount."No.", "Bal. Account No.");
                    IF GLAccount.FINDFIRST THEN BEGIN
                        "Bal. Account Name" := GLAccount.Name;
                    END;
                END;


                IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN BEGIN
                    CustomerCard.RESET;
                    CustomerCard.SETRANGE(CustomerCard."No.", "Bal. Account No.");
                    IF CustomerCard.FINDFIRST THEN BEGIN
                        "Bal. Account Name" := CustomerCard.Name;
                    END;
                END;


                IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN BEGIN
                    VendorCard.RESET;
                    VendorCard.SETRANGE(VendorCard."No.", "Bal. Account No.");
                    IF VendorCard.FINDFIRST THEN BEGIN
                        "Bal. Account Name" := VendorCard.Name;
                    END;
                END;

                IF "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" THEN BEGIN
                    FixedAsset.RESET;
                    FixedAsset.SETRANGE(FixedAsset."No.", "Bal. Account No.");
                    IF FixedAsset.FINDFIRST THEN BEGIN
                        "Bal. Account Name" := FixedAsset.Description;
                    END;
                END;

                IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                    BankAccount.RESET;
                    BankAccount.SETRANGE(BankAccount."No.", "Bal. Account No.");
                    IF BankAccount.FINDFIRST THEN BEGIN
                        "Bal. Account Name" := BankAccount.Name;
                    END;
                END;
            end;
        }
        field(19; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;

            trigger OnValidate()
            var
                BankAcc: Record 270;
            begin
            end;
        }
        field(20; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(21; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                GetCurrency;
                "Debit Amount" := ROUND("Debit Amount", Currency."Amount Rounding Precision");
                IF ("Credit Amount" = 0) OR ("Debit Amount" <> 0) THEN BEGIN
                    Amount := "Debit Amount";
                    VALIDATE(Amount);
                END;
            end;
        }
        field(22; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                GetCurrency;
                "Credit Amount" := ROUND("Credit Amount", Currency."Amount Rounding Precision");
                IF ("Debit Amount" = 0) OR ("Credit Amount" <> 0) THEN BEGIN
                    Amount := -"Credit Amount";
                    VALIDATE(Amount);
                END;
            end;
        }
        field(23; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*IF "Currency Code" = '' THEN BEGIN
                  Amount := "Amount (LCY)";
                  VALIDATE(Amount);
                END ELSE BEGIN
                  IF CheckFixedCurrency THEN BEGIN
                    GetCurrency;
                    Amount := ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          "Posting Date","Currency Code",
                          "Amount (LCY)","Currency Factor"),
                        Currency."Amount Rounding Precision")
                  END ELSE BEGIN
                    TESTFIELD("Amount (LCY)");
                    TESTFIELD(Amount);
                    "Currency Factor" := Amount / "Amount (LCY)";
                  END;
                
                  VALIDATE("VAT %");
                  VALIDATE("Bal. VAT %");
                  UpdateLineBalance;
                END;
                */

            end;
        }
        field(24; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
            end;
        }
        field(26; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }
        field(28; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;

            trigger OnValidate()
            begin
                IF "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" THEN
                    VALIDATE("Applies-to Doc. No.", '');
            end;
        }
        field(29; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                PaymentToleranceMgt: Codeunit 426;
                AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
                AccNo: Code[20];
            begin
                xRec.Amount := Amount;
                xRec."Currency Code" := "Currency Code";
                xRec."Posting Date" := "Posting Date";

                /*//GetAccTypeAndNo(Rec,AccType,AccNo);
                CLEAR(CustLedgEntry);
                CLEAR(VendLedgEntry);
                
                CASE AccType OF
                  AccType::Customer:
                    LookUpAppliesToDocCust(AccNo);
                  AccType::Vendor:
                    LookUpAppliesToDocVend(AccNo);
                  AccType::Employee:
                    LookUpAppliesToDocEmpl(AccNo);
                END;
                SetJournalLineFieldsFromApplication;
                
                IF xRec.Amount <> 0 THEN
                  IF NOT PaymentToleranceMgt.PmtTolGenJnl(Rec) THEN
                    EXIT;
                
                IF "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice THEN
                  UpdateAppliesToInvoiceID;
                  */

            end;

            trigger OnValidate()
            var
                CustLedgEntry: Record 21;
                VendLedgEntry: Record 25;
                TempGenJnlLine: Record 81 temporary;
            begin
                /*IF "Applies-to Doc. No." <> xRec."Applies-to Doc. No." THEN
                  //ClearCustVendApplnEntry;
                
                IF ("Applies-to Doc. No." = '') AND (xRec."Applies-to Doc. No." <> '') THEN BEGIN
                  PaymentToleranceMgt.DelPmtTolApllnDocNo(Rec,xRec."Applies-to Doc. No.");
                
                  TempGenJnlLine := Rec;
                  IF (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Customer) OR
                     (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Vendor) OR
                     (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Employee)
                  THEN
                    CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",TempGenJnlLine);
                
                  CASE TempGenJnlLine."Account Type" OF
                    TempGenJnlLine."Account Type"::Customer:
                      BEGIN
                        CustLedgEntry.SETCURRENTKEY("Document No.");
                        CustLedgEntry.SETRANGE("Document No.",xRec."Applies-to Doc. No.");
                        IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                          CustLedgEntry.SETRANGE("Document Type",xRec."Applies-to Doc. Type");
                        CustLedgEntry.SETRANGE("Customer No.",TempGenJnlLine."Account No.");
                        CustLedgEntry.SETRANGE(Open,TRUE);
                        IF CustLedgEntry.FINDFIRST THEN BEGIN
                          IF CustLedgEntry."Amount to Apply" <> 0 THEN  BEGIN
                            CustLedgEntry."Amount to Apply" := 0;
                            CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
                          END;
                          "Exported to Payment File" := CustLedgEntry."Exported to Payment File";
                          "Applies-to Ext. Doc. No." := '';
                        END;
                      END;
                    TempGenJnlLine."Account Type"::Vendor:
                      BEGIN
                        VendLedgEntry.SETCURRENTKEY("Document No.");
                        VendLedgEntry.SETRANGE("Document No.",xRec."Applies-to Doc. No.");
                        IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                          VendLedgEntry.SETRANGE("Document Type",xRec."Applies-to Doc. Type");
                        VendLedgEntry.SETRANGE("Vendor No.",TempGenJnlLine."Account No.");
                        VendLedgEntry.SETRANGE(Open,TRUE);
                        IF VendLedgEntry.FINDFIRST THEN BEGIN
                          IF VendLedgEntry."Amount to Apply" <> 0 THEN  BEGIN
                            VendLedgEntry."Amount to Apply" := 0;
                            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
                          END;
                          "Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                        END;
                        "Applies-to Ext. Doc. No." := '';
                      END;
                    TempGenJnlLine."Account Type"::Employee:
                      BEGIN
                        EmplLedgEntry.SETCURRENTKEY("Document No.");
                        EmplLedgEntry.SETRANGE("Document No.",xRec."Applies-to Doc. No.");
                        IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                          EmplLedgEntry.SETRANGE("Document Type",xRec."Applies-to Doc. Type");
                        EmplLedgEntry.SETRANGE("Employee No.",TempGenJnlLine."Account No.");
                        EmplLedgEntry.SETRANGE(Open,TRUE);
                        IF EmplLedgEntry.FINDFIRST THEN BEGIN
                          IF EmplLedgEntry."Amount to Apply" <> 0 THEN BEGIN
                            EmplLedgEntry."Amount to Apply" := 0;
                            CODEUNIT.RUN(CODEUNIT::"Empl. Entry-Edit",EmplLedgEntry);
                          END;
                          "Exported to Payment File" := EmplLedgEntry."Exported to Payment File";
                        END;
                      END;
                  END;
                END;
                
                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (Amount <> 0) THEN BEGIN
                  IF xRec."Applies-to Doc. No." <> '' THEN
                    PaymentToleranceMgt.DelPmtTolApllnDocNo(Rec,xRec."Applies-to Doc. No.");
                  SetApplyToAmount;
                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                  xRec.ClearAppliedGenJnlLine;
                END;
                
                CASE "Account Type" OF
                  "Account Type"::Customer:
                    GetCustLedgerEntry;
                  "Account Type"::Vendor:
                    GetVendLedgerEntry;
                  "Account Type"::Employee:
                    GetEmplLedgerEntry;
                END;
                
                ValidateApplyRequirements(Rec);
                SetJournalLineFieldsFromApplication;
                
                IF "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice THEN
                  UpdateAppliesToInvoiceID;
                */

            end;
        }
        field(30; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;

            trigger OnValidate()
            begin
                IF ("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Fixed Asset",
                                       "Account Type"::"IC Partner", "Account Type"::Employee]) AND
                   ("Bal. Account Type" IN ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor, "Bal. Account Type"::"Fixed Asset",
                                            "Bal. Account Type"::"IC Partner", "Bal. Account Type"::Employee])
                THEN
                    ERROR(
                      Text000,
                      FIELDCAPTION("Account Type"), FIELDCAPTION("Bal. Account Type"));

                IF ("Bal. Account Type" = "Bal. Account Type"::Employee) AND ("Currency Code" <> '') THEN
                    ERROR(OnlyLocalCurrencyForEmployeeErr);

                VALIDATE("Bal. Account No.", '');
                IF "Bal. Account Type" IN
                   ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor, "Bal. Account Type"::"Bank Account", "Bal. Account Type"::Employee]
                THEN BEGIN

                END ELSE
                    IF "Account Type" IN [
                                          "Bal. Account Type"::"G/L Account", "Account Type"::"Bank Account", "Account Type"::"Fixed Asset"]
                    THEN

                        //UpdateSource;
                        IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                THEN BEGIN
                            "Depreciation Book Code" := '';
                            VALIDATE("FA Posting Type", "FA Posting Type"::" ");
                        END;
                IF xRec."Bal. Account Type" IN
                   [xRec."Bal. Account Type"::Customer, xRec."Bal. Account Type"::Vendor]
                THEN BEGIN

                END;
                IF ("Account Type" IN [
                                       "Account Type"::"G/L Account", "Account Type"::"Bank Account", "Account Type"::"Fixed Asset"]) AND
                   ("Bal. Account Type" IN [
                                            "Bal. Account Type"::"G/L Account", "Bal. Account Type"::"Bank Account", "Bal. Account Type"::"Fixed Asset"])
                THEN
                    IF "Bal. Account Type" = "Bal. Account Type"::"IC Partner" THEN BEGIN

                        IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany THEN
                            FIELDERROR("Bal. Account Type");
                    END;
                IF "Bal. Account Type" <> "Bal. Account Type"::"Bank Account" THEN;
            end;
        }
        field(31; "External Document No.";
        Code[35])
        {
            Caption = 'External "Document No."';
            DataClassification = ToBeClassified;
        }
        field(32; "FA Posting Date"; Date)
        {
            AccessByPermission = TableData 5600 = R;
            Caption = 'FA Posting Date';
            DataClassification = ToBeClassified;
        }
        field(33; "FA Posting Type"; Option)
        {
            AccessByPermission = TableData 5600 = R;
            Caption = 'FA Posting Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance';
            OptionMembers = " ","Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance;

            trigger OnValidate()
            begin
                IF NOT (("Account Type" = "Account Type"::"Fixed Asset") OR
                         ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")) AND
                   ("FA Posting Type" = "FA Posting Type"::" ")
                THEN BEGIN
                    "FA Posting Date" := 0D;

                END;
            end;
        }
        field(34; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            DataClassification = ToBeClassified;
            TableRelation = "Depreciation Book";

            trigger OnValidate()
            var
                FADeprBook: Record 5612;
            begin
                IF "Depreciation Book Code" = '' THEN
                    EXIT;

                IF ("Account No." <> '') AND
                   ("Account Type" = "Account Type"::"Fixed Asset")
                THEN BEGIN
                    FADeprBook.GET("Account No.", "Depreciation Book Code");
                    //"Posting Group" := FADeprBook."FA Posting Group";
                END;

                IF ("Bal. Account No." <> '') AND
                   ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")
                THEN BEGIN
                    FADeprBook.GET("Bal. Account No.", "Depreciation Book Code");
                    //  "Posting Group" := FADeprBook."FA Posting Group";
                END;
            end;
        }
        field(35; Description2; Text[250])
        {
            Caption = 'Description2';
            DataClassification = ToBeClassified;
        }
        field(36; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(37; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(38; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(39; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(40; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(41; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(50; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group"
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "FA Posting Group";
        }
        field(60; "Account Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "Bal. Account Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(100; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Posted By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(103; "Time Posted"; Time)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", "JV No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label '%1 or %2 must be a G/L Account or Bank Account.', Comment = '%1=Account Type,%2=Balance Account Type';
        Text001: Label 'You must not specify %1 when %2 is %3.';
        Text002: Label 'cannot be specified without %1';
        ChangeCurrencyQst: Label 'The Currency Code in the Gen. Journal Line will be changed from %1 to %2.\\Do you want to continue?', Comment = '%1=FromCurrencyCode, %2=ToCurrencyCode';
        UpdateInterruptedErr: Label 'The update has been interrupted to respect the warning.';
        Text006: Label 'The %1 option can only be used internally in the system.';
        Text007: Label '%1 or %2 must be a bank account.', Comment = '%1=Account Type,%2=Balance Account Type';
        Text008: Label ' must be 0 when %1 is %2.';
        Text009: Label 'LCY';
        Text010: Label '%1 must be %2 or %3.';
        Text011: Label '%1 must be negative.';
        Text012: Label '%1 must be positive.';
        Text013: Label 'The %1 must not be more than %2.';
        Text014: Label 'The %1 %2 has a %3 %4.\\Do you still want to use %1 %2 in this journal line?', Comment = '%1=Caption of Table Customer, %2=Customer No, %3=Caption of field Bill-to Customer No, %4=Value of Bill-to customer no.';
        Text015: Label 'You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.';
        Text016: Label '%1 must be G/L Account or Bank Account.';
        Text018: Label '%1 can only be set when %2 is set.';
        Text019: Label '%1 cannot be changed when %2 is set.';
        ExportAgainQst: Label 'One or more of the selected lines have already been exported. Do you want to export them again?';
        NothingToExportErr: Label 'There is nothing to export.';
        NotExistErr: Label 'Document number %1 does not exist or is already closed.', Comment = '%1=Document number';
        DocNoFilterErr: Label 'The document numbers cannot be renumbered while there is an active filter on the "Document No." field.';
        DueDateMsg: Label 'This posting date will cause an overdue payment.';
        CalcPostDateMsg: Label 'Processing payment journal lines #1##########';
        NoEntriesToVoidErr: Label 'There are no entries to void.';
        OnlyLocalCurrencyForEmployeeErr: Label 'The value of the Currency Code field must be empty. General journal lines in foreign currency are not supported for employee account type.';
        SalespersonPurchPrivacyBlockErr: Label 'Privacy Blocked must not be true for Salesperson / Purchaser %1.', Comment = '%1 = salesperson / purchaser code.';
        BlockedErr: Label 'The Blocked field must not be %1 for %2 %3.', Comment = '%1=Blocked field value,%2=Account Type,%3=Account No.';
        BlockedEmplErr: Label 'You cannot export file because employee %1 is blocked due to privacy.', Comment = '%1 = Employee no. ';
        GenJnlTemplate: Record 80;
        GenJnlBatch: Record 232;
        GenJnlLine: Record 81;
        Currency: Record 4;
        CurrExchRate: Record 330;
        PaymentTerms: Record 3;
        CustLedgEntry: Record 21;
        VendLedgEntry: Record 25;
        EmplLedgEntry: Record 5222;
        GenJnlAlloc: Record 221;
        VATPostingSetup: Record 325;
        GenBusPostingGrp: Record 250;
        GenProdPostingGrp: Record 251;
        GLSetup: Record 98;
        Job: Record 167;
        SourceCodeSetup: Record 242;
        TempJobJnlLine: Record 210 temporary;
        SalespersonPurchaser: Record 13;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustCheckCreditLimit: Codeunit 312;
        SalesTaxCalculate: Codeunit 398;
        GenJnlApply: Codeunit 225;
        GenJnlShowCTEntries: Codeunit 16;
        CustEntrySetApplID: Codeunit 101;
        VendEntrySetApplID: Codeunit 111;
        EmplEntrySetApplID: Codeunit 112;
        DimMgt: Codeunit 408;
        PaymentToleranceMgt: Codeunit 426;
        DeferralUtilities: Codeunit 1720;
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Fund Ext";
        Window: Dialog;
        DeferralDocType: Option Purchase,Sales,"G/L";
        CurrencyCode: Code[10];
        TemplateFound: Boolean;
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        GLSetupRead: Boolean;
        GLAccount: Record 15;
        CustomerCard: Record 18;
        VendorCard: Record 23;
        FixedAsset: Record 5600;
        BankAccount: Record 270;

    local procedure GetCurrency()
    begin
        /*IF "Additional-Currency Posting" =
           "Additional-Currency Posting"::"Additional-Currency Amount Only"
        THEN BEGIN
          IF GLSetup."Additional Reporting Currency" = '' THEN
            ReadGLSetup;
          CurrencyCode := GLSetup."Additional Reporting Currency";
        END ELSE
          CurrencyCode := "Currency Code";
        
        IF CurrencyCode = '' THEN BEGIN
          CLEAR(Currency);
          Currency.InitRoundingPrecision
        END ELSE
          IF CurrencyCode <> Currency.Code THEN BEGIN
            Currency.GET(CurrencyCode);
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
          */

    end;
}


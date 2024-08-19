table 50005 "Receipt Line"
{
    Caption = 'Receipt Line';

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
            TableRelation = "Receipt Header"."No.";
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt,Funds Transfer,Imprest,Imprest Surrender';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Receipt,"Funds Transfer",Imprest,"Imprest Surrender";
        }
        field(4; "Receipt Code"; Code[50])
        {
            Caption = 'Receipt Code';
            TableRelation = "Funds Transaction Code"."Transaction Code" WHERE("Transaction Type" = CONST(Receipt));

            trigger OnValidate()
            begin
                "Account Type" := "Account Type"::"G/L Account";
                "Account No." := '';
                "Posting Group" := '';
                "Receipt Code Description" := '';
                "VAT Code" := '';
                "Withholding Tax Code" := '';
                "Withholding VAT Code" := '';
                FundsTransactionCodes.RESET;
                FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code", "Receipt Code");
                IF FundsTransactionCodes.FINDFIRST THEN BEGIN
                    "Account Type" := FundsTransactionCodes."Account Type";
                    "Account No." := FundsTransactionCodes."Account No.";
                    "Posting Group" := FundsTransactionCodes."Posting Group";
                    "Receipt Code Description" := FundsTransactionCodes.Description;
                    IF FundsTransactionCodes."Include VAT" THEN
                        "VAT Code" := FundsTransactionCodes."VAT Code";
                    IF FundsTransactionCodes."Include Withholding Tax" THEN
                        "Withholding Tax Code" := FundsTransactionCodes."Withholding Tax Code";
                    IF FundsTransactionCodes."Include Withholding VAT" THEN
                        "Withholding VAT Code" := FundsTransactionCodes."Withholding VAT Code";
                    //Employee Transaction Type
                    "Employee Transaction Type" := FundsTransactionCodes."Transaction Type";
                END;

                VALIDATE("Account No.");
            end;
        }
        field(5; "Receipt Code Description"; Text[100])
        {
            Caption = 'Receipt Code Description';
            Editable = false;
        }
        field(6; "Account Type"; Option)
        {
            Caption = 'Account Type';
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
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
                        ReceiptHeader.RESET;
                        ReceiptHeader.SETRANGE(ReceiptHeader."No.", "Document No.");
                        IF ReceiptHeader.FINDFIRST THEN BEGIN
                            IF ReceiptHeader."Received From" = '' THEN
                                ReceiptHeader."Received From" := Customer.Name;
                            ReceiptHeader.MODIFY;
                        END;
                    END;
                END;

                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Account No.") THEN BEGIN
                        "Account Name" := Vendor.Name;
                    END;
                END;

                IF "Account Type" = "Account Type"::Employee THEN BEGIN
                    IF Employee.GET("Account No.") THEN BEGIN
                        "Account Name" := Employee.FullName;
                        ReceiptHeader.RESET;
                        IF ReceiptHeader.GET("Document No.") THEN BEGIN
                            ReceiptHeader."Received From" := Employee.FullName;
                            ReceiptHeader.MODIFY;
                        END;
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
            Editable = false;
        }
        field(21; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
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

                VALIDATE("VAT Code");
                VALIDATE("Withholding Tax Code");
            end;
        }
        field(24; "Amount(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
            Editable = false;
        }
        field(25; "VAT Code"; Code[10])
        {
            Caption = 'VAT Code';
            TableRelation = "Funds Tax Code"."Tax Code" WHERE(Type = CONST(VAT));
        }
        field(26; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Editable = false;
        }
        field(27; "VAT Amount(LCY)"; Decimal)
        {
            Caption = 'VAT Amount(LCY)';
            Editable = false;
        }
        field(28; "Withholding Tax Code"; Code[10])
        {
            Caption = 'Withholding Tax Code';
            TableRelation = "Funds Tax Code"."Tax Code" WHERE(Type = CONST("W/TAX"));
        }
        field(29; "Withholding Tax Amount"; Decimal)
        {
            Caption = 'Withholding Tax Amount';
            Editable = false;
        }
        field(30; "Withholding Tax Amount(LCY)"; Decimal)
        {
            Caption = 'Withholding Tax Amount(LCY)';
            Editable = false;
        }
        field(31; "Withholding VAT Code"; Code[10])
        {
            Caption = 'Withholding VAT Code';
            TableRelation = "Funds Tax Code"."Tax Code" WHERE(Type = CONST("W/VAT"));
        }
        field(32; "Withholding VAT Amount"; Decimal)
        {
            Caption = 'Withholding VAT Amount';
            Editable = false;
        }
        field(33; "Withholding VAT Amount(LCY)"; Decimal)
        {
            Caption = 'Withholding VAT Amount(LCY)';
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
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Invoice,SCMProFit Job';
            OptionMembers = " ",Invoice,"SCMProFit Job";
        }
        field(37; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                VendLedgEntry: Record 21;
                PayToVendorNo: Code[20];
                OK: Boolean;
                Text000: Label 'You must specify %1 or %2.';
                AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
                AccNo: Code[20];
            begin
                /*WITH Rec DO BEGIN
                  Amount:=0;
                  VALIDATE(Amount);
                  BillToCustNo := Rec."Account No." ;
                  CustLedgEntry.SETCURRENTKEY("Customer No.",Open);
                  CustLedgEntry.SETRANGE("Customer No.", BillToCustNo);
                  CustLedgEntry.SETRANGE(Open,TRUE);
                  IF "Applies-to ID" = '' THEN
                    "Applies-to ID" := "Document No.";
                  IF "Applies-to ID" = '' THEN
                    ERROR(
                      Text000,
                      FIELDCAPTION("Document No."),FIELDCAPTION("Applies-to ID"));
                  ApplyCustEntries.SetReceiptLine(Rec,Rec.FIELDNO("Applies-to ID"));
                  ApplyCustEntries.SETRECORD(CustLedgEntry);
                  ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
                  ApplyCustEntries.LOOKUPMODE(TRUE);
                  OK := ApplyCustEntries.RUNMODAL = ACTION::LookupOK;
                  CLEAR(ApplyCustEntries);
                  IF NOT OK THEN
                    EXIT;
                  CustLedgEntry.RESET;
                  CustLedgEntry.SETCURRENTKEY("Customer No.",Open);
                  CustLedgEntry.SETRANGE("Customer No.", BillToCustNo);
                  CustLedgEntry.SETRANGE(Open,TRUE);
                  CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
                  IF CustLedgEntry.FIND('-') THEN BEGIN
                    "Applies-to Doc. Type" :=CustLedgEntry."Applies-to Doc. Type";
                    "Applies-to Doc. No.":=  CustLedgEntry."Applies-to Doc. No.";
                  END ELSE
                    "Applies-to ID" := '';
                
                END;
                //Calculate Total Amount
                  CustLedgEntry.RESET;
                  CustLedgEntry.SETCURRENTKEY("Customer No.",Open,"Applies-to ID");
                  CustLedgEntry.SETRANGE("Customer No.", BillToCustNo);
                  CustLedgEntry.SETRANGE(Open,TRUE);
                  CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
                  IF CustLedgEntry.FINDFIRST THEN BEGIN
                      CustLedgEntry.CALCSUMS(CustLedgEntry."Amount to Apply");
                      Amount:=ABS(CustLedgEntry."Amount to Apply");
                      VALIDATE(Amount);
                  END;*/

                IF ("Account Type" <> "Account Type"::Customer) AND ("Account Type" <> Rec."Account Type"::Vendor) THEN
                    ERROR(ApplicationNotAllowed, "Account Type");

                xRec.Amount := Amount;
                xRec."Currency Code" := "Currency Code";
                xRec."Posting Date" := "Posting Date";

                GetAccTypeAndNo(Rec, AccType, AccNo);
                CLEAR(VendLedgEntry);

                CASE AccType OF
                    AccType::Vendor:
                        LookUpAppliesToDocVend(AccNo);
                END;
                //SetPaymentLineFieldsFromApplication;

            end;

            trigger OnValidate()
            begin
                /*IF "Applies-to Doc. Type"="Applies-to Doc. Type"::Invoice THEN BEGIN
                  ReceiptHeader.RESET;
                  ReceiptHeader.SETRANGE(ReceiptHeader."No.","Applies-to Doc. No.");
                  IF ReceiptHeader.FINDFIRST THEN BEGIN
                    //ReceiptHeader.CALCFIELDS("Amount Including VAT");
                    "VAT Amount":=ReceiptHeader."Amount Received";
                    VALIDATE("VAT Amount");
                  END;
                END;*/

            end;
        }
        field(38; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                TempVendLedgEntry: Record 25;
            begin
                /*IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN BEGIN
                  CustLedgEntry.SETCURRENTKEY("Customer No.",Open);
                  CustLedgEntry.SETRANGE("Customer No.","Account No.");
                  CustLedgEntry.SETRANGE(Open,TRUE);
                  CustLedgEntry.SETRANGE("Applies-to ID",xRec."Applies-to ID");
                  IF CustLedgEntry.FINDFIRST THEN
                   CustEntrySetAppliesToID.SetApplId(CustLedgEntry,TempCustLedgEntry,'');
                  CustLedgEntry.RESET;
                  END;*/

            end;
        }
        field(39; Committed; Boolean)
        {
            Caption = 'Committed';
            Editable = false;
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
            // Field52136925=FIELD("Global Dimension 1 Code"));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                        Blocked = CONST(false));
            // Field52136925=FIELD("Global Dimension 1 Code"));

        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                       Blocked = CONST(false));
            // Field52136925=FIELD("Global Dimension 1 Code"));

        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                            Blocked = CONST(false));
            // Field52136925=FIELD("Global Dimension 1 Code"));

        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                    Blocked = CONST(false));
            // Field52136925=FIELD("Global Dimension 1 Code"));

        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                  Blocked = CONST(false));
            // Field52136925=FIELD("Global Dimension 1 Code"));

        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                       Blocked = CONST(false));
            // Field52136925=FIELD("Global Dimension 1 Code"));

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
        field(52136965; "Job No."; Code[20])
        {
            Description = 'SCMProFit Integration';
        }
        field(52137023; "Employee Transaction Type"; Option)
        {
            Caption = 'Employee Transaction Type';
            Description = '//Sysre NextGen Addon-Categories Employee Transactions';
            OptionCaption = ' ,NetPay,Imprest';
            OptionMembers = " ",NetPay,Imprest;
        }
        field(52137640; "Loan Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137641; "Loan Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Loan Disbursed,Principal Receivable,Principal Paid,Interest Receivable,Interest Paid,Penalty Receivable,Penalty Paid,Loan Charge Receivable,Loan Charge Paid';
            OptionMembers = " ","Loan Disbursed","Principal Receivable","Principal Paid","Interest Receivable","Interest Paid","Penalty Receivable","Penalty Paid","Loan Charge Receivable","Loan Charge Paid";
        }
        field(52137862; "Investment Application No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*
                InvestmentApplications.RESET;
                InvestmentApplications.SETRANGE(InvestmentApplications."No.","Investment Application No.");
                IF InvestmentApplications.FINDFIRST THEN BEGIN
                  ReceiptHeader.RESET;
                  ReceiptHeader.SETRANGE(ReceiptHeader."No.","Document No.");
                  IF ReceiptHeader.FINDFIRST THEN BEGIN
                    IF ReceiptHeader."Received From"='' THEN
                    ReceiptHeader."Received From":=InvestmentApplications.Name;
                    ReceiptHeader.MODIFY;
                  END;
                END;
                */

            end;
        }
        field(52137863; "Investment Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
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
        ReceiptHeader.RESET;
        ReceiptHeader.SETRANGE(ReceiptHeader."No.", "Document No.");
        IF ReceiptHeader.FINDFIRST THEN BEGIN
            ReceiptHeader.TESTFIELD(ReceiptHeader.Status, ReceiptHeader.Status::Open);
        END;
    end;

    trigger OnInsert()
    begin
        ReceiptHeader.RESET;
        ReceiptHeader.SETRANGE(ReceiptHeader."No.", "Document No.");
        IF ReceiptHeader.FINDFIRST THEN BEGIN
            ReceiptHeader.TESTFIELD(ReceiptHeader.Description);
            Description := ReceiptHeader.Description;
            "Document Type" := "Document Type"::Receipt;
            "Posting Date" := ReceiptHeader."Posting Date";
            "Currency Code" := ReceiptHeader."Currency Code";
            "Currency Factor" := ReceiptHeader."Currency Factor";
            "Global Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ReceiptHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := ReceiptHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code" := ReceiptHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code" := ReceiptHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code" := ReceiptHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code" := ReceiptHeader."Shortcut Dimension 8 Code";
            "Responsibility Center" := ReceiptHeader."Responsibility Center";
        END;
    end;

    var
        Text000: Label 'You must specify %1 or %2';
        FundsTransactionCodes: Record 50027;
        FundsTaxCodes: Record 50028;
        "G/LAccount": Record 15;
        BankAccount: Record 270;
        Customer: Record 18;
        Vendor: Record 23;
        FixedAsset: Record 5600;
        ICPartner: Record 413;
        Employee: Record 5200;
        ReceiptHeader: Record 50004;
        ReceiptLine: Record 50005;
        CurrExchRate: Record 330;
        CustLedgEntry: Record 21;
        VendLedgEntry: Record 21;
        EmplLedgEntry: Record 5222;
        BillToCustNo: Code[30];
        //  ApplyCustEntries: Page 232;
        //CustEntrySetAppliesToID: Codeunit 101;
        TempCustLedgEntry: Record 21;
        DocumentNotOpen: Label 'You can only modify Open Documents, Current Status is:%1';
        ApplicationNotAllowed: Label 'You cannot apply to %1';

    [Scope('onPrem')]
    procedure LookUpAppliesToDocCust(AccNo: Code[20])
    var
    //  ApplyCustEntries: Page 232;
    begin
        /*CLEAR(CustLedgEntry);
        CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
        IF AccNo <> '' THEN
          CustLedgEntry.SETRANGE("Customer No.",AccNo);
        CustLedgEntry.SETRANGE(Open,TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
          CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF CustLedgEntry.ISEMPTY THEN BEGIN
            CustLedgEntry.SETRANGE("Document Type");
            CustLedgEntry.SETRANGE("Document No.");
          END;
        END;
        IF "Applies-to ID" <> '' THEN BEGIN
          CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF CustLedgEntry.ISEMPTY THEN
            CustLedgEntry.SETRANGE("Applies-to ID");
        END;
        IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
          CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          IF CustLedgEntry.ISEMPTY THEN
            CustLedgEntry.SETRANGE("Document Type");
        END;
        IF Amount <> 0 THEN BEGIN
          CustLedgEntry.SETRANGE(Positive,Amount < 0);
          IF CustLedgEntry.ISEMPTY THEN
            CustLedgEntry.SETRANGE(Positive);
        END;
        ApplyCustEntries.SetReceiptLine(Rec,ReceiptLine.FIELDNO("Applies-to Doc. No."));
        ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
        ApplyCustEntries.SETRECORD(CustLedgEntry);
        ApplyCustEntries.LOOKUPMODE(TRUE);
        IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ApplyCustEntries.GETRECORD(CustLedgEntry);
          IF AccNo = '' THEN BEGIN
            AccNo := CustLedgEntry."Customer No.";
            VALIDATE("Account No.",AccNo);
          END;
          SetAmountWithCustLedgEntry;
          "Applies-to Doc. Type" := CustLedgEntry."Document Type";
          "Applies-to Doc. No." := CustLedgEntry."Document No.";
          "Applies-to ID" := '';
        END;*/

    end;

    // [Scope('')]
    procedure LookUpAppliesToDocVend(AccNo: Code[20])
    var
    //  ApplyVendEntries: Page 233;
    begin
        /*CLEAR(VendLedgEntry);
        VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
        IF AccNo <> '' THEN
          VendLedgEntry.SETRANGE("Vendor No.",AccNo);
        VendLedgEntry.SETRANGE(Open,TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
          VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF VendLedgEntry.ISEMPTY THEN BEGIN
            VendLedgEntry.SETRANGE("Document Type");
            VendLedgEntry.SETRANGE("Document No.");
          END;
        END;
        IF "Applies-to ID" <> '' THEN BEGIN
          VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF VendLedgEntry.ISEMPTY THEN
            VendLedgEntry.SETRANGE("Applies-to ID");
        END;
        IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
          VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          IF VendLedgEntry.ISEMPTY THEN
            VendLedgEntry.SETRANGE("Document Type");
        END;
        IF  "Applies-to Doc. No." <> ''THEN BEGIN
          VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF VendLedgEntry.ISEMPTY THEN
            VendLedgEntry.SETRANGE("Document No.");
        END;
        IF Amount <> 0 THEN BEGIN
          VendLedgEntry.SETRANGE(Positive,Amount < 0);
          IF VendLedgEntry.ISEMPTY THEN;
          VendLedgEntry.SETRANGE(Positive);
        END;
        ApplyVendEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
        ApplyVendEntries.SETRECORD(VendLedgEntry);
        ApplyVendEntries.LOOKUPMODE(TRUE);
        IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ApplyVendEntries.GETRECORD(VendLedgEntry);
          IF AccNo = '' THEN BEGIN
            AccNo := VendLedgEntry."Vendor No.";
            IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN
              VALIDATE("Bal. Account No.",AccNo)
            ELSE
              VALIDATE("Account No.",AccNo);
          END;
          SetAmountWithVendLedgEntry;
          "Applies-to Doc. Type" := VendLedgEntry."Document Type";
          "Applies-to Doc. No." := VendLedgEntry."Document No.";
          "Applies-to ID" := '';
        END;
        */

    end;

    [Scope('onPrem')]
    procedure LookUpAppliesToDocEmpl(AccNo: Code[20])
    var
        ApplyEmplEntries: Page 234;
    begin
        /*CLEAR(EmplLedgEntry);
        EmplLedgEntry.SETCURRENTKEY("Employee No.",Open,Positive);
        IF AccNo <> '' THEN
          EmplLedgEntry.SETRANGE("Employee No.",AccNo);
        EmplLedgEntry.SETRANGE(Open,TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
          EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF EmplLedgEntry.ISEMPTY THEN BEGIN
            EmplLedgEntry.SETRANGE("Document Type");
            EmplLedgEntry.SETRANGE("Document No.");
          END;
        END;
        IF "Applies-to ID" <> '' THEN BEGIN
          EmplLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF EmplLedgEntry.ISEMPTY THEN
            EmplLedgEntry.SETRANGE("Applies-to ID");
        END;
        IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
          EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          IF EmplLedgEntry.ISEMPTY THEN
            EmplLedgEntry.SETRANGE("Document Type");
        END;
        IF  "Applies-to Doc. No." <> '' THEN BEGIN
          EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF EmplLedgEntry.ISEMPTY THEN
            EmplLedgEntry.SETRANGE("Document No.");
        END;
        IF Amount <> 0 THEN BEGIN
          EmplLedgEntry.SETRANGE(Positive,Amount < 0);
          IF EmplLedgEntry.ISEMPTY THEN;
          EmplLedgEntry.SETRANGE(Positive);
        END;
        ApplyEmplEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyEmplEntries.SETTABLEVIEW(EmplLedgEntry);
        ApplyEmplEntries.SETRECORD(EmplLedgEntry);
        ApplyEmplEntries.LOOKUPMODE(TRUE);
        IF ApplyEmplEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ApplyEmplEntries.GETRECORD(EmplLedgEntry);
          IF AccNo = '' THEN BEGIN
            AccNo := EmplLedgEntry."Employee No.";
            IF "Bal. Account Type" = "Bal. Account Type"::Employee THEN
              VALIDATE("Bal. Account No.",AccNo)
            ELSE
              VALIDATE("Account No.",AccNo);
          END;
          SetAmountWithEmplLedgEntry;
          "Applies-to Doc. Type" := EmplLedgEntry."Document Type";
          "Applies-to Doc. No." := EmplLedgEntry."Document No.";
          "Applies-to ID" := '';
        END;
        */

    end;

    local procedure "..IGS"()
    begin
    end;

    procedure LookUpAppliesToDocCust1(AccNo: Code[20])
    var
        ApplyVendEntries: Page 232;
    begin
        CLEAR(VendLedgEntry);
        VendLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date");
        IF AccNo <> '' THEN
            VendLedgEntry.SETRANGE("Customer No.", AccNo);
        VendLedgEntry.SETRANGE(Open, TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
            VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
            VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
            IF VendLedgEntry.ISEMPTY THEN BEGIN
                VendLedgEntry.SETRANGE("Document Type");
                VendLedgEntry.SETRANGE("Document No.");
            END;
        END;
        IF "Applies-to ID" <> '' THEN BEGIN
            VendLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
            IF VendLedgEntry.ISEMPTY THEN
                VendLedgEntry.SETRANGE("Applies-to ID");
        END;
        IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
            VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
            IF VendLedgEntry.ISEMPTY THEN
                VendLedgEntry.SETRANGE("Document Type");
        END;
        IF "Applies-to Doc. No." <> '' THEN BEGIN
            VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
            IF VendLedgEntry.ISEMPTY THEN
                VendLedgEntry.SETRANGE("Document No.");
        END;
        IF Amount <> 0 THEN BEGIN
            VendLedgEntry.SETRANGE(Positive, Amount < 0);
            IF VendLedgEntry.ISEMPTY THEN;
            VendLedgEntry.SETRANGE(Positive);
        END;
        //ApplyVendEntries.SetReceiptLine(Rec, ReceiptLine.FIELDNO("Applies-to Doc. No."));//to be added after extension has been developed
        ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
        ApplyVendEntries.SETRECORD(VendLedgEntry);
        ApplyVendEntries.LOOKUPMODE(TRUE);
        IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ApplyVendEntries.GETRECORD(VendLedgEntry);
            IF AccNo = '' THEN BEGIN
                AccNo := VendLedgEntry."Customer No.";
                VALIDATE("Account No.", AccNo);
            END;
            SetAmountWithVendLedgEntry;
            "Applies-to Doc. Type" := VendLedgEntry."Document Type";
            "Applies-to Doc. No." := VendLedgEntry."Document No.";
            "Applies-to ID" := '';
        END;
    end;

    procedure SetApplyToAmount()
    begin
        IF "Account Type" = "Account Type"::Customer THEN BEGIN
            VendLedgEntry.SETCURRENTKEY("Document No.");
            VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
            VendLedgEntry.SETRANGE("Customer No.", "Account No.");
            VendLedgEntry.SETRANGE(Open, TRUE);
            IF VendLedgEntry.FIND('-') THEN
                IF VendLedgEntry."Amount to Apply" = 0 THEN BEGIN
                    VendLedgEntry.CALCFIELDS("Remaining Amount");
                    VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                    CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                END;
        END;
    end;

    local procedure GetAccTypeAndNo(PaymentLine2: Record 50005; var AccType: Option; var AccNo: Code[20])
    begin
        AccType := PaymentLine2."Account Type";
        AccNo := PaymentLine2."Account No.";
    end;

    local procedure SetAmountWithVendLedgEntry()
    begin
        IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
            CheckModifyCurrencyCode("Account Type"::Vendor, VendLedgEntry."Currency Code");
        IF Amount = 0 THEN BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            SetAmountWithRemaining(FALSE, VendLedgEntry."Amount to Apply", VendLedgEntry."Remaining Amount", VendLedgEntry."Remaining Pmt. Disc. Possible");
        END;
    end;

    procedure CheckModifyCurrencyCode(AccountType: Option; CustVendLedgEntryCurrencyCode: Code[10])
    begin
    end;

    local procedure SetAmountWithRemaining(CalcPmtDisc: Boolean; AmountToApply: Decimal; RemainingAmount: Decimal; RemainingPmtDiscPossible: Decimal)
    begin
        IF AmountToApply <> 0 THEN
            IF CalcPmtDisc AND (ABS(AmountToApply) >= ABS(RemainingAmount - RemainingPmtDiscPossible)) THEN
                Amount := -(RemainingAmount - RemainingPmtDiscPossible)
            ELSE
                Amount := -AmountToApply
        ELSE
            IF CalcPmtDisc THEN
                Amount := -(RemainingAmount - RemainingPmtDiscPossible)
            ELSE
                Amount := -RemainingAmount;
        VALIDATE(Amount);
    end;

    local procedure SetPaymentLineFieldsFromApplication()
    var
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo: Code[20];
    begin
        /*"Exported to Payment File" := FALSE;
        GetAccTypeAndNo(Rec,AccType,AccNo);
        CASE AccType OF
          AccType::Vendor:
            IF "Applies-to ID" <> '' THEN BEGIN
              IF FindFirstVendLedgEntryWithAppliesToID(AccNo,"Applies-to ID") THEN BEGIN
                VendLedgEntry.SETRANGE("Exported to Payment File",TRUE);
                "Exported to Payment File" := VendLedgEntry.FINDFIRST;
              END
            END ELSE
              IF "Applies-to Doc. No." <> '' THEN
                IF FindFirstVendLedgEntryWithAppliesToDocNo(AccNo,"Applies-to Doc. No.") THEN BEGIN
                  "Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                  "Applies-to Ext. Doc. No." := VendLedgEntry."External Document No.";
                END;
        END;*/

    end;

    local procedure FindFirstVendLedgEntryWithAppliesToID(AccNo: Code[20]; AppliesToID: Code[50]): Boolean
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open);
        VendLedgEntry.SETRANGE("Customer No.", AccNo);
        VendLedgEntry.SETRANGE("Applies-to ID", AppliesToID);
        VendLedgEntry.SETRANGE(Open, TRUE);
        EXIT(VendLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToDocNo(AccNo: Code[20]; AppliestoDocNo: Code[20]): Boolean
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.", AppliestoDocNo);
        VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
        VendLedgEntry.SETRANGE("Customer No.", AccNo);
        VendLedgEntry.SETRANGE(Open, TRUE);
        EXIT(VendLedgEntry.FINDFIRST)
    end;

    local procedure TestStatusOpen(AllowApproverEdit: Boolean)
    var
        PaymentHeader: Record 50004;
        ApprovalEntry: Record 454;
    begin
        PaymentHeader.GET("Document No.");
        IF AllowApproverEdit THEN BEGIN
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", PaymentHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", USERID);
            IF NOT ApprovalEntry.FINDFIRST THEN BEGIN
                PaymentHeader.TESTFIELD(Status, PaymentHeader.Status::Open);
            END;
        END ELSE BEGIN
            PaymentHeader.TESTFIELD(Status, PaymentHeader.Status::Open);
        END;//mesh
    end;
}


table 50003 "Payment Line"
{
    Caption = 'Payment Line';

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
            TableRelation = "Payment Header"."No.";
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Receipt,Funds Transfer,Imprest,Imprest Surrender';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Receipt,"Funds Transfer",Imprest,"Imprest Surrender";
        }
        field(4; "Payment Code"; Code[50])
        {
            Caption = 'Payment Code';
            TableRelation = "Funds Transaction Code"."Transaction Code" WHERE("Transaction Type" = CONST(Payment),
                                                                               "Funds Claim Code" = CONST(false));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Account Type" := "Account Type"::"G/L Account";
                "Account No." := '';
                "Posting Group" := '';
                "Payment Code Description" := '';
                "VAT Code" := '';
                "Withholding Tax Code" := '';
                "Withholding VAT Code" := '';
                FundsTransactionCodes.RESET;
                FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code", "Payment Code");
                IF FundsTransactionCodes.FINDFIRST THEN BEGIN
                    "Account Type" := FundsTransactionCodes."Account Type";
                    "Account No." := FundsTransactionCodes."Account No.";
                    "Posting Group" := FundsTransactionCodes."Posting Group";
                    "Payment Code Description" := FundsTransactionCodes.Description;
                    IF FundsTransactionCodes."Include VAT" THEN
                        "VAT Code" := FundsTransactionCodes."VAT Code";
                    IF FundsTransactionCodes."Include Withholding Tax" THEN
                        "Withholding Tax Code" := FundsTransactionCodes."Withholding Tax Code";
                    IF FundsTransactionCodes."Include Withholding VAT" THEN
                        "Withholding VAT Code" := FundsTransactionCodes."Withholding VAT Code";
                    //Employee Transaction Type
                    "Employee Transaction Type" := FundsTransactionCodes."Employee Transaction Type";
                END;

                VALIDATE("Account No.");
            end;
        }
        field(5; "Payment Code Description"; Text[100])
        {
            Caption = 'Payment Code Description';
            Editable = false;
        }
        field(6; "Account Type"; Option)
        {
            Caption = 'Account Type';
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Imprest';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Imprest;

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
            IF ("Account Type" = CONST(Employee)) Employee."No.";

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

                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    Vendor.RESET;
                    IF Vendor.GET("Account No.") THEN BEGIN
                        "Account Name" := Vendor.Name;

                        /* "Payee Bank Code" := Vendor."Bank Code";
                        "Payee Bank Name" := Vendor."Bank Name";
                        "Payee Bank Branch Code" := Vendor."Bank Branch Code";
                        "Payee Bank Branch Name" := Vendor."Bank Branch Name";
                        "Payee Bank Account No." := Vendor."Bank Account No.";
                        "Mobile Payment Account No." := Vendor."MPESA/Paybill Account No.";
 */
                        PaymentHeader.RESET;
                        PaymentHeader.GET("Document No.");
                        PaymentHeader."Payee Name" := Vendor.Name;
                        PaymentHeader.MODIFY;
                    END;
                END;

                IF "Account Type" = "Account Type"::Employee THEN BEGIN
                    IF Employee.GET("Account No.") THEN BEGIN
                        "Account Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                        // "Payee Bank Code" := Employee."Bank Code-d";
                        //   "Payee Bank Name" := Employee."Bank Name";
                        // "Payee Bank Branch Code" := Employee."Bank Branch Code-d";
                        //     "Payee Bank Branch Name" := Employee."Bank Branch Name";
                        "Payee Bank Account No." := Employee."Bank Account No.";
                        "Mobile Payment Account No." := Employee."Mobile Phone No.";
                        /*"Global Dimension 1 Code":=Employee."Global Dimension 1 Code";
                        "Shortcut Dimension 3 Code":=Employee."Shortcut Dimension 3 Code";
                        "Shortcut Dimension 4 Code":=Employee."Shortcut Dimension 4 Code";
                        "Shortcut Dimension 5 Code":=Employee."Shortcut Dimension 5 Code";
                        "Shortcut Dimension 6 Code":=Employee."Shortcut Dimension 6 Code";
                        "Shortcut Dimension 7 Code":=Employee."Shortcut Dimension 7 Code";
                        "Shortcut Dimension 8 Code":=Employee."Shortcut Dimension 8 Code";*/
                        PaymentHeader.RESET;
                        PaymentHeader.GET("Document No.");
                        PaymentHeader."Payee Name" := "Account Name";
                        PaymentHeader.Description := Description;
                        PaymentHeader.MODIFY;
                    END;
                END;

            end;
        }
        field(8; "Account Name"; Text[50])
        {
            Caption = 'Account Name';
            Editable = true;
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

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(10; Description; Text[200])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(11; "Reference No."; Code[30])
        {
            Caption = 'Reference No.';
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
        field(23; "Total Amount"; Decimal)
        {
            Caption = 'Amount Incl. VAT';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
                //Rounding
                IF FundsGeneralSetup.GET THEN BEGIN
                    IF FundsGeneralSetup."Payment Rounding Precision" <> 0 THEN BEGIN
                        IF FundsGeneralSetup."Payment Rounding Type" = FundsGeneralSetup."Payment Rounding Type"::Nearest THEN BEGIN
                            "Total Amount" := ROUND("Total Amount", FundsGeneralSetup."Payment Rounding Precision", '=');
                        END;
                        IF FundsGeneralSetup."Payment Rounding Type" = FundsGeneralSetup."Payment Rounding Type"::Up THEN BEGIN
                            "Total Amount" := ROUND("Total Amount", FundsGeneralSetup."Payment Rounding Precision", '>');
                        END;
                        IF FundsGeneralSetup."Payment Rounding Type" = FundsGeneralSetup."Payment Rounding Type"::Down THEN BEGIN
                            "Total Amount" := ROUND("Total Amount", FundsGeneralSetup."Payment Rounding Precision", '<');
                        END;
                    END;
                END;
                //End Rounding
                "Net Amount" := "Total Amount";
                IF "Currency Code" <> '' THEN BEGIN
                    "Total Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Total Amount", "Currency Factor"));
                    "Net Amount(LCY)" := "Total Amount(LCY)";
                END ELSE BEGIN
                    "Total Amount(LCY)" := "Total Amount";
                    "Net Amount(LCY)" := "Total Amount";
                END;
                VALIDATE("Total Amount(LCY)");
                VALIDATE("Net Amount(LCY)");

                VALIDATE("VAT Code");
                VALIDATE("Withholding Tax Code");
                VALIDATE("Withholding VAT Code");
            end;
        }
        field(24; "Total Amount(LCY)"; Decimal)
        {
            Caption = 'Amount Incl. VAT(LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                //Rounding
                IF FundsGeneralSetup.GET THEN BEGIN
                    IF FundsGeneralSetup."Payment Rounding Precision" <> 0 THEN BEGIN
                        IF FundsGeneralSetup."Payment Rounding Type" = FundsGeneralSetup."Payment Rounding Type"::Nearest THEN BEGIN
                            "Total Amount(LCY)" := ROUND("Total Amount(LCY)", FundsGeneralSetup."Payment Rounding Precision", '=');
                        END;
                        IF FundsGeneralSetup."Payment Rounding Type" = FundsGeneralSetup."Payment Rounding Type"::Up THEN BEGIN
                            "Total Amount(LCY)" := ROUND("Total Amount(LCY)", FundsGeneralSetup."Payment Rounding Precision", '>');
                        END;
                        IF FundsGeneralSetup."Payment Rounding Type" = FundsGeneralSetup."Payment Rounding Type"::Down THEN BEGIN
                            "Total Amount(LCY)" := ROUND("Total Amount(LCY)", FundsGeneralSetup."Payment Rounding Precision", '<');
                        END;
                    END;
                END;
                //End Rounding
            end;
        }
        field(25; "VAT Code"; Code[10])
        {
            Caption = 'VAT Code';
            TableRelation = "Funds Tax Code"."Tax Code" WHERE(Type = CONST(VAT));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
                "VAT Amount" := 0;
                VALIDATE("VAT Amount");
                "Withholding Tax Code" := '';
                VALIDATE("Withholding Tax Code");
                "Withholding VAT Code" := '';
                VALIDATE("Withholding VAT Code");

                IF "VAT Code" <> '' THEN BEGIN
                    FundsTaxCodes.RESET;
                    FundsTaxCodes.SETRANGE(FundsTaxCodes."Tax Code", "VAT Code");
                    IF FundsTaxCodes.FINDFIRST THEN BEGIN
                        "VAT Amount" := ROUND("Total Amount" - (("Total Amount" * 100) / (FundsTaxCodes.Percentage + 100)), 0.01);
                        VALIDATE("VAT Amount");
                    END;
                END;
            end;
        }
        field(26; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Net Amount" := "Total Amount";

                IF "Currency Code" <> '' THEN BEGIN
                    "VAT Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "VAT Amount", "Currency Factor"));
                    "Net Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Net Amount", "Currency Factor"));
                END ELSE BEGIN
                    "VAT Amount(LCY)" := "VAT Amount";
                    "Net Amount(LCY)" := "Net Amount";
                END;
                VALIDATE("Withholding VAT Code");
            end;
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

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
                "Withholding Tax Amount" := 0;
                VALIDATE("Withholding Tax Amount");

                IF "Withholding Tax Code" <> '' THEN BEGIN
                    FundsTaxCodes.RESET;
                    FundsTaxCodes.SETRANGE(FundsTaxCodes."Tax Code", "Withholding Tax Code");
                    IF FundsTaxCodes.FINDFIRST THEN BEGIN
                        "Withholding Tax Amount" := ROUND(("Total Amount" - "VAT Amount") * (FundsTaxCodes.Percentage / 100), 0.01);
                        ;
                        VALIDATE("Withholding Tax Amount");
                    END;
                END;
            end;
        }
        field(29; "Withholding Tax Amount"; Decimal)
        {
            Caption = 'Withholding Tax Amount';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
                //Rounding
                IF FundsGeneralSetup.GET THEN BEGIN
                    IF FundsGeneralSetup."W/Tax Rounding Precision" <> 0 THEN BEGIN
                        IF FundsGeneralSetup."W/Tax Rounding Type" = FundsGeneralSetup."W/Tax Rounding Type"::Nearest THEN BEGIN
                            "Withholding Tax Amount" := ROUND("Withholding Tax Amount", FundsGeneralSetup."W/Tax Rounding Precision", '=');
                        END;
                        IF FundsGeneralSetup."W/Tax Rounding Type" = FundsGeneralSetup."W/Tax Rounding Type"::Up THEN BEGIN
                            "Withholding Tax Amount" := ROUND("Withholding Tax Amount", FundsGeneralSetup."W/Tax Rounding Precision", '>');
                        END;
                        IF FundsGeneralSetup."W/Tax Rounding Type" = FundsGeneralSetup."W/Tax Rounding Type"::Down THEN BEGIN
                            "Withholding Tax Amount" := ROUND("Withholding Tax Amount", FundsGeneralSetup."W/Tax Rounding Precision", '<');
                        END;
                    END;
                END;
                //End Rounding
                "Net Amount" := "Total Amount" - "Withholding Tax Amount" - "Withholding VAT Amount" + "Catering Levy Amount" - "Retention Amount";
                IF "Currency Code" <> '' THEN BEGIN
                    "Withholding Tax Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Withholding Tax Amount", "Currency Factor"));
                    "Net Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Net Amount", "Currency Factor"));
                END ELSE BEGIN
                    "Withholding Tax Amount(LCY)" := "Withholding Tax Amount";
                    "Net Amount(LCY)" := "Net Amount";
                END;
                VALIDATE("Withholding Tax Amount(LCY)");
                VALIDATE("Net Amount(LCY)");
            end;
        }
        field(30; "Withholding Tax Amount(LCY)"; Decimal)
        {
            Caption = 'Withholding Tax Amount(LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                //Rounding
                IF FundsGeneralSetup.GET THEN BEGIN
                    IF FundsGeneralSetup."W/Tax Rounding Precision" <> 0 THEN BEGIN
                        IF FundsGeneralSetup."W/Tax Rounding Type" = FundsGeneralSetup."W/Tax Rounding Type"::Nearest THEN BEGIN
                            "Withholding Tax Amount(LCY)" := ROUND("Withholding Tax Amount(LCY)", FundsGeneralSetup."W/Tax Rounding Precision", '=');
                        END;
                        IF FundsGeneralSetup."W/Tax Rounding Type" = FundsGeneralSetup."W/Tax Rounding Type"::Up THEN BEGIN
                            "Withholding Tax Amount(LCY)" := ROUND("Withholding Tax Amount(LCY)", FundsGeneralSetup."W/Tax Rounding Precision", '>');
                        END;
                        IF FundsGeneralSetup."W/Tax Rounding Type" = FundsGeneralSetup."W/Tax Rounding Type"::Down THEN BEGIN
                            "Withholding Tax Amount(LCY)" := ROUND("Withholding Tax Amount(LCY)", FundsGeneralSetup."W/Tax Rounding Precision", '<');
                        END;
                    END;
                END;
                //End Rounding
            end;
        }
        field(31; "Withholding VAT Code"; Code[10])
        {
            Caption = 'Withholding VAT Code';
            TableRelation = "Funds Tax Code"."Tax Code" WHERE(Type = CONST("W/VAT"));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                IF "Withholding VAT Code" <> '' THEN BEGIN
                    //TESTFIELD("VAT Amount");
                    FundsTaxCodes.RESET;
                    FundsTaxCodes.SETRANGE(FundsTaxCodes."Tax Code", "Withholding VAT Code");
                    IF FundsTaxCodes.FINDFIRST THEN BEGIN
                        IF FundsTaxCodes2.GET("VAT Code") THEN BEGIN
                            "Withholding VAT Amount" := ROUND(("VAT Amount") * (FundsTaxCodes.Percentage / FundsTaxCodes2.Percentage), 0.01);
                            ;
                            VALIDATE("Withholding VAT Amount");
                        END;
                    END;
                END ELSE BEGIN
                    "Withholding VAT Amount" := 0;
                    VALIDATE("Withholding VAT Amount");
                END;
            end;
        }
        field(32; "Withholding VAT Amount"; Decimal)
        {
            Caption = 'Withholding VAT Amount';

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
                //Rounding
                IF FundsGeneralSetup.GET THEN BEGIN
                    IF FundsGeneralSetup."W/VAT Rounding Precision" <> 0 THEN BEGIN
                        IF FundsGeneralSetup."W/VAT Rounding Type" = FundsGeneralSetup."W/VAT Rounding Type"::Nearest THEN BEGIN
                            "Withholding VAT Amount" := ROUND("Withholding VAT Amount", FundsGeneralSetup."W/VAT Rounding Precision", '=');
                        END;
                        IF FundsGeneralSetup."W/VAT Rounding Type" = FundsGeneralSetup."W/VAT Rounding Type"::Up THEN BEGIN
                            "Withholding VAT Amount" := ROUND("Withholding VAT Amount", FundsGeneralSetup."W/VAT Rounding Precision", '>');
                        END;
                        IF FundsGeneralSetup."W/VAT Rounding Type" = FundsGeneralSetup."W/VAT Rounding Type"::Down THEN BEGIN
                            "Withholding VAT Amount" := ROUND("Withholding VAT Amount", FundsGeneralSetup."W/VAT Rounding Precision", '<');
                        END;
                    END;
                END;
                //End Rounding

                "Net Amount" := "Total Amount" - "Withholding Tax Amount" - "Withholding VAT Amount" - "Retention Amount";
                IF "Currency Code" <> '' THEN BEGIN
                    "Withholding VAT Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Withholding VAT Amount", "Currency Factor"));
                    "Net Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Net Amount", "Currency Factor"));
                END ELSE BEGIN
                    "Withholding VAT Amount(LCY)" := "Withholding VAT Amount";
                    "Net Amount(LCY)" := "Net Amount";
                END;
                VALIDATE("Withholding VAT Amount(LCY)");
                VALIDATE("Net Amount(LCY)");
            end;
        }
        field(33; "Withholding VAT Amount(LCY)"; Decimal)
        {
            Caption = 'Withholding VAT Amount(LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                //Rounding
                IF FundsGeneralSetup.GET THEN BEGIN
                    IF FundsGeneralSetup."W/VAT Rounding Precision" <> 0 THEN BEGIN
                        IF FundsGeneralSetup."W/VAT Rounding Type" = FundsGeneralSetup."W/VAT Rounding Type"::Nearest THEN BEGIN
                            "Withholding VAT Amount(LCY)" := ROUND("Withholding VAT Amount(LCY)", FundsGeneralSetup."W/VAT Rounding Precision", '=');
                        END;
                        IF FundsGeneralSetup."W/VAT Rounding Type" = FundsGeneralSetup."W/VAT Rounding Type"::Up THEN BEGIN
                            "Withholding VAT Amount(LCY)" := ROUND("Withholding VAT Amount(LCY)", FundsGeneralSetup."W/VAT Rounding Precision", '>');
                        END;
                        IF FundsGeneralSetup."W/VAT Rounding Type" = FundsGeneralSetup."W/VAT Rounding Type"::Down THEN BEGIN
                            "Withholding VAT Amount(LCY)" := ROUND("Withholding VAT Amount(LCY)", FundsGeneralSetup."W/VAT Rounding Precision", '<');
                        END;
                    END;
                END;
                //End Rounding
            end;
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

            trigger OnValidate()
            begin
                //Rounding
                IF FundsGeneralSetup.GET THEN BEGIN
                    IF FundsGeneralSetup."Payment Rounding Precision" <> 0 THEN BEGIN
                        IF FundsGeneralSetup."Payment Rounding Type" = FundsGeneralSetup."Payment Rounding Type"::Nearest THEN BEGIN
                            "Net Amount(LCY)" := ROUND("Net Amount(LCY)", FundsGeneralSetup."Payment Rounding Precision", '=');
                        END;
                        IF FundsGeneralSetup."Payment Rounding Type" = FundsGeneralSetup."Payment Rounding Type"::Up THEN BEGIN
                            "Net Amount(LCY)" := ROUND("Net Amount(LCY)", FundsGeneralSetup."Payment Rounding Precision", '>');
                        END;
                        IF FundsGeneralSetup."Payment Rounding Type" = FundsGeneralSetup."Payment Rounding Type"::Down THEN BEGIN
                            "Net Amount(LCY)" := ROUND("Net Amount(LCY)", FundsGeneralSetup."Payment Rounding Precision", '<');
                        END;
                    END;
                END;
                //End Rounding
            end;
        }
        field(36; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(37; "Applies-to Doc. No."; Code[60])
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
                //TestStatusOpen(TRUE);

                IF ("Account Type" <> "Account Type"::Customer) AND ("Account Type" <> Rec."Account Type"::Vendor) THEN
                    ERROR(ApplicationNotAllowed, "Account Type");

                xRec."Total Amount" := "Total Amount";
                xRec."Currency Code" := "Currency Code";
                xRec."Posting Date" := "Posting Date";

                GetAccTypeAndNo(Rec, AccType, AccNo);
                CLEAR(VendLedgEntry);

                CASE AccType OF
                    AccType::Vendor:
                        LookUpAppliesToDocVend(AccNo);
                END;
                SetPaymentLineFieldsFromApplication;
            end;

            trigger OnValidate()
            var
                AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
                AccNo: Code[20];
            begin
                //TestStatusOpen(TRUE);
                //Get the Invoice Vatable Amount
                IF "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice THEN BEGIN
                    PurchInvHeader.RESET;
                    PurchInvHeader.SETRANGE(PurchInvHeader."No.", "Applies-to Doc. No.");
                    IF PurchInvHeader.FINDFIRST THEN BEGIN
                        PurchInvHeader.CALCFIELDS(Amount, "Amount Including VAT");
                        "VAT Amount" := PurchInvHeader."Amount Including VAT" - PurchInvHeader.Amount;
                        VALIDATE("VAT Amount");
                    END;
                END;
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
        field(41; "Payee Type"; Option)
        {
            Caption = 'Payee Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Vendor,Employee,Imprest,Customer,Petty Cash Request,Salary Advance,Board Allowance';
            OptionMembers = " ",Vendor,Employee,Imprest,Customer,"Petty Cash Request","Salary Advance","Board Allowance";
        }
        field(42; "Payee No."; Code[20])
        {
            Caption = 'Payee No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Payee Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Payee Type" = CONST(Employee)) Employee
            ELSE
            IF ("Payee Type" = CONST(Imprest),
                                     "Payee Type" = CONST(Imprest)) "Imprest Header" WHERE(Posted = CONST(false),
                                                                                                 Status = CONST(Approved),
                                                                                                 Type = CONST(Imprest))
            ELSE
            IF ("Payee Type" = CONST("Petty Cash Request"),
                    "Payment Type" = FILTER(<> "Cheque Payment")) "Imprest Header" WHERE(Posted = CONST(false), Status = CONST(Approved),
                                                                                                                  Type = CONST("Petty Cash"))
            ELSE
            IF ("Payee Type" = CONST(Customer)) Customer
            ELSE
            /*  IF ("Payee Type" = CONST("Salary Advance")) "Loans/Advances".LID WHERE(Status = CONST(Approved), Created = CONST(true),
                                                                            "Paid to Employee" = CONST(false))
             ELSE */
            IF ("Payee Type" = CONST("Board Allowance"),
                            "Payee Type" = CONST(Imprest)) "Imprest Header" WHERE(Posted = CONST(false),
                            Status = CONST(Posted));
            //     Type = CONST("Board Allowances"));

            trigger OnValidate()
            var
            //     LoansAdvances: Record 51171;
            begin
                "Account No." := '';
                Description := '';
                "Total Amount" := 0;
                "Total Amount(LCY)" := 0;
                /*"Global Dimension 1 Code":='';
                "Global Dimension 2 Code":='';
                "Shortcut Dimension 3 Code":='';
                "Shortcut Dimension 4 Code":='';
                "Shortcut Dimension 5 Code":='';
                "Shortcut Dimension 6 Code":='';
                "Shortcut Dimension 7 Code":='';
                "Shortcut Dimension 8 Code":='';*/

                //Payye Type Employee
                IF "Payee Type" = "Payee Type"::Employee THEN BEGIN
                    ImprestHeader.RESET;
                    ImprestHeader.SETRANGE(ImprestHeader."No.", "Payee No.");
                    IF ImprestHeader.FINDFIRST THEN BEGIN
                        PaymentLine.RESET;
                        PaymentLine.SETRANGE(PaymentLine."Payee No.", "Payee No.");
                        IF PaymentLine.FINDFIRST THEN BEGIN
                            REPEAT
                                PaymentHeader2.GET(PaymentLine."Document No.");
                                IF PaymentHeader2.Reversed = FALSE THEN
                                    ERROR(Text005, PaymentLine."Document No.");
                            UNTIL PaymentLine.NEXT = 0;
                        END;
                        ImprestHeader.CALCFIELDS(ImprestHeader.Amount);
                        ImprestHeader.CALCFIELDS(ImprestHeader."Amount(LCY)");
                        "Account Type" := "Account Type"::Employee;
                        "Account No." := ImprestHeader."Employee No.";
                        VALIDATE("Account No.");
                        Description := COPYSTR(ImprestHeader.Description, 1, 100);
                        "Total Amount" := ImprestHeader.Amount;
                        VALIDATE("Total Amount");

                        PaymentHeader.RESET;
                        PaymentHeader.SETRANGE(PaymentHeader."No.", "Document No.");
                        IF PaymentHeader.FINDFIRST THEN BEGIN
                            PaymentHeader."Payee Name" := ImprestHeader."Employee Name";
                            PaymentHeader.Description := Description;
                            PaymentHeader.MODIFY;
                        END;
                    END;
                    //Payye Type Employee...End
                END;
                IF "Payee Type" = "Payee Type"::Imprest THEN BEGIN
                    ImprestHeader.RESET;
                    ImprestHeader.SETRANGE(ImprestHeader."No.", "Payee No.");
                    IF ImprestHeader.FINDFIRST THEN BEGIN
                        PaymentLine.RESET;
                        PaymentLine.SETRANGE(PaymentLine."Payee No.", "Payee No.");
                        IF PaymentLine.FINDFIRST THEN BEGIN
                            REPEAT
                                PaymentHeader2.GET(PaymentLine."Document No.");
                                IF PaymentHeader2.Reversed = FALSE THEN
                                    ERROR(Text005, PaymentLine."Document No.");
                            UNTIL PaymentLine.NEXT = 0;
                        END;

                        ImprestHeader.CALCFIELDS(ImprestHeader.Amount);
                        ImprestHeader.CALCFIELDS(ImprestHeader."Amount(LCY)");
                        "Account Type" := "Account Type"::Employee;
                        "Account No." := ImprestHeader."Employee No.";
                        VALIDATE("Account No.");
                        Description := COPYSTR(ImprestHeader.Description, 1, 100);
                        "Total Amount" := ImprestHeader.Amount;
                        VALIDATE("Total Amount");
                        /*"Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                        "Global Dimension 2 Code":=ImprestHeader."Global Dimension 2 Code";
                        "Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                        "Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                        "Shortcut Dimension 5 Code":=ImprestHeader."Shortcut Dimension 5 Code";
                        "Shortcut Dimension 6 Code":=ImprestHeader."Shortcut Dimension 6 Code";
                        "Shortcut Dimension 7 Code":=ImprestHeader."Shortcut Dimension 7 Code";
                        "Shortcut Dimension 8 Code":=ImprestHeader."Shortcut Dimension 8 Code";*/
                        PaymentHeader.RESET;
                        PaymentHeader.SETRANGE(PaymentHeader."No.", "Document No.");
                        IF PaymentHeader.FINDFIRST THEN BEGIN
                            PaymentHeader."Payee Name" := ImprestHeader."Employee Name";
                            /*PaymentHeader."Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                            PaymentHeader."Global Dimension 2 Code":=ImprestHeader."Global Dimension 2 Code";
                            PaymentHeader."Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                            PaymentHeader."Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                            PaymentHeader."Shortcut Dimension 5 Code":=ImprestHeader."Shortcut Dimension 5 Code";
                            PaymentHeader."Shortcut Dimension 6 Code":=ImprestHeader."Shortcut Dimension 6 Code";
                            PaymentHeader."Shortcut Dimension 7 Code":=ImprestHeader."Shortcut Dimension 7 Code";
                            PaymentHeader."Shortcut Dimension 8 Code":=ImprestHeader."Shortcut Dimension 8 Code";*/
                            PaymentHeader.Description := Description;
                            PaymentHeader.MODIFY;
                        END;
                    END;
                END;
                //Payye Type Employee...End
                //END;
                IF "Payee Type" = "Payee Type"::"Board Allowance" THEN BEGIN
                    ImprestHeader.RESET;
                    ImprestHeader.SETRANGE(ImprestHeader."No.", "Payee No.");
                    IF ImprestHeader.FINDFIRST THEN BEGIN
                        PaymentLine.RESET;
                        PaymentLine.SETRANGE(PaymentLine."Payee No.", "Payee No.");
                        IF PaymentLine.FINDFIRST THEN
                            ERROR(Text005, PaymentLine."Document No.");

                        ImprestHeader.CALCFIELDS(ImprestHeader.Amount);
                        ImprestHeader.CALCFIELDS(ImprestHeader."Amount(LCY)");
                        "Account Type" := "Account Type"::Employee;
                        "Account No." := ImprestHeader."Employee No.";
                        VALIDATE("Account No.");
                        Description := COPYSTR(ImprestHeader.Description, 1, 100);
                        "Total Amount" := ImprestHeader.Amount;
                        VALIDATE("Total Amount");
                        /*"Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                        "Global Dimension 2 Code":=ImprestHeader."Global Dimension 2 Code";
                        "Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                        "Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                        "Shortcut Dimension 5 Code":=ImprestHeader."Shortcut Dimension 5 Code";
                        "Shortcut Dimension 6 Code":=ImprestHeader."Shortcut Dimension 6 Code";
                        "Shortcut Dimension 7 Code":=ImprestHeader."Shortcut Dimension 7 Code";
                        "Shortcut Dimension 8 Code":=ImprestHeader."Shortcut Dimension 8 Code";*/
                        PaymentHeader.RESET;
                        PaymentHeader.SETRANGE(PaymentHeader."No.", "Document No.");
                        IF PaymentHeader.FINDFIRST THEN BEGIN
                            PaymentHeader."Payee Name" := ImprestHeader."Employee Name";
                            /*PaymentHeader."Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                            PaymentHeader."Global Dimension 2 Code":=ImprestHeader."Global Dimension 2 Code";
                            PaymentHeader."Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                            PaymentHeader."Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                            PaymentHeader."Shortcut Dimension 5 Code":=ImprestHeader."Shortcut Dimension 5 Code";
                            PaymentHeader."Shortcut Dimension 6 Code":=ImprestHeader."Shortcut Dimension 6 Code";
                            PaymentHeader."Shortcut Dimension 7 Code":=ImprestHeader."Shortcut Dimension 7 Code";
                            PaymentHeader."Shortcut Dimension 8 Code":=ImprestHeader."Shortcut Dimension 8 Code";*/
                            PaymentHeader.Description := Description;
                            PaymentHeader.MODIFY;
                        END;
                    END;
                END;
                /*IF "Payee Type"="Payee Type"::"Salary Advance" THEN BEGIN
                  LoansAdvances.RESET;
                  LoansAdvances.SETFILTER(ID,'=%1',"Payee No.");
                  IF LoansAdvances.FINDFIRST THEN BEGIN
                    PaymentLine.RESET;
                    PaymentLine.SETRANGE(PaymentLine."Payee No.","Payee No.");
                    IF PaymentLine.FINDFIRST THEN
                      ERROR(Text005,PaymentLine."Document No.");
                
                
                    "Account Type":="Account Type"::Employee;
                    "Account No.":=LoansAdvances."Employee No.";
                    VALIDATE("Account No.");
                    Description:=COPYSTR(ImprestHeader.Description,1,100);
                    "Total Amount":=ImprestHeader.Amount;
                    VALIDATE("Total Amount");
                    "Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                    "Global Dimension 2 Code":=ImprestHeader."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code":=ImprestHeader."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code":=ImprestHeader."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code":=ImprestHeader."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code":=ImprestHeader."Shortcut Dimension 8 Code";
                    PaymentHeader.RESET;
                    PaymentHeader.SETRANGE(PaymentHeader."No.","Document No.");
                    IF PaymentHeader.FINDFIRST THEN BEGIN
                      PaymentHeader."Payee Name":=ImprestHeader."Employee Name";
                      PaymentHeader."Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                      PaymentHeader."Global Dimension 2 Code":=ImprestHeader."Global Dimension 2 Code";
                      PaymentHeader."Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                      PaymentHeader."Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                      PaymentHeader."Shortcut Dimension 5 Code":=ImprestHeader."Shortcut Dimension 5 Code";
                      PaymentHeader."Shortcut Dimension 6 Code":=ImprestHeader."Shortcut Dimension 6 Code";
                      PaymentHeader."Shortcut Dimension 7 Code":=ImprestHeader."Shortcut Dimension 7 Code";
                      PaymentHeader."Shortcut Dimension 8 Code":=ImprestHeader."Shortcut Dimension 8 Code";
                      PaymentHeader.MODIFY;
                    END;
                  END;
                END;
                */
                IF "Payee Type" = "Payee Type"::"Petty Cash Request" THEN BEGIN
                    ImprestHeader.RESET;
                    ImprestHeader.SETRANGE(ImprestHeader."No.", "Payee No.");
                    IF ImprestHeader.FINDFIRST THEN BEGIN

                        PaymentLine.RESET;
                        PaymentLine.SETRANGE(PaymentLine."Payee No.", "Payee No.");
                        IF PaymentLine.FINDFIRST THEN BEGIN
                            REPEAT
                                PaymentHeader2.GET(PaymentLine."Document No.");
                                IF PaymentHeader2.Reversed = FALSE THEN
                                    ERROR(Text005, PaymentLine."Document No.");
                            UNTIL PaymentLine.NEXT = 0;
                        END;


                        ImprestHeader.CALCFIELDS(ImprestHeader.Amount);
                        ImprestHeader.CALCFIELDS(ImprestHeader."Amount(LCY)");
                        "Account Type" := "Account Type"::Employee;
                        "Account No." := ImprestHeader."Employee No.";
                        VALIDATE("Account No.");
                        Description := COPYSTR(ImprestHeader.Description, 1, 100);
                        "Total Amount" := ImprestHeader.Amount;
                        VALIDATE("Total Amount");
                        /*"Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                        "Global Dimension 2 Code":=ImprestHeader."Global Dimension 2 Code";
                        "Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                        "Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                        "Shortcut Dimension 5 Code":=ImprestHeader."Shortcut Dimension 5 Code";
                        "Shortcut Dimension 6 Code":=ImprestHeader."Shortcut Dimension 6 Code";
                        "Shortcut Dimension 7 Code":=ImprestHeader."Shortcut Dimension 7 Code";
                        "Shortcut Dimension 8 Code":=ImprestHeader."Shortcut Dimension 8 Code";*/
                        PaymentHeader.RESET;
                        PaymentHeader.SETRANGE(PaymentHeader."No.", "Document No.");
                        IF PaymentHeader.FINDFIRST THEN BEGIN
                            PaymentHeader."Payee Name" := ImprestHeader."Employee Name";
                            /*PaymentHeader."Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
                            PaymentHeader."Global Dimension 2 Code":=ImprestHeader."Global Dimension 2 Code";
                            PaymentHeader."Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
                            PaymentHeader."Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
                            PaymentHeader."Shortcut Dimension 5 Code":=ImprestHeader."Shortcut Dimension 5 Code";
                            PaymentHeader."Shortcut Dimension 6 Code":=ImprestHeader."Shortcut Dimension 6 Code";
                            PaymentHeader."Shortcut Dimension 7 Code":=ImprestHeader."Shortcut Dimension 7 Code";
                            PaymentHeader."Shortcut Dimension 8 Code":=ImprestHeader."Shortcut Dimension 8 Code";*/
                            PaymentHeader.Description := Description;
                            PaymentHeader.MODIFY;
                        END;
                    END;
                END;


                IF "Payee Type" = "Payee Type"::Customer THEN BEGIN
                    "Account Type" := "Account Type"::Customer;
                    "Account No." := "Payee No.";
                    VALIDATE("Account No.");
                END;

                IF "Payee Type" = "Payee Type"::Vendor THEN BEGIN
                    "Account Type" := "Account Type"::Vendor;
                    "Account No." := "Payee No.";
                    VALIDATE("Account No.");
                END;

                IF "Payee Type" = "Payee Type"::Employee THEN BEGIN
                    "Account Type" := "Account Type"::Employee;
                    "Account No." := "Payee No.";
                    VALIDATE("Account No.");
                END;

            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
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
                TestStatusOpen(TRUE);
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
                TestStatusOpen(TRUE);
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
                TestStatusOpen(TRUE);
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
                TestStatusOpen(TRUE);
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
                TestStatusOpen(TRUE);
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
                TestStatusOpen(TRUE);
            end;
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;
        }
        field(60; "Payee Bank Code"; Code[20])
        {
        }
        field(61; "Payee Bank Name"; Text[250])
        {
        }
        field(62; "Payee Bank Branch Code"; Code[20])
        {
        }
        field(63; "Payee Bank Branch Name"; Text[250])
        {
        }
        field(64; "Payee Bank Account No."; Code[20])
        {
        }
        field(65; "Mobile Payment Account No."; Code[40])
        {
            Editable = false;
        }
        field(66; "Payment Type"; Option)
        {
            CalcFormula = Lookup("Payment Header"."Payment Type" WHERE("No." = FIELD("Document No.")));
            Caption = '"Payment Type"';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = '"Cheque Payment",Cash Payment,EFT,RTGS,MPESA';
            OptionMembers = "Cheque Payment","Cash Payment",EFT,RTGS,MPESA;
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
        field(50000; "Catering Levy Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Total Amount" := "Total Amount" - "Catering Levy Amount";
                "Total Amount(LCY)" := "Total Amount(LCY)" - "Catering Levy Amount";
            end;
        }
        field(50001; "Retention Code"; Code[10])
        {
            Caption = 'Retention Code';
            DataClassification = ToBeClassified;
            TableRelation = "Funds Tax Code"."Tax Code" WHERE(Type = CONST(Retention));

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
                "Retention Amount" := 0;
                VALIDATE("Retention Amount");

                IF "Retention Code" <> '' THEN BEGIN
                    FundsTaxCodes.RESET;
                    FundsTaxCodes.SETRANGE(FundsTaxCodes."Tax Code", "Retention Code");
                    IF FundsTaxCodes.FINDFIRST THEN BEGIN
                        "Retention Amount" := ("Total Amount") * (FundsTaxCodes.Percentage / 100);
                        VALIDATE("Retention Amount");
                    END;
                END;
            end;
        }
        field(50002; "Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
                //Rounding
                IF FundsGeneralSetup.GET THEN BEGIN
                    IF FundsGeneralSetup."W/Tax Rounding Precision" <> 0 THEN BEGIN
                        IF FundsGeneralSetup."W/Tax Rounding Type" = FundsGeneralSetup."W/Tax Rounding Type"::Nearest THEN BEGIN
                            "Retention Amount" := ROUND("Retention Amount", FundsGeneralSetup."W/Tax Rounding Precision", '=');
                        END;
                        IF FundsGeneralSetup."W/Tax Rounding Type" = FundsGeneralSetup."W/Tax Rounding Type"::Up THEN BEGIN
                            "Retention Amount" := ROUND("Retention Amount", FundsGeneralSetup."W/Tax Rounding Precision", '>');
                        END;
                        IF FundsGeneralSetup."W/Tax Rounding Type" = FundsGeneralSetup."W/Tax Rounding Type"::Down THEN BEGIN
                            "Retention Amount" := ROUND("Retention Amount", FundsGeneralSetup."W/Tax Rounding Precision", '<');
                        END;
                    END;
                END;
                "Retention Amount" := ROUND("Retention Amount", 1, '=');
                //End Rounding
                "Net Amount" := "Total Amount" - "Withholding Tax Amount" - "Withholding VAT Amount" - "Catering Levy Amount" - "Retention Amount";
                IF "Currency Code" <> '' THEN BEGIN
                    "Withholding Tax Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Withholding Tax Amount", "Currency Factor"));
                    "Net Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Net Amount", "Currency Factor"));
                END ELSE BEGIN
                    //"Withholding Tax Amount(LCY)":="Withholding Tax Amount";
                    "Net Amount(LCY)" := "Net Amount";
                END;
                //VALIDATE("Retention Amount");
                VALIDATE("Net Amount(LCY)");
            end;
        }
        field(52136965; "Job No."; Code[50])
        {
            Description = 'Jobs Management Integration';
        }
        field(52137023; "Employee Transaction Type"; Option)
        {
            Caption = 'Employee Transaction Type';
            OptionCaption = ' ,NetPay,Imprest';
            OptionMembers = " ",NetPay,Imprest;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.", "Payment Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*PaymentHeader.RESET;
        PaymentHeader.SETRANGE(PaymentHeader."No.","Document No.");
        IF PaymentHeader.FINDFIRST THEN BEGIN
         //PaymentHeader.TESTFIELD(PaymentHeader.Status,PaymentHeader.Status::Open);
          {IF PaymentHeader.Status=PaymentHeader.Status::Released THEN
            ERROR(Text001);}
        END;*/
        //TestStatusOpen(TRUE);
        //TESTFIELD(Status,Status::Open);

    end;

    trigger OnInsert()
    begin
        PaymentHeader.RESET;
        PaymentHeader.SETRANGE(PaymentHeader."No.", "Document No.");
        IF PaymentHeader.FINDFIRST THEN BEGIN
            //PaymentHeader.TESTFIELD(Description);
            PaymentHeader.TESTFIELD("Posting Date");
            "Document Type" := "Document Type"::Payment;
            "Posting Date" := PaymentHeader."Posting Date";
            // "Currency Code":=PaymentHeader."Currency Code";
            // "Currency Factor":=PaymentHeader."Currency Factor";
            Description := PaymentHeader.Description;
            /*"Global Dimension 1 Code":=PaymentHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code":=PaymentHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code":=PaymentHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code":=PaymentHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code":=PaymentHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code":=PaymentHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code":=PaymentHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code":=PaymentHeader."Shortcut Dimension 8 Code";*/
        END;

    end;

    trigger OnModify()
    begin
        //TestStatusOpen(TRUE);
        //TESTFIELD(Status,Status::Open);
    end;

    trigger OnRename()
    begin
        //TestStatusOpen(TRUE);
        //TESTFIELD(Status,Status::Open);
    end;

    var
        FundsGeneralSetup: Record 50031;
        FundsTransactionCodes: Record 50027;
        FundsTaxCodes: Record 50028;
        "G/LAccount": Record 15;
        BankAccount: Record 270;
        Customer: Record 18;
        Vendor: Record 23;
        FixedAsset: Record 5600;
        ICPartner: Record 413;
        Employee: Record 5200;
        PaymentHeader: Record 50002;
        PaymentLine: Record 50003;
        PurchInvHeader: Record 122;
        CurrExchRate: Record 330;
        DocumentNotOpen: Label 'You can only modify Open Documents, Current Status is:%1';
        ApplicationNotAllowed: Label 'You cannot apply to %1';
        VendLedgEntry: Record 25;
        PaymentToleranceMgt: Codeunit 426;
        FromCurrencyCode: Code[10];
        ToCurrencyCode: Code[10];
        "Exported to Payment File": Boolean;
        "Applies-to Ext. Doc. No.": Code[35];
        Text001: Label 'You Cannot Delete line when status is Released';
        FundsTaxCodes2: Record 50028;
        ImprestHeader: Record 50008;
        Text005: Label 'The Imprest has already been assigned to Payment Voucher no. %1';
        Text006: Label 'The petty cash request has already been assigned to Payment Voucher no. %1';
        PaymentHeader2: Record 50002;

    procedure LookUpAppliesToDocVend(AccNo: Code[20])
    var
        ApplyVendEntries: Page 233;
    begin
        CLEAR(VendLedgEntry);
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        IF AccNo <> '' THEN
            VendLedgEntry.SETRANGE("Vendor No.", AccNo);
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
        IF "Total Amount" <> 0 THEN BEGIN
            VendLedgEntry.SETRANGE(Positive, "Total Amount" < 0);
            IF VendLedgEntry.ISEMPTY THEN;
            VendLedgEntry.SETRANGE(Positive);
        END;
        ApplyVendEntries.SetPaymentLine(Rec, PaymentLine.FIELDNO("Applies-to Doc. No."));
        ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
        ApplyVendEntries.SETRECORD(VendLedgEntry);
        ApplyVendEntries.LOOKUPMODE(TRUE);
        IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ApplyVendEntries.GETRECORD(VendLedgEntry);
            IF AccNo = '' THEN BEGIN
                AccNo := VendLedgEntry."Vendor No.";
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
        IF "Account Type" = "Account Type"::Vendor THEN BEGIN
            VendLedgEntry.SETCURRENTKEY("Document No.");
            VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
            VendLedgEntry.SETRANGE("Vendor No.", "Account No.");
            VendLedgEntry.SETRANGE(Open, TRUE);
            IF VendLedgEntry.FIND('-') THEN
                IF VendLedgEntry."Amount to Apply" = 0 THEN BEGIN
                    VendLedgEntry.CALCFIELDS("Remaining Amount");
                    VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                    CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                END;
        END;
    end;

    local procedure GetAccTypeAndNo(PaymentLine2: Record 50003; var AccType: Option; var AccNo: Code[20])
    begin
        AccType := PaymentLine2."Account Type";
        AccNo := PaymentLine2."Account No.";
    end;

    local procedure SetAmountWithVendLedgEntry()
    begin
        IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
            CheckModifyCurrencyCode("Account Type"::Vendor, VendLedgEntry."Currency Code");
        IF "Total Amount" = 0 THEN BEGIN
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
                "Total Amount" := -(RemainingAmount - RemainingPmtDiscPossible)
            ELSE
                "Total Amount" := -AmountToApply
        ELSE
            IF CalcPmtDisc THEN
                "Total Amount" := -(RemainingAmount - RemainingPmtDiscPossible)
            ELSE
                "Total Amount" := -RemainingAmount;
        VALIDATE("Total Amount");
    end;

    local procedure SetPaymentLineFieldsFromApplication()
    var
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo: Code[20];
    begin
        "Exported to Payment File" := FALSE;
        GetAccTypeAndNo(Rec, AccType, AccNo);
        CASE AccType OF
            AccType::Vendor:
                IF "Applies-to ID" <> '' THEN BEGIN
                    IF FindFirstVendLedgEntryWithAppliesToID(AccNo, "Applies-to ID") THEN BEGIN
                        VendLedgEntry.SETRANGE("Exported to Payment File", TRUE);
                        "Exported to Payment File" := VendLedgEntry.FINDFIRST;
                    END
                END ELSE
                    IF "Applies-to Doc. No." <> '' THEN
                        IF FindFirstVendLedgEntryWithAppliesToDocNo(AccNo, "Applies-to Doc. No.") THEN BEGIN
                            "Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                            //  "Applies-to Ext. Doc. No." := VendLedgEntry."External  Document No.";
                        END;
        END;
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToID(AccNo: Code[20]; AppliesToID: Code[50]): Boolean
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open);
        VendLedgEntry.SETRANGE("Vendor No.", AccNo);
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
        VendLedgEntry.SETRANGE("Vendor No.", AccNo);
        VendLedgEntry.SETRANGE(Open, TRUE);
        EXIT(VendLedgEntry.FINDFIRST)
    end;

    local procedure TestStatusOpen(AllowApproverEdit: Boolean)
    var
        PaymentHeader: Record 50002;
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


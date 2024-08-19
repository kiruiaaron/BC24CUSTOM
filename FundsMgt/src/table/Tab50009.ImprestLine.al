table 50009 "Imprest Line"
{
    Caption = 'Imprest Line';

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
            TableRelation = "Imprest Header"."No.";
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
                    "Account Name" := FundsTransactionCodes.Description;

                END;

                VALIDATE("Account No.");
                VALIDATE(City);
            end;
        }
        field(5; "Imprest Code Description"; Text[100])
        {
            Caption = 'Imprest Code Description';
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
                TestStatusOpen(TRUE);
            end;
        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE("Direct Posting" = CONST(true))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee."No.";

            trigger OnValidate()
            begin
                //TestStatusOpen(TRUE);

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
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group".Code
            ELSE
            IF ("Account Type" = CONST(Employee)) "Employee Posting Group".Code;

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

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                VALIDATE("Gross Amount");
            end;
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
            Editable = false;

            trigger OnValidate()
            var
                FundsTaxCode: Record 50028;
            begin
                /*IF "Unit Amount"=0 THEN
                  ERROR('Unit Amount must have a value!!!!');*/
                TestStatusOpen(TRUE);

                "Tax Amount" := 0;
                "Net Amount" := 0;
                FundsTransactionCodes.RESET;
                FundsTransactionCodes.SETRANGE(FundsTransactionCodes."Transaction Code", "Imprest Code");
                IF FundsTransactionCodes.FINDFIRST THEN BEGIN
                    IF "Gross Amount" > FundsTransactionCodes."Minimum Non Taxable Amount" THEN
                        IF FundsTransactionCodes."Include Withholding Tax" THEN BEGIN
                            FundsTransactionCodes.TESTFIELD("Withholding Tax Code");
                            FundsTaxCode.GET(FundsTransactionCodes."Withholding Tax Code");
                            "Tax Amount" := ROUND((FundsTaxCode.Percentage * "Gross Amount") / 100, 1, '>');


                        END

                END;
                "Net Amount" := "Gross Amount" - "Tax Amount";
                IF "Currency Code" <> '' THEN BEGIN
                    "Gross Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Gross Amount", "Currency Factor"));
                END ELSE BEGIN
                    "Gross Amount(LCY)" := "Gross Amount";
                END;

            end;
        }
        field(24; "Gross Amount(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(25; Quantity; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Description);
                "Gross Amount" := "Unit Amount" * Quantity;
                VALIDATE("Gross Amount");
            end;
        }
        field(26; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(27; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(28; "Unit Amount"; Decimal)
        {
            Caption = 'Unit Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);

                "Gross Amount" := "Unit Amount" * Quantity;
                VALIDATE("Gross Amount");
            end;
        }
        field(39; "Budget Committed"; Boolean)
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

            trigger OnValidate()
            begin
                TestStatusOpen(TRUE);
            end;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
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
        }
        field(100; "Activity Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Imprest Code" := '';
                "Imprest Code Description" := '';
                //Amount:=0;
                "Gross Amount(LCY)" := 0;
                "From City" := '';
                "To City" := '';
                City := '';
                "Account No." := '';
                "Account Name" := '';
            end;
        }
        field(101; "From City"; Code[50])
        {
            DataClassification = ToBeClassified;
            //  TableRelation = "Procurement Lookup Values".Code WHERE("Type" = CONST(City));
        }
        field(102; "To City"; Code[50])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Procurement Lookup Values".Code WHERE("Type" = CONST(City));

            trigger OnValidate()
            begin
                City := '';
                TESTFIELD("From City");
                IF "To City" = "From City" THEN BEGIN
                    ERROR(Error001);
                END;

                AlowanceMatrix.RESET;
                AlowanceMatrix.SETRANGE(AlowanceMatrix."Allowance Code", "Imprest Code");
                AlowanceMatrix.SETRANGE(AlowanceMatrix.From, "From City");
                AlowanceMatrix.SETRANGE(AlowanceMatrix.Tos, "To City");
                IF AlowanceMatrix.FINDFIRST THEN BEGIN
                    "Gross Amount" := AlowanceMatrix.Amount;
                    "Gross Amount(LCY)" := "Gross Amount";
                END;
            end;
        }
        field(103; "HR Job Grade"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(104; City; Code[30])
        {
            DataClassification = ToBeClassified;
            //  TableRelation = "Procurement Lookup Values".Code WHERE("Type" = CONST(City));

            trigger OnValidate()
            begin
                "From City" := '';
                "To City" := '';
                VALIDATE("Gross Amount", 0);
                /* CityCodes.RESET;
                CityCodes.SETRANGE(CityCodes.Code, Rec.City);
                IF CityCodes.FINDFIRST THEN BEGIN
                    AlowanceMatrix.RESET;
                    AlowanceMatrix.SETRANGE(AlowanceMatrix."Job Group", "HR Job Grade");
                    AlowanceMatrix.SETRANGE(AlowanceMatrix."Allowance Code", "Imprest Code");
                    AlowanceMatrix.SETRANGE(AlowanceMatrix.Tos, CityCodes.Code);
                    IF AlowanceMatrix.FINDFIRST THEN BEGIN
                        "Unit Amount" := AlowanceMatrix.Amount;
                        "Gross Amount" := "Unit Amount" * Quantity;
                        VALIDATE("Gross Amount");
                    END;
                END; */
            end;
        }
        field(105; "Imprest Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Normal,DSA';
            OptionMembers = Normal,DSA;
        }
        field(106; "Employee No"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(107; "Overtime Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Daytype: Option "Normal Day","Off Day",Holiday;
            begin
                ImprestHeader.RESET;
                ImprestHeader.SETRANGE(ImprestHeader."No.", "Document No.");
                IF ImprestHeader.FINDFIRST THEN;
                ImprestHeader.TESTFIELD("Employee No.");
                Employee.GET(ImprestHeader."Employee No.");
                PayrollSetup.GET(Employee."Payroll Code");
                PayrollSetup.TESTFIELD("Weekend OT Rate");
                PayrollSetup.TESTFIELD("Normal OT Rate");
                PayrollSetup.TESTFIELD("Holiday OT Rate");
                PayrollSetup.TESTFIELD("Standard Hours");
                "Basic Pay" := Employee."Fixed Pay";
                "Hourly rate" := ROUND("Basic Pay" / PayrollSetup."Standard Hours", 1);
                Daytype := GetDayType("Overtime Date");
                IF Daytype = Daytype::Holiday THEN
                    "Overtime Rate" := PayrollSetup."Holiday OT Rate"
                ELSE
                    IF Daytype = Daytype::"Off Day" THEN
                        "Overtime Rate" := PayrollSetup."Weekend OT Rate"
                    ELSE
                        "Overtime Rate" := PayrollSetup."Normal OT Rate";
                "Unit Amount" := "Overtime Rate" * "Hourly rate";
            end;
        }
        field(108; "Overtime Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(109; "Basic Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(110; "Hourly rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(1107; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(1108; "Bank Branch"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(1109; "Bank A/C No."; Text[50])
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
        /*TestStatusOpen(TRUE);
        TESTFIELD(Status,Status::Open);
        */

    end;

    trigger OnInsert()
    begin
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.", "Document No.");
        IF ImprestHeader.FINDFIRST THEN BEGIN
            IF ImprestHeader.Type <> ImprestHeader.Type::Overtime THEN BEGIN
                ImprestHeader.TESTFIELD("Date From");
                ImprestHeader.TESTFIELD("Date To");
                ImprestHeader.TESTFIELD(Type);
                Quantity := ImprestHeader."Date To" - ImprestHeader."Date From" + 1;
                IF Quantity = 0 THEN
                    Quantity := 1;
            END;
            Description := ImprestHeader.Description;
            "Document Type" := "Document Type"::Imprest;
            "Posting Date" := ImprestHeader."Posting Date";
            /*"Currency Code":=ImprestHeader."Currency Code";
            "Currency Factor":=ImprestHeader."Currency Factor";
            "Global Dimension 1 Code":=ImprestHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code":=ImprestHeader."Global Dimension 2 Code";
            "Shortcut Dimension 3 Code":=ImprestHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code":=ImprestHeader."Shortcut Dimension 4 Code";
            "Shortcut Dimension 5 Code":=ImprestHeader."Shortcut Dimension 5 Code";
            "Shortcut Dimension 6 Code":=ImprestHeader."Shortcut Dimension 6 Code";
            "Shortcut Dimension 7 Code":=ImprestHeader."Shortcut Dimension 7 Code";
            "Shortcut Dimension 8 Code":=ImprestHeader."Shortcut Dimension 8 Code";
            */
            "HR Job Grade" := ImprestHeader."HR Job Grade";
            "Employee No" := ImprestHeader."Employee No.";


        END;

    end;

    trigger OnModify()
    begin
        //TestStatusOpen(TRUE);
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
        ImprestHeader: Record 50008;
        ImprestLine: Record 50009;
        CurrExchRate: Record 330;
        DepreciationBook: Record 5612;
        AlowanceMatrix: Record 50032;
        //  CityCodes: Record 50062;
        Error001: Label 'From City must be Inserted';
        Error002: Label 'Imprest code exists for this date. Cannot be twice on the same day';
        PayrollSetup: Record 51165;

    local procedure TestStatusOpen(AllowApproverEdit: Boolean)
    var
        ApprovalEntry: Record 454;
    begin
        ImprestHeader.GET("Document No.");
        IF AllowApproverEdit THEN BEGIN
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", ImprestHeader."No.");
            ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
            ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", USERID);
            IF NOT ApprovalEntry.FINDFIRST THEN BEGIN
                ImprestHeader.TESTFIELD(Status, ImprestHeader.Status::Open);
            END;
        END ELSE BEGIN
            ImprestHeader.TESTFIELD(Status, ImprestHeader.Status::Open);
        END;
    end;

    local procedure GetDayType(DayDate: Date): Integer
    var
        Holidays: Record 7601;
        Daytype: Option "Normal Day","Off Day",Holiday;
    begin
        Holidays.RESET;
        Holidays.SETRANGE(Date, DayDate);
        Holidays.SETRANGE(Nonworking, TRUE);
        IF Holidays.FINDFIRST THEN
            EXIT(Daytype::Holiday)
        ELSE BEGIN

            IF (GetDayName(DayDate) = 7) THEN
                EXIT(Daytype::"Off Day")
            ELSE
                EXIT(Daytype::"Normal Day")
        END
    end;

    procedure GetDayName(Date: Date): Integer
    var
        DateTable: Record 2000000007;
    begin
        DateTable.SETRANGE("Period Type", DateTable."Period Type"::Date);
        DateTable.SETRANGE("Period Start", Date);
        IF DateTable.FINDFIRST THEN
            EXIT(DateTable."Period No.");
    end;
}


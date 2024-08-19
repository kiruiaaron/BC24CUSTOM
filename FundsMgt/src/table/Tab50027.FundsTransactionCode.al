table 50027 "Funds Transaction Code"
{
    Caption = 'Funds Transaction Code';

    fields
    {
        field(1; "Transaction Code"; Code[50])
        {
            Caption = 'Transaction Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Payment,Receipt,Imprest,Refund';
            OptionMembers = Payment,Receipt,Imprest,Refund;
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;

            trigger OnValidate()
            begin
                "Account No." := '';
                "Account Name" := '';
            end;
        }
        field(5; "Account No."; Code[20])
        {
            Caption = 'Account No.';
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
                    IF "G/L Account".GET("Account No.") THEN BEGIN
                        "Account Name" := "G/L Account".Name;
                    END;
                END;

                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    IF Customer.GET("Account No.") THEN BEGIN
                        "Account Name" := Customer.Name;
                    END;
                END;

                IF "Account Type" = "Account Type"::"Fixed Asset" THEN BEGIN
                    IF FA.GET("Account No.") THEN BEGIN
                        "Account Name" := FA.Description;
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
        field(6; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
            Editable = true;
        }
        field(7; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group".Code
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group".Code
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account Posting Group".Code
            ELSE
            IF ("Account Type" = CONST(Employee)) "Employee Posting Group".Code;
        }
        field(8; "Include VAT"; Boolean)
        {
            Caption = 'Include VAT';
        }
        field(9; "VAT Code"; Code[10])
        {
            Caption = 'VAT Code';
            TableRelation = "Funds Tax Code"."Tax Code" WHERE(Type = CONST(VAT));
        }
        field(10; "Include Withholding Tax"; Boolean)
        {
            Caption = 'Include Withholding Tax';
        }
        field(11; "Withholding Tax Code"; Code[10])
        {
            Caption = 'Withholding Tax Code';
            TableRelation = "Funds Tax Code"."Tax Code" WHERE(Type = CONST("W/TAX"));
        }
        field(12; "Include Withholding VAT"; Boolean)
        {
            Caption = 'Include Withholding VAT';
        }
        field(13; "Withholding VAT Code"; Code[10])
        {
            Caption = 'Withholding VAT Code';
            TableRelation = "Funds Tax Code"."Tax Code" WHERE(Type = CONST("W/VAT"));
        }
        field(20; "Funds Claim Code"; Boolean)
        {
        }
        field(52137023; "Employee Transaction Type"; Option)
        {
            Caption = 'Employee Transaction Type';
            OptionCaption = ' ,Salary,Imprest,Advance';
            OptionMembers = " ",Salary,Imprest,Advance;

            trigger OnValidate()
            begin
                TESTFIELD("Account Type", "Account Type"::Employee);
            end;
        }
        field(52137123; "Payroll Taxable"; Boolean)
        {
            Caption = 'Payroll Taxable';
        }
        field(52137124; "Payroll Allowance Code"; Code[50])
        {
            Caption = 'Payroll Allowance Code';
        }
        field(52137125; "Payroll Deduction Code"; Code[50])
        {
            Caption = 'Payroll Deduction Code';
        }
        field(52137130; "Loan Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Staff Loan,Investment Loan';
            OptionMembers = " ","Staff Loan","Investment Loan";
        }
        field(52137131; "Minimum Non Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52137132; "Imprest Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Imprest,Lunch&Subsistence,Overtime,Allowance';
            OptionMembers = Imprest,"Lunch&Subsistence",Overtime,Allowance;
        }
    }

    keys
    {
        key(Key1; "Transaction Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        "G/L Account": Record 15;
        Customer: Record 18;
        Vendor: Record 23;
        Employee: Record 5200;
        FA: Record 5600;
}


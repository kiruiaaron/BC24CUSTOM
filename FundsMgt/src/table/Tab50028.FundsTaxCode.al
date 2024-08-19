table 50028 "Funds Tax Code"
{
    Caption = 'Funds Tax Code';

    fields
    {
        field(1; "Tax Code"; Code[10])
        {
            Caption = 'Tax Code';
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,VAT,W/TAX,W/VAT,Retention';
            OptionMembers = " ",VAT,"W/TAX","W/VAT",Retention;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(5; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee;

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
        field(6; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
            Editable = false;
        }
        field(7; Percentage; Decimal)
        {
            Caption = 'Percentage';
            MaxValue = 100;
            MinValue = 0;
        }
        field(8; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group".Code
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group".Code
            ELSE
            IF ("Account Type" = CONST(Employee)) "Employee Posting Group".Code;
        }
    }

    keys
    {
        key(Key1; "Tax Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        "G/LAccount": Record 15;
        Customer: Record 18;
        Vendor: Record 23;
        Employee: Record 5200;
}


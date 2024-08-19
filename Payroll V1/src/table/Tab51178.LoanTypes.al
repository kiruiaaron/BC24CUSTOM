/// <summary>
/// Table Loan Types (ID 51178).
/// </summary>
table 51178 "Loan Types"
{
    LookupPageID = 51174;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Loan Account"; Code[20])
        {
            TableRelation = IF ("Loan Accounts Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Loan Accounts Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Loan Accounts Type" = CONST(Customer)) Customer;
        }
        field(4; "Loan Interest Account"; Code[20])
        {

            TableRelation = IF ("Loan Interest Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Loan Interest Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Loan Interest Account Type" = CONST(Customer)) Customer;
        }
        field(5; "Loan Losses Account"; Code[20])
        {
            TableRelation = IF ("Loan Accounts Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Loan Accounts Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Loan Accounts Type" = CONST(Customer)) Customer;
        }
        field(6; "Loan E/D Code"; Code[20])
        {
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Deduction));
        }
        field(8; "Loan Account Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("Loan Account")));

        }
        field(9; "Losses Account Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("Loan Losses Account")));

        }
        field(10; "Loan E/D Name"; Text[50])
        {
            CalcFormula = Lookup("ED Definitions".Description WHERE("ED Code" = FIELD("Loan E/D Code")));
            FieldClass = FlowField;
        }
        field(12; Rounding; Option)
        {
            OptionMembers = Nearest,Down,Up;
        }
        field(13; "Rounding Precision"; Decimal)
        {
            InitValue = 1;
            MaxValue = 1;
            MinValue = 0.1;
        }
        field(14; Type; Option)
        {
            OptionMembers = Annuity,Serial,Advance;
        }
        field(15; "Calculate Interest Benefit"; Boolean)
        {
            InitValue = false;
        }
        field(16; "Loan Accounts Type"; Option)
        {
            Description = 'IGS 06/03/00 Allow GL, Customer, Vendor accounts';
            OptionMembers = "G/L Account",Customer,Vendor;

            trigger OnValidate()
            begin
                IF "Loan Accounts Type" <> xRec."Loan Accounts Type" THEN BEGIN
                    "Loan Account" := '';
                    "Loan Interest Account" := '';
                    "Loan Losses Account" := '';
                    MODIFY
                END;
            end;
        }
        field(17; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                //ERROR('Manual Edits not allowed.');
            end;
        }
        field(18; "Finance Source"; Option)
        {
            OptionMembers = Company,External;
        }
        field(19; "Loan Interest Account Type"; Option)
        {
            Description = 'IGS 06/03/00 Allow GL, Customer, Vendor accounts';
            OptionMembers = "G/L Account",Customer,Vendor;

            trigger OnValidate()
            begin
                IF "Loan Interest Account Type" <> xRec."Loan Interest Account Type" THEN BEGIN
                    "Loan Interest Account" := '';
                    MODIFY
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Payroll Code" = '' THEN "Payroll Code" := gvPayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation
    end;

    var
        gvPayrollUtilities: Codeunit 51152;
}


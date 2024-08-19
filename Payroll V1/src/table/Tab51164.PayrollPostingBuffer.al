table 51164 "Payroll Posting Buffer"
{

    fields
    {
        field(1; "Buffer No"; Integer)
        {
        }
        field(2; "Account Type"; Option)
        {
            NotBlank = true;
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
        }
        field(3; "Account No"; Code[20])
        {
            NotBlank = true;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(4; "Payroll Code"; Code[10])
        {
            NotBlank = true;
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                //ERROR('Manual Edits not allowed.');
            end;
        }
        field(5; "ED Code"; Code[20])
        {
        }
        field(6; Amount; Decimal)
        {
            NotBlank = true;
        }
        field(7; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(8; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(9; "Amount (LCY)"; Decimal)
        {

            trigger OnValidate()
            var
                lvAllowedPayrolls: Record 51182;
                lvPayrollSetupRec: Record "Payroll Setups";
            begin
            end;
        }
        field(10; "Employee No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Buffer No")
        {
        }
        key(Key2; "Account Type", "Account No", "Payroll Code", "ED Code", "Currency Code")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        gvPayrollUtilities.sDeletePostingBufferDims(Rec);
    end;

    trigger OnInsert()
    begin
        IF "Account No" = '' THEN "Account No" := gvPayrollUtilities.gsAssignPayrollCode();
    end;

    var
        gvPayrollUtilities: Codeunit 51152;
}


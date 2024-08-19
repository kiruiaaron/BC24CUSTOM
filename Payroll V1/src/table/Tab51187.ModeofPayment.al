table 51187 "Mode of Payment"
{
    LookupPageID = 51202;

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Net Pay Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account";
        }
        field(4; "Net Pay Account No"; Code[20])
        {
            TableRelation = IF ("Net Pay Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Net Pay Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Net Pay Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Net Pay Account Type" = CONST("Bank Account")) "Bank Account";
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
}


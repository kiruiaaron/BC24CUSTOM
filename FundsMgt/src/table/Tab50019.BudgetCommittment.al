table 50019 "Budget Committment"
{
    Caption = 'Budget Committment';

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'LPO,Requisition,Imprest,Payment Voucher,PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,Grant Surrender,Cash Purchase';
            OptionMembers = LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,"Grant Surrender","Cash Purchase";
        }
        field(5; "Document No.";
        Code[20])
        {
            Caption = '"Document No."';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(7; "Month Budget"; Decimal)
        {
            Caption = 'Month Budget';
        }
        field(8; "Month Actual"; Decimal)
        {
        }
        field(9; Committed; Boolean)
        {
        }
        field(10; "Committed By"; Code[50])
        {
        }
        field(11; "Committed Date"; Date)
        {
        }
        field(12; "Committed Time"; Time)
        {
        }
        field(13; "Committed Machine"; Text[100])
        {
        }
        field(14; Cancelled; Boolean)
        {
        }
        field(15; "Cancelled By"; Code[20])
        {
        }
        field(16; "Cancelled Date"; Date)
        {
        }
        field(17; "Cancelled Time"; Time)
        {
        }
        field(18; "Cancelled Machine"; Text[100])
        {
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
        }
        field(21; "Shortcut Dimension 3 Code"; Code[20])
        {
        }
        field(22; "Shortcut Dimension 4 Code"; Code[20])
        {
        }
        field(23; "G/L Account No."; Code[20])
        {
        }
        field(24; Budget; Code[20])
        {
        }
        field(25; "Vendor/Cust No."; Code[20])
        {
            Caption = 'Vendor/Cust No.';
        }
        field(26; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = " ",Vendor,Customer;
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


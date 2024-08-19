table 51614 "Cash Management Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Payment Voucher Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(3; "Imprest Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(4; "Imprest Surrender Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(5; "PCASH Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(6; "Receipt Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(7; "Post VAT"; Boolean)
        {
        }
        field(8; "Rounding Type"; Option)
        {
            OptionCaption = 'Up,Nearest,Down';
            OptionMembers = Up,Nearest,Down;
        }
        field(9; "Rounding Precision"; Decimal)
        {
        }
        field(10; "Imprest Limit"; Decimal)
        {
        }
        field(11; "Imprest Due Date"; DateFormula)
        {
        }
        field(12; "PV Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Petty Cash Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; "Imprest Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(15; "Current Budget"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(16; "Current Budget Start Date"; Date)
        {
        }
        field(17; "Current Budget End Date"; Date)
        {
        }
        field(18; "Imprest Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }
        field(19; "General Bus. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
        }
        field(20; "VAT Bus. Posting Group"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
        }
        field(21; "Check for Committment"; Boolean)
        {
        }
        field(22; "Imprest Memo Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(23; "Imprest Surrender Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(24; "Bank Transfer Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(25; "Receipt Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(26; "Petty Cash Surrender Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(27; "Receipt Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Receipt Template"));
        }
        field(28; "Employee Posting Group"; Code[20])
        {
            TableRelation = "Employee Posting Group";
        }
        field(56000; "PV Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(56001; "PV Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("PV Journal Template"));
        }
        field(56002; "PCASH Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("PCASH Journal Template"));
        }
        field(56003; "IMPREST Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Imprest Journal Template"));
        }
        field(56004; "IMPREST SUR Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Imprest Surrender Template"));
        }
        field(56005; "Bank TR Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(56006; "Bank TR Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("PV Journal Template"));
        }
        field(56007; "Fuel Market Price"; Decimal)
        {
        }
        field(56008; "Imprest Surr Memo Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(56009; "EFT Header Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(56010; "EFT Details Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(56011; "Staff Claim Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(56012; "Staff Claim Journal Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Staff Claim Journal Template"));
        }
        field(56013; "Staff Claim Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(56014; "Lock Imprest Application"; Boolean)
        {
        }
        field(56015; "Send Email Notification"; Boolean)
        {
        }
        field(56016; "Imprest Email"; Text[100])
        {
        }
        field(56017; "Salary Advance Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(56018; "Planning Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(56019; "Imprest Nos - Posted"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(56020; "Input VAT Vendor"; Code[10])
        {
            TableRelation = Vendor;
        }
        field(56021; "Deployment Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


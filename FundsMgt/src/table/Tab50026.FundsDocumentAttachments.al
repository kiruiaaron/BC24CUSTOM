table 50026 "Funds Document Attachments"
{

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(3; "Document Type"; Option)
        {
            OptionCaption = ' ,Payment,Receipt,Imprest,Imprest Surrender,Funds Claim,Funds Transfer';
            OptionMembers = " ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Claim","Funds Transfer";
        }
        field(4; "Document No.";
        Code[20])
        {
        }
        field(20; "Document Link"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}


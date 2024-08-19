table 50022 "Bank Statement Buffer"
{
    Caption = 'Bank Statement Buffer';

    fields
    {
        field(1;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(2;"User ID";Code[50])
        {
        }
        field(3;Date;Date)
        {
            Caption = 'Date';
        }
        field(4;"Reference No.";Code[20])
        {
        }
        field(5;Description;Text[250])
        {
            Caption = 'Description';
        }
        field(10;Amount;Decimal)
        {
            Caption = 'Debit Amount';
        }
    }

    keys
    {
        key(Key1;"Line No.","User ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID":=USERID;
    end;
}


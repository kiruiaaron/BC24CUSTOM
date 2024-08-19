table 50156 "Medical Cover Setup"
{

    fields
    {
        field(10;"Line No";Integer)
        {
            AutoIncrement = true;
        }
        field(11;"Employee Category";Code[20])
        {
        }
        field(12;"In-Patient Amount";Decimal)
        {
        }
        field(13;"Out-Patient Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Employee Category")
        {
        }
    }

    fieldgroups
    {
    }
}


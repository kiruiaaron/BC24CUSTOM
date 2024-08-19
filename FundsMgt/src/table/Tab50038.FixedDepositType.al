table 50038 "Fixed Deposit Type"
{

    fields
    {
        field(1;"Code";Code[30])
        {
            NotBlank = true;
        }
        field(2;Duration;DateFormula)
        {
        }
        field(3;Description;Text[50])
        {
        }
        field(4;"No. of Months";Integer)
        {
        }
        field(5;"Maximum Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Code","Maximum Amount")
        {
        }
    }

    fieldgroups
    {
    }
}


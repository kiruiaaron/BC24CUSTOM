table 50039 "FD Interest Calculation Crite"
{

    fields
    {
        field(1;"Code";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Minimum Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3;"Maximum Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(4;"Interest Rate";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5;Duration;DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"On Call Interest Rate";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"No of Months";Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code","Minimum Amount",Duration)
        {
        }
    }

    fieldgroups
    {
    }
}


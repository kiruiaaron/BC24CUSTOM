table 50041 Charges
{

    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2;Description;Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Charge Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Percentage of Amount";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Percentage of Amount">100 THEN
                ERROR('You cannot exceed 100. Please enter a valid number.');
            end;
        }
        field(6;"Use Percentage";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"GL Account";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(8;Minimum;Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF Maximum<>0 THEN BEGIN
                IF Maximum<Minimum THEN
                ERROR('The maximum amount cannot be less than the minimum amount.');
                END;
            end;
        }
        field(9;Maximum;Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF Minimum<>0 THEN BEGIN
                IF Minimum>Maximum THEN
                ERROR('The minimum amount cannot be more than the maximum amount.');
                END;
            end;
        }
        field(10;"Charge Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Loans,Special Advance,Discounting,Standing Order Fee,Failed Standing Order Fee,External Standing Order Fee,Cheque Book,Cheque Processing';
            OptionMembers = " ",Loans,"Special Advance",Discounting,"Standing Order Fee","Failed Standing Order Fee","External Standing Order Fee","Cheque Book","Cheque Processing";
        }
        field(11;"Sacco Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Bank Account";Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}


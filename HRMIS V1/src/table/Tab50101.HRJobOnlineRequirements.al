table 50101 "HR Job Online Requirements"
{
    Caption = 'HR Job Requirement';

    fields
    {
        field(2;"Requirement Code";Code[50])
        {
            Caption = 'Requirement Code';
            TableRelation = "HR Job Lookup Value".Code WHERE (Option=CONST(Requirement));
        }
        field(3;Description;Text[250])
        {
            Caption = 'Description';
        }
        field(5;"Line No";Integer)
        {
            AutoIncrement = true;
        }
        field(6;"No. of Years";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"E-mail";Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Line No","Requirement Code","E-mail")
        {
        }
    }

    fieldgroups
    {
    }
}


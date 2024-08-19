table 50168 "HR Job Applicant Requirement"
{
    Caption = 'HR Job Requirement';

    fields
    {
        field(1;"Job Application No.";Code[20])
        {
            Caption = 'Job Application No.';
        }
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
        key(Key1;"Job Application No.","Line No","Requirement Code")
        {
        }
    }

    fieldgroups
    {
    }
}


table 50114 "HR Lookup Values"
{
    Caption = 'HR Job Lookup Value';

    fields
    {
        field(1;"Code";Code[50])
        {
            Caption = 'Code';
        }
        field(2;Option;Option)
        {
            Caption = 'Option';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Ethnicity,Religion,Nationality,Unit of Measure';
            OptionMembers = " ",Ethnicity,Religion,Nationality,"Unit of Measure";
        }
        field(3;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(10;"Line No";Integer)
        {
            AutoIncrement = true;
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


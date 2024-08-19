table 50258 "Recruitment Plan"
{

    fields
    {
        field(1;"Code";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Description;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Created by";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Goal;Text[250])
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

    trigger OnInsert()
    begin
        "Created by":=USERID;
    end;
}


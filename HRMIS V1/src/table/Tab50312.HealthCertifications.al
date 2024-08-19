table 50312 "Health Certifications"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2;Description;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Certificate No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Serial No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Date of Issue";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Date Of Expiry";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Amount Paid";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Document Path";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Active,Expired';
            OptionMembers = Active,Expired;
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}


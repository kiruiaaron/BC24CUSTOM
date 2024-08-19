table 50332 "Probation First Review"
{

    fields
    {
        field(1;"Review No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"First Review Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Performance Summary";Text[250])
        {
            Caption = 'Performance/Progress Summary';
            DataClassification = ToBeClassified;
        }
        field(4;"Objectives Met?";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Training Need Addressed?";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Training Need Action";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Training Need Review Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Objectives Met Action";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Objective Met Review Date";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Review No.")
        {
        }
    }

    fieldgroups
    {
    }
}


table 50324 "Appraisal Standard Import"
{

    fields
    {
        field(1;"Employee No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(2;"Employee Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Appraisal Period";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"KPI Code";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"KPI Description";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Activity Code";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Activity Description";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Standard Code";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Standard Description";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Target Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Target Score";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12;Processed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Relative Weightage";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Employee No","KPI Code","Activity Code","Standard Code")
        {
        }
    }

    fieldgroups
    {
    }
}


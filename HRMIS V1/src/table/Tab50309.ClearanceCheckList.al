table 50309 "Clearance Check List"
{

    fields
    {
        field(1;"Clearance No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;Department;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Employee Department,ICT,Finance,HR & Administration';
            OptionMembers = "Employee Department",ICT,Finance,"HR & Administration";
        }
        field(4;"Checklist item";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Clearance;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cleared,Not Cleared';
            OptionMembers = " ",Cleared,"Not Cleared";
        }
        field(6;Remarks;Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Clearance No","Line No")
        {
        }
    }

    fieldgroups
    {
    }
}


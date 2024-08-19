table 50313 "EHS Periodic Activities"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;Type;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Fire Extinguishers,Ambulance Services,First Aid Boxes,Blood Donations,Safety Audit,Fire Audit,Noise Measurements,Fumigation,First Aid Training,Stain Removal,Immunization';
            OptionMembers = " ","Fire Extinguishers","Ambulance Services","First Aid Boxes","Blood Donations","Safety Audit","Fire Audit","Noise Measurements",Fumigation,"First Aid Training","Stain Removal",Immunization;
        }
        field(3;Description;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Period Intervals";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Daily,Weekly,Monthly,Quartely, Bi Annually,Annually';
            OptionMembers = ,Daily,Weekly,Monthly,Quartely," Bi Annually",Annually;
        }
        field(5;"Activity Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Next Activity Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7;Coverage;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Comments & Recommendations";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Document Path";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Active,Archived';
            OptionMembers = Active,Archived;
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


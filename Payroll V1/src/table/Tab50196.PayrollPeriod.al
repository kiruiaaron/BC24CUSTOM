table 50196 "Payroll Period"
{

    fields
    {
        field(1;"Payroll Group Code";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll Group".Code;
        }
        field(2;"Date Opened";Date)
        {
            Caption = 'Payroll Period';
            DataClassification = ToBeClassified;
        }
        field(3;"Date Closed";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4;"Period Name";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Period Year";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Period Month";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7;Closed;Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(70;Status;Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Posted';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Posted;
        }
        field(71;Posted;Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(72;"Posted By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(73;"Date Posted";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(74;"Time Posted";Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99;"User ID";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
    }

    keys
    {
        key(Key1;"Payroll Group Code")
        {
        }
    }

    fieldgroups
    {
    }
}


table 50134 "HR Leave Types"
{
    // DrillDownPageID = 50229;
    //LookupPageID = 50229;

    fields
    {
        field(1; "Code"; Code[50])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Gender; Option)
        {
            OptionCaption = 'Both,Male,Female';
            OptionMembers = Both,Male,Female;
        }
        field(4; Days; Decimal)
        {
            MinValue = 0;
        }
        field(5; "Annual Leave"; Boolean)
        {
        }
        field(6; "Base Calendar"; Code[10])
        {
            TableRelation = "HR Base Calendar".Code;
        }
        field(8; "Inclusive of Non Working Days"; Boolean)
        {
        }
        field(10; "Take as Block"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; Balance; Option)
        {
            OptionCaption = 'Ignore,Carry Forward,Convert to Cash';
            OptionMembers = Ignore,"Carry Forward","Convert to Cash";
        }
        field(21; "Max Carry Forward Days"; Decimal)
        {
        }
        field(22; "Amount Per Day"; Decimal)
        {
        }
        field(23; "Leave Plan Mandatory"; Boolean)
        {
        }
        field(24; "Allow Negative Days"; Boolean)
        {
        }
        field(25; "Leave Year"; Integer)
        {
        }
        field(30; "Show in Portal"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Yes,No';
            OptionMembers = Yes,No;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}


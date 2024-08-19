table 50135 "HR Leave Periods"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Name;Text[50])
        {
            Caption = 'Name';
        }
        field(3;"Start Date";Date)
        {
            Caption = 'Start Date';
        }
        field(4;"End Date";Date)
        {
            Caption = 'End Date';
        }
        field(5;Closed;Boolean)
        {
            Caption = 'Closed';
        }
        field(6;"Leave Year";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20;"Enable Leave Planning";Boolean)
        {
        }
        field(21;"Leave Planning End Date";Date)
        {
        }
        field(22;"Enable Leave Application";Boolean)
        {
        }
        field(23;"Enable Leave Carryover";Boolean)
        {
        }
        field(24;"Leave Carryover End Date";Date)
        {
        }
        field(25;"Enable Leave Reimbursement";Boolean)
        {
        }
        field(26;"Leave Reimbursement End Date";Date)
        {
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
        Name:=Code;
    end;
}


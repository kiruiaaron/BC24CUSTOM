table 50124 "HR Employee Employment Hist."
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Employer Name/Organization"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Address of the Organization"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Job Designation/Position Held"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "To Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Days/Years of service" := Dates.DetermineAge_Years("From Date", "To Date");
            end;
        }
        field(8; "Days/Years of service"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Gross Salary"; Decimal)
        {
            Caption = 'Gross Salary in Kenya Shillings';
            DataClassification = ToBeClassified;
        }
        field(10; Benefits; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "E-mail"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Employee No.", "E-mail")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Dates: Codeunit Dates;
}


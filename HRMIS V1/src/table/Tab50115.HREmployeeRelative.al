/// <summary>
/// Table HR Employee Relative (ID 50115).
/// </summary>
table 50115 "HR Employee Relative"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; "Relative Code"; Code[10])
        {
            Caption = 'Relationship Code';
            TableRelation = Relative.Code;
        }
        field(4; Surname; Text[50])
        {
        }
        field(5; Firstname; Text[50])
        {
        }
        field(6; Middlename; Text[50])
        {
        }
        field(7; "Date of Birth"; Date)
        {

            trigger OnValidate()
            begin
                Age := Dates.DetermineAge("Date of Birth", TODAY);
            end;
        }
        field(8; Age; Text[250])
        {
        }
        field(9; Type; Option)
        {
            OptionCaption = 'Relative,Next Of Kin,Beneficiary';
            OptionMembers = Relative,"Next Of Kin",Beneficiary;
        }
        field(10; "Relationship Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Postal Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Mobile No"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Dates: Codeunit Dates;
        PostCode: Record "Post Code";
}


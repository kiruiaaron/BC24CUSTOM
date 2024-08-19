table 50181 "HR Employee Documents"
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
        field(3; "Document Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Document Path"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
        Dates: Codeunit 50043;
        PostCode: Record "Post Code";
}


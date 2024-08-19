table 50110 "HR Job Applicant Results"
{

    fields
    {
        field(1;"Job Applicant No";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3;Surname;Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4;Firstname;Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5;Middlename;Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;"Job No";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;"Job Requistion No";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "HR Employee Requisitions";
        }
        field(10;Closed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50;"EV 1";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(51;"EV 2";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(52;"EV 3";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(53;"EV 4";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(54;"EV 5";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(55;"EV 6";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(56;"EV 7";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(57;"EV 8";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(58;"EV 9";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(59;"EV 10";Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                Total:="EV 1"+"EV 2"+"EV 3"+"EV 4"+"EV 5"+"EV 6"+"EV 7"+"EV 8"+"EV 9"+"EV 10";
            end;
        }
        field(80;Total;Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(81;Position;Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Job Applicant No")
        {
        }
        key(Key2;Total)
        {
        }
    }

    fieldgroups
    {
    }
}


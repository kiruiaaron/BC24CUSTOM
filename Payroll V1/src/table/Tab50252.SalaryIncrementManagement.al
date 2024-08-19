table 50252 "Salary Increment Management"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Created By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Last Modified By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Last Modified Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Total Amount Planned"; Decimal)
        {
            CalcFormula = Sum("Compensation Plan Dept Line"."Amount Planned" WHERE("Compensation Plan code" = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Increment Reason"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Method; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Individual,Percentage,Block Figure';
            OptionMembers = Individual,Percentage,"Block Figure";
        }
        field(9; "Mass Value"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF Method = Method::Individual THEN
                    ERROR('You are not allowed to enter for individual. Please update on lines');
            end;
        }
        field(10; "Ed Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Payments));

            trigger OnValidate()
            begin
                IF Method = Method::Individual THEN
                    ERROR('You are not allowed to enter for individual. Please update on lines');
            end;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Posted;
        }
        field(72; "Start Period"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Periods."Period ID" WHERE(Status = CONST(Open));

            trigger OnValidate()
            var
                PeriodRec: Record 51151;
                PayrollHeaderrec: Record 51159;
            begin
            end;
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

    trigger OnInsert()
    begin
        "Created By" := USERID;
        "Last Modified By" := USERID;
        "Last Modified Date Time" := CURRENTDATETIME;
    end;

    trigger OnModify()
    begin

        "Last Modified By" := USERID;
        "Last Modified Date Time" := CURRENTDATETIME;
    end;
}


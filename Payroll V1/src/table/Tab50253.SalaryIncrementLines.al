table 50253 "Salary Increment Lines"
{

    fields
    {
        field(1; "Increment Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salary Increment Management";
        }
        field(2; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Employee.GET("Employee No");
                "Employee name" := Employee.FullName;
                "Current Amount" := GetEdAmount("Employee No", "Ed Code");
            end;
        }
        field(3; "Ed Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Payments));

            trigger OnValidate()
            begin
                EDDefinitions.GET("Ed Code");
                "Ed Definition" := EDDefinitions.Description;
                "Current Amount" := GetEdAmount("Employee No", "Ed Code");
            end;
        }
        field(4; "Employee name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Ed Definition"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Current Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Proposed Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Increment Value"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Proposed Amount" := "Current Amount" + "Increment Value";
            end;
        }
    }

    keys
    {
        key(Key1; "Increment Code", "Employee No", "Ed Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EDDefinitions: Record 51158;
        Employee: Record 5200;
        PayrollSetups: Record 51165;

    local procedure GetEdAmount(Employeeno: Code[20]; EDcode: Code[20]): Decimal
    var
        PayrollEntry: Record 51161;
    begin
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE("ED Code", EDcode);
        PayrollEntry.SETRANGE("Employee No.", Employeeno);
        IF PayrollEntry.FINDFIRST THEN
            EXIT(PayrollEntry.Amount)
        ELSE
            EXIT(0)
    end;
}


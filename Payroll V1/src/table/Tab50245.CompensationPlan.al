table 50245 "Compensation Plan"
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
        field(7; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "End date"; Date)
        {
            DataClassification = ToBeClassified;
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

    procedure CalculateExpenditure(PLanCode: Code[20]; EDcode: Code[30]; Department: Code[20]): Decimal
    var
        CompensationPlan: Record 50245;
        PayrollLines: Record 51160;
        Amountspent: Decimal;
    begin
        Amountspent := 0;
        CompensationPlan.GET(PLanCode);
        IF (CompensationPlan."Start Date" = 0D) OR (CompensationPlan."End date" = 0D) THEN
            EXIT(0);
        PayrollLines.RESET;
        PayrollLines.SETRANGE("Posting Date", CompensationPlan."Start Date", CompensationPlan."End date");
        PayrollLines.SETRANGE("Calculation Group", PayrollLines."Calculation Group"::Payments);
        IF EDcode <> '' THEN
            PayrollLines.SETRANGE("ED Code", EDcode);
        IF Department <> '' THEN
            PayrollLines.SETRANGE("Global Dimension 1 Code", Department);

        PayrollLines.CALCSUMS(Amount);
        Amountspent := PayrollLines.Amount;
        EXIT(Amountspent);
    end;
}


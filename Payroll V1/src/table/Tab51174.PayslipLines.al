table 51174 "Payslip Lines"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            NotBlank = true;
        }
        field(2; "Payslip Group"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Payslip Group";
        }
        field(3; "Line Type"; Option)
        {
            OptionMembers = "E/D code",P9;
        }
        field(4; P9; Option)
        {
            OptionMembers = " ",A,B,C,D,E1,E2,E3,F,G,H,J,K,L,M;
        }
        field(5; "E/D Code"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(6; "P9 Text"; Text[50])
        {
        }
        field(7; Amount; Decimal)
        {
        }
        field(8; "E/D Description"; Text[50])
        {
            CalcFormula = Lookup("ED Definitions".Description WHERE("ED Code" = FIELD("E/D Code")));
            FieldClass = FlowField;
        }
        field(9; Negative; Boolean)
        {
        }
        field(50009; "Payroll Code"; Code[10])
        {
            Editable = true;
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                //ERROR('Manual Edits not allowed.');
            end;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Payslip Group", "Payroll Code")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine(LastReg: Record 51174; BottomLine: Boolean)
    var
        LastReg2: Record 51174;
    begin
        LastReg2.COPY(LastReg);
        LastReg2.SETRANGE("Payslip Group", LastReg."Payslip Group");

        IF BottomLine THEN
            IF LastReg2.FIND('-') THEN
                "Line No." := LastReg."Line No." + 10000
            ELSE
                "Line No." := 10000
        ELSE BEGIN
            IF LastReg2.FIND('<') THEN
                "Line No." := (LastReg."Line No." + LastReg2."Line No.") DIV 2
            ELSE
                "Line No." := LastReg."Line No." DIV 2
        END;
    end;

    procedure gsAssignPayrollCode()
    var
        lvUserSetup: Record 91;
    begin
        lvUserSetup.GET(USERID);
        // lvUserSetup.TESTFIELD("Give Access to Payroll");
        //Rec. "Payroll Code" := lvUserSetup."Give Access to Payroll"
    end;
}


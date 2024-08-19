table 51192 "Calculation Scheme Master Roll"
{
    LookupPageID = 51153;

    fields
    {
        field(2; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;
        }
        field(10; Number; Integer)
        {
        }
        field(11; "ED Code"; Code[20])
        {
            TableRelation = "ED Definitions";

            trigger OnValidate()
            var
                lvSpecialAllowances: Record 51167;
            begin
            end;
        }
        field(12; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Value Source"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'ED Definition,Total Gross,Total Deduction,Net Pay';
            OptionMembers = "ED Definition","Total Gross","Total Deduction","Net Pay";
        }
        field(14; Negative; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Payroll Code", Number)
        {
        }
    }

    fieldgroups
    {
    }

    var
        EDDif: Record 51158;
        Scheme: Record 51154;
        gvPayrollUtilites: Codeunit 51152;

    procedure SetUpNewLine(LastReg: Record 51154; BottomLine: Boolean)
    var
        LastReg2: Record 51154;
    begin
    end;
}


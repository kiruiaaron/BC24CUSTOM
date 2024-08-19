/// <summary>
/// Table Calculation Scheme (ID 51154).
/// </summary>
table 51154 "Calculation Scheme"
{
    LookupPageID = 51153;

    fields
    {
        field(1; "Line No."; Integer)
        {
        }
        field(2; "Scheme ID"; Code[20])
        {
            TableRelation = "Calculation Header";
        }
        field(3; Amount; Decimal)
        {
        }
        field(4; "Payroll Entry"; Code[20])
        {

            trigger OnLookup()
            var
                lvEDDef: Record "ED Definitions";
            begin
            end;

            trigger OnValidate()
            var
                lvEDDef: Record "ED Definitions";
            begin
            end;
        }
        field(5; Calculation; Option)
        {
            OptionMembers = "None",Add,Substract,Multiply,Divide,Percent,Highest,Lowest,"Look Up";
        }
        field(6; "Compute To"; Integer)
        {
        }
        field(7; "Factor of"; Integer)
        {
            TableRelation = "Calculation Scheme" WHERE("Scheme ID" = FIELD("Scheme ID"));
        }
        field(8; Percent; Decimal)
        {
            DecimalPlaces = 3 : 3;
        }
        field(9; "Round Precision"; Decimal)
        {
            InitValue = 1;
            MinValue = 0.01;
        }
        field(10; Number; Decimal)
        {
        }
        field(11; "Payroll Lines"; Code[20])
        {
            TableRelation = "ED Definitions";

            trigger OnValidate()
            var
                lvSpecialAllowances: Record "Special Allowances";
            begin
            end;
        }
        field(12; P9A; Option)
        {
            OptionMembers = " ",A,B,C,D,E1,E2,E3,F,G,H,J,K,L,M;
        }
        field(15; Description; Text[55])
        {
        }
        field(16; Round; Option)
        {
            InitValue = Nearest;
            OptionMembers = "None",Up,Down,Nearest;
        }
        field(17; LookUp; Code[20])
        {
            TableRelation = "Lookup Table Header";
        }
        field(18; Input; Option)
        {
            OptionMembers = "None","Calculation Line","Payroll Entry";
        }
        field(19; "Caculation Line"; Integer)
        {
            TableRelation = "Calculation Scheme" WHERE("Scheme ID" = FIELD("Scheme ID"));
        }
        field(20; Quantity; Decimal)
        {
        }
        field(21; Rate; Decimal)
        {
        }
        field(22; Multiline; Boolean)
        {
            InitValue = false;
        }
        field(23; "Loan Entry"; Boolean)
        {
            InitValue = false;
        }
        field(24; Interest; Decimal)
        {
        }
        field(25; Repayment; Decimal)
        {
        }
        field(26; "Remaining Debt"; Decimal)
        {
        }
        field(27; Paid; Decimal)
        {
        }
        field(28; "Total Earnings (B4 SAPP)"; Boolean)
        {
            Description = 'Total Earnings Before Special Allowances/Payments and Pension';
        }
        field(29; "Special Allowance"; Boolean)
        {
            Description = 'Indicates a tax free allowance to be inserted by the system from Special Allowances setup table';
        }
        field(30; "Special Payment"; Boolean)
        {
            Description = 'Indicates a tax free payment to be inserted by the system from Special Payments setup table';
        }
        field(31; "Chargeable Pay (B4 SAP)"; Boolean)
        {
            Description = 'Indicates a taxable amount without Special Allowances and Special Payments';
        }
        field(32; "Chargeable Pay"; Boolean)
        {
            Description = 'Indicates a taxable amount with Special Allowances and Special Payments';
        }
        field(33; "Special Allowance Calculated"; Boolean)
        {
            Description = 'Indicates whether the Special Allowance has been retrieved from setup table and included in taxable pay';
        }
        field(34; "PAYE Lookup Line"; Boolean)
        {
            Description = 'Identifies the Calc Scheme Line that looks up PAYE. Used in processing Special Allowances';
        }
        field(35; "Special Payment Calculated"; Boolean)
        {
            Description = 'Indicates whether the Special Payment has been retrieved from setup table and included in taxable pay';
        }
        field(36; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;
        }
        field(37; "Amount (LCY)"; Decimal)
        {
        }
        field(38; "Rate (LCY)"; Decimal)
        {
        }
        field(39; "Interest (LCY)"; Decimal)
        {
        }
        field(40; "Repayment (LCY)"; Decimal)
        {
        }
        field(41; "Remaining Debt (LCY)"; Decimal)
        {
        }
        field(42; "Paid (LCY)"; Decimal)
        {
        }
        field(43; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(44; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(45; "Annualize TAX"; Boolean)
        {
            Description = 'Added for Select Annualize Tax Scheme';
        }
        field(46; "Annualize Relief"; Boolean)
        {
            Description = 'Added for Select Annualize Relief Scheme';
        }
    }

    keys
    {
        key(Key1; "Line No.", "Scheme ID")
        {
        }
        key(Key2; "Payroll Entry")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EDDif: Record "ED Definitions";
        Scheme: Record "ED Definitions";
        gvPayrollUtilites: Codeunit "Payroll Posting";

    procedure SetUpNewLine(LastReg: Record "Calculation Scheme"; BottomLine: Boolean)
    var
        LastReg2: Record "Calculation Scheme";
    begin
    end;
}


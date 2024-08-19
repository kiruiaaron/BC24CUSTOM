table 51159 "Payroll Header"
{
    Permissions = TableData 51159 = rimd,
                  TableData 51160 = rimd,
                  TableData 51161 = rimd;

    fields
    {
        field(1; "Payroll ID"; Code[10])
        {
            NotBlank = true;
            TableRelation = Periods."Period ID";
        }
        field(2; "Payroll Month"; Integer)
        {
        }
        field(3; "Payroll Year"; Integer)
        {
        }
        field(4; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;
        }
        field(5; "A (LCY)"; Decimal)
        {
        }
        field(6; "B (LCY)"; Decimal)
        {
        }
        field(7; "C (LCY)"; Decimal)
        {
        }
        field(8; "D (LCY)"; Decimal)
        {
        }
        field(9; "E1 (LCY)"; Decimal)
        {
        }
        field(10; "E2 (LCY)"; Decimal)
        {
        }
        field(11; "E3 (LCY)"; Decimal)
        {
        }
        field(12; "F (LCY)"; Decimal)
        {
        }
        field(13; "G (LCY)"; Decimal)
        {
        }
        field(14; "H (LCY)"; Decimal)
        {
        }
        field(16; "J (LCY)"; Decimal)
        {
        }
        field(17; "K (LCY)"; Decimal)
        {
        }
        field(18; "L (LCY)"; Decimal)
        {
        }
        field(19; "M (LCY)"; Decimal)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "M (LCY)" < 0 THEN
                    "M (LCY)" := 0;
            end;
        }
        field(20; Calculated; Boolean)
        {
        }
        field(21; "First Name"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Employee."First Name" WHERE("No." = FIELD("Employee No.")));
            Editable = false;

        }
        field(22; "Last Name"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Employee."Last Name" WHERE("No." = FIELD("Employee No.")));
            Editable = false;

        }
        field(23; "Payroll Period"; Text[30])
        {

            FieldClass = FlowField;
            CalcFormula = Lookup(Periods.Description WHERE("Period ID" = FIELD("Payroll ID")));
            Editable = false;

        }
        field(24; "Total Payable (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Payroll ID" = FIELD("Payroll ID"),
                                                                    "Employee No." = FIELD("Employee No."),
                                                                    "Calculation Group" = CONST(Payments),
                                                                    Rounding = CONST(false)));
            Editable = false;

        }
        field(25; "Total Benefit (LCY)"; Decimal)
        {
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Payroll ID" = FIELD("Payroll ID"),
                                                                    "Employee No." = FIELD("Employee No."),
                                                                    "Calculation Group" = CONST("Benefit non Cash")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Total Deduction (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Payroll ID" = FIELD("Payroll ID"),
                                                                    "Employee No." = FIELD("Employee No."),
                                                                    "Calculation Group" = CONST(Deduction),
                                                                    Rounding = CONST(false)));
            Editable = false;

        }
        field(27; Posted; Boolean)
        {
            InitValue = false;
        }
        field(28; "Basic Pay"; Decimal)
        {
        }
        field(29; "Hour Rate"; Decimal)
        {
        }
        field(30; "Day Rate"; Decimal)
        {
        }
        field(330; "Mid Month Advance Code"; Code[10])
        {
        }
        field(331; "Total Other (LCY)"; Decimal)
        {
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Payroll ID" = FIELD("Payroll ID"),
                                                                    "Employee No." = FIELD("Employee No."),
                                                                    "Calculation Group" = CONST(None)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(332; "Advance (LCY)"; Decimal)
        {
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Payroll ID" = FIELD("Payroll ID"),
                                                                    "Employee No." = FIELD("Employee No."),
                                                                    "Calculation Group" = CONST(Deduction),
                                                                    "ED Code" = FIELD("Mid Month Advance Code")));
            FieldClass = FlowField;
        }
        field(333; "NHIF Code"; Code[20])
        {
            CalcFormula = Lookup("Payroll Setups"."NHIF ED Code");
            FieldClass = FlowField;
        }
        field(334; "NHIF Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Payroll ID" = FIELD("Payroll ID"),
                                                                    "Employee No." = FIELD("Employee No."),
                                                                    "Calculation Group" = CONST(Deduction),
                                                                    "ED Code" = FIELD("NHIF Code")));
            FieldClass = FlowField;
        }
        field(335; "NSSF Code"; Code[20])
        {
            CalcFormula = Lookup("Payroll Setups"."NSSF ED Code");
            FieldClass = FlowField;
        }
        field(336; "NSSF Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Payroll ID" = FIELD("Payroll ID"),
                                                                    "Employee No." = FIELD("Employee No."),
                                                                    "Calculation Group" = CONST(Deduction),
                                                                    "ED Code" = FIELD("NSSF Code")));
            FieldClass = FlowField;
        }
        field(337; "Total Rounding Pmts (LCY)"; Decimal)
        {
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Payroll ID" = FIELD("Payroll ID"),
                                                                    "Employee No." = FIELD("Employee No."),
                                                                    "Calculation Group" = CONST(Payments),
                                                                    Rounding = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(338; "Total Rounding Ded (LCY)"; Decimal)
        {
            CalcFormula = Sum("Payroll Lines"."Amount (LCY)" WHERE("Payroll ID" = FIELD("Payroll ID"),
                                                                    "Employee No." = FIELD("Employee No."),
                                                                    "Calculation Group" = CONST(Deduction),
                                                                    Rounding = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(339; "Manually Imported"; Boolean)
        {
            Editable = false;
        }
        field(340; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                //ERROR('Manual Edits not allowed.');
            end;
        }
        field(341; "Basic Pay Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(342; "Basic Pay Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(343; "Basic Pay (LCY)"; Decimal)
        {
        }
        field(344; "Hour Rate (LCY)"; Decimal)
        {
        }
        field(345; "Day Rate (LCY)"; Decimal)
        {
        }

        field(347; "Business Loan"; Decimal)
        {
            /* CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period ID"),
                                                             "Employee No." = FIELD("Employee No."),
                                                             "Calculation Group" = CONST(Deduction),
                                                             Rounding = CONST(false),
                                                             "ED Code" = CONST(BLOAN)));*/
            FieldClass = Normal;
        }
        field(348; Savings; Decimal)
        {
            /*CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period ID"),
                                                            "Employee No." = FIELD("Employee No."),
                                                            "Calculation Group" = CONST(Deduction),
                                                            Rounding = CONST(false),
                                                            "ED Code"= CONST(SAVINGS)));*/
            FieldClass = Normal;
        }
        field(349; "School Fees Loan"; Decimal)
        {
            /* CalcFormula = Sum("Payroll Lines".Amount WHERE("Payroll ID" = FIELD("Period ID"),
                                                             "Employee No." = FIELD("Employee No."),
                                                             "Calculation Group" = CONST(Deduction),
                                                             Rounding = CONST(False),
                                                             "ED Code" = CONST(SFEE)));*/
            FieldClass = Normal;
        }

        field(371; "Employee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',CMT,General,Apprecentices';
            OptionMembers = ,CMT,General,Apprecentices;
        }
        field(372; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin

                /*ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                Rec.MODIFY;*/

            end;
        }
        field(373; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin

                /*ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                Rec.MODIFY;*/

            end;
        }
        field(374; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
    }

    keys
    {
        key(Key1; "Payroll ID", "Employee No.")
        {
        }
        key(Key2; "Payroll Month")
        {
            SumIndexFields = "A (LCY)", "B (LCY)", "C (LCY)", "D (LCY)", "E1 (LCY)", "E2 (LCY)", "E3 (LCY)", "F (LCY)", "G (LCY)", "H (LCY)", "J (LCY)", "K (LCY)", "L (LCY)", "M (LCY)";
        }
        key(Key3; Posted)
        {
        }
        key(Key4; "Employee No.", "Payroll Year")
        {
            SumIndexFields = "A (LCY)", "B (LCY)", "C (LCY)", "D (LCY)", "E1 (LCY)", "E2 (LCY)", "E3 (LCY)", "F (LCY)", "G (LCY)", "H (LCY)", "J (LCY)", "K (LCY)", "L (LCY)", "M (LCY)";
        }
        key(Key5; "Employee No.", "Payroll Year", "Payroll Month")
        {
        }
        key(Key6; "Employee No.", "Payroll Year", "Payroll Code")
        {
            SumIndexFields = "A (LCY)", "B (LCY)", "C (LCY)", "D (LCY)", "E1 (LCY)", "E2 (LCY)", "E3 (LCY)", "F (LCY)", "G (LCY)", "H (LCY)", "J (LCY)", "K (LCY)", "L (LCY)", "M (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Rec.TESTFIELD(Posted, FALSE);

        PayrollEntry.SETRANGE("Payroll ID", "Payroll ID");
        PayrollEntry.SETRANGE("Employee No.", "Employee No.");
        PayrollEntry.DELETEALL;

        PayrollLines.SETRANGE("Payroll ID", "Payroll ID");
        PayrollLines.SETRANGE("Employee No.", "Employee No.");
        PayrollLines.DELETEALL;

        PayrollUtilities.sDeleteDefaultEmpDims(Rec); //skm310506 Advanced Dimensions
    end;

    trigger OnInsert()
    begin
        IF "Payroll Code" = '' THEN "Payroll Code" := PayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation

        PayrollUtilities.sGetDefaultEmpDims(Rec); //skm310506 Advanced Dimensions
    end;

    trigger OnRename()
    begin
        PayrollUtilities.sDeleteDefaultEmpDims(Rec); //skm310506 Advanced Dimensions
        PayrollUtilities.sGetDefaultEmpDims(Rec); //skm310506 Advanced Dimensions
    end;

    var
        PayrollSetup: Record "Payroll Setups";
        PayrollLines: Record 51160;
        PayrollEntry: Record 51161;
        DimMgt: Codeunit DimensionManagement;
        PayrollUtilities: Codeunit "Payroll Posting";

    procedure ShowPayrollDim()
    var
        PayrollDim: Record "Payroll Dimension";
        PayrollDims: Page "Payroll Dimensions";
    begin
        PayrollDim.SETRANGE("Table ID", DATABASE::"Payroll Header");
        PayrollDim.SETRANGE("Payroll ID", "payroll ID");
        PayrollDim.SETRANGE("Employee No", "Employee No.");
        PayrollDim.SETRANGE("Payroll Code", "Payroll Code");
        PayrollDim.SETRANGE("Entry No", 0);
        PayrollDims.SETTABLEVIEW(PayrollDim);
        PayrollDims.RUNMODAL;
        GET("Payroll ID", "Employee No.");
    end;
}


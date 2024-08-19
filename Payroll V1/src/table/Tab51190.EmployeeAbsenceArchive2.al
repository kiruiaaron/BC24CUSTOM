/// <summary>
/// Table Employee Absence Archive2 (ID 51190).
/// </summary>
table 51190 "Employee Absence Archive2"
{
    Caption = 'Employee Absence';
    DataCaptionFields = "Employee No.";
    // DrillDownPageID = 5211;
    // LookupPageID = 5211;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Editable = false;
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Employee.GET("Employee No.");
            end;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(3; "From Date"; Date)
        {
            Caption = 'From Date';
            Editable = false;
        }
        field(4; "To Date"; Date)
        {
            Caption = 'To Date';
            Editable = false;
        }
        field(5; "Cause of Absence Code"; Code[10])
        {
            Caption = 'Cause of Absence Code';
            Editable = false;
            TableRelation = "Cause of Absence";

            trigger OnValidate()
            begin
                CauseOfAbsence.GET("Cause of Absence Code");
                Description := CauseOfAbsence.Description;
                VALIDATE("Unit of Measure Code", CauseOfAbsence."Unit of Measure Code");
                //KE Payroll
                //"Day/Hour" := CauseOfAbsence."Day/Hour";
                //"Tranfer to Payroll" := CauseOfAbsence."Transfer To Payroll";
            end;
        }
        field(6; Description; Text[30])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                "Quantity (Base)" := CalcBaseQty(Quantity);
            end;
        }
        field(8; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Human Resource Unit of Measure";

            trigger OnValidate()
            begin
                HumanResUnitOfMeasure.GET("Unit of Measure Code");
                "Qty. per Unit of Measure" := HumanResUnitOfMeasure."Qty. per Unit of Measure";
                VALIDATE(Quantity);
            end;
        }
        field(11; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST("Employee Absence"),
                                                                     "Table Line No." = FIELD("Entry No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                Rec.TESTFIELD("Qty. per Unit of Measure", 1);
                VALIDATE(Quantity, "Quantity (Base)");
            end;
        }
        field(13; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(50000; "Qty of Stems"; Decimal)
        {
            Editable = false;
        }
        field(50001; "Qty Boxes Packed"; Decimal)
        {
            Editable = false;
        }
        field(50002; "Qty Labels Made"; Decimal)
        {
            Editable = false;
        }
        field(50003; "Qty Plants Rooted"; Decimal)
        {
            Editable = false;
        }
        field(50004; "Qty of Bouquets"; Decimal)
        {
            Editable = false;
        }
        field(50005; "Transfer to Bonus"; Boolean)
        {
            Editable = false;
        }
        field(50006; Team; Code[20])
        {
            Editable = false;
            // TableRelation = Table39020002.Field1;
        }
        field(50007; "Approval Status"; Option)
        {
            Editable = false;
            OptionMembers = Open,Released;
        }
        field(50010; Supervisor; Code[20])
        {
            Description = 'Added by GJ';
            Editable = false;
            TableRelation = Employee;
        }
        field(50012; "Org. Unit"; Code[20])
        {
            Description = 'Added by GJ';
            Editable = false;
            // TableRelation = Table39013013;
        }
        field(50013; "Batch name"; Code[10])
        {
            Description = 'Added by WTM for ODC_CCN_71';
            Editable = false;
        }
        field(39012001; "Tranfer to Payroll"; Boolean)
        {
            Editable = false;
            InitValue = true;
        }
        field(39012002; Transferred; Boolean)
        {
            Editable = false;
        }
        field(39012003; "Day/Hour"; Option)
        {
            Editable = false;
            OptionMembers = Day,Hour;
        }
        field(39012004; "Charge Date"; Date)
        {
            Description = 'Date a backposted time is charged in payroll';
            Editable = false;

            trigger OnValidate()
            begin
                IF ("Tranfer to Payroll") AND ("Charge Date" = 0D) THEN
                    ERROR('Charge Date can''t be null for an entry to be transferred to payroll.');
            end;
        }
        field(39012005; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(39012006; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(39012007; "Payroll Code"; Code[10])
        {
            Editable = false;
            TableRelation = Payroll;

            trigger OnValidate()
            begin
                ERROR('Manual Edits not allowed.');
            end;
        }
        field(39012008; "Reason Code"; Code[20])
        {
            Description = 'Added by GJ for HR2-3';
            Editable = false;
            //TableRelation = Table39013129;
        }
        field(39012009; "Transfer to Field"; Boolean)
        {
            Description = 'Added by GJ for PR2';
            Editable = false;
        }
        field(39012010; "Field No."; Code[20])
        {
            Description = 'Added by GJ for PR2';
            Editable = false;
            TableRelation = "Fixed Asset" WHERE(Blocked = FILTER(false));
        }
        field(39012011; "Field Section No."; Code[20])
        {
            Description = 'Added by GJ for PR2';
            Editable = false;
            // TableRelation = Table39020104.Field2 WHERE(Field1 = FIELD(Field No.));
        }
        field(39012012; "Transferred to Field Cost"; Boolean)
        {
            Description = 'Added by GJ for PR2';
            Editable = false;
        }
        field(39012013; "Qty of Processed Stems"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(39012030; "Archived By"; Code[10])
        {
            Editable = false;
        }
        field(39012031; "Date Archived"; Date)
        {
            Editable = false;
        }
        field(39012032; "Time Archived"; Time)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Employee No.", "From Date")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key3; "Employee No.", "Cause of Absence Code", "From Date")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key4; "Cause of Absence Code", "From Date")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key5; "From Date", "To Date")
        {
        }
        key(Key6; "Employee No.", "Cause of Absence Code", "From Date", "Transfer to Bonus")
        {
        }
        key(Key7; "From Date", Team)
        {
        }
        key(Key8; "Employee No.", Supervisor, "Org. Unit", "From Date")
        {
        }
        key(Key9; "Batch name", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        EmployeeAbsence.SETCURRENTKEY("Entry No.");
        IF EmployeeAbsence.FIND('+') THEN
            "Entry No." := EmployeeAbsence."Entry No." + 10000
        ELSE
            "Entry No." := 10000;

        IF "Payroll Code" = '' THEN "Payroll Code" := gvPayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation
    end;

    var
        CauseOfAbsence: Record 5206;
        Employee: Record 5200;
        EmployeeAbsence: Record 5207;
        HumanResUnitOfMeasure: Record 5220;
        gvPayrollUtilities: Codeunit "Payroll Posting";

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        Rec.TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;
}


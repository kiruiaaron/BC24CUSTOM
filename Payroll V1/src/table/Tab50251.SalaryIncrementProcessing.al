table 50251 "Salary Increment Processing"
{

    fields
    {
        field(1; "No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                EmployeeRec.GET(Rec."Employee No.");
                "Employee Name" := EmployeeRec.FullName;
                "Current Job Grade" := EmployeeRec."Employee Grade";
                "Current Designation" := EmployeeRec."Job Title";

                //Get current Basic, House allowance, Commuter allowance
                PayrollSetupsRec.GET(EmployeeRec."Payroll Code");

                //Basic,Commuter,House
                "Current Basic Pay" := GetEDAmount(PayrollSetupsRec."Basic Pay E/D Code", "Employee No.");
                "Current Commuter Allowance" := GetEDAmount(PayrollSetupsRec."Commuter Allowance ED", "Employee No.");
                "Current House Allowance" := GetEDAmount(PayrollSetupsRec."House Allowances ED", "Employee No.");

                "Active Years Of Service" := EmployeeRec."Active Service Years";
            end;
        }
        field(3; "Employee Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Financial Year"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Base Calendar";
        }
        field(5; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Current Job Grade"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Job Lookup Value" WHERE(Option = CONST("Job Grade"));
        }
        field(7; "Current Designation"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Date of Last Increment"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Current Basic Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Current House Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Current Commuter Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Medical Cover Inpatient"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Medical Cover Outpatient"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Leave Training Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Club Membership"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Proposed Basic Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Proposed House Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Proposed Commuter Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Proposed Cadre"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Proposed Inpatient"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Proposed Outpatient"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Proposed Leave Travel Allowanc"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Proposed Club Membership"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Current Breakfast Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Current Lunch Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Current Dinner Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Current Per-Diem Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Current Out of the Pocket"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Proposed Breakfast Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Proposed Lunch Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Proposed Dinner Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Proposed Per-Diem Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Proposed Out of the Pocket"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Expected Pay Computation PM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Expected Pay Computation Pa"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Remarks By HOD"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "HOD Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(38; "HOD Designation"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "HRM Signature"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(40; "Remarks by HRAM"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "HRAM Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "HRAM Designation"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(43; "HRAM Signature"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(44; "HRAM Remarks Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Remarks By MD"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Is Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(47; "MD Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "MD Designation"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "MD Signature"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(50; "MDs Remarks Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52; "HoD Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(53; "HoD Signature"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(54; "Current Cadre"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Proposed Designation"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Jobs";
        }
        field(56; "Active Years Of Service"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(57; "Avg Performance Appraisal"; Decimal)
        {
            Caption = 'Avg Performance Appraisal for the last 2 years';
            DataClassification = ToBeClassified;
        }
        field(58; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(59; "Current Extraneous Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Proposed Extraneous Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(61; "Proposed Job Grade"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Job Lookup Value" WHERE(Option = CONST("Job Grade"));
        }
        field(62; "Minimum Basic"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(63; "Maximum Basic"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(64; "Proposed Minimum Basic"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(65; "Proposed Maximum Basic"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(66; "Current Salary Point"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Job Grade Levels" WHERE("Job Grade" = FIELD("Current Job Grade"));
        }
        field(68; "Proposed Salary Point"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Job Grade Levels" WHERE("Job Grade" = FIELD("Proposed Job Grade"));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        HumanResourcesSetupRec.GET;
        IF "No." = '' THEN BEGIN
            // HumanResourcesSetupRec.TESTFIELD("Salary Increment Nos");
            //  NoSeriesMgt.InitSeries(HumanResourcesSetupRec."Salary Increment Nos",xRec."No. Series",0D,"No.","No. Series");
        END;

        "Document Date" := TODAY;
    end;

    var
        HumanResourcesSetupRec: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeRec: Record 5200;
        PayrollSetupsRec: Record 51165;
        PayrollEntryRec: Record 51161;
        PeriodsRec: Record 51151;
        PeriodId: Code[10];
    // HRDates: Codeunit 52002;

    local procedure GetEDAmount(EDCode: Code[20]; EmployeeNo: Code[20]): Decimal
    var
        PayrollEntry: Record 51161;
    begin
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE("ED Code", EDCode);
        PayrollEntry.SETRANGE("Employee No.", EmployeeNo);
        IF PayrollEntry.FINDFIRST THEN
            EXIT(PayrollEntry.Amount)
        ELSE
            EXIT(0)
    end;
}


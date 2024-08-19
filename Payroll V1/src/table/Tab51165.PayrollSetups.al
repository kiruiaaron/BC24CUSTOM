/// <summary>
/// Table Payroll Setups (ID 51165).
/// </summary>
table 51165 "Payroll Setups"
{
    // LookupPageID = 50150;

    fields
    {
        field(1; "Payroll Code"; Code[10])
        {
            TableRelation = Payroll;
        }
        field(2; "NSSF ED Code"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(3; "NSSF Company Contribution"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(4; "NHIF ED Code"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(5; "Mid Month ED Code"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(6; "PAYE ED Code"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(10; "Payroll Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payroll Template"));
        }
        field(11; "Payroll Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
            //TableRelation = "Gen. Journal Template".Name;
        }
        field(12; "Employer PIN No."; Code[20])
        {
        }
        field(13; "Employer NSSF No."; Code[20])
        {
        }
        field(14; "Employer NHIF No."; Code[20])
        {
        }
        field(15; "Employer LASC No."; Code[20])
        {
        }
        field(16; "Employer Name"; Text[50])
        {
        }
        field(17; "Loan Payments Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Template"));
        }
        field(18; "Loan Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(19; "Loan Losses Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Template"));
        }
        field(20; "Basic Pay E/D Code"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(21; "Daily Rate Rounding"; Option)
        {
            InitValue = Nearest;
            OptionMembers = "None",Up,Down,Nearest;
        }
        field(22; "Hourly Rate Rounding"; Option)
        {
            InitValue = Nearest;
            OptionMembers = "None",Up,Down,Nearest;
        }
        field(23; "Hourly Rounding Precision"; Decimal)
        {
            InitValue = 0.5;
            MinValue = 0.1;
        }
        field(24; "Daily Rounding Precision"; Decimal)
        {
            InitValue = 0.5;
            MinValue = 0.1;
        }
        field(25; "Bank Account No"; Code[10])
        {
            Numeric = true;
        }
        field(26; "Payroll Transfer Path"; Text[50])
        {
            Description = 'Enter the Payroll Transfer Destination Path without the file name';
        }
        field(27; "Pension ED Code"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(28; "Pension Company Contribution"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(29; "Pension Lumpsom Contribution"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(30; "Interest Benefit"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(31; "Standard Hours"; Decimal)
        {
        }
        field(32; "Standard Days"; Decimal)
        {
        }
        field(33; "Branch Code"; Code[10])
        {
            Enabled = false;
        }
        field(34; "Overdrawn ED"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(35; "Employers Address"; Text[30])
        {
        }
        field(36; "Income Brackets Rate"; Code[20])
        {
            TableRelation = "Lookup Table Header";
        }
        field(37; "Net Pay Rounding B/F"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(38; "Net Pay Rounding C/F"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(39; "Net Pay Rounding B/F (-Ve)"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(40; "Net Pay Rounding C/F (-ve)"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(41; Path; Text[30])
        {
            Enabled = false;
        }
        field(42; "Net Pay Rounding Precision"; Integer)
        {
        }
        field(43; "Net Pay Rounding Mid Amount"; Integer)
        {
            Description = 'Net Pay Rounding Middle Amount to round up or down';

            trigger OnValidate()
            begin
                IF "Net Pay Rounding Mid Amount" > "Net Pay Rounding Precision" THEN
                    ERROR('Net Pay Rounding Min Amount should be less than Net Pay Rounding Precision.')
            end;
        }
        field(44; "Tax on Lump Sum ED"; Code[20])
        {
            TableRelation = "ED Definitions"."ED Code" WHERE("Calculation Group" = CONST(Deduction),
                                                              "System Created" = CONST(TRUE));
        }
        field(45; "Insert Special Payments"; Boolean)
        {
        }
        field(46; "Payroll Company Code"; Code[3])
        {
        }
        field(48; "Priority to Dims Assigned To"; Option)
        {
            Description = 'Give priority to dimensions assigned to';
            OptionMembers = Employee,ED;
        }
        field(49; "Auto-Post Payroll Journals"; Boolean)
        {
        }
        field(50; "Payslips Folder"; Text[200])
        {
            Description = 'Folder into which payslips for employees with e-mail addresses are saved.';
        }
        field(51; "Email Subject"; Text[250])
        {
            Description = 'Subject of the payslip Emails';
        }
        field(52; "Email Body"; Text[250])
        {
            Description = 'Body of the payslip Emails';
        }
        field(53; "Email Footer Line 1"; Text[100])
        {
            Description = 'e.g Regards,';
        }
        field(54; "Email Footer Line 2"; Text[100])
        {
            Description = 'e.g For Company XYZ Ltd.';
        }
        field(55; "Email Footer Line 3"; Text[100])
        {
            Description = 'e.g HR Manager';
        }
        field(56; "Email Footer Line 4"; Text[100])
        {
        }
        field(57; "Email Footer Line 5"; Text[100])
        {
        }
        field(58; "Payslips Folder No Email"; Text[200])
        {
            Description = 'Folder into which payslips for employees without Email Addresses are saved';
        }
        field(59; "Bank Code"; Code[20])
        {
            TableRelation = "Employee Bank Account";

            trigger OnValidate()
            var
                rEmpBankAccount: Record "Employee Bank Account";
            begin
            end;
        }
        field(60; "Attendance Time Register Code"; Code[10])
        {
            TableRelation = "Cause of Absence";
        }
        field(61; "Overtime Time Register Code"; Code[10])
        {
            TableRelation = "Cause of Absence";
        }
        field(62; "Absence Time Register Code"; Code[10])
        {
            TableRelation = "Cause of Absence";
        }
        field(63; "CBS Brackets"; Code[20])
        {
            TableRelation = "Lookup Table Header";
        }
        field(64; "KRA Tax Logo"; BLOB)
        {
            Description = 'used P10D';
            SubType = Bitmap;
        }
        field(65; "File Extension"; Text[5])
        {
        }
        field(66; "Employer HELB No."; Code[20])
        {
        }
        field(67; "Insurance Relief ED"; Text[100])
        {
            TableRelation = "ED Definitions"."ED Code";
        }
        field(68; "Rent Recovery ED"; Text[100])
        {
            TableRelation = "ED Definitions"."ED Code";
        }
        field(69; "Payroll Expense Based On"; Option)
        {
            OptionCaption = ' ,Default,Month';
            OptionMembers = " ",Default,Month;
        }
        field(50001; "Tax Calculation"; Option)
        {
            OptionCaption = 'Kenya,Ethiopia';
            OptionMembers = Kenya,Ethiopia;
        }
        field(50002; "Bonuses Exist"; Boolean)
        {
        }
        field(50003; "House Allowances ED"; Code[20])
        {
            TableRelation = "ED Definitions"."ED Code";
        }
        field(50004; "Commuter Allowance ED"; Code[20])
        {
            TableRelation = "ED Definitions"."ED Code";
        }
        field(50005; "Lost Hours Registration Type"; Code[20])
        {
            TableRelation = "Cause of Absence";
        }
        field(50006; "Leave Travel Allowance ED"; Code[10])
        {
            Description = 'Added for select LTA ED';
            TableRelation = "ED Definitions";
        }
        field(50007; "Leave Advance Payment ED"; Code[10])
        {
            Description = 'Added for select LTP ED';
            TableRelation = "ED Definitions";
        }
        field(50008; "Leave Advance Loan"; Code[10])
        {
            Description = 'Added for select LA Loan';
            TableRelation = "Loan Types";
        }
        field(50009; "Normal OT ED"; Code[10])
        {
            Description = 'Added for OT calculation Grade Wise Normal - GJ';
            TableRelation = "ED Definitions";
        }
        field(50010; "Weekend OT ED"; Code[10])
        {
            Description = 'Added for OT calculation Grade Wise Weekend - GJ';
            TableRelation = "ED Definitions";
        }
        field(50011; "Holiday OT ED"; Code[10])
        {
            Description = 'Added for OT calculation Grade Wise Holiday - GJ';
            TableRelation = "ED Definitions";
        }
        field(50012; "Personal Account Recoveries ED"; Code[10])
        {
            Description = 'Added for Select the PA Recoveries ED';
            TableRelation = "ED Definitions";
        }
        field(50013; "Make Personal A/C Recoveries"; Boolean)
        {
            Description = 'Added for P A/C Recoveries';
        }
        field(50014; "% of Basic Pay to Advance"; Decimal)
        {
            Description = 'GJ_ODCII_PMC_021110';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50015; "Default Cause of Absence"; Code[20])
        {
            Description = 'The registration type that is inserted in time registration ''suggest emp. attendance'' if day is non-working';
            TableRelation = "Cause of Absence";
        }
        field(50016; "Emp ID in Payroll Posting Jnl"; Boolean)
        {
            Description = 'allows the employee ID to be included in description of payroll posting';
        }
        field(50017; "Retirement Age"; Decimal)
        {
            Description = 'JNG ODC PAY8 20120829';
        }
        field(50018; "Itemize Personal Recoveries"; Boolean)
        {
            Description = 'EMO ODC PAY14 29082012';
        }
        field(50019; "Max Donations Per Month"; Integer)
        {
            Description = 'EMO ODC PAY 21 14092012';
        }
        field(50020; "Donation ED Code"; Code[20])
        {
            Description = 'EMO ODC PAY 21 14092012';
            TableRelation = "ED Definitions"."ED Code";
        }
        field(50021; "Recover Loan Outside Payroll"; Boolean)
        {
            Description = 'JNG ODC PAY25 20120925';
        }
        field(50022; "Recover Interest on Repayments"; Boolean)
        {
            Description = 'JNG ODC PAY25 20120925';
        }
        field(50023; "Leave Encashed ED"; Code[10])
        {
            Description = 'Added for select LTA ED';
            TableRelation = "ED Definitions";
        }
        field(50024; "Payroll Cut Off Date"; Integer)
        {
        }
        field(50026; "Leave Lost Day Recovered ED"; Code[10])
        {
            TableRelation = "ED Definitions";
        }
        field(50027; "NSSF Voluntary ED Code"; Code[20])
        {
            Description = 'JNG PAY4 20130228';
            TableRelation = "ED Definitions";
        }
        field(50028; "House Benefit ED"; Code[20])
        {
            TableRelation = "ED Definitions";
        }
        field(50029; "% House Benefit on Basic Pay"; Decimal)
        {
        }
        field(50030; "Print Retire Age On Payslip"; Boolean)
        {
            Description = 'JNG PAY 7';
        }
        field(50031; "Allow TR Entries After Payroll"; Boolean)
        {
            Description = 'JNG TR26 20130222';
        }
        field(50032; "Default Employee Posting Group"; Code[20])
        {
            TableRelation = "Employee Posting Groups";
        }
        field(50033; "Payroll Base Currency"; Code[20])
        {
            TableRelation = Currency;
        }
        field(50034; "Payslip Message Footer"; Text[100])
        {
        }
        field(50035; "Retirements Age"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "LAPTRUST Employee ED Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ED Definitions";
        }
        field(50037; "LAPTRUST Employer ED Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ED Definitions";
        }
        field(50038; "Normal OT Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Holiday OT Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Weekend OT Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Subsistence ED"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Added for OT calculation Grade Wise Normal - GJ';
            TableRelation = "ED Definitions";
        }
        field(50042; "Overtime ED"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Added for OT calculation Grade Wise Weekend - GJ';
            TableRelation = "ED Definitions";
        }
        field(50043; "Gratuity Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'GJ_ODCII_PMC_021110';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50044; "Gratuity Tax Exempt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Gratuity Tax Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "Payroll Run Days"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50047; "Payroll Verification Days"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50048; "Payroll Transfer Days"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Gratuity Journal Template"; Code[10])
        {
            Caption = 'Gratuity Journal Template';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(50051; "Gratuity Journal Batch"; Code[10])
        {
            Caption = 'Gratuity Journal Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Gratuity Journal Template"));
        }
        field(50052; "Gratuity Expense GL"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50053; "Gratuity Liability GL"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50054; "GratuityTax GL"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Payroll Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Payroll Code" = '' THEN "Payroll Code" := gvPayrollUtilities.gsAssignPayrollCode; //SNG 130611 payroll data segregation
    end;

    var
        gvPayrollUtilities: Codeunit "Payroll Posting";
        Text001: Label 'Replace existing attachment?';
        Text002: Label 'You have canceled the import process.';
        Text006: Label 'Import Attachment';
        Text007: Label 'All Files (*.*)|*.*';
        Text008: Label 'Error during copying file.';
        FileMgt: Codeunit "File Management";
        TableCodeTransfer: Codeunit 51154;

    procedure Import()
    begin
        TableCodeTransfer.PaySetupImport(Rec);
    end;

    procedure ImportAttachment(ImportFromFile: Text[260]; IsTemporary: Boolean; IsInherited: Boolean): Boolean
    var
        FileName: Text[260];
        AttachmentManagement: Codeunit AttachmentManagement;
        ClientFileName: Text[260];
        NewAttachmentNo: Integer;
        // BLOBRef: Record 99008535;
        RBAutoMgt: Codeunit 419;
        ServerFileName: Text[260];
    begin
        EXIT(TableCodeTransfer.PaySetupImportAttachment(Rec, ImportFromFile, IsTemporary, IsInherited));
    end;

    procedure ExportAttachment(ExportToFile: Text[1024]): Boolean
    var
        // BLOBRef: Record 99008535;
        RBAutoMgt: Codeunit 419;
        FileName: Text[1024];
        FileFilter: Text[260];
        ClientFileName: Text[1024];
    begin
        EXIT(TableCodeTransfer.PaySetupExportAttachment(Rec, ExportToFile));
    end;

    procedure RemoveAttachment(Prompt: Boolean)
    begin
        TableCodeTransfer.PaySetupRemoveAttachment(Rec, Prompt);
    end;

    procedure DeleteFile(FileName: Text[260]): Boolean
    var
        I: Integer;
    begin
        EXIT(TableCodeTransfer.PaySetupDeleteFile(FileName));
    end;
}


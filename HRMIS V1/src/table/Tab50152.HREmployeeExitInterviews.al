/// <summary>
/// Table HR Employee Exit Interviews (ID 50152).
/// </summary>
table 50152 "HR Employee Exit Interviews"
{

    fields
    {
        field(1; "Exit Interview No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Date Of Interview"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Interview Done By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                HREmp.RESET;
                HREmp.SETRANGE(HREmp."No.", "Interview Done By");
                IF HREmp.FIND('-') THEN BEGIN
                    IntFullName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Interviewer Name" := IntFullName;
                END;
            end;
        }
        field(4; "Re Employ In Future"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Yes,No;
        }
        field(5; "Grounds for Term. Code"; Code[30])
        {
            Caption = 'Grounds for Term. Code';
            DataClassification = ToBeClassified;
            TableRelation = "Grounds for Termination".Code;
        }
        field(6; "Reason For Leaving (Other)"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Date Of Separation"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                "Employement Years of Service" := Dates.DetermineAge_Years("Employement Date", "Date Of Separation");
            end;
        }
        field(10; Comment; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                "Employee Name" := '';
                "National ID No." := '';
                "Passport No." := '';
                "Employement Date" := 0D;
                "HR Job Title" := '';
                "Global Dimension 1 Code" := '';
                "Global Dimension 2 Code" := '';
                "Supervisor Job No." := '';
                "Supervisor Job Title" := '';

                HREmp.RESET;
                HREmp.SETRANGE(HREmp."No.", "Employee No.");
                IF HREmp.FIND('-') THEN BEGIN
                    EmpFullName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Employee Name" := EmpFullName;
                    "National ID No." := HREmp."National ID No.-d";
                    //"Passport No." := HREmp."Passport No.-d";
                    "Employement Date" := HREmp."Employment Date";
                    "HR Job Title" := HREmp.Title;
                    "Global Dimension 1 Code" := HREmp."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := HREmp."Global Dimension 2 Code";
                    "Supervisor Job No." := HREmp."Supervisor Job No.";
                    "Supervisor Job Title" := HREmp."Supervisor Job Title";
                END;
            end;
        }
        field(12; "No Series"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Clearance Form Submitted"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                HREmp.RESET;
                HREmp.SETRANGE("No.", "Employee No.");
                OK := HREmp.FIND('-');

                IF "Clearance Form Submitted" = TRUE THEN BEGIN

                    IF OK THEN BEGIN
                        HREmp.Status := HREmp.Status::Inactive;
                        HREmp."Termination Date" := "Date Of Separation";
                        HREmp."Grounds for Term. Code" := "Grounds for Term. Code";
                        HREmp.MODIFY;
                    END
                END;

                IF "Clearance Form Submitted" = FALSE THEN BEGIN
                    IF OK THEN BEGIN
                        HREmp.Status := HREmp.Status::Active;
                        HREmp."Termination Date" := 0D;
                        HREmp."Grounds for Term. Code" := '';
                        HREmp.MODIFY;
                    END;
                END;
            end;
        }
        field(14; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(15; "Employee Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Interviewer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(18; "National ID No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Passport No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Employement Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "HR Job Title"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Pension Provider"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Pension Letter Recipient Name"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Pension Provider Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = '"Global Dimension 1 Code"';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(27; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                Vendors.RESET;
                Vendors.SETRANGE("No.", "Vendor No.");
                IF Vendors.FINDFIRST THEN BEGIN
                    "Pension Provider" := Vendors.Name;
                    "Pension Letter Recipient Name" := Vendors.Contact;
                    "Pension Provider Address" := Vendors.Address;
                END;
            end;
        }
        field(28; "Supervisor Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Supervisor Job Title"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Employement Years of Service"; Text[50])
        {
            Caption = 'Employment Years of Service';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(62; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(63; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(64; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(65; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(66; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(67; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
    }

    keys
    {
        key(Key1; "Exit Interview No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        //GENERATE NEW NUMBER FOR THE DOCUMENT
        IF "Exit Interview No" = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Exit Interview Nos");
            //NoSeriesMgt.InitSeries(HRSetup."Exit Interview Nos", xRec."No Series", 0D, "Exit Interview No", "No Series");
        END;
    end;

    var
        CareerEvent: Page 5218;
        OK: Boolean;
        HREmp: Record 5200;
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmpFullName: Text;
        IntFullName: Text;
        Vendors: Record 23;
        Dates: Codeunit 50043;
}


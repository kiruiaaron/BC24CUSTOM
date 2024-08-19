table 50035 "Document Reversal Line"
{

    fields
    {
        field(9; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,Receipt,Imprest,Imprest Surrender,Funds Transfer,Funds Claim';
            OptionMembers = " ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Transfer","Funds Claim";

            trigger OnValidate()
            begin
                "Document No." := '';
                "Doc. Posting date" := 0D;
                Description := '';
                Amount := 0;
                "Amount (LCY)" := 0;
            end;
        }
        field(12; "Document No.";
        Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Doc. Posting date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; Description; Text[150])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(18; "Reversal Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Reversal Posted By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Reversal Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "User ID"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(25; "Account No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26; "Account Name"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(51; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
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
        key(Key1; "Line No.", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            FundsSetup.GET;
            FundsSetup.TESTFIELD(FundsSetup."Reversal Header");
            NoSeriesMgt.InitSeries(FundsSetup."Reversal Header", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        "Document Date" := TODAY;
        "User ID" := USERID;
    end;

    var
        FundsClaimHeader: Record 50012;
        ReceiptHeader: Record 50004;
        PaymentHeader: Record 50002;
        ImprestHeader: Record 50008;
        ImprestSurrenderHeader: Record 50010;
        GLEntry: Record 17;
        Customer: Record 18;
        Vendor: Record 23;
        Employee: Record 5200;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FundsSetup: Record 50031;
}


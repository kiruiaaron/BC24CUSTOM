table 50016 "Journal Voucher Header"
{
    DrillDownPageID = 50379;
    LookupPageID = 50379;

    fields
    {
        field(10; "JV No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "User ID"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;

            trigger OnValidate()
            begin
                /*IF Rec.Status = Rec.Status::Approved THEN BEGIN
                  IF FundsUserSetup.GET(USERID) THEN BEGIN
                  FundsUserSetup.TESTFIELD(FundsUserSetup."JV Template");
                  FundsUserSetup.TESTFIELD(FundsUserSetup."JV Batch");
                  JTemplate:=FundsUserSetup."JV Template";JBatch:=FundsUserSetup."JV Batch";
                  FundsManagement.PostJournalVoucher(Rec,JTemplate,JBatch,FALSE);
                 END;
                END;*/

            end;
        }
        field(16; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "JV Lines Cont"; Integer)
        {
            CalcFormula = Count("Journal Voucher Lines" WHERE("JV No." = FIELD("JV No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Journal Voucher Lines".Amount WHERE(Amount = FILTER(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Time Posted"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Posted By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(28; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Reversal Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Reversal Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Reversed By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "JV No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "JV No." = '' THEN BEGIN
            FundsSetup.GET;
            FundsSetup.TESTFIELD(FundsSetup."JV Nos.");
            NoSeriesMgt.InitSeries(FundsSetup."JV Nos.", xRec."No. Series", 0D, "JV No.", "No. Series");
        END;

        "Document date" := TODAY;
        "User ID" := USERID;
        "Posting Date" := TODAY;
        VALIDATE("User ID");
    end;

    var
        FundsSetup: Record 50031;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FundsUserSetup: Record 50029;
        FundsManagement: Codeunit 50045;
        JTemplate: Code[30];
        JBatch: Code[30];
}


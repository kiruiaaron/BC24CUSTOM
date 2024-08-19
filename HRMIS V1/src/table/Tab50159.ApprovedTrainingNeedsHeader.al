table 50159 "Approved Training Needs Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Calendar Year"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Calendar Period".Code;
        }
        field(4; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
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
        //GENERATE NEW NUMBER FOR THE DOCUMENT
        IF "No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Approved Training Nos");
            //NoSeriesMgt.InitSeries(HRSetup."Approved Training Nos", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        "Document Date" := TODAY;
        "User ID" := USERID;
    end;

    var
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}


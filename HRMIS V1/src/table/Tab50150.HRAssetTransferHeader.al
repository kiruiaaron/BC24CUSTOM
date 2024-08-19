table 50150 "HR Asset Transfer Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Document Date"; Date)
        {
        }
        field(3; "Date Requested"; Date)
        {
        }
        field(4; "Transfer Reason"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Canceled';
            OptionMembers = Open,"Pending Approval",Approved,Canceled;
        }
        field(11; "Transfer Effected"; Boolean)
        {
        }
        field(12; "Date Transfered"; Date)
        {
        }
        field(13; "Transfered By"; Code[50])
        {
        }
        field(14; "Time Posted"; Time)
        {
        }
        field(15; "User ID"; Code[50])
        {
            Editable = false;
        }
        field(16; "Responsibility Center"; Code[50])
        {
        }
        field(30; "No. Series"; Code[20])
        {
        }
        field(31; "Activity Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Asset Transfer,Asset Surrender,Maintenance';
            OptionMembers = " ","Asset Transfer","Asset Surrender",Maintenance;
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
        IF "No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Asset Transfer No.");
            //NoSeriesMgt.InitSeries(HRSetup."Asset Transfer No.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        "Date Requested" := TODAY;
        "Document Date" := TODAY;
        "User ID" := USERID;
    end;

    var
        FASetup: Record 5603;
        Employees: Record 5200;
        FA: Record 5600;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimensionValue: Record 349;
        HRSetup: Record 5218;
}


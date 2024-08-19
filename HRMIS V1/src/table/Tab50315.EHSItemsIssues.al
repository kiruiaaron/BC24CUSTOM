table 50315 "EHS Items Issues"
{

    fields
    {
        field(1; "Issue No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Item issued Details"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(43; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(44; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Document Path"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Claim Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(47; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Store Requisition No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Issue By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Issue No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Issue No" = '' THEN BEGIN

            HRSetup.GET;
            // HRSetup.TESTFIELD(HRSetup."EHS Issue Nos");
            // //NoSeriesMgt.InitSeries(HRSetup."EHS Issue Nos",xRec."No. Series",0D,"Issue No","No. Series");


        END;
    end;

    var
        Employee: Record 5200;
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}


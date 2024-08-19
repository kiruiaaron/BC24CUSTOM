table 50268 "Induction Program"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Created by"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        HumanResourcesSetupRec.GET;
        IF Code = '' THEN BEGIN
            //  HumanResourcesSetupRec.TESTFIELD("Induction Nos.");
            //  //NoSeriesMgt.InitSeries(HumanResourcesSetupRec."Induction Nos.",xRec."No. Series",0D,Code,"No. Series");
        END;
        "Created by" := USERID;
    end;

    var
        HumanResourcesSetupRec: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}


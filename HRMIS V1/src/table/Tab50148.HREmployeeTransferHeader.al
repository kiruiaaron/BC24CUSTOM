table 50148 "HR Employee Transfer Header"
{

    fields
    {
        field(1; "Request No"; Code[50])
        {

            trigger OnValidate()
            begin
                IF "Request No" <> xRec."Request No" THEN BEGIN
                    hrsetup.GET;
                    //   NoSeriesMgt.TestManual(hrsetup."Employee Transfer Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Date Requested"; Date)
        {
        }
        field(3; "Date Approved"; Date)
        {
        }
        field(4; "Reason For Transfer"; Text[100])
        {
            DataClassification = ToBeClassified;
            Enabled = true;
        }
        field(7; "Transfer details Updated"; Boolean)
        {
        }
        field(10; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Cancelled';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Cancelled;
        }
        field(20; "No. Series"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Request No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Request No" = '' THEN BEGIN
            hrsetup.GET;
            hrsetup.TESTFIELD(hrsetup."Employee Transfer Nos.");
            //NoSeriesMgt.InitSeries(hrsetup."Employee Transfer Nos.", xRec."No. Series", 0D, "Request No", "No. Series");
            "Date Requested" := TODAY;
        END;
    end;

    var
        hrsetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Employees: Record Employee;
}


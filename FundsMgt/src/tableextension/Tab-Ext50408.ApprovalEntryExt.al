tableextension 50408 "Approval Entry Ext." extends "Approval Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Web Portal Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136923; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52136924; "Document Source"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52136925; Document_Type; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52136926; "Rejection Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52136927; "Record Opened"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
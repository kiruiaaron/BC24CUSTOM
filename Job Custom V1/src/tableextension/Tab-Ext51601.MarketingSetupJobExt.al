tableextension 51601 "Marketing Setup Job Ext" extends "Marketing Setup"
{
    fields
    {
        field(50000; "Creative Brief No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50001; "Opening Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Closing Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Default Customer Template"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Templ.";
        }
    }
}

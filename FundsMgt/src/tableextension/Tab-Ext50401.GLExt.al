
tableextension 50401 "GL Ext" extends "G/L Account"
{
    fields
    {
        field(50000; "Budget Controlled"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Electricity Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

}
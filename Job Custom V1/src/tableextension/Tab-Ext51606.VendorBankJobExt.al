tableextension 51606 "Vendor Bank Job Ext" extends "Vendor Bank Account"
{
    fields
    {
        field(53001; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(53002; "Branch Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(53005; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(53006; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(53007; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

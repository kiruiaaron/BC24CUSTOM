/// <summary>
/// Table HR Mandatory Doc. Checklist (ID 50112).
/// </summary>
table 50112 "HR Mandatory Doc. Checklist"
{
    Caption = 'HR Mandatory Documents Checklist';

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Document No.";
        Code[20])
        {
        }
        field(3; "Mandatory Doc. Code"; Code[50])
        {
            Caption = 'Mandatory Document Document Code';
            TableRelation = "HR Job Lookup Value".Code WHERE(Code = FIELD("Mandatory Doc. Code"),
                                                              Option = CONST("Checklist Item"));

            trigger OnValidate()
            begin
                HRJobLookupValue.RESET;
                HRJobLookupValue.SETRANGE(HRJobLookupValue.Code, "Mandatory Doc. Code");
                IF HRJobLookupValue.FINDFIRST THEN BEGIN
                    "Mandatory Doc. Description" := HRJobLookupValue.Description;
                END;
            end;
        }
        field(4; "Mandatory Doc. Description"; Text[250])
        {
            Caption = 'Mandatory Document Description';
        }
        field(5; "Document Attached"; Boolean)
        {
            Enabled = false;
        }
        field(20; "Local File URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "SharePoint URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.", "Mandatory Doc. Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRJobLookupValue: Record 50097;
}


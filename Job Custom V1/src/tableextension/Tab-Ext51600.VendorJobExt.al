tableextension 51600 "Vendor Job Ext" extends vendor
{
    fields
    {
        field(51601; "Vendor Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Trade,Director,Sub-Contractor';
            OptionMembers = Trade,Director,"Sub-Contractor";
        }
        field(51602; "Default Daily Rate BA"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51603; "Default Daily Rate TL"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51604; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange("Project Code", "Project Code");
                if Vend.FindSet then
                    Error('The subcontract category %1 for this project %2 already exists', Vend."No.", "Project Code");
                JobsRec.Reset;
                JobsRec.SetRange("No.", "Project Code");
                if JobsRec.FindSet then begin
                    "Project Name" := JobsRec.Description;
                end;
            end;
        }
        field(51605; "Project Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(51606; "Default Daily Rate DJ"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51607; "Default Daily Rate MC"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51608; "Default Daily Rate Ushers"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51609; "Default Daily Rate Supervisors"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51610; "Default Daily Rate Models"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51611; "Default Daily Rate Mixologist"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51612; "Default Daily Rate Dancers"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51613; "Task No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            begin
                JobsRec.Reset;
                JobsRec.SetRange("No.", "Project Code");
                if JobsRec.FindSet then begin
                    "Project Name" := JobsRec.Description;
                end;
            end;
        }
        field(51614; "Task Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        JobsRec: Record Job;
        Vend: Record Vendor;
}

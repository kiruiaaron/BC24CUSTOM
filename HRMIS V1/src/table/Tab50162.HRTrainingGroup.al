/// <summary>
/// Table HR Training Group (ID 50162).
/// </summary>
table 50162 "HR Training Group"
{

    fields
    {
        field(1; "Training Group App. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Training Group Name"; Text[100])
        {
        }
        field(3; "Training Needs No."; Code[20])
        {
            TableRelation = "HR Training Needs Line";

            trigger OnValidate()
            begin
                /*TrainingNeeds.RESET;
                TrainingNeeds.SETRANGE("No.","Training Needs No.");
                IF TrainingNeeds.FINDFIRST THEN
                  "Training Needs Description":=TrainingNeeds."Line No.";*/

            end;
        }
        field(4; "Training Needs Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Total Estimated Cost"; Decimal)
        {
            CalcFormula = Sum("HR Training Group Participants"."Estimated Cost" WHERE("Training Group No." = FIELD("Training Group App. No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Development Need"; Text[100])
        {
            Caption = 'Training Group Development Need';
            DataClassification = ToBeClassified;
        }
        field(7; Objective; Text[100])
        {
            Caption = 'Training Objective';
            DataClassification = ToBeClassified;
        }
        field(8; "Proposed Training Provider"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Training Location"; Text[100])
        {
            Caption = 'Training Location & Venue';
            DataClassification = ToBeClassified;
        }
        field(10; "Proposed Period"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Q1,Q2,Q3,Q4;
        }
        field(11; "From Date"; Date)
        {
            Caption = 'Training scheduled Date From ';
            DataClassification = ToBeClassified;
        }
        field(12; "To Date"; Date)
        {
            Caption = 'Training scheduled Date To ';
            DataClassification = ToBeClassified;
        }
        field(13; "Calendar Year"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Calendar Period".Code;
        }
        field(14; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(20; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(99; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
    }

    keys
    {
        key(Key1; "Training Group App. No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Training Group App. No.", "Training Group Name")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Training Group App. No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Training Group Nos");
            //NoSeriesMgt.InitSeries(HRSetup."Training Group Nos", xRec."No. Series", 0D, "Training Group App. No.", "No. Series");
        END;
        "User ID" := USERID;
    end;

    var
        HRSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;

        TrainingNeeds: Record 50158;
        Employees: Record 5200;
}


table 50335 "Probation Final Review"
{

    fields
    {
        field(1; "Review No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Final Review Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Performance Summary"; Text[250])
        {
            Caption = 'Performance/Progress Summary';
            DataClassification = ToBeClassified;
        }
        field(4; "Objectives Met?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Training Need Addressed?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Training Need Action"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Training Need Review Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Objectives Met Action"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Objective Met Review Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Appointment to be Confirmed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Reasons For Not Confirming"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Employee Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Extend Probation Period"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Reason For Extension"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Length Of Extension"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "New Probation End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Confirmation Letter Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Reason Objective Not Met"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Reason Training Not Met"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Signatory Employee"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                IF EmployeeRec.GET("Signatory Employee") THEN BEGIN
                    "Signatory Employee Name" := EmployeeRec.FullName;
                    "Signatory Employee Title" := EmployeeRec."Job Title";

                END;
            end;
        }
        field(21; "Signatory Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Signatory Employee Title"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Review No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EmployeeRec: Record 5200;
}


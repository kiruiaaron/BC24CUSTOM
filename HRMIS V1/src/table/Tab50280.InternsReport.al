table 50280 "Interns Report"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[200])
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
        field(12; Quarter; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'QTR 1,QTR 2,QTR 3,QTR 4';
            OptionMembers = "QTR 1","QTR 2","QTR 3","QTR 4";
        }
        field(14; "Document Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Minutes,Papers';
            OptionMembers = Minutes,Papers;
        }
        field(16; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Recommendations 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Recommendations 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Recommendations 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Intern No"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Intern name" := '';

                IF Employee.GET("Intern No") THEN BEGIN
                    "Intern name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    Designation := Employee."Job Title";
                END;
            end;
        }
        field(21; "Intern name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Designation; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Current Stage"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Employee,HOS,HOD,HR,MD';
            OptionMembers = Employee,HOS,HOD,HR,MD;
        }
        field(59; "HOS Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "HOD Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "HR Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HumanResourcesSetupRec: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Employee: Record 5200;
}


/// <summary>
/// Table HR Medical Scheme Members (ID 50155).
/// </summary>
table 50155 "HR Medical Scheme Members"
{

    fields
    {
        field(10; "Line No"; Integer)
        {
            Editable = false;
        }
        field(11; "Scheme No"; Code[30])
        {
        }
        field(12; "Employee No"; Code[30])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF Employees.GET("Employee No") THEN BEGIN
                    "Employee Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name";
                    "Principal No" := Employees."No.";
                END;
            end;
        }
        field(13; "Employee Name"; Text[100])
        {
        }
        field(14; "Medical Scheme Description"; Text[100])
        {
        }
        field(15; "Family Size"; Code[20])
        {
        }
        field(16; "Cover Option"; Option)
        {
            OptionCaption = ' ,Principal,Dependant';
            OptionMembers = " ",Principal,Dependant;
        }
        field(17; "In Patient Benfit"; Decimal)
        {
        }
        field(18; "Out patient Benefit"; Decimal)
        {
        }
        field(19; Status; Option)
        {
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
        field(20; "Principal No"; Code[30])
        {
        }
        field(21; "Dependant Name"; Text[100])
        {

            trigger OnValidate()
            begin
                /*HREmployeeRelative.RESET;
                HREmployeeRelative.SETRANGE();*/

            end;
        }
        field(22; "Date of Birth"; Date)
        {
        }
        field(23; Age; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(24; Relation; Code[20])
        {
        }
        field(25; Category; Code[10])
        {
            TableRelation = "Medical Cover Setup";

            trigger OnValidate()
            begin

                IF MedicalSetup.GET(Relation) THEN BEGIN
                    "In Patient Benfit" := MedicalSetup."In-Patient Amount";
                    "Out patient Benefit" := MedicalSetup."Out-Patient Amount";
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Line No", "Scheme No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employees: Record 5200;
        MedicalSetup: Record 50156;
        HREmployeeRelative: Record 50115;
}


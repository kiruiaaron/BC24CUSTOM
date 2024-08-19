table 50328 "Probation Review"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF EmployeeRec.GET("Employee No.") THEN BEGIN
                    "Employee Name" := EmployeeRec.FullName;
                    VALIDATE("Department/Section", EmployeeRec."Shortcut Dimension 3 Code");
                    "Post Start Date" := EmployeeRec."Contract Start Date";
                    VALIDATE("Line Manager", EmployeeRec."Manager No.");
                END;
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Grade; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Department/Section"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                "Department Name" := '';
                DimensionValueRec.RESET;
                DimensionValueRec.SETRANGE(Code, "Department/Section");
                IF DimensionValueRec.FINDFIRST THEN
                    "Department Name" := DimensionValueRec.Name;
            end;
        }
        field(7; "Department Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Post Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Line Manager"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF EmployeeRec.GET("Line Manager") THEN
                    "Line Manager Name" := EmployeeRec.FullName;
            end;
        }
        field(10; "Line Manager Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Review Stage"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Initial Meeting,3-Month Review,6-Month Review,Closed';
            OptionMembers = " ","Initial Meeting","3-Month Review","6-Month Review",Closed;
        }
        field(12; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            HumanResourcesSetup.GET;
            //  HumanResourcesSetup.TESTFIELD("Probation Nos");
            //  NoSeriesManagement.InitSeries(HumanResourcesSetup."Probation Nos",xRec."No. Series",TODAY,"No.","No. Series");
        END;
        "Document Date" := TODAY;
    end;

    var
        HumanResourcesSetup: Record 5218;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        EmployeeRec: Record 5200;
        DimensionValueRec: Record 349;
}


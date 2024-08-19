table 50274 "Transfer Request"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Reason; Text[30])
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
        field(40; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                //

                "Employee Name" := '';

                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    Employee.TESTFIELD(Employee."Imprest Posting Group");
                    //"Employee Posting Group":=Employee."Imprest Posting Group";
                    // "Job Grade" := Employee."Salary Scale";
                    "Phone No." := Employee."Mobile Phone No.";
                    VALIDATE("Global Dimension 1 Code", Employee."Global Dimension 1 Code");
                    VALIDATE("Global Dimension 2 Code", Employee."Global Dimension 2 Code");
                    VALIDATE("Shortcut Dimension 3 Code", Employee."Shortcut Dimension 3 Code");
                    Designation := Employee."Job Title";
                END;
            end;
        }
        field(41; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "Global Dimension 1 Code");
                IF DimensionValue.FINDFIRST THEN
                    Department := DimensionValue.Name;
            end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "Global Dimension 2 Code");
                IF DimensionValue.FINDFIRST THEN
                    Station := DimensionValue.Name;
            end;
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "Shortcut Dimension 3 Code");
                IF DimensionValue.FINDFIRST THEN
                    Section := DimensionValue.Name;
            end;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Posted,Reversed';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Posted,Reversed;
        }
        field(103; "Phone No."; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(105; "Job Grade"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(106; "Forward To"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'HOD,MD';
            OptionMembers = HOD,MD;
        }
        field(107; Department; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(108; Station; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(109; Section; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(110; Designation; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        HumanResourcesSetupRec.GET;
        IF Code = '' THEN BEGIN
            //   HumanResourcesSetupRec.TESTFIELD("Transfer Request Nos.");
            //  //NoSeriesMgt.InitSeries(HumanResourcesSetupRec."Transfer Request Nos.",xRec."No. Series",0D,Code,"No. Series");
        END;
        "Created by" := USERID;
    end;

    var
        HumanResourcesSetupRec: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Employee: Record 5200;
        DimensionValue: Record 349;
}


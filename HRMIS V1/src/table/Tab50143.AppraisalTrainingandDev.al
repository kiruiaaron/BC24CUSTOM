table 50143 "Appraisal Training and Dev"
{

    fields
    {
        field(1; "Appraisal No."; Code[20])
        {
            Caption = 'Appraisal No.';
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(4; "Employee Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Area of Development"; Text[250])
        {
            Caption = 'Area of Development';
        }
        field(6; "Agreed Improv Action plan"; Text[250])
        {
            Caption = 'Agreed Improvement Action plan';
        }
        field(7; Resposibility; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Appraisal Period"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Appraisal No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        EmployeeAppraisalHeader.RESET;
        EmployeeAppraisalHeader.SETRANGE(EmployeeAppraisalHeader."No.", "Appraisal No.");
        IF EmployeeAppraisalHeader.FINDFIRST THEN BEGIN
            "Employee No." := EmployeeAppraisalHeader."Employee No.";
            "Employee Name" := EmployeeAppraisalHeader."Employee Name";
            "Appraisal Period" := EmployeeAppraisalHeader."Appraisal Period";
        END;
    end;

    var
        EmployeeAppraisalHeader: Record 50138;
}


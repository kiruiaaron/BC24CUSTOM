/// <summary>
/// Table Interview Attendance Header (ID 50108).
/// </summary>
table 50108 "Interview Attendance Header"
{

    fields
    {
        field(10; "Interview No"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
        }
        field(11; "Interview Committee code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Interview Committee Dep Header"."Department Code";

            trigger OnValidate()
            begin
                "Interview Committee Name" := '';
                IntCommitteeHeader.RESET;
                IntCommitteeHeader.SETRANGE("Department Code", "Interview Committee code");
                IF IntCommitteeHeader.FINDFIRST THEN
                    "Interview Committee Name" := IntCommitteeHeader."Dept Committee Name";
                EmployeeRecruitment.LoadInterviewPanelFromCommittee(Rec);
            end;
        }
        field(12; "Interview Committee Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Interview Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Interview Date from"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Interview Date to"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Interview Time"; Text[30])
        {
            Caption = 'Interview Start Time';
            DataClassification = ToBeClassified;
        }
        field(17; "Interview Location"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Interview Chairperson Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE(Employee."No.", "Interview Chairperson Code");
                IF Employee.FINDFIRST THEN BEGIN
                    "Interview Chairperson Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                END;
            end;
        }
        field(19; "Interview Chairperson Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Interview Purpose"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Job Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Employee Requisitions"."No.";

            trigger OnValidate()
            begin
                "Interview Job No." := '';
                "Job Title" := '';
                Description := '';
                EmployeeRequisition.RESET;
                EmployeeRequisition.SETRANGE("No.", "Job Requisition No.");
                IF EmployeeRequisition.FINDFIRST THEN BEGIN
                    "Interview Job No." := EmployeeRequisition."Job No.";
                    "Job Title" := EmployeeRequisition."Job Title";
                    Description := EmployeeRequisition."Emp. Requisition Description";
                    EmployeeRecruitment.LoadApplicantsToInterviewPannel(EmployeeRequisition."No.", EmployeeRequisition."Job No.");
                END;
            end;
        }
        field(22; "Job Title"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; Description; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Committee Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(49; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(50; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Created by"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Mandatory Docs. Required"; Boolean)
        {
            Caption = 'Mandatory Documents Required';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Interview No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Interview No" = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Interview Nos.");
            //NoSeriesMgt.InitSeries(HRSetup."Interview Nos.", xRec."No. Series", 0D, "Interview No", "No. Series");
        END;
        "Created by" := USERID;
        "Document Date" := TODAY;
    end;

    var
        IntCommitteeHeader: Record 50106;
        EmployeeRequisition: Record 50098;
        EmployeeJobApplications: Record 50099;
        EmployeeRecruitment: Codeunit 50033;
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Employee: Record 5200;
}


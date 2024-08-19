/// <summary>
/// Table Interview Qns Parameters (ID 50111).
/// </summary>
table 50111 "Interview Qns Parameters"
{

    fields
    {
        field(1; "Job Applicant No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "HR Job Applications"."No." WHERE("Employee Requisition No." = FIELD("Job Requistion No"));

            trigger OnValidate()
            begin
                HRJobApplications.RESET;
                HRJobApplications.SETRANGE("No.", "Job Applicant No");
                IF HRJobApplications.FINDFIRST THEN BEGIN
                    Surname := HRJobApplications.Surname;
                    Firstname := HRJobApplications.Firstname;
                    Middlename := HRJobApplications.Middlename;
                END;
            end;
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; Surname; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; Firstname; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Middlename; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Job No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Job Requistion No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "HR Employee Requisitions";
        }
        field(8; "Evaluator No."; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,EV1,EV2,EV3,EV4,EV5,EV6,EV7,EV8,EV9,EV10';
            OptionMembers = " ",EV1,EV2,EV3,EV4,EV5,EV6,EV7,EV8,EV9,EV10;
        }
        field(10; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Preliminary Qns"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Total := "Preliminary Qns" + "Technical Qns" + "Behavioural Qns" + "Closing Qns";
            end;
        }
        field(12; "Technical Qns"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Total := "Preliminary Qns" + "Technical Qns" + "Behavioural Qns" + "Closing Qns";
            end;
        }
        field(13; "Behavioural Qns"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Total := "Preliminary Qns" + "Technical Qns" + "Behavioural Qns" + "Closing Qns";
            end;
        }
        field(14; "Closing Qns"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Total := "Preliminary Qns" + "Technical Qns" + "Behavioural Qns" + "Closing Qns";
            end;
        }
        field(80; Total; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Job Applicant No", "Job Requistion No", "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRJobApplications: Record "HR Job Applications";
}


/// <summary>
/// TableExtension HR Setup (ID 50261) extends Record Human Resources Setup.
/// </summary>
tableextension 50261 "HR Setup" extends "Human Resources Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transport Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Vehicle Filling Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50002; "Fleet Accident Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52136923; "Employee Data Directory Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52137023; "Job Nos."; Code[20])
        {
            Caption = 'Job Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137024; "Employee Requisition Nos."; Code[20])
        {
            Caption = 'Employee Requisition Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137025; "Job Application Nos."; Code[20])
        {
            Caption = 'Job Application Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137026; "Shortlisting Nos."; Code[20])
        {
            Caption = 'Shortlisting Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137027; "Interview Nos."; Code[20])
        {
            Caption = 'Interview Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137028; "Employee Detail Update Nos."; Code[20])
        {
            Caption = 'Employee Detail Update Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137029; "Employee Appraisal Nos."; Code[20])
        {
            Caption = 'Employee Appraisal Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137030; "Employee Evaluation Nos."; Code[20])
        {
            Caption = 'Employee Evaluation Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137031; "Leave Allocation Nos."; Code[20])
        {
            Caption = 'Leave Allocation Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137032; "Leave Planner Nos."; Code[20])
        {
            Caption = 'Leave Planner Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137033; "Leave Application Nos."; Code[20])
        {
            Caption = 'Leave Application Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137034; "Leave Reimbursement Nos."; Code[20])
        {
            Caption = 'Leave Reimbursement Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137035; "Leave Carryover Nos."; Code[20])
        {
            Caption = 'Leave Carryover Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137036; "Leave Allowance Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137040; "Employee Timesheet Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137041; "Disciplinary Cases Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137042; "Appraisal Max score (Core)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52137043; "Appraisal Max Score(None Core)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52137044; "Appraisal Activity Code Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137050; "Default Base Calender"; Code[20])
        {
            Caption = 'Base Calender';
            DataClassification = ToBeClassified;
            TableRelation = "Base Calendar".Code;
        }
        field(52137051; "Default Imprest Posting Group"; Code[20])
        {
            Caption = 'Default Imprest Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Employee Posting Group".Code;
        }
        field(52137052; "Employee Transfer Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137053; "Exit Interview Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137054; "Asset Transfer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137055; "Medical Scheme No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137056; "Training Needs Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137057; "Training Group Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137058; "Training Application Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137059; "Approved Training Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137060; "Enable Online Leave App."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52137061; "Job App. Lower Age Limit"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52137062; "Job App. Upper Age Limit"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52137063; "HR Job Applicant Data Dir.Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52137064; "Permanent Employment Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employment Contract".Code;
        }
        field(52137065; "Contract Employment Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employment Contract".Code;
        }
        field(52137066; "ShortTerm Employment  Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employment Contract".Code;
        }
        field(52137067; "Retirement Age"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(52137100; "HR Jobs Data"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52137120; "Loan Invoice Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137150; "Principal Journal Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(52137151; "Principal Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Principal Journal Template"));
        }
        field(52137152; "Interest Journal Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(52137153; "Interest Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Interest Journal Template"));
        }
        field(52137154; "HR HOD"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(52137155; "Grievance Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137156; "Incident Reference Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137157; "Salary Advance Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52137158; "Salary Increment Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    var
        myInt: Integer;
}
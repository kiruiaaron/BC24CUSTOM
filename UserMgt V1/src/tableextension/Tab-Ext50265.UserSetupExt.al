tableextension 50265 "User Setup Ext" extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(50001; Picture; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(52136923; "Re-Open Imprest Surrender"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136924; "Post Leave Application"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136925; "ReOpen Purchase Requisition"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136950; "Reopen Documents"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136951; "Reversal Right"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136952; "Item Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136953; "Payroll Admin"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136980; "Receive Legal Notifications"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136981; "Receive ICT Notifications"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136982; "Give Access to Payroll"; Code[20])
        {
            DataClassification = ToBeClassified;
            //  TableRelation = Payroll;
        }
        field(52136983; "Payroll Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name;// WHERE("Journal Template Name"=CONST(GENERAL));
        }
        field(52136984; HOD; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(52136985; "View Petty Cash"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136986; "View Imprest"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
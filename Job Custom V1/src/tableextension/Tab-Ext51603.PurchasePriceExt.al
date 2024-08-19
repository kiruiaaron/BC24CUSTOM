tableextension 51603 "Purchase Price Ext" extends "Purchase Price"
{
    fields
    {

        field(50000; "Contract Type"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Contract Type";
        }
        field(50001; Contract; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            begin
                //added on 20/03/2019
                if JobRec.Get("Project Code") then begin
                    "Project Name" := JobRec.Description;
                end;
            end;
        }
        field(50003; "Project Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Task No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Project Code"));

            trigger OnValidate()
            begin
                JobTask.Reset;
                JobTask.SetRange("Job No.", "Project Code");
                JobTask.SetRange("Job Task No.", "Task No");
                if JobTask.FindSet then begin
                    "Task Description" := JobTask.Description;

                    //get amount from the sales line
                    JobRec.Get("Project Code");

                    SalesLineRec.Reset;
                    SalesLineRec.SetRange("Document No.", JobRec."Sales Order");
                    Evaluate(lineNo, JobTask."Job Task No.");
                    SalesLineRec.SetRange("Line No.", lineNo);
                    SalesLineRec.SetRange(SalesLineRec."Document Type", SalesLineRec."Document Type"::Order);
                    if SalesLineRec.FindSet then begin
                        "Quoted Daily Rate" := SalesLineRec."Unit Price";
                    end;
                end;
            end;
        }
        field(50005; "Task Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50006; "Quoted Daily Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    var
        SalesLineRec: Record "Sales Line";
        JobTask: Record "Job Task";
        JobRec: Record Job;
        lineNo: Integer;
}

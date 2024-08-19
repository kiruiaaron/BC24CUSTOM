tableextension 51607 "Job Planning Line Ext" extends "Job Planning Line"
{
    fields
    {
        field(5901; Venue; Text[200])
        {
            DataClassification = ToBeClassified;
            TableRelation = Venues.Venue;
        }
        field(5902; "Vendor No"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE("Vendor Type" = FILTER("Sub-Contractor"));

            trigger OnValidate()
            begin
                if Vendor.Get("Vendor No") then
                    "Vendor Name" := Vendor.Name;
            end;
        }
        field(5903; "Vendor Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5904; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5905; Ordered; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; Deployment; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Deployment Header".Code WHERE(Project = FIELD("Job No."));

            trigger OnValidate()
            begin
                DeploymentHeader.Reset;
                DeploymentHeader.SetRange(Code, Deployment);
                if DeploymentHeader.FindSet then begin
                    DeploymentHeader.CalcFields("Total Actual No of Days");
                    Quantity := DeploymentHeader."Total Actual No of Days";
                    Validate(Quantity);
                end;
            end;
        }
        field(50002; "Brand Ambassadors"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //IF NOT "Brand Ambassadors" THEN
                Quantity := 0;
                if not "Brand Ambassadors" then
                    Deployment := '';
            end;
        }
        field(50003; "Line no"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Planned Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Actual Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TotalQuantity := 0;
                JobPlanningLine.Reset;
                JobPlanningLine.SetRange("Job No.", "Job No.");
                JobPlanningLine.SetRange("Job Task No.", "Job Task No.");
                JobPlanningLine.CalcSums(JobPlanningLine."Actual Quantity");
                TotalQuantity := JobPlanningLine."Actual Quantity";
                if (TotalQuantity + "Actual Quantity") > "Planned Quantity" then begin
                    Error('You cannot Input more than the Planned Quantity');
                end;


                //calculate reminder 24/10/2018
                //Remainder := Quantity - "Actual Quantity";

                if "Actual Quantity" > Quantity then
                    Error('Actual quantity %1 cannot be greater than the quantity%2', "Actual Quantity", Quantity);
            end;
        }
        field(50006; "Ordered Quantity"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                              "Job Task No." = FIELD("Job Task No."),
                                                              "Document Type" = CONST(Order)));
            FieldClass = FlowField;
        }
        field(50007; Remainder; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; Week; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; Executed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Procured Quantity"; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                  "Job Task No." = FIELD("Job Task No.")));
            FieldClass = FlowField;
        }
        field(50011; "Consumed Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Sales Line Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50035; "No. of Days"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; Purpose; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        Job1: Record Job;
        JobPlanningLine: Record "Job Planning Line";
        quantity1: Decimal;
        JobTask1: Record "Job Task";
        Resource1: Record Resource;
        SalesOrder: Record "Sales Line";
        VarInteger: Integer;
        VarCode: Code[10];
        TotalQuantity: Decimal;
        Vendor: Record Vendor;
        DeploymentHeader: Record "Deployment Header";
        deploymentActive: Boolean;
}

table 51610 "Assignment Lines"
{
    DrillDownPageID = 51621;
    LookupPageID = 51621;

    fields
    {
        field(1; "Assignment Number"; Code[50])
        {
            TableRelation = "Project Assignment Header"."Assignment Number";
        }
        field(2; "BA Code"; Code[50])
        {
            TableRelation = Resource."No." WHERE("Resource Type" = CONST("Brand Ambassador"));

            trigger OnValidate()
            begin
                Resource.Reset;
                Resource.SetRange(Resource."No.", "BA Code");
                if Resource.FindSet then begin
                    "BA Name" := Resource.Name;
                    //"Daily Rate":= Resource."Unit Cost";

                    "Phone Number" := Resource."Phone Number";
                    "ID Number" := Resource."Id Number";
                end;

                //added on 24/09/2018 to get daily rate from vendor card
                AssignHeader.Reset;
                AssignHeader.SetRange("Assignment Number", "Assignment Number");
                if AssignHeader.FindSet then begin

                    //updated on 17/01/2019 prices for the contract types
                    PurchasePrice.Reset;
                    PurchasePrice.SetRange("Vendor No.", AssignHeader."BA Category");
                    PurchasePrice.SetRange("Item No.", AssignHeader."Contract Type");
                    if PurchasePrice.FindSet then begin
                        "Daily Rate" := PurchasePrice."Direct Unit Cost";
                    end;

                    //added 0804/2019
                    "Subcontract Type" := AssignHeader."Contract Type";
                    //
                end;
            end;
        }
        field(3; "BA Name"; Text[250])
        {
        }
        field(4; "Daily Rate"; Decimal)
        {
            Editable = false;
        }
        field(5; "Team Leader"; Boolean)
        {

            trigger OnValidate()
            begin
                Validate("BA Code");
            end;
        }
        field(6; Select; Boolean)
        {
        }
        field(7; "Region Code"; Code[20])
        {
            Editable = false;
        }
        field(8; "Phone Number"; Code[20])
        {
        }
        field(9; "ID Number"; Code[10])
        {
        }
        field(10; Deployed; Boolean)
        {
        }
        field(11; Project; Code[50])
        {
            TableRelation = Job;
        }
        field(12; "Task No"; Code[50])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD(Project));
        }
        field(13; "Subcontract Type"; Code[20])
        {
            TableRelation = "Purchase Price"."Vendor No." WHERE("Task No" = FIELD("Task No"),
                                                                 "Project Code" = FIELD(Project));

            trigger OnValidate()
            begin
                //added on 08/04/2019 to get daily rate from vendor card
                AssignHeader.Reset;
                AssignHeader.SetRange("Assignment Number", "Assignment Number");
                if AssignHeader.FindSet then begin

                    PurchasePrice.Reset;
                    PurchasePrice.SetRange("Vendor No.", AssignHeader."BA Category");
                    PurchasePrice.SetRange("Project Code", AssignHeader.Project);
                    PurchasePrice.SetRange("Task No", AssignHeader."Task No");
                    if PurchasePrice.FindSet then begin
                        "Daily Rate" := PurchasePrice."Direct Unit Cost";
                        // added on 15/04/2019 to add taskno on lines
                        "Task No" := PurchasePrice."Task No";
                        "Task Description" := PurchasePrice."Task Description";
                    end;

                    //added 0804/2019
                    "Subcontract Type" := PurchasePrice."Item No.";
                    //
                end;
            end;
        }
        field(14; "Task Description"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Assignment Number", "BA Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        AssignHeader.Reset;
        AssignHeader.SetRange("Assignment Number", "Assignment Number");
        if AssignHeader.FindSet then begin
            "Region Code" := AssignHeader."Region Code";
            //added on 15/03/2019 to include project no and task line no
            "Task No" := AssignHeader."Task No";
            Project := AssignHeader.Project;
        end;
    end;

    var
        Resource: Record Resource;
        VendorRec: Record Vendor;
        AssignHeader: Record "Project Assignment Header";
        PurchasePrice: Record "Purchase Price";
        "Sub Contract Category Card": Record "Purchase Price";
}


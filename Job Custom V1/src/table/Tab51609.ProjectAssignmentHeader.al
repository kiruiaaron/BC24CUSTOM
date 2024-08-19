table 51609 "Project Assignment Header"
{
    DrillDownPageID = 51628;
    LookupPageID = 51628;

    fields
    {
        field(1; "Assignment Number"; Code[50])
        {
        }
        field(2; Project; Code[50])
        {
            TableRelation = Job;

            trigger OnValidate()
            begin
                if Job.Get(Project) then begin
                    "Project Name" := Job.Description;
                    "Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                end;

                Vendor.Reset;
                Vendor.SetRange("Project Code", Project);
                if Vendor.FindSet then begin
                    "BA Category" := Vendor."No.";
                    "BA Category Description" := Vendor.Name;
                end;
            end;
        }
        field(3; "Project Name"; Text[250])
        {
        }
        field(4; "Task No"; Code[50])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD(Project));

            trigger OnValidate()
            begin
                JobTask.Reset;
                JobTask.SetRange(JobTask."Job No.", Project);
                JobTask.SetRange(JobTask."Job Task No.", "Task No");
                if JobTask.FindSet then begin
                    "Task Description" := JobTask.Description;
                    //added on 15/03/2019 to display quoted resources from order
                    "Quoted Resources" := JobTask."Sales Line Qty";
                    "Quoted No. of Days" := JobTask."Sales Line No. of Days";
                    Quantity := "Quoted No. of Days" * "Quoted Resources";
                end;

                /*CALCFIELDS("Resources Already Deployed");
                
                IF "Resources Already Deployed" = Quantity THEN
                ERROR('The resources have been fully deployed %1 . The quoted resources were %2',"Resources Already Deployed", "Quoted Resources");
                */

            end;
        }
        field(5; "Task Description"; Text[250])
        {
        }
        field(6; "Created On"; DateTime)
        {
        }
        field(7; "Created By"; Code[50])
        {
        }
        field(8; "BA Category"; Code[200])
        {
            TableRelation = Vendor."No." WHERE("Vendor Type" = FILTER("Sub-Contractor"));

            trigger OnValidate()
            begin
                if Vendor.Get("BA Category") then
                    "BA Category Description" := Vendor.Name;
            end;
        }
        field(9; "BA Category Description"; Text[200])
        {
        }
        field(10; "Region Code"; Code[20])
        {
            Editable = false;
            TableRelation = Regions;
        }
        field(11; Week; Text[100])
        {
        }
        field(33; "No. of Brand Ambassadors"; Integer)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(34; "No. of Team Leaders"; Integer)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(43; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(44; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(45; "Contract Type"; Code[50])
        {
            TableRelation = "Purchase Price"."Item No." WHERE("Project Code" = FIELD(Project));

            trigger OnValidate()
            begin
                "Sub Contract Category Card".Reset;
                "Sub Contract Category Card".SetRange("Vendor No.", "BA Category");
                "Sub Contract Category Card".SetRange("Item No.", "Contract Type");
                if "Sub Contract Category Card".FindSet then begin
                    "Task No" := "Sub Contract Category Card"."Task No";
                    "Task Description" := "Sub Contract Category Card"."Task Description";
                end;

                Validate("Task No");
            end;
        }
        field(46; "Resources to assign"; Integer)
        {
            CalcFormula = Count("Assignment Lines" WHERE("Assignment Number" = FIELD("Assignment Number")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "Quoted Resources"; Decimal)
        {
            Editable = false;
            Enabled = true;
        }
        field(48; "Resources Already Deployed"; Integer)
        {
            CalcFormula = Count("Assignment Lines" WHERE(Project = FIELD(Project),
                                                          "Task No" = FIELD("Task No"),
                                                          Deployed = FILTER(true)));
            Editable = true;
            FieldClass = FlowField;
        }
        field(49; Deployed; Boolean)
        {
        }
        field(50; "Date Deployed"; Date)
        {
        }
        field(51; "Time Deployed"; Time)
        {
        }
        field(52; "Deployed By"; Code[100])
        {
        }
        field(53; "Quoted No. of Days"; Decimal)
        {
            Editable = false;
        }
        field(54; Quantity; Decimal)
        {
            Editable = false;
        }
        field(55; Amount; Integer)
        {
            Enabled = false;
        }
        field(56; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Assignment Lines"."Daily Rate" WHERE("Assignment Number" = FIELD("Assignment Number")));
            FieldClass = FlowField;
        }
        field(57; "No. Series"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Assignment Number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        BASetUp.Reset;
        if BASetUp.FindSet then
            NoSeriesMgt.InitSeries(BASetUp."Assignment Number Series", BASetUp."Assignment Number Series", Today, "Assignment Number", noSeries);

        "Created By" := UserId;
        "Created On" := CurrentDateTime;

        //added on 23/11/2018
        Employees.Reset;
        // to be Employees.SETRANGE("User ID",USERID);
        if Employees.FindSet then begin
            // to be  "Region Code" := Employees."Region Supervised";
        end;
    end;

    var
        Job: Record Job;
        JobTask: Record "Job Task";
        BASetUp: Record "BA SetUp";
        "code": Code[50];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        noSeries: Code[10];
        Vendor: Record Vendor;
        Employees: Record Employee;
        "Sub Contract Category Card": Record "Purchase Price";
}


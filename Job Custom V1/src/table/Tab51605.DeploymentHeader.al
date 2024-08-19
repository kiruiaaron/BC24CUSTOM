table 51605 "Deployment Header"
{
    DrillDownPageID = 51627;
    LookupPageID = 51627;

    fields
    {
        field(1; "Code"; Code[50])
        {

            trigger OnValidate()
            begin
                if Code <> xRec.Code then begin
                    CashMgt.Get;
                    NoSeriesMgt.TestManual(CashMgt."Deployment Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "B A Category"; Code[100])
        {
            TableRelation = Vendor."No." WHERE("Vendor Type" = FILTER("Sub-Contractor"));

            trigger OnValidate()
            begin
                if Vendor.Get("B A Category") then
                    "B A Category Name" := Vendor.Name;
            end;
        }
        field(3; "B A Category Name"; Text[200])
        {
        }
        field(4; Project; Code[100])
        {
            TableRelation = Job;

            trigger OnValidate()
            begin
                //added on 9/04/2019
                if Job.Get(Project) then begin
                    "Project Name" := Job.Description;
                    "Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                end;

                Vendor.Reset;
                Vendor.SetRange("Project Code", Project);
                if Vendor.FindSet then begin
                    "B A Category" := Vendor."No.";
                    "B A Category Name" := Vendor.Name;
                end;
            end;
        }
        field(5; "Project Name"; Text[200])
        {
        }
        field(6; "Task No"; Code[100])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD(Project));

            trigger OnValidate()
            begin
                JobTask.Reset;
                JobTask.SetRange("Job No.", Project);
                JobTask.SetRange("Job Task No.", "Task No");
                if JobTask.FindSet then
                    "Task Description" := JobTask.Description;

                JobTask.Reset;
                JobTask.SetRange(JobTask."Job No.", Project);
                JobTask.SetRange(JobTask."Job Task No.", "Task No");
                if JobTask.FindSet then begin
                    "Task Description" := JobTask.Description;
                    //added on 15/03/2019 to display quoted resources from order
                    "Quoted Resources" := JobTask."Sales Line Qty";
                    "Quoted No. of Days" := JobTask."Sales Line No. of Days";
                    "Total Quoted Quantity" := "Quoted No. of Days" * "Quoted Resources";
                end;
            end;
        }
        field(7; "Task Description"; Text[200])
        {
        }
        field(8; Date; Date)
        {
        }
        field(9; Paid; Boolean)
        {
        }
        field(10; Total; Decimal)
        {
            CalcFormula = Sum("Deployment Lines".Amount WHERE("Deployment Header" = FIELD(Code)));
            Caption = 'Planned Amount';
            FieldClass = FlowField;
        }
        field(11; "Total Number of Days"; Decimal)
        {
            CalcFormula = Sum("Deployment Lines"."No of Days" WHERE("Deployment Header" = FIELD(Code)));
            Caption = 'Planned Number of Days';
            FieldClass = FlowField;
        }
        field(12; Status; Option)
        {
            OptionCaption = 'open,pending approval,approved,rejected';
            OptionMembers = open,"pending approval",approved,rejected;
        }
        field(13; Released; Boolean)
        {
        }
        field(14; Region; Code[20])
        {
            TableRelation = Regions;
        }
        field(15; "Supervisor Code"; Code[50])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Supervisor Code") then begin
                    "Supervisor Name" := Employee.FullName;
                    //  "Supervisor UserID" := Employee."User ID";
                end;
            end;
        }
        field(16; "Supervisor Name"; Text[200])
        {
            Editable = false;
        }
        field(17; "Created By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(18; "Date Created"; Date)
        {
        }
        field(19; "Time Created"; Time)
        {
        }
        field(20; "Total Actual No of Days"; Decimal)
        {
            CalcFormula = Sum("Deployment Lines"."Actual Days Worked" WHERE("Deployment Header" = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Total Actual Amount"; Decimal)
        {
            CalcFormula = Sum("Deployment Lines"."Actual Amount" WHERE("Deployment Header" = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; Week; Decimal)
        {
        }
        field(23; "No. Series"; Code[20])
        {
        }
        field(24; Deployment; Boolean)
        {
        }
        field(25; "Work Dates"; Text[100])
        {
        }
        field(26; "Payment Schedule"; Boolean)
        {
        }
        field(27; "Posted By"; Code[50])
        {
        }
        field(28; "Date Posted"; Date)
        {
        }
        field(29; "Time Posted"; Time)
        {
        }
        field(30; Posted; Boolean)
        {
        }
        field(31; "External Document No"; Code[20])
        {
            Editable = false;
        }
        field(32; "Payment Voucher Created"; Boolean)
        {
        }
        field(33; "No. of Brand Ambassadors"; Integer)
        {
            CalcFormula = Count("Deployment Lines" WHERE("Deployment Header" = FIELD(Code),
                                                          "Team Leader" = FILTER(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "No. of Team Leaders"; Integer)
        {
            CalcFormula = Count("Deployment Lines" WHERE("Deployment Header" = FIELD(Code),
                                                          "Team Leader" = FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Posting Date"; Date)
        {
        }
        field(36; "PV Created"; Boolean)
        {
        }
        field(37; "PV No"; Code[20])
        {
        }
        field(38; "Date PV Created"; Date)
        {
        }
        field(39; "Time PV Created"; Time)
        {
        }
        field(40; "PV Created By"; Code[50])
        {
        }
        field(41; "Work Start Date"; Date)
        {
        }
        field(42; "Work End Date"; Date)
        {
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
                "Sub Contract Category Card".SetRange("Vendor No.", "B A Category");
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
            CalcFormula = Count("Deployment Lines" WHERE("Deployment Header" = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No of Deployment with similar"; Integer)
        {
            CalcFormula = Count("Deployment Header" WHERE(Project = FIELD(Project),
                                                           "Task No" = FIELD("Task No"),
                                                           "Work Start Date" = FIELD("Work Start Date"),
                                                           "Work End Date" = FIELD("Work End Date"),
                                                           Status = FILTER(approved),
                                                           "Supervisor Code" = FIELD("Supervisor Code"),
                                                           "Contract Type" = FIELD("Contract Type")));
            Caption = 'No of Deployment with similar Work dates';
            FieldClass = FlowField;
        }
        field(48; "Resources Already Deployed"; Integer)
        {
            CalcFormula = Count("Deployment Lines" WHERE("Deployment Header" = FIELD(Code),
                                                          Project = FIELD(Project),
                                                          "Task No" = FIELD("Task No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(49; Deployed; Boolean)
        {
        }
        field(53; "Quoted No. of Days"; Decimal)
        {
            Editable = false;
        }
        field(54; "Quoted Resources"; Decimal)
        {
            Editable = false;
        }
        field(55; "Supervisor UserID"; Code[20])
        {
            Editable = false;
        }
        field(56; "Total Quoted Quantity"; Decimal)
        {
            Editable = false;
        }
        field(57; Approved; Boolean)
        {
        }
        field(58; "Reversed By"; Code[50])
        {
        }
        field(59; "Time Reversed"; Time)
        {
        }
        field(60; "Date Reversed"; Date)
        {
        }
        field(61; "Reason for Reversal"; Text[250])
        {
        }
        field(62; Reversed; Boolean)
        {
        }
        field(63; "Document Reversed No"; Code[20])
        {
        }
        field(64; "Created From a Reversed Doc"; Boolean)
        {
        }
        field(65; "PV Posted"; Boolean)
        {
            FieldClass = Normal;
        }
        field(66; "PV Posted Date"; Date)
        {
            FieldClass = Normal;
        }
        field(67; TL; Text[250])
        {
            Caption = 'Supervisor Name';
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CashMgt.Get();
        CashMgt.TestField("Deployment Nos");
        if Code = '' then
            NoSeriesMgt.InitSeries(CashMgt."Deployment Nos", xRec."No. Series", 0D, Code, "No. Series");
        /*IF Code = '' THEN
        BEGIN
        MESSAGE('IN');
         BASetUp.RESET;
         IF BASetUp.FINDSET THEN
          NoSeriesMgt.InitSeries(BASetUp."Deployment Number Series",xRec."No. Series",0D,Code,"No. Series");
         //NoSeriesMgt.InitSeries(BASetUp."Assignment Number Series",xRec."No. Series",0D,"Assignment Number","No. Series");
         //MESSAGE('%1',BASetUp."Deployment Number Series");
        END;*/
        /*
        BASetUp.GET;
        
        BASetUp.TESTFIELD(BASetUp."Assignment Number Series");
        IF "Assignment Number" ='' THEN
        NoSeriesMgt.InitSeries(BASetUp."Assignment Number Series",xRec."No. Series",0D,"Assignment Number","No. Series");
        MESSAGE('%1',BASetUp."Assignment Number Series");
        */

        //added on 20/09/2018 time stamping details
        "Created By" := UserId;
        "Date Created" := Today;
        "Time Created" := Time;

        //added on21/09/2018
        //adding the details of the supervisor
        Employee.Reset;
        // to beEmployee.SETRANGE("User ID",USERID);
        if Employee.FindSet then begin
            "Supervisor Code" := Employee."No.";
            "Supervisor Name" := Employee.FullName;
            // to be Region := Employee."Region Supervised";
            "Supervisor UserID" := UserId;
        end;
        Date := Today;

    end;

    var
        Vendor: Record Vendor;
        Job: Record Job;
        JobTask: Record "Job Task";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        noSeries: Code[10];
        BASetUp: Record "BA SetUp";
        Employee: Record Employee;
        JobPlanningLine: Record "Job Planning Line";
        Deployment: Record "Deployment Header";
        CashMgt: Record "Cash Management Setup";
        "Sub Contract Category Card": Record "Purchase Price";
        BA: Integer;
}


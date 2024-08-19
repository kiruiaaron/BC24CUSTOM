table 51606 "Deployment Lines"
{
    DrillDownPageID = "Deployment Lines";
    LookupPageID = "Deployment Lines";

    fields
    {
        field(1; "Deployment Header"; Code[50])
        {

            trigger OnValidate()
            begin
                if DeploymentHeader.Get("Deployment Header") then begin
                    "Vendor No" := DeploymentHeader."B A Category";
                    Project := DeploymentHeader.Project;
                end;
            end;
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "B A Code"; Code[100])
        {
            TableRelation = Resource."No." WHERE("Resource Type" = FILTER("Brand Ambassador"));

            trigger OnValidate()
            begin
                Resource.Reset;
                Resource.SetRange("No.", "B A Code");
                if Resource.FindSet then begin
                    "B A Name" := Resource.Name;
                    //"Daily Rate":= Resource."Unit Cost";
                    //added on 29/042019
                    "ID Number" := Resource."Id Number";
                    "Phone Number" := Resource."Phone Number";
                    //

                    VendorBankAccount.Reset;
                    VendorBankAccount.SetRange(Code, "B A Code");
                    VendorBankAccount.SetRange("Vendor No.", Rec."Vendor No");
                    VendorBankAccount.SetRange(Blocked, false);
                    /* IF VendorBankAccount.FINDSET THEN BEGIN
                       "Bank Code":= VendorBankAccount."Bank Code";
                       "Bank Name":= VendorBankAccount."Bank Name";
                       "Branch Code":= VendorBankAccount."Branch Code";
                       "Branch Name":= VendorBankAccount."Branch Name";
                       "Account Number":= VendorBankAccount."Bank Account No.";
                       END ELSE BEGIN
                         ERROR('Please specify the brand ambassador as a pay point with the chosen vendor');
                         END;*/
                end;

                //added on 24/09/2018 to get daily rate from vendor card
                AssignHeader.Reset;
                AssignHeader.SetRange(Code, "Deployment Header");
                if AssignHeader.FindSet then begin

                    //updated on 17/01/2019 prices for the contract types
                    PurchasePrice.Reset;
                    PurchasePrice.SetRange("Vendor No.", AssignHeader."B A Category");
                    PurchasePrice.SetRange("Item No.", AssignHeader."Contract Type");
                    if PurchasePrice.FindSet then begin
                        "Daily Rate" := PurchasePrice."Direct Unit Cost";
                    end;

                    //added 0804/2019
                    "Subcontract Type" := AssignHeader."Contract Type";
                    //
                end;

                if DeploymentHeader.Get("Deployment Header") then begin
                    "Vendor No" := DeploymentHeader."B A Category";
                    Project := DeploymentHeader.Project;
                end;

            end;
        }
        field(4; "B A Name"; Text[250])
        {
        }
        field(5; "Bank Code"; Code[50])
        {
        }
        field(6; "Bank Name"; Code[20])
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(7; "Branch Code"; Code[50])
        {
        }
        field(8; "Branch Name"; Text[100])
        {
        }
        field(9; "Account Number"; Code[50])
        {
        }
        field(10; "No of Days"; Decimal)
        {

            trigger OnValidate()
            begin
                Amount := "No of Days" * "Daily Rate";

                //added on 15/03/2019
                if "Quoted No. of Days" <> 0 then begin
                    if "No of Days" > "Quoted No. of Days" then
                        Error('Planned no of days %1 cannot exceed quoted no of days %2', "No of Days", "Quoted No. of Days");
                end;
            end;
        }
        field(11; "Daily Rate"; Decimal)
        {
        }
        field(12; "Vendor No"; Code[50])
        {
            FieldClass = Normal;
        }
        field(13; Amount; Decimal)
        {
        }
        field(14; "Venue/Outlet"; Text[200])
        {
        }
        field(15; Transfered; Boolean)
        {
        }
        field(16; "Team Leader"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Team Leader" then
                    "B A Team Leader" := "B A Code";
            end;
        }
        field(17; "B A Team Leader"; Code[20])
        {
            TableRelation = "Deployment Lines"."B A Code" WHERE("Team Leader" = CONST(true));
        }
        field(18; "Actual Days Worked"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF "Actual Days Worked">"No of Days" THEN
                // ERROR('Actual number of days cannot be more than the planned days');


                "Actual Amount" := "Actual Days Worked" * "Daily Rate";
                "No of Days" := "Actual Days Worked";
            end;
        }
        field(19; "Actual Amount"; Decimal)
        {
        }
        field(20; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            NotBlank = true;
            TableRelation = Job;
        }
        field(21; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            NotBlank = true;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(22; "Planned Quantity"; Decimal)
        {
        }
        field(23; Week; Decimal)
        {
        }
        field(24; No; Code[20])
        {
        }
        field(25; Description; Text[250])
        {
        }
        field(26; "Quoted Quantity"; Decimal)
        {
        }
        field(27; "Remaining Quantity"; Decimal)
        {
        }
        field(28; "Phone Number"; Code[20])
        {
        }
        field(29; "ID Number"; Code[10])
        {
        }
        field(30; Project; Code[50])
        {
            TableRelation = Job;
        }
        field(31; "Task No"; Code[50])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD(Project));
        }
        field(32; "Subcontract Type"; Code[20])
        {
            TableRelation = "Purchase Price"."Item No." WHERE("Vendor No." = FIELD("Vendor No"),
                                                               "Project Code" = FIELD(Project));

            trigger OnValidate()
            begin
                //added on 25/04/2019 to get daily rate from vendor card
                AssignHeader.Reset;
                AssignHeader.SetRange(Code, "Deployment Header");
                if AssignHeader.FindSet then begin

                    PurchasePrice.Reset;
                    PurchasePrice.SetRange("Vendor No.", AssignHeader."B A Category");
                    PurchasePrice.SetRange("Project Code", AssignHeader.Project);
                    //PurchasePrice.SETRANGE("Item No.","Subcontract Type");
                    if PurchasePrice.FindSet then begin

                        "Daily Rate" := PurchasePrice."Direct Unit Cost";
                        "Task No" := PurchasePrice."Task No";
                        "Task Description" := PurchasePrice."Task Description";
                        "Subcontract Type" := PurchasePrice."Item No.";
                    end;

                    //the quoted qty no of days
                    TaskRec.Reset;
                    TaskRec.SetRange("Job No.", Project);
                    TaskRec.SetRange("Job Task No.", "Task No");
                    if TaskRec.FindSet then begin

                        "Quoted No. of Days" := TaskRec."Sales Line No. of Days";
                        "Quoted Quantity" := TaskRec."Sales Line Qty";
                        "Quoted Total Amount" := "Quoted No. of Days" * "Quoted Quantity";
                    end;

                end;
            end;
        }
        field(33; "Task Description"; Text[50])
        {
        }
        field(53; "Quoted No. of Days"; Decimal)
        {
        }
        field(54; "Quoted Total Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Deployment Header", "Line No", "B A Code")
        {
            Clustered = true;
        }
        key(Key2; "B A Team Leader", "Team Leader")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        AssignHeader.Reset;
        AssignHeader.SetRange(Code, "Deployment Header");
        if AssignHeader.FindSet then begin
            //"Region Code" := AssignHeader."Region Code";
            //added on 15/03/2019 to include project no and task line no
            //DeploymentHeader.TESTFIELD(DeploymentHeader."B A Category");
            "Task No" := AssignHeader."Task No";
            Project := AssignHeader.Project;
            "Vendor No" := DeploymentHeader."B A Category";

            //control added on 04/09/2019 to prohibit rate adjustment

            if AssignHeader."Payment Schedule" = false then begin
                //updated on 17/01/2019 prices for the contract types
                PurchasePrice.Reset;
                PurchasePrice.SetRange("Vendor No.", AssignHeader."B A Category");
                PurchasePrice.SetRange("Item No.", AssignHeader."Contract Type");
                if PurchasePrice.FindSet then begin
                    "Daily Rate" := PurchasePrice."Direct Unit Cost";
                    "Actual Amount" := "Actual Days Worked" * "Daily Rate";
                    "No of Days" := "Actual Days Worked";
                end;
            end;
            //added 0804/2019
            "Subcontract Type" := AssignHeader."Contract Type";
            //

        end;
    end;

    var
        Resource: Record Resource;
        VendorBankAccount: Record "Vendor Bank Account";
        DeploymentHeader: Record "Deployment Header";
        AssignHeader: Record "Deployment Header";
        PurchasePrice: Record "Purchase Price";
        "Sub Contract Category Card": Record "Purchase Price";
        TaskRec: Record "Job Task";
}


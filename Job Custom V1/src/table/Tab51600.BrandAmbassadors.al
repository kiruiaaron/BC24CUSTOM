table 51600 "Brand Ambassadors"
{

    fields
    {
        field(1; "code"; Code[20])
        {
            Caption = 'BA Code';
            Editable = false;
            Enabled = true;
        }
        field(2; "First Name"; Text[100])
        {
        }
        field(3; "Middle Name"; Text[100])
        {
        }
        field(4; "Last Name"; Text[100])
        {
        }
        field(5; "Full Name"; Text[250])
        {
        }
        field(6; "Id Number"; Code[10])
        {

            trigger OnValidate()
            begin
                BrandAmbassadors.Reset;
                BrandAmbassadors.SetRange("Id Number", "Id Number");
                if BrandAmbassadors.FindSet then
                    Error('Brand Ambassador %1 with the given ID Number %2 already exists', BrandAmbassadors."First Name", "Id Number");
            end;
        }
        field(7; "Phone Number"; Code[20])
        {

            trigger OnValidate()
            begin
                BrandAmbassadors.Reset;
                BrandAmbassadors.SetRange("Phone Number", "Phone Number");
                if BrandAmbassadors.FindSet then
                    Error('Brand Ambassador %1 with the given Phone Number %2 already exists', BrandAmbassadors."First Name", "Phone Number");
            end;
        }
        field(8; "Email Address"; Text[100])
        {
        }
        field(9; "Physical Address"; Text[250])
        {
        }
        field(10; Comments; BLOB)
        {
        }
        field(11; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved';
            OptionMembers = Open,Pending,Approved;
        }
        field(12; converted; Boolean)
        {
        }
        field(13; "Bank Code"; Code[20])
        {
            TableRelation = "Employee Bank AccountX".Code;

            trigger OnValidate()
            begin
                EmployeeBankAccountX.Reset;
                EmployeeBankAccountX.SetRange(EmployeeBankAccountX.Code, "Bank Code");
                if EmployeeBankAccountX.FindSet then begin
                    "Bank Name" := EmployeeBankAccountX."Bank Name";
                end;
            end;
        }
        field(14; "Bank Name"; Text[100])
        {
        }
        field(15; "Branch Code"; Code[20])
        {
            TableRelation = "Employee Bank AccountX"."Bank Branch No." WHERE(Code = FIELD("Bank Code"));

            trigger OnValidate()
            begin
                EmployeeBankAccountX.Reset;
                EmployeeBankAccountX.SetRange(EmployeeBankAccountX."Bank Branch No.", "Branch Code");
                if EmployeeBankAccountX.FindSet then begin
                    "Branch Name" := EmployeeBankAccountX."Branch Name";
                end;
            end;
        }
        field(16; "Account Number"; Code[50])
        {
        }
        field(17; "Branch Name"; Text[100])
        {
        }
        field(18; "B A Category Name"; Text[250])
        {
        }
        field(19; Height; Text[100])
        {
        }
        field(20; "Body Size"; Option)
        {
            OptionCaption = 'X-small 2-4, Small 6-8,Medium 8-10,Large 12-14,X-large 16';
            OptionMembers = "X-small 2-4"," Small 6-8","Medium 8-10","Large 12-14","X-large 16";
        }
        field(21; Complexion; Text[100])
        {
        }
        field(22; Project; Code[20])
        {
            TableRelation = Job."No.";

            trigger OnValidate()
            begin
                if Job.Get(Project) then
                    "Project Name" := Job.Description;
            end;
        }
        field(23; Weight; Text[100])
        {
        }
        field(24; "Date Added"; Date)
        {
        }
        field(25; "B A Category"; Code[50])
        {
            TableRelation = Vendor."No." WHERE("Vendor Type" = FILTER("Sub-Contractor"));

            trigger OnValidate()
            begin
                if Vendor.Get("B A Category") then begin
                    "B A Category Name" := Vendor.Name;
                    "Price Per Day" := Vendor."Default Daily Rate BA";
                end;
            end;
        }
        field(26; "Price Per Day"; Decimal)
        {
        }
        field(27; "Created By"; Code[100])
        {
        }
        field(28; "Created On"; DateTime)
        {
        }
        field(29; Select; Boolean)
        {
        }
        field(30; "Project Name"; Text[200])
        {
        }
        field(31; Gender; Option)
        {
            OptionCaption = ',Male,Female';
            OptionMembers = ,Male,Female;
        }
        field(32; "Region Code"; Code[50])
        {
            TableRelation = Regions;

            trigger OnValidate()
            begin
                if Regions.Get("Region Code") then
                    "Region Name" := Regions."Region Name";
            end;
        }
        field(33; "Region Name"; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; "code")
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
            NoSeriesMgt.InitSeries(BASetUp."No. Series", BASetUp."No. Series", Today, code, noSeries);
        "Date Added" := Today;
        "Created On" := CurrentDateTime;
        "Created By" := UserId;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        noSeries: Code[10];
        BASetUp: Record "BA SetUp";
        EmployeeBankAccountX: Record "Employee Bank AccountX";
        Vendor: Record Vendor;
        BrandAmbassadors: Record "Brand Ambassadors";
        Job: Record Job;
        Regions: Record Regions;
}


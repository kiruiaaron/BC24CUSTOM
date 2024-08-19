tableextension 51605 "Resource Ext" extends Resource
{
    fields
    {
        field(50020; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Shorstcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
            end;
        }
        field(50021; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ///ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
            end;
        }
        field(50022; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,1,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(5,"Shortcut Dimension 5 Code");
            end;
        }
        field(59000; "Resource Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',CaseMngmt,Facility,ExtraServices,Brand Ambassador';
            OptionMembers = ,CaseMngmt,Facility,ExtraServices,"Brand Ambassador";
        }
        field(59001; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59002; Ammenities; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(59003; "Id Number"; Code[10])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(59004; "Phone Number"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;

            trigger OnValidate()
            begin
                /*Res.RESET;
                Res.SETRANGE(Res."Phone Number","Phone Number");
                IF Res.FINDFIRST() THEN
                  ERROR('The phone number %1 has already been assigned on another ID number %2', "Phone Number", "Id Number");
                  */

            end;
        }
        field(59005; "Email Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59006; "Physical Address"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(59007; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
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
        field(59008; "Bank Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59009; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
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
        field(59010; "Account Number"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(59011; "Branch Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59012; "B A Category Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(59013; Height; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59014; "Body Size"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'X-small 2-4, Small 6-8,Medium 8-10,Large 12-14,X-large 16';
            OptionMembers = "X-small 2-4"," Small 6-8","Medium 8-10","Large 12-14","X-large 16";
        }
        field(59015; Complexion; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59016; Brand; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Brands."Brand Name";
        }
        field(59017; Weight; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59018; "B A Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE("Vendor Type" = FILTER("Sub-Contractor"));

            trigger OnValidate()
            begin
                if Vendor.Get("B A Category") then begin
                    "B A Category Name" := Vendor.Name;
                    //block bank accounts
                    VendorBankAccount.Reset;
                    VendorBankAccount.SetRange(Code, "No.");
                    if VendorBankAccount.FindSet then begin
                        VendorBankAccount.ModifyAll(Blocked, true);
                    end;
                    VendorBankAccount.Reset;
                    VendorBankAccount.SetRange("Vendor No.", "B A Category");
                    VendorBankAccount.SetRange(Code, "No.");
                    if VendorBankAccount.FindSet then begin
                        VendorBankAccount.Blocked := false;
                        VendorBankAccount.Modify(true);
                    end else begin
                        VendorBankAccount.Init;
                        VendorBankAccount."Vendor No." := "B A Category";
                        VendorBankAccount.Code := "No.";
                        VendorBankAccount."Bank Account No." := "Account Number";
                        VendorBankAccount."Bank Code" := "Bank Code";
                        VendorBankAccount."Bank Name" := "Bank Name";
                        VendorBankAccount."Branch Code" := "Branch Code";
                        VendorBankAccount."Branch Name" := "Branch Name";
                        VendorBankAccount.Insert(true);
                    end;
                end;
            end;
        }
        field(59019; "Brand Ambassadors"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(59020; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Male,Female';
            OptionMembers = ,Male,Female;
        }
        field(59021; "Region Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Regions;

            trigger OnValidate()
            begin
                if Regions.Get("Region Code") then
                    "Region Name" := Regions."Region Name";
            end;
        }
        field(59022; "Region Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(59023; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            begin
                if Job.Get("Project Code") then
                    "Project Name" := Job.Description;
            end;
        }
        field(59024; "Project Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(59025; "Resource Costs"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Income/Balance" = FILTER("Income Statement"),
                                                       "Account Type" = FILTER(Posting));

            trigger OnValidate()
            begin
                if GL.Get("Resource Costs") then
                    "Resource Account Name" := GL.Name;
            end;
        }
        field(59026; Inhouse; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(59027; "Fixed Asset"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset"."No.";
        }
        field(59028; "Resource Account Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        EmployeeBankAccountX: Record "Employee Bank AccountX";
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        Regions: Record Regions;
        Job: Record Job;
        GL: Record "G/L Account";
}

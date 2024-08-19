tableextension 50407 "Vendor Ext." extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Supplier PIN No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Normal,Projects';
            OptionMembers = ,Normal,Projects;
        }
        field(52137023; "Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Code"."Bank Code";

            trigger OnValidate()
            begin
                "Bank Name" := '';
                BankCodes.RESET;
                BankCodes.SETRANGE(BankCodes."Bank Code", "Bank Code");
                IF BankCodes.FINDFIRST THEN BEGIN
                    BankCodes.TESTFIELD(BankCodes."Bank Name");
                    "Bank Name" := BankCodes."Bank Name";
                END;

            end;
        }
        field(52137024; "Bank Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137025; "Bank Branch Code"; Code[20])
        {
            Caption = 'Bank Branch Code';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Branch"."Bank Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));

            trigger OnValidate()
            begin
                "Bank Branch Name" := '';
                BankBranches.RESET;
                BankBranches.SETRANGE(BankBranches."Bank Code", "Bank Code");
                BankBranches.SETRANGE(BankBranches."Bank Branch Code", "Bank Branch Code");
                IF BankBranches.FINDFIRST THEN BEGIN
                    BankBranches.TESTFIELD(BankBranches."Bank Branch Name");
                    "Bank Branch Name" := BankBranches."Bank Branch Name";
                END;

            end;
        }
        field(52137026; "Bank Branch Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137027; "Bank Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52137028; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52137029; "MPESA/Paybill Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52137030; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137031; "Vendor Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137032; "VAT Registered"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52137033; "VAT Registration Nos."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52137034; "Date of Incorporation"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52137035; "Incorporation Certificate No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52137036; AGPO; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'N/A,Youth,Women,PWD';
            OptionMembers = "N/A PWD";
        }
        field(52137037; Building; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52137038; "County Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = County.Code;

            trigger OnValidate()
            begin
                "County Name" := '';

                IF Counties.GET("County Code") THEN
                    "County Name" := Counties.Name;
            end;
        }
        field(52137039; "County Name"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137040; Street; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52137041; "Supplier Category Code"; Code[20])
        {
            Caption = 'Supplier Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                ItemAttributeManagement: Codeunit 7500;
            begin
                //ItemAttributeManagement.InheritAttributesFromItemCategory(Rec,"Item Category Code",xRec."Item Category Code");
            end;
        }
        field(52137042; Contacts; Code[30])
        {
            Caption = 'Contact';
            DataClassification = ToBeClassified;
            TableRelation = Contact;

            trigger OnValidate()
            begin
                CompanyPhonebook.RESET;
                CompanyPhonebook.SETRANGE(CompanyPhonebook."No.", Contacts);
                IF CompanyPhonebook.FINDFIRST THEN BEGIN
                    "Home Page" := CompanyPhonebook."Home Page";
                    "Phone No." := CompanyPhonebook."Phone No.";
                    "E-Mail" := CompanyPhonebook."E-Mail";
                END;
            end;
        }
        field(52137043; "Vendor Phone No."; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(52137044; "Vendor Email"; Text[80])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(52137045; "Vendor Home Page"; Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
    }

    var
        myInt: Integer;
        "//Custom Code": Integer;
        BankCodes: Record 50000;
        BankBranches: Record 50001;
        Counties: Record 50176;
        //   ProcurementUploadDocuments: Record 50066;
        //   ProcurementUploadDocuments2: Record 50066;
        VendorPostingGroup: Record 93;
        // VendorDocs: Record 50071;
        CompanyPhonebook: Record 5050;

}

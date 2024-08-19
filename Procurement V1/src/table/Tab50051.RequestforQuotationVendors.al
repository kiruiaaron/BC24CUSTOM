table 50051 "Request for Quotation Vendors"
{

    fields
    {
        field(9; LineNo; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(10; "RFQ Document No.";
        Code[20])
        {
            Caption = 'RFQ "Document No."';
            Editable = false;
            TableRelation = "Request for Quotation Header"."No.";
        }
        field(11; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                /*RFQVendor.RESET;
                RFQVendor.SETRANGE(RFQVendor."RFQ Document No.","RFQ Document No.");
                RFQVendor.SETRANGE(RFQVendor."Vendor No.","Vendor No.");
                IF RFQVendor.FINDFIRST THEN BEGIN
                  ERROR(vendorexists);
                END;
                */


                "Vendor Name" := '';
                "Vendor Email Address" := '';
                "E-Mail" := '';
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    "Vendor Name" := Vendor.Name;
                    "Vendor Email Address" := Vendor."E-Mail";
                    "E-Mail" := Vendor."E-Mail";
                END;

            end;
        }
        field(12; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(13; "Vendor Email Address"; Text[100])
        {
            Caption = 'Vendor Email Address';

            trigger OnValidate()
            begin
                RFQVendor.RESET;
                RFQVendor.SETRANGE(RFQVendor."RFQ Document No.", "RFQ Document No.");
                RFQVendor.SETRANGE(RFQVendor."Vendor Email Address", "Vendor Email Address");
                IF RFQVendor.FINDFIRST THEN BEGIN
                    ERROR(Emailexists);
                END;
                "E-Mail" := "Vendor Email Address";
            end;
        }
        field(14; "RFQ Type"; Option)
        {
            Caption = 'RFQ Type';
            OptionCaption = 'Quotation Request,Open Tender,Restricted Tender';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender";
        }
        field(15; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
        }
        field(16; "E-Mail"; Text[80])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                RFQVendor.RESET;
                RFQVendor.SETRANGE(RFQVendor."RFQ Document No.", "RFQ Document No.");
                RFQVendor.SETRANGE(RFQVendor."E-Mail", "E-Mail");
                IF RFQVendor.FINDFIRST THEN BEGIN
                    ERROR(Emailexists);
                END;
            end;
        }
        field(17; "Not listed Vendor"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Vendor No." := '';
                VALIDATE("Vendor No.");
            end;
        }
    }

    keys
    {
        key(Key1; LineNo, "RFQ Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record 23;
        RFQVendor: Record 50051;
        vendorexists: Label 'The vendor assigned Exists for this RFQ';
        Emailexists: Label 'This Email Address has already been assigned for this RFQ';
}


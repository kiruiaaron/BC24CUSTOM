table 50054 "Bid Analysis Line"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Document No.";
        Code[20])
        {
            Editable = false;
            TableRelation = "Bid Analysis Header"."RFQ No.";
        }
        field(3; "Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                "Vendor Name" := '';
                Vendor.RESET;
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    "Vendor Name" := Vendor.Name;
                END;
            end;
        }
        field(4; "Vendor Name"; Text[50])
        {
            Editable = false;
        }
        field(10; "Purchase Quote No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote));


            /*                     "Buy-from Vendor No.""=FIELD("Vendor No."),
                                                      "Request for Quotation Code"=FIELD("")),
                                  Status=CONST(Released));  */

            trigger OnValidate()
            begin
                PurchaseHeader.RESET;
                PurchaseHeader.SETRANGE(PurchaseHeader."Document Type", PurchaseHeader."Document Type"::Quote);
                PurchaseHeader.SETRANGE(PurchaseHeader."No.", "Purchase Quote No.");
                PurchaseHeader.SETRANGE(PurchaseHeader."Buy-from Vendor No.", "Vendor No.");
                IF PurchaseHeader.FINDFIRST THEN BEGIN
                    PurchaseHeader.CALCFIELDS(PurchaseHeader.Amount, PurchaseHeader."Amount Including VAT");
                    "Purchase Quote Date" := PurchaseHeader."Order Date";
                    "Quote Amount Excl VAT" := PurchaseHeader.Amount;
                    "VAT Amount" := PurchaseHeader."Amount Including VAT" - PurchaseHeader.Amount;
                    "Quote Amount Incl VAT" := PurchaseHeader."Amount Including VAT";
                    MODIFY;
                END;
            end;
        }
        field(11; "Purchase Quote Date"; Date)
        {
            Editable = false;
        }
        field(14; "Quote Currency"; Code[10])
        {
        }
        field(15; "Quote Amount Excl VAT"; Decimal)
        {
            Editable = false;
        }
        field(16; "VAT Amount"; Decimal)
        {
            Editable = false;
        }
        field(17; "Quote Amount Incl VAT"; Decimal)
        {
            Editable = false;
        }
        field(20; Award; Boolean)
        {
        }
        field(40; "Meets Specifications"; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(41; "Delivery/Lead Time"; Text[100])
        {
        }
        field(42; "Payment Terms"; Code[20])
        {
        }
        field(49; Remarks; Text[250])
        {
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Closed';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Closed;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record 23;
        PurchaseHeader: Record 38;
}


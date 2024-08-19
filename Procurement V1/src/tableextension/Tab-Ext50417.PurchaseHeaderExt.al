tableextension 50417 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Base Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                   "Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Tender No"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52136923; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52136924; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52136925; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52136926; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52136927; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52136928; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52136932; "Amount(LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52136933; "Amount Including VAT(LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52136980; "Purchase Order Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52136983; "Request for Quotation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';
            TableRelation = "Request for Quotation Header"."No." WHERE(Status = CONST(Released));

            trigger OnValidate()
            begin
                //Sysre NextGen Addon
                TESTFIELD("Buy-from Vendor No.");
                //Check if the selected vendor was part of the RFQ
                /*RequestforQuotationVendors.RESET;
                RequestforQuotationVendors.SETRANGE(RequestforQuotationVendors."RFQ Document No.","Request for Quotation Code");
                RequestforQuotationVendors.SETRANGE(RequestforQuotationVendors."Vendor No.","Buy-from Vendor No.");
                IF NOT RequestforQuotationVendors.FINDFIRST THEN BEGIN
                  ERROR(Text057,RequestforQuotationVendors."RFQ Document No.");
                END;
                //End Check
                */
                IF CONFIRM(Text055) THEN BEGIN
                    ProcurementManagement.CreatePurchaseQuoteLinesfromRFQ(Rec, "Request for Quotation Code");
                END ELSE BEGIN
                    ERROR(Text056);
                END;
                //End Sysre NextGen Addon

            end;
        }
        field(52137000; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = '//Sysre NextGen Addon';

            trigger OnValidate()
            begin
                /*  UserSetup.RESET;
                 UserSetup.SETRANGE(UserSetup."User ID", "User ID");
                 IF UserSetup.FINDFIRST THEN BEGIN
                     UserSetup.TESTFIELD(UserSetup."Global Dimension 1 Code");
                     UserSetup.TESTFIELD(UserSetup."Global Dimension 2 Code");
                     "Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
                     "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
                     "Shortcut Dimension 3 Code" := UserSetup."Shortcut Dimension 3 Code";
                     "Shortcut Dimension 4 Code" := UserSetup."Shortcut Dimension 4 Code";
                     "Shortcut Dimension 5 Code" := UserSetup."Shortcut Dimension 5 Code";
                     "Shortcut Dimension 6 Code" := UserSetup."Shortcut Dimension 6 Code";
                     "Shortcut Dimension 7 Code" := UserSetup."Shortcut Dimension 7 Code";
                     "Shortcut Dimension 8 Code" := UserSetup."Shortcut Dimension 8 Code";
                 END; */
            end;
        }
        field(52137001; "PO sent to Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52137002; "Purchase Order Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,LPO,LSO';
            OptionMembers = " ",LPO,LSO;
        }
        field(52137003; "Delivery Note No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52137004; "Purchase Requisition"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Requisitions";
        }
        field(52137005; Printed; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    var
        myInt: Integer;
        RequestforQuotationVendors: Record 50051;
        ProcurementManagement: Codeunit 50007;
        UserSetup: Record 5200;
        ProcurementUploadDocuments2: Record 50066;
        VendorDocs: Record 50071;
        Text055: Label 'Change the RFQ Reference No., the existing purchase quote lines will be deleted. Continue?';
        Text056: Label 'Modify RFQ Reference No. Cancelled.';
        Text057: Label 'The selected vendor is not in list of the vendors assigned to RFQ No.:%1';

}
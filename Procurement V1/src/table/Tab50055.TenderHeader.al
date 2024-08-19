table 50055 "Tender Header"
{

    fields
    {
        field(10; "No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Tender Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Tender Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Restricted';
            OptionMembers = Open,Restricted;
        }
        field(13; "Tender Submission (From)"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Tender Submission (To)"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Tender Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Tender Preparation,Tender Opening,Tender Evaluation,Closed';
            OptionMembers = "Tender Preparation","Tender Opening","Tender Evaluation",Closed;
        }
        field(20; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "User ID"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Tender Closing Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Evaluation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Award Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Supplier Awarded"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                "Supplier Name" := '';
                IF Supplier.GET("Supplier Awarded") THEN
                    "Supplier Name" := Supplier.Name;
            end;
        }
        field(26; "Supplier Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Purchase Requisition"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Requisitions";//WHERE(Status = CONST(Approved));

            trigger OnValidate()
            begin
                PurchaseRequisition.RESET;
                PurchaseRequisition.SETRANGE(PurchaseRequisition."No.", "Purchase Requisition");
                IF PurchaseRequisition.FINDFIRST THEN BEGIN
                    //                         "Purchase Req. Description" := PurchaseRequisition.Description;
                END;
            end;
        }
        field(29; "Purchase Req. Description"; Text[150])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30; "Tender closed by"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Supplier Category"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Category".Code;

            trigger OnValidate()
            begin
                Rec.TESTFIELD(Status, Rec.Status::Open);
                "Supplier Category Description" := '';



                ItemCategory.RESET;
                ItemCategory.SETRANGE(ItemCategory.Code, "Supplier Category");
                IF ItemCategory.FINDFIRST THEN BEGIN
                    "Supplier Category Description" := ItemCategory.Description;

                    IF "Tender Type" = "Tender Type"::Restricted THEN BEGIN
                        TenderLines.RESET;
                        TenderLines.SETRANGE(TenderLines."Document No.", "No.");
                        IF TenderLines.FINDSET THEN BEGIN
                            TenderLines.DELETEALL
                        END;
                        SupplierCategory.RESET;
                        SupplierCategory.SETRANGE(SupplierCategory."Supplier Category", "Supplier Category");
                        IF SupplierCategory.FINDSET THEN BEGIN
                            REPEAT
                                TenderLines.INIT;
                                TenderLines."Document No." := "No.";
                                Vendors.RESET;
                                Vendors.SETRANGE(Vendors."No.", SupplierCategory."Document Number");
                                IF Vendors.FINDFIRST THEN
                                    TenderLines."Supplier Name" := Vendors.Name;
                                TenderLines.INSERT;
                            UNTIL SupplierCategory.NEXT = 0;
                        END;
                    END;
                END;
            end;
        }
        field(32; "Supplier Category Description"; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(33; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }
        field(34; "Tender Preparation Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Held By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Tender Description", "Tender Type", "Purchase Requisition")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            "Purchases&PayablesSetup".GET;
            /*       "Purchases&PayablesSetup".TESTFIELD("Purchases&PayablesSetup"."Tender Doc No.");
                  //NoSeriesMgt.InitSeries("Purchases&PayablesSetup"."Tender Doc No.",xRec."No. Series",0D,"No.","No. Series");
         */
        END;

        "Document Date" := TODAY;
        "User ID" := USERID;
        "Held By" := USERID;

        ProcurementUploadDocuments2.RESET;
        ProcurementUploadDocuments2.SETRANGE(ProcurementUploadDocuments2.Type, ProcurementUploadDocuments2.Type::Tender);
        ProcurementUploadDocuments2.SETRANGE(ProcurementUploadDocuments2."Tender Stage", ProcurementUploadDocuments2."Tender Stage"::"Tender Preparation");
        IF ProcurementUploadDocuments2.FINDSET THEN BEGIN
            REPEAT
            /*         VendorDocs.INIT;
                    VendorDocs.Code := "No.";
                    VendorDocs."Document Code" := ProcurementUploadDocuments2."Document Code";
                    VendorDocs."Document Description" := ProcurementUploadDocuments2."Document Description";
                    VendorDocs."Document Attached" := FALSE;
                    VendorDocs.INSERT;
     */
            UNTIL ProcurementUploadDocuments2.NEXT = 0;
        END;
    end;

    var
        "Purchases&PayablesSetup": Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Supplier: Record 23;
        PurchaseRequisition: Record 50046;
        ItemCategory: Record 5722;
        TenderLines: Record 50056;
        SupplierCategory: Record 50045;
        Vendors: Record 23;
        ProcurementUploadDocuments2: Record 50066;
    //VendorDocs: Record 50071;
}


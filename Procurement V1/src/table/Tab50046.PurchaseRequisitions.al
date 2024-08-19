table 50046 "Purchase Requisitions"
{
    Caption = 'Purchase Requisition Header';
    DrillDownPageID = 50391;
    LookupPageID = 50391;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(3; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
        }
        field(4; Budget; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(21; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(22; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(23; Amount; Decimal)
        {
            CalcFormula = Sum("Purchase Requisition Line"."Total Cost" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Purchase Requisition Line"."Total Cost(LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount(LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(49; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                Description := UPPERCASE(Description);
            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                         "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Closed';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Closed;

            trigger OnValidate()
            begin
                PurchaseRequisitionLine.RESET;
                PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Document No.", "No.");
                IF PurchaseRequisitionLine.FINDSET THEN BEGIN
                    REPEAT
                        PurchaseRequisitionLine.Status := Status;
                        PurchaseRequisitionLine.MODIFY;
                    UNTIL PurchaseRequisitionLine.NEXT = 0;
                END;
            end;
        }
        field(99; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                /*   UserSetup.RESET;
                  UserSetup.SETRANGE(UserSetup."User ID","User ID");
                  IF UserSetup.FINDFIRST THEN BEGIN
                    UserSetup.TESTFIELD(UserSetup."Global Dimension 1 Code");
                    UserSetup.TESTFIELD(UserSetup."Global Dimension 2 Code");
                    "Global Dimension 1 Code":=UserSetup."Global Dimension 1 Code";
                    "Global Dimension 2 Code":=UserSetup."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code":=UserSetup."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code":=UserSetup."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code":=UserSetup."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code":=UserSetup."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code":=UserSetup."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code":=UserSetup."Shortcut Dimension 8 Code";
                  END; */
            end;
        }
        field(100; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(101; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
        }
        field(102; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
        }
        field(111; "Cancelation Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52137023; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(52137024; "Reference Document No.";
        Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52137025; "Replenishment PR"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52137026; "Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(52137027; "Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header";
        }
        field(52137028; "Document Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52137029; "Odometer Reading"; Text[100])
        {
            DataClassification = ToBeClassified;
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
    }

    trigger OnDelete()
    var
        PostPurchDelete: Codeunit 364;
        ArchiveManagement: Codeunit 5063;
    begin
        //TESTFIELD(Status,Status::Open);
        PurchaseRequisitionLine.RESET;
        PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Document No.", "No.");
        IF PurchaseRequisitionLine.FINDSET THEN
            PurchaseRequisitionLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            "Purchases&PayablesSetup".GET;
            "Purchases&PayablesSetup".TESTFIELD("Purchases&PayablesSetup"."Purchase Requisition Nos.");
            NoSeriesMgt.InitSeries("Purchases&PayablesSetup"."Purchase Requisition Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        "Document Date" := TODAY;
        "Requested Receipt Date" := TODAY;
        "User ID" := USERID;
        VALIDATE("User ID");


        BudgetControlSetup.GET;
        Budget := BudgetControlSetup."Current Budget Code";
        VALIDATE(Budget);
    end;

    var
        Text003: Label 'You cannot rename a %1.';
        ConfirmChangeQst: Label 'Do you want to change %1?', Comment = '%1 = a Field Caption like Currency Code';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        YouCannotChangeFieldErr: Label 'You cannot change %1 because the order is associated with one or more sales orders.', Comment = '%1 - fieldcaption';
        Text007: Label '%1 is greater than %2 in the %3 table.\';
        Text008: Label 'Confirm change?';
        Text009: Label 'Deleting this document will cause a gap in the number series for receipts. An empty receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment = '%1 = "Document No."';
        Text012: Label 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment = '%1 = "Document No."';
        Text014: Label 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment = '%1 = "Document No."';
        Text016: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\';
        Text018: Label 'You must delete the existing purchase lines before you can change %1.';
        Text019: Label 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.\';
        Text020: Label 'You must update the existing purchase lines manually.';
        Text021: Label 'The change may affect the exchange rate used on the price calculation of the purchase lines.';
        Text022: Label 'Do you want to update the exchange rate?';
        Text023: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text025: Label 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ';
        Text027: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text028: Label 'Your identification is set up to process from %1 %2 only.';
        Text029: Label 'Deleting this document will cause a gap in the number series for return shipments. An empty return shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment = '%1 = "Document No."';
        Text032: Label 'You have modified %1.\\';
        Text033: Label 'Do you want to update the lines?';
        Text034: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text037: Label 'Contact %1 %2 is not related to vendor %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than vendor %3.';
        Text039: Label 'Contact %1 %2 is not related to a vendor.';
        Text040: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text042: Label 'You must cancel the approval process if you wish to change the %1.';
        Text045: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text046: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text049: Label '%1 is set up to process from %2 %3 only.';
        Text050: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\Do you want to continue?';
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text052: Label 'The %1 field on the purchase order %2 must be the same as on sales order %3.';
        Text053: Label 'There are unposted prepayment amounts on the document of type %1 with the number %2.';
        Text054: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        DeferralLineQst: Label 'You have changed the %1 on the purchase header, do you want to update the deferral schedules for the lines with this date?', Comment = '%1=The posting date on the document.';
        ChangeCurrencyQst: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created. You may need to update the price information manually.\\Do you want to change %1?';
        PostedDocsToPrintCreatedMsg: Label 'One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.';
        BuyFromVendorTxt: Label 'Buy-from Vendor';
        PayToVendorTxt: Label 'Pay-to Vendor';
        DocumentNotPostedClosePageQst: Label 'The document has not been posted.\Are you sure you want to exit?';
        DocTxt: Label 'Purchase Order';
        MixedDropshipmentErr: Label 'You cannot print the purchase order because it contains one or more lines for drop shipment in addition to regular purchase lines.';
        ModifyVendorAddressNotificationLbl: Label 'Update the address';
        DontShowAgainActionLbl: Label 'Don''t show again';
        DontShowAgainFunctionTok: Label 'HidePurchaseNotificationForCurrentUser';
        UpdateAddressWithBuyFromAddressFunctionTok: Label 'CopyBuyFromVendorAddressFieldsFromSalesDocument';
        UpdateAddressWithPayToAddressTok: Label 'CopyPayToVendorAddressFieldsFromSalesDocument';
        ModifyVendorAddressNotificationMsg: Label 'The address you entered for %1 is different from the Vendor''s existing address.', Comment = '%1=Vendor name';
        ModifyBuyFromVendorAddressNotificationNameTxt: Label 'Update Buy-from Vendor Address';
        ModifyBuyFromVendorAddressNotificationDescriptionTxt: Label 'Warn if the Buy-from address on sales documents is different from the Vendor''s existing address.';
        ModifyPayToVendorAddressNotificationNameTxt: Label 'Update Pay-to Vendor Address';
        ModifyPayToVendorAddressNotificationDescriptionTxt: Label 'Warn if the Pay-to address on sales documents is different from the Vendor''s existing address.';
        PurchaseAlreadyExistsTxt: Label 'Purchase %1 %2 already exists for this vendor.', Comment = '%1 = Document Type; %2 = "Document No."';
        ShowVendLedgEntryTxt: Label 'Show the vendor ledger entry.';
        ShowDocAlreadyExistNotificationNameTxt: Label 'Purchase document with same external document number already exists.';
        ShowDocAlreadyExistNotificationDescriptionTxt: Label 'Warn if purchase document with same external document number already exists.';
        "Purchases&PayablesSetup": Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchaseRequisitionLine: Record 50047;
        UserSetup: Record 5200;
        BudgetControlSetup: Record 50018;
}


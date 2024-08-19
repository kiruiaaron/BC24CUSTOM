codeunit 50012 "Inventory Management"
{

    trigger OnRun()
    begin
    end;

    var
        Txt001: Label 'Store requisition No.:%1 is already posted.';

    procedure CheckStoreRequisitionMandatoryFields("Store Requisition Header": Record 50068; Posting: Boolean)
    var
        StoreRequisitionHeader: Record 50068;
        StoreRequisitionLine: Record 50069;
    begin
        StoreRequisitionHeader.TRANSFERFIELDS("Store Requisition Header", TRUE);

        StoreRequisitionHeader.TESTFIELD("Document Date");
        StoreRequisitionHeader.TESTFIELD("Posting Date");
        StoreRequisitionHeader.TESTFIELD("Required Date");
        StoreRequisitionHeader.TESTFIELD(Description);
        //StoreRequisitionHeader.TESTFIELD("Global Dimension 1 Code");
        IF Posting THEN BEGIN
            StoreRequisitionHeader.TESTFIELD(Status, StoreRequisitionHeader.Status::Approved);
        END;

        StoreRequisitionLine.RESET;
        StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Document No.", StoreRequisitionHeader."No.");
        IF StoreRequisitionLine.FINDSET THEN BEGIN
            StoreRequisitionLine.TESTFIELD("Item No.");
            //StoreRequisitionLine.TESTFIELD("Location Code");
            StoreRequisitionLine.TESTFIELD(Quantity);
            //StoreRequisitionLine.TESTFIELD("Unit of Measure Code");
            //StoreRequisitionLine.TESTFIELD(Description);
            //StoreRequisitionLine.TESTFIELD("Global Dimension 1 Code");
            //StoreRequisitionLine.TESTFIELD("Global Dimension 2 Code");
            //StoreRequisitionLine.TESTFIELD("Shortcut Dimension 3 Code");
            // StoreRequisitionLine.TESTFIELD("Shortcut Dimension 4 Code");
            //StoreRequisitionLine.TESTFIELD("Shortcut Dimension 5 Code");
            // StoreRequisitionLine.TESTFIELD("Shortcut Dimension 6 Code");
        END ELSE BEGIN
            ERROR('');
        END;
    end;

    procedure PostStoreRequisition("Store Requisition Header": Record 50068; JTemplate: Code[10]; JBatch: Code[10])
    var
        "LineNo.": Integer;
        ItemLedgerEntry: Record 32;
        ItemJnlLine: Record 83;
        StoreRequisitionHeader: Record 50068;
        StoreRequisitionLine: Record 50069;
        StoreRequisitionHeader2: Record 50068;
        StoreRequisitionLine2: Record 50069;
        TempRequisition: Record 50046;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Setups: Record 312;
        TempRequisitionLines: Record 50047;
        PurchaseRequisition: Record 50046;
        PurchaseRequisitionLines: Record 50047;
        ExistInrequisition: Boolean;
        Items: Record 27;
        Text00011: Label 'Reorder point has been reached and  a purchase requisition has been created for your attention for item no: %1';
    begin
        StoreRequisitionHeader.TRANSFERFIELDS("Store Requisition Header", TRUE);
        IF NOT CONFIRM('Are you sure you have Updated Quantity to issue?')
          THEN
            EXIT;
        //Check posted document
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Document No.", StoreRequisitionHeader."No.");
        IF ItemLedgerEntry.FINDFIRST THEN BEGIN
            ERROR(Txt001, StoreRequisitionHeader."No.");
        END;
        //End Check Posted Document

        //If Item Journal Lines Exist, Delete
        ItemJnlLine.RESET;
        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", JTemplate);
        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", JBatch);
        IF ItemJnlLine.FINDSET THEN BEGIN
            ItemJnlLine.DELETEALL;
        END;
        //End Delete Item Journal Lines

        "LineNo." := 1000;

        StoreRequisitionLine.RESET;
        StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Document No.", StoreRequisitionHeader."No.");
        StoreRequisitionLine.SETFILTER(StoreRequisitionLine.Quantity, '>%1', 0);
        IF StoreRequisitionLine.FINDSET THEN BEGIN
            REPEAT

                "LineNo." := "LineNo." + 1;
                ItemJnlLine.INIT;
                ItemJnlLine."Journal Template Name" := JTemplate;
                ItemJnlLine."Journal Batch Name" := JBatch;
                ItemJnlLine."Line No." := "LineNo.";
                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
                ItemJnlLine."Posting Date" := TODAY;
                ItemJnlLine."Document No." := StoreRequisitionHeader."No.";
                ItemJnlLine."Item No." := StoreRequisitionLine."Item No.";
                ItemJnlLine.VALIDATE("Item No.");
                ItemJnlLine."Unit of Measure Code" := StoreRequisitionLine."Unit of Measure Code";
                ItemJnlLine.VALIDATE("Unit of Measure Code");
                ItemJnlLine."Location Code" := StoreRequisitionLine."Location Code";
                ItemJnlLine.VALIDATE("Location Code");
                ItemJnlLine.Description := COPYSTR(StoreRequisitionLine."Item Description", 1, 50);
                ItemJnlLine.Quantity := StoreRequisitionLine."Quantity to Issue";
                ItemJnlLine.VALIDATE(ItemJnlLine.Quantity);
                ItemJnlLine."Shortcut Dimension 1 Code" := StoreRequisitionLine."Global Dimension 1 Code";
                ItemJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                ItemJnlLine."Shortcut Dimension 2 Code" := StoreRequisitionLine."Global Dimension 2 Code";
                ItemJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                ItemJnlLine.ValidateShortcutDimCode(3, StoreRequisitionLine."Shortcut Dimension 3 Code");
                ItemJnlLine.ValidateShortcutDimCode(4, StoreRequisitionLine."Shortcut Dimension 4 Code");
                ItemJnlLine.ValidateShortcutDimCode(5, StoreRequisitionLine."Shortcut Dimension 5 Code");
                ItemJnlLine.ValidateShortcutDimCode(6, StoreRequisitionLine."Shortcut Dimension 6 Code");
                ItemJnlLine.ValidateShortcutDimCode(7, StoreRequisitionLine."Shortcut Dimension 7 Code");
                ItemJnlLine.ValidateShortcutDimCode(8, StoreRequisitionLine."Shortcut Dimension 8 Code");
                ItemJnlLine.INSERT;
            UNTIL StoreRequisitionLine.NEXT = 0;

            COMMIT;
            //Post Entries
            ItemJnlLine.RESET;
            ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", JTemplate);
            ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", JBatch);
            IF ItemJnlLine.FINDSET THEN BEGIN
                CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJnlLine);
            END;
            COMMIT;
            //End Post entries

            //Change Document Status
            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Document No.", StoreRequisitionHeader."No.");
            IF ItemLedgerEntry.FINDFIRST THEN BEGIN
                StoreRequisitionHeader2.RESET;
                StoreRequisitionHeader2.SETRANGE(StoreRequisitionHeader2."No.", StoreRequisitionHeader."No.");
                IF StoreRequisitionHeader2.FINDFIRST THEN BEGIN
                    StoreRequisitionHeader2.Status := StoreRequisitionHeader2.Status::Posted;
                    StoreRequisitionHeader2."Posting Date" := TODAY;
                    StoreRequisitionHeader2."Posted By" := USERID;
                    StoreRequisitionHeader2.VALIDATE(StoreRequisitionHeader2.Status);
                    StoreRequisitionHeader2.Posted := TRUE;
                    StoreRequisitionHeader2.MODIFY;
                END;
            END;
        END;

        /*
        //Replenish Purchase Requisition
        StoreRequisitionLine2.RESET;
        StoreRequisitionLine2.SETRANGE(StoreRequisitionLine2."Document No.","Store Requisition Header"."No.");
        IF StoreRequisitionLine2.FINDSET THEN BEGIN
          REPEAT
            Setups.GET;
            Setups.TESTFIELD(Setups."User to replenish Stock");
            Items.RESET;
            Items.SETRANGE(Items."No.",StoreRequisitionLine2."Item No.");
            Items.SETFILTER(Items."Reorder Point",'<>%1',0);
            IF Items.FINDSET THEN BEGIN
              REPEAT
              Items.CALCFIELDS(Items.Inventory);
        
              IF Items.Inventory<Items."Reorder Point" THEN BEGIN
              TempRequisition.INIT;
              TempRequisition."No.":=NoSeriesMgt.GetNextNo(Setups."Purchase Requisition Nos.",0D,TRUE);
             // ERROR(FORMAT(TempRequisition."No."));
              TempRequisition."Requested Receipt Date":=TODAY;
              TempRequisition."Document Date":=TODAY;
              TempRequisition.Description:='Purchase requisition for Item that need replenishement';
              TempRequisition."User ID":=Setups."User to replenish Stock";
              TempRequisition.VALIDATE(TempRequisition."User ID");
              TempRequisition."Replenishment PR":=TRUE;
              TempRequisition.INSERT;
        
              TempRequisitionLines.INIT;
              TempRequisitionLines."Document No.":=TempRequisition."No.";
              TempRequisitionLines."Requisition Type":=TempRequisitionLines."Requisition Type"::Item;
              TempRequisitionLines.VALIDATE(TempRequisitionLines."Requisition Type");
              TempRequisitionLines."Requisition Code":=Items."No.";
              TempRequisitionLines.VALIDATE(TempRequisitionLines."Requisition Code");
              TempRequisitionLines.Quantity:=Items."Reorder Quantity";
             IF  TempRequisitionLines.INSERT THEN
               MESSAGE(Text00011,TempRequisitionLines."Requisition Code");
              END;
            // MESSAGE(Text00011,TempRequisitionLines."Requisition Code")
              UNTIL Items.NEXT=0;
            END;
        
          UNTIL StoreRequisitionLine2.NEXT=0;
        END;
        */

    end;

    procedure PostStoreRequisitionReturn("Store Requisition Header": Record 50068; JTemplate: Code[10]; JBatch: Code[10])
    var
        "LineNo.": Integer;
        ItemLedgerEntry: Record 32;
        ItemJnlLine: Record 83;
        StoreRequisitionHeader: Record 50068;
        StoreRequisitionLine: Record 50069;
        StoreRequisitionHeader2: Record 50068;
        StoreRequisitionLine2: Record 50069;
        TempRequisition: Record 50046;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Setups: Record 312;
        TempRequisitionLines: Record 50047;
        PurchaseRequisition: Record 50046;
        PurchaseRequisitionLines: Record 50047;
        ExistInrequisition: Boolean;
        Items: Record 27;
        Text00011: Label 'Reorder point has been reached and  a purchase requisition has been created for your attention for item no: %1';
    begin
        StoreRequisitionHeader.TRANSFERFIELDS("Store Requisition Header", TRUE);

        //Check posted document
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Document No.", StoreRequisitionHeader."No.");
        IF ItemLedgerEntry.FINDFIRST THEN BEGIN
            ERROR(Txt001, StoreRequisitionHeader."No.");
        END;
        //End Check Posted Document

        //If Item Journal Lines Exist, Delete
        ItemJnlLine.RESET;
        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", JTemplate);
        ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", JBatch);
        IF ItemJnlLine.FINDSET THEN BEGIN
            ItemJnlLine.DELETEALL;
        END;
        //End Delete Item Journal Lines

        "LineNo." := 1000;

        StoreRequisitionLine.RESET;
        StoreRequisitionLine.SETRANGE(StoreRequisitionLine."Document No.", StoreRequisitionHeader."No.");
        StoreRequisitionLine.SETFILTER(StoreRequisitionLine.Quantity, '>%1', 0);
        IF StoreRequisitionLine.FINDSET THEN BEGIN
            REPEAT
                "LineNo." := "LineNo." + 1;
                ItemJnlLine.INIT;
                ItemJnlLine."Journal Template Name" := JTemplate;
                ItemJnlLine."Journal Batch Name" := JBatch;
                ItemJnlLine."Line No." := "LineNo.";
                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                ItemJnlLine."Posting Date" := StoreRequisitionHeader."Posting Date";
                ItemJnlLine."Document No." := StoreRequisitionHeader."No.";
                ItemJnlLine."Item No." := StoreRequisitionLine."Item No.";
                ItemJnlLine.VALIDATE("Item No.");
                ItemJnlLine."Unit of Measure Code" := StoreRequisitionLine."Unit of Measure Code";
                ItemJnlLine.VALIDATE("Unit of Measure Code");
                ItemJnlLine."Location Code" := StoreRequisitionLine."Location Code";
                //ItemJnlLine.VALIDATE("Location Code");
                ItemJnlLine.Description := COPYSTR(StoreRequisitionLine."Item Description", 1, 50);
                //Frs05072020 for Nanyuki water

                ItemJnlLine.Quantity := StoreRequisitionLine.Quantity;
                ItemJnlLine.VALIDATE(ItemJnlLine.Quantity);
                ItemJnlLine."Unit Cost" := StoreRequisitionLine."Unit Cost";
                ItemJnlLine."Unit Amount" := StoreRequisitionLine."Line Amount";
                ItemJnlLine."Shortcut Dimension 1 Code" := StoreRequisitionLine."Global Dimension 1 Code";
                ItemJnlLine.VALIDATE("Shortcut Dimension 1 Code");
                ItemJnlLine."Shortcut Dimension 2 Code" := StoreRequisitionLine."Global Dimension 2 Code";
                ItemJnlLine.VALIDATE("Shortcut Dimension 2 Code");
                ItemJnlLine.ValidateShortcutDimCode(3, StoreRequisitionLine."Shortcut Dimension 3 Code");
                ItemJnlLine.ValidateShortcutDimCode(4, StoreRequisitionLine."Shortcut Dimension 4 Code");
                ItemJnlLine.ValidateShortcutDimCode(5, StoreRequisitionLine."Shortcut Dimension 5 Code");
                ItemJnlLine.ValidateShortcutDimCode(6, StoreRequisitionLine."Shortcut Dimension 6 Code");
                ItemJnlLine.ValidateShortcutDimCode(7, StoreRequisitionLine."Shortcut Dimension 7 Code");
                ItemJnlLine.ValidateShortcutDimCode(8, StoreRequisitionLine."Shortcut Dimension 8 Code");
                ItemJnlLine.VALIDATE("Gen. Bus. Posting Group", StoreRequisitionLine."Gen. Bus. Posting Group");
                ItemJnlLine.INSERT;
            UNTIL StoreRequisitionLine.NEXT = 0;

            COMMIT;
            //Post Entries
            ItemJnlLine.RESET;
            ItemJnlLine.SETRANGE(ItemJnlLine."Journal Template Name", JTemplate);
            ItemJnlLine.SETRANGE(ItemJnlLine."Journal Batch Name", JBatch);
            IF ItemJnlLine.FINDSET THEN BEGIN
                CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJnlLine);
            END;
            COMMIT;
            //End Post entries

            //Change Document Status
            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Document No.", StoreRequisitionHeader."No.");
            IF ItemLedgerEntry.FINDFIRST THEN BEGIN
                StoreRequisitionHeader2.RESET;
                StoreRequisitionHeader2.SETRANGE(StoreRequisitionHeader2."No.", StoreRequisitionHeader."No.");
                IF StoreRequisitionHeader2.FINDFIRST THEN BEGIN

                    StoreRequisitionHeader2.Status := StoreRequisitionHeader2.Status::Posted;
                    StoreRequisitionHeader2."Posting Date" := TODAY;
                    StoreRequisitionHeader2."Posted By" := USERID;
                    StoreRequisitionHeader2.VALIDATE(StoreRequisitionHeader2.Status);
                    StoreRequisitionHeader2.MODIFY;
                END;
            END;
        END;


        //Replenish Purchase Requisition
        /*
        StoreRequisitionLine2.RESET;
        StoreRequisitionLine2.SETRANGE(StoreRequisitionLine2."Document No.","Store Requisition Header"."No.");
        IF StoreRequisitionLine2.FINDSET THEN BEGIN
          REPEAT
            Setups.GET;
            Setups.TESTFIELD(Setups."User to replenish Stock");
            Items.RESET;
            Items.SETRANGE(Items."No.",StoreRequisitionLine2."Item No.");
            Items.SETFILTER(Items."Reorder Point",'<>%1',0);
            IF Items.FINDSET THEN BEGIN
              REPEAT
              Items.CALCFIELDS(Items.Inventory);
        
              IF Items.Inventory<Items."Reorder Point" THEN BEGIN
              TempRequisition.INIT;
              TempRequisition."No.":=NoSeriesMgt.GetNextNo(Setups."Purchase Requisition Nos.",0D,TRUE);
             // ERROR(FORMAT(TempRequisition."No."));
              TempRequisition."Requested Receipt Date":=TODAY;
              TempRequisition."Document Date":=TODAY;
              TempRequisition.Description:='Purchase requisition for Item that need replenishement';
              TempRequisition."User ID":=Setups."User to replenish Stock";
              TempRequisition.VALIDATE(TempRequisition."User ID");
              TempRequisition."Replenishment PR":=TRUE;
              TempRequisition.INSERT;
        
              TempRequisitionLines.INIT;
              TempRequisitionLines."Document No.":=TempRequisition."No.";
              TempRequisitionLines."Requisition Type":=TempRequisitionLines."Requisition Type"::Item;
              TempRequisitionLines.VALIDATE(TempRequisitionLines."Requisition Type");
              TempRequisitionLines."Requisition Code":=Items."No.";
              TempRequisitionLines.VALIDATE(TempRequisitionLines."Requisition Code");
              TempRequisitionLines.Quantity:=Items."Reorder Quantity";
             IF  TempRequisitionLines.INSERT THEN
               MESSAGE(Text00011,TempRequisitionLines."Requisition Code");
              END;
            // MESSAGE(Text00011,TempRequisitionLines."Requisition Code")
              UNTIL Items.NEXT=0;
            END;
        
          UNTIL StoreRequisitionLine2.NEXT=0;
        END;
        */

    end;
}


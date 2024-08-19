report 50044 "Get PR for Min. Stock Level"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layouts/Get PR for Min. Stock Level.rdlc';

    dataset
    {
        dataitem(Item; 27)
        {
            DataItemTableView = WHERE("Reorder Point" = FILTER(<> 0));

            trigger OnAfterGetRecord()
            begin
                Setups.GET;
                Setups.TESTFIELD(Setups."User to replenish Stock");
                Item.RESET;
                Item.SETFILTER(Item."Reorder Point", '<>%1', 0);
                IF Item.FINDFIRST THEN BEGIN
                    REPEAT
                        Item.CALCFIELDS(Item.Inventory);

                        // IF Item.Inventory<Item."Reorder Point" THEN BEGIN
                        TempRequisition.INIT;
                        TempRequisition."No." := '';// NoSeriesMgt.GetNextNo(Setups."Purchase Requisition Nos.", 0D, TRUE);
                        // ERROR(FORMAT(TempRequisition."No."));
                        TempRequisition."Requested Receipt Date" := TODAY;
                        TempRequisition."Document Date" := TODAY;
                        TempRequisition.Description := 'Purchase requisition for Item that need replenishement';
                        TempRequisition."User ID" := Setups."User to replenish Stock";
                        TempRequisition.VALIDATE(TempRequisition."User ID");
                        TempRequisition.INSERT;

                        TempRequisitionLines.RESET;
                        TempRequisitionLines."Document No." := TempRequisition."No.";
                        TempRequisitionLines."Requisition Type" := TempRequisitionLines."Requisition Type"::Item;
                        TempRequisitionLines.VALIDATE(TempRequisitionLines."Requisition Type");
                        TempRequisitionLines."Requisition Code" := Item."No.";
                        TempRequisitionLines.VALIDATE(TempRequisitionLines."Requisition Code");
                        TempRequisitionLines.Quantity := Item."Reorder Quantity";
                        TempRequisitionLines.INSERT
                    // END;
                    UNTIL Item.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        TempRequisition: Record 50046;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Setups: Record 312;
        TempRequisitionLines: Record 50047;
        PurchaseRequisition: Record 50046;
        PurchaseRequisitionLines: Record 50047;
        ExistInrequisition: Boolean;
}


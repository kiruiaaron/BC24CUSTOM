pageextension 51605 "Job Card Ext" extends "Job Card"
{

    actions
    {
        addlast(navigation)
        {
            action("Create Requisition")
            {
                ApplicationArea = Jobs;
                Caption = 'Create Requisition';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+P';
                ToolTip = 'Create Requisition';

                trigger OnAction()
                var
                    JobPlanningLine: Record "Job Planning Line";
                    JobPlanningLines: Page "Job Planning Lines";
                    PurchaseHeader: Record "Purchase Header";
                    JobTask: Record "Job Task";
                    SalesLine: Record "Sales Line";
                    lineNo: Integer;
                    PurchaseLine: Record "Purchase Line";
                    EmployeeRec: Record Employee;
                begin
                    /*
                    JobTask.RESET;
                    JobTask.SETRANGE(JobTask."Job No.", "No.");
                    JobTask.SETRANGE(JobTask."Select To Post", TRUE);
                    JobTask.SETRANGE(requisitioned, FALSE);
                    IF JobTask.FINDSET THEN BEGIN
                      REPEAT
                        //added on 23/01/2018 ensure that one selects no of days and quantity before sending
                        JobTask.TESTFIELD(JobTask."No. of Days");
                        JobTask.TESTFIELD(JobTask."Quantity to Requisition");
                        //
                    IF PurchaseHeader."No." = '' THEN BEGIN
                    PurchaseHeader.INIT;
                    PurchaseHeader."Document Type":= PurchaseHeader."Document Type"::"Purchase Requisition";
                    PurchaseHeader."Requisition Type":= PurchaseHeader."Requisition Type"::Project;
                    PurchaseHeader."Document Date":= TODAY;
                    //added on 02/01/2019 add description
                    PurchaseHeader.Description := 'Requisition';
                    //end

                    //added on 14/09/2018 adding the sales order field
                    PurchaseHeader."Sales Order" := "Sales Order";
                    //updated on 07/09/2018

                     EmployeeRec.RESET;
                     EmployeeRec.SETRANGE("User ID",USERID);
                     IF EmployeeRec.FINDSET THEN
                     BEGIN
                       //MESSAGE('in%1',EmployeeRec."No.");
                       PurchaseHeader."Request-By No." := EmployeeRec."No.";
                       PurchaseHeader."Request-By Name" := EmployeeRec."First Name" +' '+EmployeeRec."Last Name";
                       PurchaseHeader."Shortcut Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";

                     END;
                    PurchaseHeader."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                    PurchaseHeader."Order Date" := TODAY;
                    //end
                    PurchaseHeader."Job No.":= "No.";
                    PurchaseHeader.VALIDATE("Job No.");
                    PurchaseHeader."Requester ID":= USERID;
                    PurchaseHeader.Status:= PurchaseHeader.Status::Open;
                    IF PurchaseHeader.INSERT(TRUE) THEN BEGIN

                     // IF CONFIRM();
                      END;
                      END;
                      //create purchase line
                      //get details from sales line
                      IF JobTask.Merchandise = FALSE THEN
                      BEGIN
                      SalesLine.RESET;
                      EVALUATE(lineNo, JobTask."Job Task No.");
                      SalesLine.SETRANGE("Line No.", lineNo);
                      SalesLine.SETRANGE(SalesLine."Document No.", Rec."Sales Order");
                      SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
                      IF SalesLine.FINDSET THEN BEGIN
                        //create purchase line
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type":= PurchaseLine."Document Type"::"Purchase Requisition";
                        PurchaseLine."Document No.":= PurchaseHeader."No.";
                        PurchaseLine."Line No.":= SalesLine."Line No.";
                        PurchaseLine.Type:= PurchaseLine.Type::"G/L Account";
                        //PurchaseLine."No.":= SalesLine."No.";
                        //PurchaseLine.VALIDATE("No.");
                        PurchaseLine."Job No.":= "No.";
                        PurchaseLine.VALIDATE("Job No.");
                        //added on 05/03/2019 to add purpose
                        IF JobTask.Purpose = '' THEN
                        BEGIN
                          PurchaseLine.Purpose := SalesLine.Description;
                        END ELSE
                        BEGIN
                          PurchaseLine.Purpose := JobTask.Purpose;
                        END;
                        //
                        PurchaseLine."Job Task No.":= JobTask."Job Task No.";
                        PurchaseLine.VALIDATE("Job Task No.");
                        PurchaseLine."Qty. Requested":= JobTask."Quantity to Requisition"*JobTask."No. of Days";
                        PurchaseLine."Sales Line No. of Days" := SalesLine."No. of Days";
                        PurchaseLine."Qty.to Requisition" := JobTask."Quantity to Requisition";
                        PurchaseLine."No. of Days":=JobTask."No. of Days";
                        PurchaseLine."Sales Line Quantity" := SalesLine.Quantity;
                        PurchaseLine.VALIDATE("Qty. Requested");
                        PurchaseLine."Resource Description" := JobTask.Description;
                        //START RESOURCE
                        //UPDATED 07/09/2018
                        //CATER FOR RESOURCE COST GETTING THE G/L ACCOUNT
                        ResourceRec.RESET;
                        ResourceRec.SETRANGE("No.",SalesLine."No.");
                        IF ResourceRec.FINDSET THEN
                        BEGIN
                          PurchaseLine."No." := ResourceRec."Resource Costs";
                          IF GAccountRec.GET(PurchaseLine."No.") THEN
                          BEGIN
                            PurchaseLine."VAT Prod. Posting Group":= GAccountRec."VAT Prod. Posting Group";
                            PurchaseLine."Gen. Prod. Posting Group" := GAccountRec."Gen. Prod. Posting Group";
                            PurchaseLine.Description := GAccountRec.Name;
                          END;

                          PurchaseLine."Direct Unit Cost":= ResourceRec."Unit Cost";
                          PurchaseLine.VALIDATE("Direct Unit Cost");
                        END;

                        //END

                        //ADDED ON 18/03/2019
                        PurchaseLine."Shortcut Dimension 1 Code" := PurchaseHeader."Shortcut Dimension 1 Code";
                        PurchaseLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                        //Added on 18/04/19 to add qouted price
                        JobTask.CALCFIELDS("Contract (Total Price)");
                        PurchaseLine."Quoted Price":=JobTask."Contract (Total Price)";
                        //
                        PurchaseLine.INSERT(TRUE);
                        END;
                        END ELSE
                        BEGIN
                    //***********************************************************************************
                        //merchadise 07/03/2019
                        EVALUATE(lineNo, JobTask."Job Task No.");
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type":= PurchaseLine."Document Type"::"Purchase Requisition";
                        PurchaseLine."Document No.":= PurchaseHeader."No.";
                        PurchaseLine.Type:= PurchaseLine.Type::Item;
                        PurchaseLine."No." := JobTask."Item No.";
                        //PurchaseLine.VALIDATE("No.");
                        IF ItemRec.GET(JobTask."Item No.") THEN
                        BEGIN
                          PurchaseLine."VAT Prod. Posting Group":= ItemRec."VAT Prod. Posting Group";
                          PurchaseLine."Gen. Prod. Posting Group" := ItemRec."Inventory Posting Group";
                          PurchaseLine."Unit of Measure Code" := ItemRec."Base Unit of Measure";
                          PurchaseLine."Unit of Measure" := ItemRec."Base Unit of Measure";
                        END;
                        PurchaseLine."Location Code" := JobTask."Location Code";
                        PurchaseLine.Description := JobTask.Description;
                        PurchaseLine."Line No.":= lineNo;
                        PurchaseLine."Job No.":= "No.";
                        PurchaseLine.VALIDATE("Job No.");
                        PurchaseLine."Resource Description" := JobTask.Description;
                        PurchaseLine.Purpose := JobTask.Description;
                        PurchaseLine."Job Task No.":= JobTask."Job Task No.";
                        PurchaseLine.VALIDATE("Job Task No.");
                        PurchaseLine."No. of Days" := JobTask."No. of Days";
                        PurchaseLine."Qty. Requested":= JobTask."Quantity to Requisition"*JobTask."No. of Days";
                        //PurchaseLine."Sales Line No. of Days" := SalesLine."No. of Days";
                        //PurchaseLine."Sales Line Quantity" := SalesLine.Quantity;
                        PurchaseLine.VALIDATE("Qty. Requested");

                        PurchaseLine.INSERT(TRUE);
                      END;
                    //**************************************************************************************

                        JobTask."Select To Post" := FALSE;
                        JobTask."Requisitioned Quantity" := JobTask."Requisitioned Quantity"+JobTask."Quantity to Requisition";
                        JobTask.Remainder := JobTask.Quantity-JobTask."Requisitioned Quantity";
                        JobTask."Quantity to Requisition" := 0;
                        JobTask."No. of Days" := 0;
                        IF JobTask."Requisitioned Quantity" = JobTask.Quantity THEN
                        BEGIN
                          JobTask.requisitioned:= TRUE;
                        END;
                        JobTask.MODIFY(TRUE);

                      UNTIL JobTask.NEXT = 0;
                      END;
                      COMMIT;
                       IF CONFIRM('Purchase requisition '+PurchaseHeader."No."+' was successfully created.Would you like to open it?', FALSE) THEN
                      PAGE.RUNMODAL(50071, PurchaseHeader);
                      */

                end;
            }
            action("Create Store Requisition")
            {
                ApplicationArea = Jobs;
                Caption = 'Create Store Requisition';
                Image = EditAttachment;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+P';
                ToolTip = 'Create Requisition';

                trigger OnAction()
                var
                    JobPlanningLine: Record "Job Planning Line";
                    JobPlanningLines: Page "Job Planning Lines";
                    PurchaseHeader: Record "Purchase Header";
                    JobTask: Record "Job Task";
                    SalesLine: Record "Sales Line";
                    lineNo: Integer;
                    PurchaseLine: Record "Purchase Line";
                    EmployeeRec: Record Employee;
                begin
                    /*
                    JobTask.RESET;
                    JobTask.SETRANGE(JobTask."Job No.", "No.");
                    JobTask.SETRANGE(JobTask."Select To Post", TRUE);
                    JobTask.SETRANGE(requisitioned, FALSE);
                    IF JobTask.FINDSET THEN BEGIN
                      REPEAT
                        //added on 23/01/2018 ensure that one selects no of days and quantity before sending
                        JobTask.TESTFIELD(JobTask."No. of Days");
                        JobTask.TESTFIELD(JobTask."Quantity to Requisition");
                        //
                    IF PurchaseHeader."No." = '' THEN BEGIN
                    PurchaseHeader.INIT;
                    PurchaseHeader."Document Type":= PurchaseHeader."Document Type"::"Store Requisition";
                    PurchaseHeader."Requisition Type":= PurchaseHeader."Requisition Type"::Project;
                    PurchaseHeader."Document Date":= TODAY;
                    PurchaseHeader."Project Name":=JobRec.Description;
                    //added on 02/01/2019 add description
                    PurchaseHeader.Description := 'Store Requisition from the project';

                    //end

                    //added on 14/09/2018 adding the sales order field
                    PurchaseHeader."Sales Order" := "Sales Order";
                    //updated on 07/09/2018

                     EmployeeRec.RESET;
                     EmployeeRec.SETRANGE("User ID",USERID);
                     IF EmployeeRec.FINDSET THEN
                     BEGIN
                       MESSAGE('in%1',EmployeeRec."No.");
                       PurchaseHeader."Request-By No." := EmployeeRec."No.";
                       PurchaseHeader."Request-By Name" := EmployeeRec."First Name" +' '+EmployeeRec."Last Name";
                       PurchaseHeader."Shortcut Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                     END;

                    PurchaseHeader."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                    PurchaseHeader."Order Date" := TODAY;
                    //end
                    PurchaseHeader."Job No.":= "No.";
                    PurchaseHeader.VALIDATE("Job No.");
                    PurchaseHeader."Requester ID":= USERID;
                    PurchaseHeader.Status:= PurchaseHeader.Status::Open;
                    IF PurchaseHeader.INSERT(TRUE) THEN BEGIN

                     // IF CONFIRM();
                      END;
                      END;
                      //create purchase line
                      //get details from sales line
                      IF JobTask.Merchandise = FALSE THEN
                      BEGIN
                      SalesLine.RESET;
                      EVALUATE(lineNo, JobTask."Job Task No.");
                      SalesLine.SETRANGE("Line No.", lineNo);
                      SalesLine.SETRANGE(SalesLine."Document No.", Rec."Sales Order");
                      SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
                      IF SalesLine.FINDSET THEN BEGIN
                        //create purchase line
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type":= PurchaseLine."Document Type"::"Store Requisition";
                        PurchaseLine."Document No.":= PurchaseHeader."No.";
                        PurchaseLine."Line No.":= SalesLine."Line No.";
                        PurchaseLine.Type:= PurchaseLine.Type::"G/L Account";
                        //PurchaseLine."No.":= SalesLine."No.";
                        //PurchaseLine.VALIDATE("No.");
                        PurchaseLine."Job No.":= "No.";
                        PurchaseLine.VALIDATE("Job No.");
                        //added on 05/03/2019 to add purpose
                        IF JobTask.Purpose = '' THEN
                        BEGIN
                          PurchaseLine.Purpose := SalesLine.Description;
                        END ELSE
                        BEGIN
                          PurchaseLine.Purpose := JobTask.Purpose;
                        END;
                        //
                        PurchaseLine."Job Task No.":= JobTask."Job Task No.";
                        PurchaseLine.VALIDATE("Job Task No.");
                        PurchaseLine."Qty. Requested":= JobTask."Quantity to Requisition"*JobTask."No. of Days";
                        PurchaseLine."Sales Line No. of Days" := SalesLine."No. of Days";
                        PurchaseLine."Sales Line Quantity" := SalesLine.Quantity;
                        PurchaseLine.VALIDATE("Qty. Requested");
                        PurchaseLine."Resource Description" := JobTask.Description;
                        //START RESOURCE
                        //UPDATED 07/09/2018
                        //CATER FOR RESOURCE COST GETTING THE G/L ACCOUNT
                        ResourceRec.RESET;
                        ResourceRec.SETRANGE("No.",SalesLine."No.");
                        IF ResourceRec.FINDSET THEN
                        BEGIN
                          PurchaseLine."No." := ResourceRec."Resource Costs";
                          IF GAccountRec.GET(PurchaseLine."No.") THEN
                          BEGIN
                            PurchaseLine."VAT Prod. Posting Group":= GAccountRec."VAT Prod. Posting Group";
                            PurchaseLine."Gen. Prod. Posting Group" := GAccountRec."Gen. Prod. Posting Group";
                            PurchaseLine.Description := GAccountRec.Name;
                          END;

                          PurchaseLine."Direct Unit Cost":= ResourceRec."Unit Cost";
                          PurchaseLine.VALIDATE("Direct Unit Cost");
                        END;

                        //END

                        //ADDED ON 18/03/2019
                        PurchaseLine."Shortcut Dimension 1 Code" := PurchaseHeader."Shortcut Dimension 1 Code";
                        PurchaseLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                        //
                        PurchaseLine.INSERT(TRUE);
                        END;
                        END ELSE
                        BEGIN
                    //***********************************************************************************
                        //merchadise 07/03/2019
                        EVALUATE(lineNo, JobTask."Job Task No.");
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type":= PurchaseLine."Document Type"::"Store Requisition";
                        PurchaseLine."Document No.":= PurchaseHeader."No.";
                        PurchaseLine.Type:= PurchaseLine.Type::Item;
                        PurchaseLine."No." := JobTask."Item No.";
                        //PurchaseLine.VALIDATE("No.");
                        IF ItemRec.GET(JobTask."Item No.") THEN
                        BEGIN
                          PurchaseLine."VAT Prod. Posting Group":= ItemRec."VAT Prod. Posting Group";
                          PurchaseLine."Gen. Prod. Posting Group" := ItemRec."Inventory Posting Group";
                          PurchaseLine."Unit of Measure Code" := ItemRec."Base Unit of Measure";
                          PurchaseLine."Unit of Measure" := ItemRec."Base Unit of Measure";
                        END;
                        PurchaseLine."Location Code" := JobTask."Location Code";
                        PurchaseLine.Description := JobTask.Description;
                        PurchaseLine."Line No.":= lineNo;
                        PurchaseLine."Job No.":= "No.";
                        PurchaseLine.VALIDATE("Job No.");
                        PurchaseLine."Resource Description" := JobTask.Description;
                        PurchaseLine.Purpose := JobTask.Description;
                        PurchaseLine."Job Task No.":= JobTask."Job Task No.";
                        PurchaseLine.VALIDATE("Job Task No.");
                        PurchaseLine."No. of Days" := JobTask."No. of Days";
                        PurchaseLine."Qty. Requested":= JobTask."Quantity to Requisition"*JobTask."No. of Days";
                        //PurchaseLine."Sales Line No. of Days" := SalesLine."No. of Days";
                        //PurchaseLine."Sales Line Quantity" := SalesLine.Quantity;
                        PurchaseLine.VALIDATE("Qty. Requested");

                        PurchaseLine.INSERT(TRUE);
                      END;
                    //**************************************************************************************

                        JobTask."Select To Post" := FALSE;
                        JobTask."Requisitioned Quantity" := JobTask."Requisitioned Quantity"+JobTask."Quantity to Requisition";
                        JobTask.Remainder := JobTask.Quantity-JobTask."Requisitioned Quantity";
                        JobTask."Quantity to Requisition" := 0;
                        JobTask."No. of Days" := 0;
                        IF JobTask."Requisitioned Quantity" = JobTask.Quantity THEN
                        BEGIN
                          JobTask.requisitioned:= TRUE;
                        END;
                        JobTask.MODIFY(TRUE);

                      UNTIL JobTask.NEXT = 0;
                      END;
                      COMMIT;
                       IF CONFIRM('Store requisition '+PurchaseHeader."No."+' was successfully created.Would you like to open it?', FALSE) THEN
                      PAGE.RUNMODAL(50051, PurchaseHeader);
                      */

                end;
            }
            action("Create Imprest Requisition")
            {
                ApplicationArea = Jobs;
                Caption = 'Create Imprest Requisition';
                Image = CreateLinesFromJob;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+P';
                ToolTip = 'Create Imprest Requisition';
                Visible = false;

                trigger OnAction()
                var
                    JobPlanningLine: Record "Job Planning Line";
                    JobPlanningLines: Page "Job Planning Lines";
                    PurchaseHeader: Record "Purchase Header";
                    JobTask: Record "Job Task";
                    SalesLine: Record "Sales Line";
                    lineNo: Integer;
                    PurchaseLine: Record "Purchase Line";
                    JobRec: Record Job;
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    CashMgt: Record "Cash Management Setup";
                    Noseries: Code[20];
                    ResourceRec: Record Resource;
                    EmployeeRec: Record Employee;
                begin
                    /*
                    JobRec.RESET;
                    JobRec.SETRANGE("No.","No.");
                    IF JobRec.FINDSET THEN
                    BEGIN
                      CashMgt.RESET;
                      IF CashMgt.FIND('-') THEN
                      BEGIN
                          Noseries := CashMgt."Imprest Nos";
                      END;

                     ImprestHeader.INIT;
                     ImprestHeader.Date := TODAY;
                     ImprestHeader."No." := NoSeriesMgt.GetNextNo(Noseries,ImprestHeader.Date,TRUE);
                     ImprestHeader."Created By" := USERID;
                     ImprestHeader."Payment Type":=ImprestHeader."Payment Type"::Imprest;
                     ImprestHeader."Imprest Type":=ImprestHeader."Imprest Type"::"Project Imprest";
                     ImprestHeader."Document Type":=ImprestHeader."Document Type"::Imprest;
                     //added on 14/09/2018 adding the sales order field
                     ImprestHeader."Sales Order" := "Sales Order";
                     EmployeeRec.RESET;
                     EmployeeRec.SETRANGE("User ID",USERID);
                     IF EmployeeRec.FINDSET THEN
                     BEGIN
                       ImprestHeader."Account Type" := ImprestHeader."Account Type"::Employee;
                       ImprestHeader."Account No." := EmployeeRec."No.";
                       ImprestHeader."Account Name":= EmployeeRec."First Name" +' '+EmployeeRec."Last Name";
                       ImprestHeader."Shortcut Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                       ImprestHeader."Shortcut Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                       ImprestHeader."Posting Group" := EmployeeRec."Posting Group";
                     END;
                     ImprestHeader.INSERT;

                      //lines
                     JobTask.RESET;
                     JobTask.SETRANGE(JobTask."Job No.", "No.");
                     JobTask.SETRANGE(JobTask."Select To Post", TRUE);
                     JobTask.SETRANGE(requisitioned, FALSE);
                     IF JobTask.FINDSET THEN
                     BEGIN
                      REPEAT
                        //get details from sales line
                        SalesLine.RESET;
                        EVALUATE(lineNo, JobTask."Job Task No.");
                        SalesLine.SETRANGE("Line No.", lineNo);
                        SalesLine.SETRANGE(SalesLine."Document No.", Rec."Sales Order");
                        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
                        IF SalesLine.FINDSET THEN
                        BEGIN
                          ImprestLine.INIT;
                          ImprestLine.No:= ImprestHeader."No.";
                          ImprestLine."Line No":= SalesLine."Line No.";
                          ImprestLine."Job No.":= "No.";
                          ImprestLine.VALIDATE("Job No.");
                          ImprestLine."Job Task No.":= JobTask."Job Task No.";
                          ImprestLine.VALIDATE("Job Task No.");
                          ResourceRec.RESET;
                          ResourceRec.SETRANGE("No.",SalesLine."No.");
                          IF ResourceRec.FINDSET THEN
                          BEGIN
                            ImprestLine."Account No." := ResourceRec."Resource Costs";
                            ImprestLine."Account Name" := SalesLine.Description;
                            ImprestLine.Purpose := SalesLine.Description;
                            ImprestLine."Job Quantity":= SalesLine.Quantity;
                            ImprestLine.Amount := ImprestLine."Job Quantity"*ResourceRec."Unit Cost";
                            ImprestLine."Resource Unit Price" := ResourceRec."Unit Cost";
                            ImprestLine."Planned Job Quantity":= SalesLine.Quantity;
                            ImprestLine."Planned Amount" := ImprestLine."Job Quantity"*ResourceRec."Unit Cost";
                            ImprestLine."Planned Unit Amount" := ResourceRec."Unit Cost";

                          END;
                          ImprestLine.INSERT(TRUE);
                        END;
                        JobTask.requisitioned:= TRUE;
                        JobTask."Select To Post" := FALSE;
                        JobTask.MODIFY(TRUE);
                      UNTIL JobTask.NEXT = 0;
                     END;
                     END;

                      COMMIT;
                       IF CONFIRM('Imprest requisition '+ImprestHeader."No."+' was successfully created.Would you like to open it?', FALSE) THEN
                      PAGE.RUNMODAL(57012, ImprestHeader);
                    */

                end;
            }
            action("Create & Weekly Invoice")
            {
                ApplicationArea = Jobs;
                Caption = 'Create & Weekly Invoice';
                Image = CreateLinesFromJob;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+P';
                ToolTip = 'Create Imprest Requisition';

                trigger OnAction()
                var
                    JobPlanningLine: Record "Job Planning Line";
                    JobPlanningLines: Page "Job Planning Lines";
                    PurchaseHeader: Record "Purchase Header";
                    JobTask: Record "Job Task";
                    SalesLine: Record "Sales Line";
                    lineNo: Integer;
                    PurchaseLine: Record "Purchase Line";
                    JobRec: Record Job;
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    CashMgt: Record "Sales & Receivables Setup";
                    Noseries: Code[20];
                    ResourceRec: Record Resource;
                    EmployeeRec: Record Employee;
                begin
                    /*
                    JobRec.RESET;
                    JobRec.SETRANGE("No.","No.");
                    IF JobRec.FINDSET THEN
                    BEGIN
                      CashMgt.RESET;
                      IF CashMgt.FIND('-') THEN
                      BEGIN
                          Noseries := CashMgt."Invoice Nos.";
                      END;

                      SalesHeader.INIT;
                      SalesHeader."Posting Date" := TODAY;
                      SalesHeader."No.":= NoSeriesMgt.GetNextNo(Noseries,SalesHeader."Posting Date",TRUE);
                      SalesHeader."Document Date" := TODAY;
                      SalesHeader."Shipment Date" := TODAY;
                      SalesHeader."Project Name" := JobRec.Description;
                      SalesHeader."Project No" := JobRec."No.";
                      SalesHeader."Sell-to Customer No." := JobRec."Bill-to Customer No.";
                      SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.");
                      JobsSetup.GET;
                      SalesHeader."Bill-to Customer No." := JobsSetup."Sundry Customer";
                      SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.");
                      SalesHeader."Due Date" := TODAY;
                      SalesHeader."Assigned User ID" := USERID;
                      SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                      SalesHeader."Shortcut Dimension 2 Code" := JobRec."Global Dimension 2 Code";
                      //SalesHeader.VALIDATE(SalesHeader."Shortcut Dimension 2 Code");
                      SalesHeader.INSERT(TRUE);

                       //lines
                       JobTask.RESET;
                       JobTask.SETRANGE(JobTask."Job No.", "No.");
                       JobTask.SETRANGE(JobTask."Select To Post", TRUE);
                       IF JobTask.FINDSET THEN
                       BEGIN
                        REPEAT

                          //get details from sales line
                          SalesLines.RESET;
                          EVALUATE(lineNo, JobTask."Job Task No.");
                          SalesLines.SETRANGE("Line No.", lineNo);
                          SalesLines.SETRANGE(SalesLines."Document No.", JobRec."Sales Order");
                          SalesLines.SETRANGE(SalesLines."Document Type", SalesLine."Document Type"::Order);
                          IF SalesLines.FINDSET THEN
                          BEGIN
                            SalesLine.INIT;
                            SalesLine."Line No." := SalesLines."Line No.";
                            SalesLine.Type := SalesLines.Type;
                            SalesLine."No." := SalesLines."No.";
                            SalesLine."Unit Price" := SalesLines."Unit Price";
                            SalesLine."Gen. Prod. Posting Group" := SalesLines."Gen. Prod. Posting Group";
                            SalesLine."VAT Prod. Posting Group" := SalesLines."VAT Prod. Posting Group";
                            SalesLine."Unit of Measure" := SalesLines."Unit of Measure";
                            SalesLine."Unit of Measure Code" := SalesLines."Unit of Measure Code";
                          END;
                          SalesLine."Job No." := "No.";
                          SalesLine."Job Task No." := JobTask."Job Task No.";
                          SalesLine."Document No." := SalesHeader."No.";
                          SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                          SalesLine."Sell-to Customer No." := JobRec."Bill-to Customer No.";
                          SalesLine.VALIDATE(SalesLine."Sell-to Customer No.");
                          JobsSetup.GET;
                          SalesLine."Bill-to Customer No." := JobsSetup."Sundry Customer";
                          SalesLine.VALIDATE(SalesLine."Bill-to Customer No.");
                          IF VendorRec.GET(SalesLine."Bill-to Customer No.") THEN
                          SalesLine."Gen. Bus. Posting Group" := VendorRec."Vendor Posting Group";
                          SalesLine."No. of Days" := 1;
                          SalesLine.Quantity := JobTask."Requisitioned Quantity" - JobTask."Billed Amount";
                          SalesLine."Qty. to Ship" := SalesLine.Quantity;
                          SalesLine."Qty. to Invoice" := SalesLine.Quantity;
                          SalesLine."Line Amount" :=  SalesLine.Quantity * SalesLine."No. of Days" * SalesLine."Unit Price";
                          SalesLine.VALIDATE(SalesLine."Unit Price");
                          SalesLine.VALIDATE(SalesLine."VAT Prod. Posting Group");
                          SalesLine.VALIDATE(SalesLine.Quantity);
                          SalesLine.Description := JobTask.Description;
                          SalesLine.INSERT(TRUE);

                          JobTask."Billed Amount" := JobTask."Billed Amount"+SalesLine.Quantity;
                          JobTask."Select To Post" := FALSE;
                          JobTask.MODIFY(TRUE);
                      UNTIL JobTask.NEXT = 0;

                     END;
                     END;

                      COMMIT;
                       IF CONFIRM('Weekly sales invoice '+SalesHeader."No."+' was successfully created.Would you like to open it?', FALSE) THEN
                      PAGE.RUNMODAL(43, SalesHeader);
                    */

                end;
            }

            action("Send Email Notification")
            {
                Image = Email;
                Promoted = true;

                trigger OnAction()
                var
                    //  SMTPMail: Codeunit "SMTP Mail";
                    JobTask: Record "Job Task";
                    UserSetup: Record "User Setup";
                    //   SMTPMailSetup: Record "SMTP Mail Setup";
                    Window: Dialog;
                begin
                    //MESSAGE('hi');
                    /*
                    JobTask.RESET;
                    JobTask.SETRANGE("Job No.", "No.");
                    JobTask.SETRANGE(Completed, FALSE);
                    SMTPMailSetup.GET;
                    IF JobTask.FINDSET THEN BEGIN
                       Window.OPEN('Notifying ######################1##');
                      REPEAT
                          Window.UPDATE(1,JobTask."Assigned To");
                        UserSetup.GET(JobTask."Assigned To");
                        UserSetup.TESTFIELD("E-Mail");
                    SMTPMail.CreateMessage('TRUEBLAQ',SMTPMailSetup."Email Sender Address",UserSetup."E-Mail",'You have been assigned a task','Dear '+JobTask."Assigned To"+', <br /> <br /> You have '+
                    ' been assigned a task No '+JobTask."Job Task No."+'Name: <strong>'+JobTask.Description+'</strong> on project No: '+JobTask."Job No."+' Project Name: <strong>'+Description+'</strong>',TRUE);
                    SMTPMail.Send;
                    SLEEP(1000);

                    UNTIL JobTask.NEXT=0;
                     Window.CLOSE;
                    END;

                    MESSAGE('Notifications were successfully sent');
                    */

                end;
            }
            action("Notify Project Manager")
            {
                Image = Email;
                Promoted = true;

                trigger OnAction()
                var
                    //    SMTPMail: Codeunit "SMTP Mail";
                    JobTask: Record "Job Task";
                    UserSetup: Record "User Setup";
                    //   SMTPMailSetup: Record "SMTP Mail Setup";
                    Window: Dialog;
                begin
                    //MESSAGE('hi');
                    /*
                    JobRec.RESET;
                    JobRec.SETRANGE("No.", "No.");
                    SMTPMailSetup.GET;
                    IF JobRec.FINDSET THEN
                    BEGIN
                       Window.OPEN('Notifying ######################1##');
                       JobRec.TESTFIELD(JobRec."Project Manager");
                       Window.UPDATE(1,JobRec."Project Manager");
                       UserSetup.GET(JobRec."Project Manager");
                       UserSetup.TESTFIELD("E-Mail");
                       SMTPMail.CreateMessage('TRUEBLAQ',SMTPMailSetup."Email Sender Address",UserSetup."E-Mail",' You have been assigned a project','Dear '+UserSetup."Employee Name"+', <br /> <br /> You have '+
                       ' been assigned a project No: <strong> '+JobRec."No."+'</strong> Name: <strong>'+JobRec.Description+'</strong>. <br /> <br /> Kindly update the budget in the project planning line.',TRUE);
                       SMTPMail.Send;
                       SLEEP(1000);

                      Window.CLOSE;
                    END;

                    MESSAGE('Notifications were successfully sent');
                    */

                end;
            }
            action("Create Purchase Order")
            {
                Caption = 'Create Purchase Order';
                Image = PostDocument;
                Promoted = true;
                Visible = false;

                trigger OnAction()
                var
                    //  SMTPMail: Codeunit "SMTP Mail";
                    JobTask: Record "Job Task";
                    UserSetup: Record "User Setup";
                    //    SMTPMailSetup: Record "SMTP Mail Setup";
                    Window: Dialog;
                    headerCreated: Boolean;
                    NextNo: Code[20];
                    PurchSetup: Record "Purchases & Payables Setup";
                    ResourceRec: Record Resource;
                begin
                    //make a purchase order
                    /*
                    headerCreated:= FALSE;
                    JobPlanningLine.RESET;
                    JobPlanningLine.SETRANGE("Job No.", "No.");
                    JobPlanningLine.SETRANGE(JobPlanningLine.Ordered, FALSE);
                    JobPlanningLine.SETRANGE(Select, TRUE);
                    IF JobPlanningLine.FINDSET THEN BEGIN
                      REPEAT
                      //CREATE header
                      JobPlanningLine.TESTFIELD("Vendor No");
                      IF NOT headerCreated THEN BEGIN
                         PurchaseHeader.INIT;
                        PurchSetup.GET();
                       NextNo:=NoSeriesMgt.GetNextNo(PurchSetup."Order Nos.",TODAY,TRUE);
                       PurchaseHeader."No.":=NextNo;
                        PurchaseHeader."Document Type":= PurchaseHeader."Document Type"::Order;
                        PurchaseHeader."Buy-from Vendor No.":= JobPlanningLine."Vendor No";
                        //added on 14/09/2018 adding the sales order field
                        PurchaseHeader."Sales Order" := "Sales Order";
                        PurchaseHeader.VALIDATE("Buy-from Vendor No.");
                        IF PurchaseHeader.INSERT(TRUE) THEN BEGIN
                          headerCreated:= TRUE;
                        //  MESSAGE('Purchase order was successfully created');
                          END;
                    END;
                    //insert lines
                    PurchaseLine.INIT;
                    PurchaseLine."Document Type":= PurchaseLine."Document Type"::Order;
                    PurchaseLine."Document No.":= PurchaseHeader."No.";
                    PurchaseLine.VALIDATE("Document No.");
                    PurchaseLine."Line No.":= JobPlanningLine."Line No.";
                    PurchaseLine.Type:= PurchaseLine.Type::"G/L Account";
                    JobsSetup.GET();
                    //PurchaseLine."No.":= JobsSetup."P O G/L Account";
                    //PurchaseLine.VALIDATE("No.");
                    PurchaseLine."Buy-from Vendor No.":= PurchaseHeader."Buy-from Vendor No.";
                    PurchaseLine."Job No.":= "No.";
                    PurchaseLine.VALIDATE("Job No.");
                    PurchaseLine."Job Task No.":= JobPlanningLine."Job Task No.";
                    PurchaseLine."Job Line Type":= JobPlanningLine.Type;
                    PurchaseLine.Quantity:= JobPlanningLine.Quantity;
                    PurchaseLine.VALIDATE(Quantity);
                    PurchaseLine."Direct Unit Cost":= JobPlanningLine."Unit Cost";
                    PurchaseLine.VALIDATE("Direct Unit Cost");

                    //UPDATED ON 13/09/2018
                    //ADD THE G/L ACCOUNT FROM RESOURCE
                    PurchaseLine.Description := JobPlanningLine.Description;

                    ResourceRec.RESET;
                    ResourceRec.SETRANGE("No.",JobPlanningLine."No.");
                    IF ResourceRec.FINDSET THEN
                    BEGIN
                      PurchaseLine."No.":= ResourceRec."Resource Costs";
                      PurchaseLine.VALIDATE("No.");
                    END;

                    IF PurchaseLine.INSERT(TRUE) THEN BEGIN
                      JobPlanningLine.Ordered:= TRUE;
                      JobPlanningLine.MODIFY(TRUE);
                      END;

                      UNTIL JobPlanningLine.NEXT=0;
                    END;
                    COMMIT;
                    IF headerCreated THEN BEGIN
                      IF CONFIRM('Purchase order ('+PurchaseHeader."No."+') was successfully created. Would you like to open it?', FALSE) THEN
                      PAGE.RUNMODAL(50, PurchaseHeader);
                      END
                      */

                end;
            }
        }
    }
    var

        JobSimplificationAvailable: Boolean;
        TotalBudgetCommitments: Decimal;
        NoFieldVisible: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        JobPlanningLine: Record "Job Planning Line";
        PurchaseHeader: Record "Purchase Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchaseLine: Record "Purchase Line";
        JobsSetup: Record "Jobs Setup";
        ResourceRec: Record Resource;
        JobRec: Record Job;
        ReservedRec: Record "Item Reservations";
        ReservedRec2: Record "Item Reservations";
        GAccountRec: Record "G/L Account";
        JobTasks: Record "Job Task";
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        VendorRec: Record Vendor;
        ItemRec: Record Item;
}

codeunit 50007 "Procurement Management"
{

    trigger OnRun()
    begin
    end;

    var
        ReqLines: Record 39;
        ItemLedgeEntries: Record 32;
        "LineNo.": Integer;
        LocationCode: Code[10];
        RHeader: Record 38;
        Txt_001: Label 'Empty Purchase Requisition Line';
        Txt_002: Label 'Empty Request for Quotation Line';
        /*   SMTPMailSetup: Record 409;
          SMTPMail: Codeunit 400; */
        RequestforQuotationVendor: Record 50051;
        BCSetup: Record 50018;
        Text0001: Label 'You Have exceeded the Budget by ';
        Text0002: Label 'Do you want to Continue?';
        Text0003: Label 'There is no Budget to Check against do you wish to continue?';
        Text0004: Label 'The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3';
        Text0005: Label 'The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3';
        Text0006: Label 'No Budget To Check Against';
        Text0007: Label 'Item Does not Exist';
        Text0008: Label 'Ensure Fixed Asset No %1 has the Maintenance G/L Account';
        Text0009: Label 'Ensure Fixed Asset No %1 has the Acquisition G/L Account';
        Text0010: Label 'No Budget To Check Against';
        Text0011: Label 'The Amount On Purchase Requisition No %1  %2 %3  Exceeds The Budget By %4';
        BudgetGL: Code[20];
        //SMTP: Record 409;
        RequestforQuotationHeader: Record 50049;
        PurchasesPayablesSetup: Record 312;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        FundsGeneralSetup: Record 50031;
        Employee: Record 5200;
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure CheckPurchaseRequisitionMandatoryFields(PurchaseRequisition: Record 50046)
    var
        PurchaseRequisitionHeader: Record 50046;
        PurchaseRequisitionLine: Record 50047;
    begin
        PurchaseRequisitionHeader.TRANSFERFIELDS(PurchaseRequisition);
        PurchaseRequisitionHeader.TESTFIELD("Document Date");
        PurchaseRequisitionHeader.TESTFIELD(Description);
        PurchaseRequisitionHeader.TESTFIELD("Global Dimension 1 Code");

        PurchaseRequisitionLine.RESET;
        PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Document No.", PurchaseRequisitionHeader."No.");
        IF PurchaseRequisitionLine.FINDSET THEN BEGIN
            REPEAT
                PurchaseRequisitionLine.TESTFIELD("Requisition Code");
                PurchaseRequisitionLine.TESTFIELD(Quantity);
                PurchaseRequisitionLine.TESTFIELD("Global Dimension 1 Code");
            UNTIL PurchaseRequisitionLine.NEXT = 0;
        END ELSE BEGIN
            ERROR(Txt_001);
        END;
    end;

    procedure CheckRequestforQuotationVendors()
    begin
    end;

    procedure CheckRequestforQuotationMandatoryFields(RequestforQuotation: Record 50049)
    var
        RequestforQuotationHeader: Record 50049;
        RequestforQuotationLine: Record 50050;
    begin
        RequestforQuotationHeader.TRANSFERFIELDS(RequestforQuotation);
        RequestforQuotationHeader.TESTFIELD("Document Date");
        RequestforQuotationHeader.TESTFIELD(Description);

        RequestforQuotationLine.RESET;
        RequestforQuotationLine.SETRANGE(RequestforQuotationLine."Document No.", RequestforQuotationHeader."No.");
        IF RequestforQuotationLine.FINDSET THEN BEGIN
            REPEAT
                RequestforQuotationLine.TESTFIELD("Requisition Code");
                RequestforQuotationLine.TESTFIELD("No.");
                RequestforQuotationLine.TESTFIELD(Quantity);
                RequestforQuotationLine.TESTFIELD(Description);
            //  RequestforQuotationLine.TESTFIELD("Global Dimension 1 Code");
            // RequestforQuotationLine.TESTFIELD("Global Dimension 2 Code");

            UNTIL RequestforQuotationLine.NEXT = 0;
        END ELSE BEGIN
            ERROR(Txt_002);
        END;
    end;

    procedure CheckBidAnalysisMandatoryFields("Bid Analysis": Record 50052)
    var
        BidAnalysis: Record 50052;
        BidAnalysisLine: Record 50054;
    begin
    end;

    procedure SendRequestforQuotationToVendor("RFQ No.": Code[20])
    var
        VendorEmailAddress: List of [Text];
    begin
        /*   SMTPMailSetup.GET;
          CLEAR(SMTPMail);

          RequestforQuotationVendor.RESET;
          RequestforQuotationVendor.SETRANGE(RequestforQuotationVendor."RFQ Document No.", "RFQ No.");
          IF RequestforQuotationVendor.FINDSET THEN BEGIN
              REPEAT
                  VendorEmailAddress.Add(RequestforQuotationVendor."Vendor Email Address");
                  SMTPMail.AddBCC(VendorEmailAddress);
              UNTIL RequestforQuotationVendor.NEXT = 0;
          END;
          //SMTPMail.AddAttachment('', '');
          SMTPMail.Send();//(); */
    end;

    procedure CreatePurchaseQuoteLinesfromRFQ(PurchaseHeader: Record 38; "RequestforQuotationNo.": Code[20])
    var
        PurchaseLine: Record 39;
        PurchaseLine2: Record 39;
        RequestforQuotationHeader: Record 50049;
        RequestforQuotationLine: Record 50050;
    begin
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Quote);
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF PurchaseLine.FINDSET THEN BEGIN
            PurchaseLine.DELETEALL;
        END;
        COMMIT;

        "LineNo." := 1000;
        RequestforQuotationLine.RESET;
        RequestforQuotationLine.SETRANGE("Document No.", "RequestforQuotationNo.");
        RequestforQuotationLine.SETRANGE(Status, RequestforQuotationLine.Status::Released);
        IF RequestforQuotationLine.FINDSET THEN BEGIN
            REPEAT
                "LineNo." := "LineNo." + 1;
                PurchaseLine2.INIT;
                PurchaseLine2."Document Type" := PurchaseLine2."Document Type"::Quote;
                PurchaseLine2.VALIDATE("Document Type");
                PurchaseLine2."Document No." := PurchaseHeader."No.";
                PurchaseLine2.VALIDATE("Document No.");
                PurchaseLine2."Line No." := "LineNo.";
                PurchaseLine2.VALIDATE("Line No.");
                PurchaseHeader.TESTFIELD("Buy-from Vendor No.");
                PurchaseLine2."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                PurchaseLine2.VALIDATE("Buy-from Vendor No.");
                PurchaseLine2.Type := RequestforQuotationLine.Type;
                PurchaseLine2.VALIDATE(Type);
                PurchaseLine2."No." := RequestforQuotationLine."No.";
                PurchaseLine2.VALIDATE("No.");
                PurchaseLine2."Location Code" := RequestforQuotationLine."Location Code";
                PurchaseLine2.VALIDATE("Location Code");
                PurchaseLine2.Quantity := RequestforQuotationLine.Quantity;
                PurchaseLine2.VALIDATE(Quantity);
                PurchaseLine2."Unit of Measure Code" := RequestforQuotationLine."Unit of Measure Code";
                PurchaseLine2.VALIDATE("Unit of Measure Code");
                PurchaseLine2."Direct Unit Cost" := RequestforQuotationLine."Unit Cost";
                PurchaseLine2.VALIDATE("Direct Unit Cost");
                PurchaseLine2.Remarks := RequestforQuotationLine.Description;
                PurchaseLine2."Shortcut Dimension 1 Code" := RequestforQuotationLine."Global Dimension 1 Code";
                PurchaseLine2.VALIDATE(PurchaseLine2."Shortcut Dimension 1 Code");
                PurchaseLine2."Shortcut Dimension 2 Code" := RequestforQuotationLine."Global Dimension 2 Code";
                PurchaseLine2.VALIDATE(PurchaseLine2."Shortcut Dimension 2 Code");
                PurchaseLine2."Shortcut Dimension 3 Code" := RequestforQuotationLine."Shortcut Dimension 3 Code";
                PurchaseLine2.VALIDATE(PurchaseLine2."Shortcut Dimension 3 Code");
                PurchaseLine2."Shortcut Dimension 4 Code" := RequestforQuotationLine."Shortcut Dimension 4 Code";
                PurchaseLine2.VALIDATE(PurchaseLine2."Shortcut Dimension 4 Code");
                PurchaseLine2."Shortcut Dimension 5 Code" := RequestforQuotationLine."Shortcut Dimension 5 Code";
                PurchaseLine2.VALIDATE(PurchaseLine2."Shortcut Dimension 5 Code");
                PurchaseLine2."Shortcut Dimension 6 Code" := RequestforQuotationLine."Shortcut Dimension 6 Code";
                PurchaseLine2.VALIDATE(PurchaseLine2."Shortcut Dimension 6 Code");
                PurchaseLine2."Shortcut Dimension 7 Code" := RequestforQuotationLine."Shortcut Dimension 7 Code";
                PurchaseLine2.VALIDATE(PurchaseLine2."Shortcut Dimension 7 Code");
                PurchaseLine2."Shortcut Dimension 8 Code" := RequestforQuotationLine."Shortcut Dimension 8 Code";
                PurchaseLine2.VALIDATE(PurchaseLine2."Shortcut Dimension 8 Code");
                PurchaseLine2.INSERT;
            UNTIL RequestforQuotationLine.NEXT = 0;
        END;
    end;

    procedure CheckBudgetPurchaseRequisition(var PurchHeader: Record 50046)
    var
        PurchLine: Record 50047;
        Commitments: Record 50019;
        Amount: Decimal;
        GLAccount: Record 15;
        Items: Record 27;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record 96;
        BudgetAmount: Decimal;
        Actuals: Record 365;
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssets: Record 5600;
        FAPostingGroup: Record 5606;
        EntryNo: Integer;
        dimSetEntry: Record 480;
    begin
        BCSetup.GET;
        //check if the dates are within the specified range
        IF (PurchHeader."Document Date" < BCSetup."Current Budget Start Date") OR (PurchHeader."Document Date" > BCSetup."Current Budget End Date") THEN BEGIN
            ERROR(Text0004, PurchHeader."Document Date",
            BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
        END;

        CheckIfGLAccountBlocked(BCSetup."Current Budget Code");

        //get the lines related to the purchase requisition header
        PurchLine.RESET;
        PurchLine.SETRANGE(PurchLine."Document No.", PurchHeader."No.");
        IF PurchLine.FINDSET THEN BEGIN
            REPEAT
                //Items
                IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
                    Items.RESET;
                    IF NOT Items.GET(PurchLine."No.") THEN
                        ERROR(Text0007);
                    Items.TESTFIELD("Item G/L Budget Account");
                    BudgetGL := Items."Item G/L Budget Account";
                END;

                //Fixed Asset
                IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN BEGIN
                    FixedAssets.RESET;
                    FixedAssets.SETRANGE(FixedAssets."No.", PurchLine."No.");
                    IF FixedAssets.FINDFIRST THEN BEGIN
                        FAPostingGroup.RESET;
                        FAPostingGroup.SETRANGE(FAPostingGroup.Code, FixedAssets."FA Posting Group");
                        IF FAPostingGroup.FINDFIRST THEN
                            IF PurchLine."FA Posting Type" = PurchLine."FA Posting Type"::Maintenance THEN BEGIN
                                BudgetGL := FAPostingGroup."Maintenance Expense Account";
                                IF BudgetGL = '' THEN
                                    ERROR(Text0008, PurchLine."No.");
                            END ELSE BEGIN
                                BudgetGL := FAPostingGroup."Acquisition Cost Account";
                                IF BudgetGL = '' THEN
                                    ERROR(Text0009, PurchLine."No.");
                            END;
                    END;
                END;

                //G/L Account
                IF PurchLine.Type = PurchLine.Type::"G/L Account" THEN BEGIN
                    BudgetGL := PurchLine."No.";
                    IF GLAccount.GET(PurchLine."No.") THEN
                        GLAccount.TESTFIELD(GLAccount."Budget Controlled", TRUE);
                END;

                //check the votebook now
                FirstDay := DMY2DATE(1, DATE2DMY(PurchHeader."Document Date", 2), DATE2DMY(PurchHeader."Document Date", 3));
                CurrMonth := DATE2DMY(PurchHeader."Document Date", 2);
                IF CurrMonth = 12 THEN BEGIN
                    LastDay := DMY2DATE(1, 1, DATE2DMY(PurchHeader."Document Date", 3) + 1);
                    LastDay := CALCDATE('-1D', LastDay);
                END ELSE BEGIN
                    CurrMonth := CurrMonth + 1;
                    LastDay := DMY2DATE(1, CurrMonth, DATE2DMY(PurchHeader."Document Date", 3));
                    LastDay := CALCDATE('-1D', LastDay);
                END;

                //check the summation of the budget
                BudgetAmount := 0;
                Budget.RESET;
                Budget.SETRANGE(Budget."Budget Name", BCSetup."Current Budget Code");
                Budget.SETFILTER(Budget.Date, '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                Budget.SETRANGE(Budget."G/L Account No.", BudgetGL);
                /*Budget.SETRANGE(Budget."Global Dimension 1 Code",PurchLine."Global Dimension 1 Code");
                Budget.SETRANGE(Budget."Global Dimension 2 Code",PurchLine."Global Dimension 2 Code");
                IF PurchLine."Shortcut Dimension 3 Code" <> '' THEN
                 Budget.SETRANGE(Budget."Budget Dimension 3 Code",PurchLine."Shortcut Dimension 3 Code");
                IF PurchLine."Shortcut Dimension 4 Code" <> '' THEN
                 Budget.SETRANGE(Budget."Budget Dimension 4 Code",PurchLine."Shortcut Dimension 4 Code");*/
                IF Budget.FINDSET THEN BEGIN
                    Budget.CALCSUMS(Amount);
                    BudgetAmount := Budget.Amount;
                END;

                //get the committments
                CommitmentAmount := 0;
                Commitments.RESET;
                Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code", PurchLine."Global Dimension 1 Code");
                Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", PurchLine."Global Dimension 2 Code");
                IF PurchLine."Shortcut Dimension 3 Code" <> '' THEN
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code", PurchLine."Shortcut Dimension 3 Code");
                IF PurchLine."Shortcut Dimension 4 Code" <> '' THEN
                    Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code", PurchLine."Shortcut Dimension 4 Code");
                Commitments.CALCSUMS(Commitments.Amount);
                CommitmentAmount := Commitments.Amount;

                //check if there is any budget
                IF (BudgetAmount <= 0) THEN
                    ERROR(Text0010);

                //check if the actuals plus the amount is greater then the budget amount
                IF ((CommitmentAmount + PurchLine."Total Cost(LCY)") > BudgetAmount) AND (BCSetup."Allow OverExpenditure" = FALSE) THEN BEGIN
                    ERROR(Text0011,
                    PurchLine."Document No.", PurchLine.Type, PurchLine."No.",
                    FORMAT(ABS(BudgetAmount - (CommitmentAmount + ActualsAmount + PurchLine."Total Cost"))));
                END ELSE BEGIN
                    //commit Amounts
                    Commitments.INIT;
                    Commitments."Line No." := 0;
                    Commitments.Date := TODAY;
                    Commitments."Posting Date" := PurchHeader."Document Date";
                    Commitments."Document Type" := Commitments."Document Type"::Requisition;
                    Commitments."Document No." := PurchHeader."No.";
                    Commitments.Amount := PurchLine."Total Cost(LCY)";
                    Commitments."Month Budget" := BudgetAmount;
                    Commitments.Committed := TRUE;
                    Commitments."Committed By" := USERID;
                    Commitments."Committed Date" := PurchHeader."Document Date";
                    Commitments."G/L Account No." := BudgetGL;
                    Commitments."Committed Time" := TIME;
                    Commitments."Shortcut Dimension 1 Code" := PurchLine."Global Dimension 1 Code";
                    Commitments."Shortcut Dimension 2 Code" := PurchLine."Global Dimension 2 Code";
                    Commitments."Shortcut Dimension 3 Code" := PurchLine."Shortcut Dimension 3 Code";
                    Commitments."Shortcut Dimension 4 Code" := PurchLine."Shortcut Dimension 4 Code";
                    Commitments.Budget := BCSetup."Current Budget Code";
                    Commitments.Type := Commitments.Type::Vendor;
                    Commitments.Committed := TRUE;
                    IF Commitments.INSERT THEN BEGIN
                        PurchLine.Committed := TRUE;
                        PurchLine.MODIFY;
                    END;
                END;
            UNTIL PurchLine.NEXT = 0;
        END;

    end;

    procedure CancelBudgetCommitmentPurchaseRequisition(PurchHeader: Record 50046)
    var
        Commitments: Record 50019;
        EntryNo: Integer;
        PurchLine: Record 50047;
        BudgetAmount: Decimal;
        Items: Record 27;
        FixedAsset: Record 5600;
        FAPostingGroup: Record 5606;
    begin
        CLEAR(BudgetAmount);
        BudgetGL := '';
        BCSetup.GET();
        PurchLine.RESET;
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        PurchLine.SETRANGE(Committed, TRUE);
        IF PurchLine.FINDSET THEN BEGIN
            IF PurchLine.Type = PurchLine.Type::Item THEN
                IF Items.GET(PurchLine."No.") THEN
                    BudgetGL := Items."Item G/L Budget Account"
                ELSE
                    IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN
                        IF FixedAsset.GET(PurchLine."No.") THEN
                            FAPostingGroup.RESET;
            FAPostingGroup.SETRANGE(Code, FixedAsset."FA Posting Group");
            IF FAPostingGroup.FINDFIRST THEN
                BudgetGL := FAPostingGroup."Acquisition Cost Account"
            ELSE
                IF PurchLine.Type = PurchLine.Type::"G/L Account" THEN
                    BudgetGL := PurchLine."No.";

            REPEAT
                BudgetAmount := PurchLine.Quantity * PurchLine."Unit Cost";
                Commitments.RESET;
                Commitments.INIT;
                Commitments."Line No." := 0;
                Commitments.Date := TODAY;
                Commitments."Posting Date" := PurchHeader."Document Date";
                Commitments."Document Type" := Commitments."Document Type"::Requisition;
                Commitments."Document No." := PurchHeader."No.";
                Commitments.Amount := -BudgetAmount;
                Commitments.Committed := FALSE;
                Commitments."Committed By" := USERID;
                Commitments."Committed Date" := PurchHeader."Document Date";
                Commitments."G/L Account No." := BudgetGL;
                Commitments."Committed Time" := TIME;
                Commitments.Cancelled := TRUE;
                Commitments."Cancelled By" := USERID;
                Commitments."Cancelled Date" := TODAY;
                Commitments."Shortcut Dimension 1 Code" := PurchLine."Global Dimension 1 Code";
                Commitments."Shortcut Dimension 2 Code" := PurchLine."Global Dimension 2 Code";
                Commitments."Shortcut Dimension 3 Code" := PurchLine."Shortcut Dimension 3 Code";
                Commitments."Shortcut Dimension 4 Code" := PurchLine."Shortcut Dimension 4 Code";
                Commitments.Committed := TRUE;
                Commitments.Budget := BCSetup."Current Budget Code";
                IF Commitments.INSERT THEN BEGIN
                    PurchLine.Committed := FALSE;
                    PurchLine.MODIFY;
                END;
            UNTIL PurchLine.NEXT = 0;
        END;
    end;

    procedure CheckIfGLAccountBlocked(BudgetName: Code[20])
    var
        GLBudgetName: Record 95;
    begin
        GLBudgetName.GET(BudgetName);
        GLBudgetName.TESTFIELD(Blocked, FALSE);
    end;

    procedure SenderTenderEvaluationEmail(TenderNo: Code[30])
    var
        TenderEvaluators: Record 50044;
        TenderEvaluatorsEmail: List of [Text];
    begin
        /* SMTP.GET;
        TenderEvaluators.RESET;
        TenderEvaluators.SETRANGE(TenderEvaluators."Tender No", TenderNo);
        TenderEvaluators.SETFILTER(TenderEvaluators."E-Mail", '<>%1', '');
        IF TenderEvaluators.FINDSET THEN BEGIN
            REPEAT
                TenderEvaluatorsEmail.Add(TenderEvaluators."E-Mail");
                SMTPMail.CreateMessage(SMTP."Sender Name", SMTP."User ID", TenderEvaluatorsEmail, 'Tender Evaluation - ' + TenderEvaluators."Tender No", '', TRUE);
                SMTPMail.AppendBody('Dear' + ' ' + TenderEvaluators."Evaluator Name" + ',');
                SMTPMail.AppendBody('<br><br>');
                SMTPMail.AppendBody('You are invited for the tender evaluation exercise for the mentioned tender as assigned.');
                SMTPMail.AppendBody('__________________________________________________________________________________________________<br>');
                SMTPMail.AppendBody('Regards.');
                SMTPMail.AppendBody('<br><br>');
                SMTPMail.AppendBody('ICDC Procurement Department');
                SMTPMail.AppendBody('<br><br>');
                SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this Email');
                SMTPMail.Send;
            UNTIL TenderEvaluators.NEXT = 0; 
        END;*/
    end;

    procedure CreateEmailToApplicantOnSubmitApplication("RFQNo.": Code[20])
    var
        SenderName: Text[100];
        SenderAddress: Text[80];
        Subject: Text[100];
        Recipients: Text[250];
        RecipientsCC: Text[250];
        RecipientsBCC: Text[250];
        EmailBody: Text;
        CurrencyCode: Code[30];
        GeneralLedgerSetup: Record 98;
    begin
        /*GeneralLedgerSetup.RESET;
        GeneralLedgerSetup.GET;
        
        RequestforQuotationHeader.RESET;
        RequestforQuotationHeader.GET("RFQNo.");
        
        
        
        IF RequestforQuotationHeader."Currency Code"='' THEN
          CurrencyCode:=GeneralLedgerSetup."LCY Code"
        ELSE
          CurrencyCode:=RequestforQuotationHeader."Currency Code";
        
        //EmailMessageBody.GET;
        
        EmailBody:='';
        EmailBody:='Dear '+RequestforQuotationHeader.Name+',<br><br>';
        EmailBody:=EmailBody+'Your application has successfully been submitted to ICDC. All correspondences relating to your application will be sent through your email.<br>Below are the application details:<br>';
        EmailBody:=EmailBody+'<table>';
        EmailBody:=EmailBody+'<tr><td>Application No.</td><td>'+RequestforQuotationHeader."No."+'</td></tr>';
        EmailBody:=EmailBody+'<tr><td>Application Type</td><td>'+FORMAT(RequestforQuotationHeader."Application Type")+'</td></tr>';
        EmailBody:=EmailBody+'<tr><td>Product Category</td><td>'+FORMAT(RequestforQuotationHeader."Product Category")+'</td></tr>';
        EmailBody:=EmailBody+'<tr><td>Product Name</td><td>'+InvestmentProduct."Product Description"+'</td></tr>';
        EmailBody:=EmailBody+'<tr><td>Applied Amount</td><td>'+CurrencyCode+':'+FORMAT(RequestforQuotationHeader."Applied Amount")+'</td></tr>';
        EmailBody:=EmailBody+'</table>';
        EmailBody:=EmailBody+'<br><br>';
        EmailBody:=EmailBody+'Kind Regards<br>';
        EmailBody:=EmailBody+'ICDC Marketing Department<br>';
        EmailBody:=EmailBody+'<br><br>';
        EmailBody:=EmailBody+EmailBodySeparator+'<br>';
        EmailBody:=EmailBody+EmailBodyFooter+'<br>';
        
        SMTPMail.GET;
        SenderName:='ICDC';
        SenderAddress:=SMTPMail."User ID";
        Subject:=InvestmentProduct."Product Description"+' Application.';
        Recipients:=RequestforQuotationHeader."Email Address"+';'+RequestforQuotationHeader."Contact Person E-Mail";
        RecipientsCC:=RequestforQuotationHeader."Alternative Email Address";
        RecipientsBCC:='';
        
        InsertInvestmentEmailMessage(SenderName,SenderAddress,Subject,Recipients,RecipientsCC,RecipientsBCC,EmailBody);
        */

    end;


    procedure CreatePurchaseOrder(var PurchaseRequisitions: Record 50046)
    var
        PurchaseRequisitionLine: Record 50047;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchaseHeaderCopy: Record 38;
        Lineno: Integer;
        PurchaseLine2: Record 39;
        Orders: Text;
    begin
        WITH PurchaseRequisitions
          DO BEGIN
            PurchaseRequisitionLine.RESET;
            PurchaseRequisitionLine.SETRANGE("Document No.", "No.");
            IF PurchaseRequisitionLine.FINDFIRST THEN
                REPEAT
                    PurchaseRequisitionLine.TESTFIELD("Vendor No");
                    PurchaseRequisitionLine.TESTFIELD("Unit Cost");
                    PurchaseRequisitionLine.TESTFIELD("No.");
                    PurchaseHeaderCopy.RESET;
                    PurchaseHeaderCopy.SETRANGE("Purchase Requisition", "No.");
                    PurchaseHeaderCopy.SETRANGE("Buy-from Vendor No.", PurchaseRequisitionLine."Vendor No");

                    IF PurchaseHeaderCopy.FINDFIRST THEN BEGIN
                        Lineno := 0;
                        PurchaseLine2.RESET;
                        PurchaseLine2.SETRANGE("Document No.", PurchaseHeaderCopy."No.");
                        IF PurchaseLine2.FINDLAST THEN
                            Lineno := PurchaseLine2."Line No.";
                        Lineno := Lineno + 1000;
                        PurchaseLine.INIT;
                        PurchaseLine."Line No." := Lineno;
                        PurchaseLine."Document No." := PurchaseHeaderCopy."No.";
                        PurchaseLine.VALIDATE("Document Type", PurchaseHeaderCopy."Document Type");
                        PurchaseLine.VALIDATE("Buy-from Vendor No.", "Vendor No");
                        IF PurchaseRequisitionLine."Requisition Type" = PurchaseRequisitionLine."Requisition Type"::Item THEN
                            PurchaseLine.Type := PurchaseLine.Type::Item
                        ELSE
                            IF PurchaseRequisitionLine."Requisition Type" = PurchaseRequisitionLine."Requisition Type"::Service THEN
                                PurchaseLine.Type := PurchaseLine.Type::"G/L Account"
                            ELSE
                                IF PurchaseRequisitionLine."Requisition Type" = PurchaseRequisitionLine."Requisition Type"::"Fixed Asset" THEN
                                    PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        PurchaseLine.VALIDATE("No.", PurchaseRequisitionLine."No.");
                        PurchaseLine.Description := PurchaseRequisitionLine.Description;
                        PurchaseLine."Description 2" := PurchaseRequisitionLine.Description;
                        PurchaseLine.VALIDATE(Quantity, PurchaseRequisitionLine.Quantity);
                        PurchaseLine."Location Code" := PurchaseRequisitionLine."Location Code";
                        //   PurchaseLine.VALIDATE("Unit Amount", PurchaseRequisitionLine."Unit Cost");
                        PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", PurchaseRequisitionLine."Global Dimension 1 Code");
                        PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", PurchaseRequisitionLine."Global Dimension 2 Code");
                        PurchaseLine.INSERT;
                        PurchaseRequisitionLine."Order No." := PurchaseHeaderCopy."No.";
                        PurchaseRequisitionLine.MODIFY;
                    END ELSE BEGIN
                        //TESTFIELD("Order No.",'')y
                        //TESTFIELD("Vendor No");
                        PurchasesPayablesSetup.GET;
                        PurchaseHeader.INIT;
                        PurchaseHeader."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Order Nos.", TODAY, TRUE);
                        PurchaseHeader.VALIDATE("Document Type", PurchaseHeader."Document Type"::Order);
                        PurchaseHeader.VALIDATE("Document Date", PurchaseRequisitions."Document Date");
                        PurchaseHeader.VALIDATE("Posting Date", PurchaseRequisitions."Document Date");
                        PurchaseHeader."User ID" := USERID;
                        PurchaseHeader."Currency Code" := "Currency Code";
                        PurchaseHeader."Purchase Requisition" := "No.";
                        PurchaseHeader.VALIDATE("Buy-from Vendor No.", PurchaseRequisitionLine."Vendor No");

                        PurchaseHeader.INSERT(TRUE);
                        COMMIT;
                        Lineno := 0;


                        Lineno := Lineno + 1000;
                        PurchaseLine.INIT;
                        PurchaseLine."Line No." := Lineno;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine.VALIDATE("Document Type", PurchaseHeader."Document Type");
                        PurchaseLine.VALIDATE("Buy-from Vendor No.", "Vendor No");
                        IF PurchaseRequisitionLine."Requisition Type" = PurchaseRequisitionLine."Requisition Type"::Item THEN
                            PurchaseLine.Type := PurchaseLine.Type::Item
                        ELSE
                            IF PurchaseRequisitionLine."Requisition Type" = PurchaseRequisitionLine."Requisition Type"::Service THEN
                                PurchaseLine.Type := PurchaseLine.Type::"G/L Account"
                            ELSE
                                IF PurchaseRequisitionLine."Requisition Type" = PurchaseRequisitionLine."Requisition Type"::"Fixed Asset" THEN
                                    PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        PurchaseLine.VALIDATE("No.", PurchaseRequisitionLine."No.");
                        PurchaseLine.Description := PurchaseRequisitionLine.Description;
                        PurchaseLine."Description 2" := PurchaseRequisitionLine.Description;
                        PurchaseLine.VALIDATE(Quantity, PurchaseRequisitionLine.Quantity);
                        PurchaseLine."Location Code" := PurchaseRequisitionLine."Location Code";
                        PurchaseLine.VALIDATE("Unit Amount", PurchaseRequisitionLine."Unit Cost");
                        PurchaseLine.VALIDATE(Quantity, PurchaseRequisitionLine.Quantity);
                        PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", PurchaseRequisitionLine."Global Dimension 1 Code");
                        PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", PurchaseRequisitionLine."Global Dimension 2 Code");
                        PurchaseLine.INSERT;
                        PurchaseRequisitionLine."Order No." := PurchaseHeader."No.";
                        PurchaseRequisitionLine.MODIFY;
                    END;

                UNTIL PurchaseRequisitionLine.NEXT = 0;
            //"Order No.":=PurchaseHeader."No.";
            Status := Status::Closed;
            MODIFY;
            PurchaseHeaderCopy.RESET;
            PurchaseHeaderCopy.SETRANGE("Purchase Requisition", "No.");
            IF PurchaseHeaderCopy.FINDFIRST THEN
                REPEAT
                    Orders := Orders + ',' + PurchaseHeaderCopy."No.";
                UNTIL PurchaseHeaderCopy.NEXT = 0;
            MESSAGE('Purchase order %1 created succesfully', Orders);
        END;
    end;


    procedure CreatePurchaseQuotes(var RequestforQuotationHeader: Record 50049)
    var
        RequestforQuotationLine: Record 50050;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchaseHeaderCopy: Record 38;
        Lineno: Integer;
        PurchaseLine2: Record 39;
        Orders: Text;
        RequestforQuotationVendors: Record 50051;
    begin
        PurchaseHeaderCopy.RESET;

        PurchaseHeaderCopy.SETRANGE("Document Type", PurchaseHeaderCopy."Document Type"::Quote);
        PurchaseHeaderCopy.SETRANGE("Request for Quotation Code", RequestforQuotationHeader."No.");
        IF PurchaseHeaderCopy.FINDFIRST THEN
            ERROR('Quotes have already been created for this document');
        RequestforQuotationVendor.RESET;
        RequestforQuotationVendor.SETRANGE("RFQ Document No.", RequestforQuotationHeader."No.");
        IF RequestforQuotationVendor.FINDFIRST THEN
            REPEAT
                Lineno := 0;
                PurchasesPayablesSetup.GET;
                PurchaseHeader.INIT;
                PurchaseHeader."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Quote Nos.", TODAY, TRUE);
                PurchaseHeader.VALIDATE("Document Type", PurchaseHeader."Document Type"::Quote);
                PurchaseHeader.VALIDATE("Document Date", RequestforQuotationHeader."Document Date");
                PurchaseHeader.VALIDATE("Posting Date", RequestforQuotationHeader."Document Date");
                PurchaseHeader."User ID" := USERID;
                //PurchaseHeader."Currency Code":="Currency Code";
                PurchaseHeader."Request for Quotation Code" := RequestforQuotationHeader."No.";
                PurchaseHeader.VALIDATE("Buy-from Vendor No.", RequestforQuotationVendor."Vendor No.");
                PurchaseHeader.INSERT(TRUE);
                RequestforQuotationLine.RESET;
                RequestforQuotationLine.SETRANGE("Document No.", RequestforQuotationHeader."No.");
                IF RequestforQuotationLine.FINDFIRST THEN
                    REPEAT
                        Lineno := Lineno + 1000;
                        PurchaseLine.INIT;
                        PurchaseLine."Line No." := Lineno;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine.VALIDATE("Document Type", PurchaseHeader."Document Type");
                        PurchaseLine.VALIDATE("Buy-from Vendor No.", RequestforQuotationVendor."Vendor No.");
                        PurchaseLine.VALIDATE(Type, RequestforQuotationLine.Type);

                        PurchaseLine.VALIDATE("No.", RequestforQuotationLine."No.");
                        PurchaseLine.Description := RequestforQuotationLine.Description;
                        PurchaseLine."Description 2" := RequestforQuotationLine.Description;
                        PurchaseLine.VALIDATE(Quantity, RequestforQuotationLine.Quantity);
                        PurchaseLine."Location Code" := RequestforQuotationLine."Location Code";
                        PurchaseLine.VALIDATE("Unit Amount", 0);
                        PurchaseLine.VALIDATE(Quantity, RequestforQuotationLine.Quantity);
                        PurchaseLine.VALIDATE("Unit Amount", 0);
                        PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", RequestforQuotationLine."Global Dimension 1 Code");
                        PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", RequestforQuotationLine."Global Dimension 2 Code");
                        PurchaseLine.INSERT;
                    UNTIL RequestforQuotationLine.NEXT = 0;

            UNTIL RequestforQuotationVendor.NEXT = 0;
        MESSAGE('Purchase Quotes Created succesfully', Orders);


        /*
            IF PurchaseHeaderCopy.FINDFIRST THEN
              BEGIN
                Lineno:=0 ;
                PurchaseLine2.RESET;
                PurchaseLine2.SETRANGE("Document No.",PurchaseHeaderCopy."No.");
                IF PurchaseLine2.FINDLAST THEN
                Lineno:=PurchaseLine2."Line No.";
                Lineno:=Lineno+1000;
                PurchaseLine.INIT;
                PurchaseLine."Line No.":=Lineno;
                PurchaseLine."Document No.":=PurchaseHeaderCopy."No.";
                PurchaseLine.VALIDATE("Document Type",PurchaseHeaderCopy."Document Type");
                PurchaseLine.VALIDATE("Buy-from Vendor No.","Vendor No");
                IF PurchaseRequisitionLine."Requisition Type"=PurchaseRequisitionLine."Requisition Type"::Item THEN
                PurchaseLine.Type:= PurchaseLine.Type::Item
                ELSE IF PurchaseRequisitionLine."Requisition Type"=PurchaseRequisitionLine."Requisition Type"::Service THEN
                PurchaseLine.Type:= PurchaseLine.Type::"G/L Account"
                ELSE IF  PurchaseRequisitionLine."Requisition Type"=PurchaseRequisitionLine."Requisition Type"::"Fixed Asset" THEN
                PurchaseLine.Type:= PurchaseLine.Type::"Fixed Asset";
                PurchaseLine.VALIDATE("No.",PurchaseRequisitionLine."No.");
                PurchaseLine.Description:=PurchaseRequisitionLine.Description;
                PurchaseLine."Description 2":=PurchaseRequisitionLine.Description;
                PurchaseLine.VALIDATE(Quantity,PurchaseRequisitionLine.Quantity);
                PurchaseLine."Location Code":=PurchaseRequisitionLine."Location Code";
                PurchaseLine.VALIDATE("Unit Amount",PurchaseRequisitionLine."Unit Cost");
                PurchaseLine.VALIDATE("Shortcut Dimension 1 Code",PurchaseRequisitionLine."Global Dimension 1 Code");
                PurchaseLine.VALIDATE("Shortcut Dimension 2 Code",PurchaseRequisitionLine."Global Dimension 2 Code");
                PurchaseLine.INSERT;
        PurchaseRequisitionLine."Order No.":=PurchaseHeaderCopy."No.";
                PurchaseRequisitionLine.MODIFY;
            END  ELSE BEGIN
            //TESTFIELD("Order No.",'')y
            //TESTFIELD("Vendor No");
            PurchasesPayablesSetup.GET;
            PurchaseHeader.INIT;
            PurchaseHeader."No.":=NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Order Nos.",TODAY,TRUE);
            PurchaseHeader.VALIDATE("Document Type",PurchaseHeader."Document Type"::Order);
            PurchaseHeader.VALIDATE("Document Date",PurchaseRequisitions."Document Date");
            PurchaseHeader.VALIDATE("Posting Date",PurchaseRequisitions."Document Date");
            PurchaseHeader."User ID":=USERID;
            PurchaseHeader."Currency Code":="Currency Code";
            PurchaseHeader."Purchase Requisition":="No.";
            PurchaseHeader.VALIDATE("Buy-from Vendor No.",PurchaseRequisitionLine."Vendor No");
        
             PurchaseHeader.INSERT;
             COMMIT;
            Lineno:=0 ;
        
        
                    Lineno:=Lineno+1000;
                PurchaseLine.INIT;
                PurchaseLine."Line No.":=Lineno;
                PurchaseLine."Document No.":=PurchaseHeader."No.";
                PurchaseLine.VALIDATE("Document Type",PurchaseHeader."Document Type");
                PurchaseLine.VALIDATE("Buy-from Vendor No.","Vendor No");
                IF PurchaseRequisitionLine."Requisition Type"=PurchaseRequisitionLine."Requisition Type"::Item THEN
                PurchaseLine.Type:= PurchaseLine.Type::Item
                ELSE IF PurchaseRequisitionLine."Requisition Type"=PurchaseRequisitionLine."Requisition Type"::Service THEN
                PurchaseLine.Type:= PurchaseLine.Type::"G/L Account"
                ELSE IF  PurchaseRequisitionLine."Requisition Type"=PurchaseRequisitionLine."Requisition Type"::"Fixed Asset" THEN
                PurchaseLine.Type:= PurchaseLine.Type::"Fixed Asset";
                PurchaseLine.VALIDATE("No.",PurchaseRequisitionLine."No.");
                PurchaseLine.Description:=PurchaseRequisitionLine.Description;
                PurchaseLine."Description 2":=PurchaseRequisitionLine.Description;
                PurchaseLine.VALIDATE(Quantity,PurchaseRequisitionLine.Quantity);
                PurchaseLine."Location Code":=PurchaseRequisitionLine."Location Code";
                PurchaseLine.VALIDATE("Unit Amount",PurchaseRequisitionLine."Unit Cost");
                PurchaseLine.VALIDATE(Quantity,PurchaseRequisitionLine.Quantity);
                PurchaseLine.VALIDATE("Shortcut Dimension 1 Code",PurchaseRequisitionLine."Global Dimension 1 Code");
                PurchaseLine.VALIDATE("Shortcut Dimension 2 Code",PurchaseRequisitionLine."Global Dimension 2 Code");
                PurchaseLine.INSERT;
                PurchaseRequisitionLine."Order No.":=PurchaseHeader."No.";
                PurchaseRequisitionLine.MODIFY;
                END;
        
                UNTIL PurchaseRequisitionLine.NEXT=0;
           //"Order No.":=PurchaseHeader."No.";
           Status:=Status::Closed;
           MODIFY;
            PurchaseHeaderCopy.RESET;
            PurchaseHeaderCopy.SETRANGE("Purchase Requisition","No.");
            IF PurchaseHeaderCopy.FINDFIRST THEN
              REPEAT
           Orders:=Orders+','+PurchaseHeaderCopy."No.";
              UNTIL PurchaseHeaderCopy.NEXT=0;
               MESSAGE('Purchase order %1 created succesfully', Orders);
          END;
          */

    end;


    procedure CreatePurchaseOrderRFQ(var RequestforQuotationHeader: Record 50049)
    var
        RequestforQuotationLine: Record 50050;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchaseHeaderCopy: Record 38;
        Lineno: Integer;
        PurchaseLine2: Record 39;
        Orders: Text;
        RequestforQuotationVendors: Record 50051;
    begin
        PurchaseHeaderCopy.RESET;

        PurchaseHeaderCopy.SETRANGE("Document Type", PurchaseHeaderCopy."Document Type"::Order);
        PurchaseHeaderCopy.SETRANGE("Request for Quotation Code", RequestforQuotationHeader."No.");
        IF PurchaseHeaderCopy.FINDFIRST THEN
            ERROR('LPOS have already been created for this document');

        Lineno := 0;
        PurchasesPayablesSetup.GET;

        RequestforQuotationLine.RESET;
        RequestforQuotationLine.SETRANGE("Document No.", RequestforQuotationHeader."No.");
        IF RequestforQuotationLine.FINDFIRST THEN
            REPEAT
                RequestforQuotationLine.TESTFIELD(Quantity);
                RequestforQuotationLine.TESTFIELD("Unit Cost");
                RequestforQuotationLine.TESTFIELD("Vendor No");
                Lineno := Lineno + 1000;
                PurchaseHeaderCopy.SETRANGE("Document Type", PurchaseHeaderCopy."Document Type"::Order);
                PurchaseHeaderCopy.SETRANGE("Request for Quotation Code", RequestforQuotationHeader."No.");
                PurchaseHeaderCopy.SETRANGE("Buy-from Vendor No.", RequestforQuotationLine."Vendor No");
                IF PurchaseHeaderCopy.FINDFIRST THEN BEGIN
                    PurchaseLine.INIT;
                    PurchaseLine."Line No." := Lineno;
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine.VALIDATE("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.VALIDATE("Buy-from Vendor No.", RequestforQuotationLine."Vendor No");
                    PurchaseLine.VALIDATE(Type, RequestforQuotationLine.Type);

                    PurchaseLine.VALIDATE("No.", RequestforQuotationLine."No.");
                    PurchaseLine.Description := RequestforQuotationLine.Description;
                    PurchaseLine."Description 2" := RequestforQuotationLine.Description;
                    PurchaseLine.VALIDATE(Quantity, RequestforQuotationLine.Quantity);
                    PurchaseLine."Location Code" := RequestforQuotationLine."Location Code";
                    PurchaseLine.VALIDATE("Unit Amount", RequestforQuotationLine."Unit Cost");
                    PurchaseLine.VALIDATE(Quantity, RequestforQuotationLine.Quantity);
                    PurchaseLine.VALIDATE("Unit Amount", RequestforQuotationLine."Unit Cost");
                    PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", RequestforQuotationLine."Global Dimension 1 Code");
                    PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", RequestforQuotationLine."Global Dimension 2 Code");
                    PurchaseLine.INSERT;
                END ELSE BEGIN
                    PurchaseHeader.INIT;
                    PurchaseHeader."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Order Nos.", TODAY, TRUE);
                    PurchaseHeader.VALIDATE("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.VALIDATE("Document Date", RequestforQuotationHeader."Document Date");
                    PurchaseHeader.VALIDATE("Posting Date", RequestforQuotationHeader."Document Date");
                    PurchaseHeader."User ID" := USERID;
                    //PurchaseHeader."Currency Code":="Currency Code";
                    PurchaseHeader."Request for Quotation Code" := RequestforQuotationHeader."No.";
                    PurchaseHeader.VALIDATE("Buy-from Vendor No.", RequestforQuotationLine."Vendor No");
                    PurchaseHeader.INSERT(TRUE);
                    PurchaseLine.INIT;
                    PurchaseLine."Line No." := Lineno;
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine.VALIDATE("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.VALIDATE("Buy-from Vendor No.", RequestforQuotationLine."Vendor No");
                    PurchaseLine.VALIDATE(Type, RequestforQuotationLine.Type);

                    PurchaseLine.VALIDATE("No.", RequestforQuotationLine."No.");
                    PurchaseLine.Description := RequestforQuotationLine.Description;
                    PurchaseLine."Description 2" := RequestforQuotationLine.Description;
                    PurchaseLine.VALIDATE(Quantity, RequestforQuotationLine.Quantity);
                    PurchaseLine."Location Code" := RequestforQuotationLine."Location Code";
                    PurchaseLine.VALIDATE("Unit Amount", RequestforQuotationLine."Unit Cost");
                    PurchaseLine.VALIDATE(Quantity, RequestforQuotationLine.Quantity);
                    PurchaseLine.VALIDATE("Unit Amount", RequestforQuotationLine."Unit Cost");

                    PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", RequestforQuotationLine."Global Dimension 1 Code");
                    PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", RequestforQuotationLine."Global Dimension 2 Code");
                    PurchaseLine.INSERT;
                END;
                RequestforQuotationLine."Order No." := PurchaseHeader."No.";
                RequestforQuotationLine.MODIFY;
            UNTIL RequestforQuotationLine.NEXT = 0;

        RequestforQuotationHeader.Status := RequestforQuotationHeader.Status::Closed;
        RequestforQuotationHeader.MODIFY;
        PurchaseHeaderCopy.RESET;
        PurchaseHeaderCopy.SETRANGE("Request for Quotation Code", RequestforQuotationHeader."No.");
        PurchaseHeaderCopy.SETRANGE("Document Type", PurchaseHeaderCopy."Document Type"::Order);
        IF PurchaseHeaderCopy.FINDFIRST THEN
            REPEAT
                Orders := Orders + ',' + PurchaseHeaderCopy."No.";
            UNTIL PurchaseHeaderCopy.NEXT = 0;
        MESSAGE('Purchase Orders %1 Created succesfully', Orders);
    end;

    procedure CreatePettyCash(PurchaseRequisitions: Record 50046)
    var
        ImprestHeader: Record 50008;
        PurchaseRequisitionLine: Record 50047;
        ImprestLine: Record 50009;
        LineNo: Integer;
        UserSetupRec: Record "User Setup";
    begin

        FundsGeneralSetup.RESET;
        FundsGeneralSetup.GET;
        UserSetupRec.get(UserId);
        Employee.RESET;
        Employee.SETRANGE("No.", UserSetupRec."Employee No");
        Employee.FINDFIRST;
        ImprestHeader.INIT;
        ImprestHeader."No." := NoSeriesMgt.GetNextNo(FundsGeneralSetup."Imprest Nos.", 0D, TRUE);
        ImprestHeader."Employee No." := Employee."No.";
        ImprestHeader.VALIDATE(ImprestHeader."Employee No.");
        ImprestHeader."User ID" := USERID;
        ImprestHeader."Document Date" := TODAY;
        ImprestHeader."Posting Date" := TODAY;
        ImprestHeader.Type := ImprestHeader.Type::"Petty Cash";
        ImprestHeader."Document Type" := ImprestHeader."Document Type"::Imprest;
        ImprestHeader."Date From" := TODAY;
        ImprestHeader."Date To" := TODAY;
        ImprestHeader.VALIDATE("Date To");
        ImprestHeader.Description := PurchaseRequisitions.Description;
        ImprestHeader."Created By" := Employee."No.";
        ImprestHeader."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
        ImprestHeader.VALIDATE(ImprestHeader."Global Dimension 1 Code");
        ImprestHeader."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
        // ImprestHeader."Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
        ImprestHeader."Purchase Requisition No" := PurchaseRequisitions."No.";
        ImprestHeader.INSERT;
        LineNo := 0;
        PurchaseRequisitionLine.RESET;
        PurchaseRequisitionLine.SETRANGE(PurchaseRequisitionLine."Document No.", PurchaseRequisitions."No.");
        IF PurchaseRequisitionLine.FINDSET THEN
            REPEAT
                PurchaseRequisitionLine.TESTFIELD("Imprest Code");
                LineNo := LineNo + 1;
                ImprestLine.INIT;
                ImprestLine."Line No." := LineNo;
                ImprestLine."Document No." := ImprestHeader."No.";
                ImprestLine."Imprest Code" := PurchaseRequisitionLine."Imprest Code";
                ImprestLine.VALIDATE(ImprestLine."Imprest Code");
                ImprestLine.Quantity := PurchaseRequisitionLine.Quantity;
                ImprestLine."Unit Amount" := PurchaseRequisitionLine."Unit Cost";
                ImprestLine.Description := PurchaseRequisitionLine.Description;
                ImprestLine."Gross Amount" := ImprestLine."Unit Amount" * ImprestLine.Quantity;
                ImprestLine.VALIDATE(ImprestLine."Gross Amount");
                ImprestLine.INSERT;

            UNTIL PurchaseRequisitionLine.NEXT = 0;
        PurchaseRequisitions.Status := PurchaseRequisitions.Status::Closed;
        PurchaseRequisitions.MODIFY;
        MESSAGE('Petty Cash No %1 Created Successfully', ImprestHeader."No.");
    end;
}


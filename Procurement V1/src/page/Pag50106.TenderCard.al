page 50106 "Tender Card"
{
    PageType = Card;
    SourceTable = 50055;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Tender Description"; Rec."Tender Description")
                {
                    MultiLine = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Tender Type"; Rec."Tender Type")
                {
                    ApplicationArea = All;
                }
                field("Purchase Requisition"; Rec."Purchase Requisition")
                {
                    ApplicationArea = All;
                }
                field("Purchase Req. Description"; Rec."Purchase Req. Description")
                {
                    ApplicationArea = All;
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                    ApplicationArea = All;
                }
                field("Supplier Category Description"; Rec."Supplier Category Description")
                {
                    ApplicationArea = All;
                }
                field("Tender Submission (From)"; Rec."Tender Submission (From)")
                {
                    ApplicationArea = All;
                }
                field("Tender Submission (To)"; Rec."Tender Submission (To)")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Held By"; Rec."Held By")
                {
                    ApplicationArea = All;
                }
                field("Tender Closing Date"; Rec."Tender Closing Date")
                {
                    ApplicationArea = All;
                }
                field("Award Date"; Rec."Award Date")
                {
                    ApplicationArea = All;
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ApplicationArea = All;
                }
                field("Tender Status"; Rec."Tender Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50107)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            part(sbpg1; 50078)
            {
                SubPageLink = "Tender No" = FIELD("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Tender Required Attachments")
            {
                Image = ApprovalSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50119;
                RunPageLink = Code = FIELD("No.");
                ApplicationArea = All;
            }
            action("Purchase Requisition Lines")
            {
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50084;
                RunPageLink = "Document No." = FIELD("Purchase Requisition");
                ApplicationArea = All;
            }
            action("Close Tender")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    Rec.TESTFIELD("Purchase Requisition");
                    Rec.TESTFIELD("Tender Submission (From)");
                    Rec.TESTFIELD("Tender Submission (To)");

                    Rec.TESTFIELD("Tender Status", Rec."Tender Status"::"Tender Evaluation");

                    IF CONFIRM(Txt061) = FALSE THEN EXIT;

                    Rec."Tender Status" := Rec."Tender Status"::Closed;

                    MESSAGE(TenderClosed);
                end;
            }
            action("Print Tender List")
            {
                Caption = 'Print Tender List';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Prepare to print the document. A report request window where you can specify what to include on the print-out.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TenderHeader.RESET;
                    TenderHeader.SETRANGE(TenderHeader."No.", Rec."No.");
                    IF TenderHeader.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(REPORT::"Tender Listing", TRUE, FALSE, TenderHeader);
                    END;
                end;
            }
            action("Send To Tender Open. Committee")
            {
                Caption = 'Send to Tender Opening committee';
                Image = Migration;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Purchase Requisition");
                    Rec.TESTFIELD("Tender Description");
                    Rec.TESTFIELD("Tender Submission (From)");
                    Rec.TESTFIELD("Tender Submission (To)");
                    Rec.TESTFIELD("Supplier Category");
                    Rec.TESTFIELD(Status, Rec.Status::Approved);

                    //Check required documents attached.
                    ProcurementUploadDocuments.RESET;
                    ProcurementUploadDocuments.SETRANGE(ProcurementUploadDocuments.Type, ProcurementUploadDocuments.Type::Tender);
                    ProcurementUploadDocuments.SETRANGE(ProcurementUploadDocuments."Tender Stage", ProcurementUploadDocuments."Tender Stage"::"Tender Preparation");
                    IF ProcurementUploadDocuments.FINDSET THEN BEGIN
                        REPEAT
                            VendorRequiredDocuments.RESET;
                            VendorRequiredDocuments.SETRANGE(VendorRequiredDocuments.Code, Rec."No.");
                            VendorRequiredDocuments.SETRANGE(VendorRequiredDocuments."Document Code", ProcurementUploadDocuments."Document Code");
                            IF VendorRequiredDocuments.FINDFIRST THEN BEGIN
                                IF NOT VendorRequiredDocuments.HASLINKS THEN BEGIN
                                    ERROR(ProcurementUploadDocuments."Document Code" + ' has not been attached. This is a required document.');
                                    BREAK;
                                    EXIT;
                                END;
                            END ELSE BEGIN
                                ERROR(ProcurementUploadDocuments."Document Code" + ' has not been attached. This is a required document.');
                                BREAK;
                                EXIT;
                            END;
                        UNTIL ProcurementUploadDocuments.NEXT = 0;
                    END;


                    Rec."Tender Status" := Rec."Tender Status"::"Tender Opening";
                    Rec."Tender Preparation Approved" := TRUE;
                    IF Rec.MODIFY THEN BEGIN

                        ProcurementUploadDocuments2.RESET;
                        ProcurementUploadDocuments2.SETRANGE(ProcurementUploadDocuments2.Type, ProcurementUploadDocuments2.Type::Tender);
                        ProcurementUploadDocuments2.SETRANGE(ProcurementUploadDocuments2."Tender Stage", ProcurementUploadDocuments2."Tender Stage"::"Tender Opening");
                        IF ProcurementUploadDocuments2.FINDSET THEN BEGIN
                            REPEAT
                                VendorDocs.INIT;
                                VendorDocs.Code := Rec."No.";
                                VendorDocs."Document Code" := ProcurementUploadDocuments2."Document Code";
                                VendorDocs."Document Description" := ProcurementUploadDocuments2."Document Description";
                                VendorDocs."Document Attached" := FALSE;
                                VendorDocs.INSERT;
                            UNTIL ProcurementUploadDocuments2.NEXT = 0;
                        END;

                        //ProcurementManagement.SenderTenderEvaluationEmail("No.");
                        MESSAGE(TenderEvaluate);
                        CurrPage.CLOSE;
                    end;
                end;
            }
            action("Get Awardee")
            {
                Image = Approval;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*TenderLines.RESET;
                    TenderLines.SETRANGE(TenderLines."Document No.","No.");
                    TenderLines.SETCURRENTKEY(TenderLines."Document No.",TenderLines."Total Assessment MRKS");
                    TenderLines.SETASCENDING("Total Assessment MRKS",FALSE);
                    IF TenderLines.FINDFIRST THEN
                    BEGIN
                    //  "Supplier Awarded":=TenderLines."Supplier No.";
                      "Supplier Name":=TenderLines."Supplier Name";
                      MODIFY;
                    END
                    */

                end;
            }
            action("Make Contract Request")
            {
                Image = CalculateDiscount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Approved);
                    Rec.TESTFIELD("Tender Status", Rec."Tender Status"::"Tender Evaluation");
                    IF CONFIRM(Txt060) = FALSE THEN EXIT;

                    ContractSetup.GET;

                    Contract.RESET;
                    Contract.SETRANGE(Contract.Type, Contract.Type::Procurement);
                    Contract.SETRANGE(Contract."Contract Link", Rec."No.");
                    IF Contract.FINDFIRST THEN BEGIN
                        ERROR(Contractexist);
                    END;

                    TempContract.INIT;
                    TempContract."Request No." := NoSeriesMgt.GetNextNo(ContractSetup."Contract Request Nos", 0D, TRUE);
                    TempContract."Document Date" := TODAY;
                    TempContract."Contract Link" := Rec."No.";
                    TempContract.Type := TempContract.Type::Procurement;
                    TempContract.Description := Rec."Tender Description";
                    TempContract."User ID" := USERID;
                    TempContract.INSERT;
                    MESSAGE(ContractCreated);
                end;
            }
            action("Contract Request Details")
            {
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Tender Evaluation Result")
            {
                Caption = 'Tender Evaluation Results';
                Image = QuestionaireSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50112;
                RunPageLink = "Tender No." = FIELD("No.");
                ApplicationArea = All;
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action(Approvals)
                {
                    AccessByPermission = TableData 454 = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    /*     RunObject = Page "Approval Entries";
                         RunPageLink = "Document No." = FIELD("No.");*/
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(Rec.RECORDID,DATABASE::"Purchase Requisition Header","No.");
                    end;
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Supplier Category");
                        Rec.TESTFIELD("Tender Description");
                        Rec.TESTFIELD("Purchase Requisition");
                        Rec.TESTFIELD("Tender Submission (From)");
                        Rec.TESTFIELD("Tender Submission (To)");


                        IF Rec."Tender Status" = Rec."Tender Status"::"Tender Preparation" THEN BEGIN
                            //Check required documents attached.
                            ProcurementUploadDocuments.RESET;
                            ProcurementUploadDocuments.SETRANGE(ProcurementUploadDocuments.Type, ProcurementUploadDocuments.Type::Tender);
                            ProcurementUploadDocuments.SETRANGE(ProcurementUploadDocuments."Tender Stage", ProcurementUploadDocuments."Tender Stage"::"Tender Preparation");
                            IF ProcurementUploadDocuments.FINDSET THEN BEGIN
                                REPEAT
                                    VendorRequiredDocuments.RESET;
                                    VendorRequiredDocuments.SETRANGE(VendorRequiredDocuments.Code, Rec."No.");
                                    VendorRequiredDocuments.SETRANGE(VendorRequiredDocuments."Document Code", ProcurementUploadDocuments."Document Code");
                                    IF VendorRequiredDocuments.FINDFIRST THEN BEGIN
                                        IF NOT VendorRequiredDocuments.HASLINKS THEN BEGIN
                                            ERROR(ProcurementUploadDocuments."Document Code" + ' has not been attached. This is a required document.');
                                            BREAK;
                                            EXIT;
                                        END;
                                    END ELSE BEGIN
                                        ERROR(ProcurementUploadDocuments."Document Code" + ' has not been attached. This is a required document.');
                                        BREAK;
                                        EXIT;
                                    END;
                                UNTIL ProcurementUploadDocuments.NEXT = 0;
                            END;
                        END;

                        IF Rec."Tender Status" = Rec."Tender Status"::"Tender Evaluation" THEN BEGIN
                            //Check required documents attached.
                            ProcurementUploadDocuments.RESET;
                            ProcurementUploadDocuments.SETRANGE(ProcurementUploadDocuments.Type, ProcurementUploadDocuments.Type::Tender);
                            ProcurementUploadDocuments.SETRANGE(ProcurementUploadDocuments."Tender Stage", ProcurementUploadDocuments."Tender Stage"::"Tender Evaluation");
                            IF ProcurementUploadDocuments.FINDSET THEN BEGIN
                                REPEAT
                                    VendorRequiredDocuments.RESET;
                                    VendorRequiredDocuments.SETRANGE(VendorRequiredDocuments.Code, Rec."No.");
                                    //MESSAGE(VendorRequiredDocuments.Code);
                                    //  ERROR("No.");
                                    VendorRequiredDocuments.SETRANGE(VendorRequiredDocuments."Document Code", ProcurementUploadDocuments."Document Code");
                                    IF VendorRequiredDocuments.FINDFIRST THEN BEGIN
                                        IF NOT VendorRequiredDocuments.HASLINKS THEN BEGIN
                                            ERROR(ProcurementUploadDocuments."Document Code" + ' has not been attached. This is a required document.');
                                            BREAK;
                                            EXIT;
                                        END;
                                    END ELSE BEGIN
                                        ERROR(ProcurementUploadDocuments."Document Code" + ' has not been attached. This is a required document.');
                                        BREAK;
                                        EXIT;
                                    END;
                                UNTIL ProcurementUploadDocuments.NEXT = 0;
                            END;
                        END;

                        IF ApprovalsMgmtExt.CheckTenderHeaderApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendTenderHeaderForApproval(Rec);

                        COMMIT;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    begin
                        ApprovalsMgmtExt.OnCancelTenderHeaderApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);

                        //CanCancelApprovalForRecord OR CanCancelApprovalForFlow
                    end;
                }
            }
            group(IncomingDocument)
            {
                Caption = 'Incoming Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    ApplicationArea = Suite;
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    ToolTip = 'View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes';

                    trigger OnAction()
                    var
                        IncomingDocument: Record 130;
                    begin
                        //IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData 130 = R;
                    ApplicationArea = Suite;
                    Caption = 'Select Incoming Document';
                    Image = SelectLineToApply;
                    ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record 130;
                    begin
                        //VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Incoming Document from File';
                    Ellipsis = true;
                    Enabled = CreateIncomingDocumentEnabled;
                    Image = Attach;
                    ToolTip = 'Create an incoming document from a file that you select from the disk. The file will be attached to the incoming document record.';

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record 133;
                    begin
                        //IncomingDocumentAttachment.NewAttachmentFromPurchaseRequisitionDocument(Rec);
                    end;
                }
                action(RemoveIncomingDoc)
                {
                    ApplicationArea = Suite;
                    Caption = 'Remove Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = RemoveLine;
                    ToolTip = 'Remove any incoming document records and file attachments.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record 130;
                    begin
                        /*IF IncomingDocument.GET("Incoming Document Entry No.") THEN
                          IncomingDocument.RemoveLinkToRelatedRecord;
                        "Incoming Document Entry No." := 0;
                        MODIFY(TRUE);
                        */

                    end;
                }
            }
        }
    }

    var
        ApprovalsMgmt: Codeunit 50082;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

        ProcurementManagement: Codeunit 50007;
        ProcurementApprovalWorkflow: Codeunit 50009;
        ApprovalsMgmtExt: Codeunit "Approval Mgt.Procurement Ext";

        PurchaseRequisitionHeader: Record 50046;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund","Purchase Requisition";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        IsEditable: Boolean;
        TenderHeader: Record 50055;
        TenderLines: Record 50056;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TenderClosed: Label 'Tender Successfully Closed';
        TenderEvaluate: Label 'Tender successfully Now Under Tender Evaluation Committee';
        Txt060: Label 'Are you sure you want to make contract request for this tender document?';
        Txt061: Label 'Are you sure you want to close this tender?';
        Contractexist: Label 'There exists a contract in relation to this tender';
        ContractCreated: Label 'Contract request successfully created. Proceed to the contract application and send to Legal Department';
        ProcurementUploadDocuments: Record 50066;
        VendorRequiredDocuments: Record 50071;
        TenderOpening: Label 'Tender successfully Now Under Tender Opening Committee';
        VendorDocs: Record 50071;
        ProcurementUploadDocuments2: Record 50066;
        TenderEvaluators: Record 50044;
        Txt100003: Label 'You must elect a chaiperson for the evaluation committee!';
        TenderEvaluationResults: Record 50057;
        ApprovalEditable: Boolean;
        ContractGroup: Record 5966;
        ContractSetup: Record 50209;
        TempContract: Record 50208;
        Contract: Record 50208;
}


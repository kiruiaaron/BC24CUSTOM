codeunit 50004 "Funds Workflow Events"
{

    trigger OnRun()
    begin
    end;

    var
        WFHandler: Codeunit 1520;
        WorkflowManagement: Codeunit 1501;

    procedure AddEventsToLibrary()
    begin
        //---------------------------------------------1. Approval Events--------------------------------------------------------------
        //Payment Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendPaymentHeaderForApprovalCode,
                                    DATABASE::"Payment Header", 'Approval of a payment document is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelPaymentHeaderApprovalRequestCode,
                                    DATABASE::"Payment Header", 'An approval request for a payment document is canceled.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnChangePaymentHeaderDocumentCode,
                                    DATABASE::"Payment Header", 'A payment document is changed.', 0, FALSE);
        //Receipt Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendReceiptHeaderForApprovalCode,
                                    DATABASE::"Receipt Header", 'Approval of a receipt is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelReceiptHeaderApprovalRequestCode,
                                    DATABASE::"Receipt Header", 'An approval request for a receipt is canceled.', 0, FALSE);
        //Funds Transfer Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendFundsTransferHeaderForApprovalCode,
                                    DATABASE::"Funds Transfer Header", 'Approval of a funds transfer is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelFundsTransferHeaderApprovalRequestCode,
                                    DATABASE::"Funds Transfer Header", 'An approval request for a funds transfer is canceled.', 0, FALSE);
        //Imprest Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendImprestHeaderForApprovalCode,
                                    DATABASE::"Imprest Header", 'Approval of an imprest is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelImprestHeaderApprovalRequestCode,
                                    DATABASE::"Imprest Header", 'An approval request for an imprest is canceled.', 0, FALSE);
        //Imprest Surrender Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendImprestSurrenderHeaderForApprovalCode,
                                    DATABASE::"Imprest Surrender Header", 'Approval of an imprest surrender is requested.', 0, FALSE);

        WFHandler.AddEventToLibrary(RunWorkflowOnCancelImprestSurrenderHeaderApprovalRequestCode,
                                    DATABASE::"Imprest Surrender Header", 'An approval request for an imprest surrender is canceled.', 0, FALSE);
        //Funds Claim Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendFundsClaimHeaderForApprovalCode,
                                    DATABASE::"Funds Claim Header", 'Approval of a funds claim document is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelFundsClaimHeaderApprovalRequestCode,
                                    DATABASE::"Funds Claim Header", 'An approval request for a funds claim document is canceled.', 0, FALSE);

        //Budget Allocation Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendBudgetAllocationHeaderForApprovalCode,
                                    DATABASE::"Budget Allocation Header", 'Approval of a budget allocation document is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelBudgetAllocationHeaderApprovalRequestCode,
                                    DATABASE::"Budget Allocation Header", 'An approval request for a budget allocation document is canceled.', 0, FALSE);

        //Document Reversal Header
        WFHandler.AddEventToLibrary(RunWorkflowOnSendDocumentReversalHeaderForApprovalCode,
                                    DATABASE::"Document Reversal Header", 'Approval of a Document Reversal document is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelDocumentReversalHeaderApprovalRequestCode,
                                    DATABASE::"Document Reversal Header", 'An approval request for a Document Reversal document is canceled.', 0, FALSE);

        //Journal Voucher
        WFHandler.AddEventToLibrary(RunWorkflowOnSendJournalVoucherForApprovalCode,
                                    DATABASE::"Journal Voucher Header", 'Approval of a Journal Voucher is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelJournalVoucherApprovalRequestCode,
                                    DATABASE::"Journal Voucher Header", 'An approval request for a Journal Voucher is canceled.', 0, FALSE);
        //Salary advance
        WFHandler.AddEventToLibrary(RunWorkflowOnSendSalaryAdvanceForApprovalCode,
                                    DATABASE::"Salary Advance", 'Approval of a salary advance is requested.', 0, FALSE);
        WFHandler.AddEventToLibrary(RunWorkflowOnCancelSalaryAdvanceApprovalRequestCode,
                                    DATABASE::"Salary Advance", 'An approval request for salary advane is canceled.', 0, FALSE);


        //-------------------------------------------End Approval Events-------------------------------------------------------------
    end;

    procedure AddEventsPredecessor()
    begin
        //--------------------------------------1.Approval,Rejection,Delegation Predecessors------------------------------------------------
        //Payment Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPaymentHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPaymentHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPaymentHeaderForApprovalCode);//Delegate

        //Receipt Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendReceiptHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendReceiptHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendReceiptHeaderForApprovalCode);//Delegate

        //Funds Transfer Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendFundsTransferHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendFundsTransferHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendFundsTransferHeaderForApprovalCode);//Delegate

        //Imprest Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendImprestHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendImprestHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendImprestHeaderForApprovalCode);//Delegate

        //Imprest Surrender Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendImprestSurrenderHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendImprestSurrenderHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendImprestSurrenderHeaderForApprovalCode);//Delegate

        //Funds Claim Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendFundsClaimHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendFundsClaimHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendFundsClaimHeaderForApprovalCode);//Delegate

        //Budget Allocation Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendBudgetAllocationHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendBudgetAllocationHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendBudgetAllocationHeaderForApprovalCode);//Delegate

        //Document Reversal Header
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendDocumentReversalHeaderForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendDocumentReversalHeaderForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendDocumentReversalHeaderForApprovalCode);//Delegate

        //Journal Voucher
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendJournalVoucherForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendJournalVoucherForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendJournalVoucherForApprovalCode);//Delegate

        //Salary Advance
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendSalaryAdvanceForApprovalCode);//Approve
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendSalaryAdvanceForApprovalCode);//Reject
        WFHandler.AddEventPredecessor(WFHandler.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendSalaryAdvanceForApprovalCode);//Delegate

        //---------------------------------------End Approval,Rejection,Delegation Predecessors-----------------------------------------------
    end;

    procedure RunWorkflowOnSendPaymentHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendPaymentHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelPaymentHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelPaymentHeaderApprovalRequest'));
    end;

    procedure RunWorkflowOnChangePaymentHeaderDocumentCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnChangePaymentHeaderDocument'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendPaymentHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendPaymentHeaderForApproval(var PaymentHeader: Record 50002)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPaymentHeaderForApprovalCode, PaymentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelPaymentHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelPaymentHeaderApprovalRequest(var PaymentHeader: Record 50002)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPaymentHeaderApprovalRequestCode, PaymentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendPaymentHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnChangePaymentHeaderDocument(var PaymentHeader: Record 50002)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnChangePaymentHeaderDocumentCode, PaymentHeader);
    end;

    procedure RunWorkflowOnSendReceiptHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendReceiptHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelReceiptHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelReceiptHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendReceiptHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendReceiptHeaderForApproval(var ReceiptHeader: Record 50004)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendReceiptHeaderForApprovalCode, ReceiptHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelReceiptHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelReceiptHeaderApprovalRequest(var ReceiptHeader: Record 50004)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelReceiptHeaderApprovalRequestCode, ReceiptHeader);
    end;

    procedure RunWorkflowOnSendFundsTransferHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendFundsTransferHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelFundsTransferHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelFundsTransferHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendFundsTransferHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendFundsTransferHeaderForApproval(var FundsTransferHeader: Record 50006)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendFundsTransferHeaderForApprovalCode, FundsTransferHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelFundsTransferHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelFundsTransferHeaderApprovalRequest(var FundsTransferHeader: Record 50006)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelFundsTransferHeaderApprovalRequestCode, FundsTransferHeader);
    end;

    procedure RunWorkflowOnSendImprestHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendImprestHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelImprestHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelImprestHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendImprestHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendImprestHeaderForApproval(var ImprestHeader: Record 50008)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendImprestHeaderForApprovalCode, ImprestHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelImprestHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelImprestHeaderApprovalRequest(var ImprestHeader: Record 50008)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelImprestHeaderApprovalRequestCode, ImprestHeader);
    end;

    procedure RunWorkflowOnSendImprestSurrenderHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendImprestSurrenderHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelImprestSurrenderHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelImprestSurrenderHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendImprestSurrenderHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendImprestSurrenderHeaderForApproval(var ImprestSurrender: Record 50010)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendImprestSurrenderHeaderForApprovalCode, ImprestSurrender);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelImprestSurrenderHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelImprestSurrenderHeaderApprovalRequest(var ImprestSurrender: Record 50010)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelImprestSurrenderHeaderApprovalRequestCode, ImprestSurrender);
    end;

    procedure RunWorkflowOnSendFundsClaimHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendFundsClaimHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelFundsClaimHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelFundsClaimHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendFundsClaimHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendFundsClaimHeaderForApproval(var FundsClaimHeader: Record 50012)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendFundsClaimHeaderForApprovalCode, FundsClaimHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelFundsClaimHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelFundsClaimHeaderApprovalRequest(var FundsClaimHeader: Record 50012)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelFundsClaimHeaderApprovalRequestCode, FundsClaimHeader);
    end;

    procedure RunWorkflowOnSendBudgetAllocationHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendBudgetAllocationHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelBudgetAllocationHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelBudgetAllocationHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendPaymentHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendBudgetAllocationHeaderForApproval(var PaymentHeader: Record "Payment Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendBudgetAllocationHeaderForApprovalCode, PaymentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelPaymentHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelBudgetAllocationHeaderApprovalRequest(var PaymentHeader: Record "Payment Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelBudgetAllocationHeaderApprovalRequestCode, PaymentHeader);
    end;

    procedure RunWorkflowOnSendDocumentReversalHeaderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendDocumentReversalHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelDocumentReversalHeaderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelDocumentReversalHeaderApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendDocumentReversalHeaderForApproval', '', false, false)]
    procedure RunWorkflowOnSendDocumentReversalHeaderForApproval(var DocumentReversalHeader: Record 50034)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendDocumentReversalHeaderForApprovalCode, DocumentReversalHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelDocumentReversalHeaderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelDocumentReversalHeaderApprovalRequest(var DocumentReversalHeader: Record 50034)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelDocumentReversalHeaderApprovalRequestCode, DocumentReversalHeader);
    end;

    procedure RunWorkflowOnSendJournalVoucherForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendJournalVoucherForApproval'));
    end;

    procedure RunWorkflowOnCancelJournalVoucherApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelJournalVoucherApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendJournalVoucherForApproval', '', false, false)]
    procedure RunWorkflowOnSendJournalVoucherForApproval(var JournalVoucherHeader: Record 50016)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendJournalVoucherForApprovalCode, JournalVoucherHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelJournalVoucherApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelJournalVoucherApprovalRequest(var JournalVoucherHeader: Record 50016)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelJournalVoucherApprovalRequestCode, JournalVoucherHeader);
    end;

    procedure RunWorkflowOnSendSalaryAdvanceForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendSalaryAdvanceForApproval'));
    end;

    procedure RunWorkflowOnCancelSalaryAdvanceApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelSalaryAdvanceApprovalRequest'));
    end;

    /* [EventSubscriber(ObjectType::Codeunit, 50083, 'OnSendSalaryAdvanceForApproval', '', false, false)]
    procedure RunWorkflowOnSendSalaryAdvanceForApproval(var SalaryAdvance: Record 50239)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendSalaryAdvanceForApprovalCode, SalaryAdvance);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50083, 'OnCancelSalaryAdvanceApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelSalaryAdvanceApprovalRequest(var SalaryAdvance: Record 50239)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelSalaryAdvanceApprovalRequestCode, SalaryAdvance);
    end; */
}


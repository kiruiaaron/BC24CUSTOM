page 50385 "Salary Advance Card"
{
    PageType = Card;
    SourceTable = 50239;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ID; Rec."Loan ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Employee; Rec.Employee)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Loan Types"; Rec."Loan Types")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Principal; Rec.Principal)
                {
                    ApplicationArea = All;
                }
                field("Principal (LCY)"; Rec."Principal (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Start Period"; Rec."Start Period")
                {
                    ApplicationArea = All;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Installment Amount"; Rec."Installment Amount")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CheckAthirdRule
                    end;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approvals1)
            {
                Caption = 'Approvals';
            }
            group(Group)
            {
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
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund","Purchase Requisition";
                    begin
                        //WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Payment Header",DocType::Payment,"No.");
                    end;
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                    //  ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                    begin
                        //  IF ApprovalsMgmtExt.CheckSalaryAdvanceApprovalsWorkflowEnabled(Rec) THEN
                        //    ApprovalsMgmtExt.OnSendSalaryAdvanceForApproval(Rec);

                        CurrPage.CLOSE;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        //ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                    begin
                        //   ApprovalsMgmtExt.OnCancelSalaryAdvanceApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Advance
    end;

    var
        gvAllowedPayrolls: Record 51182;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ShowWorkflowStatus: Boolean;
        PageEditable: Boolean;
        UserSetup: Record 91;
    // FundsApprovalManager: Codeunit 50003;

    procedure MarkClearedLoans()
    var
        lvLoan: Record 51171;
    begin
        //skm 130405
        lvLoan.SETRANGE(Cleared, FALSE);
        lvLoan.SETRANGE(Created, TRUE);
        IF lvLoan.FIND('-') THEN
            REPEAT
                lvLoan.CALCFIELDS("Remaining Debt");
                IF lvLoan."Remaining Debt" = 0 THEN BEGIN
                    lvLoan.Cleared := TRUE;
                    lvLoan.MODIFY
                END
            UNTIL lvLoan.NEXT = 0;

        Rec.SETRANGE(Cleared, FALSE);
    end;

    procedure CreateBatch()
    begin
        IF NOT CONFIRM('Create all loans with a tick on Create field and within your current filters?', FALSE) THEN EXIT;
        gvAllowedPayrolls.SETRANGE("User ID", USERID);
        gvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        gvAllowedPayrolls.FINDFIRST;
        Rec.SETRANGE(Create, TRUE);
        Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        IF Rec.FIND('-') THEN
            REPEAT
                Rec.CreateLoan
            UNTIL Rec.NEXT = 0;

        Rec.RESET;
        Rec.SETRANGE(Cleared, FALSE);
        MESSAGE('Loans successfully created.')
    end;

    procedure PayBatch()
    begin
        IF NOT CONFIRM('Pay all loans with a tick on Pay field and within your current filters?', FALSE) THEN EXIT;
        gvAllowedPayrolls.SETRANGE("User ID", USERID);
        gvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        gvAllowedPayrolls.FINDFIRST;
        Rec.SETRANGE(Pay, TRUE);
        Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
        IF Rec.FIND('-') THEN
            REPEAT
                Rec.PayLoan
            UNTIL Rec.NEXT = 0;

        Rec.RESET;
        Rec.SETRANGE(Cleared, FALSE);
        MESSAGE('Loans successfully paid.')
    end;

    procedure gsSegmentPayrollData()
    var
        lvAllowedPayrolls: Record 51182;
        lvPayrollUtilities: Codeunit 51152;
        UsrID: Code[10];
        UsrID2: Code[10];
        StringLen: Integer;
        lvActiveSession: Record 2000000110;
    begin
        /*lvSession.SETRANGE("My Session", TRUE);
        lvSession.FINDFIRST; //fire error in absence of a login
        IF lvSession."Login Type" = lvSession."Login Type"::Database THEN
          lvAllowedPayrolls.SETRANGE("User ID", USERID)
        ELSE*/

        lvActiveSession.RESET;
        lvActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        lvActiveSession.SETRANGE("Session ID", SESSIONID);
        lvActiveSession.FINDFIRST;


        lvAllowedPayrolls.SETRANGE("User ID", lvActiveSession."User ID");
        lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
        IF lvAllowedPayrolls.FINDFIRST THEN
            Rec.SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
        ELSE
            ERROR('You are not allowed access to this payroll dataset.');
        Rec.FILTERGROUP(100);

    end;

    local procedure CheckAthirdRule()
    begin
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit 1535;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

    begin
        //HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        //CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("No." <> '');

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);

        IF (Rec.Status = Rec.Status::Open) OR (Rec.Status = Rec.Status::"Pending Approval") THEN BEGIN
            PageEditable := TRUE;
        END ELSE BEGIN
            PageEditable := FALSE;
        END;
    end;
}


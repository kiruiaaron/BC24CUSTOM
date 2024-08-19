page 50197 "Employee Detail Update Card"
{
    PageType = Card;
    SourceTable = 50116;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the No.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the  Employee No.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the  Employee Name.';
                    ApplicationArea = All;
                }
                field("Update Option"; Rec."Update Option")
                {
                    ToolTip = 'Specifies the  update option.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the  status.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the User ID that created the document.';
                    ApplicationArea = All;
                }
            }
            group("Job Details")
            {
                field("Current Job Grade"; Rec."Current Job Grade")
                {
                    ToolTip = 'Specifies the  Current Job Grades.';
                    ApplicationArea = All;
                }
                field("New Job Grade"; Rec."New Job Grade")
                {
                    ToolTip = 'Specifies the  New Job Grade.';
                    ApplicationArea = All;
                }
            }
            group("Contact Information")
            {
            }
            group("Employee Status")
            {
                field("Current Employee Status"; Rec."Current Employee Status")
                {
                    ToolTip = 'Specifies the current Employee status.';
                    ApplicationArea = All;
                }
                field("New Employee Status"; Rec."New Employee Status")
                {
                    ToolTip = 'Specifies the New Employee status.';
                    ApplicationArea = All;
                }
            }
            group("Employee Transfer")
            {
                field("Current HR Location"; Rec."Current HR Location")
                {
                    ToolTip = 'Specifies Current HR location';
                    ApplicationArea = All;
                }
                field("New HR Location"; Rec."New HR Location")
                {
                    ToolTip = 'Specifies New HR Location.';
                    ApplicationArea = All;
                }
                field("Current HR Department"; Rec."Current HR Department")
                {
                    ToolTip = 'Specifies the current HR Deparment.';
                    ApplicationArea = All;
                }
                field("New HR Department"; Rec."New HR Department")
                {
                    ToolTip = 'Specifies the New HR deparment.';
                    ApplicationArea = All;
                }
            }
            group("Bank Information")
            {
                field("Current Bank Code"; Rec."Current Bank Code")
                {
                    ToolTip = 'Specifies the current Bank code.';
                    ApplicationArea = All;
                }
                field("Current Bank Name"; Rec."Current Bank Name")
                {
                    ToolTip = 'Specifies the  current Bank Name.';
                    ApplicationArea = All;
                }
                field("Current Bank Branch Code"; Rec."Current Bank Branch Code")
                {
                    ToolTip = 'Specifies the  current Bank Branch Code.';
                    ApplicationArea = All;
                }
                field("Current Bank Branch Name"; Rec."Current Bank Branch Name")
                {
                    ToolTip = 'Specifies the current Bank Branch Name.';
                    ApplicationArea = All;
                }
                field("Current Bank Account No."; Rec."Current Bank Account No.")
                {
                    ToolTip = 'Specifies the  current Bank Account Number.';
                    ApplicationArea = All;
                }
                field("New Bank Code"; Rec."New Bank Code")
                {
                    ToolTip = 'Specifies the New Bank Code';
                    ApplicationArea = All;
                }
                field("New Bank Name"; Rec."New Bank Name")
                {
                    ToolTip = 'Specifies the  New Bank Name.';
                    ApplicationArea = All;
                }
                field("New Bank Branch Code"; Rec."New Bank Branch Code")
                {
                    ToolTip = 'Specifies the new Bank Branch Code.';
                    ApplicationArea = All;
                }
                field("New Bank Branch Name"; Rec."New Bank Branch Name")
                {
                    ToolTip = 'Specifies the New Bank Branch Name.';
                    ApplicationArea = All;
                }
                field("New Bank Account No."; Rec."New Bank Account No.")
                {
                    ToolTip = 'Specifies the new Bank Account.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Send Approval Request';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Open);
                    /*
                    IF ApprovalsMgmtExt.CheckHREmployeeRequisitionApprovalsWorkflowEnabled(Rec) THEN
                    ApprovalsMgmtExt.OnSendHREmployeeRequisitionForApproval(Rec);
                    */

                end;
            }
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
                    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ",Payment,Receipt,Imprest,"Imprest Surrender","Funds Refund",Requisition,"Funds Transfer","HR Document";
                begin
                    //WorkflowsEntriesBuffer.RunWorkflowEntriesDocumentPage(RECORDID,DATABASE::"HR Employee Requisitions","No.");
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
                var
                    ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                // WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    /*ApprovalsMgmtExt."OnCancelHREmployee RequisitionApprovalRequest"(Rec);
                    //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);*/

                end;
            }
            action(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Open);
                    Rec.Status := Rec.Status::Approved;
                    REC.MODIFY;
                end;
            }
        }
        area(navigation)
        {
            action("Payroll Update")
            {
                Caption = 'Payroll Update';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Category4;
                /*   RunObject = Page 50426;
                  RunPageLink = "No." = FIELD("No."),
                                "Employee No." = FIELD("Employee No."); */
                ApplicationArea = All;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
}


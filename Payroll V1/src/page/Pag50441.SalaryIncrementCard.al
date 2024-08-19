page 50441 "Salary Increment Card"
{
    PageType = Card;
    SourceTable = 50252;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Increment Reason"; Rec."Increment Reason")
                {
                    ApplicationArea = All;
                }
                field(Method; Rec.Method)
                {
                    ApplicationArea = All;
                }
                field("Mass Value"; Rec."Mass Value")
                {
                    ApplicationArea = All;
                }
                field("Ed Code"; Rec."Ed Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Start Period"; Rec."Start Period")
                {
                    ApplicationArea = All;
                }
            }
            part(sbpg; 50442)
            {
                SubPageLink = "Increment Code" = FIELD(Code);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Insert All Employees")
            {
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    /*  CLEAR(InsertIncrementLines);
                     InsertIncrementLines.Setcode(Code);
                     InsertIncrementLines.RUN; */
                end;
            }
            action("Mass Update")
            {
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Method = Rec.Method::Individual THEN ERROR('Please update in the lines for Method individual');
                    Rec.TESTFIELD("Mass Value");
                    Rec.TESTFIELD("Ed Code");
                    SalaryIncrementLines.RESET;
                    SalaryIncrementLines.SETRANGE("Ed Code", Rec."Ed Code");
                    SalaryIncrementLines.SETRANGE("Increment Code", Rec.Code);
                    IF SalaryIncrementLines.FINDFIRST THEN
                        REPEAT

                            IF Rec.Method = Rec.Method::"Block Figure" THEN
                                SalaryIncrementLines.VALIDATE("Increment Value", Rec."Mass Value")
                            ELSE BEGIN
                                SalaryIncrementLines."Increment Value" := ROUND((Rec."Mass Value" / 100) * SalaryIncrementLines."Current Amount");
                                SalaryIncrementLines.VALIDATE("Increment Value");
                            END;
                            SalaryIncrementLines.MODIFY;
                        UNTIL SalaryIncrementLines.NEXT = 0;
                    MESSAGE('Update completed successfully');
                end;
            }
            action("Implement changes")
            {
                Image = PostedOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Approved);
                    Rec.TESTFIELD("Start Period");

                    SalaryIncrementLines.RESET;
                    SalaryIncrementLines.SETRANGE("Increment Code", Rec.Code);
                    IF SalaryIncrementLines.FINDFIRST THEN
                        REPEAT
                            Employee.GET(SalaryIncrementLines."Employee No");
                            PayrollSetups.GET(Employee."Payroll Code");
                            Periods.RESET;
                            Periods.SETRANGE("Period ID", Rec."Start Period");
                            Periods.SETRANGE("Payroll Code", Employee."Payroll Code");
                            Periods.FINDFIRST;
                            Periods.TESTFIELD(Status, Periods.Status::Open);
                            IF Rec."Ed Code" = PayrollSetups."Basic Pay E/D Code" THEN BEGIN
                                Employee."Fixed Pay" := SalaryIncrementLines."Proposed Amount";
                                Employee.MODIFY;
                            END;
                            PayrollEntry.RESET;
                            PayrollEntry.SETRANGE("ED Code", SalaryIncrementLines."Ed Code");
                            PayrollEntry.SETRANGE("Employee No.", SalaryIncrementLines."Employee No");
                            PayrollEntry.SETRANGE("Payroll ID", Rec."Start Period");
                            IF PayrollEntry.FINDFIRST THEN BEGIN
                                PayrollEntry.VALIDATE(Amount, SalaryIncrementLines."Proposed Amount");
                                PayrollEntry.MODIFY(TRUE);

                            END ELSE
                                ERROR('Employee %1 does not have %2 in payroll entry', Employee."No.", SalaryIncrementLines."Ed Code")



                        UNTIL SalaryIncrementLines.NEXT = 0;
                    Rec.Status := Rec.Status::Posted;
                    Rec.MODIFY;
                    MESSAGE('Changes implemented on Payroll successfully')
                end;
            }
            group("Request Approval")
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
                    RunObject = Page "Approval Entries";
                    RunPageLink = "Document No." = FIELD(Code);
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record 832;
                    begin
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
                    var
                    //   ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                    begin
                        /*TESTFIELD("Global Dimension 1 Code");
                       Rec.TESTFIELD(Status,Status::Open);
                        FundsManagement.CheckImprestMandatoryFields(Rec,FALSE);
                        
                        IF ApprovalsMgmtExt.CheckImprestApprovalsWorkflowEnabled(Rec) THEN
                          ApprovalsMgmtExt.OnSendImprestHeaderForApproval(Rec);
                        //"Cancelation Comments":='';
                        //MODIFY;
                        CurrPage.CLOSE;*/

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
                        //  ApprovalsMgmtExt: Codeunit "Approval Mgt. Ext";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

                    begin
                        /*TESTFIELD(Posted,FALSE);
                       Rec.TESTFIELD("Paid In Bank",FALSE);
                        ApprovalsMgmtExt.OnCancelImprestHeaderApprovalRequest(Rec);
                        //WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                        */

                    end;
                }
            }
        }
    }

    var
        SalaryIncrementLines: Record 50253;
        //  InsertIncrementLines: Report 51222;
        PayrollEntry: Record 51161;
        Employee: Record 5200;
        PayrollSetups: Record 51165;
        Periods: Record 51151;
}


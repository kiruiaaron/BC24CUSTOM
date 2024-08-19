page 51181 "Loan/Advance Card"
{
    PageType = Card;
    SourceTable = 51171;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ID; Rec."Loan ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Employee; Rec.Employee)
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
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
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
                field("Installment Amount"; Rec."Installment Amount")
                {
                    ApplicationArea = All;
                }
                field("Payments Method"; Rec."Payments Method")
                {
                    ApplicationArea = All;
                }
                field("Paid to Employee"; Rec."Paid to Employee")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Create; Rec.Create)
                {
                    ApplicationArea = All;
                }
                field(Pay; Rec.Pay)
                {
                    ApplicationArea = All;
                }
                field(Created; Rec.Created)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(PrincipalStat; Rec.Principal)
                {
                    Caption = 'Principal';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Principal (LCY)Stat"; Rec."Principal (LCY)")
                {
                    Caption = 'Principal (LCY)';
                    ApplicationArea = All;
                }
                field("Remaining Debt"; Rec."Remaining Debt")
                {
                    ApplicationArea = All;
                }
                field("Remaining Debt (LCY)"; Rec."Remaining Debt (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Repaid; Rec.Repaid)
                {
                    ApplicationArea = All;
                }
                field("Repaid (LCY)"; Rec."Repaid (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Number of Installments"; Rec."Number of Installments")
                {
                    ApplicationArea = All;
                }
                field("Total Interest"; Rec."Total Interest")
                {
                    ApplicationArea = All;
                }
                field("Total Interest (LCY)"; Rec."Total Interest (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Interest Paid"; Rec."Interest Paid")
                {
                    ApplicationArea = All;
                }
                field("Interest Paid (LCY)"; Rec."Interest Paid (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Last Suspension Date"; Rec."Last Suspension Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Last Suspension Duration"; Rec."Last Suspension Duration")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Loan")
            {
                Caption = '&Loan';
                action("Create Loan")
                {
                    Caption = 'Create Loan';
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.CreateLoan;
                    end;
                }
                action("Create Batch")
                {
                    Caption = 'Create Batch';
                    Image = CreateForm;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CreateBatch
                    end;
                }
                action("Create from Schedule")
                {
                    Caption = 'Create from Schedule';
                    Image = CreateLinesFromJob;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.CreateLoanfromSchedule;
                    end;
                }
                separator(sep1)
                {
                    Caption = '';
                }
                action("Pay Loan")
                {
                    Caption = 'Pay Loan';
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.PayLoan;
                    end;
                }
                action("Pay Batch")
                {
                    Caption = 'Pay Batch';
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PayBatch
                    end;
                }
                separator(sep2)
                {
                    Caption = '';
                }
                action("Write Off Loan")
                {
                    Caption = 'Write Off Loan';
                    Image = ClearLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Write Off Loan";
                    ApplicationArea = All;
                    // RunPageLink = "Loan ID" = FIELD("Loan ID");
                }
                action("Payoff Loan")
                {
                    Caption = 'Payoff Loan';
                    Image = ClosePeriod;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Pay Off Loan";
                    ApplicationArea = All;
                    //RunPageLink = "Loan ID" = FIELD("Loan ID");
                }
                separator(sep12)
                {
                    Caption = '';
                }
                action("Change Loan")
                {
                    Caption = 'Change Loan';
                    Image = Change;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 51191;
                    ApplicationArea = All;
                    // RunPageLink = "Loan ID" = FIELD("Loan ID");
                }
            }
        }
    }

    var
        gvAllowedPayrolls: Record 51182;

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
}


page 51159 "Payroll Header Card"
{
    PageType = Document;
    Permissions = TableData 51159 = rimd,
                  TableData 51160 = rimd,
                  TableData 51161 = rimd;
    SourceTable = 51159;

    layout
    {
        area(content)
        {
            group(Payroll1)
            {
                Caption = 'Payroll';
                field("Payroll ID"; Rec."Payroll ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field("Employee no."; Rec."Employee no.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Payable (LCY)"; Rec."Total Payable (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Total Benefit (LCY)"; Rec."Total Benefit (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Total Income"; "Total Income")
                {
                    Caption = 'Total Income';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Total Deduction (LCY)"; Rec."Total Deduction (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Total Payments"; "Total Payments")
                {
                    Caption = 'Net Payment';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Total Other (LCY)"; Rec."Total Other (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Calculated; Rec.Calculated)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(P9A)
            {
                Caption = 'P9A';
                field("A (LCY)"; Rec."A (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("B (LCY)"; Rec."B (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("C (LCY)"; Rec."C (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("D (LCY)"; Rec."D (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("E1 (LCY)"; Rec."E1 (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("E2 (LCY)"; Rec."E2 (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("E3 (LCY)"; Rec."E3 (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("F (LCY)"; Rec."F (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("G (LCY)"; Rec."G (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("H (LCY)"; Rec."H (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("J (LCY)"; Rec."J (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("K (LCY)"; Rec."K (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("L (LCY)"; Rec."L (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("M (LCY)"; Rec."M (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(PayrollEntries; 51160)
            {
                SubPageLink = "Payroll ID" = FIELD("Payroll ID"),
                              "Employee No." = FIELD("Employee No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Payroll)
            {
                Caption = 'Payroll';
                separator(sep1)
                {
                }
                action("Calculate Payroll")
                {
                    Caption = 'Calculate Payroll';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE(TRUE);
                        CODEUNIT.RUN(CODEUNIT::"Calculate One Payroll", Rec);
                    end;
                }
                action(Payslip)
                {
                    Caption = 'Payslip';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        lvPayslip: Report 51150;
                        lvPayrollLine: Record 51160;
                        lvPeriods: Record 51151;
                        lvEmployee: Record 5200;
                    begin
                        lvPeriods.SETRANGE("Period ID", Rec."Payroll ID");
                        lvEmployee.SETRANGE("No.", Rec."Employee no.");
                        lvPayslip.SETTABLEVIEW(lvPeriods);
                        lvPayslip.SETTABLEVIEW(lvEmployee);
                        lvPayslip.RUNMODAL;
                    end;
                }
                separator(s2)
                {
                }
                action("Insert Payroll")
                {
                    Caption = 'Insert Payroll';
                    Image = Insert;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        lvInsertIntoPeriod: Record 51151;
                        lvAllowedPayrolls: Record 51182;
                        lvPeriods: Record 51151;
                        lvPayrollMonth: Integer;
                        lvPayrollYear: Integer;
                    begin
                        //skm230409 revised to be able to insert the first payroll while ensuring Payroll ID is not blank.
                        IF Rec."Payroll ID" <> '' THEN
                            lvInsertIntoPeriod.GET(Rec."Payroll ID", Rec."Payroll Month", Rec."Payroll Year", Rec."Payroll Code")
                        ELSE BEGIN
                            lvAllowedPayrolls.SETRANGE("Last Active Payroll", TRUE);
                            IF lvAllowedPayrolls.FINDFIRST THEN
                                Rec.SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code")
                            ELSE
                                ERROR('You did not select a payroll during login or are not allowed access to any payroll dataset.');

                            lvInsertIntoPeriod.SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code");
                            lvInsertIntoPeriod.SETRANGE(lvInsertIntoPeriod.Status, lvInsertIntoPeriod.Status::Open);
                            IF NOT (ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"Payroll Periods", lvInsertIntoPeriod)) THEN BEGIN
                                MESSAGE('You have cancelled new payroll insertion.');
                                EXIT
                            END;
                        END;

                        IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"Employee List", Employee) THEN BEGIN
                            Name := Employee."First Name" + ' ' + Employee."Last Name";

                            //Payroll Month 0 Payroll Year 0 error
                            IF ((lvInsertIntoPeriod."Period Month" = 0) OR (lvInsertIntoPeriod."Period Year" = 0)) THEN BEGIN
                                lvPeriods.SETRANGE("Period ID", lvInsertIntoPeriod."Period ID");
                                lvPeriods.SETRANGE("Payroll Code", lvAllowedPayrolls."Payroll Code");
                                IF lvPeriods.FINDFIRST THEN BEGIN
                                    lvPayrollMonth := lvPeriods."Period Month";
                                    lvPayrollYear := lvPeriods."Period Year";
                                END;
                            END ELSE BEGIN
                                lvPayrollMonth := lvInsertIntoPeriod."Period Month";
                                lvPayrollYear := lvInsertIntoPeriod."Period Year";
                            END;
                            //END Payroll Month 0 Payroll Year 0 error

                            IF CONFIRM('Do you want to insert\%1\in payroll period\%2', FALSE, Name, lvInsertIntoPeriod."Period ID") THEN BEGIN
                                Rec."Payroll ID" := lvInsertIntoPeriod."Period ID";
                                Rec."Employee no." := Employee."No.";
                                //Payroll Month 0 Payroll Year 0 error. Original lines commented
                                //"Payroll Month" := lvInsertIntoPeriod."Period Month";
                                //"Payroll Year" := lvInsertIntoPeriod."Period Year";
                                Rec."Payroll Month" := lvPayrollMonth;
                                Rec."Payroll Year" := lvPayrollYear;
                                //END Payroll Month 0 Payroll Year 0 error
                                IF NOT Rec.INSERT(TRUE) THEN
                                    MESSAGE('The employee already exits.')
                            END;

                            Rec.GET(Rec."Payroll ID", Employee."No.");
                        END;
                    end;
                }
                action("Delete Employee")
                {
                    Caption = 'Delete Employee';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        IF CONFIRM('This will remove this employee from the current months payroll, Continue', FALSE) THEN
                            Rec.DELETE(TRUE)
                        ELSE
                            MESSAGE('Operation Cancelled');
                    end;
                }
                separator(s3)
                {
                }
            }
        }
        area(navigation)
        {
            action(Dimensions)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ShowPayrollDim;
                end;
            }
            action("List Employee")
            {
                Caption = 'List Employee';
                Image = List;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"Employee List", Employee) THEN
                        IF NOT Rec.GET(Rec."Payroll ID", Employee."No.") THEN;
                end;
            }
            action("Employee Card")
            {
                Caption = 'Employee Card';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 5200;
                ApplicationArea = All;

                trigger OnAction()
                var
                    lvEmployee: Record 5200;
                begin
                    lvEmployee.SETRANGE("No.", Rec."Employee no.");
                    PAGE.RUN(PAGE::"Employee Card", lvEmployee);
                end;
            }
            action("Non Payroll Receipts")
            {
                Caption = 'Non Payroll Receipts';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 51218;
                RunPageLink = "Employee No" = FIELD("Employee No.");
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        "Total Income" := Rec."Total Payable (LCY)" + Rec."Total Benefit (LCY)";

        "Total Payments" := Rec."Total Payable (LCY)" - Rec."Total Deduction (LCY)";
        //CALCFIELDS("Mid Month Advance Code", "Advance (LCY)");
    end;

    trigger OnOpenPage()
    begin
        gsSegmentPayrollData; //skm150506
        Rec.SETCURRENTKEY(Posted);
        Rec.FILTERGROUP := 2;
        Rec.SETRANGE(Posted, FALSE);
        Rec.FILTERGROUP := 0;
    end;

    var
        Employee: Record 5200;
        Periods: Record 51151;
        FilteredHeader: Record 51159;
        CalcPayrollCodeUnit: Codeunit 51151;
        "Total Payments": Decimal;
        "Total Income": Decimal;
        Name: Text[50];
        PayrollEntry: Record 51161;
        PayrollLines: Record 51160;

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


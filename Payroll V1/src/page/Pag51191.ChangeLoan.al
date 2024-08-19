page 51191 "Change Loan"
{
    InsertAllowed = false;
    PageType = Card;
    Permissions = TableData 51172 = rimd;
    SourceTable = 51172;
    SourceTableView = SORTING("No.", "Loan ID")
                      WHERE(Posted = FILTER(False));

    layout
    {
        area(content)
        {
            field(OldLoanBalance; OldLoanBalance)
            {
                Caption = 'Old Loan Balance';
                Editable = false;
                ApplicationArea = All;
            }
            field(OldInterest; OldInterest)
            {
                Caption = 'Old Interest Rate';
                Editable = false;
                ApplicationArea = All;
            }
            field(OldInstalments; OldInstalments)
            {
                Caption = 'Old Installments';
                Editable = false;
                ApplicationArea = All;
            }
            field(OLD; OldInstallmentAmount)
            {
                Caption = 'Old Installment Amount';
                Editable = false;
                Visible = OLDVisible;
                ApplicationArea = All;
            }
            field(NewLoanBalance; NewLoanBalance)
            {
                Caption = 'New Loan Balance';
                ApplicationArea = All;
            }
            field(NEW; NewInstallmentAmount)
            {
                Caption = 'New Installment Amount';
                Visible = NEWVisible;
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    NewInstalments := 0;
                end;
            }
            field(SuspensionMonths; SuspensionMonths)
            {
                Caption = 'Suspension Period (Months)';
                ApplicationArea = All;
            }
            repeater(r)
            {
                Editable = false;
                field(Employee; Rec.Employee)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Period B4 Suspension"; Rec."Period B4 Suspension")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Interest; Rec.Interest)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Interest (LCY)"; Rec."Interest (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Repayment; Rec.Repayment)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Repayment (LCY)"; Rec."Repayment (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Remaining Debt"; Rec."Remaining Debt")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Remaining Debt (LCY)"; Rec."Remaining Debt (LCY)")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Suspension)
            {
                Caption = 'Suspension';
                action("Suspend Loan")
                {
                    Caption = 'Suspend Loan';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        IF SuspensionMonths = 0 THEN
                            ERROR('Please enter the number of months by which\' +
'to suspend the loan as at ' + Rec.Period);
                        SuspendLoan();
                    end;
                }
                separator(s1)
                {
                    Caption = '';
                }
                action("Reverse Suspension")
                {
                    Caption = 'Reverse Suspension';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ReverseLoanSuspension();
                    end;
                }
            }
        }
        area(processing)
        {
            action(Change)
            {
                Caption = 'Change';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PeriodRec: Record 51160;
                begin
                    LoanEntryRecTmp.DELETEALL;

                    LoanEntryRecTmp.COPY(Rec);
                    LoanEntryRecTmp.INSERT;

                    Rec.SETFILTER("No.", '>=%1', LoanEntryRecTmp."No.");
                    Rec.DELETEALL;

                    Rec.SETRANGE("No.");

                    IF AnnuityYN THEN
                        CreateAnnuityLoan
                    ELSE
                        CreateSerialLoan;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        NEWVisible := TRUE;
        OLDVisible := TRUE;
    end;

    trigger OnOpenPage()
    begin
        gsSegmentPayrollData;
        IF Rec.FIND('-') THEN;

        OldInstalments := Rec.COUNT;
        LoansRec.GET(Rec."Loan ID");
        LoansRec.CALCFIELDS("Remaining Debt");
        OldInterest := LoansRec."Interest Rate";
        OldLoanBalance := LoansRec."Remaining Debt";
        NewLoanBalance := LoansRec."Remaining Debt";
        NewInstalments := Rec.COUNT;
        NewInterest := LoansRec."Interest Rate";
        NewInstallmentAmount := LoansRec."Installment Amount";
        OldInstallmentAmount := LoansRec."Installment Amount";
        CASE LoansRec.Type OF
            0:
                BEGIN
                    OldInstallmentAmount := LoansRec."Installment Amount";
                    AnnuityYN := TRUE;
                    NEWVisible := TRUE;
                    OLDVisible := TRUE;
                END;
            1:
                BEGIN

                    AnnuityYN := FALSE;
                    NEWVisible := TRUE;
                    OLDVisible := TRUE;

                END;
            2:
                ERROR('You Cannot Change an Advance');
        END;

        IF AnnuityYN THEN
            IF (NewInterest > 0) AND (NewInstalments > 0) THEN
                NewInstallmentAmount := ROUND(LoansRec.DebtService((Rec."Remaining Debt" + Rec.Repayment), NewInterest, NewInstalments), 1, '>')
            ELSE
                IF (NewInstalments > 0) THEN
                    NewInstallmentAmount := ROUND((Rec."Remaining Debt" + Rec.Repayment) / NewInstalments, 1, '>');
    end;

    var
        LoanEntryRecTmp: Record 51172 temporary;
        LoanEntryRec: Record 51172;
        Loansetup: Record 51165;
        LoanTypeRec: Record 51178;
        LoansRec: Record 51171;
        OldInterest: Decimal;
        NewInterest: Decimal;
        OldInstalments: Integer;
        NewInstalments: Integer;
        OldInstallmentAmount: Decimal;
        NewInstallmentAmount: Decimal;
        AnnuityYN: Boolean;
        EntryNo: Integer;
        LoanId: Code[20];
        SuspensionMonths: Integer;
        gvAllowedPayrolls: Record 51182;
        gvCurrExchangeRate: Record 330;
        [InDataSet]
        OLDVisible: Boolean;
        [InDataSet]
        NEWVisible: Boolean;
        OldLoanBalance: Decimal;
        NewLoanBalance: Decimal;

    procedure CreateSerialLoan()
    var
        LoanEntryRec: Record 51172;
        Periodrec: Record 51151;
        LoanTypeRec: Record 51178;
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin
        LoopEndBool := FALSE;

        LineNoInt := 0;
        Periodrec.SETCURRENTKEY("Start Date");
        Periodrec.SETRANGE("Period ID", LoanEntryRecTmp.Period);
        Periodrec.SETRANGE("Payroll Code", LoanEntryRecTmp."Payroll Code"); //PMC290729 Added this line
        //Periodrec.Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code"); //This is the Original line commented
        Periodrec.FIND('-');
        Periodrec.SETRANGE("Period ID");

        LoansRec.GET(LoanEntryRecTmp."Loan ID");
        LoanTypeRec.GET(LoansRec."Loan Types");

        CASE LoanTypeRec.Rounding OF
            LoanTypeRec.Rounding::Nearest:
                RoundDirectionCode := '=';
            LoanTypeRec.Rounding::Down:
                RoundDirectionCode := '<';
            LoanTypeRec.Rounding::Up:
                RoundDirectionCode := '>';
        END;

        RoundPrecisionDec := LoanTypeRec."Rounding Precision";

        RemainingPrincipalAmountDec := NewLoanBalance;

        RepaymentAmountDec := NewInstallmentAmount;
        LoopEndBool := FALSE;
        REPEAT
            IF LineNoInt <> 0 THEN BEGIN
                Periodrec.FIND('>');
                PeriodCode := Periodrec."Period ID";
            END ELSE
                PeriodCode := LoanEntryRecTmp.Period;

            LineNoInt := LineNoInt + 1;

            InterestAmountDec := ROUND(RemainingPrincipalAmountDec / 12 / 100 * NewInterest, RoundPrecisionDec, RoundDirectionCode);
            LoanEntryRec."No." := LineNoInt + LoanEntryRecTmp."No." - 1;
            LoanEntryRec."Loan ID" := LoanEntryRecTmp."Loan ID";
            LoanEntryRec.Employee := LoanEntryRecTmp.Employee;
            LoanEntryRec.Period := PeriodCode;
            LoanEntryRec.Interest := InterestAmountDec;
            LoanEntryRec."Interest (LCY)" :=
            //  ROUND(InterestAmountDec * LoansRec."Currency Factor", RoundPrecisionDec, RoundDirectionCode);
            ROUND(gvCurrExchangeRate.ExchangeAmtFCYToLCY(WORKDATE, LoansRec."Currency Code", InterestAmountDec, //SNG
            LoansRec."Currency Factor"), RoundPrecisionDec, RoundDirectionCode);


            LoanEntryRec."Calc Benefit Interest" := LoanEntryRecTmp."Calc Benefit Interest";

            IF (NewInstallmentAmount - InterestAmountDec) >= RemainingPrincipalAmountDec THEN BEGIN
                LoanEntryRec.Repayment := RemainingPrincipalAmountDec;
                LoanEntryRec."Repayment (LCY)" :=
                // ROUND(RemainingPrincipalAmountDec * LoansRec."Currency Factor", RoundPrecisionDec, RoundDirectionCode);
                ROUND(gvCurrExchangeRate.ExchangeAmtFCYToLCY(WORKDATE, LoansRec."Currency Code", RemainingPrincipalAmountDec,
                LoansRec."Currency Factor"), RoundPrecisionDec, RoundDirectionCode);

                LoanEntryRec."Remaining Debt (LCY)" := 0;
                LoanEntryRec."Remaining Debt" := 0;
                LoopEndBool := TRUE;
            END ELSE BEGIN
                LoanEntryRec.Repayment := RepaymentAmountDec;

                LoanEntryRec."Repayment (LCY)" :=
                ROUND(gvCurrExchangeRate.ExchangeAmtFCYToLCY(WORKDATE, LoansRec."Currency Code", RepaymentAmountDec, //SNG 300511
                LoansRec."Currency Factor"), RoundPrecisionDec, RoundDirectionCode);
                //  ROUND(RepaymentAmountDec * LoansRec."Currency Factor",RoundPrecisionDec,RoundDirectionCode);

                RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - RepaymentAmountDec;
                LoanEntryRec."Remaining Debt" := RemainingPrincipalAmountDec;

                LoanEntryRec."Remaining Debt (LCY)" :=
                // ROUND(RemainingPrincipalAmountDec * LoansRec."Currency Factor", RoundPrecisionDec, RoundDirectionCode);
                ROUND(gvCurrExchangeRate.ExchangeAmtFCYToLCY(WORKDATE, LoansRec."Currency Code", RemainingPrincipalAmountDec, //SNG 300511
                LoansRec."Currency Factor"), RoundPrecisionDec, RoundDirectionCode);

            END;

            LoanEntryRec."Payroll Code" := LoanEntryRecTmp."Payroll Code";//PMC290710 Added this line
                                                                          //LoanEntryRec."Payroll Code" := gvAllowedPayrolls."Payroll Code";//The original line commented
            LoanEntryRec.INSERT;

        UNTIL LoopEndBool;
        LoansRec.GET(LoanEntryRecTmp."Loan ID");
        LoansRec.CALCFIELDS("Number of Installments");
        LoansRec.Installments := LoansRec."Number of Installments";
        LoansRec.Principal := NewLoanBalance;

        LoansRec."Installment Amount" := NewInstallmentAmount;
        LoansRec.MODIFY;
    end;

    procedure CreateAnnuityLoan()
    var
        Periodrec: Record 51151;
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin
        IF NewInstallmentAmount <= 0 THEN
            ERROR('Instalment Amount must be specified');

        RemainingPrincipalAmountDec := NewLoanBalance;

        IF NewInstallmentAmount > RemainingPrincipalAmountDec THEN
            ERROR('Instalment Amount is higher than Principal');

        LoopEndBool := FALSE;

        LineNoInt := LoanEntryRecTmp."No.";

        Periodrec.SETCURRENTKEY("Start Date");
        Periodrec.SETRANGE("Period ID", LoanEntryRecTmp.Period);
        Periodrec.SETRANGE("Payroll Code", LoanEntryRecTmp."Payroll Code"); //PMC290729 Added this
        //Periodrec.Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code"); //This is the Original line commented
        Periodrec.FIND('-');
        Periodrec.SETRANGE("Period ID");

        LoansRec.GET(LoanEntryRecTmp."Loan ID");
        LoanTypeRec.GET(LoansRec."Loan Types");

        CASE LoanTypeRec.Rounding OF
            LoanTypeRec.Rounding::Nearest:
                RoundDirectionCode := '=';
            LoanTypeRec.Rounding::Down:
                RoundDirectionCode := '<';
            LoanTypeRec.Rounding::Up:
                RoundDirectionCode := '>';
        END;

        RoundPrecisionDec := LoanTypeRec."Rounding Precision";

        REPEAT
            InterestAmountDec := ROUND(RemainingPrincipalAmountDec / 100 / 12 * NewInterest, RoundPrecisionDec, RoundDirectionCode);
            IF InterestAmountDec >= NewInstallmentAmount THEN
                ERROR('This Loan is not possible because\the the instalment Amount must\be higher than %1', InterestAmountDec);


            IF LineNoInt <> LoanEntryRecTmp."No." THEN BEGIN
                Periodrec.FIND('>');
                PeriodCode := Periodrec."Period ID";
            END ELSE
                PeriodCode := LoanEntryRecTmp.Period;

            LoanEntryRec."No." := LineNoInt;
            LoanEntryRec."Loan ID" := LoanEntryRecTmp."Loan ID";
            LoanEntryRec.Employee := LoanEntryRecTmp.Employee;
            LoanEntryRec.Period := PeriodCode;
            LoanEntryRec.Interest := InterestAmountDec;

            LoanEntryRec."Interest (LCY)" :=
            //  ROUND(InterestAmountDec * LoansRec."Currency Factor", RoundPrecisionDec, '<');
            ROUND(gvCurrExchangeRate.ExchangeAmtFCYToLCY(WORKDATE, LoansRec."Currency Code", InterestAmountDec,   //SNG  300511
            LoansRec."Currency Factor"), RoundPrecisionDec, '<');

            LoanEntryRec."Calc Benefit Interest" := LoanEntryRecTmp."Calc Benefit Interest";

            IF (NewInstallmentAmount - InterestAmountDec) >= RemainingPrincipalAmountDec THEN BEGIN
                LoanEntryRec.Repayment := RemainingPrincipalAmountDec;

                LoanEntryRec."Repayment (LCY)" :=
                //  ROUND(RemainingPrincipalAmountDec * LoansRec."Currency Factor", RoundPrecisionDec, '<');
                ROUND(gvCurrExchangeRate.ExchangeAmtFCYToLCY(WORKDATE, LoansRec."Currency Code", RemainingPrincipalAmountDec,   //SNG 300511
                LoansRec."Currency Factor"), RoundPrecisionDec, '<');


                LoanEntryRec."Remaining Debt" := 0;
                LoanEntryRec."Remaining Debt (LCY)" := 0;
                LoopEndBool := TRUE;
            END ELSE BEGIN
                LoanEntryRec.Repayment := NewInstallmentAmount - InterestAmountDec;

                LoanEntryRec."Repayment (LCY)" :=
                //ROUND(LoanEntryRec.Repayment * LoansRec."Currency Factor", RoundPrecisionDec, '<');
                ROUND(gvCurrExchangeRate.ExchangeAmtFCYToLCY(WORKDATE, LoansRec."Currency Code", LoanEntryRec.Repayment,   //SNG  300511
                LoansRec."Currency Factor"), RoundPrecisionDec, '<');

                RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - (NewInstallmentAmount - InterestAmountDec);
                LoanEntryRec."Remaining Debt" := RemainingPrincipalAmountDec;
                LoanEntryRec."Remaining Debt (LCY)" :=
                //  ROUND(RemainingPrincipalAmountDec * LoansRec."Currency Factor", RoundPrecisionDec, '<');
                ROUND(gvCurrExchangeRate.ExchangeAmtFCYToLCY(WORKDATE, LoansRec."Currency Code", RemainingPrincipalAmountDec,   //SNG  300511
                LoansRec."Currency Factor"), RoundPrecisionDec, '<');


            END;

            LoanEntryRec."Transfered To Payroll" := FALSE;
            LoanEntryRec."Payroll Code" := LoanEntryRecTmp."Payroll Code";//PMC290710 Added this line
                                                                          //LoanEntryRec."Payroll Code" := gvAllowedPayrolls."Payroll Code";//The original line commented
            LoanEntryRec.INSERT;

            LineNoInt := LineNoInt + 1;
        UNTIL LoopEndBool;
        LoansRec.GET(LoanEntryRecTmp."Loan ID");
        LoansRec.CALCFIELDS("Number of Installments");
        LoansRec.Installments := LoansRec."Number of Installments";
        LoansRec.Principal := NewLoanBalance;
        LoansRec."Installment Amount" := NewInstallmentAmount;
        LoansRec.MODIFY;
    end;

    procedure SuspendLoan()
    var
        Periods: Record 51151;
        PeriodsTemp: Record 51151;
        SuspendedMnths: Integer;
    begin
        //SKM 30/03/00 This function suspends a loan as at current installment for the specified
        //payroll months(periods)
        //only open installments

        //Determine resumption period

        PeriodsTemp.SETRANGE("Period ID", Rec.Period);
        PeriodsTemp.SETRANGE("Payroll Code", Rec."Payroll Code");
        //PeriodsTemp.Rec.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code"); Original Line commented by CSm
        PeriodsTemp.FIND('-');

        Periods.SETCURRENTKEY(Periods."Start Date");
        Periods.GET(PeriodsTemp."Period ID", PeriodsTemp."Period Month", PeriodsTemp."Period Year",
          Rec."Payroll Code");
        REPEAT
            SuspendedMnths := SuspendedMnths + 1
        UNTIL (Periods.NEXT = 0) OR (SuspendedMnths = SuspensionMonths);
        IF SuspendedMnths <> SuspensionMonths THEN
            ERROR('There aren''t enough payroll periods setup in the periods table.\' +
              'Available periods = %1 (months), suspending by %2 (months)', SuspendedMnths, SuspensionMonths);

        IF CONFIRM(
            STRSUBSTNO('You are just about to postphone the repayment of this repayment\' +
                       'for %1 to %2. All the subsequent repayments will be adjusted\' +
                       'accordingly.\\' +
                       'Proceed anyway?', Rec.Period, Periods."Period ID")) = FALSE THEN
            EXIT;
        IF CONFIRM('Are you sure you want to suspend this loan?') = FALSE THEN EXIT;

        //Suspend
        LoanEntryRec.RESET;
        LoanEntryRec.SETFILTER("No.", '>=%1', Rec."No.");
        LoanEntryRec.SETRANGE("Loan ID", Rec."Loan ID");
        LoanEntryRec.SETRANGE(Employee, Rec.Employee);
        LoanEntryRec.FIND('-');
        REPEAT
            LoanEntryRec."Period B4 Suspension" := LoanEntryRec.Period;
            LoanEntryRec.Period := Periods."Period ID";
            IF Periods.NEXT = 0 THEN
                ERROR('There aren''t enough payroll periods setup in the periods table.');
            LoanEntryRec.MODIFY;
        UNTIL LoanEntryRec.NEXT = 0;

        LoansRec.GET(LoanEntryRec."Loan ID");
        LoansRec."Last Suspension Date" := TODAY;
        LoansRec."Last Suspension Duration" := SuspensionMonths;
        MESSAGE('Loan suspended sucessfully.');
    end;

    procedure ReverseLoanSuspension()
    var
        Periods: Record 51151;
        PeriodsTemp: Record 51151;
        SuspendedMnths: Integer;
    begin
        //SKM 30/03/00 This function reverses a loan suspension as at current installment
        //only open installments

        IF Rec."Period B4 Suspension" = '' THEN ERROR('Repayment was not suspended.');
        IF CONFIRM(
            STRSUBSTNO('You are just about to reverse the suspension of this repayment\' +
                       'for %1 to %2. All the subsequent repayments will be adjusted\' +
                       'accordingly.\\' +
                       'Proceed anyway?', Rec.Period, Rec."Period B4 Suspension")) = FALSE THEN
            EXIT;
        IF CONFIRM('Are you sure you want reverse the suspension of this loan?') = FALSE THEN EXIT;

        //Reverse Suspension
        LoanEntryRec.RESET;
        LoanEntryRec.SETFILTER("No.", '>=%1', Rec."No.");
        LoanEntryRec.SETRANGE("Loan ID", Rec."Loan ID");
        LoanEntryRec.SETRANGE(Employee, Rec.Employee);
        LoanEntryRec.FIND('-');
        REPEAT
            LoanEntryRec.Period := LoanEntryRec."Period B4 Suspension";
            LoanEntryRec."Period B4 Suspension" := '';
            LoanEntryRec.MODIFY;
        UNTIL LoanEntryRec.NEXT = 0;

        LoansRec.GET(LoanEntryRec."Loan ID");
        LoansRec."Last Suspension Date" := 0D;
        LoansRec."Last Suspension Duration" := 0;
        MESSAGE('Suspension reversed sucessfully.');
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


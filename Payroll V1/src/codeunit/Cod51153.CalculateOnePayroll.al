/// <summary>
/// Codeunit Calculate One Payroll (ID 51153).
/// </summary>
codeunit 51153 "Calculate One Payroll"
{
    Permissions = TableData 51159 = rm,
                  TableData 51160 = rimd,
                  TableData 51172 = rm;
    TableNo = 51159;

    trigger OnRun()
    var
        lvPayrollDim: Record 51184;
    begin
        gvPayrollUtilities.sGetActivePayroll(gvAllowedPayrolls);
        Rec."A (LCY)" := 0;
        Rec."B (LCY)" := 0;
        Rec."C (LCY)" := 0;
        Rec."D (LCY)" := 0;
        Rec."E1 (LCY)" := 0;
        Rec."E2 (LCY)" := 0;
        Rec."E3 (LCY)" := 0;
        Rec."F (LCY)" := 0;
        Rec."G (LCY)" := 0;
        Rec."H (LCY)" := 0;
        Rec."J (LCY)" := 0;
        Rec."K (LCY)" := 0;
        Rec."L (LCY)" := 0;
        Rec."M (LCY)" := 0;

        Period := Rec."Payroll ID";
        PeriodRec.GET(Rec."Payroll ID", Rec."Payroll Month", Rec."Payroll Year", Rec."Payroll Code");
        PeriodInterest := PeriodRec."Low Interest Benefit %";
        gvPostingDate := PeriodRec."Posting Date";


        IF EntryLines.FIND('+') THEN
            EntryLineNo := EntryLines."Entry No.";

        EntryLines.SETCURRENTKEY("Payroll ID", "Employee No.", "ED Code", "Loan Entry", "Basic Pay Entry", "Time Entry");
        EntryLines.SETRANGE("Payroll ID", Rec."Payroll ID");
        EntryLines.SETRANGE("Employee No.", Rec."Employee no.");
        EntryLines.SETRANGE("Loan Entry", TRUE);
        EntryLines.DELETEALL(TRUE);
        EntryLines.SETRANGE("Loan Entry");

        EntryLines.SETRANGE("Basic Pay Entry", TRUE);
        EntryLines.DELETEALL(TRUE);
        EntryLines.SETRANGE("Basic Pay Entry");

        EntryLines.SETRANGE("Time Entry", TRUE);
        EntryLines.DELETEALL(TRUE);
        EntryLines.SETRANGE("Time Entry");

        //ICS synchronize payroll header and employee dimensions for dimensions amended after creation of header
        lvPayrollDim.SETRANGE("Table ID", DATABASE::"Payroll Header");
        lvPayrollDim.SETRANGE("Employee No", Rec."Employee no.");
        lvPayrollDim.SETRANGE("Payroll ID", Rec."Payroll ID");
        lvPayrollDim.DELETEALL;
        gvPayrollUtilities.sGetDefaultEmpDims(Rec);
        //ICS end

        GetLoans(Rec);
        GetBasicPay(Rec);
        GetTime(Rec);
        GetCommission(Rec);

        //V.6.1.65_07SEP10 >>
        IF Rec."Employee no." <> '' THEN
            Emp.GET(Rec."Employee no.");
        IF Emp."Customer No." <> '' THEN BEGIN
            Cust.SETCURRENTKEY("Customer No.", "Posting Date", "Currency Code");
            Cust.SETRANGE(Cust."Customer No.", Emp."Customer No.");
            Cust.SETFILTER(Cust."On Hold", '%1', '');
            IF Cust.FINDSET THEN
                REPEAT
                    Cust.CALCFIELDS(Cust."Remaining Amt. (LCY)");
                    OutStandingAmt += Cust."Remaining Amt. (LCY)";
                UNTIL Cust.NEXT = 0;
            IF OutStandingAmt > 0 THEN
                PersonalACRecoveries(Rec);
        END;
        //V.6.1.65_07SEP10 <<

        GetInfo;
        Employee.GET(Rec."Employee no.");
        BringFWDrounding;

        Scheme := Employee."Calculation Scheme";
        SchemeControlTmp.SETRANGE("Scheme ID", Employee."Calculation Scheme");
        SchemeValueTmp.SETRANGE("Scheme ID", Employee."Calculation Scheme");
        SchemeValueTmp.MODIFYALL(Amount, 0);
        SchemeValueTmp.MODIFYALL("Amount (LCY)", 0);

        //SKM050505 Special Allowances & Payments Management
        SchemeControlTmp.SETRANGE("Special Allowance", TRUE);
        SchemeControlTmp.MODIFYALL("Special Allowance Calculated", FALSE);
        SchemeControlTmp.SETFILTER("Special Allowance", '');

        SchemeControlTmp.SETRANGE("Special Payment", TRUE);
        SchemeControlTmp.MODIFYALL("Special Payment Calculated", FALSE);
        SchemeControlTmp.SETFILTER("Special Payment", '');
        //End SKM050505 Special Allowance Management

        SchemeControlTmp.FIND('-');
        REPEAT
            //V.6.1.65_10SEP10 >>
            IF (NOT SchemeControlTmp."Annualize TAX") AND (NOT SchemeControlTmp."Annualize Relief") THEN BEGIN
                Flag := FALSE;
                CLEAR(gvPayrollHeader);
                gvPayrollHeader.GET(Rec."Payroll ID", Employee."No.");
                //V.6.1.65_10SEP10 <<
                LineNo := SchemeControlTmp."Line No.";
                GetInput(Rec);

                IF (SchemeControlTmp."Special Allowance") AND (NOT SchemeControlTmp."Special Allowance Calculated")
                   THEN
                    GetSpecialAllowance(Rec);

                IF (SchemeControlTmp."Special Payment") AND (NOT SchemeControlTmp."Special Payment Calculated")
                   THEN
                    GetSpecialPayments(Rec);

                RoundAmount;
                Calculate(Rec);
                Output(Rec);
            END ELSE BEGIN
                PeriodRec.GET(PayrollHeader."Payroll ID", PayrollHeader."Payroll Month",
                PayrollHeader."Payroll Year", PayrollHeader."Payroll Code");
                IF (PeriodRec."Annualize TAX") THEN BEGIN //V.6.1.65_10SEP10 >>
                    Flag := FALSE;
                    CLEAR(gvPayrollHeader);
                    gvPayrollHeader.GET(Rec."Payroll ID", Employee."No.");

                    LineNo := SchemeControlTmp."Line No.";
                    GetInput(Rec);

                    IF (SchemeControlTmp."Special Allowance") AND (NOT SchemeControlTmp."Special Allowance Calculated")
                       THEN
                        GetSpecialAllowance(Rec);

                    IF (SchemeControlTmp."Special Payment") AND (NOT SchemeControlTmp."Special Payment Calculated")
                       THEN
                        GetSpecialPayments(Rec);

                    RoundAmount;
                    IF SchemeControlTmp."Annualize TAX" THEN
                        IF BeforeReliefAmt = 0 THEN
                            BeforeReliefAmt := Amount1LCY;

                    Calculate(Rec);
                    Output(Rec);
                END;
            END; //V.6.1.65_10SEP10 >>
        UNTIL SchemeControlTmp.NEXT = 0;
        Rec.Calculated := TRUE;
        IF Rec."M (LCY)" < 0 THEN Rec."M (LCY)" := 0;
        FlushTmp(Rec);
        gvPayrollUtilities.sAllocatePayroll(Period, gvAllowedPayrolls."Payroll Code", Rec."Employee no.");
    end;

    var
        SchemeControlTmp: Record 51154 temporary;
        SchemeValueTmp: Record 51154 temporary;
        EntryLines: Record 51161;
        EntryLinesTMP: Record 51161 temporary;
        PayrollLinesTmp: Record 51160 temporary;
        EDDefinitionTmp: Record 51158 temporary;
        Employee: Record 5200;
        PayrollLinesTmpLineNo: Integer;
        Amount: Decimal;
        "Amount (LCY)": Decimal;
        Amount1: Decimal;
        Amount1LCY: Decimal;
        Cum: Decimal;
        Percent: Decimal;
        PeriodInterest: Decimal;
        Scheme: Code[20];
        Period: Code[10];
        LineNo: Integer;
        EntryLineNo: Integer;
        Quantity: Decimal;
        PeriodRec: Record 51151;
        PayrollHeader: Record 51159;
        gvLineNo2: Integer;
        gvPostingDate: Date;
        gvAllowedPayrolls: Record 51182;
        gvPayrollUtilities: Codeunit 51152;
        gvCurrExchRate: Record 330;
        gvCurrency: Record 4;
        PayrollSetup: Record 51165;
        "-- V.6.1.65 ---": Integer;
        Cust: Record 21;
        Emp: Record 5200;
        OutStandingAmt: Decimal;
        gvPayrollHeader: Record 51159;
        Flag: Boolean;
        Flag1: Boolean;
        AnnualReliefAmt: Decimal;
        BeforeReliefAmt: Decimal;
        AllowedPayrolls2: Record 51182;
        myPayrollCode: Code[20];
        myPeriod: Record 51151;
        myDate: Date;
        myMonth: Integer;
        myYear: Integer;
        myPeriodHrs: Decimal;
        myPeriodDays: Decimal;
        lvPayrollPeriod: Integer;

    procedure GetLoans(var Header: Record 51159)
    var
        LoanEntryRec: Record 51172;
        LoanRec: Record 51171;
        LoanTypeRec: Record 51178;
        PayrollSetupRec: Record 51165;
        BenefitInterest: Decimal;
    begin
        LoanEntryRec.SETCURRENTKEY("Loan ID", Employee, Period, "Transfered To Payroll", Posted);
        LoanEntryRec.SETRANGE(Employee, Header."Employee no.");
        LoanEntryRec.SETRANGE(Period, Period);
        LoanEntryRec.SETRANGE(Posted, FALSE);

        IF LoanEntryRec.FIND('-') THEN BEGIN

            REPEAT
                LoanRec.GET(LoanEntryRec."Loan ID");

                IF LoanRec."Paid to Employee" THEN BEGIN
                    EntryLineNo := EntryLineNo + 1;
                    LoanTypeRec.GET(LoanRec."Loan Types");

                    EntryLines."Entry No." := EntryLineNo;
                    EntryLines."Payroll ID" := Period;
                    EntryLines."Employee No." := Header."Employee no.";
                    EntryLines.Date := gvPostingDate;
                    EntryLines.VALIDATE("ED Code", LoanTypeRec."Loan E/D Code");
                    EntryLines.VALIDATE("Currency Code", LoanRec."Currency Code");
                    EntryLines.Quantity := 0;
                    EntryLines.VALIDATE(Rate, 0);
                    EntryLines.VALIDATE(Amount, LoanEntryRec.Interest + LoanEntryRec.Repayment);
                    EntryLines."Copy to next" := FALSE;
                    EntryLines."Reset Amount" := FALSE;
                    EntryLines.Editable := TRUE;
                    EntryLines."Loan ID" := LoanEntryRec."Loan ID";
                    EntryLines.VALIDATE(Interest, LoanEntryRec.Interest);
                    EntryLines.VALIDATE(Repayment, LoanEntryRec.Repayment);
                    EntryLines.VALIDATE("Remaining Debt", LoanEntryRec."Remaining Debt");
                    EntryLines.VALIDATE(Paid, LoanRec.Principal - LoanEntryRec."Remaining Debt");
                    EntryLines."Loan Entry" := TRUE;
                    EntryLines."Basic Pay Entry" := FALSE;
                    EntryLines."Time Entry" := FALSE;
                    EntryLines."Loan Entry No" := LoanEntryRec."No.";
                    EntryLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                    EntryLines.INSERT;

                    IF LoanEntryRec."Calc Benefit Interest" THEN BEGIN
                        BenefitInterest := (LoanEntryRec.Repayment + LoanEntryRec."Remaining Debt") * PeriodInterest / 12 / 100;
                        CASE LoanTypeRec.Rounding OF
                            LoanTypeRec.Rounding::Nearest:
                                BenefitInterest := ROUND(BenefitInterest, LoanTypeRec."Rounding Precision", '=');
                            LoanTypeRec.Rounding::Up:
                                BenefitInterest := ROUND(BenefitInterest, LoanTypeRec."Rounding Precision", '>');
                            LoanTypeRec.Rounding::Down:
                                BenefitInterest := ROUND(BenefitInterest, LoanTypeRec."Rounding Precision", '<');
                        END;
                    END;

                    IF BenefitInterest > LoanEntryRec.Interest THEN BEGIN
                        PayrollSetupRec.GET(LoanEntryRec."Payroll Code");
                        EntryLineNo := EntryLineNo + 1;
                        EntryLines."Entry No." := EntryLineNo;
                        EntryLines."Payroll ID" := Period;
                        EntryLines."Employee No." := Header."Employee no.";
                        EntryLines.Date := gvPostingDate;
                        EntryLines.VALIDATE("ED Code", PayrollSetupRec."Interest Benefit");
                        EntryLines.VALIDATE("Currency Code", LoanRec."Currency Code");
                        EntryLines.Quantity := 0;
                        EntryLines.VALIDATE(Rate, 0);
                        EntryLines.VALIDATE(Amount, BenefitInterest - LoanEntryRec.Interest);
                        EntryLines."Copy to next" := FALSE;
                        EntryLines."Reset Amount" := FALSE;
                        EntryLines.Editable := FALSE;
                        EntryLines."Loan ID" := LoanEntryRec."Loan ID";
                        EntryLines.VALIDATE(Interest, 0);
                        EntryLines.VALIDATE(Repayment, 0);
                        EntryLines.VALIDATE("Remaining Debt", 0);
                        EntryLines.VALIDATE(Paid, 0);
                        EntryLines."Loan Entry" := TRUE;
                        EntryLines."Basic Pay Entry" := FALSE;
                        EntryLines."Time Entry" := FALSE;
                        EntryLines."Loan Entry No" := LoanEntryRec."No.";
                        EntryLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                        EntryLines.INSERT;
                    END;

                    LoanEntryRec."Transfered To Payroll" := TRUE;
                    LoanEntryRec.MODIFY;
                END;
            UNTIL LoanEntryRec.NEXT = 0;
        END;
    end;

    procedure GetTime(var Header: Record 51159)
    var
        TimeregRec: Record 5207;
        TimeRegTypesRec: Record 5206;
        PeriodRec: Record 51151;
        PayrollSetup: Record 51165;
        EmployeeRec: Record 5200;
        lvEDDef: Record 51158;
        lvPayrollPeriod: Record 51151;
        lvActiveSession: Record 2000000110;
    begin
        /*PeriodRec.GET(Header."Payroll ID", Header."Payroll Month", Header."Payroll Year", Header."Payroll Code");
        TimeregRec.SETRANGE("Employee No.",Header."Employee no.");
        EmployeeRec.GET(Header."Employee no.");
        TimeregRec.SETRANGE("Charge Date",PeriodRec."Start Date",PeriodRec."End Date");
        TimeregRec.SETRANGE(TimeregRec."Transfer to Payroll",TRUE);
        
        IF TimeregRec.FIND('-') THEN BEGIN
          REPEAT
            TimeRegTypesRec.GET(TimeregRec."Cause of Absence Code");
            IF TimeRegTypesRec."Transfer to Payroll" THEN BEGIN
              EntryLineNo := EntryLineNo + 1;
              EntryLines."Entry No." := EntryLineNo;
              EntryLines."Payroll ID" := Period;
              EntryLines."Employee No." := Header."Employee no.";
              EntryLines.VALIDATE("ED Code", TimeRegTypesRec."E/D Code");
              EntryLines.VALIDATE("Currency Code", EmployeeRec."Basic Pay Currency");
              EntryLines.Quantity := TimeregRec.Quantity;
              PayrollSetup.GET(Header."Payroll Code");
        
              //get active session 181213 cmm
              lvActiveSession.RESET;
              lvActiveSession.SETRANGE("Server Instance ID",SERVICEINSTANCEID);
              lvActiveSession.SETRANGE("Session ID",SESSIONID);
              lvActiveSession.FINDFIRST;
        
              AllowedPayrolls2.SETRANGE("User ID", lvActiveSession."User ID");
              AllowedPayrolls2.SETRANGE("Last Active Payroll",TRUE);
              IF AllowedPayrolls2.FINDFIRST THEN
                myPayrollCode := AllowedPayrolls2."Payroll Code";
        
              myMonth := DATE2DMY (TimeregRec."From Date",2);
              myYear :=  DATE2DMY (TimeregRec."From Date",3);
              myDate := DMY2DATE (1,myMonth,myYear);
        
              //cmm added 21052013 check the start date on payroll period
              lvPayrollPeriod.SETRANGE("Period ID", Header."Payroll ID");
              lvPayrollPeriod.SETRANGE("Payroll Code", Header."Payroll Code");
              lvPayrollPeriod.FINDFIRST;
        
              myPeriod.SETRANGE (myPeriod."Start Date",lvPayrollPeriod."Start Date");
              //end cmm
              //myPeriod.SETRANGE (myPeriod."Start Date",myDate);  //cmm commented 2010513
              myPeriod.SETFILTER (myPeriod."Payroll Code",myPayrollCode);
              IF myPeriod.FINDFIRST THEN BEGIN
                IF myPeriod.Hours <> 0 THEN BEGIN
                  myPeriodHrs := myPeriod.Hours;
                  myPeriodDays := myPeriod.Days;
                END;
              END;
              IF myPeriodHrs = 0
                THEN ERROR ('Period must have hours');
              IF myPeriodDays = 0
                THEN ERROR ('Period must have Days');
        
              IF TimeregRec."Day/Hour" = 0 THEN
                EntryLines.VALIDATE(Rate, Header."Day Rate")
              ELSE
                EntryLines.VALIDATE(Rate, Header."Hour Rate");
        
              IF TimeRegTypesRec.Percent >= 0 THEN EntryLines.Rate := EntryLines.Rate * TimeRegTypesRec.Percent / 100;
              lvEDDef.GET(TimeRegTypesRec."E/D Code");
              IF lvEDDef."Overtime ED" THEN BEGIN
                lvEDDef.TESTFIELD("Overtime ED Weight");
                EntryLines.Rate := EntryLines.Rate * lvEDDef."Overtime ED Weight"
              END;
        
              EntryLines.VALIDATE(Amount, EntryLines.Rate * EntryLines.Quantity);
              EntryLines."Copy to next" := FALSE;
              EntryLines."Reset Amount" := FALSE;
              EntryLines.Date := gvPostingDate;
              EntryLines.Editable := FALSE;
              EntryLines."Loan ID" := 0;
              EntryLines.VALIDATE(Interest, 0);
              EntryLines.VALIDATE(Repayment, 0);
              EntryLines.VALIDATE("Remaining Debt", 0);
              EntryLines.VALIDATE(Paid, 0);
              EntryLines."Loan Entry" := FALSE;
              EntryLines."Loan Entry No" := 0;
              EntryLines."Basic Pay Entry" := FALSE;
              EntryLines."Time Entry" := TRUE;
              EntryLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
              EntryLines.INSERT;
              TimeregRec.Transferred := TRUE;
              TimeregRec.MODIFY;
             END;
          UNTIL TimeregRec.NEXT = 0;
        END;*/

    end;

    procedure GetBasicPay(var Header: Record 51159) BasicPay: Decimal
    var
        EmployeeRec: Record 5200;
        PeriodRec: Record 51151;
        ScaleStepRec: Record 51170;
        PayrollSetupRec: Record 51165;
        BasicPayAmount: Decimal;
        BasicHourRateAmount: Decimal;
        BasicDayRateAmount: Decimal;
        AbsentDays: Integer;
        DaysEmployed: Integer;
    begin
        EmployeeRec.GET(Header."Employee no.");
        IF EmployeeRec."Basic Pay" = EmployeeRec."Basic Pay"::" " THEN EXIT;

        PayrollSetupRec.GET(Header."Payroll Code");

        PeriodRec.GET(Header."Payroll ID", Header."Payroll Month", Header."Payroll Year", Header."Payroll Code");
        PeriodRec.TESTFIELD(Hours);
        PeriodRec.TESTFIELD(Days);

        BasicPayAmount := 0;
        BasicHourRateAmount := 0;
        BasicDayRateAmount := 0;

        IF (EmployeeRec."Employment Date" > PeriodRec."Start Date") AND
           (EmployeeRec."Employment Date" <= PeriodRec."End Date") THEN BEGIN
            DaysEmployed := (PeriodRec."End Date" - EmployeeRec."Employment Date") + 1;
        END;

        CASE EmployeeRec."Basic Pay" OF
            EmployeeRec."Basic Pay"::None:
                BEGIN
                    IF EmployeeRec."Hourly Rate" <> 0 THEN BEGIN
                        BasicPayAmount := EmployeeRec."Hourly Rate";
                        BasicHourRateAmount := BasicPayAmount * PeriodRec.Hours;
                    END;
                    IF EmployeeRec."Daily Rate" <> 0 THEN BEGIN
                        BasicPayAmount := EmployeeRec."Daily Rate";
                        BasicDayRateAmount := BasicPayAmount * PeriodRec.Days;
                    END;
                END;
            EmployeeRec."Basic Pay"::Fixed:
                BEGIN
                    BasicPayAmount := EmployeeRec."Fixed Pay";
                    BasicHourRateAmount := BasicPayAmount / PeriodRec.Hours;
                    BasicDayRateAmount := BasicPayAmount / PeriodRec.Days;
                END;
            EmployeeRec."Basic Pay"::Scale:
                BEGIN
                    ScaleStepRec.GET(EmployeeRec."Scale Step", EmployeeRec."Salary Scale");
                    IF ScaleStepRec."Currency Code" <> EmployeeRec."Basic Pay Currency" THEN
                        ERROR('Salary Scale %1 step %2 is not in the basic pay currency of employee %3', EmployeeRec."Salary Scale",
                          EmployeeRec."Scale Step", EmployeeRec."No.");
                    BasicPayAmount := ScaleStepRec.Amount;
                    BasicHourRateAmount := BasicPayAmount / PeriodRec.Hours;
                    BasicDayRateAmount := BasicPayAmount / PeriodRec.Days;
                END;
        END;

        IF BasicDayRateAmount > 0 THEN BEGIN
            CASE PayrollSetupRec."Daily Rate Rounding" OF
                PayrollSetupRec."Daily Rate Rounding"::Up:
                    BasicDayRateAmount := ROUND(BasicDayRateAmount, PayrollSetupRec."Daily Rounding Precision", '>');
                PayrollSetupRec."Daily Rate Rounding"::Down:
                    BasicDayRateAmount := ROUND(BasicDayRateAmount, PayrollSetupRec."Daily Rounding Precision", '<');
                PayrollSetupRec."Daily Rate Rounding"::Nearest:
                    BasicDayRateAmount := ROUND(BasicDayRateAmount, PayrollSetupRec."Daily Rounding Precision", '=');
            END;
        END;

        IF BasicHourRateAmount > 0 THEN BEGIN
            CASE PayrollSetupRec."Hourly Rate Rounding" OF
                PayrollSetupRec."Hourly Rate Rounding"::Up:
                    BasicHourRateAmount := ROUND(BasicHourRateAmount, PayrollSetupRec."Hourly Rounding Precision", '>');
                PayrollSetupRec."Hourly Rate Rounding"::Down:
                    BasicHourRateAmount := ROUND(BasicHourRateAmount, PayrollSetupRec."Hourly Rounding Precision", '<');
                PayrollSetupRec."Hourly Rate Rounding"::Nearest:
                    BasicHourRateAmount := ROUND(BasicHourRateAmount, PayrollSetupRec."Hourly Rounding Precision", '=');
            END;
        END;

        IF DaysEmployed <> 0 THEN BasicPayAmount := DaysEmployed * BasicDayRateAmount;
        Header."Basic Pay" := BasicPayAmount;
        Header."Hour Rate" := BasicHourRateAmount;
        Header."Day Rate" := BasicDayRateAmount;
        IF EmployeeRec."Basic Pay Currency" <> '' THEN BEGIN
            Header."Basic Pay Currency Code" := EmployeeRec."Basic Pay Currency";
            Header."Basic Pay Currency Factor" :=
              gvCurrExchRate.ExchangeRate(gvPostingDate, EmployeeRec."Basic Pay Currency");
            gvCurrency.GET(EmployeeRec."Basic Pay Currency");
            Header."Basic Pay (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(gvPostingDate,
              gvCurrency.Code, BasicPayAmount, Header."Basic Pay Currency Factor"), gvCurrency."Unit-Amount Rounding Precision");
            Header."Hour Rate (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(gvPostingDate,
              gvCurrency.Code, BasicHourRateAmount, Header."Basic Pay Currency Factor"), gvCurrency."Unit-Amount Rounding Precision");
            Header."Day Rate (LCY)" := ROUND(gvCurrExchRate.ExchangeAmtFCYToLCY(gvPostingDate,
              gvCurrency.Code, BasicDayRateAmount, Header."Basic Pay Currency Factor"), gvCurrency."Unit-Amount Rounding Precision");
        END ELSE BEGIN
            Header."Basic Pay (LCY)" := BasicPayAmount;
            Header."Hour Rate (LCY)" := BasicHourRateAmount;
            Header."Day Rate (LCY)" := BasicDayRateAmount;
        END;
        //skm240807 commented line gave record modified by another user error
        //Header.MODIFY;

        EntryLineNo := EntryLineNo + 1;
        EntryLines."Entry No." := EntryLineNo;
        EntryLines."Payroll ID" := Period;
        EntryLines."Employee No." := Header."Employee no.";
        EntryLines.VALIDATE("ED Code", PayrollSetupRec."Basic Pay E/D Code");
        EntryLines.Date := gvPostingDate;
        EntryLines.VALIDATE("Currency Code", EmployeeRec."Basic Pay Currency");
        EntryLines.Quantity := 0;
        EntryLines.VALIDATE(Rate, 0);
        EntryLines.VALIDATE(Amount, BasicPayAmount);
        EntryLines."Copy to next" := FALSE;
        EntryLines."Reset Amount" := FALSE;
        EntryLines.Editable := FALSE;
        EntryLines."Loan ID" := 0;
        EntryLines.VALIDATE(Interest, 0);
        EntryLines.VALIDATE(Repayment, 0);
        EntryLines.VALIDATE("Remaining Debt", 0);
        EntryLines.VALIDATE(Paid, 0);
        EntryLines."Loan Entry" := FALSE;
        EntryLines."Loan Entry No" := 0;
        EntryLines."Basic Pay Entry" := TRUE;
        EntryLines."Time Entry" := FALSE;
        EntryLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
        EntryLines.INSERT;
    end;

    procedure GetInfo()
    var
        CalcScheme: Record 51154;
        EDDefinition: Record 51158;
    begin
        CalcScheme.FIND('-');
        REPEAT
            SchemeControlTmp.COPY(CalcScheme);
            SchemeControlTmp.INSERT;
            SchemeValueTmp.COPY(CalcScheme);
            SchemeValueTmp.INSERT;
        UNTIL CalcScheme.NEXT = 0;

        EDDefinition.FIND('-');
        REPEAT
            EDDefinitionTmp.COPY(EDDefinition);
            EDDefinitionTmp.INSERT;
        UNTIL EDDefinition.NEXT = 0;
    end;

    procedure GetInput(var Header: Record 51159)
    var
        InterestAmount: Decimal;
        RemainingDebt: Decimal;
        PaidAmount: Decimal;
        RepaymentAmount: Decimal;
        InterestAmountLCY: Decimal;
        RemainingDebtLCY: Decimal;
        PaidAmountLCY: Decimal;
        RepaymentAmountLCY: Decimal;
        "---V.6.1.65---": Integer;
        lvPayrollHeader: Record 51159;
        lvAmount: Decimal;
        lvAmountLCY: Decimal;
    begin
        CASE SchemeControlTmp.Input OF
            SchemeControlTmp.Input::"Calculation Line":
                BEGIN
                    SchemeValueTmp.GET(SchemeControlTmp."Caculation Line", Scheme);
                    Amount := SchemeValueTmp.Amount;
                    "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                    SchemeValueTmp.GET(LineNo, Scheme);
                    SchemeValueTmp.Amount := Amount;
                    SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                    SchemeValueTmp.MODIFY;
                END;

            SchemeControlTmp.Input::"Payroll Entry":
                BEGIN
                    EDDefinitionTmp.GET(SchemeControlTmp."Payroll Entry");

                    IF (NOT EDDefinitionTmp."Sum Payroll Entries") AND
                       (SchemeControlTmp."Payroll Entry" = SchemeControlTmp."Payroll Lines") THEN BEGIN
                        SchemeControlTmp.Multiline := TRUE;
                        SchemeControlTmp.MODIFY;
                    END;

                    EntryLines.SETRANGE("ED Code", SchemeControlTmp."Payroll Entry");

                    IF EntryLines.FIND('-') THEN BEGIN
                        Amount := 0;
                        Quantity := 0;
                        InterestAmount := 0;
                        RemainingDebt := 0;
                        PaidAmount := 0;
                        RepaymentAmount := 0;

                        "Amount (LCY)" := 0;
                        InterestAmountLCY := 0;
                        RemainingDebtLCY := 0;
                        PaidAmountLCY := 0;
                        RepaymentAmountLCY := 0;

                        IF SchemeControlTmp.Multiline THEN EntryLinesTMP.DELETEALL(TRUE);

                        REPEAT
                            IF SchemeControlTmp.Multiline THEN BEGIN
                                EntryLinesTMP.COPY(EntryLines);
                                CASE SchemeControlTmp.Round OF
                                    SchemeControlTmp.Round::Up:
                                        BEGIN
                                            EntryLinesTMP.Amount := ROUND(EntryLinesTMP.Amount, SchemeValueTmp."Round Precision", '>');
                                            EntryLinesTMP."Amount (LCY)" := ROUND(EntryLinesTMP."Amount (LCY)", SchemeValueTmp."Round Precision", '>');
                                        END;

                                    SchemeControlTmp.Round::Down:
                                        BEGIN
                                            EntryLinesTMP.Amount := ROUND(EntryLinesTMP.Amount, SchemeValueTmp."Round Precision", '<');
                                            EntryLinesTMP."Amount (LCY)" := ROUND(EntryLinesTMP."Amount (LCY)", SchemeValueTmp."Round Precision", '<');
                                        END;

                                    SchemeControlTmp.Round::Nearest:
                                        BEGIN
                                            EntryLinesTMP.Amount := ROUND(EntryLinesTMP.Amount, SchemeValueTmp."Round Precision", '=');
                                            EntryLinesTMP."Amount (LCY)" := ROUND(EntryLinesTMP."Amount (LCY)", SchemeValueTmp."Round Precision", '=');
                                        END;
                                END;

                                EntryLinesTMP.VALIDATE("ED Code");
                                EntryLinesTMP.INSERT;
                            END;

                            InterestAmount += EntryLines.Interest;
                            RemainingDebt += EntryLines."Remaining Debt";
                            PaidAmount += EntryLines.Paid;
                            RepaymentAmount += EntryLines.Repayment;

                            InterestAmountLCY += EntryLines."Interest (LCY)";
                            RemainingDebtLCY += EntryLines."Remaining Debt (LCY)";
                            PaidAmountLCY += EntryLines."Paid (LCY)";
                            RepaymentAmountLCY += EntryLines."Repayment (LCY)";

                            Amount += EntryLines.Amount;
                            "Amount (LCY)" += EntryLines."Amount (LCY)";
                            Quantity += EntryLines.Quantity;
                        UNTIL EntryLines.NEXT = 0;

                        SchemeValueTmp.GET(LineNo, Scheme);
                        SchemeValueTmp.Amount := Amount;
                        SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                        SchemeValueTmp.Quantity := Quantity;
                        SchemeValueTmp.Interest := InterestAmount;
                        SchemeValueTmp."Interest (LCY)" := InterestAmountLCY;
                        SchemeValueTmp.Repayment := RepaymentAmount;
                        SchemeValueTmp."Repayment (LCY)" := RepaymentAmountLCY;
                        SchemeValueTmp."Remaining Debt" := RemainingDebt;
                        SchemeValueTmp."Remaining Debt (LCY)" := RemainingDebtLCY;
                        SchemeValueTmp.Paid := PaidAmount;
                        SchemeValueTmp."Paid (LCY)" := PaidAmountLCY;
                        SchemeValueTmp."Loan Entry" := EntryLines."Loan Entry";

                        IF (Quantity > 0) AND (Amount > 0) THEN SchemeValueTmp.Rate := Amount / Quantity;

                        SchemeValueTmp.MODIFY;
                    END;
                END;
            SchemeControlTmp.Input::None:
                BEGIN
                    //V.6.1.65_10SEP10 >>
                    IF PeriodRec."Annualize TAX" THEN BEGIN
                        IF (SchemeControlTmp."Annualize TAX") OR (SchemeControlTmp."Annualize Relief") THEN BEGIN
                            Flag := TRUE;
                            CLEAR(lvPayrollHeader);
                            lvPayrollHeader.SETRANGE("Employee no.", gvPayrollHeader."Employee no.");
                            lvPayrollHeader.SETRANGE("Payroll Year", gvPayrollHeader."Payroll Year");
                            lvPayrollHeader.SETFILTER("Payroll Month", '%1..%2', 1, gvPayrollHeader."Payroll Month");
                            IF lvPayrollHeader.FINDSET THEN
                                REPEAT
                                    lvAmount += lvPayrollHeader."H (LCY)";
                                    lvAmountLCY += lvPayrollHeader."H (LCY)";
                                UNTIL lvPayrollHeader.NEXT = 0;
                            SchemeValueTmp.Amount := lvAmount;
                            SchemeValueTmp."Amount (LCY)" := lvAmountLCY;
                            SchemeValueTmp.MODIFY;
                            Amount := SchemeValueTmp.Amount;
                            "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                        END;
                    END;
                    //V.6.1.65_10SEP10 <<
                END;
        END;
    end;

    procedure RoundAmount()
    begin
        //V.6.1.65_10SEP10 >>
        IF NOT Flag THEN
            SchemeValueTmp.GET(LineNo, Scheme);
        CASE SchemeControlTmp.Round OF
            SchemeControlTmp.Round::Up:
                BEGIN
                    SchemeValueTmp.Amount := ROUND(SchemeValueTmp.Amount, SchemeValueTmp."Round Precision", '>');
                    SchemeValueTmp."Amount (LCY)" := ROUND(SchemeValueTmp."Amount (LCY)", SchemeValueTmp."Round Precision", '>');
                END;
            SchemeControlTmp.Round::Down:
                BEGIN
                    SchemeValueTmp.Amount := ROUND(SchemeValueTmp.Amount, SchemeValueTmp."Round Precision", '<');
                    SchemeValueTmp."Amount (LCY)" := ROUND(SchemeValueTmp."Amount (LCY)", SchemeValueTmp."Round Precision", '<');
                END;
            SchemeControlTmp.Round::Nearest:
                BEGIN
                    SchemeValueTmp.Amount := ROUND(SchemeValueTmp.Amount, SchemeValueTmp."Round Precision", '=');
                    SchemeValueTmp."Amount (LCY)" := ROUND(SchemeValueTmp."Amount (LCY)", SchemeValueTmp."Round Precision", '=');
                END
        END;
        //V.6.1.65 >>
        IF (SchemeValueTmp.P9A = SchemeValueTmp.P9A::L) THEN BEGIN
            SchemeValueTmp.Amount := SchemeValueTmp.Amount - AnnualReliefAmt;
            SchemeValueTmp."Amount (LCY)" := SchemeValueTmp."Amount (LCY)" - AnnualReliefAmt;
            AnnualReliefAmt := 0;
            Flag1 := FALSE;
        END;
        //V.6.1.65 <<
        SchemeValueTmp.MODIFY;
    end;

    procedure Calculate(var Header: Record 51159)
    var
        lvPayrollSetup: Record 51165;
        lvEmployee: Record 5200;
    begin
        //CSM 10082010 added to distinguish ethiopian tax calculation
        lvPayrollSetup.GET(Header."Payroll Code");
        IF lvPayrollSetup."Tax Calculation" = lvPayrollSetup."Tax Calculation"::Kenya THEN BEGIN
            CASE SchemeControlTmp.Calculation OF
                SchemeControlTmp.Calculation::Add:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        //PMC 20100830: ODC Phase2 FRD P13 - Check if Hse or Commuter Allowance and prorate
                        IF lvEmployee.GET(Header."Employee no.") THEN
                            IF lvEmployee."Housing Eligibility" <> lvEmployee."Housing Eligibility"::House THEN
                                IF ((SchemeValueTmp."Payroll Entry" = lvPayrollSetup."House Allowances ED") OR
                                    (SchemeValueTmp."Payroll Entry" = lvPayrollSetup."Commuter Allowance ED")) THEN
                                    /* lvHRMEmpLedger.SETRANGE("Employee No.",Header."Employee no.");
                                     IF lvHRMEmpLedger.FINDFIRST THEN
                                     IF ((lvHRMEmpLedger."Housing Type" = lvHRMEmpLedger."Housing Type"::"1") OR
                                         (lvHRMEmpLedger."Housing Type" = lvHRMEmpLedger."Housing Type"::"0")) THEN
                                         IF ((lvHRMEmpLedger."Posting Date" > PeriodRec."Start Date") AND
                                         (lvHRMEmpLedger."Posting Date" < PeriodRec."End Date")) THEN
                                       BEGIN
                                         Amount := lvEmployee."Fixed Pay" * (lvHRMEmpLedger."Posting Date" - PeriodRec."Start Date")/
                                                   (PeriodRec."End Date"-PeriodRec."Start Date");
                                         "Amount (LCY)" := lvEmployee."Fixed Pay" * (lvHRMEmpLedger."Posting Date" - PeriodRec."Start Date")/
                                                            (PeriodRec."End Date"-PeriodRec."Start Date");
                                       END ELSE
                                     IF ((lvHRMEmpLedger."Housing Type" = lvHRMEmpLedger."Housing Type"::"3") AND
                                         (lvHRMEmpLedger."Posting Date" > PeriodRec."Start Date") AND
                                         (lvHRMEmpLedger."Posting Date" < PeriodRec."End Date")) THEN
                                       BEGIN
                                         Amount := lvEmployee."Fixed Pay" * (PeriodRec."End Date"-lvHRMEmpLedger."Posting Date")/
                                                   (PeriodRec."End Date"-PeriodRec."Start Date");
                                         "Amount (LCY)" := lvEmployee."Fixed Pay" * (PeriodRec."End Date"-lvHRMEmpLedger."Posting Date")/
                                                            (PeriodRec."End Date"-PeriodRec."Start Date");
                                       END ELSE BEGIN
                                     //PMC 20100830: ODC Phase2 FRD P13
                                     Amount := SchemeValueTmp.Amount;
                                     "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                                     END;//PMC 20100830: ODC Phase2 FRD P13
                                     */
                  SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        Amount := SchemeValueTmp.Amount;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.Amount += Amount;
                        SchemeValueTmp."Amount (LCY)" += "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Substract:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        SchemeValueTmp.Amount -= Amount;
                        SchemeValueTmp."Amount (LCY)" -= "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Multiply:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount * SchemeValueTmp.Number;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)" * SchemeValueTmp.Number;
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        SchemeValueTmp.Amount := Amount;
                        SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Divide:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount / SchemeValueTmp.Number;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)" / SchemeValueTmp.Number;
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        SchemeValueTmp.Amount := Amount;
                        SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Percent:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount * SchemeValueTmp.Percent / 100;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)" * SchemeValueTmp.Percent / 100;
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        SchemeValueTmp.Amount := Amount;
                        SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Highest:
                    BEGIN
                        SchemeValueTmp.GET(SchemeValueTmp."Factor of", Scheme);
                        Amount1 := SchemeValueTmp.Amount;
                        Amount1LCY := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        IF Amount < Amount1 THEN BEGIN
                            SchemeValueTmp.Amount := Amount1;
                            SchemeValueTmp."Amount (LCY)" := Amount1LCY;
                            Amount := 0;
                            Amount1 := 0;
                            "Amount (LCY)" := 0;
                            Amount1LCY := 0;
                            SchemeValueTmp.MODIFY;
                        END ELSE BEGIN
                            SchemeValueTmp.Amount := Amount;
                            SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                            Amount := 0;
                            Amount1 := 0;
                            "Amount (LCY)" := 0;
                            Amount1LCY := 0;
                            SchemeValueTmp.MODIFY;
                        END;
                    END;

                SchemeControlTmp.Calculation::Lowest:
                    BEGIN
                        SchemeValueTmp.GET(SchemeControlTmp."Factor of", Scheme);
                        Amount1 := SchemeValueTmp.Amount;
                        Amount1LCY := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        IF Amount < Amount1 THEN BEGIN
                            SchemeValueTmp.Amount := Amount;
                            SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                            Amount := 0;
                            Amount1 := 0;
                            "Amount (LCY)" := 0;
                            Amount1LCY := 0;
                            SchemeValueTmp.MODIFY;
                        END ELSE BEGIN
                            SchemeValueTmp.Amount := Amount1;
                            SchemeValueTmp."Amount (LCY)" := Amount1LCY;
                            Amount := 0;
                            Amount1 := 0;
                            "Amount (LCY)" := 0;
                            Amount1LCY := 0;
                            SchemeValueTmp.MODIFY;
                        END;
                    END;
                SchemeControlTmp.Calculation::"Look Up":
                    LookUp(Header);
            END;
        END;
        IF lvPayrollSetup."Tax Calculation" = lvPayrollSetup."Tax Calculation"::Ethiopia THEN BEGIN
            CASE SchemeControlTmp.Calculation OF
                SchemeControlTmp.Calculation::Add:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        SchemeValueTmp.Amount += Amount;
                        SchemeValueTmp."Amount (LCY)" += "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Substract:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        SchemeValueTmp.Amount -= Amount;
                        SchemeValueTmp."Amount (LCY)" -= "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Multiply:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount * SchemeValueTmp.Number;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)" * SchemeValueTmp.Number;
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        SchemeValueTmp.Amount := Amount;
                        SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Divide:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount / SchemeValueTmp.Number;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)" / SchemeValueTmp.Number;
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        SchemeValueTmp.Amount := Amount;
                        SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Percent:
                    BEGIN
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount * SchemeValueTmp.Percent / 100;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)" * SchemeValueTmp.Percent / 100;
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        SchemeValueTmp.Amount := Amount;
                        SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                        SchemeValueTmp.MODIFY;
                    END;

                SchemeControlTmp.Calculation::Highest:
                    BEGIN
                        SchemeValueTmp.GET(SchemeValueTmp."Factor of", Scheme);
                        Amount1 := SchemeValueTmp.Amount;
                        Amount1LCY := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        IF Amount < Amount1 THEN BEGIN
                            SchemeValueTmp.Amount := Amount1;
                            SchemeValueTmp."Amount (LCY)" := Amount1LCY;
                            Amount := 0;
                            Amount1 := 0;
                            "Amount (LCY)" := 0;
                            Amount1LCY := 0;
                            SchemeValueTmp.MODIFY;
                        END ELSE BEGIN
                            SchemeValueTmp.Amount := Amount;
                            SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                            Amount := 0;
                            Amount1 := 0;
                            "Amount (LCY)" := 0;
                            Amount1LCY := 0;
                            SchemeValueTmp.MODIFY;
                        END;
                    END;

                SchemeControlTmp.Calculation::Lowest:
                    BEGIN
                        SchemeValueTmp.GET(SchemeControlTmp."Factor of", Scheme);
                        Amount1 := SchemeValueTmp.Amount;
                        Amount1LCY := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(LineNo, Scheme);
                        Amount := SchemeValueTmp.Amount;
                        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
                        IF Amount < Amount1 THEN BEGIN
                            SchemeValueTmp.Amount := Amount;
                            SchemeValueTmp."Amount (LCY)" := "Amount (LCY)";
                            Amount := 0;
                            Amount1 := 0;
                            "Amount (LCY)" := 0;
                            Amount1LCY := 0;
                            SchemeValueTmp.MODIFY;
                        END ELSE BEGIN
                            SchemeValueTmp.Amount := Amount1;
                            SchemeValueTmp."Amount (LCY)" := Amount1LCY;
                            Amount := 0;
                            Amount1 := 0;
                            "Amount (LCY)" := 0;
                            Amount1LCY := 0;
                            SchemeValueTmp.MODIFY;
                        END;
                    END;
                SchemeControlTmp.Calculation::"Look Up":
                    LookUpEthiopia(Header);
            END;
        END;

    end;

    procedure LookUp(var Header: Record 51159)
    var
        LookUpHeader: Record 51162;
        LookUpLine: Record 51163;
    begin
        LookUpHeader.GET(SchemeControlTmp.LookUp);
        LookUpLine.SETRANGE("Table ID", SchemeControlTmp.LookUp);
        //V.6.1.65_10SEP10 >>
        IF NOT Flag THEN
            SchemeValueTmp.GET(LineNo, Scheme);
        Amount := SchemeValueTmp.Amount;
        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";

        CASE LookUpHeader.Type OF
            LookUpHeader.Type::Percentage:
                BEGIN
                    LookUpLine.FIND('-');

                    WHILE "Amount (LCY)" > LookUpLine."Upper Amount (LCY)" DO
                        LookUpLine.FIND('>');

                    Percent := LookUpLine.Percent;
                    IF LookUpLine.FIND('<') THEN BEGIN
                        Cum := LookUpLine."Cumulate (LCY)";
                        Amount1LCY := (("Amount (LCY)" - LookUpLine."Upper Amount (LCY)") * Percent / 100) + Cum;
                    END ELSE BEGIN
                        Amount1LCY := ("Amount (LCY)" * Percent / 100);
                    END;
                    CalculateAnnualTax(Header);//V.6.1.65_10SEP10 >>
                END;
            LookUpHeader.Type::"Extract Amount":
                BEGIN
                    LookUpLine.FIND('-');
                    WHILE NOT ("Amount (LCY)" <= LookUpLine."Upper Amount (LCY)") DO
                        LookUpLine.FIND('>');

                    Amount1LCY := LookUpLine."Extract Amount (LCY)";
                    CalculateAnnualTax(Header);//V.6.1.65_10SEP10 >>
                END;
            LookUpHeader.Type::Month:
                BEGIN
                    LookUpLine.FIND('-');
                    WHILE Header."Payroll Month" <> LookUpLine.Month DO
                        LookUpLine.FIND('>');
                    Amount1LCY := LookUpLine."Extract Amount (LCY)";

                    CalculateAnnualTax(Header);//V.6.1.65_10SEP10 >>
                END;
            LookUpHeader.Type::"Max Min":
                BEGIN
                    IF LookUpHeader."Min Extract Amount (LCY)" <> 0 THEN
                        IF "Amount (LCY)" < LookUpHeader."Min Extract Amount (LCY)" THEN
                            Amount1LCY := LookUpHeader."Min Extract Amount (LCY)";
                    IF LookUpHeader."Max Extract Amount (LCY)" <> 0 THEN
                        IF "Amount (LCY)" > LookUpHeader."Max Extract Amount (LCY)" THEN
                            Amount1LCY := LookUpHeader."Max Extract Amount (LCY)";
                    CalculateAnnualTax(Header);//V.6.1.65_10SEP10 >>
                END;
        END;
        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
        SchemeValueTmp.Amount := Amount1LCY;
        SchemeValueTmp."Amount (LCY)" := Amount1LCY;
        SchemeValueTmp.MODIFY;
    end;

    procedure Output(var Header: Record 51159)
    var
        EmployeeRec: Record 5200;
        lvHeader: Record 51159;
    begin
        EmployeeRec.GET(Header."Employee no.");
        //V.6.1.65_10SEP10 >>
        IF NOT Flag THEN
            SchemeValueTmp.GET(LineNo, Scheme);
        // SchemeValueTmp.GET(SchemeValueTmp."Compute To",Scheme);
        //ELSE

        //Output payroll header
        CASE SchemeValueTmp.P9A OF
            SchemeValueTmp.P9A::A:
                Header."A (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::B:
                Header."B (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::C:
                Header."C (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::D:
                Header."D (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::E1:
                Header."E1 (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::E2:
                Header."E2 (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::E3:
                Header."E3 (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::F:
                Header."F (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::G:
                Header."G (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::H:
                Header."H (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::J:
                Header."J (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::K:
                Header."K (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::L:
                Header."L (LCY)" := SchemeValueTmp."Amount (LCY)";
            SchemeValueTmp.P9A::M:
                Header."M (LCY)" := SchemeValueTmp."Amount (LCY)";
        END;
        //V.6.1.65_13SEP10 >>
        IF gvPayrollHeader."L (LCY)" <> Header."L (LCY)" THEN BEGIN
            gvPayrollHeader."K (LCY)" := Header."K (LCY)";
            IF SchemeValueTmp.P9A = SchemeValueTmp.P9A::L THEN BEGIN
                gvPayrollHeader."L (LCY)" := Header."L (LCY)";
                gvPayrollHeader.Calculated := TRUE;
                IF gvPayrollHeader."M (LCY)" < 0 THEN gvPayrollHeader."M (LCY)" := 0;
                IF PeriodRec."Annualize TAX" THEN
                    gvPayrollHeader.MODIFY;
            END;
            gvPayrollHeader."A (LCY)" := Header."A (LCY)";
            gvPayrollHeader."B (LCY)" := Header."B (LCY)";
            gvPayrollHeader."C (LCY)" := Header."C (LCY)";
            gvPayrollHeader."D (LCY)" := Header."D (LCY)";
            gvPayrollHeader."E1 (LCY)" := Header."E1 (LCY)";
            gvPayrollHeader."E2 (LCY)" := Header."E2 (LCY)";
            gvPayrollHeader."E3 (LCY)" := Header."E3 (LCY)";
            gvPayrollHeader."F (LCY)" := Header."F (LCY)";
            gvPayrollHeader."G (LCY)" := Header."G (LCY)";
            gvPayrollHeader."H (LCY)" := Header."H (LCY)";
            gvPayrollHeader.Calculated := TRUE;

            IF SchemeValueTmp.P9A = SchemeValueTmp.P9A::L THEN BEGIN
                IF PeriodRec."Annualize TAX" THEN
                    PayrollHeader."J (LCY)" := BeforeReliefAmt;
                PayrollHeader.MODIFY;
                BeforeReliefAmt := 0;
            END;

            IF SchemeValueTmp.P9A = SchemeValueTmp.P9A::J THEN BEGIN
                IF PeriodRec."Annualize TAX" THEN
                    gvPayrollHeader."J (LCY)" := BeforeReliefAmt
                ELSE
                    gvPayrollHeader."J (LCY)" := Header."J (LCY)";
                IF PeriodRec."Annualize TAX" THEN BEGIN
                    gvPayrollHeader.Calculated := TRUE;
                    IF gvPayrollHeader."M (LCY)" < 0 THEN gvPayrollHeader."M (LCY)" := 0;
                    gvPayrollHeader.MODIFY;
                END;
            END;
            gvPayrollHeader."M (LCY)" := Header."M (LCY)";
        END;
        IF Flag THEN BEGIN
            CASE SchemeValueTmp.P9A OF
                SchemeValueTmp.P9A::K:
                    gvPayrollHeader."K (LCY)" := Header."K (LCY)";
                SchemeValueTmp.P9A::L:
                    gvPayrollHeader."L (LCY)" := Header."L (LCY)";
            END;
            IF PeriodRec."Annualize TAX" THEN
                gvPayrollHeader.MODIFY;
        END;
        //V.6.1.65_13SEP10 <<
        //Output payroll lines
        IF SchemeControlTmp."Payroll Lines" <> '' THEN BEGIN
            IF SchemeControlTmp.Multiline THEN BEGIN
                IF EntryLinesTMP.FIND('-') THEN BEGIN
                    REPEAT
                        IF EntryLinesTMP.Amount > 0 THEN BEGIN
                            PayrollLinesTmpLineNo := PayrollLinesTmpLineNo + 1;
                            EDDefinitionTmp.GET(EntryLinesTMP."ED Code");
                            PayrollLinesTmp."Entry No." := PayrollLinesTmpLineNo;
                            PayrollLinesTmp."Payroll ID" := Period;
                            PayrollLinesTmp."Employee No." := Header."Employee no.";
                            PayrollLinesTmp."Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                            PayrollLinesTmp."Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                            PayrollLinesTmp."Posting Group" := EmployeeRec."Posting Group";
                            PayrollLinesTmp."ED Code" := EntryLinesTMP."ED Code";
                            PayrollLinesTmp."Currency Code" := EntryLinesTMP."Currency Code";
                            PayrollLinesTmp."Currency Factor" := EntryLinesTMP."Currency Factor";
                            PayrollLinesTmp.Text := EDDefinitionTmp."Payroll Text";
                            PayrollLinesTmp.Amount := EntryLinesTMP.Amount;
                            PayrollLinesTmp."Amount (LCY)" := EntryLinesTMP."Amount (LCY)";
                            PayrollLinesTmp.Quantity := EntryLinesTMP.Quantity;
                            PayrollLinesTmp.Rate := EntryLinesTMP.Rate;
                            PayrollLinesTmp."Rate (LCY)" := EntryLinesTMP."Rate (LCY)";
                            PayrollLinesTmp."Calculation Group" := EDDefinitionTmp."Calculation Group";
                            PayrollLinesTmp.Rounding := EDDefinitionTmp."Rounding ED";
                            PayrollLinesTmp."Loan Entry" := EntryLinesTMP."Loan Entry";
                            PayrollLinesTmp."Loan Entry No" := EntryLinesTMP."Loan Entry No";
                            PayrollLinesTmp."Loan ID" := EntryLinesTMP."Loan ID";
                            PayrollLinesTmp.Interest := EntryLinesTMP.Interest;
                            PayrollLinesTmp."Interest (LCY)" := EntryLinesTMP."Interest (LCY)";
                            PayrollLinesTmp.Repayment := EntryLinesTMP.Repayment;
                            PayrollLinesTmp."Repayment (LCY)" := EntryLinesTMP."Repayment (LCY)";
                            PayrollLinesTmp."Remaining Debt" := EntryLinesTMP."Remaining Debt";
                            PayrollLinesTmp."Remaining Debt (LCY)" := EntryLinesTMP."Remaining Debt (LCY)";
                            PayrollLinesTmp.Paid := EntryLinesTMP.Paid;
                            PayrollLinesTmp."Paid (LCY)" := EntryLinesTMP."Paid (LCY)";
                            PayrollLinesTmp."Posting Date" := gvPostingDate;
                            PayrollLinesTmp."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                            PayrollLinesTmp.INSERT;
                            gvPayrollUtilities.sCopyDimsFromEntryToLines(EntryLinesTMP, PayrollLinesTmp)
                        END;
                    UNTIL EntryLinesTMP.NEXT = 0;
                    EntryLinesTMP.DELETEALL(TRUE);
                END;
            END ELSE BEGIN
                IF SchemeValueTmp.Amount > 0 THEN BEGIN
                    PayrollLinesTmpLineNo := PayrollLinesTmpLineNo + 1;
                    EDDefinitionTmp.GET(SchemeValueTmp."Payroll Lines");
                    PayrollLinesTmp."Entry No." := PayrollLinesTmpLineNo;
                    PayrollLinesTmp."Payroll ID" := Period;
                    PayrollLinesTmp."Employee No." := Header."Employee no.";
                    PayrollLinesTmp."Currency Code" := SchemeValueTmp."Currency Code";
                    PayrollLinesTmp."Currency Factor" := SchemeValueTmp."Currency Factor";
                    PayrollLinesTmp."Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                    PayrollLinesTmp."Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                    PayrollLinesTmp."Posting Group" := EmployeeRec."Posting Group";
                    PayrollLinesTmp."ED Code" := EDDefinitionTmp."ED Code";
                    PayrollLinesTmp.Text := EDDefinitionTmp."Payroll Text";
                    PayrollLinesTmp.Amount := SchemeValueTmp.Amount;
                    PayrollLinesTmp."Amount (LCY)" := SchemeValueTmp."Amount (LCY)";
                    PayrollLinesTmp.Quantity := SchemeValueTmp.Quantity;
                    PayrollLinesTmp.Rate := SchemeValueTmp.Rate;
                    PayrollLinesTmp."Rate (LCY)" := SchemeValueTmp."Rate (LCY)";
                    PayrollLinesTmp."Calculation Group" := EDDefinitionTmp."Calculation Group";
                    PayrollLinesTmp.Rounding := EDDefinitionTmp."Rounding ED";
                    PayrollLinesTmp."Loan Entry" := SchemeValueTmp."Loan Entry";
                    PayrollLinesTmp."Loan Entry No" := EntryLines."Loan Entry No";
                    PayrollLinesTmp."Loan ID" := EntryLines."Loan ID";
                    PayrollLinesTmp.Interest := SchemeValueTmp.Interest;
                    PayrollLinesTmp."Interest (LCY)" := SchemeValueTmp."Interest (LCY)";
                    PayrollLinesTmp.Repayment := SchemeValueTmp.Repayment;
                    PayrollLinesTmp."Repayment (LCY)" := SchemeValueTmp."Repayment (LCY)";
                    PayrollLinesTmp."Remaining Debt" := SchemeValueTmp."Remaining Debt";
                    PayrollLinesTmp."Remaining Debt (LCY)" := SchemeValueTmp."Remaining Debt (LCY)";
                    PayrollLinesTmp.Paid := SchemeValueTmp.Paid;
                    PayrollLinesTmp."Paid (LCY)" := SchemeValueTmp."Paid (LCY)";
                    PayrollLinesTmp."Posting Date" := gvPostingDate;
                    PayrollLinesTmp."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                    PayrollLinesTmp.INSERT;
                    gvPayrollUtilities.sGetDefaultEDDims2(PayrollLinesTmp);
                END;
            END;
        END;
    end;

    procedure BringFWDrounding()
    var
        PayrollHeaderRec: Record 51159;
        PeriodsRec: Record 51151;
        NetAmount: Decimal;
        RoundAmount: Decimal;
        PayrollSetup: Record 51165;
        PayrollEntry: Record 51161;
    begin
        //Bring Foward Net Pay Rounding from the previous payroll month if any
        PayrollSetup.GET(gvAllowedPayrolls."Payroll Code");

        PayrollEntry.SETCURRENTKEY("Employee No.", "Payroll ID", "ED Code");
        PayrollEntry.SETRANGE("Employee No.", Employee."No.");
        PayrollEntry.SETRANGE("Payroll ID", Period);
        PayrollEntry.SETRANGE("ED Code", PayrollSetup."Net Pay Rounding B/F");
        PayrollEntry.DELETEALL(TRUE);

        PayrollEntry.RESET;
        PayrollEntry.SETCURRENTKEY("Employee No.", "Payroll ID", "ED Code");
        PayrollEntry.SETRANGE("Employee No.", Employee."No.");
        PayrollEntry.SETRANGE("Payroll ID", Period);
        PayrollEntry.SETRANGE("ED Code", PayrollSetup."Net Pay Rounding B/F (-Ve)");
        PayrollEntry.DELETEALL(TRUE);

        PayrollEntry.RESET;
        PayrollEntry.SETCURRENTKEY("Employee No.", "Payroll ID", "ED Code");
        PayrollEntry.SETRANGE("Employee No.", Employee."No.");
        PayrollEntry.SETRANGE("Payroll ID", Period);
        PayrollEntry.SETRANGE("ED Code", PayrollSetup."Overdrawn ED");
        PayrollEntry.DELETEALL(TRUE);

        PeriodsRec.RESET;
        PeriodsRec.SETCURRENTKEY("Start Date");
        PeriodsRec.ASCENDING(TRUE);
        PeriodsRec.SETRANGE(Status, PeriodsRec.Status::Posted);
        IF NOT PeriodsRec.FIND('+') THEN EXIT;

        PayrollHeaderRec.SETCURRENTKEY("Payroll ID", "Employee no.");
        PayrollHeaderRec.SETRANGE("Payroll ID", PeriodsRec."Period ID");
        PayrollHeaderRec.SETRANGE("Employee no.", Employee."No.");

        IF PayrollHeaderRec.FIND('-') THEN
            IF PayrollHeader.GET(Period, PayrollHeaderRec."Employee no.") THEN BEGIN

                PayrollHeaderRec.CALCFIELDS("Total Deduction (LCY)", "Total Payable (LCY)");
                NetAmount := PayrollHeaderRec."Total Payable (LCY)" - PayrollHeaderRec."Total Deduction (LCY)";

                IF NetAmount > 0 THEN BEGIN
                    IF PayrollSetup."Net Pay Rounding Precision" <> 0 THEN
                        RoundAmount := NetAmount MOD PayrollSetup."Net Pay Rounding Precision";

                    IF (RoundAmount <> 0) AND (RoundAmount >= PayrollSetup."Net Pay Rounding Mid Amount") THEN
                        RoundAmount := PayrollSetup."Net Pay Rounding Precision" - RoundAmount;

                    IF RoundAmount <> 0 THEN BEGIN
                        PayrollEntry.INIT;
                        EntryLineNo := EntryLineNo + 1;
                        PayrollEntry."Entry No." := EntryLineNo;

                        IF PayrollSetup."Net Pay Rounding Precision" <> 0 THEN
                            PayrollEntry."Payroll ID" := Period;
                        PayrollEntry."Employee No." := PayrollHeaderRec."Employee no.";

                        IF NetAmount MOD PayrollSetup."Net Pay Rounding Precision" >= PayrollSetup."Net Pay Rounding Mid Amount" THEN
                            PayrollEntry.VALIDATE("ED Code", PayrollSetup."Net Pay Rounding B/F (-Ve)")
                        ELSE
                            PayrollEntry.VALIDATE("ED Code", PayrollSetup."Net Pay Rounding B/F");

                        PayrollEntry.Date := gvPostingDate;
                        PayrollEntry.VALIDATE(Amount, RoundAmount);
                        PayrollEntry."Copy to next" := FALSE;
                        PayrollEntry."Reset Amount" := FALSE;
                        PayrollEntry.Editable := FALSE;
                        PayrollEntry."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                        PayrollEntry.INSERT;
                        COMMIT;
                    END;
                END ELSE
                    IF NetAmount < 0 THEN BEGIN
                        PayrollEntry.INIT;
                        EntryLineNo := EntryLineNo + 1;
                        PayrollEntry."Entry No." := EntryLineNo;
                        PayrollEntry."Payroll ID" := Period;
                        PayrollEntry."Employee No." := PayrollHeaderRec."Employee no.";
                        PayrollEntry.Date := gvPostingDate;
                        PayrollEntry.VALIDATE("ED Code", PayrollSetup."Overdrawn ED");
                        PayrollEntry.VALIDATE(Amount, ABS(NetAmount));
                        PayrollEntry."Copy to next" := FALSE;
                        PayrollEntry."Reset Amount" := FALSE;
                        PayrollEntry.Editable := FALSE;
                        PayrollEntry."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                        PayrollEntry.INSERT;
                        COMMIT;
                    END;
            END;
    end;

    procedure GetLumpSum(PayrollHdr: Record 51159)
    var
        lvPayrollSetup: Record 51165;
        lvPayrollEntry: Record 51161;
        lvLumpsumPayments: Record 51168;
        lvEntryNo: BigInteger;
        lvAssessmentYrsArray: array[20] of Integer;
        lvIndex: Integer;
        lvAssessmentYrsFound: Integer;
        lvEmployee: Record 5200;
        lvPayrollHdr: Record 51159;
        lvRevisedTotalTaxableIncome: Decimal;
        lvTaxOnRevisedIncome: Decimal;
        lvPayrollLines: Record 51160;
        lvLastPayrollLineEntryNo: BigInteger;
        lvEdDef: Record 51158;
    begin
        //skm200405 Compute Taxation on Lump Sum Payment
        lvLumpsumPayments.SETCURRENTKEY("Employee No", "Assessment Year", "ED Code");
        lvLumpsumPayments.SETRANGE("Employee No", PayrollHdr."Employee no.");
        IF NOT lvLumpsumPayments.FIND('-') THEN EXIT;

        lvPayrollSetup.GET(gvAllowedPayrolls."Payroll Code");

        //Clear payroll entry and line for lumpsum payment EDs
        lvPayrollEntry.SETCURRENTKEY("Employee No.", "Payroll ID", "ED Code");
        lvPayrollEntry.SETRANGE("Employee No.", PayrollHdr."Employee no.");
        lvPayrollEntry.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
        lvPayrollEntry.SETRANGE("ED Code", lvPayrollSetup."Tax on Lump Sum ED");
        lvPayrollEntry.DELETEALL(TRUE);

        lvPayrollLines.SETCURRENTKEY("Payroll ID", "Employee No.", "ED Code");
        lvPayrollLines.SETRANGE("Employee No.", PayrollHdr."Employee no.");
        lvPayrollLines.SETRANGE("Payroll ID", PayrollHdr."Payroll ID");
        lvPayrollLines.SETRANGE("ED Code", lvPayrollSetup."Tax on Lump Sum ED");
        lvPayrollLines.DELETEALL(TRUE);

        REPEAT
            lvLumpsumPayments.TESTFIELD("Employee No");
            lvLumpsumPayments.TESTFIELD("ED Code");
            lvLumpsumPayments.TESTFIELD("Amount (LCY)");
            lvLumpsumPayments.TESTFIELD("Assessment Year");
            lvLumpsumPayments.TESTFIELD("Annual Tax Table");

            lvPayrollEntry.SETRANGE("ED Code", lvLumpsumPayments."ED Code");
            lvPayrollEntry.DELETEALL(TRUE);

            lvPayrollLines.SETRANGE("ED Code", lvLumpsumPayments."ED Code");
            lvPayrollLines.DELETEALL(TRUE);
        UNTIL lvLumpsumPayments.NEXT = 0;
        //End Clear payroll entry for lumpsum payment EDs

        lvPayrollEntry.RESET;
        IF lvPayrollEntry.FIND('+') THEN lvEntryNo := lvPayrollEntry."Entry No.";

        //Retrieve assessment years and put them into a 20 dim array
        //max assessement years 20
        lvLumpsumPayments.FIND('-');
        lvIndex += 1;

        REPEAT
            IF lvIndex > 1 THEN BEGIN
                IF lvLumpsumPayments."Assessment Year" > lvAssessmentYrsArray[lvIndex - 1] THEN BEGIN
                    lvAssessmentYrsArray[lvIndex] := lvLumpsumPayments."Assessment Year";
                    lvIndex += 1;
                END
            END ELSE BEGIN
                lvAssessmentYrsArray[lvIndex] := lvLumpsumPayments."Assessment Year";
                lvIndex += 1;
            END
        UNTIL (lvLumpsumPayments.NEXT = 0) OR (lvIndex > 20);

        IF (lvIndex > 20) THEN BEGIN
            MESSAGE('More than 20 assessment years have been entered in Lump Sum Payments table. Only the oldest 20 have been assessed.');
            lvAssessmentYrsFound := 20;
        END ELSE
            lvAssessmentYrsFound := lvIndex - 1;
        //end Retrieve assessment years and put them into a 20 dim array

        //Compute tax on lump sum per year
        lvLumpsumPayments.RESET;
        lvLumpsumPayments.SETCURRENTKEY("Employee No", "Assessment Year", "ED Code");
        lvLumpsumPayments.SETRANGE("Employee No", PayrollHdr."Employee no.");

        lvPayrollHdr.SETCURRENTKEY("Employee no.", "Payroll Year");
        lvPayrollHdr.SETRANGE("Employee no.", PayrollHdr."Employee no.");

        lvPayrollLines.RESET;
        IF lvPayrollLines.FIND('+') THEN lvLastPayrollLineEntryNo := lvPayrollLines."Entry No.";
        lvEdDef.GET(lvPayrollSetup."Tax on Lump Sum ED");

        FOR lvIndex := 1 TO lvAssessmentYrsFound DO BEGIN
            //Calculate Total Payable for the year as per P9A (Column D)
            lvPayrollHdr.SETRANGE("Payroll Year", lvAssessmentYrsArray[lvIndex]);
            lvPayrollHdr.CALCSUMS("D (LCY)", "K (LCY)", "L (LCY)");

            //Calculate Lump Sum pay for the year
            lvLumpsumPayments.SETRANGE("Assessment Year", lvAssessmentYrsArray[lvIndex]);
            lvLumpsumPayments.CALCSUMS("Amount (LCY)");

            //Calculate revised taxable income
            lvRevisedTotalTaxableIncome := lvPayrollHdr."D (LCY)" + lvLumpsumPayments."Amount (LCY)";

            //Calculate tax on revised taxable income
            lvTaxOnRevisedIncome := ROUND(LookUp2(lvLumpsumPayments."Annual Tax Table", lvRevisedTotalTaxableIncome, PayrollHdr), 1, '>');

            //Deduct relief for the year
            lvTaxOnRevisedIncome -= lvPayrollHdr."K (LCY)";

            //Deduct PAYE already deducted and paid
            lvTaxOnRevisedIncome -= lvPayrollHdr."L (LCY)";

            //Insert Tax on Lump Sum Payroll Entry
            lvPayrollEntry.INIT;
            lvEntryNo += 1;
            lvPayrollEntry."Entry No." := lvEntryNo;
            lvPayrollEntry."Payroll ID" := PayrollHdr."Payroll ID";
            lvPayrollEntry."Employee No." := PayrollHdr."Employee no.";
            lvPayrollEntry.Date := gvPostingDate;
            lvPayrollEntry.VALIDATE("ED Code", lvPayrollSetup."Tax on Lump Sum ED");
            lvPayrollEntry.VALIDATE(Amount, lvTaxOnRevisedIncome);
            lvPayrollEntry."Copy to next" := FALSE;
            lvPayrollEntry."Reset Amount" := FALSE;
            lvPayrollEntry.Editable := FALSE;
            lvPayrollEntry."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            lvPayrollEntry.INSERT;
            //End Insert

            //Insert tax on lump sum into payroll lines
            lvLastPayrollLineEntryNo += 1;
            lvPayrollLines."Entry No." := lvLastPayrollLineEntryNo;
            lvPayrollLines."Payroll ID" := PayrollHdr."Payroll ID";
            lvPayrollLines."Employee No." := PayrollHdr."Employee no.";
            lvPayrollLines."Global Dimension 1 Code" := lvEmployee."Global Dimension 1 Code";
            lvPayrollLines."Global Dimension 2 Code" := lvEmployee."Global Dimension 2 Code";
            lvPayrollLines."Posting Group" := lvEmployee."Posting Group";
            lvPayrollLines."ED Code" := lvPayrollSetup."Tax on Lump Sum ED";
            lvPayrollLines.Text := STRSUBSTNO('%1 %2', lvEdDef."Payroll Text", lvAssessmentYrsArray[lvIndex]);
            lvPayrollLines.Amount := lvTaxOnRevisedIncome;
            lvPayrollLines."Amount (LCY)" := lvTaxOnRevisedIncome;
            lvPayrollLines."Calculation Group" := lvEdDef."Calculation Group";
            lvPayrollLines."GE PA Lump Sum" := lvPayrollHdr."D (LCY)";
            lvPayrollLines."PAYE Earlier Paid Lump Sum" := lvPayrollHdr."L (LCY)";
            lvPayrollLines."LumpSum Line" := TRUE;
            lvPayrollLines."Posting Date" := gvPostingDate;
            lvPayrollLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            lvPayrollLines.INSERT;
            gvPayrollUtilities.sGetDefaultEDDims2(lvPayrollLines);
            //end insert
        END;
        //End Compute tax on lump sum per year

        //Insert Lump Sum Payments into Payroll Entry and Payroll Lines tables
        lvLumpsumPayments.RESET;
        lvLumpsumPayments.SETCURRENTKEY("Employee No", "Assessment Year", "ED Code");
        lvLumpsumPayments.SETRANGE("Employee No", PayrollHdr."Employee no.");

        FOR lvIndex := 1 TO lvAssessmentYrsFound DO BEGIN
            lvLumpsumPayments.SETRANGE(lvLumpsumPayments."Assessment Year", lvAssessmentYrsArray[lvIndex]);
            lvLumpsumPayments.FIND('-');
            REPEAT
                //Insert Lump Sum Payments into payroll entry
                lvPayrollEntry.INIT;
                lvEntryNo += 1;
                lvPayrollEntry."Entry No." := lvEntryNo;
                lvPayrollEntry."Payroll ID" := PayrollHdr."Payroll ID";
                lvPayrollEntry."Employee No." := PayrollHdr."Employee no.";
                lvPayrollEntry.Date := gvPostingDate;
                lvPayrollEntry.VALIDATE("ED Code", lvLumpsumPayments."ED Code");
                lvPayrollEntry.VALIDATE(Amount, lvLumpsumPayments."Amount (LCY)");
                lvPayrollEntry."Copy to next" := FALSE;
                lvPayrollEntry."Reset Amount" := FALSE;
                lvPayrollEntry.Editable := FALSE;
                lvPayrollEntry."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                lvPayrollEntry.INSERT;

                //Insert Lump Sum Payments into payroll lines
                lvLastPayrollLineEntryNo += 1;
                lvPayrollLines."Entry No." := lvLastPayrollLineEntryNo;
                lvPayrollLines."Payroll ID" := PayrollHdr."Payroll ID";
                lvPayrollLines."Employee No." := PayrollHdr."Employee no.";
                lvPayrollLines."Global Dimension 1 Code" := lvEmployee."Global Dimension 1 Code";
                lvPayrollLines."Global Dimension 2 Code" := lvEmployee."Global Dimension 2 Code";
                lvPayrollLines."Posting Group" := lvEmployee."Posting Group";
                lvPayrollLines."ED Code" := lvLumpsumPayments."ED Code";
                lvEdDef.GET(lvLumpsumPayments."ED Code");
                lvPayrollLines.Text := STRSUBSTNO('%1 %2', lvEdDef."Payroll Text", lvLumpsumPayments."Assessment Year");
                lvPayrollLines.Amount := lvLumpsumPayments."Amount (LCY)";
                lvPayrollLines."Amount (LCY)" := lvLumpsumPayments."Amount (LCY)";
                lvPayrollLines."Calculation Group" := lvEdDef."Calculation Group";
                lvPayrollLines."LumpSum Line" := TRUE;
                lvPayrollLines."Posting Date" := gvPostingDate;
                lvPayrollLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                lvPayrollLines.INSERT;
                gvPayrollUtilities.sGetDefaultEDDims2(lvPayrollLines);

                //flag lump sum payment
                lvLumpsumPayments."Linked Payroll Entry No" := lvEntryNo;
                lvLumpsumPayments."Linked Payroll Line No" := lvLastPayrollLineEntryNo;
                lvLumpsumPayments.MODIFY
            UNTIL lvLumpsumPayments.NEXT = 0
        END;
        //Insert Lump Sum Payments into Payroll Entry and Payroll Lines tables
    end;

    procedure LookUp2(LookupTableID: Code[20]; LookupAmount: Decimal; PayrollHdr: Record 51159) Tax: Decimal
    var
        LookUpHeader: Record 51162;
        LookUpLine: Record 51163;
    begin
        //SKM 200405 This function looks up the tax or relief based on table ID and Amount

        LookUpHeader.GET(LookupTableID);
        LookUpLine.SETRANGE("Table ID", LookupTableID);
        Amount := LookupAmount;

        CASE LookUpHeader.Type OF
            LookUpHeader.Type::Percentage:
                BEGIN
                    LookUpLine.FIND('-');

                    WHILE Amount > LookUpLine."Upper Amount (LCY)" DO
                        LookUpLine.FIND('>');

                    Percent := LookUpLine.Percent;
                    IF LookUpLine.FIND('<') THEN BEGIN
                        Cum := LookUpLine."Cumulate (LCY)";
                        Amount1 := ((Amount - LookUpLine."Upper Amount (LCY)") * Percent / 100) + Cum;
                    END ELSE BEGIN
                        Amount1 := (Amount * Percent / 100);
                    END;

                END;
            LookUpHeader.Type::"Extract Amount":
                BEGIN
                    LookUpLine.FIND('-');
                    WHILE NOT (Amount <= LookUpLine."Upper Amount (LCY)") DO
                        LookUpLine.FIND('>');

                    Amount1 := LookUpLine."Extract Amount (LCY)";
                END;
            LookUpHeader.Type::Month:
                BEGIN
                    LookUpLine.FIND('-');
                    WHILE PayrollHdr."Payroll Month" <> LookUpLine.Month DO
                        LookUpLine.FIND('>');
                    Amount1 := LookUpLine."Extract Amount (LCY)";
                END;
            LookUpHeader.Type::"Max Min":
                BEGIN
                    IF LookUpHeader."Min Extract Amount (LCY)" <> 0 THEN
                        IF Amount < LookUpHeader."Min Extract Amount (LCY)" THEN
                            Amount1 := LookUpHeader."Min Extract Amount (LCY)";
                    IF LookUpHeader."Max Extract Amount (LCY)" <> 0 THEN
                        IF Amount > LookUpHeader."Max Extract Amount (LCY)" THEN
                            Amount1 := LookUpHeader."Max Extract Amount (LCY)";
                END;
        END;
        EXIT(Amount1);
    end;

    procedure GetSpecialAllowance(var pPayrollHdr: Record 51159)
    var
        lvPayrollEntry: Record 51161;
        lvSpecialAllowances: Record 51167;
        lvTotalSpecAllowances: Decimal;
        lvTEB4SAPP: Decimal;
        lvTEB4SAPPLineNo: BigInteger;
        lvChargeablePayB4SAP: Decimal;
        lvChargeablePayB4SAPLineNo: BigInteger;
        lvTotalPayAfterTaxB4SAP: Decimal;
        lvTEWithSAPP: Decimal;
        lvTotalPayAfterTaxWithSAP: Decimal;
        lvPAYETableID: Code[20];
        lvPayeLookUpLineNo: BigInteger;
        lvEmployee: Record 5200;
        lvCurrentControlLineNo: BigInteger;
    begin
        //SKM 250405 this subroutine retrieves the Special Allowance value (net of tax) from Specail Allowances setup table and
        //computes its gross equivalent, it then inserts a recovery deduction for the allowance into employee's payroll
        //
        //A Special Allowance is a payment to an employee where the company pays for a certain expense on behalf of the
        //employee and also bears the tax burden on the allowance on behalf of the employee.

        PeriodRec.GET(pPayrollHdr."Payroll ID", pPayrollHdr."Payroll Month", pPayrollHdr."Payroll Year",
          pPayrollHdr."Payroll Code");
        gvLineNo2 := SchemeControlTmp."Line No."; //Note current control line pointer

        //Check if employee entitled to any special allowances compute total entitlement
        lvSpecialAllowances.SETRANGE("Employee No", pPayrollHdr."Employee no.");
        IF lvSpecialAllowances.FIND('-') THEN BEGIN
            lvSpecialAllowances.CALCSUMS("Amount (LCY)");
            lvTotalSpecAllowances := lvSpecialAllowances."Amount (LCY)"
        END ELSE BEGIN
            SchemeControlTmp.SETRANGE("Special Allowance", TRUE);
            SchemeControlTmp.MODIFYALL("Special Allowance Calculated", TRUE);
            SchemeControlTmp.SETFILTER("Special Allowance", '');
            EXIT
        END;
        //End Check if employee entitled to any special allowances compute total entitlement

        //Reset Payroll Entry: Delete any Special Allowances earlier computed
        lvPayrollEntry.SETRANGE("Payroll ID", pPayrollHdr."Payroll ID");
        lvPayrollEntry.SETRANGE("Employee No.", pPayrollHdr."Employee no.");

        REPEAT
            lvPayrollEntry.SETFILTER("ED Code", '%1|%2', lvSpecialAllowances."Allowance ED Code",
              lvSpecialAllowances."Deduction ED Code");
            lvPayrollEntry.DELETEALL(TRUE);
        UNTIL lvSpecialAllowances.NEXT = 0;
        //End Reset

        //Get Total Payments before pension, Special Allowances and special payments (TEB4SAPP)
        SchemeValueTmp.RESET;
        SchemeValueTmp.SETRANGE(SchemeValueTmp."Scheme ID", Scheme);
        SchemeValueTmp.SETRANGE("Total Earnings (B4 SAPP)", TRUE);

        IF NOT SchemeValueTmp.FIND('-') THEN
            ERROR('Calculation Line for Total Earnings (B4 SAPP) not identified in scheme %1.', Scheme);

        IF SchemeValueTmp."Amount (LCY)" = 0 THEN
            ERROR('Scheme %1 Calculation Line %2 Total Earnings (B4 SAPP) should be known before a Special Allowance ' +
                  'line can be processed.', Scheme, SchemeValueTmp."Line No.");

        IF SchemeValueTmp.COUNT > 1 THEN
            ERROR('Scheme %1: Multiple lines marked as Total Earnings (B4 SAPP)', Scheme);

        lvTEB4SAPP := SchemeValueTmp."Amount (LCY)";
        lvTEB4SAPPLineNo := SchemeValueTmp."Line No.";
        //End Get Total Payments before Special Allowances (TEB4SAPP)

        //Get Total Payments after pension without special allowances
        SchemeValueTmp.RESET;
        SchemeValueTmp.SETRANGE(SchemeValueTmp."Scheme ID", Scheme);
        SchemeValueTmp.SETRANGE("Chargeable Pay (B4 SAP)", TRUE);

        IF NOT SchemeValueTmp.FIND('-') THEN
            ERROR('Calculation Line for Chargeable Pay (B4 SAP) not identified in scheme %1.', Scheme);

        IF SchemeValueTmp."Amount (LCY)" = 0 THEN
            ERROR('Scheme %1 Calculation Line %2 Chargeable Pay (B4 SAP) should be known before a Special Allowance ' +
                  'line can be processed.', Scheme, SchemeControlTmp."Line No.");

        IF SchemeValueTmp.COUNT > 1 THEN
            ERROR('Scheme %1: Multiple lines marked as Chargeable Pay (B4 SAP)', Scheme);

        lvChargeablePayB4SAP := SchemeValueTmp."Amount (LCY)";
        lvChargeablePayB4SAPLineNo := SchemeValueTmp."Line No.";
        //End Get Total Payments after pension without special allowances

        //Compute Payments Total after Tax without Special Allowances
        SchemeValueTmp.RESET;
        SchemeValueTmp.SETRANGE(SchemeValueTmp."Scheme ID", Scheme);
        SchemeValueTmp.SETRANGE("PAYE Lookup Line", TRUE);

        IF NOT SchemeValueTmp.FIND('-') THEN
            ERROR('Calculation Line for PAYE Lookup Line is not identified in scheme %1.', Scheme);

        IF SchemeValueTmp.COUNT > 1 THEN
            ERROR('Scheme %1: Multiple lines are marked as PAYE Lookup Lines.', Scheme);

        lvPAYETableID := SchemeValueTmp.LookUp;
        lvTotalPayAfterTaxB4SAP := lvChargeablePayB4SAP - LookUp2(lvPAYETableID, lvChargeablePayB4SAP, pPayrollHdr);
        lvPayeLookUpLineNo := SchemeValueTmp."Line No.";
        //End Compute Payments Total after Tax without Special Allowances

        //Determine the Gross Value of Special Allowance, add it to the initial total payments and recalculate Pension and PAYE
        lvTEWithSAPP := lvTEB4SAPP + lvTotalSpecAllowances;
        SchemeControlTmp.SETRANGE("Line No.", lvTEB4SAPPLineNo, lvChargeablePayB4SAPLineNo);

        REPEAT
            lvTEWithSAPP += 5; //Determine new Gross Value Inclusive of Special Allowances in increments of 5

            SchemeValueTmp.RESET;
            SchemeValueTmp.SETRANGE("Line No.", lvTEB4SAPPLineNo, lvPayeLookUpLineNo);
            SchemeValueTmp.MODIFYALL(Amount, 0);
            SchemeValueTmp.RESET;

            SchemeControlTmp.FIND('-');
            SchemeValueTmp.GET(SchemeControlTmp."Line No.", SchemeControlTmp."Scheme ID");
            SchemeValueTmp.Amount := lvTEWithSAPP;
            SchemeValueTmp."Amount (LCY)" := lvTEWithSAPP;
            SchemeValueTmp.MODIFY;
            REPEAT
                LineNo := SchemeControlTmp."Line No.";
                IF SchemeControlTmp."Line No." > lvTEB4SAPPLineNo THEN GetInput(pPayrollHdr);
                RoundAmount;
                Calculate(pPayrollHdr);

                //Clear Previous payroll lines (gueses)
                IF SchemeControlTmp."Payroll Lines" <> '' THEN BEGIN
                    PayrollLinesTmp.SETRANGE("Payroll ID", pPayrollHdr."Payroll ID");
                    PayrollLinesTmp.SETRANGE("Employee No.", pPayrollHdr."Employee no.");
                    PayrollLinesTmp.SETRANGE("ED Code", SchemeControlTmp."Payroll Lines");
                    PayrollLinesTmp.DELETEALL(TRUE);
                    PayrollLinesTmp.RESET
                END;
                //End Clear Previous payroll lines (gueses)

                Output(pPayrollHdr);
            UNTIL SchemeControlTmp.NEXT = 0;

            SchemeValueTmp.GET(LineNo, SchemeControlTmp."Scheme ID");
            lvTotalPayAfterTaxWithSAP := SchemeValueTmp."Amount (LCY)" - LookUp2(lvPAYETableID, SchemeValueTmp."Amount (LCY)", pPayrollHdr
        );
        UNTIL lvTotalPayAfterTaxWithSAP >= (lvTotalPayAfterTaxB4SAP + lvTotalSpecAllowances);
        //End Determine the Gross Value of Special Allowance, add it to the initial total payments and recalculate Pension and PAYE

        lvSpecialAllowances.FIND('-');
        lvEmployee.GET(pPayrollHdr."Employee no.");
        REPEAT
            //Insert Gross Value of Special Allowance ED Line into Payroll Entry & Payroll Lines
            IF lvPayrollEntry.FIND('+') THEN
                lvPayrollEntry."Entry No." += 1
            ELSE
                lvPayrollEntry."Entry No." := 1;
            EDDefinitionTmp.GET(lvSpecialAllowances."Allowance ED Code");
            lvPayrollEntry."Entry No." := PayrollLinesTmpLineNo;
            lvPayrollEntry.Date := PeriodRec."Posting Date";
            lvPayrollEntry."Payroll ID" := Period;
            lvPayrollEntry."Employee No." := pPayrollHdr."Employee no.";
            lvPayrollEntry.VALIDATE("ED Code", lvSpecialAllowances."Allowance ED Code");
            lvPayrollEntry.Text := EDDefinitionTmp."Payroll Text";
            //Apportion the gross value of total allowances to individual Special Allowance EDs
            lvPayrollEntry.VALIDATE(Amount,
              ROUND(lvSpecialAllowances."Amount (LCY)" * (lvTEWithSAPP - lvTEB4SAPP) / lvTotalSpecAllowances, 1));
            lvPayrollEntry."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            lvPayrollEntry.INSERT;

            PayrollLinesTmpLineNo := PayrollLinesTmpLineNo + 1;
            PayrollLinesTmp.INIT;
            PayrollLinesTmp."Entry No." := PayrollLinesTmpLineNo;
            PayrollLinesTmp."Payroll ID" := Period;
            PayrollLinesTmp."Employee No." := pPayrollHdr."Employee no.";
            PayrollLinesTmp."Global Dimension 1 Code" := lvEmployee."Global Dimension 1 Code";
            PayrollLinesTmp."Global Dimension 2 Code" := lvEmployee."Global Dimension 2 Code";
            PayrollLinesTmp."Posting Group" := lvEmployee."Posting Group";
            PayrollLinesTmp."ED Code" := lvSpecialAllowances."Allowance ED Code";
            PayrollLinesTmp.Text := EDDefinitionTmp."Payroll Text";
            PayrollLinesTmp.Amount := ROUND(lvSpecialAllowances."Amount (LCY)" * (lvTEWithSAPP - lvTEB4SAPP) / lvTotalSpecAllowances, 1);
            PayrollLinesTmp."Amount (LCY)" :=
              ROUND(lvSpecialAllowances."Amount (LCY)" * (lvTEWithSAPP - lvTEB4SAPP) / lvTotalSpecAllowances, 1);
            PayrollLinesTmp."Calculation Group" := EDDefinitionTmp."Calculation Group";
            PayrollLinesTmp."Posting Date" := gvPostingDate;
            PayrollLinesTmp."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            PayrollLinesTmp.INSERT;
            gvPayrollUtilities.sGetDefaultEDDims2(PayrollLinesTmp);
            //End. Insert Gross Value of Special Allowance ED Line into Payroll Entry & Payroll Lines

            //Insert Special Allowance Recovery ED Line into Payroll Entry & Payroll Lines
            IF lvPayrollEntry.FIND('+') THEN
                lvPayrollEntry."Entry No." += 1
            ELSE
                lvPayrollEntry."Entry No." := 1;
            EDDefinitionTmp.GET(lvSpecialAllowances."Deduction ED Code");
            lvPayrollEntry."Payroll ID" := Period;
            lvPayrollEntry.Date := PeriodRec."Posting Date";
            lvPayrollEntry."Employee No." := pPayrollHdr."Employee no.";
            lvPayrollEntry.VALIDATE("ED Code", lvSpecialAllowances."Deduction ED Code");
            lvPayrollEntry.Text := EDDefinitionTmp."Payroll Text";
            lvPayrollEntry.VALIDATE(Amount, lvSpecialAllowances."Amount (LCY)");
            lvPayrollEntry."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            lvPayrollEntry.INSERT;

            PayrollLinesTmpLineNo := PayrollLinesTmpLineNo + 1;
            PayrollLinesTmp.INIT;
            PayrollLinesTmp."Entry No." := PayrollLinesTmpLineNo;
            PayrollLinesTmp."Payroll ID" := Period;
            PayrollLinesTmp."Employee No." := pPayrollHdr."Employee no.";
            PayrollLinesTmp."Global Dimension 1 Code" := lvEmployee."Global Dimension 1 Code";
            PayrollLinesTmp."Global Dimension 2 Code" := lvEmployee."Global Dimension 2 Code";
            PayrollLinesTmp."Posting Group" := lvEmployee."Posting Group";
            PayrollLinesTmp."ED Code" := lvSpecialAllowances."Deduction ED Code";
            PayrollLinesTmp.Text := EDDefinitionTmp."Payroll Text";
            PayrollLinesTmp.Amount := lvSpecialAllowances."Amount (LCY)";
            PayrollLinesTmp."Amount (LCY)" := lvSpecialAllowances."Amount (LCY)";
            PayrollLinesTmp."Calculation Group" := EDDefinitionTmp."Calculation Group";
            PayrollLinesTmp."Posting Date" := gvPostingDate;
            PayrollLinesTmp."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            PayrollLinesTmp.INSERT;
            gvPayrollUtilities.sGetDefaultEDDims2(PayrollLinesTmp);
        //Insert Special Allowance Recovery ED Line into Payroll Entry & Payroll Lines
        UNTIL lvSpecialAllowances.NEXT = 0;

        //Skip subsequent special allowance calculation lines since ALL already calculated
        SchemeControlTmp.RESET;
        SchemeControlTmp.SETRANGE("Scheme ID", Scheme);
        SchemeControlTmp.SETRANGE("Special Allowance", TRUE);
        SchemeControlTmp.MODIFYALL("Special Allowance Calculated", TRUE);
        //End Skip subsequent special allowance calculation lines since ALL already calculated

        //Restore Control Record Pointer
        SchemeControlTmp.RESET;
        SchemeControlTmp.SETRANGE("Scheme ID", Scheme);
        LineNo := gvLineNo2;
        SchemeControlTmp.GET(LineNo, Scheme);
        //End Restore Control Record Pointer
    end;

    procedure GetSpecialPayments(var pPayrollHdr: Record 51159)
    var
        lvPayrollEntry: Record 51161;
        lvSpecialPayments: Record 51166;
        lvTEB4SPP: Decimal;
        lvTEB4SPPLineNo: BigInteger;
        lvChargeablePayB4SP: Decimal;
        lvChargeablePayB4SPLineNo: BigInteger;
        lvTotalPayAfterTaxB4SP: Decimal;
        lvTEWithSPP: Decimal;
        lvTotalPayAfterTaxWithSP: Decimal;
        lvPAYETableID: Code[20];
        lvPayeLookUpLineNo: BigInteger;
        lvEmployee: Record 5200;
        lvCurrentControlLineNo: BigInteger;
        lvPayrollSetup: Record 51165;
        lvSpecialPaymentED: Record 51158;
        lvBasicSalary: Decimal;
        lvSalaryScaleStep: Record 51170;
        lvTotalNetSpecialPaymentsLCY: Decimal;
        lvCurrencyFactor: Decimal;
        lvCurrExchRate: Record 330;
        lvIndividualSpecialPaymentLCY: Decimal;
    begin
        //SKM 130505 this subroutine computes the Special Payment value (net of tax) based on the entitlement in the special payments
        //setup table
        //
        //A Special Payment is a payment computed as a percentage of Basic Salary and the company bears the tax burden.

        lvPayrollSetup.GET(pPayrollHdr."Payroll Code");
        lvSpecialPaymentED.SETRANGE("Special Payment", TRUE);
        IF lvSpecialPaymentED.FIND('-') THEN BEGIN
            //Get basic pay
            lvEmployee.GET(pPayrollHdr."Employee no.");
            IF lvEmployee."Basic Pay Currency" <> '' THEN
                lvCurrencyFactor := lvCurrExchRate.ExchangeRate(gvPostingDate, lvEmployee."Basic Pay Currency")
            ELSE
                lvCurrencyFactor := 0;

            IF lvEmployee."Basic Pay" = lvEmployee."Basic Pay"::Fixed THEN BEGIN
                lvEmployee.TESTFIELD("Fixed Pay");
                lvBasicSalary := lvEmployee."Fixed Pay";
            END ELSE
                IF lvEmployee."Basic Pay" = lvEmployee."Basic Pay"::Scale THEN BEGIN
                    lvSalaryScaleStep.SETRANGE(Scale, lvEmployee."Salary Scale");
                    lvSalaryScaleStep.SETRANGE(Code, lvEmployee."Scale Step");
                    lvSalaryScaleStep.SETRANGE("Currency Code", lvEmployee."Basic Pay Currency");
                    IF NOT lvSalaryScaleStep.FIND('-') THEN
                        ERROR('Employee %1, Salary Scale Step in Employee''s Basic Pay Currency not found.', lvEmployee."No.");
                    lvSalaryScaleStep.TESTFIELD(Amount);
                    lvBasicSalary := lvSalaryScaleStep.Amount
                END ELSE BEGIN
                    MESSAGE('Employee %1: Special Payment not inserted. Basic Salary not defined.', lvEmployee."No.");
                    EXIT
                END;
            //End Get basic pay

            //Reset Payroll Entry: Delete any Special Payments earlier computed and compute Net Total of Special Payments entitled
            lvSpecialPayments.SETCURRENTKEY("Payment ED Code", "Min Basic Salary");
            lvPayrollEntry.SETRANGE("Payroll ID", pPayrollHdr."Payroll ID");
            lvPayrollEntry.SETRANGE("Employee No.", pPayrollHdr."Employee no.");

            REPEAT
                lvPayrollEntry.SETRANGE("ED Code", lvSpecialPaymentED."ED Code");
                lvPayrollEntry.DELETEALL(TRUE);

                lvSpecialPayments.SETRANGE("Payment ED Code", lvSpecialPaymentED."ED Code");
                lvSpecialPayments.SETRANGE("Min Basic Salary", 0, lvBasicSalary);
                lvSpecialPayments.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
                lvSpecialPayments.SETRANGE("Currency Code", lvEmployee."Basic Pay Currency");
                IF NOT lvSpecialPayments.FIND('+') THEN
                    ERROR('ED %1, Basic Pay %1, Currency Code %3, no Special Payment entitlement entry found.',
                      lvSpecialPaymentED."ED Code", lvBasicSalary, lvEmployee."Basic Pay Currency");
                lvTotalNetSpecialPaymentsLCY += ROUND(lvSpecialPayments."Granted Rate (%)" * lvBasicSalary / 100, 0.01)

             UNTIL lvSpecialPaymentED.NEXT = 0;

            lvTotalNetSpecialPaymentsLCY :=
               ROUND(lvCurrExchRate.ExchangeAmtFCYToLCY(gvPostingDate, lvEmployee."Basic Pay Currency",
               lvTotalNetSpecialPaymentsLCY, lvCurrencyFactor));
            //End Reset
        END ELSE
            ERROR('Please mark Special Payment EDs or deactivate their insertion on Payroll Setup.');

        IF NOT lvPayrollSetup."Insert Special Payments" THEN EXIT;

        PeriodRec.GET(pPayrollHdr."Payroll ID", pPayrollHdr."Payroll Month", pPayrollHdr."Payroll Year",
          pPayrollHdr."Payroll Code");
        gvLineNo2 := SchemeControlTmp."Line No."; //Note current control line pointer

        //Get Total Payments before pension and special payments (lvTEB4SPP)
        SchemeValueTmp.RESET;
        SchemeValueTmp.SETRANGE(SchemeValueTmp."Scheme ID", Scheme);
        SchemeValueTmp.SETRANGE("Total Earnings (B4 SAPP)", TRUE);

        IF NOT SchemeValueTmp.FIND('-') THEN
            ERROR('Calculation Line for Total Earnings (B4 SAPP) not identified in scheme %1.', Scheme);

        IF SchemeValueTmp."Amount (LCY)" = 0 THEN
            ERROR('Scheme %1 Calculation Line %2 Total Earnings (B4 SAPP) should be known before a Special Allowance ' +
                  'line can be processed.', Scheme, SchemeValueTmp."Line No.");

        IF SchemeValueTmp.COUNT > 1 THEN
            ERROR('Scheme %1: Multiple lines marked as Total Earnings (B4 SAPP)', Scheme);

        lvTEB4SPP := SchemeValueTmp."Amount (LCY)";
        lvTEB4SPPLineNo := SchemeValueTmp."Line No.";
        //End Get Total Payments before pension and special payments (lvTEB4SPP)

        //Get Total Payments after pension without special payments
        SchemeValueTmp.RESET;
        SchemeValueTmp.SETRANGE(SchemeValueTmp."Scheme ID", Scheme);
        SchemeValueTmp.SETRANGE("Chargeable Pay (B4 SAP)", TRUE);

        IF NOT SchemeValueTmp.FIND('-') THEN
            ERROR('Calculation Line for Chargeable Pay (B4 SAP) not identified in scheme %1.', Scheme);

        IF SchemeValueTmp."Amount (LCY)" = 0 THEN
            ERROR('Scheme %1 Calculation Line %2 Chargeable Pay (B4 SAP) should be known before a Special Payment ' +
                  'line can be processed.', Scheme, SchemeControlTmp."Line No.");

        IF SchemeValueTmp.COUNT > 1 THEN
            ERROR('Scheme %1: Multiple lines marked as Chargeable Pay (B4 SAP)', Scheme);

        lvChargeablePayB4SP := SchemeValueTmp."Amount (LCY)";
        lvChargeablePayB4SPLineNo := SchemeValueTmp."Line No.";
        //Get Total Payments after pension without special payments

        //Compute Payments Total after Tax without Special Payments
        SchemeValueTmp.RESET;
        SchemeValueTmp.SETRANGE(SchemeValueTmp."Scheme ID", Scheme);
        SchemeValueTmp.SETRANGE("PAYE Lookup Line", TRUE);

        IF NOT SchemeValueTmp.FIND('-') THEN
            ERROR('Calculation Line for PAYE Lookup Line is not identified in scheme %1.', Scheme);

        IF SchemeValueTmp.COUNT > 1 THEN
            ERROR('Scheme %1: Multiple lines are marked as PAYE Lookup Lines.', Scheme);

        lvPAYETableID := SchemeValueTmp.LookUp;
        lvTotalPayAfterTaxB4SP := lvChargeablePayB4SP - LookUp2(lvPAYETableID, lvChargeablePayB4SP, pPayrollHdr);
        lvPayeLookUpLineNo := SchemeValueTmp."Line No.";
        //End Compute Payments Total after Tax without Special Payments

        //Determine the Gross Value of Special Payment, add it to the initial total payments and recalculate Pension and PAYE
        lvTEWithSPP := lvTEB4SPP + lvTotalNetSpecialPaymentsLCY;
        SchemeControlTmp.SETRANGE("Line No.", lvTEB4SPPLineNo, lvChargeablePayB4SPLineNo);

        REPEAT
            lvTEWithSPP += 5; //Determine new Gross Value Inclusive of Special Payments in increments of 5

            SchemeValueTmp.RESET;
            SchemeValueTmp.SETRANGE("Line No.", lvTEB4SPPLineNo, lvPayeLookUpLineNo);
            SchemeValueTmp.MODIFYALL(Amount, 0);
            SchemeValueTmp.MODIFYALL("Amount (LCY)", 0);
            SchemeValueTmp.RESET;

            SchemeControlTmp.FIND('-');
            SchemeValueTmp.GET(SchemeControlTmp."Line No.", SchemeControlTmp."Scheme ID");
            SchemeValueTmp.Amount := lvTEWithSPP;
            SchemeValueTmp."Amount (LCY)" := lvTEWithSPP;
            SchemeValueTmp.MODIFY;
            REPEAT
                LineNo := SchemeControlTmp."Line No.";
                IF SchemeControlTmp."Line No." > lvTEB4SPPLineNo THEN GetInput(pPayrollHdr);
                RoundAmount;
                Calculate(pPayrollHdr);

                //Clear Previous payroll lines (gueses)
                IF SchemeControlTmp."Payroll Lines" <> '' THEN BEGIN
                    PayrollLinesTmp.SETRANGE("Payroll ID", pPayrollHdr."Payroll ID");
                    PayrollLinesTmp.SETRANGE("Employee No.", pPayrollHdr."Employee no.");
                    PayrollLinesTmp.SETRANGE("ED Code", SchemeControlTmp."Payroll Lines");
                    PayrollLinesTmp.DELETEALL(TRUE);
                    PayrollLinesTmp.RESET
                END;
                //End Clear Previous payroll lines (gueses)

                Output(pPayrollHdr);
            UNTIL SchemeControlTmp.NEXT = 0;

            SchemeValueTmp.GET(LineNo, SchemeControlTmp."Scheme ID");
            lvTotalPayAfterTaxWithSP := SchemeValueTmp.Amount - LookUp2(lvPAYETableID, SchemeValueTmp.Amount, pPayrollHdr);
        UNTIL lvTotalPayAfterTaxWithSP >= (lvTotalPayAfterTaxB4SP + lvTotalNetSpecialPaymentsLCY);
        //End Determine the Gross Value of Special Payment, add it to the initial total payments and recalculate Pension and PAYE

        //Insert Gross Value of Special Payment ED Line into Payroll Entry & Payroll Lines
        lvSpecialPaymentED.FIND('-');
        REPEAT
            lvSpecialPayments.RESET;
            lvSpecialPayments.SETCURRENTKEY("Payment ED Code", "Min Basic Salary");
            lvSpecialPayments.SETRANGE("Payment ED Code", lvSpecialPaymentED."ED Code");
            lvSpecialPayments.SETRANGE("Min Basic Salary", 0, lvBasicSalary);
            lvSpecialPayments.SETRANGE("Payroll Code", gvAllowedPayrolls."Payroll Code");
            lvSpecialPayments.FIND('+');

            IF lvPayrollEntry.FIND('+') THEN
                lvPayrollEntry."Entry No." += 1
            ELSE
                lvPayrollEntry."Entry No." := 1;

            EDDefinitionTmp.GET(lvSpecialPayments."Payment ED Code");
            lvPayrollEntry."Entry No." := PayrollLinesTmpLineNo;
            lvPayrollEntry.Date := PeriodRec."Posting Date";
            lvPayrollEntry."Payroll ID" := Period;
            lvPayrollEntry."Employee No." := pPayrollHdr."Employee no.";
            lvPayrollEntry.VALIDATE("ED Code", lvSpecialPayments."Payment ED Code");
            lvPayrollEntry.Text := EDDefinitionTmp."Payroll Text";

            //Apportion the gross value of total payment to individual Special Payment EDs
            lvIndividualSpecialPaymentLCY := ROUND(
              ROUND(lvSpecialPayments."Granted Rate (%)" * lvBasicSalary / 100, 0.01) *
                   (lvTEWithSPP - lvTEB4SPP) / lvTotalNetSpecialPaymentsLCY, 1);
            IF lvSpecialPayments."Currency Code" = '' THEN
                lvPayrollEntry.VALIDATE(Amount, lvIndividualSpecialPaymentLCY)
            ELSE BEGIN
                lvPayrollEntry."Currency Code" := lvSpecialPayments."Currency Code";
                lvPayrollEntry."Currency Factor" := lvCurrExchRate.ExchangeRate(gvPostingDate, lvSpecialPayments."Currency Code");
                lvPayrollEntry.VALIDATE(Amount,
                  lvCurrExchRate.ExchangeAmtLCYToFCY(gvPostingDate, lvSpecialPayments."Currency Code",
                    lvIndividualSpecialPaymentLCY, lvPayrollEntry."Currency Factor"))
            END;
            lvPayrollEntry."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            lvPayrollEntry.INSERT;

            PayrollLinesTmpLineNo := PayrollLinesTmpLineNo + 1;
            PayrollLinesTmp.INIT;
            PayrollLinesTmp."Entry No." := PayrollLinesTmpLineNo;
            PayrollLinesTmp."Payroll ID" := Period;
            PayrollLinesTmp."Employee No." := pPayrollHdr."Employee no.";
            PayrollLinesTmp."Global Dimension 1 Code" := lvEmployee."Global Dimension 1 Code";
            PayrollLinesTmp."Global Dimension 2 Code" := lvEmployee."Global Dimension 2 Code";
            PayrollLinesTmp."Posting Group" := lvEmployee."Posting Group";
            PayrollLinesTmp."ED Code" := lvSpecialPayments."Payment ED Code";
            PayrollLinesTmp.Text := EDDefinitionTmp."Payroll Text";
            PayrollLinesTmp."Calculation Group" := EDDefinitionTmp."Calculation Group";
            IF lvSpecialPayments."Currency Code" = '' THEN
                PayrollLinesTmp.Amount := lvIndividualSpecialPaymentLCY
            ELSE BEGIN
                PayrollLinesTmp."Currency Code" := lvSpecialPayments."Currency Code";
                PayrollLinesTmp."Currency Factor" := lvCurrExchRate.ExchangeRate(gvPostingDate, lvSpecialPayments."Currency Code");
                PayrollLinesTmp.Amount :=
                  lvCurrExchRate.ExchangeAmtLCYToFCY(gvPostingDate, lvSpecialPayments."Currency Code",
                    lvIndividualSpecialPaymentLCY, PayrollLinesTmp."Currency Factor")
            END;
            PayrollLinesTmp."Amount (LCY)" := lvIndividualSpecialPaymentLCY;
            PayrollLinesTmp."Posting Date" := gvPostingDate;
            PayrollLinesTmp."Payroll Code" := gvAllowedPayrolls."Payroll Code";
            PayrollLinesTmp.INSERT;
            gvPayrollUtilities.sGetDefaultEDDims2(PayrollLinesTmp);
        UNTIL lvSpecialPaymentED.NEXT = 0;
        //End. Insert Gross Value of Special Allowance ED Line into Payroll Entry & Payroll Lines

        //Skip subsequent special payment calculation lines since ALL already calculated
        SchemeControlTmp.RESET;
        SchemeControlTmp.SETRANGE("Scheme ID", Scheme);
        SchemeControlTmp.SETRANGE("Special Payment", TRUE);
        SchemeControlTmp.MODIFYALL("Special Payment Calculated", TRUE);
        //End Skip subsequent special payment calculation lines since ALL already calculated

        //Restore Control Record Pointer
        SchemeControlTmp.RESET;
        SchemeControlTmp.SETRANGE("Scheme ID", Scheme);
        LineNo := gvLineNo2;
        SchemeControlTmp.GET(LineNo, Scheme);
        //End Restore Control Record Pointer
    end;

    procedure GetCommission(pPayrollHdr: Record 51159)
    var
        lvCommissionRate: Record 51186;
        lvPayrollPeriod: Record 51151;
        lvPayrollEntry: Record 51161;
        lvNextPayrollEntryNo: Integer;
        lvSalesInvoiceHeader: Record 112;
        lvEmployee: Record 5200;
        lvCommissionAmountLCY: Decimal;
        lvCommissionBaseAmntLCY: Decimal;
        lvCustLedger: Record 21;
    begin
        //SKM 130505 this subroutine computes the commissionamount based on the entitlements in the
        //Commission Rates table.

        //Get payroll period whose payroll is being processed
        lvPayrollPeriod.SETRANGE("Period ID", pPayrollHdr."Payroll ID");
        lvPayrollPeriod.SETRANGE("Payroll Code", pPayrollHdr."Payroll Code");
        lvPayrollPeriod.FINDFIRST;

        //Check for qualifying commission rates
        lvCommissionRate.SETCURRENTKEY("Employee No", "Valid To Date", Base);
        lvCommissionRate.SETRANGE("Employee No", pPayrollHdr."Employee no.");
        lvCommissionRate.SETFILTER("Valid To Date", '>=%1', lvPayrollPeriod."Start Date");
        IF lvCommissionRate.FINDFIRST THEN
            REPEAT
                lvPayrollEntry.SETRANGE("ED Code", lvCommissionRate."ED Code");
                lvPayrollEntry.SETRANGE("Payroll ID", pPayrollHdr."Payroll ID");
                lvPayrollEntry.SETRANGE("Employee No.", pPayrollHdr."Employee no.");
                lvPayrollEntry.SETRANGE("Payroll Code", pPayrollHdr."Payroll Code");
                IF lvPayrollEntry.FINDFIRST THEN lvPayrollEntry.DELETEALL(TRUE);

                lvPayrollEntry.RESET;
                lvPayrollEntry.SETRANGE("ED Code", lvCommissionRate."ED Code");
                IF lvPayrollEntry.FINDLAST THEN lvNextPayrollEntryNo := lvPayrollEntry."Entry No." + 1;

                //Calc Commission Base Amount
                lvCommissionBaseAmntLCY := 0;
                lvCommissionAmountLCY := 0;
                lvEmployee.GET(pPayrollHdr."Employee no.");

                CASE lvCommissionRate.Base OF
                    lvCommissionRate.Base::"Basic Salary":
                        BEGIN
                            IF pPayrollHdr."Basic Pay" = 0 THEN
                                ERROR('Employee %1, commission base of Basic Salary is invalid when Basic Pay is zero.', pPayrollHdr."Employee no.");
                            lvCommissionBaseAmntLCY := pPayrollHdr."Basic Pay (LCY)";
                        END;

                    lvCommissionRate.Base::"Sales Turnover":
                        BEGIN
                            lvEmployee.TESTFIELD(lvEmployee."Salespers./Purch. Code");

                            lvSalesInvoiceHeader.SETCURRENTKEY("Salesperson Code", "Posting Date");
                            lvSalesInvoiceHeader.SETRANGE("Salesperson Code", lvEmployee."Salespers./Purch. Code");
                            lvSalesInvoiceHeader.SETRANGE("Posting Date", lvPayrollPeriod."Start Date", lvPayrollPeriod."End Date");

                            IF lvSalesInvoiceHeader.FINDFIRST THEN
                                REPEAT
                                    lvSalesInvoiceHeader.CALCFIELDS(Amount);
                                    IF lvSalesInvoiceHeader."Currency Code" = '' THEN
                                        lvCommissionBaseAmntLCY += lvSalesInvoiceHeader.Amount
                                    ELSE
                                        lvCommissionBaseAmntLCY += ROUND(lvSalesInvoiceHeader.Amount / lvSalesInvoiceHeader."Currency Factor", 1)
                                UNTIL lvSalesInvoiceHeader.NEXT = 0
                        END;

                    lvCommissionRate.Base::"Receipts Collected":
                        BEGIN
                            lvEmployee.TESTFIELD(lvEmployee."Salespers./Purch. Code");

                            lvCustLedger.SETCURRENTKEY("Salesperson Code", "Posting Date");
                            lvCustLedger.SETRANGE("Salesperson Code", lvEmployee."Salespers./Purch. Code");
                            lvCustLedger.SETRANGE("Posting Date", lvPayrollPeriod."Start Date", lvPayrollPeriod."End Date");
                            lvCustLedger.SETRANGE("Document Type", lvCustLedger."Document Type"::Payment);

                            IF lvCustLedger.FINDFIRST THEN
                                REPEAT
                                    lvCustLedger.CALCFIELDS("Amount (LCY)");
                                    lvCommissionBaseAmntLCY -= lvCustLedger."Amount (LCY)";
                                UNTIL lvCustLedger.NEXT = 0
                        END;
                END;

                //Check Within Minimum Allowed Threshold
                IF lvCommissionBaseAmntLCY >= lvCommissionRate."Threshold Amount LCY" THEN
                    IF lvCommissionRate."Commission %" <> 0 THEN
                        lvCommissionAmountLCY := ROUND(lvCommissionBaseAmntLCY * lvCommissionRate."Commission %" / 100, 1)
                    ELSE
                        lvCommissionAmountLCY := lvCommissionRate."Commission Amount LCY";

                //Insert Commission Payroll Entry
                IF lvCommissionAmountLCY <> 0 THEN BEGIN
                    lvPayrollEntry.INIT;
                    lvPayrollEntry."Entry No." := lvNextPayrollEntryNo;
                    lvPayrollEntry.Date := gvPostingDate;
                    lvPayrollEntry."Payroll ID" := pPayrollHdr."Payroll ID";
                    lvPayrollEntry."Employee No." := pPayrollHdr."Employee no.";
                    lvPayrollEntry."Payroll Code" := pPayrollHdr."Payroll Code";
                    lvPayrollEntry.VALIDATE("ED Code", lvCommissionRate."ED Code");
                    lvPayrollEntry.VALIDATE(Amount, lvCommissionAmountLCY);
                    lvPayrollEntry.INSERT(TRUE);
                END
            UNTIL lvCommissionRate.NEXT = 0;
    end;

    procedure FlushTmp(var Header: Record 51159)
    var
        PayrollLines: Record 51160;
        PayslipEntryNo: Integer;
        NetamountLCY: Decimal;
        RoundAmount1: Decimal;
        PayrollSetupRec: Record 51165;
        EdDef: Record 51158;
        lvPayrollEntry: Record 51161;
        lvEntryNo: Integer;
    begin
        PayrollSetupRec.GET(Header."Payroll Code");
        NetamountLCY := 0;
        PayrollLines.SETRANGE("Payroll ID", Header."Payroll ID");
        PayrollLines.SETRANGE("Employee No.", Header."Employee no.");
        PayrollLines.DELETEALL(TRUE);

        PayrollLines.RESET;
        IF PayrollLines.FIND('+') THEN
            PayslipEntryNo := PayrollLines."Entry No."
        ELSE
            PayslipEntryNo := 0;

        IF PayrollLinesTmp.FIND('-') THEN BEGIN
            REPEAT
                PayslipEntryNo := PayslipEntryNo + 1;
                PayrollLines.COPY(PayrollLinesTmp);
                PayrollLines."Entry No." := PayslipEntryNo;
                PayrollLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                PayrollLines.INSERT;
                gvPayrollUtilities.sCopyDimsFromLineToLine(PayrollLinesTmp, PayrollLines);
            UNTIL PayrollLinesTmp.NEXT = 0;

            GetLumpSum(Header); //Compute Tax on Lump Sum Payments

            //Compute netpay after lump sum
            PayrollLines.RESET;
            PayrollLines.SETRANGE("Payroll ID", Header."Payroll ID");
            PayrollLines.SETRANGE("Employee No.", Header."Employee no.");
            IF PayrollLines.FIND('-') THEN
                REPEAT
                    IF PayrollLines."Calculation Group" = PayrollLines."Calculation Group"::Payments THEN
                        NetamountLCY += PayrollLines."Amount (LCY)";
                    IF PayrollLines."Calculation Group" = PayrollLines."Calculation Group"::Deduction THEN
                        NetamountLCY -= PayrollLines."Amount (LCY)";
                UNTIL PayrollLines.NEXT = 0;
            //End Compute netpay after lump sum

            //Insert Net Pay Rounding Carried Forward
            //IF PayrollSetupRec."Net Pay Rounding Precision" <> 0 THEN BEGIN//rgk added. No need to do the below if rounding not specified
            IF NetamountLCY > 0 THEN BEGIN
                IF PayrollSetupRec."Net Pay Rounding Precision" <> 0 THEN
                    RoundAmount1 := NetamountLCY MOD PayrollSetupRec."Net Pay Rounding Precision";

                IF (RoundAmount1 <> 0) AND (RoundAmount1 >= PayrollSetupRec."Net Pay Rounding Mid Amount") THEN
                    RoundAmount1 := PayrollSetupRec."Net Pay Rounding Precision" - RoundAmount1;

                IF RoundAmount1 <> 0 THEN BEGIN
                    PayrollLines.RESET;
                    IF PayrollLines.FIND('+') THEN
                        PayslipEntryNo := PayrollLines."Entry No."
                    ELSE
                        PayslipEntryNo := 0;

                    PayrollLines.INIT;
                    PayslipEntryNo := PayslipEntryNo + 1;


                    PayrollLines."Entry No." := PayslipEntryNo;
                    //rgk 18/01/2010 commented two lines below. Replaced them with the two after them.
                    //PayrollLines."Payroll ID" := PayrollHeader."Payroll ID";
                    //PayrollLines."Employee No." := PayrollHeader."Employee no.";
                    PayrollLines."Payroll ID" := Header."Payroll ID";
                    PayrollLines."Employee No." := Header."Employee no.";

                    PayrollLines."Posting Date" := gvPostingDate;

                    IF NetamountLCY MOD PayrollSetupRec."Net Pay Rounding Precision" >= PayrollSetupRec."Net Pay Rounding Mid Amount" THEN BEGIN
                        PayrollLines."ED Code" := PayrollSetupRec."Net Pay Rounding C/F (-ve)";
                        EdDef.GET(PayrollSetupRec."Net Pay Rounding C/F (-ve)");
                    END ELSE BEGIN
                        PayrollLines."ED Code" := PayrollSetupRec."Net Pay Rounding C/F";
                        EdDef.GET(PayrollSetupRec."Net Pay Rounding C/F");
                    END;

                    PayrollLines.Text := EdDef."Payroll Text";
                    PayrollLines.Amount := RoundAmount1;
                    PayrollLines."Amount (LCY)" := RoundAmount1;
                    PayrollLines."Calculation Group" := EdDef."Calculation Group";
                    PayrollLines."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    PayrollLines."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                    PayrollLines."Posting Group" := Employee."Posting Group";
                    PayrollLines.Rounding := EdDef."Rounding ED";
                    PayrollLines."Payroll Code" := gvAllowedPayrolls."Payroll Code";
                    PayrollLines.INSERT;
                    gvPayrollUtilities.sGetDefaultEDDims2(PayrollLines);
                END;
            END;
            /*
              //RGK Insert Rounding to Payroll Entry
               lvPayrollEntry.INIT;
               lvEntryNo += 1;
               lvPayrollEntry."Entry No." := lvEntryNo;
               lvPayrollEntry."Payroll ID" := Header."Payroll ID";
               lvPayrollEntry."Employee No." := Header."Employee no.";
               lvPayrollEntry.Date := gvPostingDate;
               //lvPayrollEntry.VALIDATE("ED Code", EdDef."Rounding ED");
               IF NetamountLCY MOD PayrollSetupRec."Net Pay Rounding Precision" >= PayrollSetupRec."Net Pay Rounding Mid Amount" THEN BEGIN
                 lvPayrollEntry.VALIDATE("ED Code",PayrollSetupRec."Net Pay Rounding C/F (-ve)");
                 EdDef.GET(PayrollSetupRec."Net Pay Rounding C/F (-ve)");
               END ELSE BEGIN
                 lvPayrollEntry.VALIDATE("ED Code",PayrollSetupRec."Net Pay Rounding C/F");
                 PayrollLines."ED Code" := PayrollSetupRec."Net Pay Rounding C/F";
                 EdDef.GET(PayrollSetupRec."Net Pay Rounding C/F");
               END;
               lvPayrollEntry.VALIDATE(Amount, RoundAmount1);
               lvPayrollEntry."Copy to next" := FALSE;
               lvPayrollEntry."Reset Amount" := FALSE;
               lvPayrollEntry.Editable := FALSE;
               lvPayrollEntry."Payroll Code" := gvAllowedPayrolls."Payroll Code";
               lvPayrollEntry.INSERT;
               //RGK End Insert
            */
            /*
              //RGK added this Compute netpay after rounding
              NetamountLCY:=0;
              PayrollLines.RESET;
              PayrollLines.SETRANGE("Payroll ID",Header."Payroll ID");
              PayrollLines.SETRANGE("Employee No.",Header."Employee no.");
              IF  PayrollLines.FIND('-') THEN
                REPEAT
                  IF PayrollLines."Calculation Group" = PayrollLines."Calculation Group"::Payments THEN
                    NetamountLCY += PayrollLines."Amount (LCY)";
                  IF PayrollLines."Calculation Group" = PayrollLines."Calculation Group"::Deduction THEN
                    NetamountLCY -= PayrollLines."Amount (LCY)";
                UNTIL PayrollLines.NEXT = 0;
              //RGK End Compute netpay after rounding

             END;//rgk added this line. No need to do the below if rounding not specified
            */

        END;

        PayrollLinesTmp.DELETEALL(TRUE); //skm060606 del any associated dims

    end;

    procedure LookUpEthiopia(var Header: Record 51159)
    var
        LookUpHeader: Record 51162;
        LookUpLine: Record 51163;
        Relief: Decimal;
    begin
        // CSM 10082010 Ethiopian Tax tables use a straight percentage for each tax bracket, no cumulation
        LookUpHeader.GET(SchemeControlTmp.LookUp);
        LookUpLine.SETRANGE("Table ID", SchemeControlTmp.LookUp);
        //V.6.1.65_10SEP10 >>
        IF NOT Flag THEN
            SchemeValueTmp.GET(LineNo, Scheme);
        Amount := SchemeValueTmp.Amount;
        "Amount (LCY)" := SchemeValueTmp."Amount (LCY)";

        CASE LookUpHeader.Type OF
            LookUpHeader.Type::Percentage:
                BEGIN
                    LookUpLine.FIND('-');
                    WHILE "Amount (LCY)" > LookUpLine."Upper Amount (LCY)" DO
                        LookUpLine.FIND('>');
                    Relief := LookUpLine."Relief Amount"; //070906 Ethiopian Tax modification
                    Percent := LookUpLine.Percent;
                    Amount1LCY := ("Amount (LCY)" * Percent / 100) - Relief;
                    CalculateAnnualTax(Header);//V.6.1.65_10SEP10 >>
                END;
            LookUpHeader.Type::"Extract Amount":
                BEGIN
                    LookUpLine.FIND('-');
                    WHILE NOT ("Amount (LCY)" <= LookUpLine."Upper Amount (LCY)") DO
                        LookUpLine.FIND('>');

                    Amount1LCY := LookUpLine."Extract Amount (LCY)";
                    CalculateAnnualTax(Header);//V.6.1.65_10SEP10 >>
                END;
            LookUpHeader.Type::Month:
                BEGIN
                    LookUpLine.FIND('-');
                    WHILE Header."Payroll Month" <> LookUpLine.Month DO
                        LookUpLine.FIND('>');
                    Amount1LCY := LookUpLine."Extract Amount (LCY)";
                    CalculateAnnualTax(Header);//V.6.1.65_10SEP10 >>
                END;
            LookUpHeader.Type::"Max Min":
                BEGIN
                    IF LookUpHeader."Min Extract Amount (LCY)" <> 0 THEN
                        IF "Amount (LCY)" < LookUpHeader."Min Extract Amount (LCY)" THEN
                            Amount1LCY := LookUpHeader."Min Extract Amount (LCY)";
                    IF LookUpHeader."Max Extract Amount (LCY)" <> 0 THEN
                        IF "Amount (LCY)" > LookUpHeader."Max Extract Amount (LCY)" THEN
                            Amount1LCY := LookUpHeader."Max Extract Amount (LCY)";
                    CalculateAnnualTax(Header);//V.6.1.65_10SEP10 >>
                END;
        END;
        SchemeValueTmp.GET(SchemeControlTmp."Compute To", Scheme);
        SchemeValueTmp.Amount := Amount1LCY;
        SchemeValueTmp."Amount (LCY)" := Amount1LCY;
        SchemeValueTmp.MODIFY;
    end;

    procedure "--- V.6.1.65 --"()
    begin
    end;

    procedure PersonalACRecoveries(var Header: Record 51159)
    var
        PayrollEntry: Record 51160;
        PayrollSetup: Record 51165;
        EDDefinitionTmp1: Record 51158;
        lvCust: Record 18;
    begin
        CLEAR(PayrollEntry);
        CLEAR(EDDefinitionTmp1);
        CLEAR(lvCust);
        IF Header."Employee no." <> '' THEN
            Emp.GET(Header."Employee no.");
        IF Emp."Customer No." <> '' THEN
            lvCust.GET(Emp."Customer No.");

        PayrollSetup.GET(Header."Payroll Code");
        IF PayrollEntry.FIND('+') THEN
            PayrollLinesTmp."Entry No." := PayrollEntry."Entry No." + 1
        ELSE
            PayrollLinesTmp."Entry No." := 1;

        /*skm20110314 Enforce complete setup
        IF PayrollSetup."Personal Account Recoveries ED" <> '' THEN
          EDDefinitionTmp1.GET(PayrollSetup."Personal Account Recoveries ED");
        */
        PayrollSetup.TESTFIELD("Personal Account Recoveries ED");
        EDDefinitionTmp1.GET(PayrollSetup."Personal Account Recoveries ED");
        //skm end

        PayrollLinesTmp."Payroll ID" := Period;
        PayrollLinesTmp."Employee No." := Header."Employee no.";
        //  PayrollLinesTmp."Currency Code" := lvCust."Currency Code";
        PayrollLinesTmp."Currency Code" := PayrollLinesTmp."Currency Code";
        PayrollLinesTmp."ED Code" := PayrollSetup."Personal Account Recoveries ED";
        PayrollLinesTmp."Posting Group" := Emp."Posting Group";
        PayrollLinesTmp."Calculation Group" := EDDefinitionTmp1."Calculation Group";
        PayrollLinesTmp.Text := EDDefinitionTmp1."Payroll Text";
        PayrollLinesTmp.Amount := OutStandingAmt;
        PayrollLinesTmp."Amount (LCY)" := OutStandingAmt;
        PayrollLinesTmp.INSERT;

    end;

    procedure CalculateAnnualTax(var Header: Record 51159)
    var
        lvPayrollHeader: Record 51159;
        LastPaidTaxAmt: Decimal;
    begin
        IF Flag THEN BEGIN
            LastPaidTaxAmt := 0;
            CLEAR(lvPayrollHeader);
            lvPayrollHeader.SETFILTER(lvPayrollHeader."Payroll Month", '%1..%2', 1, Header."Payroll Month" - 1);
            lvPayrollHeader.SETRANGE(lvPayrollHeader."Payroll Year", Header."Payroll Year");
            lvPayrollHeader.SETRANGE(lvPayrollHeader."Employee no.", Header."Employee no.");
            IF lvPayrollHeader.FINDSET THEN
                REPEAT
                    IF NOT SchemeControlTmp."Annualize Relief" THEN
                        LastPaidTaxAmt += lvPayrollHeader."L (LCY)"
                    ELSE
                        LastPaidTaxAmt += lvPayrollHeader."K (LCY)";
                UNTIL lvPayrollHeader.NEXT = 0;
            //  IF SchemeControlTmp."Annualize TAX" THEN
            // BeforeReliefAmt := gvPayrollHeader."J (LCY)";
            IF SchemeControlTmp."Annualize Relief" THEN BEGIN
                AnnualReliefAmt := Amount1LCY;
            END;
            Amount1LCY := Amount1LCY - LastPaidTaxAmt;
            IF SchemeControlTmp."Annualize Relief" THEN
                AnnualReliefAmt := AnnualReliefAmt - Amount1LCY;
        END;
    end;
}

